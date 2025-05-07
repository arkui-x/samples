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

import { PiPWindow, promptAction, window } from '@kit.ArkUI';
import { XComponentView } from './XComponentView';
import { PipManager } from '../model/PipManager';
import { getTimeString } from '../util/TimeTools';
import { AVPlayer } from '../model/AVPlayer';
import { ControlPanel } from './ControlPanel';
import { audio, AVVolumePanel } from '@kit.AudioKit';
import { logger } from '../util/Logger';
import { emitter } from '@kit.BasicServicesKit';

const TAP_GESTURE = 2; // 双击事件
const COMPONENT_OPACITY = 0.6; // 视频进度条组件透明度
const TAKE_SURPLUS = 100; // 对视频时长进行取余
const HEIGHT_INTEGER = 100; // 手指移动距离取整
const PARTITION = 2; // 视频分区
const CONTROLLER_MAX = 50; // 控制器的最大值
const CONTROLLER_DElAY = 500; // 控制器时延
const BRIGHT_VALUE = 0.5; // 亮度的原值
const POSITION_X = -100; // 面板横轴坐标
const POSITION_Y = 200; // 面板纵轴坐标

// 画中画控制开启、播放组件
/**
 * 功能描述：
 * 1.悬浮窗的开启条件以及开启后台模式下的悬浮穿
 * 2.视频资源加载的动效
 * 3.原视频界面播放暂停的控制
 * 4.原视频暂停关闭悬浮窗
 * 5.点击小窗口图标拉起悬浮窗
 *
 * 实现原理：
 * 1.通过PiPWindow.isPiPEnabled()来判断当前设备是否开启画中画
 * 2.通过PipManager.getInstance().init(getContext(this));来创建画中画
 * 3.通过this.player.isLoading来监听在线资源是否加载完成
 * 4.通过对this.player.isPlaying进行更改，并使用@Watch监听整个AVPlayer的变化，来确定isPlaying是否改变，并通过来this.player.getPlay()、this.player.getPause()控制视频的播放和暂停
 * 5.当this.player.isPlaying===false时，应关闭画中画的开启，使用PipManager.getInstance().setAutoStart(false)关闭
 * 6.点击小窗口图标使用PipManager.getInstance().startPip()手动开启悬浮窗
 * 7.使用this.mWindow?.setWindowBrightness(this.bright / CONTROLLER_MAX)控制屏幕亮度
 * 8.使用audioVolumeGroupManager.getVolume控制视频声音大小
 *
 * @param {string} url - 视频源（必需，本案例仅支持使用在线视频）
 * @param {AVPlayer} player - 初始化视频播放控制器（必需）
 */
@Component
export struct PipWindowComponent {
  @Link url: string; // 在线视频路径
  @ObjectLink @Watch("onPlayingChange") player: AVPlayer;
  private panOption = new PanGestureOptions({ direction: PanDirection.Up | PanDirection.Down });
  private positionH: number = 0; // 移动的高度
  @State fingerPosition: number = 0; // 手指定位位置
  @State videoAreaWidth: number = 0; // 视频播放区域宽度
  @State videoAreaHeight: number = 0; // 视频播放区域高度
  @State volume: number = 25; //音量大小
  @State bright: number = 25; //亮度大小
  @State controlShow: boolean = false; // 控制器是否显示
  @State mWindow: window.Window | undefined = undefined; // 当前窗口实例
  @State maxVolume: number = 0; // 媒体最大音量

  onPlayingChange() {
    this.player.isPlaying ? this.player.getPlay() : this.player.getPause();
    if (this.player.isPlaying === false) {
      PipManager.getInstance().setAutoStart(false);
    } else {
      PipManager.getInstance().setAutoStart(true);
      PipManager.getInstance().updatePiPControlStatus();
    }
  }

  onBrightActionUpdate(changeY: number) {
    this.bright += changeY;
    this.bright = Number(this.borderJudge(0, CONTROLLER_MAX, this.bright).toFixed(0));
  }

  onVolumeActionUpdate(changeY: number) {
    this.getVolume();
    this.volume += changeY;
    this.volume = Number(this.borderJudge(0, this.maxVolume, this.volume).toFixed(0));
  }

  borderJudge(min: number, max: number, value: number) {
    if (value < min) {
      return min;
    } else if (value > max) {
      return max;
    } else {
      return value;
    }
  }

  getVolume() {
    let audioManager = audio.getAudioManager();
    let audioVolumeManager: audio.AudioVolumeManager = audioManager.getVolumeManager();
    let audioVolumeGroupManager: audio.AudioVolumeGroupManager =
      audioVolumeManager.getVolumeGroupManagerSync(audio.DEFAULT_VOLUME_GROUP_ID);
    audioVolumeGroupManager.getVolume(audio.AudioVolumeType.MEDIA).then((value: number) => {
      logger.info(`Promise returned to indicate that the volume is obtained ${value}.`);
      this.volume = value;
    });
    audioVolumeGroupManager.getMaxVolume(audio.AudioVolumeType.MEDIA).then((data: number) => {
      logger.info('Promised returned to indicate that the maximum volume is obtained.' + data);
      this.maxVolume = data;
    });
  }

  sysVolumeChange() {
    let audioManager = audio.getAudioManager();
    let audioVolumeManager: audio.AudioVolumeManager = audioManager.getVolumeManager();
    audioVolumeManager.on('volumeChange', (volumeEvent: audio.VolumeEvent) => {
      logger.info(`Volume level: ${volumeEvent.volume} `);
      this.volume = volumeEvent.volume;
    });
  }

  async aboutToAppear() {
    // 当前窗口实例
    window.getLastWindow(getContext(this)).then((lastWindow) => {
      this.mWindow = lastWindow;
    })
    // 获取系统当前音量
    this.sysVolumeChange();
    // 获取视频当前音量
    this.getVolume();
    // 判断当前设备是否开启画中画
    if (PiPWindow.isPiPEnabled()) {
      promptAction.showToast({ message: $r('app.string.pip_window_open') });
      // 创建画中画控制器
      PipManager.getInstance().init(getContext(this));
    } else {
      promptAction.showToast({ message: $r('app.string.pip_window_not_activated') });
    }
    // 获取当前视频总时长
    this.player.setTimeUpdateCallback((time) => {
      this.player.currentTime = time;
    })
  }

  aboutToDisappear() {
    // 关闭画中画
    this.player.isPiPWindowLoad = false;
    // 释放AVPlayer资源
    this.player.release();
    // 关闭画中画
    PipManager.getInstance().stopPip();
    // 当回桌面时关闭画中画
    PipManager.getInstance().setAutoStart(false);
    // 调整屏幕亮度
    this.mWindow?.setWindowBrightness(BRIGHT_VALUE);
  }

  build() {
    Stack() {
      Text($r('app.string.pip_window_video_playing'))
        .fontColor($r('app.color.pip_window_component_stack_text'))

      this.XComponentVideo()
    }
    .backgroundColor($r('app.color.pip_window_component_stack_background_color'))
    .alignContent(Alignment.Bottom)
  }

  /**
   * 视频渲染页面
   */
  @Builder
  XComponentVideo() {
    Stack(this.player.isLoading ? { alignContent: Alignment.Center } :
      { alignContent: Alignment.Bottom }) {

      /**
       * 视频播放组件
       * url:视频源（本案例仅支持使用在线视频）
       */
      XComponentView({
        url: this.url
      })

      /**
       * 音量面板，掉起系统面板将面板通过定位隐藏，使用自定义图标
       * volumeLevel:通过音量面板设置设备音量
       * volumeParameter:设置音量面板的自定义参数
       */
      // TODO：知识点：音量面板详情可参考：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V13/ohos-multimedia-avvolumepanel-V13。
      AVVolumePanel({
        volumeLevel: this.volume,
        volumeParameter: {
          position: {
            x: POSITION_X,
            y: POSITION_Y
          }
        }
      })

      // 开发者可自定义播放组件
      if (this.player.isLoading) {
        // 加载页面
        Column() {
          // TODO: 知识点：创建加载进展组件，除支持通用属性外，还支持设置加载进度条前景色和设置动画显示或者不显示。
          LoadingProgress()
            .color(Color.White)
            .width($r('app.integer.pip_window_loading_progress_width'))
            .height($r('app.integer.pip_window_loading_progress_width'))
          Text($r('app.string.pip_window_loading_progress'))
            .fontSize($r('app.integer.pip_window_loading_progress_text'))
            .fontColor(Color.White)
        }
        .justifyContent(FlexAlign.Center)
        .zIndex(2)
      } else {
        // 视频进度条
        this.ProgressBar()
      }
    }
    .onAreaChange((oldVal: Area, newVal: Area) => {
      // 获取视频播放区域的宽高
      this.videoAreaWidth = newVal.width as number;
      this.videoAreaHeight = newVal.height as number;
    })
    .gesture(
      // 双击视频，视频暂停/播放
      GestureGroup(GestureMode.Exclusive,
        TapGesture({ count: TAP_GESTURE })
          .onAction((event?: GestureEvent) => {
            this.player.isPlaying = !this.player.isPlaying;
            emitter.emit({ eventId: 0, priority: 0 }, {
              data: {
                pipWindow_isPlaying: this.player.isPlaying
              }
            })
            if (this.player.isPlaying === false) {
              PipManager.getInstance().setAutoStart(false);
              PipManager.getInstance().updatePiPControlStatus();
            } else {
              PipManager.getInstance().setAutoStart(true);
              PipManager.getInstance().updatePiPControlStatus();
            }
          }),
        PanGesture(this.panOption)
          .onActionStart((event: GestureEvent) => {
            this.sysVolumeChange();
            this.positionH = event.offsetY;
            this.controlShow = true;
          })
          .onActionUpdate((event: GestureEvent) => {
            this.panOption.setDirection(PanDirection.Vertical);
            // 手指初次滑动横向坐标位置
            this.fingerPosition = event.fingerList[0].localX;
            if (this.positionH === event.offsetY) {
              return;
            }
            // 手指移动的距离
            let changeVolume = ((this.positionH - event.offsetY) / this.videoAreaHeight) * HEIGHT_INTEGER;
            if (this.fingerPosition < (this.videoAreaWidth / PARTITION)) {
              this.onBrightActionUpdate(changeVolume);
              // 调节视频亮度
              this.mWindow?.setWindowBrightness(this.bright / CONTROLLER_MAX);
            } else {
              this.onVolumeActionUpdate(changeVolume);
            }
            this.positionH = event.offsetY;
          })
          .onActionEnd(() => {
            // 延时隐藏控制器
            setTimeout(() => {
              this.controlShow = false;
            }, CONTROLLER_DElAY)
          })
      ))
    .visibility(this.player.isPiPWindowLoad ? Visibility.Hidden : Visibility.Visible)
  }

  @Builder
  ProgressBar() {
    /**
     * 视频亮度、音量控制器组件
     * volume:视频音量大小
     * bright:视频亮度大小
     * fingerPosition:手指滑动的位置
     * videoAreaWidth:视频播放区域宽度
     * videoAreaHeight:视频播放区域高度
     * controlShow:控制器是否显示
     * maxVolume:媒体最大音量
     */
    ControlPanel({
      volume: $volume,
      bright: $bright,
      fingerPosition: $fingerPosition,
      videoAreaWidth: $videoAreaWidth,
      videoAreaHeight: $videoAreaHeight,
      controlShow: $controlShow,
      maxVolume: $maxVolume
    })
      .margin({ bottom: $r('app.integer.pip_window_control_panel_margin_bottom') })
    Row() {
      // 播放icon
      Image(this.player.isPlaying ? $r("app.media.pip_window_icon_play") :
      $r("app.media.pip_window_icon_pause"))
        .id('isPlaying')
        .width($r('app.integer.pip_window_progress_bar_icon_play_width'))
        .height($r('app.integer.pip_window_progress_bar_icon_play_width'))
        .margin({
          left: $r('app.integer.pip_window_progress_bar_icon_play_margin_left'),
          right: $r('app.integer.pip_window_progress_bar_icon_play_margin_left')
        })
        .onClick(() => {
          this.player.isPlaying = !this.player.isPlaying;
          emitter.emit({ eventId: 0, priority: 0 }, {
            data: {
              pipWindow_isPlaying: this.player.isPlaying
            }
          })
          if (this.player.isPlaying === false) {
            PipManager.getInstance().setAutoStart(false);
            PipManager.getInstance().updatePiPControlStatus();
          } else {
            PipManager.getInstance().setAutoStart(true);
            PipManager.getInstance().updatePiPControlStatus();
          }
        })
      // 时间轴
      Row() {
        Text(getTimeString(this.player.currentTime))
          .fontSize($r('app.integer.pip_window_loading_progress_text'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .opacity(COMPONENT_OPACITY)
        Slider({
          value: Math.round(this.player.currentTime /
          this.player.totalDuration * TAKE_SURPLUS)
        })
          .selectedColor(Color.White)
          .layoutWeight(1)
          .trackColor(Color.Gray)
          .onChange((value: number) => {
            this.player.currentTime =
              this.player.totalDuration * value / TAKE_SURPLUS;
            this.player.avPlayer.seek(this.player.currentTime);
          })
        Text(getTimeString(this.player.totalDuration))
          .fontSize($r('app.integer.pip_window_loading_progress_text'))
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .opacity(COMPONENT_OPACITY)
      }
      .layoutWeight(1)
      .height($r('app.integer.pip_window_slider_height'))

      // 全屏icon
      Image($r("app.media.pip_window_icon_large"))
        .width($r('app.integer.pip_window_progress_bar_icon_play_width'))
        .height($r('app.integer.pip_window_progress_bar_icon_play_width'))
        .margin({
          left: $r('app.integer.pip_window_progress_bar_icon_play_margin_left'),
          right: $r('app.integer.pip_window_progress_bar_icon_play_margin_left')
        })
        .opacity(COMPONENT_OPACITY)
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r("app.string.pip_window_toast_tips") });
        })

      // 手动开启悬浮窗
      Image($r("app.media.pip_window_icon_move_out"))
        .width($r('app.integer.pip_window_progress_bar_icon_play_width'))
        .height($r('app.integer.pip_window_progress_bar_icon_play_width'))
        .margin({
          right: $r('app.integer.pip_window_progress_bar_icon_play_margin_left')
        })
        .opacity(COMPONENT_OPACITY)
        // TODO：知识点：开发者可在此手动开启悬浮窗，也可以从此处进行页面的路由跳转，相关功能请开发者根据业务场景实现。注意当开发者动手开启悬浮窗后立即点击返回在模拟器上异常，需要开发者在真机验证。
        .onClick(() => {
          // 手动开启悬浮窗
          PipManager.getInstance().startPip();
          // 手动开启悬浮窗时，视频在悬浮窗界面保持播放
          this.player.isPlaying = true;
        })
    }
    .padding({ bottom: $r('app.integer.pip_window_progress_bar_padding_bottom') })
  }
}


