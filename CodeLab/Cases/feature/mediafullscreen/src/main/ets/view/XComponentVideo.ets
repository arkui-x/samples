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

import media from '@ohos.multimedia.media';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { getTimeString } from '../util/TimeTools';
import { logger } from '../util/Logger';

const WINDOW_SYSTEM_BAR: Array<'status' | 'navigation'> = ['navigation', 'status'];
const ASPECT_RATIO: number = 1.77777778; // 元素宽高比
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const VIDEO_Z_INDEX: number = 100; // 组件zIndex
const ANIMATE_DURATION: number = 400; // 动画持续时间
const TIMEOUT_DURATION: number = 200; // 计时器时间
const SPEED_POPUP_LIST_SPACE: number = 20;
const TAG: string = '[XVideoComponent] ';
// 倍速对象
interface speedObj {
  text: string,
  value: number
};

class AVPlayerConstants {
  // 倍速
  static readonly SPEED_ARRAY: speedObj[] = [
    {
      text: '0.75x', value: 0
    },
    {
      text: '1.0x', value: 1
    },
    {
      text: '1.25x', value: 2
    },
    {
      text: '1.75x', value: 3
    },
    {
      text: '2.0x', value: 4
    }];
}

@Component
export struct XVideoComponent {
  @Prop videoLocation: Area; // 视频在屏幕中的位置信息
  @Link maskShow: boolean; // 遮罩层是否显示
  @Link @Watch('changeOrientation') isLandscape: boolean; // 是否横屏状态
  @Link @Watch('createOrRelease') fileName: string; // 视频名称
  @State isFullScreen: boolean = false; // 是否全屏状态
  @State systemHeight: number = 0; // 系统状态栏高度
  @State currentTime: number = 0; // 视频当前时间
  @State totalDuration: number = 0; // 视频总时长
  @State isSpeedShow: boolean = false; // 是否倍速状态
  @State speedText: string = '1.0x'; // 倍速Text
  @State speedObj: speedObj = { text: '1.0x', value: 1 }; // 倍速对象
  @State @Watch('onChangePlay') isPlaying: boolean = false; // 是否播放状态
  private avPlayer: media.AVPlayer | undefined = undefined; // 视频播放器对象
  private surfaceID: string = ''; // 视频播放器ID
  private surfaceIDFlag: boolean = false; // 是否绑定surfaceID(仅用于ArkUI-X)
  private xComponentController: XComponentController = new XComponentController();

  aboutToAppear() {
    // 获取系统状态栏高度
    window.getLastWindow(getContext()).then((lastWindow) => {
      const areas = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.systemHeight = px2vp(areas.topRect.height);
    });
  }

  aboutToDisappear() {
    this.getRelease();
    this.isLandscape = false;
  }

  createOrRelease() {
    if (this.fileName !== '') {
      this.init();
    } else {
      this.getRelease();
    }
  }

  onChangePlay() {
    this.isPlaying ? this.getPlay() : this.getPause();
  }

  changeOrientation() {
    // 获取UIAbility实例的上下文信息
    const context = getContext(this) as common.UIAbilityContext;
    // 调用该接口手动改变设备横竖屏状态（设置全屏模式，先强制横屏，再加上传感器模式）
    window.getLastWindow(context).then((lastWindow) => {
      if (this.isLandscape) {
        //横屏模式下，设置窗口的布局是否为沉浸式布局
        lastWindow.setWindowLayoutFullScreen(true).then(() => {
          // 设置窗口全屏模式时导航栏、状态栏的可见模式
          lastWindow.setWindowSystemBarEnable([]);
          // 设置窗口的显示方向属性，AUTO_ROTATION_LANDSCAPE表示传感器自动横向旋转模式
          let windowOrientation: window.Orientation =
            PlatformInfo.isArkUIX() ? window.Orientation.LANDSCAPE_INVERTED : window.Orientation.AUTO_ROTATION_LANDSCAPE
          lastWindow.setPreferredOrientation(windowOrientation);
        });
      } else {
        // 竖屏模式下，取消窗口全屏
        lastWindow.setWindowLayoutFullScreen(false).then(() => {
          // 设置窗口的显示方向属性，UNSPECIFIED表示未定义方向模式，由系统判定
          lastWindow.setPreferredOrientation(window.Orientation.PORTRAIT, () => {
            // 设置窗口全屏模式时导航栏、状态栏的可见模式
            lastWindow.setWindowSystemBarEnable(WINDOW_SYSTEM_BAR).then(() => {
              setTimeout(() => {
                // 设置退出全屏动画
                animateTo({
                  duration: ANIMATE_DURATION,
                  onFinish: () => {
                    this.fileName = '';
                    this.maskShow = false;
                  }
                }, () => {
                  this.isFullScreen = !this.isFullScreen;
                });
              }, TIMEOUT_DURATION);
            });
          });
        })
      }
    });
  }

  checkAvPlayer(): boolean {
    if (this.avPlayer !== undefined) {
      return true
    }
    logger.info(TAG + 'Invalid operation, please create AVPlayer')
    return false;
  }

  async init() {
    try {
      if (this.checkAvPlayer()) {
        this.getRelease();
        this.init();
      } else {
        this.avPlayer = await media.createAVPlayer();
        setTimeout(async () => {
          if (this.checkAvPlayer()) {
            try {
              this.setCallbackFunc();
              let context = getContext(this) as common.UIAbilityContext;
              logger.info(TAG + 'init get fileName is ' + this.fileName);
              let fileDescriptor = await context.resourceManager.getRawFd(this.fileName);
              let fileFd: number = JSON.parse(JSON.stringify(fileDescriptor))['fd'];
              let fileOffset: number = JSON.parse(JSON.stringify(fileDescriptor))['offset'];
              let avFileDescriptor: media.AVFileDescriptor = { fd: fileFd, offset: fileOffset, length: -1 };
              this.avPlayer!.fdSrc = avFileDescriptor;
              // 设置全屏播放展开动画
              animateTo({
                duration: ANIMATE_DURATION,
                onFinish: () => {
                  this.isLandscape = !this.isLandscape;
                }
              }, () => {
                this.isFullScreen = !this.isFullScreen;
                this.surfaceIDFlag = true;
              });
            } catch (err) {
              logger.info(TAG + 'Set Url failed : ' + JSON.stringify(err));
            }
          }
        }, TIMEOUT_DURATION)
      }
    } catch (err) {
      logger.info(TAG + 'init failed : ' + JSON.stringify(err))
    }
  }

  setSurfaceId() {
    try {
      setTimeout(() => {
        if (this.checkAvPlayer()) {
          this.avPlayer!.surfaceId = this.surfaceID;
          this.avPlayer!.prepare().then(async () => {
            logger.info(TAG + 'Prepare success');
            this.totalDuration = this.avPlayer!.duration;
            logger.info(TAG + 'this.totalDuration is ' + this.totalDuration);
            this.isPlaying = true;
            this.surfaceIDFlag = false;
          }).catch((err: BusinessError) => {
            logger.info(TAG + 'Prepare failed : ' + JSON.stringify(err))
          })
        }
      }, TIMEOUT_DURATION)
    } catch (err) {
      logger.info(TAG + 'setSurfaceId failed : ' + JSON.stringify(err))
    }
  }

  setCallbackFunc() {
    // 时间上报函数
    this.avPlayer!.on('timeUpdate', (time: number) => {
      logger.info('timeUpdate called: time is :' + time);
      this.currentTime = time
    });
    // 设置错误监听
    this.avPlayer!.on('error', (error) => {
      logger.error(TAG + 'error happened,message is :' + error.message);
    });
    // 状态机上报回调函数
    this.avPlayer!.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle':
          logger.info(TAG + 'state idle called');
          this.getRelease();
          break;
        case 'initialized':
          logger.info(TAG + 'state initialized called');
          this.setSurfaceId();
          break;
        case 'prepared':
          logger.info(TAG + 'state prepared called');
          this.totalDuration = this.avPlayer!.duration;
          this.isPlaying = true;
          break;
        case 'playing':
          logger.info(TAG + 'state playing called');
          break;
        case 'paused':
          logger.info(TAG + 'state paused called');
          break;
        case 'completed':
          logger.info(TAG + 'state completed called');
          this.isPlaying = !this.isPlaying
          break;
        case 'stopped':
          logger.info(TAG + 'state stopped called');
          break;
        case 'released':
          logger.info(TAG + 'state released called');
          this.currentTime = 0;
          this.totalDuration = 0;
          this.isSpeedShow = false;
          this.speedText = '1.0x';
          this.speedObj = { text: '1.0x', value: 1 };
          break;
        case 'error':
          logger.info(TAG + 'state error called');
          break;
        default:
          logger.info(TAG + 'unknown state :' + state);
          break;
      }
    });
  }

  getPlay() {
    if (this.checkAvPlayer()) {
      this.avPlayer!.setSpeed(this.speedObj.value);
      this.avPlayer!.play();
    }
  }

  getPause() {
    if (this.checkAvPlayer()) {
      this.avPlayer!.pause();
    }
  }

  getRelease() {
    if (this.checkAvPlayer()) {
      this.avPlayer!.release();
      this.isPlaying = false;
      this.avPlayer = undefined;
    }
  }

  // 倍速弹框
  @Builder
  speedPopup() {
    List({ space: SPEED_POPUP_LIST_SPACE }) {
      ForEach(AVPlayerConstants.SPEED_ARRAY, (item: speedObj) => {
        ListItem() {
          Row() {
            Text(item.text)
              .fontColor('rgba(255,255,255,0.90)')
              .fontSize($r('app.integer.media_full_screen_speed_popup_text_font'))
              .onClick(() => {
                this.speedObj = item;
                this.speedText = item.text;
                this.isSpeedShow = false;
                if (this.checkAvPlayer()) {
                  this.avPlayer!.setSpeed(item.value);
                }
              })
          }
          .padding({ left: $r('app.integer.media_full_screen_speed_popup_row_padding') })
          .width($r('app.string.media_full_screen_layout_100'))
          .height($r('app.integer.media_full_screen_speed_popup_row_height'))
        }
      }, (item: speedObj) => {
        return JSON.stringify(item.text);
      })
    }
    .width($r('app.integer.media_full_screen_speed_popup_list_width'))
    .padding($r('app.integer.media_full_screen_speed_popup_list_padding'))
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        XComponent({
          id: '',
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
          .width($r('app.string.media_full_screen_layout_100'))
          .aspectRatio(ASPECT_RATIO)
          .onLoad(() => {
            this.surfaceID = this.xComponentController.getXComponentSurfaceId();
          })
      }
      .borderRadius(this.isFullScreen ? 0 : {
        topLeft: $r('app.integer.media_full_screen_video_border_radius'),
        topRight: $r('app.integer.media_full_screen_video_border_radius')
      })
      .justifyContent(FlexAlign.Center)
      .width($r('app.string.media_full_screen_layout_100'))
      .height($r('app.string.media_full_screen_layout_100'))
      .aspectRatio(this.isFullScreen ? -1 : ASPECT_RATIO)
      .layoutWeight(LAYOUT_WEIGHT)
      .backgroundColor(Color.Black)
      .zIndex(0)

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.fileName)
          .textAlign(TextAlign.Start)
          .fontFamily($r('app.string.media_full_screen_harmony_hei_ti_medium'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize($r('app.integer.media_full_screen_video_name_font_size'))
          .fontColor(Color.White)
          .padding($r('app.integer.media_full_screen_video_name_padding'))
          .width($r('app.string.media_full_screen_layout_100'))
          .margin({left: this.systemHeight})

        Row() {
          // 播放icon
          Image(
            this.isPlaying ? $r("app.media.media_full_screen_icon_play") : $r("app.media.media_full_screen_icon_pause")
          )
            .id(this.isPlaying ? 'playingIcon' : 'pauseIcon')
            .width($r('app.integer.media_full_screen_video_icon_play_width'))
            .height($r('app.integer.media_full_screen_video_icon_play_height'))
            .margin({
              top: 0,
              bottom: 0,
              left: $r('app.integer.media_full_screen_video_icon_play_margin'),
              right: $r('app.integer.media_full_screen_video_icon_play_margin')
            })
            .onClick(() => {
              this.isPlaying = !this.isPlaying;
            })
          // 时间轴
          Row() {
            Text(getTimeString(this.currentTime))
              .fontSize($r('app.integer.media_full_screen_current_time_font_size'))
              .fontColor($r('app.color.media_full_screen_white_color'))
              .fontWeight(500)
              .opacity(0.6)
            Slider({
              value: Math.round(this.currentTime / this.totalDuration * 100)
            })
              .selectedColor(Color.White)
              .layoutWeight(1)
              .trackColor(Color.Gray)
              .onChange((value: number) => {
                if (this.checkAvPlayer()) {
                  this.currentTime = this.totalDuration * value / 100;
                  this.avPlayer!.seek(this.currentTime);
                }
              })
            Text(getTimeString(this.totalDuration))
              .fontSize($r('app.integer.media_full_screen_duration_font_size'))
              .fontColor($r('app.color.media_full_screen_white_color'))
              .fontWeight(500)
              .opacity(0.6)
          }
          .layoutWeight(1)
          .height($r('app.integer.media_full_screen_duration_row_height'))

          // 全屏icon
          Image($r("app.media.media_full_screen_icon_large"))
            .id('collapseVideoButton')
            .width($r('app.integer.media_full_screen_icon_large_width'))
            .height($r('app.integer.media_full_screen_icon_large_height'))
            .margin({
              top: 0,
              bottom: 0,
              left: $r('app.integer.media_full_screen_icon_large_margin'),
              right: $r('app.integer.media_full_screen_icon_large_margin')
            })
            .opacity(0.6)
            .onClick(() => {
              this.isLandscape = !this.isLandscape;
            })
          // 倍速icon
          Text(this.speedText)
            .fontColor('rgba(255,255,255,0.90)')
            .fontSize($r('app.integer.media_full_screen_speed_icon_font_size'))
            .fontFamily($r('app.string.media_full_screen_harmony_hei_ti_medium'))
            .margin($r('app.integer.media_full_screen_speed_icon_margin'))
            .onClick(() => {
              this.isSpeedShow = !this.isSpeedShow;
            })
            .bindPopup(this.isSpeedShow, {
              builder: this.speedPopup,
              placement: Placement.Top,
              popupColor: 'rgba(0,0,0,0.6)'
            })
        }
      }
      .visibility(this.isFullScreen ? Visibility.Visible : Visibility.None)
      .width($r('app.string.media_full_screen_layout_100'))
      .height($r('app.string.media_full_screen_layout_100'))
      .zIndex(1)
    }
    .backgroundColor(Color.Black)
    .visibility(this.fileName !== '' ? Visibility.Visible : Visibility.None)
    .width(this.isFullScreen ? $r('app.string.media_full_screen_video_width') : this.videoLocation.width)
    .height($r('app.string.media_full_screen_video_height'))
    .aspectRatio(this.isFullScreen ? -1 : ASPECT_RATIO)
    .position(this.isFullScreen ? { x: 0, y: 0 } : {
      x: this.videoLocation.globalPosition.x,
      y: (this.videoLocation.globalPosition.y as number) - this.systemHeight
    })
    .zIndex(VIDEO_Z_INDEX)
  }
}