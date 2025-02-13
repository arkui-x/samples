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

import { AbilityConstant, common, UIAbility, Want } from '@kit.AbilityKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import { Logger } from '@ohos/utils';
import { AppConstants } from '@ohos/main';
import { IndexAspect } from '@ohos/aspect';

const TAG = '[EntryAbility]';
let localStorage: LocalStorage = new LocalStorage();

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'Ability onCreate');
    if (deviceInfo.deviceType !== 'tablet') {
      window.getLastWindow(this.context, (err, data) => {
        if (err.code) {
          Logger.error(TAG, 'Failed to obtain the top window. Cause: ' + JSON.stringify(err));
          return;
        }
        let orientation = window.Orientation.PORTRAIT;
        data.setPreferredOrientation(orientation, (err) => {
          if (err.code) {
            Logger.error(TAG, 'Failed to set window orientation. Cause: ' + JSON.stringify(err));
            return;
          }
          Logger.info(TAG, 'Succeeded in setting window orientation.');
        });
      });
    }
    AppStorage.setOrCreate('systemColorMode', this.context.config.colorMode);
  }

  onDestroy(): void {
    Logger.info(TAG, 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability.
    Logger.info(TAG, 'Ability onWindowStageCreate');
    AppStorage.setOrCreate<number>('statusBarHeight', AppConstants.DEFAULT_STATUS_HEIGHT);
    AppStorage.setOrCreate<window.WindowStage>('windowStage', windowStage);
    AppStorage.setOrCreate<common.UIAbilityContext>('uiAbilityContext', this.context);
    windowStage.loadContent('pages/SplashPage', localStorage, () => {
      IndexAspect.initAspect();
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources.
    Logger.info(TAG, 'Ability onWindowStageDestroy');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(TAG, 'onNewWant want:' + JSON.stringify(want));
  }

  onForeground(): void {
    // Ability has brought to foreground.
    Logger.info(TAG, 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background.
    Logger.info(TAG, 'Ability onBackground');
  }

}
