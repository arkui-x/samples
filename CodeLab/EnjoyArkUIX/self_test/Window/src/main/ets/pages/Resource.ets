/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { TitleBar } from './TitleBar';

@Entry
@Component
struct Resource {
  @State label1: string = 'Back'

  build() {
    Row() {
      Column() {
        TitleBar({ title: $r('app.string.Resource_title') })
          .width('100%')

        Button(this.label1)
          .backgroundColor($r("app.color.color"))
          .height($r("app.float.float"))
          .width($r("app.string.label"))
          .fontSize(20)
          .margin({ top: 20 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/EnterPage' })
          })

        Image($r("app.media.girl"))
          .width(150)
          .height(150)
          .margin({ top: 20 })

        Image($r("sys.media.ohos_app_icon"))
          .height(50)
          .width(50)
          .margin({ top: 20 })

      }
      .width('100%')
    }
    .height('100%')
  }
}