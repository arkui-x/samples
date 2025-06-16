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
import { SliderModifier } from '@ohos.arkui.modifier';

class MyModifier extends SliderModifier {
  applyNormalAttribute(instance: SliderModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .blockStyle({ type: SliderBlockType.DEFAULT })
      .blockColor(Color.Orange)
      .blockBorderColor(Color.Pink)
      .blockBorderWidth(6)
      .blockSize({ width: 35, height: 35 })
      .trackColor(0xAFEEEE)
      .selectedColor(Color.Green)
      .stepColor(Color.Yellow)
      .showSteps(true)
      .showTips(true)
      .trackThickness(40)
      .trackBorderRadius(25)
      .selectedBorderRadius(60)
      .stepSize(8)
      .sliderInteractionMode(SliderInteraction.SLIDE_ONLY)
      .minResponsiveDistance(2)
      .slideRange({
        from: 20,
        to: 80
      })
  }
}

@Entry
@Component
struct TestSliderModifier {
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
            Slider({ style: SliderStyle.OutSet, value: 40, step: 10 })
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