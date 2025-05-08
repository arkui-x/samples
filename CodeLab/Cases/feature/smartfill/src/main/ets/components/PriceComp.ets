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
import { CommonConstants } from "../common/CommonConstants";

@Component
export struct PriceComp {
  build() {
    Column() {
      Text(CommonConstants.PRICE_DETAIL)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 10 })
      Row() {
        Text() {
          Span(CommonConstants.PRICE_AMOUNT1)
            .fontWeight(FontWeight.Bold)
          Span(CommonConstants.PRICE_AMOUNT2)
            .fontSize(14)
            .fontColor('#999')
        }

        Text(CommonConstants.PRICE_AMOUNT3)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 10, bottom: 10 })
      .width(CommonConstants.WIDTH_FULL)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(CommonConstants.PRICE_REDUCE1)
          .fontWeight(FontWeight.Bold)
        Text(CommonConstants.PRICE_REDUCE2)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF3A00')
      }
      .margin({ top: 10, bottom: 10 })
      .width(CommonConstants.WIDTH_FULL)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(CommonConstants.PRICE_ORIGIN1)
          .fontWeight(FontWeight.Bold)
        Text(CommonConstants.PRICE_ORIGIN2)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF3A00')
      }
      .margin({ top: 10, bottom: 10 })
      .width(CommonConstants.WIDTH_FULL)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(CommonConstants.PRICE_SHOP1)
          .fontWeight(FontWeight.Bold)
        Text(CommonConstants.PRICE_SHOP2)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FF3A00')
      }
      .margin({ top: 10, bottom: 10 })
      .width(CommonConstants.WIDTH_FULL)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(CommonConstants.PRICE_ALL1)
          .fontWeight(FontWeight.Bold)
        Text(CommonConstants.PRICE_ALL2)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ top: 10, bottom: 10 })
      .width(CommonConstants.WIDTH_FULL)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(15)
    .margin({ bottom: 10 })
    .backgroundColor('#FEFEFE')
    .borderRadius(10)
    .width(CommonConstants.WIDTH_FULL)
  }
}