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

import { logger } from '../utils/Logger';

/**
 * 功能描述: XComponent 提供了应用在 native 侧调用 OpenGLES 图形接口的能力，本文主要介绍如何配合 Vsync 事件，完成自定义动画。在这种实现方式下，自定义动画的绘制不在 UI 主线程中完成，即使主线程卡顿，动画效果也不会受影响。
 *
 * 推荐场景: 自定义动画
 *
 * 核心组件:
 * 1. XComponent
 *
 * 实现步骤：
 * 1. CMakelists 增加 lib 依赖
 * 2. 创建 vsync 实例
 * 3. 创建 OH_NativeVSync_RequestFrame 回调，并在回调中使用 egl 接口进行绘制
 */

@Component
export struct XcomponentVsyncComponent {
  build() {
    Stack() {
      XComponent({
        id: Date.now().toString(),
        type: XComponentType.SURFACE,
        libraryname: 'entry'
      })
        .onLoad(() => {
          logger.info('PluginRender:: surface onLoad')
        })
        .onDestroy(() => {
          logger.info('PluginRender:: surface onDestroy');
        })
        .width('100%')
        .height('100%')
    }
    .alignContent(Alignment.TopStart)
    .width('100%')
    .height('100%')
  }
}