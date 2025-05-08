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

import { CommonConstants } from '../common/CommonConstants';
import { Address } from '../components/Address';
import { AddressComp } from '../components/AddressComp';
import { AddressDetail } from '../components/AddressDetail';
import { GoodsComp } from '../components/GoodsComp';
import { PriceComp } from '../components/PriceComp';
import { SubmitComp } from '../components/SubmitComp';

@Component
export struct SmartFill {
  @State showAddressDetail: boolean = false;
  @State addressDetail: Address =
    new Address(CommonConstants.NAME, CommonConstants.PHONE, CommonConstants.ADDRESS, CommonConstants.DETAIL_ADDRESS);

  @Builder
  addressPanel() {
    AddressDetail({
      showAddressDetail: this.showAddressDetail,
      addressDetail: this.addressDetail
    })
  }

  build() {
    Column() {
      Column() {
        AddressComp({
          showAddressDetail: this.showAddressDetail,
          addressDetail: this.addressDetail
        })

        GoodsComp()

        PriceComp()
      }
      .padding(10)
      .layoutWeight(1)

      SubmitComp()
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor('#F5F5F5')
    .height(CommonConstants.HEIGHT_FULL)
    .width(CommonConstants.WIDTH_FULL)
    .bindSheet($$this.showAddressDetail, this.addressPanel())

  }
}