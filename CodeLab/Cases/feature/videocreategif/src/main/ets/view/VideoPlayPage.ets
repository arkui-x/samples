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

import { window, promptAction } from '@kit.ArkUI';
import { fileIo as fs } from '@kit.CoreFileKit';
import { media } from '@kit.MediaKit';
import { SelectGifTimeFrameView } from '../components/SelectGifTimeFrameView';
import { CacheListener, HttpProxyCacheServer, HttpProxyCacheServerBuilder } from '@ohos/video-cache';
import GlobalProxyServer from '../model/GlobalProxyServer';
import { GifCreateView } from '../components/GifCreateView';
import { getTimeString } from '../util/TimeTools';
import { logger } from '../util/Logger';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { CustomLoadingDialog } from '../components/CustomLoadingDialog';

const WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];

/**
 * 视频播放页面
 */
@AppRouter({ name: "videocreategif/VideoPlayPage", hasParam: true})
@Component
export struct VideoPlayPage {

  @State ratio: number = 1.0;                           // 视频宽高比
  @State isPlaying: boolean = false;                    // 是否播放状态
  @State currentTime: number = 0;                       // 当前播放时间
  @State totalDuration: number = 0;                     // 视频总时长
  @State isShowSelectGifTimeFrameView: boolean = false; // 是否显示选择gif时间段的组件
  @State isShowGifCreateView: boolean = false;          // 是否显示创建gif的组件
  @State videoPlayEvent: number = 0;                    // 启动视频播放事件

  private xComponentController: XComponentController = new XComponentController();
  private surfaceId: string = '';
  private avPlayer?: media.AVPlayer;
  private isCreate: boolean = false;        // 视频播放器是否被创建

  private srcFilePath: string = '';     // 视频文件路径
  private maxTime = 10;                 // 可截取视频的最大间隔，单位秒
  private minTime = 5;                  // 可截取视频的最小间隔，单位秒
  private startTime: number = 0;        // 可截取视频的起始时间，单位毫秒
  private endTime: number = 0;          // 可截取视频的结束时间，单位毫秒
  private currentStartTime: number = 0; // 当前选中的起始时间，单位毫秒
  private currentEndTime: number = 0;   // 当前选中的结束时间，单位毫秒
  private videoWidth: number = 1;       // 视频的宽度
  private videoHeight: number = 1;      // 视频的高度
  private url: string = '';             // 视频url

  private createGifStartTime: number = 0;    // 创建gif的视频开始时间，单位毫秒
  private createGifEndTime: number = 0;      // 创建gif的视频结束时间，单位毫秒
  private createGifSrc: string = '';         // 创建gif的视频文件路径

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomLoadingDialog({
      content: $r('app.string.video_create_gif_loading')
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    width: $r('app.integer.video_create_gif_dialog_width'),
    height: $r('app.integer.video_create_gif_dialog_width'),
    cornerRadius: $r('app.integer.video_create_gif_dialog_corner_radius')
  });

  build() {
    RelativeContainer() {
      // 视频播放区域
      Row() {
        XComponent({
          id: 'video_player_id',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
        .onLoad(async () => {
          this.surfaceId = this.xComponentController.getXComponentSurfaceId();
          this.avPlayer = await media.createAVPlayer();
          this.isCreate = true;
          this.setAVPlayerCallback(this.avPlayer);

          // 根据url的结构判断url是本地路径还是线上地址，线上地址会使用边缓存边播放的策略
          if (this.url.startsWith(getContext().filesDir)) {
            this.srcFilePath = this.url;
            let file = await fs.open(this.url);
            this.avPlayer.url = `fd://${file.fd}`;
          } else {
            let that = this;

            class MyCacheListener implements CacheListener {
              onCacheAvailable(cacheFilePath: string, url: string, percentsAvailable: number): void {
                AppStorage.setOrCreate('currentCachePercent', percentsAvailable);
                if (!that.srcFilePath) {
                  // 记录缓存文件的本地路径
                  that.srcFilePath = cacheFilePath;
                }
              }
            }

            GlobalProxyServer?.getInstance()?.getServer()?.registerCacheListener(new MyCacheListener(), this.url);

            let proxyUrl: string | undefined =
              await GlobalProxyServer?.getInstance()?.getServer()?.getProxyUrl(this.url);
            if (proxyUrl.startsWith(getContext().cacheDir)) {
              this.srcFilePath = proxyUrl;
              const file = fs.openSync(this.srcFilePath, fs.OpenMode.READ_ONLY);
              proxyUrl = `fd://${file.fd}`;
            }
            this.avPlayer.url = proxyUrl;
          }
        })
        .aspectRatio(this.ratio)
      }
      .width($r('app.string.video_create_gif_full_width'))
      .height($r('app.string.video_create_gif_full_width'))
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.Black)
      .alignRules({
        top: {anchor: "__container__", align: VerticalAlign.Top},
        left: {anchor: "__container__", align: HorizontalAlign.Start}
      })
      .id('video_x_component')
      .enabled(this.isPlaying)   // 这里设置enabled是为了在自动化测试中判断视频是否可以播放。移除设置enabled对功能无影响。

      // 返回按钮
      Image($r("app.media.video_create_gif_back"))
        .width($r('app.integer.video_create_gif_video_play_back_button_width'))
        .height($r('app.integer.video_create_gif_video_play_back_button_height'))
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .padding({
          left: $r('app.integer.video_create_gif_video_play_back_button_left_padding'),
          top: $r('app.integer.video_create_gif_video_play_back_button_top_and_bottom_padding'),
          bottom: $r('app.integer.video_create_gif_video_play_back_button_top_and_bottom_padding')
        })
        .margin({
          left: $r('app.integer.video_create_gif_video_play_back_button_left_margin')
        })
        .onClick(() => {
          DynamicsRouter.popAppRouter();
        })
        .id('video_play_back')

      Row() {
        // 播放按钮
        Image(this.isPlaying ? $r("app.media.video_create_gif_icon_play") :
                  $r("app.media.video_create_gif_icon_pause"))
          .width($r('app.integer.video_create_gif_icon_play_width'))
          .height($r('app.integer.video_create_gif_icon_play_width'))
          .margin({
            left: $r('app.integer.video_create_gif_icon_play_left_and_right_margin'),
            right: $r('app.integer.video_create_gif_icon_play_left_and_right_margin')
          })
          .onClick(() => {
            if (this.isPlaying) {
              this.avPlayer?.pause();
            } else {
              this.avPlayer?.play();
            }
            this.isPlaying = !this.isPlaying;
          })

        // 时间轴
        Row() {
          // 当前时间
          Text(getTimeString(this.currentTime))
            .fontSize($r('app.integer.video_create_gif_big_font_size'))
            .fontColor(Color.White)
            .fontWeight(500)
            .opacity(0.6)

          Slider({
            value: Math.round(this.currentTime / this.totalDuration * 100)
          })
            .selectedColor(Color.White)
            .layoutWeight(1)
            .trackColor(Color.Gray)
            .onChange((value: number) => {
              if (this.isCreate) {
                this.currentTime = this.totalDuration * value / 100;
                this.avPlayer?.seek(this.currentTime);
              }
            })

          // 总时长
          Text(getTimeString(this.totalDuration))
            .fontSize($r('app.integer.video_create_gif_big_font_size'))
            .fontColor(Color.White)
            .fontWeight(500)
            .opacity(0.6)
        }
        .layoutWeight(1)
        .height($r('app.integer.video_create_gif_duration_row_height'))
      }.alignRules({
        bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
        left: { anchor: "__container__", align: HorizontalAlign.Start }
      })
      .offset({
        y: $r('app.integer.video_create_gif_video_play_time_bar_bottom_margin')
      })
      .width($r('app.string.video_create_gif_full_width'))
      .padding({
        left: $r('app.integer.video_create_gif_video_play_time_bar_left_and_right_padding'),
        right: $r('app.integer.video_create_gif_video_play_time_bar_left_and_right_padding')
      }).visibility(!this.isShowSelectGifTimeFrameView ? Visibility.Visible : Visibility.Hidden)

      // 截取gif的按钮，当显示SelectGifTimeFrameView时该按钮隐藏
      if (!this.isShowSelectGifTimeFrameView) {
        Button("gif", { type: ButtonType.Normal})
          .fontSize($r('app.integer.video_create_gif_middle_font_size'))
          .fontColor(Color.White)
          .backgroundColor($r('app.color.video_create_gif_button_background_color'))
          .borderRadius($r('app.integer.video_create_gif_video_play_gif_button_border_radius'))
          .borderWidth($r('app.integer.video_create_gif_video_play_gif_button_border_width'))
          .borderColor(Color.White)
          .padding({
            left: $r('app.integer.video_create_gif_video_play_gif_button_left_and_right_padding'),
            right: $r('app.integer.video_create_gif_video_play_gif_button_left_and_right_padding'),
          })
          .height($r('app.integer.video_create_gif_video_play_gif_button_height'))
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .offset({
            x: $r('app.integer.video_create_gif_video_play_gif_button_right_margin'),
            y: 0
          })
          .onClick(() => {
            if (this.currentTime <= 0) {
              promptAction.showToast({
                message: $r('app.string.video_create_gif_action_gif_prompt')
              });

              return;
            }

            this.avPlayer?.pause();
            this.updateTruncateTime();
            this.isShowSelectGifTimeFrameView = true;
          })
      }

      // 选择gif时间段的组件
      if (this.isShowSelectGifTimeFrameView) {
        Row() {
          SelectGifTimeFrameView({
            srcFilePath: this.srcFilePath,
            maxTime: this.maxTime,
            minTime: this.minTime,
            startTime: this.startTime,
            endTime: this.endTime,
            currentStartTime: this.currentStartTime,
            currentEndTime: this.currentEndTime,
            videoWidth: this.videoWidth,
            videoHeight: this.videoHeight,
            back: () => {
              this.backFromSelectGifTimeFrameView();
            },
            startCreateGif: (startTime: number, endTime: number, src: string) => {
              this.createGifStartTime = startTime;
              this.createGifEndTime = endTime;
              this.createGifSrc = src;
              this.isShowGifCreateView = true;
            },
            playEvent: this.videoPlayEvent
          })
        }
        .width($r('app.string.video_create_gif_full_width'))
        .height($r('app.string.video_create_gif_full_width'))
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        }).visibility(this.isShowGifCreateView ? Visibility.Hidden : Visibility.Visible)
      }

      // 创建gif组件
      if (this.isShowGifCreateView) {
        GifCreateView({
          startTime: this.createGifStartTime,
          endTime: this.createGifEndTime,
          srcFilePath: this.createGifSrc,
          back: () => {
            this.backFromGifCreateView();
          }
        })
          .width($r('app.string.video_create_gif_full_width'))
          .height($r('app.string.video_create_gif_full_width'))
          .alignRules({
            top: {anchor: "__container__", align: VerticalAlign.Top},
            left: {anchor: "__container__", align: HorizontalAlign.Start}
          })
      }
    }
    .width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_full_width'))
  }

  aboutToAppear(): void {
    this.changeOrientation(true);

    this.url = DynamicsRouter.navPathStack.getParamByName("videocreategif/VideoPlayPage")[0] as string;

    // 初始化代理服务器
    if (!this.url.startsWith(getContext().filesDir)) {
      const server: HttpProxyCacheServer = new HttpProxyCacheServerBuilder(getContext()).build();
      GlobalProxyServer?.getInstance()?.setServer(server);
    }

    this.dialogController.open();
  }

  async aboutToDisappear(): Promise<void> {
    if (this.isCreate) {
      this.setOffCallback();
      await this.avPlayer?.stop();
      await this.avPlayer?.release();
      this.isCreate = false;
      this.isPlaying = false;
    }

    this.changeOrientation(false);
  }

  /**
   * 移除AVPlayer事件监听
   */
  setOffCallback(): void {
    if (this.avPlayer) {
      this.avPlayer?.off('timeUpdate');
      this.avPlayer?.off('videoSizeChange');
      this.avPlayer?.off('stateChange');
    }
  }

  /**
   * 更新截取的时间
   */
  private updateTruncateTime() {
    let playTime = Math.floor(this.currentTime / 1000) * 1000;

    // 当前播放时间向前10秒作为最小可截取到的时间，
    // 当前播放时间向后20秒作为最大可截取到的时间，
    // 当前播放时间到向后10秒作为当前选中的截取时间
    let prevTime = playTime - 10 * 1000;
    let nextTime = playTime + 20 * 1000;

    if (prevTime < 0) {
      prevTime = 0;
    }

    if (nextTime > this.avPlayer!.duration) {
      nextTime = this.avPlayer!.duration;
    }

    let currentPrevTime = playTime;
    if (this.currentTime ===  this.avPlayer!.duration) {
      currentPrevTime = this.avPlayer!.duration - 5 * 1000;
      if (currentPrevTime < 0) {
        currentPrevTime = 0;
      }
    }

    let currentNextTime = currentPrevTime + 10 * 1000;
    if (currentNextTime > this.avPlayer!.duration) {
      currentNextTime = this.avPlayer!.duration;
    }

    this.startTime = prevTime;
    this.endTime = nextTime;
    this.currentStartTime = currentPrevTime;
    this.currentEndTime = currentNextTime;
  }

  /**
   * 设置AVPlayer事件监听
   * @param avPlayer
   */
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    avPlayer.on('videoSizeChange', (width: number, height:number) => {
      this.videoWidth = width;
      this.videoHeight = height;
      this.ratio = width * (1.0) / height;
    })

    avPlayer.on('timeUpdate', (time:number) => {
      this.currentTime = time;
    })

    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle':
          logger.info('AVPlayer state idle called.');
          avPlayer.release();
          break;

        case 'initialized':
          logger.info('AVPlayer state initialized called.');
          avPlayer.surfaceId = this.surfaceId;
          avPlayer.prepare();
          break;

        case 'prepared':
          logger.info('AVPlayer state prepared called.');
          this.totalDuration = avPlayer.duration;
          avPlayer.play();
          this.isPlaying = true;
          this.dialogController.close();
          break;

        case 'playing':
          logger.info('AVPlayer state playing called.');
          break;

        case 'paused':
          logger.info('AVPlayer state paused called.');
          break;

        case 'completed':
          logger.info('AVPlayer state completed called.');
          break;

        case 'stopped':
          logger.info('AVPlayer state stopped called.');
          break;

        case 'released':
          logger.info('AVPlayer state released called.');
          break;

        default:
          logger.info('AVPlayer state unknown called.');
          break;
      }
    })
  }

  /**
   * 改变屏幕方向
   * @param isLandscape
   */
  changeOrientation(isLandscape: boolean) {
    // 获取UIAbility实例的上下文信息
    let context = getContext(this);
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      if (isLandscape) {
        // 设置窗口的布局是否为沉浸式布局
        lastWindow.setWindowLayoutFullScreen(true).then(() => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable([]);
          // 设置窗口的显示方向属性，AUTO_ROTATION_LANDSCAPE表示传感器自动横向旋转模式
          lastWindow.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
        });
      } else {
        // 取消窗口全屏
        lastWindow.setWindowLayoutFullScreen(false).then(() => {
          // 设置窗口的显示方向属性，UNSPECIFIED表示未定义方向模式，由系统判定
          lastWindow.setPreferredOrientation(window.Orientation.UNSPECIFIED, () => {
            // 设置窗口全屏模式时导航栏、状态栏的可见模式
            lastWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR);
          });
        })
      }
    });
  }

  /**
   * 从选取gif时间段界面返回
   */
  backFromSelectGifTimeFrameView() {
    this.isShowSelectGifTimeFrameView = false;
    this.avPlayer?.play();
  }

  /**
   * 从创建gif界面返回
   */
  backFromGifCreateView() {
    this.isShowGifCreateView = false;
    this.videoPlayEvent++;
  }

  /**
   * 返回键处理
   * @returns
   */
  onBackPress(): boolean | void {
    if (this.isShowGifCreateView) {
      this.backFromGifCreateView();

      return true;
    }

    if (this.isShowSelectGifTimeFrameView) {
      this.backFromSelectGifTimeFrameView();

      return true;
    }
  }
}