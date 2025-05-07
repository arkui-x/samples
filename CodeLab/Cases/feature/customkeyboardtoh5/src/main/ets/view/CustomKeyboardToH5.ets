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

import { AppRouter } from 'routermodule';
import { TabletTitle, WebTab } from '../components/TitleBar';
import { Browser } from '../components/Browser';

const PROGRESS_TOTAL: number = 100; // 进度条总数
const FLEX_SHRINK_NUMBER: number = 0; // Divider压缩比例

/**
 * 实现步骤：
 * 1. 构建一个 Browser 对象，集成浏览器的方法。创建一个自定义组件 TabletTitle，构成浏览器的工具栏。
 * 2. 自定义键盘传入js对象 WebKeyboardObj， 构建两个函数：点击登录按钮事件和输入法弹窗弹出事件。其中输入法弹出事件中使用CustomDialog修饰的组件，打开自定义弹窗。
 * 3. 将webKeyboardObj对象通过webController.registerJavaScriptProxy注册到h5页面中,使页面中可以调用arkTS的方法。
 * 4. 构建一个h5页面，在js层中调用注册进入的arkTS方法。
 */

@AppRouter({ name: "customkeyboardtoh5/CustomKeyboardToH5" })
@Component
export struct CustomKeyboardToH5 {
  @State browser: Browser = new Browser(); // 浏览器对象

  build() {
    Column() {
      TabletTitle({ browser: $browser })
      Progress({ value: this.browser.progress, total: PROGRESS_TOTAL })
        .color($r('app.color.custom_keyboard_to_h5_progress_color'))
        .visibility(this.browser.hideProgress ? Visibility.None : Visibility.Visible)
      Divider()
        .color($r('app.color.custom_keyboard_to_h5_divider_color'))
        .width($r('app.string.custom_keyboard_to_h5_layout_100'))
        .flexShrink(FLEX_SHRINK_NUMBER)
      WebTab({ browser: $browser })
    }
  }
}
