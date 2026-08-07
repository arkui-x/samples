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
import router from '@ohos.router';

interface OverScrollOption {
  name: string;
  value: OverScrollMode | null | undefined;
}

@Entry
@Component
struct WebScaleAndOverScrollTest {
  private temp: router.RouterMode = router.RouterMode.Standard;
  private router: Router = this.getUIContext().getRouter();
  private controller: webview.WebviewController = new webview.WebviewController()
  private overScrollOptions: Array<OverScrollOption> = [
    { name: 'ALWAYS', value: OverScrollMode.ALWAYS },
    { name: 'NEVER', value: OverScrollMode.NEVER },
    { name: 'null', value: null },
    { name: 'undefined', value: undefined },
    { name: '-10', value: -10 }
  ]

  @State initialScale: number | null | undefined = 100
  @State overScrollMode: OverScrollMode = OverScrollMode.ALWAYS
  @State result: string = ''

  build() {
    Scroll() {
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

          Text('Web属性测试')
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

        // initialScale 控制
        Column({ space: 12 }) {
          Row() {
            Text('initialScale')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)

            Blank()

            Text(`${this.initialScale}%`)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#0A59F7')
          }

          Row({ space: 10 }) {
            this.quickScaleButton(50)
            this.quickScaleButton(100)
            this.quickScaleButton(150)
            this.quickScaleButton(200)
          }

          Row({ space: 10 }) {
            this.quickScaleButton(500)
            this.quickScaleButton(800)
            this.quickScaleButton(1000)
            this.quickScaleButton(2000)
          }

          Row({ space: 10 }) {
            this.quickScaleButton(-1)
            this.quickScaleButton(0)

            Button(`null`)
              .id(`adjustInitialScale null`)
              .height(36)
              .layoutWeight(1)
              .backgroundColor(this.initialScale === null ? '#0A59F7' : '#EEF2F6')
              .fontColor(this.initialScale === null ? '#FFFFFF' : '#333333')
              .borderRadius(10)
              .onClick(() => {
                this.result = '网页加载成功'
                this.initialScale = null
              })

            Button(`undefined`)
              .id(`adjustInitialScale undefined`)
              .height(36)
              .layoutWeight(1)
              .backgroundColor(this.initialScale === undefined ? '#0A59F7' : '#EEF2F6')
              .fontColor(this.initialScale === undefined ? '#FFFFFF' : '#333333')
              .borderRadius(10)
              .onClick(() => {
                this.result = '网页加载成功'
                this.initialScale = undefined
              })
          }

          Text('overScrollMode')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)

          Row({ space: 12 }) {
            ForEach(this.overScrollOptions,
              (item: OverScrollOption) => {
                Button(item.name)
                  .id(`adjustOverScrollMode ${item.name}`)
                  .height(42)
                  .layoutWeight(1)
                  .backgroundColor(this.overScrollMode === item.value ? '#0A59F7' : '#EEF2F6')
                  .fontColor(this.overScrollMode === item.value ? '#FFFFFF' : '#333333')
                  .borderRadius(12)
                  .onClick(() => {
                    this.result = '网页加载成功'
                    this.overScrollMode = item.value!
                  })
              })
          }
        }
        .cardStyle()

        // 操作按钮
        Column({ space: 10 }) {
          Row() {
            Text(`initialScale=${this.initialScale}%  overScrollMode=${this.overScrollMode}  `)
              .id('specificResult')
              .fontSize(13)
              .fontColor('#888888')

            Text(this.result)
              .id('result')
              .fontSize(13)
              .fontColor('#888888')
          }

          // Button('获取缩放值')
          //   .id('getScale')
          //   .buttonStyle(ButtonStyleMode.NORMAL)
          //   .width('100%')
          //   .onClick(() => {
          //     try {
          //       this.controller.runJavaScript('getScale()', (err, result) => {
          //         if (!err) {
          //           this.result = `${result}`;
          //         } else {
          //           this.result = "JS执行失败";
          //         }
          //       });
          //     } catch (e) {
          //       this.result = "JS执行失败";
          //     }
          //   })

          Web({ src: $rawfile("index.html"), controller: this.controller })
            .id('webComponent1')
            .initialScale(this.initialScale)
            .overScrollMode(this.overScrollMode)
            .javaScriptAccess(true)
            .domStorageAccess(true)
            .zoomAccess(true)
            .onErrorReceive((e) => {
              this.result = "网页加载失败"
            })
            .width('100%')
            .height(200)
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
        }
        .cardStyle()

      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .backgroundColor('#F5F7FA')
    }
    .width('100%')
    .height('100%')
    .align(Alignment.TopStart)
  }

  // 快捷缩放按钮
  @Builder
  quickScaleButton(scale: number | null | undefined) {
    Button(`${scale}%`)
      .id(`adjustInitialScale ${scale}%`)
      .height(36)
      .layoutWeight(1)
      .backgroundColor(this.initialScale === scale ? '#0A59F7' : '#EEF2F6')
      .fontColor(this.initialScale === scale ? '#FFFFFF' : '#333333')
      .borderRadius(10)
      .onClick(() => {
        this.result = '网页加载成功'
        this.initialScale = scale
      })

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
