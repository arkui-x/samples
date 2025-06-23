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

import router from '@ohos.router'
import { TitleBar } from '../component/TitleBar'
import Logger from '../utils/Logger'

import { DataPanelModifier } from '@ohos.arkui.modifier'

class MyModifier extends DataPanelModifier {
  applyNormalAttribute(instance: DataPanelModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .closeEffect(true)
      .trackBackgroundColor('#20FF0000')
      .strokeWidth(30)
      .width(300)
      .height(300)
  }
}

@Entry
@Component
struct TestDataPanelModifier {
  @State title: string = ''
  @State MyModifier: DataPanelModifier = new MyModifier()
  colorArray: Array<LinearGradient | ResourceColor> = [
    new LinearGradient([{ color: "#65EEC9A3", offset: 0 }, { color: "#FFEF629F", offset: 1 }]),
    new LinearGradient([{ color: "#FF67F9D4", offset: 0 }, { color: "#FFFF9554", offset: 1 }]),
    new LinearGradient([{ color: "#65EEC9A3", offset: 0 }, { color: "#FFEF629F", offset: 1 }]),
    new LinearGradient([{ color: "#FF67F9D4", offset: 0 }, { color: "#FFFF9554", offset: 1 }]),
  ]
  shadowColorArray: Array<LinearGradient | ResourceColor> = [
    new LinearGradient([{ color: "#65EEC9A3", offset: 0 }, { color: "#65EF629F", offset: 1 }]),
    new LinearGradient([{ color: "#65e26709", offset: 0 }, { color: "#65efbd08", offset: 1 }]),
    new LinearGradient([{ color: "#6572B513", offset: 0 }, { color: "#6508efa6", offset: 1 }]),
    new LinearGradient([{ color: "#65ed08f5", offset: 0 }, { color: "#65ef0849", offset: 1 }])
  ]

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
    this.MyModifier
      .valueColors(this.colorArray)
      .trackShadow({
        radius: 5,
        colors: this.shadowColorArray,
        offsetX: 15,
        offsetY: 15
      })
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Column() {
        Scroll() {
          Column() {
            DataPanel({ values: [20, 20, 20, 20], max: 100, type: DataPanelType.Circle })
              .attributeModifier(this.MyModifier)
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
