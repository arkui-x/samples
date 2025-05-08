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

const CONTROLLER_MAX = 50; // 控制器的最大值
const ASPECT_RATIO = 1.0; // 宽高比
const PARTITION = 2; // 视频分区

// 视频亮度、音量控制器
/**
 * 功能描述：
 * 1.构建视频亮度、音量控制器
 * 2.手指在视频左右两侧滑动可控制视频页面的亮度以及视频的声音。
 *
 * 实现原理：
 * 1.通过this.fingerPosition和this.videoAreaWidth / PARTITION比较来判断需要显示亮度控制器还是声音控制器
 * 2.使用Progress来显示进度条，同时value值为this.bright、this.volume亮度、声音大小
 *
 * @param {number} volume - 音量大小（必需）
 * @param {number} bright - 亮度大小（必需）
 * @param {number} fingerPosition - 手指定位位置（必需）
 * @param {number} videoAreaWidth - 视频播放区域宽度（必需）
 * @param {number} videoAreaHeight - 视频播放区域高度（必需）
 * @param {boolean} controlShow - 控制器是否显示（必需）
 */
@Component
export struct ControlPanel {
  @Link volume: number; // 音量大小
  @Link bright: number; // 亮度大小
  @Link fingerPosition: number; // 手指定位位置
  @Link videoAreaWidth: number; // 视频播放区域宽度
  @Link videoAreaHeight: number; // 视频播放区域高度
  @Link controlShow: boolean; // 控制器是否显示
  @Link maxVolume: number; // 媒体最大音量

  build() {
    Stack() {
      // 亮度调节UI
      Image($r('app.media.pip_window_brightness'))
        .width($r('app.integer.pip_window_control_panel_image_width'))
        .aspectRatio(ASPECT_RATIO)
        .visibility((this.fingerPosition !== 0 && this.fingerPosition < this.videoAreaWidth / PARTITION &&
        this.controlShow) ?
        Visibility.Visible : Visibility.Hidden)
      Progress({
        value: this.bright,
        type: ProgressType.Ring,
        total: CONTROLLER_MAX
      })
        .color($r('app.color.pip_window_progress_color'))
        .width($r('app.integer.pip_window_control_panel_progress_width'))
        .aspectRatio(ASPECT_RATIO)
        .visibility((this.fingerPosition !== 0 && this.fingerPosition < this.videoAreaWidth / PARTITION &&
        this.controlShow) ?
        Visibility.Visible : Visibility.Hidden)

      // 音量调节UI
      Image($r('app.media.pip_window_sound'))
        .width($r('app.integer.pip_window_control_panel_image_width'))
        .aspectRatio(ASPECT_RATIO)
        .visibility((this.fingerPosition !== 0 && this.fingerPosition > this.videoAreaWidth / PARTITION &&
        this.controlShow) ?
        Visibility.Visible : Visibility.Hidden)
      Progress({
        value: this.volume,
        type: ProgressType.Ring,
        total: this.maxVolume
      })
        .color($r('app.color.pip_window_progress_color'))
        .width($r('app.integer.pip_window_control_panel_progress_width'))
        .aspectRatio(ASPECT_RATIO)
        .visibility((this.fingerPosition !== 0 && this.fingerPosition > this.videoAreaWidth / PARTITION &&
        this.controlShow) ?
        Visibility.Visible : Visibility.Hidden)
    }
    .width($r('app.string.pip_window_full_width'))
    .height($r('app.string.pip_window_control_panel_height'))
  }
}


