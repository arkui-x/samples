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

import { SecondLevelCategory, ThirdLevelCategory } from '../model/CategoricalDataType';
import { ThirdLevelNavigation } from './ThirdLevelNavigation';

@Extend(Column)
function ColumnStyle() {
  .width('100%')
  .borderRadius(24)
  .backgroundColor(Color.White)
  .padding({
    left: 12,
    right: 12,
    bottom: 4,
    top: 4
  })
}

@Component
export struct TabContentNavigation {
  private categories: ThirdLevelCategory[] | SecondLevelCategory[] = new Array<ThirdLevelCategory>();

  hasSecondLevelCategory(category: ThirdLevelCategory | SecondLevelCategory): boolean {
    return category && category.image ? false : true;
  }

  build() {
    Column() {
      List() {
        if (this.hasSecondLevelCategory(this.categories[0])) {
          ForEach(this.categories, (secondLevelCategory: SecondLevelCategory, secondLevelCategoryIndex: number) => {
            ListItem() {
              Column() {
                Text(secondLevelCategory.title)
                  .height(48)
                  .fontSize(14)
                  .width('100%')
                  .textAlign(TextAlign.Start)
                  .fontFamily('HarmonyHeiTi-Medium')
                  .fontColor($r('app.color.font_color_shallow'))
                  .padding({ bottom: 4, top: 4, left: 24 })

                Column() {
                  ForEach(secondLevelCategory.childNodes, (thirdLevelCategory: ThirdLevelCategory, thirdLevelCategoryIndex: number) => {
                    ThirdLevelNavigation({
                      thirdLevelCategory: thirdLevelCategory,
                      secondLevelCategoryIndex: secondLevelCategoryIndex,
                      ThirdLevelNavigationIndex: thirdLevelCategoryIndex
                    })
                  })
                }
                .ColumnStyle()
              }
            }
          })
        } else {
          ForEach(this.categories, (thirdLevelCategory: ThirdLevelCategory) => {
            ListItem() {
              Column() {
                ThirdLevelNavigation({ thirdLevelCategory: thirdLevelCategory })
              }
              .ColumnStyle()
            }
            .margin({ top: 6, bottom: 6 })
          })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 4 })

      Blank()
    }
    .height('100%')
    .padding({ top: 12 })
  }
}