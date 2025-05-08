/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import window from '@ohos.window';
import {
  AvVideoPlayer,
  GlobalContext,
  IVideoPlayer,
  PlayerType,
  PlayStatus,
  StandardGSYVideoModel
} from '@ohos/gsyvideoplayer';
import emitter from '@ohos.events.emitter';
import settings from '@ohos.settings';
import {
  BaseDanmaku,
  BaseDanmakuParser,
  Callback,
  DANMAKU_STYLE_STROKEN,
  DanmakuContext,
  DanmakuTimer,
  DanmakuView,
  IDanmakus,
  IDanmakuView,
  JSONSource,
  OnDanmakuClickListener,
  Proxy,
  SpannedCacheStuffer,
  SystemClock
} from '@ohos/danmakuflamemaster';
import { SegmentButton, SegmentButtonOptions, SegmentButtonItemTuple } from '@kit.ArkUI';
import { DanmakuParser } from './DanmakuParser';
import { sourceData } from './DanmakuData';
import { logger } from 'utils';
import { Directions } from '../view/VideoView';
import { Constants } from '../common/Constants';

let updateProgressTimer: number = 0;
let changeWidth: number = 0;
let changeHeight: number = 0;
let uiTime: number = 0;
const SPEED_POPUP_LIST_SPACE: number = 20;
const PERCENT_LOW: string = '30%';
const PERCENT_MIDDLE: string = '60%';
const PERCENT_HIGH: string = '100%';
const videoPlayEvent: emitter.InnerEvent = {
  eventId: 1
};
const videoInitEvent: emitter.InnerEvent = {
  eventId: 2
};
const videoPauseEvent: emitter.InnerEvent = {
  eventId: 3
};

let touchStartX: number = 0;
let touchStartY: number = 0;

// 当前视频中心图标显示状态，包括播放、暂停、加载和隐藏
export enum CenterUiShowStatus { PLAY, PAUSE, LOADING };

@Component
export struct DanmakuVideoPlayer {
  iVideoPlayer: IVideoPlayer | undefined = undefined;
  @State settingsShow: boolean = false;
  @State @Watch('changeDanmukuHeight') danmukuHeightSelectedIndexes: number[] = [2];
  @State danmukuHeightCapsuleOptions: SegmentButtonOptions = SegmentButtonOptions.capsule({
    buttons: [{ text: PERCENT_LOW }, { text: PERCENT_MIDDLE }, { text: PERCENT_HIGH }] as SegmentButtonItemTuple,
    multiply: false,
    selectedBackgroundColor: $r('sys.color.ohos_id_color_text_secondary'),
    selectedFontColor: Color.Orange,
    fontColor: $r('sys.color.ohos_id_color_foreground_contrary'),
    fontSize: $r('app.string.danmaku_player_send_danmaku_fontsize'),
    selectedFontSize: $r('app.string.danmaku_player_send_danmaku_fontsize'),
    buttonPadding: { top: $r('app.integer.danmaku_player_buttonPadding_flex'), right: $r('app.integer.danmaku_player_buttonPadding_horizontal'), bottom: $r('app.integer.danmaku_player_buttonPadding_flex'), left: $r('app.integer.danmaku_player_buttonPadding_horizontal') },
    backgroundBlurStyle: BlurStyle.BACKGROUND_THICK
  });
  @Provide currentTime: string = '00:00';
  @Provide totalTime: string = '00:00';
  @State progressValue: number = 0;
  @State progressMaxValue: number = Constants.HUNDRED_PERCENT;
  @State fullShowTop: boolean = false; // 是否显示视频标题栏
  @State showBottomUi: boolean = false; // 是否显示底部装饰器
  @State fullShowLock: boolean = false; // 是否显示UI锁定控制按钮
  @State lock: boolean = false; // 是否锁定视频UI控制界面
  // 当前视频中心图标状态
  @State centerUiShowStatus: CenterUiShowStatus = CenterUiShowStatus.PLAY;
  @State isShowCenterUi: boolean = true;
  // 当前视频方向
  @Link curDirection: Directions;
  // 弹幕开关文本
  @State danmakuText: Resource = $r('app.string.danmaku_player_danmaku_toggle_text_show');
  // 是否显示亮度数值的布局
  @State showBrightnessUi: boolean = false;
  // 是否显示横向滑动的进度布局
  @State showSeekProgressUi: boolean = false;
  // 当前亮度 [0-255]
  @State currentBrightness: number = Constants.DEFAULT_BRIGHTNESS;
  // 拖拽的时间
  @State seekCurrentTime: string = this.currentTime;
  // 当前进度
  @State seekTimePosition: number = 0;
  @Link windowClass: window.Window | undefined;
  // 是否拖动进度条
  private isSeek: boolean = false;
  // 开始拖动进度条时是否正在播放
  private isPlaying: boolean = false;
  // 是否正在加载手势滑动禁止
  private isLoadNotSeek: boolean = false;
  // 当前拖拽进度的方向资源
  @State seekDirectionRes: Resource = $r('app.media.danmaku_player_video_forward_icon');
  private isVerticalDrag: boolean = false;
  private isHorizontalDrag: boolean = false;
  // 控制封面图显隐
  @State coverVisible: Visibility = Visibility.Visible;
  private panOptionBright: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Vertical
  });
  private panOptionSeek: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Horizontal
  });
  public title: string = '';
  private xComponentId: string = '';
  private danmakuShow: boolean = true;
  second: number = Constants.COUNT_DOWN_TIME;
  // 构建StandardGSYVideoModel对象
  public videoModel: StandardGSYVideoModel = new StandardGSYVideoModel();
  @State model: DanmakuView.Model = new DanmakuView.Model();
  private context: DanmakuContext | undefined = undefined;
  private parser: BaseDanmakuParser | undefined = undefined;
  private cacheStufferAdapter: Proxy = new Pro();
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X;
  controller: VideoController = new VideoController();
  private getDirection: ()=> number = () => { return 0};


  /*
   * TODO: 知识点：解析弹幕
   */
  private createParser(): BaseDanmakuParser {
    const parser: BaseDanmakuParser = new DanmakuParser();
    const jsonSource = new JSONSource(sourceData);
    parser.load(jsonSource);
    return parser;
  }

  /*
   * 初始化播放器
   */
  videoInit: (iVideoPlayer: IVideoPlayer, xid: string) => void = (iVideoPlayer: IVideoPlayer, xid: string) => {
    logger.info('VideoInit');
    this.iVideoPlayer = iVideoPlayer;
    this.xComponentId = xid;
    this.iVideoPlayer.setUp(this.videoModel.getUrl(), this.videoModel.getCacheWithPlay());
  }

  changeDanmukuHeight() {
    this.model.setHeight(vp2px(changeHeight - 1) * (this.danmukuHeightSelectedIndexes[0] + 1) / 3);
  }

  /*
   * TODO: 知识点：添加弹幕，设置该条弹幕的相关参数，示例中为定值
   */
  private addDanmaku(isLive: Boolean) {
    if (!this.context) {
      return;
    }
    let danmaku: BaseDanmaku = this.context.mDanmakuFactory.createDanmaku(BaseDanmaku.TYPE_SCROLL_RL);
    danmaku.text = '这是一条弹幕' + SystemClock.uptimeMillis();
    danmaku.padding = getContext(this).resourceManager.getNumber($r('app.integer.danmaku_player_danmaku_padding').id);
    danmaku.priority = 0; // 可能会被各种过滤器过滤并隐藏显示
    danmaku.isLive = isLive.valueOf();
    danmaku.setTime(this.model.getCurrentTime() +
    getContext(this).resourceManager.getNumber($r('app.integer.danmaku_player_time_range').id));
    if (this.parser) {
      danmaku.textSize =
        getContext(this).resourceManager.getNumber($r('app.integer.danmaku_player_new_danmaku_fontsize').id) *
          (this.parser.getDisplayer().getDensity() * 0.5);
    }
    danmaku.textColor = 0xffff0000;
    danmaku.textShadowColor = 0xffffffff;
    danmaku.borderColor = 0xff00ff00;
    this.model.addDanmaku(danmaku);
  }

  /*
   * 上侧返回装饰器
   */
  @Builder
  topTitle() {
    Row() {
      Image($r('app.media.danmaku_player_video_back'))
        .width($r('app.integer.danmaku_player_back_icon_width'))
        .height($r('app.integer.danmaku_player_back_icon_height'))
        .margin({
          top: $r('app.integer.danmaku_player_back_icon_margin_top'),
          left: $r('app.integer.danmaku_player_back_icon_margin_left')
        })
        .onClick(() => {
          this.videoModel.ExecuteBackClickListener();
        })
      Text(this.videoModel.getTitle())
        .fontSize($r('app.string.danmaku_player_video_title_fontsize'))
        .margin({
          top: $r('app.integer.danmaku_player_title_margin_top'),
          left: $r('app.integer.danmaku_player_title_margin_left')
        })
        .fontColor($r('app.color.danmaku_player_title_color'))
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .backgroundColor($r('app.color.danmaku_player_bottom_controls_color'))
    .width($r('app.string.danmaku_player_full_size'))
    .padding($r('app.integer.danmaku_player_top_title_padding'))
  }

  /*
   * 播放暂停控制装饰器
   */
  @Builder
  middleControls() {
    Row() {
      Row() {
        if (this.isShowCenterUi) {
          if (this.centerUiShowStatus === CenterUiShowStatus.PLAY) {
            Image($r('app.media.danmaku_player_video_play_pressed'))
              .width($r('app.integer.danmaku_player_play_icon_width'))
              .height($r('app.integer.danmaku_player_play_icon_width'))
              .onClick(() => {
                this.videoToPlay();
              })
          } else if (this.centerUiShowStatus === CenterUiShowStatus.PAUSE) {
            Image($r('app.media.danmaku_player_video_pause_normal'))
              .width($r('app.integer.danmaku_player_play_icon_width'))
              .height($r('app.integer.danmaku_player_play_icon_width'))
              .onClick(() => {
                this.videoToPause();
              })
          } else {
            Image($r('app.media.danmaku_player_icon_load'))
              .objectFit(ImageFit.Auto)
              .width($r('app.integer.danmaku_player_play_icon_width'))
              .height($r('app.integer.danmaku_player_play_icon_width'))
          }
        }
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .align(Alignment.BottomEnd)
      .width($r('app.string.danmaku_player_empty_width'))
      .height($r('app.string.danmaku_player_full_size'))

      Row() {
        if (this.curDirection === Directions.VERTICAL && this.fullShowLock) {
          Image(this.lock ? $r('app.media.danmaku_player_lock') : $r('app.media.danmaku_player_unlock'))
            .width($r('app.integer.danmaku_player_lock_icon_width'))
            .height($r('app.integer.danmaku_player_lock_icon_width'))
            .objectFit(ImageFit.Contain)
            .margin({
              right: $r('app.integer.danmaku_player_lock_margin')
            })
            .onClick(() => {
              this.lock = !this.lock;
              if (this.lock) {
                this.showBottomUi = false;
                this.fullShowTop = false;
                this.isShowCenterUi = false;
              } else {
                this.showBottomUi = true;
                this.fullShowTop = true;
                this.isShowCenterUi = true;
              }
            })
        }
      }
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
      .width($r('app.string.danmaku_player_empty_width'))
      .height($r('app.string.danmaku_player_full_size'))
    }
    .width($r('app.string.danmaku_player_full_size'))
    .height($r('app.string.danmaku_player_full_size'))
    .justifyContent(FlexAlign.End)
  }

  // 弹幕高度弹框
  @Builder
  settingPopup() {
    List({ space: SPEED_POPUP_LIST_SPACE }) {
      ListItem() {
        Column() {
          Text($r('app.string.danmaku_player_height'))
            .fontColor(Color.White)
            .fontSize($r('app.string.danmaku_player_send_danmaku_fontsize'))
            .margin({ left: $r('app.integer.danmaku_player_back_icon_margin_top'), top: $r('app.integer.danmaku_player_back_icon_margin_top') })
          SegmentButton({
            options: this.danmukuHeightCapsuleOptions,
            selectedIndexes: this.danmukuHeightSelectedIndexes
          })
            .margin({ left: $r('app.integer.danmaku_player_back_icon_margin_top'), right: $r('app.integer.danmaku_player_back_icon_margin_top'), top: $r('app.integer.danmaku_player_back_icon_margin_top') })
        }
        .justifyContent(FlexAlign.SpaceBetween)
      }
    }
    .width($r('app.string.danmaku_player_setting_popup_width'))
    .height(this.getDirection() === 1 ? $r('app.string.danmaku_player_setting_popup_big_height') : $r('app.string.danmaku_player_setting_popup_little_height'))
  }

  /*
   * 暂停播放
   */
  private videoToPause() {
    if (!this.iVideoPlayer) {
      return;
    }
    logger.info('standardGSYVideoPlayer onPause1 click');
    this.iVideoPlayer.pause();
    this.showBottomUi = true;
    this.fullShowTop = true;
    this.fullShowLock = true;
    this.timeCountdown();
  }

  /*
   * 开始播放
   */
  private videoToPlay() {
    if (!this.iVideoPlayer) {
      return;
    }
    logger.info('standardGSYVideoPlayer onPlay click');
    this.centerUiShowStatus = CenterUiShowStatus.LOADING;
    this.showBottomUi = true;
    this.fullShowTop = true;
    this.fullShowLock = true;
    this.timeCountdown();
    this.videoJudgeToPlay();
  }

  /*
   * 判断是否播放逻辑
   */
  private videoJudgeToPlay() {
    logger.info('videoJudgeToPlay');
    if (!this.iVideoPlayer) {
      return;
    }
    if (GlobalContext.getContext().getObject('xid') !== this.iVideoPlayer.xComponentId) {
      // 首次播放
      logger.info('videoJudgeToPlay1');
      this.iVideoPlayer.play();
      this.iVideoPlayer.firstOrSeek = true;
    } else {
      logger.info('videoJudgeToPlay2');
      if (this.iVideoPlayer.playStatus === PlayStatus.PAUSE) {
        // 暂停后重新播放
        logger.info('standardGSYVideoPlayer videoJudgeToPlay ResumePlay');
        if (this.isSeek) {
          this.iVideoPlayer.seekTo(this.progressValue);
        } else {
          this.model.resume();
          logger.info('this.model.resume');
          this.iVideoPlayer.resumePlay();
        }
      } else {
        // 播放完成后重新播放
        logger.info('standardGSYVideoPlayer videoJudgeToPlay play: ' + this.iVideoPlayer.videoUrl);
        if (this.isSeek) {
          this.iVideoPlayer.seekTo(this.progressValue);
        } else {
          this.iVideoPlayer.play();
        }
      }
    }
  }

  /*
   * 底部装饰器：包括进度条、全屏按钮、发送弹幕按钮、弹幕开关
   */
  @Builder
  bottomControls() {
    Column() {
      Row() {
        Text(this.currentTime)
          .fontSize($r('app.string.danmaku_player_total_time_fontsize'))
          .margin({
            left: $r('app.integer.danmaku_player_time_margin')
          })
          .fontColor($r('app.color.danmaku_player_time_color'))

        Slider({
          value: this.progressValue,
          min: 0,
          max: this.progressMaxValue,
          step: 1,
          style: SliderStyle.OutSet
        })
          .width(this.curDirection === Directions.VERTICAL ?
          $r('app.string.danmaku_player_slider_length_vertical') :
          $r('app.string.danmaku_player_slider_length_horizontal'))
          .blockColor(Color.Blue)
          .trackColor(Color.White)
          .selectedColor(Color.Blue)
          .showSteps(true)
          .onChange((value: number, mode: SliderChangeMode) => {
            clearInterval(uiTime);
            if (!this.iVideoPlayer) {
              return;
            }
            switch (mode) {
              case SliderChangeMode.Begin:
                // 暂停通知的回调会到的慢一点，使用isSeek参数去控制pause通知里面的状态操作
                this.stopProgressTask();
                this.isSeek = true;
                if (this.centerUiShowStatus === CenterUiShowStatus.PAUSE) {
                  this.isPlaying = true;
                } else {
                  this.isPlaying = false;
                }
                this.iVideoPlayer.pause();
                break;
              case SliderChangeMode.Moving:
                this.currentTime = this.stringForTime(value);
                break;
              case SliderChangeMode.End:
                // 没有改变进度时，设置isSeek为false
                if (this.progressValue === value) {
                  this.isSeek = false;
                }
                this.progressValue = value;
                if (this.isPlaying) {
                  this.centerUiShowStatus = CenterUiShowStatus.LOADING;
                  this.iVideoPlayer.seekTo(value);
                }
                logger.info('slider-->seekValue end: ' + value);
                break;
            }
          })
        Text(this.totalTime)
          .fontSize($r('app.string.danmaku_player_total_time_fontsize'))
          .margin({
            right: $r('app.integer.danmaku_player_total_time_right_margin')
          })
          .fontColor($r('app.color.danmaku_player_time_color'))

        Image(this.curDirection === Directions.VERTICAL ? $r('app.media.danmaku_player_video_shrink') :
        $r('app.media.danmaku_player_video_enlarge'))
          .width($r('app.integer.danmaku_player_enlarge_icon_width'))
          .height($r('app.integer.danmaku_player_enlarge_icon_width'))
          .margin({
            right: $r('app.integer.danmaku_player_enlarge_icon_margin')
          })
          .onClick(() => {
            this.timeCountdown();
            if (this.curDirection === Directions.VERTICAL) {
              this.videoModel.ExecuteBackClickListener();
            } else {
              this.videoModel.ExecuteFullClickListener();
            }
          })
      }
      .width($r('app.string.danmaku_player_full_size'))
      .backgroundColor($r('app.color.danmaku_player_bottom_controls_color'))

      Row() {
        Text($r('app.string.danmaku_player_send_danmu'))
          .backgroundColor($r('app.color.danmaku_player_color_add_danmaku'))
          .width($r('app.string.danmaku_player_send_danmaku_width'))
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.danmaku_player_color_add_text_danmaku'))
          .borderRadius($r('app.string.danmaku_player_send_danmaku_border_radius'))
          .onClick(() => {
            this.timeCountdown();
            this.addDanmaku(false);
          })
          .layoutWeight(1)
          .fontSize($r('app.string.danmaku_player_send_danmaku_fontsize'))
          .margin($r('app.string.danmaku_player_send_danmaku_margin'))

        Text(this.danmakuText)
          .textAlign(TextAlign.Center)
          .fontColor($r('app.color.danmaku_player_color_show_danmaku'))
          .fontSize($r('app.string.danmaku_player_send_danmaku_fontsize'))
        Toggle({
          type: ToggleType.Switch,
          isOn: this.danmakuShow
        })
          .size({
            width: $r('app.string.danmaku_player_toggle_width'),
            height: $r('app.string.danmaku_player_toggle_height')
          })
          .selectedColor($r('app.color.danmaku_player_toggle_color'))
          .switchPointColor($r('app.color.danmaku_player_switchPoint_color'))
          .onChange((isOn: boolean) => {
            this.timeCountdown();
            if (!isOn) {
              this.model.hide();
              this.danmakuText = $r('app.string.danmaku_player_danmaku_toggle_text_hide');
            } else {
              this.model.setWidth(vp2px(changeWidth));
              this.model.setHeight(vp2px(changeHeight - 1) * (this.danmukuHeightSelectedIndexes[0] + 1) / 3);
              this.model.hide();
              this.model.show();
              this.danmakuText = $r('app.string.danmaku_player_danmaku_toggle_text_show');
            }
            this.danmakuShow = !this.danmakuShow;
          })
        Image($r('app.media.danmaku_player_gearshape'))
          .fillColor(Color.White)
          .width($r('app.integer.danmaku_player_lock_icon_width'))
          .height($r('app.integer.danmaku_player_lock_icon_width'))
          .onClick(() => {
            this.timeCountdown();
            this.settingsShow = !this.settingsShow;
          })
          .bindPopup(this.settingsShow, {
            enableArrow: false,
            radius: $r('app.integer.danmaku_player_current_brightness'),
            builder: this.settingPopup(),
            placement: Placement.Top,
            popupColor: $r('app.string.danmaku_player_popup_color'),
            backgroundBlurStyle: BlurStyle.NONE,
            onStateChange: (e) => {
              this.timeCountdown();
              this.settingsShow = e.isVisible;
            }
          })
      }
      .backgroundColor($r('app.color.danmaku_player_bottom_controls_color'))
      // 横屏时避让设备边缘
      .padding({
        bottom: this.curDirection === Directions.VERTICAL ? $r('app.integer.danmaku_player_send_danmu_padding') : 0,
        left: this.curDirection === Directions.VERTICAL ? $r('app.integer.danmaku_player_send_danmu_padding') : 0,
        right: this.curDirection === Directions.VERTICAL ? $r('app.integer.danmaku_player_send_danmu_padding') : 0,
      })
    }
  }

  /*
   * 亮度调节控件
   */
  @Builder
  brightnessUI() {
    Column() {
      Image($r('app.media.danmaku_player_video_brightness_6_white_36dp'))
        .objectFit(ImageFit.Auto)
        .width($r('app.integer.danmaku_player_brightness_icon_width'))
        .height($r('app.integer.danmaku_player_brightness_icon_height'))
        .alignSelf(ItemAlign.Center)

      Text((this.currentBrightness / Constants.MAX_BRIGHTNESS * Constants.HUNDRED_PERCENT).toFixed(0) + '%')
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .width($r('app.integer.danmaku_player_brightness_text_width'))
    }
    .visibility(this.showBrightnessUi ? Visibility.Visible : Visibility.None)
    .width($r('app.integer.danmaku_player_brightness_UI_width'))
    .height($r('app.string.danmaku_player_full_size'))
    .justifyContent(FlexAlign.Center)
    .position({ right: $r('app.string.danmaku_player_brightness_position_right') })
  }

  /*
   * 进度条控件
   */
  @Builder
  seekProgressUI() {
    Column() {
      Image(this.seekDirectionRes)
        .objectFit(ImageFit.Auto)
        .width($r('app.integer.danmaku_player_seek_icon_width'))
        .height($r('app.integer.danmaku_player_seek_icon_height'))
        .margin({
          top: $r('app.integer.danmaku_player_seek_progress_margin_top')
        })
        .alignSelf(ItemAlign.Center)

      Row() {
        Text(`${this.seekCurrentTime}/${this.totalTime}`)
      }
      .margin({
        top: $r('app.integer.danmaku_player_seek_progress_margin_top')
      })

      Progress({
        value: this.seekTimePosition,
        total: this.progressMaxValue ? this.progressMaxValue :
        getContext(this).resourceManager.getNumber($r('app.integer.danmaku_player_progress_total').id),
        type: ProgressType.Linear
      })
        .style({
          strokeWidth: $r('app.integer.danmaku_player_progress_stroke_width'),
          enableSmoothEffect: false
        })
        .padding({
          left: $r('app.integer.danmaku_player_seek_padding_Left'),
          right: $r('app.integer.danmaku_player_seek_padding_right')
        })
        .margin({
          top: $r('app.integer.danmaku_player_seek_margin_top'),
          bottom: $r('app.integer.danmaku_player_seek_margin_bottom')
        })
        .backgroundColor(Color.White);
    }
    .visibility(this.showSeekProgressUi ? Visibility.Visible : Visibility.Hidden)
    .width($r('app.integer.danmaku_player_seek_progress_width'))
    .backgroundColor($r('app.color.danmaku_player_seek_to_dialog_background'))
    .alignItems(HorizontalAlign.Center)
    .alignSelf(ItemAlign.Center)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      // 使用gsyvideoplayer库中的AvVideoPlayer播放器
      AvVideoPlayer({
        videoInit: this.videoInit
      })

      Row() {
        this.seekProgressUI()
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .width($r('app.string.danmaku_player_full_size'))
      .height($r('app.string.danmaku_player_full_size'))

      this.brightnessUI()

      DanmakuView({
        model: this.model
      })
        .backgroundColor(Color.Transparent)
        .position({
          x: 0,
          y: 0
        })
        .enabled(false);

      Stack() {
        if (this.videoModel.getCoverImage() && this.coverVisible === Visibility.Visible) {
          Image(this.videoModel.getCoverImage())
            .width($r('app.string.danmaku_player_full_size'))
            .height($r('app.string.danmaku_player_full_size'))
        }
      }

      this.middleControls()

      Stack() {
        if (this.curDirection === Directions.VERTICAL && this.fullShowTop) {
          this.topTitle()
        }
      }
      .position({
        x: 0,
        y: 0
      })

      Stack() {
        if (this.showBottomUi) {
          this.bottomControls()
        }
      }
    }
    .gesture(
      GestureGroup(GestureMode.Parallel,
        // 单击播放区域控制UI显示
        TapGesture()
          .onAction((event: GestureEvent | undefined) => {
            if (event) {
              this.timeCountdown();
              this.fullShowLock = true;
              if (!this.lock) {
                this.showBottomUi = true;
                this.fullShowTop = true;
                this.isShowCenterUi = true;
              }
              if (event && event.fingerList && event.fingerList[0]) {
                logger.info('TapGesture event.onActionStart start x: ' + event.fingerList[0].localX +
                  ' ---event.onActionStart start y: ' + event.fingerList[0].localY);
              }
            }
          }),
        /*
         * 绑定屏幕亮度拖动手势
         */
        PanGesture(this.panOptionBright)
          .onActionStart((event: GestureEvent | undefined) => {
            logger.info('Vertical Pan Start');
            if (this.lock || this.isHorizontalDrag) {
              return;
            }
            if (event && event.fingerList && event.fingerList[0]) {
              touchStartX = event.fingerList[0].localX;
              touchStartY = event.fingerList[0].localY;
              logger.info('VerticalPanBright event.onActionStart start x: ' + touchStartX +
                ' event.onActionStart start y: ' + touchStartY);
            }
          })
          .onActionUpdate((event: GestureEvent | undefined) => {
            if (this.lock || this.isHorizontalDrag) {
              return;
            }
            this.isVerticalDrag = true;
            if (event && event.fingerList && event.fingerList[0]) {
              const touchY = event.fingerList[0].localY;
              const deltaY = touchY - touchStartY;
              // 移动距离占播放器高度的比例(deltaY取反是因为值的正负与滑动方向相反)
              const percent = (-deltaY / changeHeight);
              const width = changeWidth as number;
              if (touchStartX <= (width / 2)) {
                this.showBrightnessUi = true;
                let brightness = this.currentBrightness;
                brightness += Constants.MAX_BRIGHTNESS * percent;
                if (brightness < 0) {
                  brightness = 0;
                }
                if (brightness > Constants.MAX_BRIGHTNESS) {
                  brightness = Constants.MAX_BRIGHTNESS;
                }
                const finalValue = brightness / Constants.MAX_BRIGHTNESS;
                if (this.windowClass) {
                  this.windowClass.setWindowBrightness(finalValue);
                }
                this.currentBrightness = brightness;
              }
              touchStartY = touchY;
            }
          })
          .onActionEnd((event: GestureEvent | undefined) => {
            logger.info('Vertical Pan End');
            this.showBrightnessUi = false;
            this.isVerticalDrag = false;
          }),
        PanGesture(this.panOptionSeek)
          .onActionStart((event: GestureEvent | undefined) => {
            logger.info('Horizontal Pan Start');
            if (!this.iVideoPlayer || this.lock || this.coverVisible === Visibility.Visible) {
              return;
            }
            if (this.centerUiShowStatus === CenterUiShowStatus.LOADING) {
              this.isLoadNotSeek = true;
              return;
            }
            if (this.isVerticalDrag) {
              return;
            }
            if (event && event.fingerList && event.fingerList[0]) {
              this.stopProgressTask();
              this.isSeek = true;
              if (this.centerUiShowStatus === CenterUiShowStatus.PAUSE) {
                this.isPlaying = true;
              } else {
                this.isPlaying = false;
              }
              this.iVideoPlayer.pause();
              touchStartX = event.fingerList[0].localX;
              this.seekTimePosition = this.progressValue;
              logger.info('HorizontalSeekProgress event.onActionStart start x: ' + event.fingerList[0].localX +
                ' event.onActionStart start y: ' + event.fingerList[0].localY);
            }
          })
          .onActionUpdate((event: GestureEvent | undefined) => {
            if (!this.iVideoPlayer || this.lock || this.isLoadNotSeek || this.isVerticalDrag ||
              this.coverVisible === Visibility.Visible) {
              return;
            }
            this.isHorizontalDrag = true;
            if (event && event.fingerList && event.fingerList[0]) {
              this.showSeekProgressUi = true;
              const touchX = event.fingerList[0].localX;
              const deltaX = touchX - touchStartX;
              if (deltaX > 0) {
                this.seekDirectionRes = $r('app.media.danmaku_player_video_forward_icon');
              } else {
                this.seekDirectionRes = $r('app.media.danmaku_player_video_backward_icon');
              }
              let seekTimePosition: number =
                Number((this.progressValue + (deltaX * this.progressMaxValue / changeWidth)).toFixed(0));
              if (seekTimePosition < 0) {
                seekTimePosition = 0;
              }
              if (seekTimePosition > this.progressMaxValue) {
                seekTimePosition = this.progressMaxValue;
              }
              // 当前调整的进度
              this.seekCurrentTime = this.stringForTime(seekTimePosition);
              // 设置当前进度
              if (this.progressMaxValue !== 0) {
                this.seekTimePosition = seekTimePosition;
              }
            }
          })
          .onActionEnd((event: GestureEvent | undefined) => {
            if (!this.iVideoPlayer || this.coverVisible === Visibility.Visible) {
              return;
            }
            if (this.isLoadNotSeek) {
              this.isLoadNotSeek = false;
              return;
            }
            if (this.isHorizontalDrag && this.iVideoPlayer) {
              if (this.progressValue === this.seekTimePosition) {
                this.isSeek = false;
                return;
              }
              this.progressValue = this.seekTimePosition;
              this.currentTime = this.stringForTime(this.progressValue);
              if (this.isPlaying) {
                this.centerUiShowStatus = CenterUiShowStatus.LOADING;
                this.iVideoPlayer.seekTo(this.seekTimePosition);
              }
            }
            this.isHorizontalDrag = false;
            this.showSeekProgressUi = false;
          }),
        // 双击播放或暂停
        TapGesture({ count: 2 })
          .onAction((event: GestureEvent | undefined) => {
            if (this.lock || this.centerUiShowStatus === CenterUiShowStatus.LOADING || !this.iVideoPlayer) {
              return;
            }
            if (this.iVideoPlayer.xComponentId !== GlobalContext.getContext().getObject('xid')) {
              this.videoToPlay();
            } else {
              if (this.iVideoPlayer.isPlaying()) {
                this.videoToPause();
              } else {
                this.videoToPlay();
              }
            }
          })
      ))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (newValue.width !== oldValue.width || newValue.height !== oldValue.height) {
        changeWidth = newValue.width as number;
        changeHeight = newValue.height as number;
        // 全屏时显示上方标题栏和锁定按钮
        if (this.curDirection === Directions.VERTICAL) {
          this.fullShowTop = true;
          this.fullShowLock = true;
          this.timeCountdown();
        }
        this.model.setWidth(vp2px(changeWidth));
        this.model.setHeight(vp2px(changeHeight) * (this.danmukuHeightSelectedIndexes[0] + 1) / 3);
        if (this.danmakuShow) {
          setTimeout(() => {
            if (!this.iVideoPlayer?.isPlaying()) {
              this.model.hide();
            }
            this.model.show();
          }, Constants.DANMU_RESIZE_TIME)
        }
      }
    })
    .backgroundColor(Color.Black)
  }

  /*
   * 注册的emitter消息回调，在list列表中，每个item都可以收到，只能通过xid区分当前是哪个才是真正的被点击的item
   * 去做相应的事件处理，不是当前选中的，一律变为初始状态（goInit）
   */
  private emitterInit() {
    emitter.on(videoPlayEvent, (data: emitter.EventData) => {
      if (data && data.data && typeof data.data.xid === 'string') {
        if (this.xComponentId === data.data.xid) {
          this.goPlaying();
        }
      }
    });
    emitter.on(videoInitEvent, (data: emitter.EventData) => {
      if (data && data.data && typeof data.data.xid === 'string') {
        if (this.xComponentId === data.data.xid) {
          this.goInit();
        }
      }
    });
    emitter.on(videoPauseEvent, (data: emitter.EventData) => {
      if (data && data.data && typeof data.data.xid === 'string') {
        if (this.xComponentId === data.data.xid) {
          if (GlobalContext.getContext().getObject('playType') === PlayerType.SYSTEM_AVPLAYER) {
            if (this.iVideoPlayer && this.iVideoPlayer.isPlaying()) {
              this.goPause();
            }
          } else {
            this.goPause();
          }
        }
      }
    })
  }

  /*
   * 监听播放
   */
  private goPlaying() {
    logger.info('standardGSYVideoPlayer onPlayingListener');
    this.coverVisible = Visibility.None;
    this.centerUiShowStatus = CenterUiShowStatus.PAUSE;
    this.timeCountdown();
    if (!this.iVideoPlayer) {
      return;
    }
    if (this.danmakuShow) {
      this.model.show();
    }
    if (this.isSeek) {
      this.model.seekTo(this.progressValue);
      this.isSeek = false;
    } else {
      // 视频从头开始播放时，重置弹幕到开始位置
      if (this.progressValue === 0) {
        this.model.seekTo(0);
      }
    }
    this.progressMaxValue = this.iVideoPlayer.getDuration();
    this.totalTime = this.stringForTime(this.progressMaxValue);
    this.stopProgressTask();
    this.startProgressTask();
    logger.info('standardGSYVideoPlayer onPlayingListener end.' + this.progressMaxValue);
  }

  /*
   * 监听初始化
   */
  private goInit() {
    logger.info('standardGSYVideoPlayer play finished');
    if (this.iVideoPlayer && GlobalContext.getContext().getObject('playType') === PlayerType.SYSTEM_AVPLAYER) {
      logger.info('PlayerType.SYSTEM_AVPLAYER need to stop');
      this.iVideoPlayer.stop();
    }
    this.model.pause();
    this.stopProgressTask();
    this.progressValue = this.progressMaxValue;
    this.currentTime = this.stringForTime(this.progressValue);
    setTimeout(() => {
      this.coverVisible = Visibility.Visible;
      this.centerUiShowStatus = CenterUiShowStatus.PLAY;
      this.isShowCenterUi = true;
      this.showBottomUi = false;
      this.fullShowTop = false;
      this.fullShowLock = false;
      this.progressValue = 0;
      this.currentTime = '00:00';
      this.lock = false;
    }, 0)
  }

  /*
   * 监听暂停
   */
  private goPause() {
    logger.info('standardGSYVideoPlayer onPauseListener');
    this.stopProgressTask();
    if (!this.isSeek) {
      this.centerUiShowStatus = CenterUiShowStatus.PLAY;
    }
    this.model.pause();
  }

  aboutToAppear() {
    this.emitterInit();
    this.currentBrightness =
      Number(settings.getValueSync(getContext(this), settings.display.SCREEN_BRIGHTNESS_STATUS,
        Constants.DEFAULT_BRIGHTNESS.toString()));
    setTimeout(() => {
      this.danmakuInit();
    }, 0)

  }

  /*
   * TODO: 知识点：初始化弹幕，设置弹幕相关参数
   */
  danmakuInit() {
    const maxLinesPair: Map<number, number> = new Map();
    // 滚动弹幕最大显示5行
    maxLinesPair.set(BaseDanmaku.TYPE_SCROLL_RL, Constants.MAX_DANMAKU_LINES);
    // 设置是否禁止重叠
    const overlappingEnablePair: Map<number, boolean> = new Map();
    overlappingEnablePair.set(BaseDanmaku.TYPE_SCROLL_RL, true);
    overlappingEnablePair.set(BaseDanmaku.TYPE_FIX_TOP, true);
    this.context = DanmakuContext.create();
    const danmakuStyle = Constants.DANMAKU_STYLE;
    this.context.setDanmakuStyle(DANMAKU_STYLE_STROKEN, danmakuStyle); // 设置描边样式
    this.context.setDuplicateMergingEnabled(false); // 设置是否启用合并重复弹幕
    this.context.setScrollSpeedFactor(Constants.DANMAKU_SCROLL_SPEED); // 设置滚动弹幕速率
    this.context.setScaleTextSize(Constants.DANMAKU_SCALE_TEXT_SIZE); // 设置缩放字体大小
    this.context.setCacheStuffer(new SpannedCacheStuffer(), this.cacheStufferAdapter); // 设置弹幕缓存填充器
    this.context.setMaximumLines(maxLinesPair).preventOverlapping(overlappingEnablePair); // 设置最大弹幕显示行数
    this.context.setDanmakuMargin(Constants.DANMAKU_MARGIN); // 设置弹幕显示外边距
    if (this.model === null) {
      return;
    }
    this.parser = this.createParser();
    this.model.setCallback(new Call(this));
    this.model.setOnDanmakuClickListener(new OnDanMaku(this));
    this.model.prepare(this.parser, this.context);
    this.model.showFPS(false);
  }

  aboutToDisappear() {
    logger.info('standardGSYVideoPlayer aboutToDisappear');
    this.emitterOff();
    this.stop();
    this.model.stop();
    this.model.release();
  }

  /*
   * 关闭事件监听
   */
  private emitterOff() {
    emitter.off(1);
    emitter.off(2);
    emitter.off(3);
  }

  /*
   * 停止播放
   */
  stop() {
    logger.info('standardGSYVideoPlayer stop');
    this.stopProgressTask();
    clearInterval(uiTime);
    if (!this.iVideoPlayer) {
      return;
    }
    this.iVideoPlayer.stop();
    this.iVideoPlayer.release();
  }

  /*
   * 时间格式化
   */
  private completionNum(num: number): string | number {
    if (num < getContext(this).resourceManager.getNumber($r('app.integer.danmaku_player_completion_time'))) {
      return '0' + num;
    } else {
      return num;
    }
  }

  /*
   * 获取时间字符串
   */
  private stringForTime(timeMs: number): string {
    const totalSeconds: number = Math.floor(timeMs / Constants.MS_IN_SECOND);
    let seconds: number = totalSeconds % Constants.SECOND_IN_MINUTE;
    let minutes: number = Math.floor((totalSeconds / Constants.SECOND_IN_MINUTE) % Constants.MINUTE_IN_HOUR);
    let hours: number = Math.floor(totalSeconds / Constants.SECOND_IN_HOUR);

    if (hours > 0) {
      return this.completionNum(hours) + ':' + this.completionNum(minutes) + ':' + this.completionNum(seconds);
    } else {
      return this.completionNum(minutes) + ':' + this.completionNum(seconds);
    }
  }

  private stopProgressTask() {
    clearInterval(updateProgressTimer);
  }

  private startProgressTask() {
    updateProgressTimer = setInterval(() => {
      this.setProgress();
    }, Constants.MS_IN_SECOND);
  }

  /*
   * 设置进度
   */
  private setProgress() {
    if (!this.iVideoPlayer) {
      return;
    }
    this.progressValue = this.iVideoPlayer.getCurrentPosition();
    this.currentTime = this.stringForTime(this.progressValue);
  }

  /*
   * 时间倒数
   */
  private timeCountdown() {
    clearInterval(uiTime);
    this.second = Constants.COUNT_DOWN_TIME;
    uiTime = setInterval(() => {
      if (this.second <= 0) {
        clearInterval(uiTime);
        this.showBottomUi = false;
        this.fullShowLock = false;
        this.fullShowTop = false;
        if (this.centerUiShowStatus === CenterUiShowStatus.PAUSE) {
          this.isShowCenterUi = false;
        }
      } else {
        this.second--;
      }
    }, Constants.MS_IN_SECOND);
  }
}

class Call implements Callback {
  private that: ESObject;

  constructor(that: ESObject) {
    this.that = that;
  }

  public updateTimer(timer: DanmakuTimer): void {
  }

  public drawingFinished(): void {

  }

  public danmakuShown(danmaku: BaseDanmaku): void {
  }

  public prepared(): void {
  }
}

class OnDanMaku implements OnDanmakuClickListener {
  private that: ESObject;

  constructor(that: ESObject) {
    this.that = that;
  }

  /*
   * 弹幕点击逻辑
   */
  onDanmakuClick(danmakus: IDanmakus): boolean {
    console.log('DFM onDanmakuClick: danmakus size:' + danmakus.size());
    const latest: BaseDanmaku = danmakus.last();
    if (null !== latest) {
      console.log('DFM onDanmakuClick: text of latest danmaku:' + latest.text);
      return true;
    }
    return false;
  };

  /*
   * 弹幕长按逻辑
   */
  onDanmakuLongClick(danmakus: IDanmakus): boolean {
    return false;
  };

  /*
   * 点击视窗逻辑
   */
  onViewClick(view: IDanmakuView): boolean {
    this.that.isVisible = true;
    return false;
  };
}

class Pro extends Proxy {
  public prepareDrawing(danmaku: BaseDanmaku, fromWorkerThread: boolean): void {
  }

  public releaseResource(danmaku: BaseDanmaku): void {

    // TODO：知识点：重要:清理含有ImageSpan的text中的一些占用内存的资源 例如drawable
  }
}