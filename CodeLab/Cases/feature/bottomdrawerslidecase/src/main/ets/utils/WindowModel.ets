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
import ArrayUtil from './ArrayUtil';
import { logger } from './Logger';


declare type DisplayType = display.Display;


/**
 * 窗口管理模型
 */
export default class WindowModel {
  // 默认的顶部导航栏高度
  public static readonly STATUS_BAR_HEIGHT = 38.8;
  // 默认的底部导航条高度
  public static readonly BOTTOM_AVOID_HEIGHT = 10;

  private constructor() {
  }

  // WindowModel 单例
  private static instance?: WindowModel;
  // 键值对
  private objects = new Map<string, Object>();

  /**
   * 获取WindowModel单例实例
   * @returns {WindowModel} WindowModel
   */
  static getInstance(): WindowModel {
    if (!WindowModel.instance) {
      WindowModel.instance = new WindowModel();
    }
    return WindowModel.instance;
  }

  // 缓存的当前WindowStage实例
  private windowStage?: window.WindowStage;

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
      windowClass.setWindowLayoutFullScreen(enable, (err) => {
        if (err.code) {
          logger.error(`Failed to set full-screen mode. Code:${err.code}, message:${err.message}`);
          return;
        }
      });
    });
  }

  /**
   * 获取主窗口顶部导航栏高度
   * @returns {callback((statusBarHeight: number) => void))}
   */
  getStatusBarHeight(callback: ((statusBarHeight: number) => void)): void {
    if (this.windowStage === undefined) {
      logger.error('windowStage is undefined.');
      return;
    }
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        logger.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        const type = window.AvoidAreaType.TYPE_SYSTEM;
        const avoidArea = windowClass.getWindowAvoidArea(type);
        const height = avoidArea.topRect.height;
        logger.info("Successful get statusHeight" + height);
        callback(height);
      }
      catch (err) {
        callback(WindowModel.STATUS_BAR_HEIGHT);
        logger.info("Failed to get statusHeight");
      }
    });
  }

  /**
   * 跨平台获取主窗口高度
   * @returns {callback: ((arkuiXWindowHeight: number) => void)}
   */
  getArkuiXWindowHeight(callback: ((arkuiXWindowHeight: number) => void)): void {
    if (this.windowStage === undefined) {
      logger.error('windowStage is undefined.');
      return;
    }
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        logger.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        const type = window.AvoidAreaType.TYPE_SYSTEM;
        const avoidArea = windowClass.getWindowAvoidArea(type);
        const screenHeight = display.getDefaultDisplaySync().height;
        const height = screenHeight - avoidArea.topRect.height;
        logger.info('Successful get arkuiXWindowHeight ==' + height);
        callback(height);
      } catch (err) {
        callback(WindowModel.BOTTOM_AVOID_HEIGHT);
        logger.info("Failed to get arkuiXWindowHeight");
      }
    });
  }

  /**
   * 获取主窗口底部导航条高度
   * @returns {callback: ((bottomAvoidHeight: number) => void)}
   */
  getBottomAvoidHeight(callback: ((bottomAvoidHeight: number) => void)): void {
    if (this.windowStage === undefined) {
      logger.error('windowStage is undefined.');
      return;
    }
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        logger.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      try {
        const type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
        const avoidArea = windowClass.getWindowAvoidArea(type);
        const height = avoidArea.bottomRect.height;
        logger.info('Successful get bottomAvoidHeight ==' + height);
        callback(height);
      } catch (err) {
        callback(WindowModel.BOTTOM_AVOID_HEIGHT);
        logger.info("Failed to get bottomAvoidHeight");
      }
    });
  }

  /**
   * 获取手机物理逻辑密度
   * @returns {Promise<number>}
   */
  async getDisplay(): Promise<number> {
    let globalDisplays = WindowModel.getInstance().getObject('display') as Array<DisplayType>
    if (ArrayUtil.isNotNullEmpty(globalDisplays)) {
      return globalDisplays[0].densityPixels;
    }
    globalDisplays = await display.getAllDisplays();
    WindowModel.getInstance().setObject('display', globalDisplays);
    return globalDisplays[0].densityPixels;
  }

  /**
   * 获取主窗口高度
   * @returns {Promise<number>}
   */
  async getWindowHeight(): Promise<number> {
    let globalDisplays = WindowModel.getInstance().getObject('display') as Array<DisplayType>;
    if (ArrayUtil.isNotNullEmpty(globalDisplays)) {
      return globalDisplays[0].height / globalDisplays[0].densityPixels;
    }
    globalDisplays = await display.getAllDisplays();
    WindowModel.getInstance().setObject('display', globalDisplays);
    return globalDisplays[0].height / globalDisplays[0].densityPixels;
  }


  getObject(key: string): Object | undefined {
    return this.objects.get(key);
  }


  setObject(key: string, value: Object): void {
    this.objects.set(key, value);
  }
}
