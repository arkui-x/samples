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

import distributedKVStore from '@ohos.data.distributedKVStore';
import { common } from '@kit.AbilityKit';
import { Router } from '@ohos.arkui.UIContext'

const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

@Entry
@Component
struct Index {
  @State consoleInfo: string = "";
  @State context: common.BaseContext = context;
  @State bundleName: string = "com.example.distributedkvstoretest";
  @State router: Router = this.getUIContext().getRouter();

  scroller: Scroller = new Scroller()
  scroller2: Scroller = new Scroller()

  build() {
    Column() {
      Row() { // 导航栏
        Navigation() {
        }
        .height('100%')
        .width('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        // .title('createKVManager测试')
        .mode(NavigationMode.Stack);
      } // 导航栏
      .height(56)
      .width('100%')
      .onClick(async () => {
        this.router.back();
      });

      Row() { //这一行放了返回之外的一整页
        Column() {
          Text("KVManager测试")
            .fontSize(35)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 20 })

          Button("getKVStore测试")
            .fontWeight(FontWeight.Bold)
            .onClick(async () => {
              this.router.pushUrl({
                url: 'pages/KVManagerTest/GetKVStoreTest'
              })
            })
            .margin({ top: 10 })

          Button("FieldNode测试")
            .fontWeight(FontWeight.Bold)
            .onClick(async () => {
              this.router.pushUrl({
                url: 'pages/KVManagerTest/FieldNodeTest'
              })
            })
            .margin({ top: 10 })

          Button("closeKVStore测试")
            .fontWeight(FontWeight.Bold)
            .onClick(async () => {
              this.router.pushUrl({
                url: 'pages/KVManagerTest/CloseKVStoreTest'
              })
            })
            .margin({ top: 10 })

          Button("deleteKVStore测试")
            .fontWeight(FontWeight.Bold)
            .onClick(async () => {
              this.router.pushUrl({
                url: 'pages/KVManagerTest/DeleteKVStoreTest'
              })
            })
            .margin({ top: 10 })


        }.width('100%').height('100%')
        // .margin({ top: -56 })
        .justifyContent(FlexAlign.Center)

      } // 整页
      .width('100%')
      .padding({ left: '3.35%', right: '3.35%' })
      .margin({ bottom: 80 })
      .borderRadius(24)
    }
    .width('100%')
    .backgroundColor('#f1f3f5')
  }
}