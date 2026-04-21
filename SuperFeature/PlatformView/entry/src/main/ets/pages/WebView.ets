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

import { MainPageComponent } from 'effectkit';
import PlatformView, { PlatformViewAttribute } from '@arkui-x.platformview';
import webview from '@ohos.web.webview'
import { deviceInfo } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State title: string = 'PlatformView WebView'
  controller: webview.WebviewController = new webview.WebviewController()
  private osFullNameInfo: string = '';

  aboutToAppear(): void {
    this.osFullNameInfo = deviceInfo.osFullName;
  }

  build() {
    Row() {
      Column() {
        MainPageComponent()
        if (this.osFullNameInfo.startsWith("OpenHarmony")) {
          Web({ src: 'https://www.gitcode.com/arkui-x', controller: this.controller })
            .width('100%')
            .height('100%')
            .domStorageAccess(true)
        } else if (this.osFullNameInfo.startsWith("Android") ||
        this.osFullNameInfo.startsWith("iOS") ||
        this.osFullNameInfo.startsWith("iPadOS")) {
          PlatformView('WebView')
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}