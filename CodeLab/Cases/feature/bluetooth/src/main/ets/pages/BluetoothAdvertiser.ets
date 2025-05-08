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

/**
 * 实现步骤
 * 1. 当前蓝牙状态是关闭时，点击按钮，调用advertiserBluetoothViewModel.startAdvertiser()开启蓝牙服务，同时打开心率模拟定时器。
 * 2. 当前蓝牙状态是开启时，点击按钮，调用advertiserBluetoothViewModel.stopAdvertiser()关闭蓝牙服务，同时关闭心率模拟定时器。
 * 3. 心率模拟定时器事件中，调用advertiserBluetoothViewModel.notifyCharacteristicChanged(this.deviceId, this.heartRate)将当前心率广播给连接到服务器的ble客户端。
 */

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import advertiserBluetoothViewModel from '../viewmodel/AdvertiserBluetoothViewModel';
import common from '@ohos.app.ability.common';
import DurationConstants from '../constants/DurationConstants.ts';
import Log from '../utils/Log';
import MathUtils from '../utils/MathUtils';
import { AppRouter } from 'routermodule';

const TAG = '[Sample_AdvertiserBluetooth]';
const MIN_HEART_RATE = 40; // 最小心率
const MAX_HEART_RATE = 200; // 最大心率

// 所需蓝牙权限
const PERMISSION_LIST: Array<Permissions> = [
  'ohos.permission.APPROXIMATELY_LOCATION',
  'ohos.permission.LOCATION',
  'ohos.permission.ACCESS_BLUETOOTH'
];

// TODO 知识点： 获取蓝牙相关权限
function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    const granStatus: Array<number> = data.authResults;
    const length: number = granStatus.length;
    for (let i = 0; i < length; i++) {
      if (granStatus[i] === 0) {

      } else {
        return;
      }
    }
  })
}

@AppRouter({ name: "bluetooth/BluetoothAdvertiser" })
@Component
export struct BluetoothAdvertiser {
  @StorageLink('deviceId') @Watch('onDeviceIdChange') deviceId: string = '';
  @StorageLink('bluetoothEnable') @Watch('onBluetoothEnableChange') bluetoothEnable: boolean = false;
  @State localName: string = '';
  @State heartRate: number = -1;
  @State startAdvertiserState: boolean = false; // 心率广播状态
  private mIntervalId: number = -1; // 定时器id

  /**
   * DeviceId变动事件
   */
  onDeviceIdChange(): void {
    Log.showInfo(TAG, `onDeviceIdChange: deviceId = ${this.deviceId}`);
  }

  /**
   * 侦听蓝牙状态变化
   */
  onBluetoothEnableChange(): void {
    Log.showInfo(TAG, `onBluetoothEnableChange: bluetoothEnable = ${this.bluetoothEnable}`);
    if (this.bluetoothEnable) {
      this.toggleAdvertiser();
    }
  }

  /**
   * 开启或关闭心率广播
   */
  toggleAdvertiser(): void {
    Log.showInfo(TAG, `toggleAdvertiser: startAdvertiserState = ${this.startAdvertiserState}`)
    if (this.startAdvertiserState) {
      //  TODO: 知识点 关闭蓝牙服务
      advertiserBluetoothViewModel.stopAdvertiser();
      this.toggleHeartRate(false);
      this.startAdvertiserState = false;
    } else {
      //  TODO: 知识点 开启蓝牙服务
      let ret = advertiserBluetoothViewModel.startAdvertiser();
      if (ret) {
        this.localName = advertiserBluetoothViewModel.getLocalName();
        // 模拟心率跳动
        this.toggleHeartRate(true);
        this.startAdvertiserState = true;
      } else {
        Log.showError(TAG, `toggleAdvertiser: ret = ${ret}`);
      }
    }
  }

  /**
   * 切换心率
   */
  toggleHeartRate(open: boolean): void {
    Log.showInfo(TAG, `toggleHeartRate: open = ${open}, deviceId = ${this.deviceId}`);
    clearInterval(this.mIntervalId);
    if (open) {
      this.mIntervalId = setInterval(() => {
        this.heartRate = MathUtils.getRandomInt(MIN_HEART_RATE, MAX_HEART_RATE);
        if (this.deviceId) {
          // TODO: 知识点 通知客户端心率特征值变动
          advertiserBluetoothViewModel.notifyCharacteristicChanged(this.deviceId, this.heartRate);
        } else {
          Log.showWarn(TAG, `toggleHeartRate: deviceId is null， heartRate = ${this.heartRate}`);
        }
      }, DurationConstants.NOTIFY_DELAY_TIME)
    }
  }

  aboutToAppear() {
    // TODO 知识点： 获取蓝牙权限
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    reqPermissionsFromUser(PERMISSION_LIST, context);
  }

  aboutToDisappear(): void {
    Log.showInfo(TAG, `aboutToDisappear`);
    advertiserBluetoothViewModel.stopAdvertiser();
  }

  build() {
    Column() {
      Row() {
        Button(this.startAdvertiserState ? $r('app.string.ble_btn_stop_advertiser') :
        $r('app.string.ble_btn_start_advertiser'))
          .id('btn_start_ble_server')
          .onClick(() => {
            this.toggleAdvertiser();
          })
      }
      .justifyContent(FlexAlign.SpaceAround)

      Text($r('app.string.ble_text_bluetooth_name', this.localName === '' ? '-' : this.localName))
        .fontSize($r('app.float.ble_text_size_master'))
        .fontWeight(FontWeight.Bold)

      Row() {
        Text($r('app.string.ble_text_heart_rate_current'))
          .fontSize($r('app.float.ble_text_size_master'))
          .width($r('app.string.ble_half_width'))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.End)
          .align(Alignment.Start)
        Text((this.heartRate === -1 ? '-' : this.heartRate.toString()) + 'bpm')
          .id('txt_heartRate')
          .fontSize($r('app.float.ble_text_size_master'))
          .fontWeight(FontWeight.Bold)
          .align(Alignment.Start)
          .alignSelf(ItemAlign.Start)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.SpaceAround)
  }
}