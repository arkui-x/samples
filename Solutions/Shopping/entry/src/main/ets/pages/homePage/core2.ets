/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { CoreDataModel } from '../../model/homeModel'
import { coreData } from '../../data/homeData'
import { router } from '@kit.ArkUI'

@Component
export struct Core2 {
  @State cols: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  @State rows: number[] = [0, 1]
  @State coreData: Array<CoreDataModel> = coreData
  @Prop ratio: number

  build() {
    Column() {
      List() {
        ForEach(this.cols, (item1: number) => {
          ListItem() {
            Grid() {
              ForEach(this.rows, (item2: number) => {
                GridItem() {
                  Column() {
                    Image(`${this.coreData[item1 * 2 + item2].uri}`)
                      .width(30 * this.ratio)
                      .aspectRatio(1)
                      .objectFit(ImageFit.Contain)
                    Text(`${this.coreData[item1 * 2 + item2].title}`)
                      .fontSize(15 * this.ratio)
                      .margin({ top: 5 })
                  }.onClick(() => {
                    router.pushUrl({
                      url: 'pages/detailPage/detail',
                    })
                  })
                }
                .width('100%')
              }, (item2: number) => JSON.stringify(item2))
            }
            .rowsTemplate('1fr 1fr')
            .columnsTemplate('1fr')
          }
          .width('22.5%')
        }, (item1: number) => JSON.stringify(item1))
      }
      .listDirection(Axis.Horizontal)
      .height('22%')
      .width('100%')
    }
  }
}