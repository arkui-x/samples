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

import { display, window } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { DynamicsRouter } from '../router/DynamicsRouter';

// 默认手机窗口尺寸
export const DEFAULT_WINDOW_SIZE: window.Size = { width: 1280, height: 2580 };

/*
 * 设置导航栏显示改变模式枚举值
 */
export enum NavMode {
  DefaultMode, // 默认模式
  FoldMode, // 折叠模式
  ChildPageMode, // 进入子页面模式
  HomePageMode // 返回首页模式
}

// 路由跳转延时
const DELAY_TIME: number = 20;

/**
 * 兼容折叠屏下的路由跳转
 */
export class FoldableRouter {
  /**
   * 兼容折叠屏下的路由跳转
   * @param uri 路由名称
   * @param param 路由参数
   */
  public static pushUri(uri: string, param: ESObject) {
    // 记录当前进入路由名称
    AppStorage.setOrCreate('enterRouteName', uri);
    // 定义事件3
    let innerEvent: emitter.InnerEvent = {
      eventId: 3
    };
    let eventData: emitter.EventData = {
      data: {
        navMode: NavMode.ChildPageMode
      }
    };
    // 触发EntryView下navMode改变
    emitter.emit(innerEvent, eventData);
    // 获取当前窗口宽度
    let displayInfo = display.getDefaultDisplaySync();
    let windowSize = AppStorage.get<window.Size>('windowSize') !== undefined ? AppStorage.get<window.Size>('windowSize') : {
      width: displayInfo.width,
      height: displayInfo.height
    } as window.Size;

    // 友盟进入案例埋点
    let enterCaseData: emitter.EventData = {
      data: {
        uri: uri
      }
    };
    emitter.emit('enterCase', enterCaseData);
    // 宽屏条件下跳转
    if (windowSize!.width > DEFAULT_WINDOW_SIZE.width) {
      DynamicsRouter.clear();
      if (DynamicsRouter.timer) {
        clearTimeout(DynamicsRouter.timer);
      }
      // Navigation的mode属性修改会有一段响应时间，需延时跳转
      DynamicsRouter.timer = setTimeout(() => {
        DynamicsRouter.pushUri(uri, param);
      }, DELAY_TIME);
    } else {
      DynamicsRouter.pushUri(uri, param);
    }
  }
}