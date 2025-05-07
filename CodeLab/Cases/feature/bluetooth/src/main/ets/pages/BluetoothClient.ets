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
 * 1. 搜索开启了心率跳动服务的蓝牙设备。
 * 2. 连接搜索到的蓝牙设备。
 * 3. 进入已连接的蓝牙设备，查看收到的实时心率值并进行绘制。
 */

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import { AppRouter, DynamicsRouter } from 'routermodule';
import bluetoothViewModel, { ConnectionState } from '../viewmodel/BluetoothClientModel';
import BluetoothDevice from '../model/BluetoothDevice';
import Log from '../utils/Log';
import EmptyPage from '../uicomponents/EmptyPage';
import NavigationBar from '../uicomponents/NavigationBar';
import StyleConstants from '../constants/StyleConstants';

const TAG = '[Sample_BluetoothManager]';
const LIST_SPACE: number = 20;

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

@AppRouter({ name: "bluetooth/BluetoothClient" })
@Component
export struct BluetoothClient {
  @StorageLink('availableDevices') @Watch('onAvailableDevicesChange') availableDevices: Array<BluetoothDevice> =
    []; // 扫描出来的可连接设备
  @StorageLink('connectBluetoothDevice') @Watch('onConnectBluetoothDeviceChange') connectBluetoothDevice: BluetoothDevice =
    {}; // 已连接设备
  @State connectBluetoothDevice1: BluetoothDevice = {}; // 当前连的设备

  /**
   * 可用设备变化事件
   */
  onAvailableDevicesChange(): void {
    Log.showInfo(TAG, `onAvailableDevicesChange: availableDevices = ${JSON.stringify(this.availableDevices)}`);
  }

  /**
   * 连接设备变化事件
   */
  onConnectBluetoothDeviceChange(): void {
    Log.showInfo(TAG,
      `onConnectBluetoothDeviceChange: connectBluetoothDevice = ${JSON.stringify(this.connectBluetoothDevice)}`);
    this.connectBluetoothDevice1 = this.connectBluetoothDevice;
  }

  /**
   * 当前页面可见时恢复竖屏显示
   */
  async onPageShow(): Promise<void> {
    Log.showInfo(TAG, `BluetoothView onPageShow`);
    await globalThis.setOrientation(window.Orientation.UNSPECIFIED);
  }

  aboutToAppear() {
    // TODO 知识点： 获取蓝牙权限
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    reqPermissionsFromUser(PERMISSION_LIST, context);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `BluetoothView aboutToDisappear`);
    bluetoothViewModel.close();
  }

  build() {
    Column() {
      NavigationBar({ title: $r('app.string.ble_title_main'), showIndicator: false })
        .height(StyleConstants.HEIGHT_NAVIGATION_BAR)
      // 有可用ble设备时显示可用设备界面，否则显示无设备页面
      if (this.availableDevices && this.availableDevices.length > 0) {
        List({ space: LIST_SPACE, initialIndex: 0 }) {
          ForEach(this.availableDevices as BluetoothDevice[], (item: BluetoothDevice, index: number) => {
            ListItem() {
              if (item.deviceId === this.connectBluetoothDevice1.deviceId) {
                Item({
                  bluetoothDevice: this.connectBluetoothDevice1 as BluetoothDevice,
                  index: index
                })
              } else {
                Item({
                  bluetoothDevice: item as BluetoothDevice,
                  index: index
                })
              }
            }
            .id('item_ble_list')
            .width('100%')
            .height($r('app.integer.ble_height_list'))
            .borderRadius($r('app.integer.ble_border_list_item'))
            .backgroundColor($r('app.color.ble_bg_white'))
          })
        }
        .scrollBar(BarState.Auto)
        .width('100%')
        .height('100%')
        .layoutWeight(1)
        .padding({
          left: $r('app.integer.ble_border_list_item'),
          top: $r('app.integer.ble_border_list_item'),
          right: $r('app.integer.ble_border_list_item'),
          bottom: 0
        })
      } else {
        EmptyPage({ img: $r('app.media.bg_empty_page'), message: $r('app.string.ble_tv_no_device') })
          .width('100%')
          .height('100%')
          .layoutWeight(1)
      }
      // 搜索设备
      Row() {
        Button($r('app.string.ble_btn_start_scan_be'))
          .id('btn_start_scan')
          .fontSize($r('app.float.ble_text_size_medium'))
          .onClick(() => {
            const ret = bluetoothViewModel.startBLEScan();
            if (!ret) {
              Log.showError(TAG, `startBLEScan: ret = ${ret}`);
            }
          })
          .width($r('app.integer.ble_search_width'))
      }
      .width('100%')
      .height($r('app.integer.ble_search_height'))
      .margin({ bottom: $r('app.integer.ble_search_margin') })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.ble_bg_main'))
  }
}

@Component
struct Item {
  @ObjectLink bluetoothDevice: BluetoothDevice;
  private index: number = 0;

  getConnectionStateDescription(): ResourceStr {
    let description = $r('app.string.ble_btn_connect')
    switch (this.bluetoothDevice.connectionState) {
      case ConnectionState.STATE_CONNECTING:
        description = $r('app.string.ble_btn_connecting');
        break;
      case ConnectionState.STATE_DISCONNECTING:
        description = $r('app.string.ble_btn_disconnecting');
        break;
      case ConnectionState.STATE_DISCONNECTED:
        description = $r('app.string.ble_btn_connect');
        break;
    }
    return description;
  }

  async aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear: bluetoothDevice = ${JSON.stringify(this.bluetoothDevice)}`);
    // 主页竖屏显示
    await globalThis.setOrientation(window.Orientation.UNSPECIFIED);
  }

  build() {
    Row() {
      Column() {
        Text(this.bluetoothDevice.deviceName)
          .fontSize($r('app.float.ble_text_size_big'))
          .fontColor($r('app.color.ble_text_color_primary'))
        Text(this.bluetoothDevice.deviceId)
          .fontSize($r('app.float.ble_text_size_normal'))
          .fontColor($r('app.color.ble_text_color_tertiary'))
          .margin({ top: $r('app.integer.ble_text_margin') })
      }
      .margin({ left: $r('app.integer.ble_main_margin') })
      .alignItems(HorizontalAlign.Start)

      Button(this.getConnectionStateDescription())
        .id(`btn_connect${this.index}`)
        .fontSize($r('app.float.ble_text_size_medium'))
        .fontColor($r('app.color.ble_color_accent'))
        .backgroundColor(this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED ?
        $r('app.color.ble_bg_transparent') : $r('app.color.ble_btn_grey'))
        .padding({ left: $r('app.integer.ble_connect_padding'), right: $r('app.integer.ble_connect_padding') })
        .margin({ right: $r('app.integer.ble_main_margin') })
        .visibility(this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED ? Visibility.None :
        Visibility.Visible)
        .onClick(() => {
          if (this.bluetoothDevice.connectionState === ConnectionState.STATE_DISCONNECTED) {
            // 连接蓝牙设备
            bluetoothViewModel.connect(this.bluetoothDevice);
          } else if (this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED) {
            // 断开与蓝牙设备的连接
            bluetoothViewModel.disconnect();
          }
        })

      Row() {
        Text($r('app.string.ble_btn_connected'))
          .fontSize($r('app.float.ble_text_size_medium'))
          .fontColor($r('app.color.ble_text_color_tertiary'))
          .margin({ right: $r('app.integer.ble_text_margin') })

        Image($r('app.media.ic_public_arrow_right'))
          .objectFit(ImageFit.Contain)
          .width($r('app.integer.ble_image_right_size'))
          .height($r('app.integer.ble_image_right_size'))
      }
      .margin({ right: $r('app.integer.ble_main_margin') })
      .visibility(this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED ? Visibility.Visible :
      Visibility.None)
    }
    .id(`list_item${this.index}`)
    .width('100%')
    .height('100%')
    .padding({
      left: $r('app.integer.ble_list_item_left_padding'),
      top: $r('app.integer.ble_list_item_top_padding'),
      right: $r('app.integer.ble_list_item_left_padding'),
      bottom: $r('app.integer.ble_list_item_top_padding')
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(async () => {
      // 设备已连接的话，进入到数据通信展示的心率界面
      if (this.bluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED) {
        DynamicsRouter.pushUri('bluetooth/HeartRate');
      }
    })
  }
}