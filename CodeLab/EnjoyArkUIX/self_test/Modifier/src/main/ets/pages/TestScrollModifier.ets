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
import { ScrollModifier } from '@ohos.arkui.modifier';

class MyModifier extends ScrollModifier {
  applyNormalAttribute(instance: ScrollModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Green)
      .scrollBarWidth(20)
      .edgeEffect(EdgeEffect.Spring)
      .enableScrollInteraction(true)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
      .friction(0.6)
      .enablePaging(false)
      .initialOffset({
        xOffset: 10,
        yOffset: 10
      })
  }
}

@Entry
@Component
struct TestScrollModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Column() {
        Scroll(this.scroller) {
          Column() {
            ForEach(this.arr, (item: number) => {
              Text(item.toString())
                .width('90%')
                .height(50)
                .backgroundColor(Color.Pink)
                .borderRadius(15)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .margin({ top: 10 })
            }, (item: string) => item)
          }.width('90%')
        }
        .attributeModifier(this.modifier)
      }
      .size({ width: '98%', height: '60%' })
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