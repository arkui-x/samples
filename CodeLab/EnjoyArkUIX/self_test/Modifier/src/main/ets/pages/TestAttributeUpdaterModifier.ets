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
import { CommonItemSelect } from '../component/CommonItemSelect'
import Logger from '../utils/Logger'
import { AttributeUpdater } from '@ohos.arkui.modifier'
import { promptAction } from '@kit.ArkUI'

const TAG: string = '[TestAttributeUpdaterModifier] '

class MyModifier extends AttributeUpdater<ButtonAttribute, ButtonInterface> {
  applyNormalAttribute(instance: ButtonAttribute): void {
    Logger.info(TAG, 'applyNormalAttribute ')
    instance
      .width('90%')
      .height(30)
      .margin({ top: 20 })
      .type(ButtonType.Capsule)
      .fontSize(20)
      .fontColor(Color.Black)
      .fontWeight(800)
      .fontStyle(FontStyle.Italic)
      .stateEffect(true)
      .buttonStyle(ButtonStyleMode.EMPHASIZED)
      .controlSize(ControlSize.NORMAL)
      .role(ButtonRole.ERROR)
  }

  initializeModifier(instance: ButtonAttribute): void {
    Logger.info(TAG, 'initializeModifier ')
    promptAction.showToast({
      message: 'initializeModifier'
    })
    instance
      .width('50%')
      .height(100)
  }

  onComponentChanged(instance: ButtonAttribute): void {
    Logger.info(TAG, 'onComponentChanged ')
    promptAction.showToast({
      message: 'onComponentChanged',
    })
  }
}

@Entry
@Component
struct TestAttributeUpdaterModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State index: number = 0

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
            if (this.index === 0) {
              Button("Button")
                .attributeModifier(this.modifier)
            } else if (this.index === 1) {
              Button("Button")
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

      Divider().size({ width: '100%', height: 3 }).backgroundColor(Color.Black).margin({ top: 20, bottom: 20 })

      Column() {
        Scroll() {
          Column({ space: 2 }) {
            CommonItemSelect({
              name: '背景颜色',
              selects: ['Orange', 'GREEN'],
              callback: (index) => {
                switch (index) {
                  case 0:
                    this.modifier.attribute?.backgroundColor(Color.Orange)
                    break
                  case 1:
                    this.modifier.attribute?.backgroundColor(Color.Green)
                    break
                  default:
                }
              }
            })

            CommonItemSelect({
              name: 'updateConstructorParams',
              selects: ['Button1', 'Button2'],
              callback: (index) => {
                switch (index) {
                  case 0:
                    this.modifier.updateConstructorParams('Button1')
                    break
                  case 1:
                    this.modifier.updateConstructorParams('Button2')
                    break
                  default:
                }
              }
            })

            CommonItemSelect({
              name: 'onComponentChanged',
              selects: ['1', '2'],
              callback: (index) => {
                this.index = index
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