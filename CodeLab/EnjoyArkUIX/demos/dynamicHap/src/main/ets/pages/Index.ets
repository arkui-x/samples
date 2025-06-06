/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import router from '@ohos.router';
import window from '@ohos.window';
import connection from '@ohos.net.connection';
import deviceInfo from '@ohos.deviceInfo';

@Entry
@Component
struct Index {
  @State message: string = '预制演示页面'
  private windowStage?: window.WindowStage = AppStorage.get("windowStage");
  private window?: window.Window;
  private netCon?: connection.NetConnection = undefined;
  @State osName: string = deviceInfo.osFullName;

  build() {
    Row() {
      Scroll() {
        Column() {
          Text(this.message)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin(10)
          Button("布局控件").onClick(() => {
            router.pushUrl({
              url: 'pages/common/CommonComponent3'
            });
          }).width('90%').margin(10)

          Button("常用组件1").onClick(() => {
            router.pushUrl({
              url: 'pages/common/CommonComponent1'
            });
          }).width('90%').margin(10)

          Button("常用组件2").onClick(() => {
            router.pushUrl({
              url: 'pages/common/CommonComponent2'
            });
          }).width('90%').margin(10)

          Button("常用组件3").onClick(() => {
            router.pushUrl({
              url: 'pages/common/CommonComponent4'
            });
          }).width('90%').margin(10)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}
