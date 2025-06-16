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
import { SwiperModifier } from '@ohos.arkui.modifier';

class MyDataSource implements IDataSource {
  private list: number[] = []

  constructor(list: number[]) {
    this.list = list
  }

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): number {
    return this.list[index]
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }
}

class MyModifier extends SwiperModifier {
  applyNormalAttribute(instance: SwiperModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .index(2)
      .autoPlay(true)
      .interval(3000)
      .indicator(new DotIndicator()
        .itemWidth(15)
        .itemHeight(15)
        .selectedItemWidth(15)
        .selectedItemHeight(15)
        .color(Color.Gray)
        .selectedColor(Color.Blue)
      )
      .loop(false)
      .duration(1000)
      .vertical(false)
      .itemSpace(10)
      .displayMode(SwiperDisplayMode.STRETCH)
      .cachedCount(2)
      .disableSwipe(false)
      .curve(Curve.Linear)
      .displayCount(1)
      .effectMode(EdgeEffect.Spring)
      .displayArrow({
        showBackground: true,
        isSidebarMiddle: true,
        backgroundSize: 24,
        backgroundColor: Color.White,
        arrowSize: 18,
        arrowColor: Color.Blue
      }, false)
      .nextMargin(5)
      .prevMargin(5)
      .indicatorInteractive(true)
      .pageFlipMode(PageFlipMode.SINGLE)
  }
}

@Entry
@Component
struct TestSwiperModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  private swiperController: SwiperController = new SwiperController()
  private data: MyDataSource = new MyDataSource([])

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
    let list: number[] = []
    for (let i = 0; i <= 9; i++) {
      list.push(i);
    }
    this.data = new MyDataSource(list)
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Column() {
        Scroll() {
          Column() {
            Swiper(this.swiperController) {
              LazyForEach(this.data, (item: string) => {
                Text(item.toString())
                  .width('90%')
                  .height(160)
                  .backgroundColor(0xAFEEEE)
                  .textAlign(TextAlign.Center)
                  .fontSize(30)
              }, (item: string) => item)
            }
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