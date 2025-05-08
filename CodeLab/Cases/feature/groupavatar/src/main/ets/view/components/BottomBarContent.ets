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
/**
 * 底部Tab栏
 */
import { promptAction } from '@kit.ArkUI';
import { TabItem } from '../../datasource/GroupAvatarModel';

@Component
export struct BottomBarContent {
  private tabSrc: number[] = [0, 1, 2, 3];
  @Link bottomTabIndex: number;
  private tabItemArray: Array<TabItem> = [
    {
      imgSrcNomral: $r("app.media.group_avatar_message_normal"),
      imgSrcPress: $r("app.media.group_avatar_message_pressed"),
      tabText: $r('app.string.group_avatar_bottom_tab_wechat')
    }, {
    imgSrcNomral: $r("app.media.group_avatar_contacts_group_normal"),
    imgSrcPress: $r("app.media.group_avatar_contacts_group_pressed"),
    tabText: $r('app.string.group_avatar_bottom_tab_contact')
  }, {
    imgSrcNomral: $r("app.media.group_avatar_discover_normal"),
    imgSrcPress: $r("app.media.group_avatar_discover_pressed"),
    tabText: $r('app.string.group_avatar_bottom_tab_discovery')
  }, {
    imgSrcNomral: $r("app.media.group_avatar_contacts_normal"),
    imgSrcPress: $r("app.media.group_avatar_contacts_pressed"),
    tabText: $r('app.string.group_avatar_bottom_tab_me')
  }
  ];

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceEvenly }) {
      ForEach(this.tabSrc, (item: number) => {
        Column() {
          Image((this.bottomTabIndex == item) ? this.tabItemArray[item].imgSrcPress :
          this.tabItemArray[item].imgSrcNomral)
            .objectFit(ImageFit.Contain)
            .width($r('app.integer.group_avatar_bottom_icon_size'))
            .height($r('app.integer.group_avatar_bottom_icon_size'))
          Text(this.tabItemArray[item].tabText)
            .fontSize($r('app.integer.group_avatar_bottom_font_size'))
            .margin({ top: $r('app.integer.group_avatar_bottom_margin_top') })
        }
        .height($r('app.integer.group_avatar_bottom_height'))
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.group_avatar_toast_message_no_supported')
          });
        })
      }, (item: number) => item.toString())
    }
    .id('group_avatar_bottom_bar')
    .width($r('app.string.group_avatar_full_size'))
    .backgroundColor($r('app.color.group_avatar_navigation'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}