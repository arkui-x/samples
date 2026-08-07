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
struct NonExplicitTest {
  private router: Router = this.getUIContext().getRouter();
  private controller: webview.WebviewController = new webview.WebviewController()

  @State result: string = '网页加载成功'

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

        Text('非显式调用测试')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222222')
          .margin({ right: 16 })

        Text('initialScale / overScrollMode')
          .fontSize(13)
          .fontColor('#888888')

      }
      .width('100%')
      .padding(16)
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Bottom)

      Column({ space: 10 }) {
        Row() {
          Text('不调用 initialScale / overScrollMode  ')
            .id('specificResult')
            .fontSize(13)
            .fontColor('#888888')

          Text(this.result)
            .id('result')
            .fontSize(13)
            .fontColor('#888888')
        }

        Web({ src: $rawfile('index.html'), controller: this.controller })
          .id('webComponent2')
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

      Blank()
        .height(30)
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
