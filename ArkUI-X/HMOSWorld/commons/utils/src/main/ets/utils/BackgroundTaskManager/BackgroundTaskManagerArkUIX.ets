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

import { common } from '@kit.AbilityKit';
import Logger from '../Logger';
import { BackgroundTaskManagerInterface } from '../interface/BackgroundTaskManagerInterface';

const TAG = '[BackgroundTaskManagerArkUIX]';

export class BackgroundTaskManagerArkUIX implements BackgroundTaskManagerInterface {
  private static instance: BackgroundTaskManagerArkUIX;

  public static getInstance(): BackgroundTaskManagerInterface {
    if (!BackgroundTaskManagerArkUIX.instance) {
      BackgroundTaskManagerArkUIX.instance = new BackgroundTaskManagerArkUIX();
    }
    return BackgroundTaskManagerArkUIX.instance;
  }

  public startContinuousTask(context: common.UIAbilityContext): void {
    Logger.warn(TAG, 'Func startContinuousTask not support arkui-x');
  }

  public stopContinuousTask(context: common.UIAbilityContext): void {
    Logger.warn(TAG, 'Func stopContinuousTask not support arkui-x');
  }
}