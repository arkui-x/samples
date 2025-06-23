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
import { CommonItemSelect } from '../component/CommonItemSelect';
import { TimePickerModifier } from '@ohos.arkui.modifier';

class MyModifier extends TimePickerModifier {
  applyNormalAttribute(instance: TimePickerModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .disappearTextStyle({ color: Color.Red, font: { size: 15, weight: FontWeight.Lighter } })
      .textStyle({ color: Color.Black, font: { size: 20, weight: FontWeight.Normal } })
      .selectedTextStyle({ color: Color.Blue, font: { size: 30, weight: FontWeight.Bolder } })
      .loop(false)
      .dateTimeOptions({ hour: "2-digit" })
  }

  setUseMilitaryTime(flag: boolean): void {
    this.useMilitaryTime(flag)
  }
}

@Entry
@Component
struct TestTimePickerModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State isMilitaryTime: boolean = false

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
            TimePicker({
              selected: new Date('2022-07-22T08:00:00')
            })
              .attributeModifier(this.modifier as MyModifier)
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

      Divider().size({ width: '100%', height: 3 }).backgroundColor(Color.Black).margin({ top: 20, bottom: 20 })

      Column() {
        Scroll() {
          Column({ space: 2 }) {
            CommonItemSelect({
              name: '时制',
              selects: ['12小时制', '24小时制'],
              callback: (index) => {
                switch (index) {
                  case 0:
                    (this.modifier as MyModifier).setUseMilitaryTime(false)
                    break
                  case 1:
                    (this.modifier as MyModifier).setUseMilitaryTime(true)
                    break
                  default:
                }
              }
            })

            Row() {
            }.size({ width: '100%', height: 20 })
          }
        }.scrollBar(BarState.Off)
      }.size({ width: '100%', height: '40%' })

    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}