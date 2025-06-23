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
import { TextPickerModifier } from '@ohos.arkui.modifier';

class MyModifier1 extends TextPickerModifier {
  applyNormalAttribute(instance: TextPickerModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .defaultPickerItemHeight(45)
      .disappearTextStyle({ color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } })
      .textStyle({ color: Color.Black, font: { size: 20, weight: FontWeight.Normal } })
      .selectedTextStyle({ color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } })
      .selectedIndex(2)
      .canLoop(false)
      .divider({
        strokeWidth: 2,
        color: Color.Pink,
        startMargin: 20,
        endMargin: 20
      })
      .gradientHeight(100)
      .disableTextStyleAnimation(false)
      .defaultTextStyle({ minFontSize: 18, maxFontSize: 28, overflow: TextOverflow.Ellipsis })
  }
}

class MyModifier2 extends TextPickerModifier {
  applyNormalAttribute(instance: TextPickerModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .defaultPickerItemHeight(45)
      .disappearTextStyle({ color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } })
      .textStyle({ color: Color.Black, font: { size: 20, weight: FontWeight.Normal } })
      .selectedTextStyle({ color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } })
      .selectedIndex(2)
      .canLoop(false)
      .divider({
        strokeWidth: 2,
        color: Color.Pink,
        startMargin: 20,
        endMargin: 20
      })
      .gradientHeight(100)
      .disableTextStyleAnimation(true)
      .defaultTextStyle({ minFontSize: 18, maxFontSize: 28, overflow: TextOverflow.Ellipsis })
  }
}

@Entry
@Component
struct TestTextPickerModifier {
  @State title: string = ''
  @State modifier1: MyModifier1 = new MyModifier1()
  @State modifier2: MyModifier2 = new MyModifier2()

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
            TextPicker({ range: ['apple', 'orange', 'peach', 'grape'] })
              .attributeModifier(this.modifier1)
          }
        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '30%' })
      .border({
        width: 3,
        color: Color.Pink,
        radius: 30,
        style: BorderStyle.Solid
      })
      .margin({ top: 10, bottom: 10 })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      Column() {
        Scroll() {
          Column() {
            TextPicker({ range: ['apple', 'orange', 'peach', 'grape'] })
              .attributeModifier(this.modifier2)
          }

        }.scrollBar(BarState.Off)
      }
      .size({ width: '98%', height: '30%' })
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