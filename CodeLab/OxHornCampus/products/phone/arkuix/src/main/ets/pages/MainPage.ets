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

import { BreakpointSystem } from '@ohos/utils';
import { Zones } from '@ohos/zones';
import { Map } from '@ohos/map';
import { Trains } from '@ohos/train';
import { BottomTabsList } from '@ohos/main';

@Entry({ routeName: 'MainPage' })
@Component
struct Index {
  @StorageLink('bottomTabIndex') bottomTabIndex: number = 1;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  private controller: TabsController = new TabsController();
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear(): void {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  @Builder
  TabBuilder(index: number, name: string) {
    Column() {
      Image(this.bottomTabIndex === index ? BottomTabsList[index].iconSelected : BottomTabsList[index].icon)
        .width('40%')
        .height('40%')
        .objectFit(ImageFit.Contain)

      Text(BottomTabsList[index].text)
        .fontSize($r('app.float.bottom_font_size'))
        .opacity(0.6)
        .fontColor(this.bottomTabIndex === index ?
        $r('app.color.bottom_tabs_font_color_selected') : $r('app.color.bottom_tabs_font_color'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .border({ width: { top: 0.5 }, color: "#FF182431" })
    .backgroundColor($r('app.color.bottom_tabs_background_color'))
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.End, justifyContent: FlexAlign.End }) {
      Tabs({ barPosition: BarPosition.End, index: this.bottomTabIndex, controller: this.controller }) {
        TabContent() {
          Map()
        }.tabBar(this.TabBuilder(0, 'Map'))

        TabContent() {
          Zones()
        }.tabBar(this.TabBuilder(1, 'Zone'))

        TabContent() {
          Trains()
        }.tabBar(this.TabBuilder(2, 'Train'))
      }
      .width('100%')
      .vertical(false)
      .barHeight('10%')
      .scrollable(false)
      .onChange((index: number) => {
        this.bottomTabIndex = index;
      })
      .height('100%')
    }
    .width('100%')
  }
}