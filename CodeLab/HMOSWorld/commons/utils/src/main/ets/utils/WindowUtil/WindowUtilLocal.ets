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

import { AbilityConstant, common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from '../Logger';
import { WindowUtilInterface } from '../interface/WindowUtilInterface';

const TAG: string = '[WindowUtilLocal]';

export class WindowUtilLocal implements WindowUtilInterface {
  private static instance: WindowUtilLocal;

  public static getInstance(): WindowUtilInterface {
    if (!WindowUtilLocal.instance) {
      WindowUtilLocal.instance = new WindowUtilLocal();
    }
    return WindowUtilLocal.instance;
  }

  public updateStatusBarColor(context: common.BaseContext, isDark: boolean) {
    window.getLastWindow(context).then((windowClass: window.Window) => {
      try {
        windowClass.setWindowSystemBarProperties({ statusBarContentColor: isDark ? '#FFFFFF' : '#000000' }, (err) => {
          if (err.code) {
            Logger.error(TAG, 'Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
            return;
          }
          Logger.info(TAG, 'Succeeded in setting the system bar properties.');
        });
      } catch (exception) {
        Logger.error(TAG, 'Failed to set the system bar properties. Cause: ' + JSON.stringify(exception));
      }
    });
  }

  public requestFullScreen(windowStage: window.WindowStage, context: Context): void {
    windowStage.getMainWindow((err: BusinessError, data: window.Window) => {
      if (err.code) {
        Logger.error(TAG, 'Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      let windowClass: window.Window = data;
      Logger.info(TAG, 'Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

      // Realize the immersive effect
      let isLayoutFullScreen = true;
      try {
        // Get status bar height.
        let area: window.AvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let naviBarArea: window.AvoidArea =
          windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        Logger.info(TAG,
          `Succeeded get the window navigation indicator HEIGHT: ${px2vp(naviBarArea.bottomRect.height)}`);
        AppStorage.setOrCreate<number>('statusBarHeight', px2vp(area.topRect.height));
        AppStorage.setOrCreate<number>('naviIndicatorHeight', px2vp(naviBarArea.bottomRect.height));
        this.getDeviceSize(context);
        if (area.topRect.height > 0) {
          let promise: Promise<void> = windowClass.setWindowLayoutFullScreen(isLayoutFullScreen);
          promise.then(() => {
            Logger.info(TAG, 'Succeeded in setting the window layout to full-screen mode.');
          }).catch((err: BusinessError) => {
            Logger.error(TAG, 'Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
          });
        }
      } catch {
        Logger.error(TAG, 'Failed to set the window layout to full-screen mode. ');
      }
    });
  }

  public getDeviceSize(context: Context): void {
    // Get device height.
    window.getLastWindow(context).then((data: window.Window) => {
      let properties = data.getWindowProperties();
      AppStorage.setOrCreate<number>('deviceHeight', px2vp(properties.windowRect.height));
      AppStorage.setOrCreate<number>('deviceWidth', px2vp(properties.windowRect.width));
    });
  }

  public setMainWindowRestricted(context: Context): void {
    window.getLastWindow(context).then((windowClass: window.Window) => {
      if (windowClass === undefined) {
        Logger.error(TAG + 'MainWindowClass is undefined');
        return;
      }
      // Setting restricted display.
      windowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_RESTRICTED);
    });
  }

  public setMainWindowPortrait(context: Context): void {
    window.getLastWindow(context).then((windowClass: window.Window) => {
      if (windowClass === undefined) {
        Logger.error(TAG + 'MainWindowClass is undefined');
        return;
      }
      // Setting restricted display.
      windowClass.setPreferredOrientation(window.Orientation.PORTRAIT);
    });
  }

  public setMissionContinueActive(context: common.UIAbilityContext, active: boolean) {
    let activeState = active ? AbilityConstant.ContinueState.ACTIVE : AbilityConstant.ContinueState.INACTIVE;
    context.setMissionContinueState(activeState).then(() => {
      Logger.info(TAG + 'setMissionContinueState success');
    }).catch((err: BusinessError) => {
      Logger.error(TAG + `setMissionContinueState failed, code is ${err.code}, message is ${err.message}`);
    });
  }
}