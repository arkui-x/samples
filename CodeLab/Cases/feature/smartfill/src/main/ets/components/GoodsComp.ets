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
export struct GoodsComp {
  build() {
    Column() {
      Row() {
        Image($r("app.media.smart_fill_house_fill"))
          .height(28)
        Text(CommonConstants.SHOP_NAME)
          .font({ weight: FontWeight.Bold, size: 18 })
          .margin({ left: 5 })
          .width(CommonConstants.WIDTH_FULL)
      }
      .height(28)
      .margin({ left: 5, bottom: 10 })
      .alignItems(VerticalAlign.Bottom)

      Row() {
        Image($r("app.media.smart_fill_phone_image"))
          .height(CommonConstants.HEIGHT_FULL)
          .width(80)
          .backgroundColor(Color.White)
        Column() {
          Text(CommonConstants.GOODS_NAME)
            .font({ size: 16 })
            .margin({ bottom: 3 })
          Text(CommonConstants.TYPE_NAME)
            .font({ size: 16 })
            .fontColor('#999')
        }
        .height(CommonConstants.HEIGHT_FULL)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)

        Column() {
          Text(CommonConstants.PRICE_LOWER)
            .font({ size: 16 })
            .fontColor('#FF3A00')
            .margin({ bottom: 3 })
          Text(CommonConstants.PRICE_ORIGIN)
            .font({ size: 16 })
            .fontColor('#999')
        }
        .height(CommonConstants.HEIGHT_FULL)
        .alignItems(HorizontalAlign.End)
        .justifyContent(FlexAlign.Start)
      }
      .height(80)
      .width(CommonConstants.WIDTH_FULL)
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Counter() {
          Text(CommonConstants.GOODS_NUMBER)
        }
      }
      .justifyContent(FlexAlign.End)
      .width(CommonConstants.WIDTH_FULL)
    }
    .alignItems(HorizontalAlign.Start)
    .padding(15)
    .margin({ bottom: 10 })
    .backgroundColor('#FEFEFE')
    .borderRadius(10)
    .width(CommonConstants.WIDTH_FULL)
  }
}