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
import { GridModifier } from '@ohos.arkui.modifier'

class MyModifier extends GridModifier {
  applyNormalAttribute(instance: GridModifier): void {
    super.applyNormalAttribute?.(instance)
    instance
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Blue)
      .scrollBarWidth(10)
      .editMode(true)
      .layoutDirection(GridDirection.Row)
      .enableScrollInteraction(true)
      .supportAnimation(false)
      .edgeEffect(EdgeEffect.Spring)
      .friction(5)
    instance
      .width('90%')
      .height(300)
      .backgroundColor(0xFAEEE0)
  }
}

@Entry
@Component
struct TestGridModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  @State numbers: string[] = ['0', '1', '2', '3', '4', '5']
  @State dragText: string = ''
  scroller: Scroller = new Scroller()

  @Builder
  pixelMapBuilder() {
    Column() {
      Text(this.dragText)
        .fontSize(16)
        .backgroundColor(0xF9CF93)
        .width(80)
        .height(80)
        .textAlign(TextAlign.Center)
    }
  }

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  changeIndex(index1: number, index2: number) {
    let temp: string
    temp = this.numbers[index1]
    this.numbers[index1] = this.numbers[index2]
    this.numbers[index2] = temp
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Grid(this.scroller) {
        ForEach(this.numbers, (day: string) => {
          ForEach(this.numbers, (day: string) => {
            GridItem() {
              Text(day)
                .fontSize(16)
                .backgroundColor(0xF9CF93)
                .width('100%')
                .height(80)
                .textAlign(TextAlign.Center)
            }
          }, (day: string) => day)
        }, (day: string) => day)
      }
      .attributeModifier(this.modifier)
      .onItemDragStart((event: ItemDragInfo, itemIndex: number) => {
        this.dragText = this.numbers[itemIndex]
        return this.pixelMapBuilder()
      })
      .onItemDrop((event: ItemDragInfo, itemIndex: number, insertIndex: number, isSuccess: boolean) => {
        if (!isSuccess || insertIndex >= this.numbers.length) {
          return
        }
        this.changeIndex(itemIndex, insertIndex)
      })

    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}