/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { Router } from '@kit.ArkUI';

@Entry
@Component
struct Home {
  private router: Router = this.getUIContext().getRouter();

  build() {
    Column({ space: 24 }) {
      Text('initialScale / overScrollMode \n属性测试')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)

      Button('显式调用测试')
        .id('goWebScaleAndOverScrollTest')
        .width('60%')
        .height(48)
        .onClick(() => {
          this.router.pushUrl({ url: 'pages/Index' });
        })

      Button('非显式调用测试')
        .id('goNonExplicitTest')
        .width('60%')
        .height(48)
        .onClick(() => {
          this.router.pushUrl({ url: 'pages/NonExplicit' });
        })

      Button('overScrollMode枚举值测试')
        .id('goOverScrollModeTest')
        .width('60%')
        .height(48)
        .onClick(() => {
          this.router.pushUrl({ url: 'pages/OverScrollModeTest' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F5F7FA')
  }
}
