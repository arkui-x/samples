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
import { image } from '@kit.ImageKit';
import { SessionData } from '../../datasource/GroupAvatarModel';

/**
 * 会话展示列表
 */
@Component
export struct SessionTabContent {
  @State sessionGroup: SessionData[] = AppStorage.get('sessionList') as SessionData[];
  @State isLoading: Boolean = false;
  @State groupAvatarPixelMap: image.PixelMap | undefined = undefined;

  onPageShow(): void {
    // 页面显示时，更新sessionList数据
    this.sessionGroup = AppStorage.get('sessionList') as SessionData[];
  }

  build() {
    /**
     * 聊天会话列表
     */
    List() {
      // TODO: 需求：真实场景下，当用户数据较大时，建议使用LazyForEach组件
      ForEach(this.sessionGroup, (item: SessionData) => {
        ListItem() {
          SessionListItem(item);
        }
      }, (item: SessionData) => item.wid)
    }
    .id('group_avatar_session_list')
    .scrollBar(BarState.Off)
    .width($r('app.string.group_avatar_full_size')).height($r('app.string.group_avatar_full_size'))
    .backgroundColor($r('app.color.group_avatar_white'))
  }
}

@Builder
function SessionListItem(sessionItem: SessionData) {
  Row() {
    // 头像
    Flex({
      direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems:
      ItemAlign.Center
    }) {
      Image(typeof sessionItem.headImg === 'string' ? $rawfile(sessionItem.headImg) : sessionItem.headImg)
        .borderRadius(5)
        .width($r('app.string.group_avatar_person_header_size'))
        .height($r('app.string.group_avatar_person_header_size'))
        .backgroundColor($r('app.color.group_avatar_navigation'))
    }
    .width($r('app.integer.group_avatar_session_header_size'))
    .height($r('app.integer.group_avatar_session_header_size'))

    //昵称及最后消息
    Column() {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
        Text(sessionItem.name)
          .width($r('app.string.group_avatar_full_size'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize($r('app.integer.group_avatar_person_name_font_size'))
          .margin({ bottom: 1 })
        Text(sessionItem.lastMsg)
          .width($r('app.string.group_avatar_full_size'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize($r('app.integer.group_avatar_bottom_font_size'))
          .opacity(0.6)
          .margin({ top: 1 })
      }
      .width($r('app.string.group_avatar_full_size'))
      .height($r('app.integer.group_avatar_custom_loading_drawing_size'))

      Divider()
        .width($r('app.string.group_avatar_full_size'))
        .color($r('app.color.group_avatar_black'))
        .opacity(0.1)
        .strokeWidth(0.8)
    }.height($r('app.integer.group_avatar_session_header_size')).layoutWeight(1)
  }
  .height($r('app.integer.group_avatar_session_header_size'))
  .width($r('app.string.group_avatar_full_size'))
  .backgroundColor($r('app.color.group_avatar_white'))
}

