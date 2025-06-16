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
import { COMPONENT_LIST } from '../data/CommonData'
import { AlphabetListItemType } from '../model/AlphabetListItemType'
import Logger from '../utils/Logger'
import { TitleBar } from 'titleBar';
const TAG: string = '[EnterPage] '

@Entry
@Component
struct attributeDemo {
  @State stabIndex: number = 0
  @State alphabetIndexer: string[] = []
  private alphabetSelectList: AlphabetListItemType[] = COMPONENT_LIST
  private scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    if (this.alphabetSelectList.length) {
      this.alphabetSelectList.forEach((item: AlphabetListItemType) => {
        this.alphabetIndexer.push(item.name)
      })
    }
  }

  build() {
    Column() {
      TitleBar({title: $r('app.string.Modifier_title') })
      Column() {
        Column() {
          Stack({ alignContent: Alignment.End }) {
            Column() {
              List({
                space: 15,
                initialIndex: 0,
                scroller: this.scroller
              }) {
                ForEach(this.alphabetSelectList, (alphabetListItem: AlphabetListItemType) => {
                  ListItem() {
                    Column() {
                      Text(`${alphabetListItem.name}`)
                        .width('100%')
                        .height(30)
                        .fontSize(16)

                      ForEach(alphabetListItem.dataList, (item: string, index: number) => {
                        Column() {
                          Text(item)
                            .width('100%')
                            .height(30)
                            .fontSize(16)
                        }
                        .margin({ left: 20 })
                        .onClick(() => {
                          // 跳转组件界面
                          let url: string = alphabetListItem.urlList[index]
                          if (url != undefined) {
                            Logger.info(TAG, 'select url is ' + url)
                            Logger.info(TAG, 'select item is ' + item)
                            router.pushUrl({
                              url: alphabetListItem.urlList[index],
                              params: { 'title': item }
                            })
                          }
                        })
                      })
                    }
                  }
                })
              }
              .width('100%')
              .layoutWeight(1)
              .edgeEffect(EdgeEffect.Spring)
              .divider({
                strokeWidth: 3,
                color: Color.Black,
                startMargin: 0,
                endMargin: 20
              })
              .listDirection(Axis.Vertical)
              .scrollBar(BarState.Off)
              .onScrollIndex((firstIndex: number, lastIndex: number) => {
                this.stabIndex = firstIndex
              })
            }
            .alignItems(HorizontalAlign.Start)

            AlphabetIndexer({ arrayValue: this.alphabetIndexer, selected: this.stabIndex })
              .height('100%')
              .margin({ right: -8 })
              .usingPopup(true)
              .alignStyle(IndexerAlign.Right)
              .itemSize(20)
              .popupColor(Color.Black)
              .popupBackground(Color.Pink)
              .popupPosition({
                x: 50,
                y: 350
              })
              .onSelect((tabIndex: number) => {
                this.scroller.scrollToIndex(tabIndex)
              })
          }
          .flexShrink(1)
          .flexGrow(1)
          .layoutWeight(1)
          .backgroundColor('#00e3e5e5')

          // }
        }
        .size({ width: '100%', height: '100%' })
        .padding({
          top: 20,
          left: 20,
          right: 20,
          bottom: 20
        })
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
  }
}