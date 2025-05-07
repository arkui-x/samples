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
import { BusinessError } from '@kit.BasicServicesKit';
import { SecondFloor } from './SecondFloor';
import { logger } from '../utils/Logger';
import { display } from '@kit.ArkUI';
import { DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

// 初始化窗口管理model
const windowStage: window.WindowStage | undefined = AppStorage.get('windowStage');

if (!windowStage) {
  window.getLastWindow(getContext()).then((windowClass: window.Window) => {
    windowClass.setWindowLayoutFullScreen(true);
    AppStorage.setOrCreate('statusHeight',
      windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height);
    AppStorage.setOrCreate('bottomHeight',
      windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height);
    AppStorage.setOrCreate('screenHeight', display.getDefaultDisplaySync().height);
  });
}

/**
 * 使用进入二楼隐藏界面组件样例
 *
 * 核心组件：
 * 1. SecondFloor
 *
 * 实现步骤：
 * 1. 将一楼页面二楼页面固定在相应位置，实时监听二楼Y轴大小用以达到页面可以正常移动
 * 2. 实时监听二楼Y轴大小，用二楼高度减去Y轴的绝对值计算出移动距离，用该距离来充当蒙层高度
 * 3. 用移动距离除以动效展示或消失高度获得相应的百分比，该百分比可用来展示动效缩放，用百分比乘以动效之间的距离，可以达到在X轴上移动效果
 */

@Component
export struct SecondFloorLoadAnimationComponent {
  aboutToAppear() {
    if (!windowStage) {
      return;
    }

    const windowClass: window.Window | undefined = windowStage.getMainWindowSync();
    windowClass.setWindowSystemBarEnable(["status"]);
    // 当前主窗口开启沉浸模式
    windowStage.getMainWindow((err, windowClass: window.Window) => {
      if (err.code) {
        return;
      }
      try {
        let promise = windowClass.setWindowLayoutFullScreen(true);
        promise.then(() => {
          logger.info('Succeeded in setting the window layout to full-screen mode.');
        }).catch((err: BusinessError) => {
          logger.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
        });
      } catch (exception) {
        logger.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(exception));
      }
    });
  }

  build() {
    Column() {
      // 一楼页面
      SecondFloor()
    }
    .width($r('app.string.second_floor_full_size'))
    .height($r('app.string.second_floor_full_size'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }

  aboutToDisappear(): void {
    if (!windowStage) {
      return;
    }
  }
}