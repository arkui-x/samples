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
import { DynamicsRouter } from 'routermodule';

/**
 * 顶部导航栏
 */
@Component
export struct NavigationBarContent {
  @State title: ResourceStr = '';
  @State isMenu: boolean = true;
  @State isSearch: boolean = true;

  // 菜单组件
  @Builder
  menuComponent() {
    Menu() {
      MenuItem({
        startIcon: $r("app.media.group_avatar_message_filled"),
        content: $r('app.string.group_avatar_menu_title_session')
      })
        .onClick(() => {
          DynamicsRouter.pushUri('groupavatar/GroupAvatarAddPage');
        })
      MenuItem({
        startIcon: $r("app.media.group_avatar_contacts_addcontact_filled"),
        content: $r('app.string.group_avatar_menu_title_add')
      })
      MenuItem({
        startIcon: $r("app.media.group_avatar_scan_filled"),
        content: $r('app.string.group_avatar_menu_title_scan')
      })
      MenuItem({
        startIcon: $r("app.media.group_avatar_cards"),
        content: $r('app.string.group_avatar_menu_title_pay')
      })
    }
    .id('group_avatar_menu')
    .backgroundColor($r('app.color.group_avatar_menu_background_color'))
    .fontColor($r('app.color.group_avatar_menu_font_color'))
    .font({ size: 14 })
    .radius(5)
  }

  build() {
    Row() {
      /**
       * 是否显示后退按钮
       */
      Column() {
        Image($r("app.media.group_avatar_arrow_left"))
          .width($r('app.integer.group_avatar_navigation_icon_size'))
          .height($r('app.integer.group_avatar_navigation_icon_size'))
          .onClick(() => {
            DynamicsRouter.popAppRouter();
          })
      }.width($r('app.integer.group_avatar_navigation_icon_column_width'))

      /**
       * 中间标题栏
       */
      Column() {
        Text(this.title)
          .fontSize($r('app.integer.group_avatar_navigation_title_font_size'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }.layoutWeight(1).padding({ left: 20 })

      Column() {
        // 是否显示搜索按钮
        if (this.isSearch) {
          Image($r("app.media.group_avatar_search"))
            .width($r('app.integer.group_avatar_navigation_icon_size'))
            .height($r('app.integer.group_avatar_navigation_icon_size'))
        }
      }.width($r('app.integer.group_avatar_navigation_icon_search_width'))

      // 是否显示菜单按钮
      Column() {
        if (this.isMenu) {
          Image($r("app.media.group_avatar_add_normal"))
            .id('group_avatar_menu_button')
            .width($r('app.integer.group_avatar_navigation_icon_size'))
            .height($r('app.integer.group_avatar_navigation_icon_size'))
            .bindMenu(this.menuComponent())
        }
      }.width($r('app.integer.group_avatar_navigation_icon_column_width'))
    }
    .id('group_avatar_title_bar')
    .height($r('app.integer.group_avatar_navigation_icon_column_height'))
    .width($r('app.string.group_avatar_full_size'))
    .backgroundColor($r('app.color.group_avatar_navigation'))
  }
}