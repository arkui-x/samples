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

import { access, ble, constant } from '@kit.ConnectivityKit';
import promptAction from '@ohos.promptAction';
import util from '@ohos.util';
import ArrayBufferUtils from '../utils/ArrayBufferUtils';
import BleConstants from '../constants/BleConstants';
import DurationConstants from '../constants/DurationConstants.ts';
import BluetoothDevice from '../model/BluetoothDevice';
import Log from '../utils/Log';

const TAG = '[Sample_BluetoothManager]';

export class ConnectionState {
  static STATE_CONNECTING = 1;
  static STATE_CONNECTED = 2;
  static STATE_DISCONNECTING = 3;
  static STATE_DISCONNECTED = 4;
}

export class BluetoothClientModel {
  private mGattClientDevice!: ble.GattClientDevice | null;
  private mConnectBluetoothDevice: BluetoothDevice = {};
  private mAvailableDevices: BluetoothDevice[] = [];
  private mTimeoutID: number = -1;

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
  enableBluetooth() {
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
  disableBluetooth() {
    Log.showInfo(TAG, `disableBluetooth`);
    try {
      this.offBTStateChange();
      access.disableBluetooth();
    } catch (err) {
      Log.showError(TAG, `disableBluetooth: err = ${err}`);
    }
  }

  /**
   * 扫描设备
   */
  startBLEScan(): boolean {
    Log.showInfo(TAG, `startBleScan`);

    if (!this.isBluetoothEnabled()) {
      Log.showInfo(TAG, `startBLEScan: bluetooth is disable.`);
      // 启动蓝牙服务
      this.enableBluetooth();
      promptAction.showToast({
        message: $r('app.string.ble_toast_enable_bluetooth'),
        duration: DurationConstants.DURATION_TIME
      });
      return false;
    }
    // 订阅搜索蓝牙服务
    this.onBLEDeviceFind();
    // 扫描蓝牙设备
    const ret = this.startBLEScanInner();
    return ret;
  }

  /**
   * 停止扫描设备
   */
  stopBLEScan() {
    Log.showInfo(TAG, `stopBLEScan`);
    clearTimeout(this.mTimeoutID);
    this.offBLEDeviceFind();
    this.stopBLEScanInner();
  }

  /**
   * 连接设备
   */
  connect(bluetoothDevice: BluetoothDevice): boolean {
    Log.showInfo(TAG, `connect: bluetoothDevice = ${JSON.stringify(bluetoothDevice)}`);

    if (this.mGattClientDevice && this.mConnectBluetoothDevice &&
      this.mConnectBluetoothDevice.deviceId === bluetoothDevice.deviceId) {
      Log.showWarn(TAG, `Trying to use an existing ${JSON.stringify(bluetoothDevice.deviceId)} for connection.`);
      const ret: boolean = this.connectInner(this.mGattClientDevice);
      return ret;
    }

    this.close();

    this.mConnectBluetoothDevice = bluetoothDevice;
    AppStorage.setOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);

    this.mGattClientDevice = ble.createGattClientDevice(bluetoothDevice.deviceId);
    let ret: boolean = this.connectInner(this.mGattClientDevice);
    if (ret) {
      Log.showInfo(TAG, `Trying to create a new connection.`);
    } else {
      Log.showError(TAG, `Trying to create a new connection fail.`);
      this.close();
    }
    return ret;
  }

  /**
   * 断开连接
   */
  disconnect() {
    Log.showInfo(TAG, `disconnect`);
    this.disconnectInner(this.mGattClientDevice!);
  }

  close() {
    Log.showInfo(TAG, `close`);
    this.closeInner(this.mGattClientDevice!);
  }

  /**
   * 获取连接状态
   */
  getConnectionState(): number {
    Log.showInfo(TAG,
      `getConnectionState: mConnectBluetoothDevice.connectionState = ${JSON.stringify(this.mConnectBluetoothDevice.connectionState)}`);
    return this.mConnectBluetoothDevice.connectionState!;
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
          this.startBLEScan();
        } else if (data === access.BluetoothState.STATE_OFF) {
          this.mAvailableDevices = [];
          AppStorage.setOrCreate('availableDevices', this.mAvailableDevices);
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
   * 订阅查找蓝牙设备
   */
  private onBLEDeviceFind() {
    try {
      ble.on('BLEDeviceFind', (arr: Array<ble.ScanResult>) => {
        Log.showInfo(TAG, `onBLEDeviceFind: BLEDeviceFind arr.length = ${arr.length}, arr = ${JSON.stringify(arr)}`);

        let deviceId: string = arr[0].deviceId;
        let device = this.mAvailableDevices.find(availableDevice => {
          return availableDevice.deviceId === deviceId;
        })
        if (!device) {
          let data: ArrayBuffer = arr[0].data;
          let deviceName: string = util.TextDecoder.create('utf-8', {
            ignoreBOM: true
          }).decodeWithStream(new Uint8Array(data), { stream: false });
          Log.showInfo(TAG, `onBLEDeviceFind: deviceId = ${deviceId}, deviceName = ${deviceName}`);

          // deviceName里存在一些未知数据导致显示乱码，暂时使用deviceId替代
          deviceName = deviceId;
          this.mAvailableDevices.push(this.getDevice(deviceId, arr[0].deviceName));
          AppStorage.setOrCreate('availableDevices', this.mAvailableDevices);
        }
      })
    } catch (err) {
      Log.showError(TAG, `onBLEDeviceFind: err = ${err}`);
    }
  }

  /**
   * 取消订阅查找蓝牙设备
   */
  private offBLEDeviceFind() {
    try {
      ble.off('BLEDeviceFind');
    } catch (err) {
      Log.showError(TAG, `offBLEDeviceFind: err = ${err}`);
    }
  }

  /**
   * 订阅蓝牙低功耗设备的连接状态变化事件
   */
  private onBLEConnectionStateChange() {
    Log.showInfo(TAG, `onBLEConnectionStateChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `onBLEConnectionStateChange: mGattClientDevice is null`);
      return;
    }

    try {
      this.mGattClientDevice.on('BLEConnectionStateChange', async (data: ble.BLEConnectionChangeState) => {
        Log.showInfo(TAG, `onBLEConnectionStateChange: data = ${JSON.stringify(data)}`);
        let deviceId: string = data.deviceId;
        let state: constant.ProfileConnectionState = data.state;
        if (data) {
          if (state === constant.ProfileConnectionState.STATE_CONNECTED) {
            Log.showInfo(TAG, `onBLEConnectionStateChange: Connected GATT server.`);
            this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_CONNECTED;
            AppStorage.setOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);

            try {
              // connect success, Starts discovering services.
              let services: Array<ble.GattService> = await this.mGattClientDevice!.getServices();
              Log.showInfo(TAG, `onBLEConnectionStateChange: services = ${JSON.stringify(services)}`);

              // Characteristic enable/disable indicate/notify
              let service: ble.GattService | undefined =
                services.find(item => item.serviceUuid === BleConstants.UUID_SERVICE_HEART_RATE);
              let characteristics: Array<ble.BLECharacteristic> = service!.characteristics;
              let characteristic: ble.BLECharacteristic | undefined =
                characteristics.find(item => item.characteristicUuid ===
                BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT);
              Log.showInfo(TAG, `onBLEConnectionStateChange: characteristic = ${JSON.stringify(characteristic)}`);
              // TODO 知识点： 向服务端发送设置通知此特征值请求
              this.mGattClientDevice!.setCharacteristicChangeNotification(characteristic, true);
              let descriptors: Array<ble.BLEDescriptor> = characteristic!.descriptors;
              let descriptor: ble.BLEDescriptor | undefined =
                descriptors.find(item => item.descriptorUuid === BleConstants.UUID_DESCRIPTOR_HEART_RATE);
              Log.showInfo(TAG, `onBLEConnectionStateChange: descriptor = ${JSON.stringify(descriptor)}`);
              descriptor!.descriptorValue = ArrayBufferUtils.byteArray2ArrayBuffer([0x01, 0x00]);
              this.mGattClientDevice!.writeDescriptorValue(descriptor);
            } catch (err) {
              Log.showError(TAG, `onBLEConnectionStateChange: err = ${err}`);
            }

          } else if (state === constant.ProfileConnectionState.STATE_DISCONNECTED) {
            Log.showInfo(TAG, `onBLEConnectionStateChange: Disonnected GATT server.`);
            if (this.getConnectionState() === ConnectionState.STATE_CONNECTING) {
              Log.showWarn(TAG, `onBLEConnectionStateChange: Connect GATT server fail.`);
              this.close();
            } else if (this.getConnectionState() === ConnectionState.STATE_CONNECTED ||
              this.getConnectionState() === ConnectionState.STATE_DISCONNECTING) {
              Log.showWarn(TAG, `onBLEConnectionStateChange: Disconnected from GATT server.`);
              this.close();
            }
          }
        }
      })
    } catch (err) {
      Log.showError(TAG, `onBLEConnectionStateChange: err = ${err}`);
    }
  }

  /**
   * 取消订阅蓝牙低功耗设备的连接状态变化事件
   */
  private offBLEConnectionStateChange() {
    Log.showInfo(TAG, `offBLEConnectionStateChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `offBLEConnectionStateChange: mGattClientDevice is null`);
      return;
    }

    try {
      this.mGattClientDevice.off('BLEConnectionStateChange');
    } catch (err) {
      Log.showError(TAG, `offBLEConnectionStateChange: err = ${err}`);
    }
  }

  /**
   * 订阅服务端的特征值变化
   */
  private onBLECharacteristicChange() {
    Log.showInfo(TAG, `onBLECharacteristicChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `onBLECharacteristicChange: mGattClientDevice is null`);
      return;
    }
    // TODO 知识点： 订阅特征值变化事件
    this.mGattClientDevice.on('BLECharacteristicChange', (data: ble.BLECharacteristic) => {
      Log.showInfo(TAG, `onBLECharacteristicChange: data = ${JSON.stringify(data)}`);
      let characteristicValue: ArrayBuffer = data.characteristicValue;
      Log.showInfo(TAG,
        `onBLECharacteristicChange: characteristicValue.length = ${characteristicValue.byteLength}, characteristicValue = ${JSON.stringify(new Uint8Array(characteristicValue))}`);
      let byteArr = ArrayBufferUtils.arrayBuffer2ByteArray(characteristicValue);
      Log.showInfo(TAG, `byteArr = ${byteArr}`);
      let heartRate = byteArr[1];
      AppStorage.setOrCreate('heartRate', heartRate);
    })
  }

  /**
   * 取消订阅服务端的特征值变化
   */
  private offBLECharacteristicChange() {
    Log.showInfo(TAG, `offBLECharacteristicChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `offBLECharacteristicChange: mGattClientDevice is null`);
      return;
    }

    this.mGattClientDevice.off('BLECharacteristicChange');
  }

  /**
   * 扫描蓝牙设备
   */
  private startBLEScanInner(): boolean {
    try {
      this.mAvailableDevices = [];
      if (this.mConnectBluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED) {
        this.mAvailableDevices.push(this.mConnectBluetoothDevice);
      }
      AppStorage.setOrCreate('availableDevices', this.mAvailableDevices);
      // TODO: 知识点 根据过滤器扫描设备
      ble.startBLEScan([{ serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE }]);
      Log.showInfo(TAG, `startBLEScanInner: scan ble start`);
      this.mTimeoutID = setTimeout(() => {
        Log.showInfo(TAG, `startBLEScanInner: scan ble finished`);
        this.stopBLEScan();
      }, DurationConstants.SCAN_TIME);
      return true;
    } catch (err) {
      Log.showError(TAG, `startBLEScanInner: err = ${err}`);
    }
    return false;
  }

  /**
   * 停止扫描蓝牙设备
   */
  private stopBLEScanInner() {
    Log.showInfo(TAG, `stopBLEScanInner`);
    try {
      ble.stopBLEScan();
      Log.showInfo(TAG, `stopBLEScanInner: scan ble stop`);
    } catch (err) {
      Log.showError(TAG, `stopBLEScanInner: err = ${err}`);
    }
  }

  /**
   * 连接蓝牙设备
   */
  private connectInner(gattClientDevice: ble.GattClientDevice): boolean {
    Log.showInfo(TAG, `connectInner`);
    try {
      if (!gattClientDevice) {
        Log.showWarn(TAG, `connectInner: mGattClientDevice is null`);
        return false;
      }
      // 订阅连接状态改变消息
      this.onBLEConnectionStateChange();
      // 订阅特征值改变消息
      this.onBLECharacteristicChange();
      // 开始连接
      gattClientDevice.connect();
      this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_CONNECTING;
      AppStorage.setOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);
      return true;
    } catch (err) {
      Log.showError(TAG, `connectInner: err = ${err}`);
    }
    return false;
  }

  /**
   * 断开与蓝牙设备的连接
   */
  private disconnectInner(gattClientDevice: ble.GattClientDevice) {
    Log.showInfo(TAG, `disconnectInner`);
    try {
      if (!gattClientDevice) {
        Log.showWarn(TAG, `disconnectInner: mGattClientDevice is null`);
        return;
      }

      this.offBLEConnectionStateChange();
      this.offBLECharacteristicChange();
      if (this.getConnectionState() === ConnectionState.STATE_CONNECTING) {
        Log.showWarn(TAG, `disconnectInner: mConnectionState is ConnectionState.STATE_CONNECTING`);
        this.close();
      } else if (this.getConnectionState() === ConnectionState.STATE_CONNECTED) {
        Log.showWarn(TAG, `disconnectInner: mConnectionState is ConnectionState.STATE_CONNECTED`);
        gattClientDevice.disconnect();
        this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_DISCONNECTING;
        AppStorage.setOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);
        this.close();
      }
    } catch (err) {
      Log.showError(TAG, `disconnectInner: err = ${err}`);
    }
  }

  /**
   * 关闭客户端
   */
  private closeInner(gattClientDevice: ble.GattClientDevice) {
    Log.showInfo(TAG, `closeInner`);
    try {
      if (!gattClientDevice) {
        Log.showWarn(TAG, `closeInner: mGattClientDevice is null`);
        return;
      }
      gattClientDevice.close();
      Log.showWarn(TAG, `closeInner: gatt close`);
      this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_DISCONNECTED;
      AppStorage.setOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);
      this.release();
    } catch (err) {
      Log.showError(TAG, `closeInner: err = ${err}`);
    }
  }

  private release() {
    Log.showWarn(TAG, `release`);
    this.mGattClientDevice = null;
    this.mTimeoutID = -1;
  }

  /**
   * 获取设备信息
   */
  private getDevice(deviceId: string, deviceName: string): BluetoothDevice {
    Log.showInfo(TAG, `getDevice: deviceId = ${deviceId}, deviceName = ${deviceName}`);
    let device = new BluetoothDevice();
    device.deviceId = deviceId;
    device.deviceName = deviceName;
    Log.showInfo(TAG, `getDevice: device = ${JSON.stringify(device)}`);
    return device;
  }
}

let bluetoothClientModel = new BluetoothClientModel();

export default bluetoothClientModel as BluetoothClientModel;