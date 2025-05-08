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
export struct SubmitComp {
  build() {
    Row() {
      Column() {
        Text() {
          Span(CommonConstants.PRICE_MOUNT)
            .fontSize(14)
            .fontColor('#999')
          Span(CommonConstants.PRICE_AMOUNT)
            .fontSize(14)
          Span(CommonConstants.PRICE_ICON)
            .fontSize(14)
            .fontColor('#FF3A00')
          Span(CommonConstants.PRICE_FIRST)
            .fontSize(24)
            .fontColor('#FF3A00')
          Span(CommonConstants.PRICE_LAST)
            .fontSize(12)
            .fontColor('#FF3A00')
        }
        .lineHeight(30)
        .fontWeight(FontWeight.Bold)

        Text(CommonConstants.REDUCE)
          .fontSize(14)
          .fontColor('#FE4C12')
      }
      .padding({ right: 10 })
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)

      Button(CommonConstants.SUBMIT_ORDER)
        .width('30%')
        .backgroundColor('#FF4400')
    }
    .expandSafeArea([SafeAreaType.SYSTEM])
    .padding(10)
    .backgroundColor('#FEFEFE')
    .width('100%')
  }
}