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

import window from '@ohos.window';
import emitter from '@ohos.events.emitter';
import { BusinessError } from '@ohos.base';
import { entryName } from './LoadContentWindow';
import { common } from '@kit.AbilityKit';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

const EVENT_ID = 1234565; // 持续订阅事件ID
const context = getContext(this) as common.UIAbilityContext; // 获取当前页面的上下文

// window实例
interface Handler {
  windowStage: window.WindowStage;
}

// 加载到窗口的页面内容
interface SubWindowParams {
  sum: string;
}

/**
 * 窗口的创建，加载，显示，销毁操作
 */
export class SubWindowApi {
  private maskColor: string = ''; // 初始化蒙层颜色
  private subWindow: window.Window | null = null; // 初始化window实例
  private Storage: LocalStorage = new LocalStorage(); // 创建页面级UI状态存储对象
  // eventId为1234565的持续订阅的事件
  private callbackEvent: emitter.InnerEvent = {
    eventId: EVENT_ID
  }

  // 显示当前窗口
  private showSubWindow() {
    if (this.subWindow) {
      this.subWindow.showWindow((err: BusinessError) => {
        if (err.code) {
          console.error('Fail to show window, Cause: ' + JSON.stringify(err));
        }
      })
    }
  }

  // 为当前WindowStage加载命名路由页面
  private loadContent(path: string) {
    if (this.subWindow) {
      // TODO: 知识点: 用loadContentByName为当前窗口加载命名路由页面，通过LocalStorage传递状态属性给加载的页面
      this.subWindow.loadContentByName(path, this.Storage, (err: BusinessError) => {
        if (this.subWindow) {
          try {
            this.subWindow.setWindowBackgroundColor(this.maskColor);
          } catch (exception) {
            console.error('Failed to set the background color. Cause: ' + JSON.stringify(exception));
          };
        }
        if (err.code) {
          console.error("Failed to load the content. Cause:" + JSON.stringify(err));
          return;
        }
      });
    }
  }

  // 销毁当前窗口
  private destroySubWindow() {
    if (this.subWindow) {
      this.subWindow.destroyWindow((err) => {
        if (err.code) {
          console.error('Fail to destroy the window. Cause:' + JSON.stringify(err));
          return;
        }
        this.subWindow = null;
      });
    }
  }

  // 创建子窗口
  private createSubWindow(windowStage: window.WindowStage | null) {
    try {
      if (!windowStage) {
        return;
      }
      if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
        windowStage.createSubWindow('mySubWindow', (err: BusinessError, data) => {
          if (err.code) {
            console.error("Failed to create the subwindow, Cause: " + JSON.stringify(err));
            return;
          }
          this.subWindow = (data as window.Window);
          if (this.subWindow) {
            // 设置子窗口蒙层颜色
            this.initColor();
            // 设置子窗口可触
            this.subWindow.setWindowTouchable(true);
            // 设置窗口UI
            this.loadContent(entryName);
            // 展示子窗口
            this.showSubWindow();
          }
        });
      } else if (PlatformInfo.isArkUIX()) {
        let mainWindow: window.Window | undefined = undefined;
        windowStage.getMainWindow((err: BusinessError, data) => {
          const errCode: number = err.code;
          if (errCode) {
            console.error(`Failed to obtain the main window. Cause code: ${err.code}, message: ${err.message}`);
            return;
          }
          mainWindow = data;
        });

        windowStage.createSubWindow('mySubWindow', (err: BusinessError, data) => {
          if (err.code) {
            console.error("Failed to create the subwindow, Cause: " + JSON.stringify(err));
            return;
          }

          this.subWindow = (data as window.Window);
          if (this.subWindow) {
            this.subWindow.resize(mainWindow?.getWindowProperties().windowRect.width,
              mainWindow?.getWindowProperties().windowRect.height)

            // 设置子窗口蒙层颜色
            this.initColor();
            // 设置子窗口可触 未跨平台
            // this.subWindow.setWindowTouchable(true);
            // 设置窗口UI
            this.loadContent(entryName);
            // 展示子窗口
            this.showSubWindow();
          }
        });
      }
    } catch (exception) {
      console.error("Failed to create the window, Cause: " + JSON.stringify(exception));
    }
  }

  /**
   * 设置子窗口蒙层颜色
   */
  initColor() {
    try {
      // 获取指定resource对象对应的字符串
      this.maskColor = context.resourceManager.getStringSync($r('app.string.custom_dialog_mask_color').id);
      console.log("getStringSync: " + this.maskColor)
    } catch (err) {
      console.error(`getStringSync failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 订阅eventId为1234565的事件
   */
  subscribeCallback(): void {
    emitter.on(this.callbackEvent, () => {
      this.hideSubWindow();
    })
  }

  /**
   * 取消针对eventId为1234565的事件的订阅
   */
  offCallback(): void {
    emitter.off(this.callbackEvent.eventId);
  }

  /**
   * 更新key为'content'的变量值
   * @param { SubWindowParams } params - 页面显示的值
   */
  updateOrCreateParams(params: SubWindowParams): void {
    this.Storage.setOrCreate("content", params.sum);
  }

  /**
   * 创建并展示弹窗
   * @param { SubWindowParams } params - 页面显示的值
   * @param { Handler } handler - WindowStage对象
   */
  initSubWindow(handler: Handler, params: SubWindowParams): void {
    const windowStage = handler.windowStage;
    // 注册回调
    this.subscribeCallback();
    // 初始化参数
    this.updateOrCreateParams(params);
    // 新建子窗口
    this.createSubWindow(windowStage);
  }

  /**
   * 隐藏弹窗
   */
  hideSubWindow(): void {
    // 注销监听事件
    this.offCallback();
    // 关闭弹窗
    this.destroySubWindow();
  }
}
