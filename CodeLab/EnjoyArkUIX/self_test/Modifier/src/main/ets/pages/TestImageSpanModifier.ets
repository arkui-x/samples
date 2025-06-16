/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { TitleBar } from '../component/TitleBar';
import Logger from '../utils/Logger';
import { ImageSpanModifier } from '@ohos.arkui.modifier';

class MyModifier extends ImageSpanModifier {
  applyNormalAttribute(instance: ImageSpanModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .verticalAlign(ImageSpanAlignment.CENTER)
      .objectFit(ImageFit.Fill)
      .colorFilter(
        new ColorFilter([0.5, 0, 0.5, 0, 0,
          0, 0.5, 0.5, 0, 0,
          0.5, 0, 0.5, 0, 0,
          0, 0, 0.5, 0, 0])
      )
      .width('200px')
      .height('200px')
  }
}

@Entry
@Component
struct TestImageSpanModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Column() {
        Scroll() {
          Column() {
            Text() {
              Span('I am LineThrough-span')
                .decoration({ type: TextDecorationType.LineThrough, color: Color.Red }).fontSize(25)
              Span('I am LineThrough-span')
                .decoration({ type: TextDecorationType.LineThrough, color: Color.Red }).fontSize(25)
              ImageSpan($r('app.media.icon'))
                .attributeModifier(this.modifier)
              Span('I am LineThrough-span')
                .decoration({ type: TextDecorationType.LineThrough, color: Color.Red }).fontSize(25)
              ImageSpan($r('app.media.icon'))
                .attributeModifier(this.modifier)
              Span('I am Underline-span')
                .decoration({ type: TextDecorationType.Underline, color: Color.Red }).fontSize(25)
            }
            .width('100%')
            .textIndent(50)
          }
        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '80%' })
      .border({
        width: 3,
        color: Color.Pink,
        radius: 30,
        style: BorderStyle.Solid
      })
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}