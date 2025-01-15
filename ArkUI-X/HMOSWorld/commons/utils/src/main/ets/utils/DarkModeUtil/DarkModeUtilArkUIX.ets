/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { DarkModeUtilInterface } from '../interface/DarkModeUtilInterface';
import { DarkModeSettingsConfig } from '../../common/DarkModeData';
import Logger from '../Logger';

const TAG = '[DarkModeUtilArkUIX]';

export class DarkModeUtilArkUIX implements DarkModeUtilInterface {
  private static instance: DarkModeUtilArkUIX;

  public static getInstance(): DarkModeUtilInterface {
    if (!DarkModeUtilArkUIX.instance) {
      DarkModeUtilArkUIX.instance = new DarkModeUtilArkUIX();
    }
    return DarkModeUtilArkUIX.instance;
  }

  public saveDarkModeSettingsConfig(darkModeConfig: DarkModeSettingsConfig) {
    Logger.warn(TAG, 'Func saveDarkModeSettingsConfig not support arkui-x');
  }

  public checkDarkModeSetting(): void {
    Logger.warn(TAG, 'Func checkDarkModeSetting not support arkui-x');
  }
}