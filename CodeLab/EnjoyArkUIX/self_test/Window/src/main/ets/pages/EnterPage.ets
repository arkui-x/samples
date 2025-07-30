/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import window from '@ohos.window';

import { WindowEventId, WindowType } from "../util/WindowConst"
import { TitleBar } from './TitleBar';
import common from '@ohos.app.ability.common'
import Logger from '../util/Logger'
const windowAttribute: WindowType = {
  moveToWidth: 50, // 窗口移动X坐标
  moveToHeight: 250, // 窗口移动Y坐标
  setTouchable: true, // 窗口是否可触
  resetSizeWidth: 400, // 窗口宽
  resetSizeHeight: 300, // 窗口高
  setPrivacyMode: true, // 窗口是否为隐私模式
  setBrightness: 1 // 窗口亮度
}

@Entry
@Component

struct Third {
  @State message: string = 'Stage Test'

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.Window_title') })
          .width('100%')

        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)

        Button('Animation')
          .margin({ top: 20 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Animation' })
          })

        Button('Resource')
          .margin({ top: 20 })
          .onClick(() => {
            console.log("resource click")
            router.pushUrl({ url: 'pages/Resource' })
          })

        Button('Window')
              .margin({ top: 20 })
              .onClick(() => {
                  router.pushUrl({ url: 'pages/Window' })
              })

      }
      .width('100%')
    }
    .height('100%')
  }



}