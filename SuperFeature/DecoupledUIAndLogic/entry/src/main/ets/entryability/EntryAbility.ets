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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import relationalStore from '@ohos.data.relationalStore';
import { BridgeUtil } from '../BridgeUtil';

const LOG_TAG: string = '[Test][ArkTS][EntryAbility]:: '

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(LOG_TAG + 'Ability onCreate');
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "RdbTest.db",
      securityLevel: relationalStore.SecurityLevel.S1
    };
    relationalStore.getRdbStore(this.context, STORE_CONFIG,
      (err, rdbStore: relationalStore.RdbStore) => {
        if (err) {
          console.error(LOG_TAG + `Get RdbStore failed, code is ${err.code},message is ${err.message}`);
          return;
        }
        console.info(LOG_TAG + `Get RdbStore successfully.`);
        BridgeUtil.getInstance().setRdbStore(rdbStore)
      })
  }

  onDestroy(): void {
    console.info(LOG_TAG + 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    console.info(LOG_TAG + 'Ability onWindowStageCreate');
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    console.info(LOG_TAG + 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    console.info(LOG_TAG + 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    console.info(LOG_TAG + 'Ability onBackground');
  }
}
