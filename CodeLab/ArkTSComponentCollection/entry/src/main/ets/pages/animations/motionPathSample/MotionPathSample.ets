/*
 * Copyright (c) 2025 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { TitleBar } from '../../../common/TitleBar';
import window from '@ohos.window';

@Entry
@Component
struct MotionPathSample {
  @State toggle: boolean = true;
  @State screenWidth: number = 0;
  @State screenHeight: number = 0;

  async aboutToAppear() {
    try {
      const win = await window.getLastWindow(getContext(this));
      const windowProperties = win.getWindowProperties();
      this.screenWidth = windowProperties.windowRect.width;
      this.screenHeight = windowProperties.windowRect.height;
    } catch (error) {
      console.error('Failed to get window properties:', error);
    }
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.motion_path') })
      Scroll() {
        Column() {
          Button($r('app.string.motion_path_click_me'))
            .margin(50)
            .motionPath({
              path: `Mstart.x start.y L${this.screenWidth * 0.5} ${this.screenHeight * 0.3} L${this.screenWidth *
                0.5} ${this.screenHeight * 0.7} Lend.x end.y`,
              from: 0.0,
              to: 1.0,
              rotatable: true
            })
            .onClick(() => {
              animateTo({ duration: 4000, curve: Curve.Linear }, () => {
                this.toggle = !this.toggle; // 通过this.toggle变化组件的位置
              })
            })
            .id('motion_click')
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius(24)
        .backgroundColor($r('app.color.background_shallow_grey'))
        .height('100%')
        .width('100%')
        .margin({ left: 12, right: 12 })
        .alignItems(this.toggle ? HorizontalAlign.Start : HorizontalAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}