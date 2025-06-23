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

import router from '@ohos.router';
import { TitleBar } from '../component/TitleBar';
import Logger from '../utils/Logger';
import { NavigationModifier } from '@ohos.arkui.modifier';
import { LengthUnit } from '@kit.ArkUI';

class MyModifier extends NavigationModifier {
  applyNormalAttribute(instance: NavigationModifier): void {
    super.applyNormalAttribute?.(instance);
    instance
      .title('Navigation', {
        backgroundColor: Color.Orange,
        backgroundBlurStyle: BlurStyle.BACKGROUND_THIN,
        barStyle: BarStyle.STANDARD,
        paddingStart: { value: 5, unit: LengthUnit.VP },
        paddingEnd: { value: 5, unit: LengthUnit.VP },
        enableHoverMode: false
      })
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
      .titleMode(NavigationTitleMode.Mini)
      .hideToolBar(false, true)
      .hideTitleBar(false, true)
      .hideBackButton(false)
      .navBarWidth('80%')
      .navBarPosition(NavBarPosition.Start)
      .mode(NavigationMode.Split)
      .backButtonIcon($r('app.media.ic_back'))
      .hideNavBar(false)
      .navBarWidthRange([260, 300])
      .minContentWidth(380)
      .enableDragBar(true)
      .enableModeChangeAnimation(true)
      .size({ width: '90%', height: '90%' })
      .backgroundColor(Color.Grey)
  }
}

@Entry
@Component
struct TestNavigationModifier {
  @State title: string = ''
  @State modifier: MyModifier = new MyModifier()
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    Logger.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }

  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })

      Navigation() {
        List({ space: 12, initialIndex: 0 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              Text('' + item)
                .width('90%')
                .height(72)
                .backgroundColor('#FFFFFF')
                .borderRadius(24)
                .fontSize(16)
                .fontWeight(500)
                .textAlign(TextAlign.Center)
            }
          }, (item: number) => item.toString())
        }
        .height('70%')
        .width('100%')
        .margin({ top: 12, left: '10%' })
      }
      .attributeModifier(this.modifier)
    }
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}


