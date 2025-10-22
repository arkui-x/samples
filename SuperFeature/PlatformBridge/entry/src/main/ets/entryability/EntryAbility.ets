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

const TAG: string = '[[Lifecycle]][ArkTS]:: ';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(TAG + 'EntryAbility onCreate');
  }

  onDestroy(): void {
    console.info(TAG + 'EntryAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    console.info(TAG + 'EntryAbility onWindowStageCreate');

    windowStage.loadContent('pages/EnterPage', (err) => {
      if (err.code) {
        console.error(TAG + 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      console.info(TAG + 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    console.info(TAG + 'EntryAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    console.info(TAG + 'EntryAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    console.info(TAG + 'EntryAbility onBackground');
  }
}
