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

import { Router } from '@ohos.arkui.UIContext'
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State importRouter: router.RouterMode = router.RouterMode.Standard;
  @State router: Router = this.getUIContext().getRouter();
  @State message: string = 'KVStore Test'

  build() {
    Row() {
      Column({ space: 10 }) {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button("createKVManager测试")
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            this.router.pushUrl({
              url: 'pages/CreateKVManagerTest'
            })
          })
          .margin({ top: 10 })

        Button("KVManager测试")
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            this.router.pushUrl({
              url: 'pages/KVManagerTest/Index'
            })
          })

        Button("SingleKVStore测试")
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            this.router.pushUrl({
              url: 'pages/SingleKVStoreTest/Index'
            })
          })

        Button('Query测试')
          .id("Query")
          .onClick(() => {
            this.router.pushUrl({
              url: 'pages/Query/QueryIndex'
            })
          })

        Button('KVStoreResultSet测试')
          .id("KVStoreResultSet")
          .onClick(() => {
            this.router.pushUrl({
              url: 'pages/KVStoreResultSet/KVStoreResultSetIndex'
            })
          })

      }
      .width('100%')
    }
    .height('100%')
  }
}
