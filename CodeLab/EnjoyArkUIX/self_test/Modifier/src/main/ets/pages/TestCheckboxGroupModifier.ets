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
import { CheckboxGroupModifier } from '@ohos.arkui.modifier';

class MyModifier extends CheckboxGroupModifier {
  applyNormalAttribute(instance: CheckboxGroupModifier): void {
    instance
      .selectAll(true)
      .selectedColor(Color.Green)
      .unselectedColor(Color.Red)
      .mark({
        strokeColor: Color.Black,
        size: 50,
        strokeWidth: 5
      })
      .checkboxShape(CheckBoxShape.ROUNDED_SQUARE)
      .width(30)
      .height(30)
  }
}

@Entry
@Component
struct TestCheckboxGroupModifier {
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

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              CheckboxGroup({ group: 'checkboxGroup' })
                .attributeModifier(this.modifier)
              Text('Select All').fontSize(14).lineHeight(20).fontColor('#182431').fontWeight(500)
            }

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
                .selectedColor('#007DFF')
                .shape(CheckBoxShape.ROUNDED_SQUARE)
                .onChange((value: boolean) => {
                  console.info('Checkbox1 change is' + value)
                })
              Text('Checkbox1').fontSize(14).lineHeight(20).fontColor('#182431').fontWeight(500)
            }.margin({ left: 36 })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                .selectedColor('#007DFF')
                .shape(CheckBoxShape.ROUNDED_SQUARE)
                .onChange((value: boolean) => {
                  console.info('Checkbox2 change is' + value)
                })
              Text('Checkbox2').fontSize(14).lineHeight(20).fontColor('#182431').fontWeight(500)
            }.margin({ left: 36 })

            Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
              Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
                .selectedColor('#007DFF')
                .shape(CheckBoxShape.ROUNDED_SQUARE)
                .onChange((value: boolean) => {
                  console.info('Checkbox3 change is' + value)
                })
              Text('Checkbox3').fontSize(14).lineHeight(20).fontColor('#182431').fontWeight(500)
            }.margin({ left: 36 })
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