/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import window from '@ohos.window'
import WindowManger from './WindowManger'
import { WindowEventId, WindowType } from "../util/WindowConst"
import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'
import './Color'
import './ProgressCircle'
const windowAttribute: WindowType = {
  moveToWidth: 50, // 窗口移动X坐标
  moveToHeight: 250, // 窗口移动Y坐标
  setTouchable: true, // 窗口是否可触
  resetSizeWidth: 400, // 窗口宽
  resetSizeHeight: 300, // 窗口高
  setPrivacyMode: true, // 窗口是否为隐私模式
  setBrightness: 1 // 窗口亮度
}
export default class Color {
  public r: number = 0;
  public g: number = 0;
  public b: number = 0;

  constructor(r: number, g: number, b: number) {
    this.r = Math.round(r);
    this.g = Math.round(g);
    this.b = Math.round(b);
  }

  public toHex(): string {
    return `#${this.num2Hex(this.r)}${this.num2Hex(this.g)}${this.num2Hex(this.b)}`;
  }

  public toRGB(): string {
    return `rgb(${this.r}, ${this.g}, ${this.b})`
  }

  private num2Hex(n: number) {
    const hex = n.toString(16);
    return hex.length == 1 ? `0${hex}` : hex;
  }
}
@Component
export struct WindowComponent {
  @StorageLink("topHeight") topHeight: number = 0 // 窗口规避区域高
  @StorageLink("topWidth") topWidth: number = 0 // 窗口规避区域宽

  build() {
    Column() {
      Button("提交")
        .width('100%')
        .height('100%')
      // 窗口顶部规避区域
      Row()
        .width(px2vp(this.topWidth))
        .height(px2vp(this.topHeight))
      // video视频
      VideoWindow()
    }
    Button("提交")
    .width('100%')
    .height('100%')
  }
}

@Component
struct VideoWindow {
  @State isPlaying: boolean = false
  private context: common.UIAbilityContext
  private subWindow: window.WindowStage
  private isPortrait: Boolean = true
  private showSubWindow: Boolean = false

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext
    let data = {
      context: null,
      launchWant: null,
      subWindow: null
    }
    this.context.eventHub.emit("createWindow", data)
    this.subWindow = data.subWindow
  }

  build() {
    Column() {

      Button("name")
        .id('mainVideo')
        .width(400)
        .height(250)
        .margin(5)
        .onClick(async () => {
          Logger.info('onClick')
          if (this.showSubWindow) {

            let windows = await this.subWindow?.getSubWindow()
            windows[0]?.destroyWindow()
            this.showSubWindow = false
          } else {
            WindowManger.initSubWindow(this.subWindow, windowAttribute)
            this.showSubWindow = true
          }
        })


      Button("window change")
        .id('windowBtn')
        .onClick(() => {
          if (this.isPortrait) {
            WindowManger.changeWindowDirection(this.subWindow, window.Orientation.LANDSCAPE)
            this.isPortrait = false
          } else {
            WindowManger.changeWindowDirection(this.subWindow, window.Orientation.PORTRAIT)
            this.isPortrait = true
          }
        })
    }
  }
}


