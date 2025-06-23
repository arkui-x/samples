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
import { TextClockModifier } from '@ohos.arkui.modifier';

class MyModifier extends TextClockModifier {
  applyNormalAttribute(instance: TextClockModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .format('aa hh:mm:ss')
      .fontColor(Color.Green)
      .fontSize(30)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .textShadow({
        radius: 20,
        color: Color.Red,
        offsetX: 15,
        offsetY: 15
      })
      .fontFeature("\"ss01\" on")
      .dateTimeOptions({ hour: "2-digit" })
  }
}

@Entry
@Component
struct TestTextClockModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State accumulateTime: number = 0
  controller: TextClockController = new TextClockController()

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
            TextClock({ timeZoneOffset: -8, controller: this.controller })
              .attributeModifier(this.modifier)
              .onDateChange((value: number) => {
                this.accumulateTime = value
              })
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