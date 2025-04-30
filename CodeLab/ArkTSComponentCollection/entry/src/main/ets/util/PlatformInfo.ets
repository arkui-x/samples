/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import deviceInfo from '@ohos.deviceInfo';

export enum PlatformTypeEnum {
  HARMONYOS = 'HarmonyOS Platform',
  ANDROID = 'Android Platform',
  IOS = 'iOS Platform',
  UNKNOWN = 'Unknown Platform'
}

/*
 * 获取当前设备的平台信息，并提供相关判断功能。
 *
 * 功能简介：
 * 1. `getPlatform()` 方法通过解析设备的操作系统全名，判断当前设备运行的操作系统类型。
 *    - 支持的平台类型包括：HarmonyOS、Android、iOS，以及其他未知平台（UNKNOWN）。
 * 2. `isArkUIX()` 方法用于判断当前平台是否支持 ArkUIX 框架。
 *    - 如果设备运行的是 Android 或 iOS 平台，则返回 `true`，否则返回 `false`。
 */
export class PlatformInfo {
  static getPlatform(): PlatformTypeEnum {
    let osFullNameInfo: string = deviceInfo.osFullName;
    let platformName: string = osFullNameInfo.split(' ')[0];
    if (platformName.includes("OpenHarmony")) {
      return PlatformTypeEnum.HARMONYOS;
    } else if (platformName.includes("Android")) {
      return PlatformTypeEnum.ANDROID;
    } else if (platformName.includes('iOS')) {
      return PlatformTypeEnum.IOS;
    } else {
      return PlatformTypeEnum.UNKNOWN;
    }
  }

  static isArkUIX(): boolean {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.ANDROID ||
      PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
      return true;
    } else {
      return false;
    }
  }
}