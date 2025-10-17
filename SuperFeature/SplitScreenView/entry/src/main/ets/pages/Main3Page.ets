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

import { router } from '@kit.ArkUI'

@Entry
@Component
struct Main3Page {
  @State message: string = '应用界面-C'

  build() {
    Row() {
      Scroll() {
        Column() {
          Text(this.message)
            .fontSize(35)
            .fontWeight(FontWeight.Bold)

          Button('返回')
            .fontSize(20)
            .size({ width: '95%', height: 45 })
            .margin({ top: 15 })
            .backgroundColor(Color.Green)
            .onClick(() => {
              router.back()
            })

        }.width('100%')
      }.scrollBar(BarState.Off)
    }.height('100%')
  }
}