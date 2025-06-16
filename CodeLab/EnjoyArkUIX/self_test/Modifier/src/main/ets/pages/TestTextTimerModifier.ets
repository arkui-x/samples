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
import { RadioModifier, TextTimerModifier } from '@ohos.arkui.modifier';

class MyTextTimerModifier extends TextTimerModifier {
  applyNormalAttribute(instance: TextTimerModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .format('mm:ss.SS')
      .fontColor(Color.Black)
      .fontSize(50)
      .fontStyle(FontStyle.Italic)
      .fontWeight(FontWeight.Bold)
      .fontFamily('HarmonyOS Sans')
      .textShadow({
        radius: 20,
        color: Color.Red,
        offsetX: 15,
        offsetY: 15
      })
  }
}

class MyRadioModifier extends RadioModifier {
  applyNormalAttribute(instance: RadioModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .radioStyle({
        checkedBackgroundColor: Color.Pink,
        uncheckedBorderColor: Color.Orange,
        indicatorColor: Color.Green
      })
      .height(50)
      .width(50)
  }

  updateChecked(flag: boolean): void {
    this.checked(flag)
  }
}

@Entry
@Component
struct TestTextTimerModifier {
  @State title: string = ''
  @State myTextTimerModifier: MyTextTimerModifier = new MyTextTimerModifier()
  @State myRadioModifier: MyRadioModifier = new MyRadioModifier()
  textTimerController: TextTimerController = new TextTimerController()

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
            TextTimer({ isCountDown: true, count: 30000, controller: this.textTimerController })
              .attributeModifier(this.myTextTimerModifier)
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

      Column() {
        Scroll() {
          Column({ space: 2 }) {
            Row() {
              Column() {
                Text('start')
                Radio({ value: 'start', group: 'radioGroup' })
                  .attributeModifier(this.myRadioModifier)
                  .onChange((isChecked: boolean) => {
                    (this.myRadioModifier as MyRadioModifier).updateChecked(isChecked)
                    if (isChecked) {
                      this.textTimerController.start()
                    }
                  })
              }

              Column() {
                Text('pause')
                Radio({ value: 'pause', group: 'radioGroup' })
                  .attributeModifier(this.myRadioModifier)
                  .onChange((isChecked: boolean) => {
                    (this.myRadioModifier as MyRadioModifier).updateChecked(isChecked)
                    if (isChecked) {
                      this.textTimerController.pause()
                    }
                  })
              }

              Column() {
                Text('reset')
                Radio({ value: 'reset', group: 'radioGroup' })
                  .attributeModifier(this.myRadioModifier)
                  .onChange((isChecked: boolean) => {
                    (this.myRadioModifier as MyRadioModifier).updateChecked(isChecked)
                    if (isChecked) {
                      this.textTimerController.reset()
                    }
                  })
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)

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
