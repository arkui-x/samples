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

import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit'
import { window } from '@kit.ArkUI'

const LOG_TAG: string = '[ArkTS][Feature2Ability] '

export default class Feature2Ability extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    console.info(LOG_TAG + 'onCreate')
  }

  onDestroy(): void {
    console.info(LOG_TAG + 'onDestroy')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    console.info(LOG_TAG + 'onWindowStageCreate')
    windowStage.loadContent('pages/Feature2Page', (err) => {
    })
  }

  onWindowStageDestroy(): void {
    console.info(LOG_TAG + 'onWindowStageDestroy')
  }

  onForeground(): void {
    console.info(LOG_TAG + 'onForeground')
  }

  onBackground(): void {
    console.info(LOG_TAG + 'onBackground')
  }
}
