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
@Entry
@Component
struct Index {
  @State title: string = 'PlatformView'

  build() {
    Column() {
      Row() {
        Column() {
          Text(this.title)
            .fontSize(35)
            .margin(5)
          Button('MapView')
            .width('75%')
            .height(50)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              router.pushUrl({ url: 'pages/MapView' });
            })
          Button('WebView')
            .width('75%')
            .height(50)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              router.pushUrl({ url: 'pages/WebView' });
            })
          Button('VideoView')
            .width('75%')
            .height(50)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              router.pushUrl({ url: 'pages/VideoView' });
            })
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}