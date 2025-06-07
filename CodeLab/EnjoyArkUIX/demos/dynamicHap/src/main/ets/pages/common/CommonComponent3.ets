/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

@Entry
@Component
struct CommonComponent3 {
  @State services: Array<string> = ['会议', '投票', '签到', '打印']
  @State Number: String[] = ['0', '1', '2', '3']
  scroller: Scroller = new Scroller()

  build() {
    Row() {
      Scroll() {
        Column() {
          Text("Grid组件展示")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin(10)

          Grid() {
            GridItem() {
              Text('会议')
            }

            GridItem() {
              Text('签到')
            }

            GridItem() {
              Text('投票')
            }

            GridItem() {
              Text('打印')
            }
          }
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .margin(20)
          .height(100)

          Text("Tabs组件展示")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin(10)

          Tabs() {
            TabContent() {
              Text('首页的内容').fontSize(10)
            }
            .tabBar('首页')

            TabContent() {
              Text('推荐的内容').fontSize(10)
            }
            .tabBar('推荐')

            TabContent() {
              Text('发现的内容').fontSize(10)
            }
            .tabBar('发现')

            TabContent() {
              Text('我的内容').fontSize(10)
            }
            .tabBar("我的")
          }
          .height(150)

          Text("scroll组件展示")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin(10)

          Grid(this.scroller) {
            ForEach(this.Number, (day: string) => {
              ForEach(this.Number, (day: string) => {
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
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .friction(0.6)
          .edgeEffect(EdgeEffect.Spring)
          .scrollBar(BarState.On)
          .onScrollIndex((first: number) => {
            console.info(first.toString())
          })
          .onScrollBarUpdate((index: number, offset: number) => {
            return { totalOffset: (index / 5) * (80 + 10) - offset, totalLength: 80 * 5 + 10 * 4 }
          })
          .width('90%')
          .backgroundColor(0xFAEEE0)
          .height(300)

        }
        .width('100%')
      }
    }
    .height('100%')
  }
}
