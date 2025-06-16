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
import { ListModifier } from '@ohos.arkui.modifier';

class MyModifier extends ListModifier {
  applyNormalAttribute(instance: ListModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .listDirection(Axis.Vertical)
      .divider({
        strokeWidth: 2,
        color: 0xFFFFFF,
        startMargin: 20,
        endMargin: 20
      })
      .scrollBar(BarState.On)
      .edgeEffect(EdgeEffect.Spring)
      .chainAnimation(true)
      .lanes(3)
      .alignListItem(ListItemAlign.Center)
      .sticky(StickyStyle.Header | StickyStyle.Footer)
      .scrollSnapAlign(ScrollSnapAlign.CENTER)
      .enableScrollInteraction(true)
      .nestedScroll({
        'scrollForward': NestedScrollMode.SELF_ONLY,
        'scrollBackward': NestedScrollMode.SELF_ONLY
      })
      .friction(0.8)
      .contentStartOffset(10)
      .contentEndOffset(10)
      .maintainVisibleContentPosition(true)
      .size({ width: '98%', height: '80%' })
      .margin({ top: 10, bottom: 10 })
      .borderRadius(10)
      .backgroundColor(0xDCDCDC)
  }
}

@Entry
@Component
struct TestListModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  private arr: number[] = []
  private scrollerForList: Scroller = new Scroller()

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
    for (let i = 0; i < 20; i++) {
      this.arr.push(i)
    }
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      List({ space: 20, initialIndex: 3, scroller: this.scrollerForList }) {
        ForEach(this.arr, (item: number) => {
          ListItem() {
            Text('' + item)
              .width('100%').height(10).fontSize(16)
              .textAlign(TextAlign.Center)
          }
          .borderRadius(10).backgroundColor(0xFFFFFF)
          .width('60%')
          .height('20%')
        }, (item: number) => JSON.stringify(item))
      }.attributeModifier(this.modifier)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}