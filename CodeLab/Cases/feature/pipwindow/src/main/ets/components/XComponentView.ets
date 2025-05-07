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

import { PipManager } from '../model/PipManager';

// 视频播放组件
/**
 * 功能描述：
 * 1.构建视频播放器
 * 2.通过绑定相同控制器来控制视频播放页面和悬浮窗的同步
 * 3.XComponent和AVPlayer通过surfaceId绑定
 *
 * 实现原理：
 * 1.通过绑定PipManager.getInstance().getXComponentController()控制器，保持视频和悬浮穿视频同步
 * 2.在onLoad（插件加载完成时回调事件）中绑定视频PipManager.getInstance().getXComponentController().getXComponentSurfaceId()，保证XComponent和AVPlayer绑定
 * 3.在onLoad（插件加载完成时回调事件）中进行视频初始化，进而开始视频的播放
 *
 * @param {string} url - 视频源（必需，本案例仅支持使用在线视频）
 */
@Component
export struct XComponentView {
  @Link url: string; // 在线视频路径

  build() {
    Column() {
      XComponent({
        type: XComponentType.SURFACE,
        controller: PipManager.getInstance().getXComponentController()
      })
        .onLoad(() => {
          // 将surfaceId设置给媒体源
          PipManager.getInstance()
            .getXComponentController()
            .onSurfaceCreated(PipManager.getInstance().getXComponentController().getXComponentSurfaceId())
          // 初始化AVPlayer
          PipManager.getInstance().player.init(this.url);
        })
    }
    .id('XComponentView')
  }
}