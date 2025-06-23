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
import { WaterFlowDataSource } from '../model/WaterFlowDataSource';
import Logger from '../utils/Logger';
import { WaterFlowModifier } from '@ohos.arkui.modifier';

class MyModifier extends WaterFlowModifier {
  applyNormalAttribute(instance: WaterFlowModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .columnsTemplate('repeat(auto-fill,80)')
      .rowsTemplate('1fr 1fr 2fr')
      .itemConstraintSize({
        'minWidth': 1,
        'maxWidth': 200,
        'minHeight': 1,
        'maxHeight': 200,
      })
      .columnsGap(10)
      .rowsGap(5)
      .layoutDirection(FlexDirection.ColumnReverse)
      .enableScrollInteraction(true)
      .nestedScroll({
        'scrollForward': NestedScrollMode.SELF_ONLY,
        'scrollBackward': NestedScrollMode.SELF_ONLY
      })
      .friction(0.6)
      .cachedCount(15, true)
      .backgroundColor(0xFAEEE0)
      .size({ width: '100%', height: '80%' })
      .margin({ top: 10, bottom: 10 })
  }
}

@Entry
@Component
struct TestWaterFlowModifier {
  @State title: string = ''
  @State minSize: number = 80
  @State maxSize: number = 180
  @State colors: number[] = [0xFFC0CB, 0xDA70D6, 0x6B8E23, 0x6A5ACD, 0x00FFFF, 0x00FF7F]
  @State modifier: MyModifier = new MyModifier()
  private itemWidthArray: number[] = []
  private itemHeightArray: number[] = []
  dataSource: WaterFlowDataSource = new WaterFlowDataSource()

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.itemWidthArray.push(this.getSize())
      this.itemHeightArray.push(this.getSize())
    }

    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  getSize() {
    let ret = Math.floor(Math.random() * this.maxSize)
    return (ret > this.minSize ? ret : this.minSize)
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })
      WaterFlow() {
        LazyForEach(this.dataSource, (item: number) => {
          FlowItem() {
            Column() {
              Text("N" + item).fontSize(12).height('16')
            }
          }
          .width('100%')
          .height(this.itemHeightArray[item % 100])
          .backgroundColor(this.colors[item % 5])
        }, (item: string) => item)
      }.attributeModifier(this.modifier)

    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}