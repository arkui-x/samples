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
import router from '@ohos.router';
import PlatformView, { PlatformViewAttribute } from '@arkui-x.platformview';
@Entry
@Component
struct Index {
  @State title: string = 'PlatformView MapView'

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .margin(5)
        Button('Back')
          .width('75%')
          .height(50)
          .fontSize(15)
          .margin(5)
          .onClick(() => {
            router.back({ url: 'pages/Index' });
          })
        PlatformView('MapView')
          .width('75%')
          .height('75%')
          .borderWidth(5)
      }
      .width('100%')
    }
    .height('100%')
  }
}