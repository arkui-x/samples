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
import { SpanModifier } from '@ohos.arkui.modifier';

class MyModifier extends SpanModifier {
  applyNormalAttribute(instance: SpanModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .decoration({ type: TextDecorationType.None, color: Color.Red })
      .letterSpacing(3)
      .textCase(TextCase.LowerCase)
      .fontColor(Color.Pink)
      .fontSize(40)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .lineHeight(50)
      .font({
        size: 40,
        weight: FontWeight.Bold,
        style: FontStyle.Italic,
        family: 'HarmonyOS Sans'
      })
      .textShadow([
        {
          radius: 10,
          color: Color.Red,
          offsetX: 10,
          offsetY: 0
        },
        {
          radius: 10,
          color: Color.Orange,
          offsetX: 20,
          offsetY: 0
        },
        {
          radius: 10,
          color: Color.Yellow,
          offsetX: 30,
          offsetY: 0
        },
        {
          radius: 10,
          color: Color.Green,
          offsetX: 40,
          offsetY: 0
        },
        {
          radius: 10,
          color: Color.Blue,
          offsetX: 100,
          offsetY: 0
        }
      ])
  }
}

@Entry
@Component
struct TestSpanModifier {
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
              Span('abc123我')
                .attributeModifier(this.modifier)
            }
          }
        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '40%' })
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