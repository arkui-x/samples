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

import { abilityAccessCtrl, AbilityConstant, bundleManager, Permissions, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { CommonConstants as Const, Logger, TrainsLine } from '@ohos/utils';

let selectPage = "";
let currentWindowStage: window.WindowStage | null = null;

export default class EntryAbility extends UIAbility {
  private storage: LocalStorage = new LocalStorage();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info('%{public}s', 'Ability onCreate');
    this.restoringData(want, launchParam);

    if (want?.parameters?.params !== undefined) {
      let params: Record<string, string> = JSON.parse(want.parameters.params as string);
      if (params.url === 'train') {
        AppStorage.setOrCreate<number>('bottomTabIndex', want.parameters['bottomTabIndex'] as number);
        switch (Number.parseInt(params.lineIndex)) {
          case TrainsLine.LINE_ONE:
            AppStorage.setOrCreate<boolean>('showLineOne', true);
            break;
          case TrainsLine.LINE_TWO:
            AppStorage.setOrCreate<boolean>('showLineTwo', true);
            break;
          case TrainsLine.LINE_THREE:
            AppStorage.setOrCreate<boolean>('showLineThree', true);
            break;
          default:
            break;
        }
      } else if (params.url === 'introduction') {
        AppStorage.setOrCreate<number>('cardID', want.parameters['id'] as number);
      }
      selectPage = params.url;
    }
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam) {
    Logger.info('%{public}s', 'Ability onNewWant');
    this.restoringData(want, launchParam);
    if (want?.parameters?.params !== undefined) {
      let params: Record<string, string> = JSON.parse(want?.parameters?.params as string);
      if (params.url === 'train') {
        AppStorage.setOrCreate<number>('bottomTabIndex', want.parameters['bottomTabIndex'] as number);
        AppStorage.setOrCreate<boolean>('showLineOne', false);
        AppStorage.setOrCreate<boolean>('showLineTwo', false);
        AppStorage.setOrCreate<boolean>('showLineThree', false);
        switch (Number.parseInt(params.lineIndex)) {
          case TrainsLine.LINE_ONE:
            AppStorage.setOrCreate<boolean>('showLineOne', true);
            break;
          case TrainsLine.LINE_TWO:
            AppStorage.setOrCreate<boolean>('showLineTwo', true);
            break;
          case TrainsLine.LINE_THREE:
            AppStorage.setOrCreate<boolean>('showLineThree', true);
            break;
          default:
            break;
        }
      } else if (params.url === 'introduction') {
        AppStorage.setOrCreate<number>('cardID', want.parameters['id'] as number);
      }
      selectPage = params.url;
    }
    if (currentWindowStage != null) {
      this.onWindowStageCreate(currentWindowStage);
    }
  }

  onDestroy() {
    Logger.info('%{public}s', 'Ability onDestroy');
  }

  restoringData(want: Want, launchParam: AbilityConstant.LaunchParam) {
    this.checkPermissions();
    // Recovering migrated data from want.
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION && want?.parameters !== undefined) {
      // Recovering migrated data from want.
      AppStorage.setOrCreate<number>('currentZoneId', want.parameters['currentZoneId'] as number);
      AppStorage.setOrCreate<number>('offsetSum', want.parameters['offsetSum'] as number);
      AppStorage.setOrCreate<number>('bottomTabIndex', want.parameters['bottomTabIndex'] as number);
      AppStorage.setOrCreate<number>('imageHeight', want.parameters['imageHeight'] as number);
      AppStorage.setOrCreate<number>('arrowIconOpacity', want.parameters['arrowIconOpacity'] as number);
      AppStorage.setOrCreate<number>('aheadIndex', want.parameters['aheadIndex'] as number)
      AppStorage.setOrCreate<string>('isContinuation', Const.CAN_CONTINUATION);
      AppStorage.setOrCreate<number>('imageId', want.parameters['imageId'] as number);
      AppStorage.setOrCreate<boolean>('imageModalOpen', want.parameters['imageModalOpen'] as boolean);
      AppStorage.setOrCreate<number>('positionType', want.parameters['positionType'] as number);
      AppStorage.setOrCreate<number>('panelOpacity', want.parameters['panelOpacity'] as number);
      AppStorage.setOrCreate<number>('panelHeight', want.parameters['panelHeight'] as number);
      AppStorage.setOrCreate<number>('iconOpacity', want.parameters['iconOpacity'] as number);
      AppStorage.setOrCreate<boolean>('isDownImage', want.parameters['isDownImage'] as boolean);
      AppStorage.setOrCreate<string>('searchInput', want.parameters['searchInput'] as string);
      AppStorage.setOrCreate<boolean>('showLineOne', want.parameters['showLineOne'] as boolean);
      AppStorage.setOrCreate<boolean>('showLineTwo', want.parameters['showLineTwo'] as boolean);
      AppStorage.setOrCreate<boolean>('showLineThree', want.parameters['showLineThree'] as boolean);
      AppStorage.setOrCreate<number>('curIndex', want.parameters['curIndex'] as number);
      this.storage = new LocalStorage();
      this.context.restoreWindowStage(this.storage);
    }
  }

  async checkPermissions(): Promise<void> {
    const permissions: Array<Permissions> = ['ohos.permission.DISTRIBUTED_DATASYNC'];
    let grantStatus: abilityAccessCtrl.GrantStatus = await this.checkAccessToken(permissions[0]);
    // Open the dialog accord to the permission of the user.
    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      Logger.info('%{public}s', 'Permission already granted.');
    } else {
      let atManager = abilityAccessCtrl.createAtManager();
      try {
        atManager.requestPermissionsFromUser(this.context, permissions);
      } catch (err) {
        Logger.error('catch requestPermissions error');
        return;
      }
    }
  }

  async checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
    // Obtain the accessTokenID of the application
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (err) {
      Logger.error('Failed to get bundle info for self.');
    }
    // Check whether the permission is granted to the application
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (err) {
      Logger.error('Failed to check access token.');
    }
    return grantStatus;
  }

  onContinue(wantParam: Record<string, string | boolean | number>) {
    Logger.info('onContinue version = %{public}s, targetDevice: %{public}s',
      wantParam.version as string, wantParam.targetDevice as string);
    // Store the data to be migrated in wantParam
    wantParam['currentZoneId'] = AppStorage.get<number>('currentZoneId') as number;
    wantParam['offsetSum'] = AppStorage.get<number>('offsetSum') as number;
    wantParam['bottomTabIndex'] = AppStorage.get<number>('bottomTabIndex') as number;
    wantParam['imageHeight'] = AppStorage.get<number>('imageHeight') as number;
    wantParam['arrowIconOpacity'] = AppStorage.get<number>('arrowIconOpacity') as number;
    wantParam['aheadIndex'] = AppStorage.get<number>('aheadIndex') as number;
    wantParam['imageId'] = AppStorage.get<number>('imageId') as number;
    wantParam['imageModalOpen'] = AppStorage.get<boolean>('imageModalOpen') as boolean;
    wantParam['positionType'] = AppStorage.get<number>('positionType') as number;
    wantParam['panelOpacity'] = AppStorage.get<number>('panelOpacity') as number;
    wantParam['panelHeight'] = AppStorage.get<number>('panelHeight') as number;
    wantParam['iconOpacity'] = AppStorage.get<number>('iconOpacity') as number;
    wantParam['isDownImage'] = AppStorage.get<boolean>('isDownImage') as boolean;
    wantParam['searchInput'] = AppStorage.get<string>('searchInput') as string;
    wantParam['showLineOne'] = AppStorage.get<boolean>('showLineOne') as boolean;
    wantParam['showLineTwo'] = AppStorage.get<boolean>('showLineTwo') as boolean;
    wantParam['showLineThree'] = AppStorage.get<boolean>('showLineThree') as boolean;
    wantParam['curIndex'] = AppStorage.get<number>('curIndex') as number;
    return AbilityConstant.OnContinueResult.AGREE;
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Logger.info('%{public}s', 'Ability onWindowStageCreate');
    let targetPage: string = '';
    // Select different pages based on the transferred targetPage
    switch (selectPage) {
      case 'train':
        targetPage = 'pages/MainPage';
        break;
      case 'introduction':
        targetPage = 'pages/IntroductionPage';
        break;
      default:
        targetPage = 'pages/Splash';
    }
    if (currentWindowStage === null) {
      currentWindowStage = windowStage;
    }
    windowStage.loadContent(targetPage, (err, data) => {
      if (err.code) {
        Logger.error('Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      Logger.info('Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    Logger.info('%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    Logger.info('%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    Logger.info('%{public}s', 'Ability onBackground');
  }
}
