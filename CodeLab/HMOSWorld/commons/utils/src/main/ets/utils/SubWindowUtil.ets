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

import { JSON } from '@kit.ArkTS';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import Logger from './Logger';

const TAG = '[SubWindowUtil]';

export interface SubWindowParams {
  width: number;
  height: number;
  x: number;
  y: number;
  backgroundColor?: string;
}

export class SubWindowUtil {
  public static showSubWindow(windowStage: window.WindowStage | undefined, path: string,
    subWindowParams: SubWindowParams) {
    if (!windowStage) {
      Logger.error(TAG, `windowStage is undefined.`);
      return;
    }
    windowStage.createSubWindow("subWindow", (err: BusinessError, data) => {
      if (err.code) {
        Logger.error(TAG, `Failed to create the subwindow. Cause: ${err.message}.`);
        return;
      }
      let subWindow = data;
      if (subWindow) {
        AppStorage.setOrCreate('subWindow', subWindow);
        // Set sub window position
        SubWindowUtil.moveSubWindow(subWindow, subWindowParams.x, subWindowParams.y);
        // Set sub window width and height
        SubWindowUtil.resizeSubWindow(subWindow, subWindowParams.width, subWindowParams.height);
        // Load content for sub window
        subWindow.setUIContent(path, (err: BusinessError) => {
          if (err.code) {
            Logger.error(TAG, `Failed to load the content. Cause: ${err.message}.`);
            return;
          }
          Logger.info('Succeeded in loading the content.');
          try {
            subWindow.setWindowBackgroundColor(subWindowParams.backgroundColor ?? '#00ffffff');
          } catch (exception) {
            Logger.error(TAG, `Failed to set the background color. Cause: ${JSON.stringify(exception)}.`);
          }
          subWindow.showWindow((err: BusinessError) => {
            if (err.code) {
              Logger.error(TAG, `Failed to show the window. Cause: ${err.message}.`);
              return;
            }
            Logger.info('Succeeded in showing the window.');
          });
        });
      }
    })
  }

  public static destroySubWindow(subWindow: window.Window | undefined) {
    if (!subWindow) {
      Logger.info('subWindow is undefined.');
      return;
    }
    subWindow.destroyWindow((err: BusinessError) => {
      if (err.code) {
        Logger.error(TAG, `Failed to destroy the window. Cause: ${err.message}.`);
        return;
      }
      AppStorage.set<window.Window>('subWindow', undefined);
      Logger.info('Succeeded in destroying the window.');
    });
  }

  public static moveSubWindow(subWindow: window.Window | undefined, x: number, y: number) {
    if (!subWindow) {
      Logger.info('subWindow is undefined.');
      return;
    }
    subWindow.moveWindowTo(x, y, (err: BusinessError) => {
      if (err.code) {
        Logger.error(TAG, `Failed to move the window. Cause: ${err.message}.`);
        return;
      }
      Logger.info('Succeeded in moving the window.', x, y);
    });
  }

  public static resizeSubWindow(subWindow: window.Window | undefined, width: number, height: number) {
    if (!subWindow) {
      Logger.info('subWindow is undefined.');
      return;
    }
    subWindow.resize(vp2px(width), vp2px(height), (err: BusinessError) => {
      if (err.code) {
        Logger.error(TAG, `Failed to change the window size. Cause: ${err.message}.`);
        return;
      }
      Logger.info('Succeeded in changing the window size.');
    });
  }
}