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

import { BusinessError } from '@ohos.base';
import { logger, PreferenceManager } from 'utils';
import { FaultDataSource } from '../model/DataSource';

const TAG: string = '[PreferencesManager]';
// TODO：知识点：初始化Preferences实例，用于异常信息的持久化存储以及获取持久化数据功能
let dataPreferencesManager: PreferenceManager = PreferenceManager.getInstance();

export class PreferencesManager {
  // 获取Preferences实例
  public static async getPreferences(faultDataSource: FaultDataSource): Promise<void> {
    logger.info(TAG, 'getPreferences start.');
    try {
      // 获取异常信息
      await PreferencesManager.getFaultMessage(faultDataSource);
      await PreferencesManager.getFaultSign();
    } catch (err) {
      logger.error(TAG, "Failed to get preferences");
    }
  }

  /**
   * 存储数据异常信息
   * @param faultMessage 异常信息集合
   */
  public static async putFaultMessage(faultMessage: Array<string>): Promise<void> {
    logger.info(TAG, `putFaultMessage start`);
    try {
      dataPreferencesManager.setValue('faultMessage', JSON.stringify(faultMessage))
    } catch (err) {
      const code = (err as BusinessError).code;
      const message = (err as BusinessError).message;
      logger.error(TAG, "Failed to put value of 'catch err'. code =" + err.code + ", message =" + err.message);
    }
  }

  /**
   * 获取数据异常信息
   * @param faultMessage 异常信息集合
   */
  public static async getFaultMessage(faultDataSource: FaultDataSource): Promise<void> {
    logger.info(TAG, `getFaultMessage start`);
    await dataPreferencesManager.getValue<string>('faultMessage').then((data: string | null) => {
      if (data != null && typeof data === 'string') {
        const faultData: Array<string> = JSON.parse(data);
        // 将异常数据添加到懒加载数据源中
        faultData.forEach((item: string) => {
          faultDataSource.pushData(item);
        })
        // 双向数据绑定懒加载数据源长度，更新数据源长度
        AppStorage.setOrCreate('faultDataSourceLength', faultDataSource.totalCount())
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG, 'getFaultSign Failed, err: ' + err);
    });
  }

  /**
   * 存储数据异常标识
   */
  public static async putFaultSign(): Promise<void> {
    logger.info(TAG, `putFaultSign start`);
    try {
      // TODO：知识点：通过 dataPreferencesManager.put方法存储数据
      dataPreferencesManager.setValue('faultSign', true)
    } catch (err) {
      logger.error(TAG,
        "putFaultSign Failed to put value of 'catch err'. code =" + err.code + ", message =" + err.message);
    }
  }

  /**
   * 获取数据异常标识
   */
  public static async getFaultSign(): Promise<void> {
    logger.info(TAG, `getFaultSign start`);
    let faultSign: boolean = false;
    // TODO：知识点：通过dataPreferencesManager.get方法获取异常标识
    await dataPreferencesManager.getValue<boolean>('faultSign').then((data: boolean | null) => {
      if (data != null) {
        AppStorage.setOrCreate('faultSign', faultSign);
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG, 'getFaultSign Failed, err: ' + err);
    });
  }
}