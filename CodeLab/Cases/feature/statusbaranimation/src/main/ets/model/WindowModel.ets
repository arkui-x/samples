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

import { promptAction, window } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { logger, PlatformInfo, PlatformTypeEnum } from 'utils';

/**
 * 窗口管理模型
 */
export default class WindowModel {
  // 默认的顶部导航栏高度
  public static readonly STATUS_BAR_HEIGHT = 38.8;
  // 默认的底部导航条高度
  public static readonly BOTTOM_AVOID_HEIGHT = 10;
  // WindowModel 单例
  private static instance?: WindowModel;
  // 缓存的当前WindowStage实例
  private windowStage?: window.WindowStage;

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

  /**
   * 缓存windowStage
   * @param windowStage 当前WindowStage实例
   * @returns {void}
   */
  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
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
        const avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        const height = avoidArea.topRect.height;
        logger.info("Successful get statusHeight" + height);
        callback(height);
      } catch (err) {
        callback(WindowModel.STATUS_BAR_HEIGHT);
        logger.info("Failed to get statusHeight");
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
        const avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
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
   * 当前主窗口是否开启沉浸模式
   * @returns {void}
   */
  setImmersive(popPage?: () => void) {
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
        // 设置沉浸式全屏
        windowClass.setWindowLayoutFullScreen(true).then(() => {
          this.registerEmitter(windowClass, popPage);
        })
        logger.info('Successful to set windowLayoutFullScreen');
      } catch (err) {
        logger.info("Failed to set windowLayoutFullScreen");
      }
    });
  }

  setSystemBarContentColor(color: string) {
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
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          // 设置导航栏，状态栏内容颜色
          windowClass.setWindowSystemBarProperties({ statusBarContentColor: color });
        }
        logger.info('Successful to set windowLayoutFullScreen');
      } catch (err) {
        logger.info("Failed to set windowLayoutFullScreen");
      }
    });
  }

  /*
   * 添加事件订阅
   */
  // TODO: 知识点：通过emitter.on监听的方式来改变沉浸式适配和状态栏的变化。
  registerEmitter(windowClass: window.Window, popPage?: () => void) {
    emitter.on({ eventId: 2 }, (data: emitter.EventData) => {
      // 收到返回事件，显示状态栏和导航栏，退出全屏模式，再返回主页
      if (data?.data?.backPressed) {
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          // 设置导航栏，状态栏内容为白色
          windowClass.setWindowSystemBarProperties({
            statusBarContentColor: '#000000'
          }).then(() => {
            if (popPage) {
              popPage();
            } else {
              // 未传入返回接口时给出弹框提示
              promptAction.showToast({
                message: '请实现页面返回功能',
                duration: 1000
              })
            }
          });
        } else if (PlatformInfo.isArkUIX()) {
          if (popPage) {
            popPage();
          } else {
            // 未传入返回接口时给出弹框提示
            promptAction.showToast({
              message: '请实现页面返回功能',
              duration: 1000
            })
          }
        }
      }
    })
  }

  /*
   * 取消事件订阅
   */
  deleteEmitter() {
    emitter.off(2);
  }
}
