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

import router from '@ohos.router'
import { TitleBar } from '../component/TitleBar'
import Logger from '../utils/Logger'
import { GridRowModifier } from '@ohos.arkui.modifier'

class MyModifier extends GridRowModifier {
  applyNormalAttribute(instance: GridRowModifier): void {
    instance
      .alignItems(ItemAlign.Stretch)
      .width("100%")
      .height("100%")
  }
}

@Entry
@Component
struct TestGridRowModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      GridRow({
        columns: 5,
      }) {
        GridCol() {
          Row().width("100%").height("20vp")
        }
        .span(4)
        .gridColOffset(20)
        .order(5)
        .borderWidth(10)
        .backgroundColor(Color.Red)
      }
      .attributeModifier(this.modifier)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
