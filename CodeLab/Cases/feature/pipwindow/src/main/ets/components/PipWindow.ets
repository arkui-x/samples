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

import { VideoInfoComponent } from './VideoInfoComponent';
import { PipWindowComponent } from './PipWindowComponent';
import { AVPlayer } from '../model/AVPlayer';
import { PipManager } from '../model/PipManager';

/**
 * 功能描述：本示例主要介绍视频小窗口播放场景，利用媒体的AVPlayer实现视频播放以及相关操作，利用PiPWindow开启悬浮窗从而实现小窗口播放视频。
 *
 * 推荐场景：需跨出应用开启悬浮窗时使用
 *
 * 核心组件：
 * 1.XComponentView 视频播放组件
 * 2.PipWindowComponent 画中画控制开启、播放组件
 * 3.ControlPanel 控制器组件
 *
 * 实现步骤：
 * 1.初始化视频播放控制器。
 * @example
 * @State player: AVPlayer = PipManager.getInstance().player;
 * 2.传入在线视频资源。
 * @example
 * @State url: string = "https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4"; // 传入在线视频资源
 * 3.设置原视频高度。
 * @example
 * @State videoHeight: string | number | Resource = $r('app.integer.pip_window_component_stack_height');
 * 4.设置原视频宽度。
 * @example
 * @State videoWidth: string | number | Resource = $r('app.string.pip_window_full_width');
 * 5.构建画中画控制开启、播放组件。
 * @example
 *  PipWindowComponent();
 *
 */
@Component
export struct PipWindowViewComponent {
  @State player: AVPlayer = PipManager.getInstance().player;
  @State url: string = "https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4"; // 传入在线视频资源
  @State videoHeight: string | number | Resource = $r('app.integer.pip_window_component_stack_height');
  @State videoWidth: string | number | Resource = $r('app.string.pip_window_full_width');

  build() {
    Column() {
      /**
       * 画中画控制开启、播放组件
       * player:初始化视频播放控制器
       * url:传入在线视频资源
       */
      PipWindowComponent({
        player: this.player,
        url: this.url
      })
        .height(this.videoHeight)
        .width(this.videoWidth)
      // 视频介绍页面，渲染效果不参与画中画功能开发
      VideoInfoComponent();
    }
  }
}