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
import { TabsModifier } from '@ohos.arkui.modifier'

class MyModifier extends TabsModifier {
  applyNormalAttribute(instance: TabsModifier): void {
    instance
      .vertical(false)
      .scrollable(true)
      .barMode(BarMode.Fixed)
      .barWidth(300)
      .barHeight(100)
      .animationDuration(2000)
      .animationMode(AnimationMode.ACTION_FIRST)
      .barPosition(BarPosition.Start)
      .divider({
        strokeWidth: 5,
        color: Color.Red,
        startMargin: 3,
        endMargin: 3
      })
      .fadingEdge(true)
      .barOverlap(true)
      .barBackgroundColor(Color.Yellow)
      .barBackgroundBlurStyle(BlurStyle.Thin)
      .barGridAlign({ sm: 2, margin: 10, gutter: 10 })
      .edgeEffect(EdgeEffect.Spring)
      .pageFlipMode(PageFlipMode.CONTINUOUS)
      .size({ width: '90%', height: '80%' })
      .margin({ top: 10, bottom: 10 })
  }
}

@Entry
@Component
struct TestTabsModifier {
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

      Tabs() {
        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Pink)
        }.tabBar('页面-1')

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Green)
        }.tabBar('页面-2')

        TabContent() {
          Column().width('100%').height('100%').backgroundColor(Color.Orange)
        }.tabBar('页面-3')
      }
      .attributeModifier(this.modifier)

    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
