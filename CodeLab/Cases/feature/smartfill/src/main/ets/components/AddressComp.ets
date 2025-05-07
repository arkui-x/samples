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
import { Address } from "./Address";

@Component
export struct AddressComp {
  @Link addressDetail: Address;
  @Link showAddressDetail: boolean;

  build() {
    Row() {
      Row() {
        Image($r("app.media.smart_fill_local_fill"))
          .width(28)
        Column() {
          Text(this.addressDetail.detailAddress)
            .font({ weight: FontWeight.Bold, size: 18 })
            .margin({ bottom: 3 })
          Text(`${this.addressDetail.name} ${this.addressDetail.phone}`)
            .font({ size: 16 })
            .fontColor('#999')
        }
        .alignItems(HorizontalAlign.Start)
        .padding({ left: 5 })
      }

      Image($r("app.media.smart_fill_arrow_right"))
        .width(12)
    }
    .onClick(() => {
      this.showAddressDetail = true;
    })
    .padding(10)
    .margin({ bottom: 10 })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#FEFEFE')
    .borderRadius(10)
    .width(CommonConstants.WIDTH_FULL)
  }
}