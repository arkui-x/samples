/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import common from '@ohos.app.ability.common'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Main1Page {
  @State message: string = '应用界面-A'

  startAbility(moduleName: string, abilityName: string): void {
    let context = getContext(this) as common.UIAbilityContext
    context.startAbility({
      bundleName: "com.example.splitscreenview",
      moduleName: moduleName,
      abilityName: abilityName,
    })
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Text(this.message)
            .fontSize(35)
            .fontWeight(FontWeight.Bold)

          Button('返回')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .backgroundColor(Color.Green)
            .onClick(() => {
              router.back()
            })

          Button('进入分屏界面-B')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .onClick(() => {
              this.startAbility('entry', 'Main2Ability')
            })

          Button('进入分屏界面-C')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .onClick(() => {
              this.startAbility('entry', 'Main3Ability')
            })

          Button('进入分屏界面-B1')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .onClick(() => {
              this.startAbility('entry', 'Feature2Ability')
            })

          Button('进入分屏界面-C1')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .onClick(() => {
              this.startAbility('entry', 'Feature3Ability')
            })

          Button('视频播放')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/VideoPage'
              })
            })

          Button('WebView')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage'
              })
            })

        }.width('100%')
      }.scrollBar(BarState.Off)
    }.height('100%')
  }
}