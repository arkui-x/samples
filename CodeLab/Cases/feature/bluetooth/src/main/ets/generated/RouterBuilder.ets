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

// auto-generated
import { DynamicsRouter, AppRouterInfo } from 'routermodule/Index';
import { BluetoothView } from '../pages/BluetoothView'
import { HeartRate } from '../pages/HeartRate'
import { BluetoothAdvertiser } from '../pages/BluetoothAdvertiser'
import { BluetoothClient } from '../pages/BluetoothClient'

@Builder
function bluetoothViewBuilder() {
  BluetoothView();
}

export function bluetoothViewRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(bluetoothViewBuilder));
}

@Builder
function heartRateBuilder() {
  HeartRate();
}

export function heartRateRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(heartRateBuilder));
}

@Builder
function bluetoothAdvertiserBuilder() {
  BluetoothAdvertiser();
}

export function bluetoothAdvertiserRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(bluetoothAdvertiserBuilder));
}

@Builder
function bluetoothClientBuilder() {
  BluetoothClient();
}

export function bluetoothClientRegister(routerInfo: AppRouterInfo) {
  DynamicsRouter.registerAppRouterPage(routerInfo, wrapBuilder(bluetoothClientBuilder));
}

