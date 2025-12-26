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
import { JSON, util } from '@kit.ArkTS';
import deviceInfo from '@ohos.deviceInfo';
import http from '@ohos.net.http';
import { relationalStore, ValuesBucket } from '@kit.ArkData';

const LOG_TAG: string = '[Test][ArkTS][BridgeUtil]::  '

export class BridgeUtil {
  private bridgeObject: bridge.BridgeObject
  private rdbStore: relationalStore.RdbStore | undefined = undefined
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
    this.bridgeObject.registerMethod({ name: 'requestBaidu', method: this.requestBaidu }, (error: BusinessError) => {
      if (error.code != 0) {
        console.error(LOG_TAG + 'registerMethod func failed; func name is (requestBaidu); error is ' +
        JSON.stringify(error))
        return
      }
    })
    this.bridgeObject.registerMethod({ name: 'handleDatabaseOperation', method: this.handleDatabaseOperation }, (error: BusinessError) => {
      if (error.code != 0) {
        console.error(LOG_TAG + 'registerMethod func failed; func name is (handleDatabaseOperation); error is ' +
        JSON.stringify(error))
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

  public setRdbStore(store: relationalStore.RdbStore) {
    this.rdbStore = store
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
  protected requestBaidu = (...parameters: bridge.Message[]): bridge.ResultValue => {
    let httpRequest = http.createHttp()
    httpRequest.request("https://www.baidu.com/", (err: Error, data: http.HttpResponse) => {
      if (!err) {
        console.info(LOG_TAG + 'requestBaidu code:' + data.responseCode)
        console.info(LOG_TAG + 'requestBaidu Result:' + data.result)
      } else {
        console.info(LOG_TAG + 'requestBaidu error:' + JSON.stringify(err))
      }
    })
    return 'requestBaidu success'
  }
  protected handleDatabaseOperation = (...parameters: bridge.Message[]): bridge.ResultValue => {
    const valueBucket: ValuesBucket = { "name": "Lisa" };
    if (this.rdbStore == undefined) {
      console.info(LOG_TAG + `Get DatabaseStore Failed, store is undefined`)
      return ''
    }
    const createTableSql: string = util.format(
      'CREATE TABLE IF NOT EXISTS %s (id INTEGER PRIMARY KEY AUTOINCREMENT %s)', 'student', ',' + 'name' + ' ' + 'TEXT')
    try {
      this.rdbStore.executeSql(createTableSql).then(() => {
        if (this.rdbStore == undefined) {
          console.info(LOG_TAG + `Get DatabaseStore Failed, store is undefined`)
          return
        }
        this.rdbStore.insert("student", valueBucket, (err: BusinessError, rowId: number) => {
          if (err) {
            console.error(LOG_TAG + `DatabaseStore Insert is failed, code is ${err.code},message is ${err.message}`);
            return;
          }
          console.info(LOG_TAG + `DatabaseStore Insert is successful, rowId = ${rowId}`);
        })
      })
      return 'handleDatabaseOperation success'
    } catch (err) {
      console.error(LOG_TAG + `createTable failed,code is ${err.code}, message is ${err.message}`);
      return ''
    }
  }
}
