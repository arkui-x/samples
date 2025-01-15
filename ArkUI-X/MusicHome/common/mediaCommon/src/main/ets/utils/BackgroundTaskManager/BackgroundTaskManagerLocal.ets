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

import { common, wantAgent } from '@kit.AbilityKit';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from '../Logger';
import { BackgroundTaskManagerInterface } from '../interface/BackgroundTaskManagerInterface';

export class BackgroundTaskManagerLocal {
  private static instance: BackgroundTaskManagerLocal;

  public static getInstance(): BackgroundTaskManagerInterface {
    if (!BackgroundTaskManagerLocal.instance) {
      BackgroundTaskManagerLocal.instance = new BackgroundTaskManagerLocal();
    }
    return BackgroundTaskManagerLocal.instance;
  }

  /**
   * Start background task.
   *
   * @param context
   */
  public startContinuousTask(context: common.UIAbilityContext | undefined): void {
    if (!context) {
      Logger.error('this avPlayer: ', `context undefined`);
      return
    }
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: Object) => {
      try {
        backgroundTaskManager.startBackgroundRunning(context,
          backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, wantAgentObj).then(() => {
          Logger.info('this avPlayer: ', 'startBackgroundRunning succeeded');
        }).catch((error: BusinessError) => {
          Logger.error('this avPlayer: ', `startBackgroundRunning failed Cause: code ${error.code}`);
        });
      } catch (error) {
        Logger.error('this avPlayer: ', `startBackgroundRunning failed. code ${(error as BusinessError).code}
         message ${(error as BusinessError).message}`);
      }
    });
  }

  /**
   * Stop background task.
   *
   * @param context
   */
  public stopContinuousTask(context: common.UIAbilityContext | undefined): void {
    try {
      backgroundTaskManager.stopBackgroundRunning(context).then(() => {
        Logger.info('this avPlayer: ', 'stopBackgroundRunning succeeded');
      }).catch((error: BusinessError) => {
        Logger.error('this avPlayer: ', `stopBackgroundRunning failed Cause: code ${error.code}`);
      });
    } catch (error) {
      Logger.error('this avPlayer: ', `stopBackgroundRunning failed. code ${(error as BusinessError).code}
       message ${(error as BusinessError).message}`);
    }
  }
}