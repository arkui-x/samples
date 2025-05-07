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
import Constant from '../../common/Constants';
import { emitter } from '@kit.BasicServicesKit';

/**
 * 功能说明：示例入口，通过Navigation跳转至Web页面和滚动组件页面
 *
 * 推荐场景：仅作为路由入口，不承载功能
 *
 * 核心组件:
 * 1. WebPageSnapshotPage
 * 2. ScrollableComponentSnapshotPage
 *
 * 实现步骤：
 *  1. 主页面使用Navigation组件作为根容器，并绑定WebPageSnapshotPage和ScrollableComponentSnapshotPage子页面
 *  2. 子页面使用NavDestination组件作为根容器，通过绑定路由栈到Navigation组件实现跳转
 */

@Component
export struct WebPageSnapshotComponent {
  // 注册路由返回函数，案例插件不触发
  popRouter: () => void = () => {
  };
  // Navigation路由栈
  pageInfos: NavPathStack = new NavPathStack()

  aboutToAppear(): void {
    this.listenBackPress();
  }

  listenBackPress() {
    let innerEvent: emitter.InnerEvent = {
      eventId: 6
    };
    // 收到eventId为6的事件后执行回调函数
    emitter.on(innerEvent, () => {
      // 在案例主页时，返回瀑布流
      if (this.pageInfos.size() === 0) {
        this.popRouter();
      }
    });

  }

  aboutToDisappear(): void {
    // 销毁事件监听
    emitter.off(6);
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Button(Constant.WEB_PAGE_TITLE, { stateEffect: true, type: ButtonType.Capsule })
          .id('web_page_snap_shot_web_page')
          .width($r('app.string.web_page_snap_shot_main_page_size_proportion'))
          .height($r('app.string.web_page_snap_shot_main_page_button_height'))
          .margin($r('app.string.web_page_snap_shot_main_page_button_margin'))
          .onClick(() => {
            this.pageInfos.pushPath({ name: Constant.WEB_PAGE_TITLE }) // 将name指定的NavDestination页面信息入栈
          })
        Button(Constant.COMPONENT_PAGE_TITLE, { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.web_page_snap_shot_main_page_size_proportion'))
          .height($r('app.string.web_page_snap_shot_main_page_button_height'))
          .margin($r('app.string.web_page_snap_shot_main_page_button_margin'))
          .onClick(() => {
            this.pageInfos.pushPath({ name: Constant.COMPONENT_PAGE_TITLE })
          })
      }
    }
    .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
    .height($r('app.string.web_page_snap_shot_web_snap_full_size'))
  }
}