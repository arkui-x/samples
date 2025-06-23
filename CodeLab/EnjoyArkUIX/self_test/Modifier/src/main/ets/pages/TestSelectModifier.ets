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
import { SelectModifier } from '@ohos.arkui.modifier';

class MyModifier extends SelectModifier {
  applyNormalAttribute(instance: SelectModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .selected(2)
      .value("Select")
      .controlSize(ControlSize.NORMAL)
      .arrowPosition(ArrowPosition.END)
      .divider({
        strokeWidth: 5,
        color: Color.Blue,
        startMargin: 10,
        endMargin: 10
      })
      .font({ size: 16, weight: 500 })
      .fontColor(Color.Pink)
      .selectedOptionBgColor(0x00FFFF)
      .selectedOptionFont({ size: 16, weight: 400 })
      .optionBgColor(Color.Green)
      .optionFont({ size: 16, weight: 400 })
      .optionFontColor(Color.Red)
      .space(12)
      .arrowPosition(ArrowPosition.END)
      .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
      .optionWidth(200)
      .optionHeight(300)
      .menuBackgroundColor(Color.Yellow)
      .menuBackgroundBlurStyle(BlurStyle.BACKGROUND_REGULAR)
  }
}

@Entry
@Component
struct TestSelectModifier {
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
            Select([{ value: 'aaa', icon: $r("app.media.icon") },
              { value: 'bbb', icon: $r("app.media.icon") },
              { value: 'ccc', icon: $r("app.media.icon") },
              { value: 'ddd', icon: $r("app.media.icon") }])
              .attributeModifier(this.modifier)
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