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
 * 服务的实现步骤
 * 1. 导入ble通讯相关库 access, ble, connection, constant。
 * 2. module.json5中配置USE_BLUETOOTH, DISCOVER_BLUETOOTH, ACCESS_BLUETOOTH 权限
 * 3. 心率模拟定时器事件中，调用advertiserBluetoothViewModel.notifyCharacteristicChanged(this.deviceId, this.heartRate)将当前随机心率广播给连接到服务器的ble客户端。
 */

import promptAction from '@ohos.promptAction';
import { access, ble, connection, constant } from '@kit.ConnectivityKit';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import ArrayBufferUtils from '../utils/ArrayBufferUtils';
import BleConstants from '../constants/BleConstants';
import DurationConstants from '../constants/DurationConstants.ts';
import Log from '../utils/Log';

const TAG = '[Sample_AdvertiserBluetooth]';

// 特征接口
interface CharacteristicModel {
  serviceUuid: string,
  characteristicUuid: string,
  characteristicValue: ArrayBufferLike,
  descriptors: Array<ble.BLEDescriptor>;
}

interface NotifyCharacteristicModel {
  serviceUuid: string,
  characteristicUuid: string,
  characteristicValue: ArrayBufferLike,
  confirm: boolean;
}


export class AdvertiserBluetoothViewModel {
  // 蓝牙服务端，提供数据给连接的客户端设备
  private mGattServer!: ble.GattServer;

  /**
   * 蓝牙功能是否可用
   */
  isBluetoothEnabled(): boolean {
    Log.showInfo(TAG, `isBluetoothEnabled`);
    const state: access.BluetoothState = access.getState();
    Log.showInfo(TAG, `isBluetoothEnabled: state = ${state}`);
    if (state === access.BluetoothState.STATE_ON || state === access.BluetoothState.STATE_TURNING_ON) {
      return true;
    }
    return false;
  }

  /**
   * 开启蓝牙功能
   */
  enableBluetooth(): void {
    Log.showInfo(TAG, `enableBluetooth`);
    try {
      this.onBTStateChange();
      access.enableBluetooth();
    } catch (err) {
      Log.showError(TAG, `enableBluetooth: err = ${err}`);
    }
  }

  /**
   * 关闭蓝牙功能
   */
  disableBluetooth(): void {
    Log.showInfo(TAG, `disableBluetooth`);
    try {
      this.offBTStateChange();
      access.disableBluetooth();
    } catch (err) {
      Log.showError(TAG, `disableBluetooth: err = ${err}`);
    }
  }

  /**
   * 获取蓝牙名称
   */
  getLocalName(): string {
    let localName = '';
    try {
      localName = connection.getLocalName();
      Log.showInfo(TAG, `getLocalName: localName = ${localName}`);
    } catch (err) {
      Log.showError(TAG, `getLocalName: err = ${err}`);
    }
    return localName;
  }

  /**
   * 启动蓝牙广播服务
   */
  startAdvertiser(): boolean {
    Log.showInfo(TAG, `startAdvertiser`);

    if (!this.isBluetoothEnabled()) {
      Log.showInfo(TAG, `startBLEScan: bluetooth is disable.`);
      this.enableBluetooth();
      promptAction.showToast({
        message: $r('app.string.ble_toast_enable_bluetooth'),
        duration: DurationConstants.DURATION_TIME
      });
      return false;
    }
    // TODO: 知识点 创建蓝牙服务实例
    this.mGattServer = ble.createGattServer();

    let descriptors: Array<ble.BLEDescriptor> = [];
    const arrayBuffer = ArrayBufferUtils.byteArray2ArrayBuffer([11]);
    const descriptor: ble.BLEDescriptor = {
      serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE, //  特定服务（service）的 UUID
      characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT, // 特定特征（characteristic）的 UUID
      descriptorUuid: BleConstants.UUID_DESCRIPTOR_HEART_RATE, // 描述符（descriptor）的 UUID
      descriptorValue: arrayBuffer  // 描述符对应的二进制值
    };
    descriptors[0] = descriptor;

    let characteristics: Array<ble.BLECharacteristic> = [];
    const arrayBufferC = ArrayBufferUtils.byteArray2ArrayBuffer([1]);
    const characteristic: ble.BLECharacteristic = {
      serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE, // 特定服务（service）的 UUID
      characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT, // 特定特征（characteristic）的 UUID
      characteristicValue: arrayBufferC, // 特征对应的二进制值
      descriptors: descriptors  // 特定特征的描述符列表
    };
    characteristics[0] = characteristic;
    // 定义心率跳动服务
    const service: ble.GattService = {
      serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
      isPrimary: true, // 主服务
      characteristics: characteristics,
      includeServices: []
    };

    try {
      // 添加服务
      this.mGattServer.addService(service);
      Log.showInfo(TAG, `startAdvertiser: addService suc`);
    } catch (err) {
      Log.showError(TAG, `startAdvertiser: addService err = ${err}`);
    }

    try {
      // 订阅连接服务状态
      this.onConnectStateChange();

      // 设置广播发送的参数
      let setting: ble.AdvertiseSetting = {
        interval: DurationConstants.ADVERTISE_INTERVAL, // 广播间隔，最小值设置160个slot表示100ms
        txPower: 1, // 发送功率，最小值设置-127，最大值设置1，默认值设置-7
        connectable: true  // 是否是可连接广播
      };
      // BLE广播包内容
      let advData: ble.AdvertiseData = {
        serviceUuids: [BleConstants.UUID_SERVICE_HEART_RATE], // 要广播的服务 UUID 列表
        manufactureData: [], // 广播的制造商信息列表
        serviceData: [], // 广播的服务数据列表
      };
      // BLE回复扫描请求回复响应
      let advResponse: ble.AdvertiseData = {
        serviceUuids: [BleConstants.UUID_SERVICE_HEART_RATE],
        manufactureData: [],
        serviceData: [],
      };
      // TODO: 知识点 开始广播
      ble.startAdvertising(setting, advData, advResponse);
      Log.showInfo(TAG, `startAdvertiser: startAdvertising success`);
      return true;
    } catch (err) {
      Log.showError(TAG, `startAdvertiser: startAdvertising err = ${err}`);
    }
    return false;
  }

  /**
   * 停止蓝牙广播服务
   */
  stopAdvertiser(): void {
    Log.showInfo(TAG, `stopAdvertiser`);
    if (this.mGattServer) {
      try {
        this.offConnectStateChange();
        // TODO: 知识点 停止蓝牙广播服务
        ble.stopAdvertising();
      } catch (err) {
        Log.showError(TAG, `stopAdvertiser: startAdvertising err = ${err}`);
      }
    } else {
      Log.showWarn(TAG, `stopAdvertiser: mGattServer is null`);
    }
  }

  /**
   * 通知链接的客户端特征值发生变化
   */
  notifyCharacteristicChanged(deviceId: string, heartRate: number) {
    Log.showInfo(TAG, `notifyCharacteristicChanged: deviceId = ${deviceId}, heartRate = ${heartRate}`);

    if (!deviceId) {
      Log.showWarn(TAG, `deviceId is null`);
      return;
    }

    if (this.mGattServer) {
      try {
        let descriptors: Array<ble.BLEDescriptor> = [];
        let arrayBuffer = ArrayBufferUtils.byteArray2ArrayBuffer([11]);
        // 构造BLEDescriptor
        let descriptor: ble.BLEDescriptor = {
          serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
          characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
          descriptorUuid: BleConstants.UUID_DESCRIPTOR_HEART_RATE,
          descriptorValue: arrayBuffer
        };
        descriptors[0] = descriptor;
        // 构造BLECharacteristic
        let arrayBufferC = ArrayBufferUtils.byteArray2ArrayBuffer([0x00, heartRate]);
        let characteristic: CharacteristicModel = {
          serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
          characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
          characteristicValue: arrayBufferC,
          descriptors: descriptors
        };
        // 通知的特征值消息
        let notifyCharacteristic: NotifyCharacteristicModel = {
          serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
          characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
          characteristicValue: characteristic.characteristicValue,
          confirm: false  // 对端不需要确认
        };
        // TODO: 知识点 server端特征值发生变化时，主动通知已连接的client设备。
        this.mGattServer.notifyCharacteristicChanged(deviceId, notifyCharacteristic, (err: BusinessError) => {
          if (err) {
            Log.showError(TAG,
              'notifyCharacteristicChanged callback failed， err.code = ' + err.code + ", err.message =" + err.message);
          } else {
            Log.showInfo(TAG, 'notifyCharacteristicChanged callback success');
          }
        });
      } catch (err) {
        Log.showError(TAG, `notifyCharacteristicChanged: notifyCharacteristicChanged err = ${err}`);
      }
    } else {
      Log.showWarn(TAG, `notifyCharacteristicChanged: mGattServer is null`);
    }
  }

  /**
   * 订阅蓝牙设备开关状态事件
   */
  private onBTStateChange() {
    Log.showInfo(TAG, `onBTStateChange`);
    try {
      access.on('stateChange', (data: access.BluetoothState) => {
        Log.showInfo(TAG, `onBTStateChange: data = ${data}`);
        if (data === access.BluetoothState.STATE_ON) {
          AppStorage.setOrCreate('bluetoothEnable', true);
          this.startAdvertiser();
        }
        if (data === access.BluetoothState.STATE_OFF) {
          AppStorage.setOrCreate('bluetoothEnable', false);
        }
      });
    } catch (err) {
      Log.showError(TAG, `onBTStateChange: err = ${err}`);
    }
  }

  /**
   * 取消订阅蓝牙设备开关状态事件
   */
  private offBTStateChange() {
    Log.showInfo(TAG, `offBTStateChange`);
    try {
      access.off('stateChange');
    } catch (err) {
      Log.showError(TAG, `offBTStateChange: err = ${err}`);
    }
  }

  /**
   *  订阅连接状态变化事件
   */
  private onConnectStateChange() {
    Log.showInfo(TAG, `onConnectStateChange`);
    if (!this.mGattServer) {
      Log.showInfo(TAG, `onConnectStateChange: mGattServer is null`);
      return;
    }

    try {
      this.mGattServer.on('connectionStateChange', async (data: ble.BLEConnectionChangeState) => {
        Log.showInfo(TAG, `onConnectStateChange: data = ${JSON.stringify(data)}`);
        if (data) {
          if (data.state === constant.ProfileConnectionState.STATE_CONNECTED) {
            Log.showInfo(TAG, `onConnectStateChange: Connected GATT Device.`);
            let deviceId = data.deviceId;
            AppStorage.setOrCreate('deviceId', deviceId);
            Log.showInfo(TAG, `onConnectStateChange: Connected GATT Device. deviceId = ${deviceId}`);
          } else if (data.state === constant.ProfileConnectionState.STATE_DISCONNECTED) {
            Log.showInfo(TAG, `onConnectStateChange: Disonnected GATT Device.`);
            AppStorage.setOrCreate('deviceId', '');
          }
        }
      });
    } catch (err) {
      Log.showError(TAG, `onConnectStateChange: err = ${err}`);
    }
  }

  /**
   *  取消订阅连接状态变化事件
   */
  private offConnectStateChange() {
    Log.showInfo(TAG, `offConnectStateChange`);
    if (!this.mGattServer) {
      Log.showInfo(TAG, `offConnectStateChange: mGattServer is null`);
      return;
    }

    try {
      this.mGattServer.off('connectionStateChange');
    } catch (err) {
      Log.showError(TAG, `offConnectStateChange: err = ${err}`);
    }
  }
}

let advertiserBluetoothViewModel = new AdvertiserBluetoothViewModel();

export default advertiserBluetoothViewModel as AdvertiserBluetoothViewModel;