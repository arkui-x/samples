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

import { NavigationBarContent } from './components/NavigationBarContent';
import { BottomBarContent } from './components/BottomBarContent';
import { SessionTabContent } from './components/SessionContent';
import { SESSION_LIST } from '../datasource/DataSource';
import { SessionData } from '../datasource/GroupAvatarModel';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

/**
 * 案例首页
 * 包含顶部导航栏、Tab页面（仅实现会话页面）、底部Tab栏
 *
 * 群头像实现逻辑请见自定义组件CustomLoadingComponent
 *
 */
@AppRouter({ name: 'groupavatar/GroupAvatarMainPage' })
@Component
export struct GroupAvatarMainPage {
  @State bottomTabIndex: number = 0;
  @State currentTitle: ResourceStr = $r('app.string.group_avatar_bottom_tab_wechat');
  @State sessionGroup: SessionData[] = [];
  @StorageLink('avoidAreaTopToModule') avoidAreaTopToModule: number = 0;
  private controller: TabsController = new TabsController();

  aboutToAppear(): void {
    // 页面加载时，重新获取数据，并反转数组，以实现倒序显示
    this.sessionGroup = [...SESSION_LIST].reverse();
    AppStorage.setOrCreate('sessionList', this.sessionGroup);
  }

  onPageShow(): void {
    // 页面展示时更新sessionGroup
    this.sessionGroup = AppStorage.get('sessionList') as SessionData[];
  }

  aboutToDisappear(): void {
    // 页面销毁时，删除AppStorage数据
    AppStorage.delete('sessionList');
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.End, justifyContent: FlexAlign.End }) {
      Column() {
      }
      .width($r('app.string.group_avatar_full_size'))
      .height(px2vp(this.avoidAreaTopToModule))
      .backgroundColor($r('app.color.group_avatar_navigation'))

      // 顶部导航栏
      NavigationBarContent({
        title: this.currentTitle,
        isMenu: true,
        isSearch: true
      })

      // Tab页面，仅实现会话列表页面，详情请见自定义组件SessionTabContent
      Tabs({ barPosition: BarPosition.End, index: 0, controller: this.controller }) {
        TabContent() {
          SessionTabContent({ sessionGroup: this.sessionGroup })
        }
      }
      .vertical(false)
      .barHeight(0)
      .width($r('app.string.group_avatar_full_size'))
      .scrollable(false)

      /**
       * 底部Tab栏
       */
      BottomBarContent({ bottomTabIndex: $bottomTabIndex })
    }
    .id('group_avatar_session_page')
    .backgroundColor($r('app.color.group_avatar_white'))
    .width($r('app.string.group_avatar_full_size'))
    .height($r('app.string.group_avatar_full_size'))
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}