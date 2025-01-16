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

  /*======================== 跨平台无法适配 start ======================================================================
  // UIAbility生命周期事件 当恢复能力窗口阶段时被回调
  onWindowStageRestore(windowStage: window.WindowStage): void {
    Logger.info(TAG, 'Ability onWindowStageRestore');
    AppStorage.setOrCreate<number>('statusBarHeight', AppConstants.DEFAULT_STATUS_HEIGHT);
    AppStorage.setOrCreate<window.WindowStage>('windowStage', windowStage);
    WindowUtil.getWindowUtil().requestFullScreen(windowStage, this.context);
  }

  // UIAbility生命周期事件 当能力准备继续时回调
  onContinue(wantParam: Record<string, Object>): AbilityConstant.OnContinueResult {
    Logger.info(TAG, 'onContinue continueData:' + JSON.stringify(ContinueModel.getInstance().data));
    wantParam.continueData = JSON.stringify(ContinueModel.getInstance().data);
    return AbilityConstant.OnContinueResult.AGREE;
  }

  // 华为云服务
  async initAgc() {
    const value = await this.context.resourceManager.getRawFileContent('agconnect-services.json');
    let json: string = buffer.from(value as ArrayBuffer).toString('utf8');
    initialize(this.context, JSON.parse(json));
  }

  // 更新卡片和推送信息的参数
  handleParams(want: Want): void {
    // Parameters for updating cards and pushing messages
    if (want.parameters && (want.parameters[formInfo.FormParam.IDENTITY_KEY] || want.parameters.articleId)) {
      Logger.info(TAG, 'onNewWant parameters:' + JSON.stringify(want.parameters));
      GlobalContext.getContext().setObject('articleId', want.parameters.articleId);
      GlobalContext.getContext().setObject('type', want.parameters.type);
      GlobalContext.getContext().setObject('webUrl', want.parameters.webUrl);
    }
  }

  // 从 want 中恢复迁移的数据。
  async restoringData(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    // Recovering migrated data from want.
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      if (want.parameters && want.parameters.continueData) {
        Logger.info(TAG, 'restoringData parameters:' + JSON.stringify(want.parameters.continueData));
        let cData = JSON.parse(want.parameters.continueData as string) as CData
        let userId = (cData.userData as Record<string, string>).id as string;
        ContinueModel.getInstance().data = cData;
        ContinueModel.getInstance().isContinue = true;
        if (userId) {
          AppStorage.setOrCreate('userId', userId);
          AppStorage.setOrCreate('isLogged', true);
        }
      }
      this.context.restoreWindowStage(localStorage);
    }
  }

  // requestEnableNotification接口不支持跨平台，但是notificationManager没有其他调用，不确定该函数作用
  requestNotification() {
    notificationManager.requestEnableNotification(this.context).then(() => {
      Logger.info('requestEnableNotification success');
      this.checkPermissions();
    }).catch((err: BusinessError) => {
      this.checkPermissions();
      Logger.error(`requestEnableNotification fail: ${JSON.stringify(err)}`);
    });
  }

  // 请求权限：ohos.permission.DISTRIBUTED_DATASYNC
  // Android/IOS 没有该权限
  async checkPermissions(): Promise<void> {
    const permissions: Array<Permissions> = ["ohos.permission.DISTRIBUTED_DATASYNC"];
    const accessManager = abilityAccessCtrl.createAtManager();
    try {
      const bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
      const grantStatus = await accessManager.checkAccessToken(bundleInfo.appInfo.accessTokenId, permissions[0]);
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_DENIED) {
        accessManager.requestPermissionsFromUser(this.context, permissions)
      }
    } catch (err) {
      Logger.error('EntryAbility', 'checkPermissions', `Catch err: ${err}`);
      return;
    }
  }

  // initializeWebEngine接口不支持跨平台
  // 在 Web 组件初始化之前，通过此接口加载 Web 引擎的动态库文件，以提高启动性能
  initWebEngine() {
    setTimeout(() => {
      webview.WebviewController.initializeWebEngine();
    }, 0);
  }

  //======================== 跨平台无法适配 end ======================================================================*/
}
