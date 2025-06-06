/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { window, display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from 'utils';

/**
 * 窗口管理模型
 */
export default class WindowModel {
  constructor() {
  }

  /**
   * 缓存的当前WindowStage实例
   */
  private windowStage?: window.WindowStage = undefined;

  /**
   * 缓存windowStage
   * @param windowStage 当前WindowStage实例
   * @returns {void}
   */
  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
  }

  /**
   * 当前主窗口是否开启沉浸模式
   * @param enable 是否开启
   * @returns {void}
   */
  setMainWindowImmersive(enable: boolean): void {
    if (this.windowStage === undefined) {
      logger.error('windowStage is undefined.');
      return;
    }
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        logger.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      windowClass.setWindowLayoutFullScreen(enable).then(()=>{
        windowClass.setWindowSystemBarEnable(enable ? [] : ['status', 'navigation']);
      })
    });
  }

  /**
   * 根据折叠屏的折叠状态，更新主窗口显示方向属性
   * @param curFoldStatus 当前折叠屏折叠状态
   * @returns {void}
   */
  updateMainWinPreferredOrientation(curFoldStatus: display.FoldStatus = display.getFoldStatus()): void {
    if (this.windowStage === undefined) {
      logger.error('windowStage is undefined.');
      return;
    }

    this.windowStage.getMainWindow(async (err: BusinessError, mainWindow: window.Window) => {
      let curWinPreferredOrientation: window.Orientation = window.Orientation.UNSPECIFIED;
      if (curFoldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
        curWinPreferredOrientation = window.Orientation.PORTRAIT;
      } else {
        curWinPreferredOrientation = window.Orientation.AUTO_ROTATION;
      }
      mainWindow.setPreferredOrientation(curWinPreferredOrientation);
    })
  }
}
