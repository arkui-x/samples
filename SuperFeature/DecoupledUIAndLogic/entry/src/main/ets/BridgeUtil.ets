/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import bridge from '@arkui-x.bridge';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import deviceInfo from '@ohos.deviceInfo';

const LOG_TAG: string = '[Test][ArkTS][BridgeUtil]::  '

export class BridgeUtil {
  private bridgeObject: bridge.BridgeObject
  private static instance: BridgeUtil = new BridgeUtil('BridgeObject', bridge.BridgeType.JSON_TYPE)

  private constructor(name: string, bridgeType: bridge.BridgeType) {
    this.bridgeObject = bridge.createBridge(name, bridgeType)
    this.registerMethod()
  }

  private registerMethod() {
    this.bridgeObject.registerMethod({ name: 'getDeviceInfo', method: this.getDeviceInfo }, (error: BusinessError) => {
      if (error.code != 0) {
        console.error(LOG_TAG + 'registerMethod func failed; func name is (getDeviceInfo); error is ' + JSON.stringify(error))
        return
      }
    })
  }

  public static getInstance(): BridgeUtil {
    return BridgeUtil.instance
  }

  public getBridge(): bridge.BridgeObject {
    return this.bridgeObject
  }

  protected getDeviceInfo(): string {
    let deviceTypeInfo: string = deviceInfo.deviceType;
    let manufactureInfo: string = deviceInfo.manufacture;
    let brandInfo: string = deviceInfo.brand;
    let marketNameInfo: string = deviceInfo.marketName;
    let productSeriesInfo: string = deviceInfo.productSeries;
    let productModelInfo: string = deviceInfo.productModel;
    let productModelAliasInfo: string = deviceInfo.productModelAlias;
    let softwareModelInfo: string = deviceInfo.softwareModel;
    let hardwareModelInfo: string = deviceInfo.hardwareModel;
    let abiListInfo: string = deviceInfo.abiList;
    let securityPatchTagInfo: string = deviceInfo.securityPatchTag;
    let displayVersionInfo: string = deviceInfo.displayVersion;
    let incrementalVersionInfo: string = deviceInfo.incrementalVersion;
    let osReleaseTypeInfo: string = deviceInfo.osReleaseType;
    let osFullNameInfo: string = deviceInfo.osFullName;

    let data: string = `deviceTypeInfo:{${deviceTypeInfo}};` +
      `manufactureInfo:{${manufactureInfo}};` +
      `brandInfo:{${brandInfo}};` +
      `marketNameInfo:{${marketNameInfo}};` +
      `productSeriesInfo:{${productSeriesInfo}};` +
      `productModelInfo:{${productModelInfo}};` +
      `productModelAliasInfo:{${productModelAliasInfo}};` +
      `softwareModelInfo:{${softwareModelInfo}};` +
      `hardwareModelInfo:{${hardwareModelInfo}};` +
      `abiListInfo:{${abiListInfo}};` +
      `securityPatchTagInfo:{${securityPatchTagInfo}};` +
      `displayVersionInfo:{${displayVersionInfo}};` +
      `incrementalVersionInfo:{${incrementalVersionInfo}};` +
      `osReleaseTypeInfo:{${osReleaseTypeInfo}};` +
      `osFullNameInfo:{${osFullNameInfo}};`;

    return '[ArkTS]: (Native) call getDeviceInfo by callMethodSync success;\nThe result is :' + data
  }
}
