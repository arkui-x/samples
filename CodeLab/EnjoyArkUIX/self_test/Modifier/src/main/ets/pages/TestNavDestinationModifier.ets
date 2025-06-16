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
import { NavDestinationModifier } from '@ohos.arkui.modifier'

class MyModifier extends NavDestinationModifier {
  applyNormalAttribute(instance: NavDestinationModifier): void {
    instance
      .title('NavDestination')
      .hideTitleBar(false)
      .hideToolBar(false)
      .mode(NavDestinationMode.STANDARD)
      .backButtonIcon($r('app.media.ic_back'))
      .menus([
        {
          value: '菜单1',
          icon: $r('app.media.icon'),
          isEnabled: true
        },
        {
          value: '菜单3',
          icon: $r('app.media.icon'),
          isEnabled: false
        }
      ])
      .systemTransition(NavigationSystemTransitionType.SLIDE_RIGHT)
      .hideBackButton(false)
      .width('90%')
      .height('90%')
  }
}

@Entry
@Component
struct TestNavDestinationModifier {
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
      NavDestination() {
        Text('NavDestination的')
        Text('子组件Text')
      }
      .attributeModifier(this.modifier)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
