/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { AppRouter, DynamicsRouter } from 'routermodule';

@AppRouter({ name: "bluetooth/BluetoothView" })
@Component
export struct BluetoothView {
  build() {
    Column() {
      Button($r('app.string.ble_btn_client_page'))
        .id('btn_ble_client')
        .onClick((event: ClickEvent) => {
          DynamicsRouter.pushUri('bluetooth/BluetoothClient');
        })
        .width('50%')

      Button($r('app.string.ble_btn_server_page'))
        .id('btn_ble_server')
        .onClick((event: ClickEvent) => {
          DynamicsRouter.pushUri('bluetooth/BluetoothAdvertiser');
        })
        .width('50%')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
  }
}
