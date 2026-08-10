/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { webview } from '@kit.ArkWeb';
import { Router } from '@kit.ArkUI';

@Entry
@Component
struct OverScrollModeTest {
  private router: Router = this.getUIContext().getRouter();
  private controller: webview.WebviewController = new webview.WebviewController()

  @State overScrollMode: OverScrollMode = OverScrollMode.ALWAYS
  @State result: string = ''

  build() {
    Column({ space: 16 }) {
      Row() {
        Button({ type: ButtonType.Circle }) {
          Image($r('sys.media.ohos_ic_back'))
            .width(20)
            .height(20)
            .fillColor('#666666')
        }
        .id('backButton')
        .width(20)
        .height(20)
        .backgroundColor('#f5f5f5')
        .onClick(() => {
          this.router.back();
        })
        .margin({ right: 16 })

        Text('overScrollMode枚举值测试')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Bottom)

      Column({ space: 12 }) {
        Row() {
          Text('overScrollMode枚举值：')
            .fontSize(13)
            .fontColor('#888888')

          Text(this.result)
            .id('result')
            .fontSize(13)
            .fontColor('#0A59F7')
            .fontWeight(FontWeight.Bold)
        }

        Row({ space: 12 }) {
          Button('NEVER')
            .id('overScrollModeNever')
            .height(42)
            .layoutWeight(1)
            .backgroundColor(this.overScrollMode === OverScrollMode.NEVER ? '#0A59F7' : '#EEF2F6')
            .fontColor(this.overScrollMode === OverScrollMode.NEVER ? '#FFFFFF' : '#333333')
            .borderRadius(12)
            .onClick(() => {
              this.overScrollMode = OverScrollMode.NEVER
              this.result = `${OverScrollMode.NEVER}`
            })

          Button('ALWAYS')
            .id('overScrollModeAlways')
            .height(42)
            .layoutWeight(1)
            .backgroundColor(this.overScrollMode === OverScrollMode.ALWAYS ? '#0A59F7' : '#EEF2F6')
            .fontColor(this.overScrollMode === OverScrollMode.ALWAYS ? '#FFFFFF' : '#333333')
            .borderRadius(12)
            .onClick(() => {
              this.overScrollMode = OverScrollMode.ALWAYS
              this.result = `${OverScrollMode.ALWAYS}`
            })
        }

        Web({ src: $rawfile('index.html'), controller: this.controller })
          .id('webComponent3')
          .overScrollMode(this.overScrollMode)
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .zoomAccess(true)
          .onErrorReceive((e) => {
            this.result = '网页加载失败'
          })
          .width('100%')
          .height(200)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
      }
      .cardStyle()

    }
    .width('100%')
    .backgroundColor('#F5F7FA')
  }
}

// 卡片统一样式
@Extend(Column)
function cardStyle() {
  .width('100%')
  .padding(16)
  .margin({ left: 16, right: 16 })
  .backgroundColor('#FFFFFF')
  .borderRadius(20)
  .shadow({
    radius: 12,
    color: 'rgba(0,0,0,0.05)',
    offsetX: 0,
    offsetY: 2
  })
}
