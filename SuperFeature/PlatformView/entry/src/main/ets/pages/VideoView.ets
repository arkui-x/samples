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
import { deviceInfo } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State title: string = 'PlatformView VideoView'
  private osFullNameInfo: string = '';

  aboutToAppear(): void {
    this.osFullNameInfo = deviceInfo.osFullName;
  }

  build() {
    Row() {
      Column() {
        MainPageComponent()
        if (this.osFullNameInfo.startsWith("OpenHarmony")) {
          Video({
            src: $rawfile('video.mp4')
          })
            .width('50%')
            .height('50%')
            .objectFit(ImageFit.Contain)
            .autoPlay(true)
        } else if (this.osFullNameInfo.startsWith("Android") ||
        this.osFullNameInfo.startsWith("iOS") ||
        this.osFullNameInfo.startsWith("iPadOS")) {
          PlatformView('VideoView')
            .width(216)
            .height(384)
        }
      }
      .height('100%')
      .width('100%')
    }
  }
}