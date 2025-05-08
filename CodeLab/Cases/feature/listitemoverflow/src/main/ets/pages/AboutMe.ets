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

import promptAction from '@ohos.promptAction';


/**
 * 功能描述: 本示例介绍在List组件内实现子组件超出容器边缘的布局样式的实现方法。List组件clip属性默认为true，超出容器边缘的子组件会按照List的布局范围被裁剪。为此，可以在List组件内部添加一个占位的ListItem，以达到预期的布局效果。List占满整个窗口或者不可滚动的情况下，也可以在List外占位，同时设置List的clip属性为false达成同样的效果。该布局效果多用于头像、列表子项标题等元素的突出显示。
 *
 * 推荐场景: 用于头像、列表子项标题等元素的突出显示
 *
 * 核心组件:
 * 1. AboutMeComponent
 *
 * 实现步骤：
 * 1. 设置头像框超出父组件ListItem范围。
 * 2. 在List内部使用ListItem占位，包住超出的区域。
 *
 * 实现步骤（另一种方式）：
 * 1. 设置头像框超出父组件ListItem范围。
 * 2. 在List组件外部使用Row占位。
 * 3. 设置List.clip(false)，允许滚动时List内部组件上下溢出List组件的区域。
 */

const ITEMOVERFLOW_LIST_SPACING = 20;

@Extend(Row)
function toastOnClick(msg: ResourceStr) {
  .clickEffect({ level: ClickEffectLevel.HEAVY })
  .onClick(() => {
    promptAction.showToast({ message: msg });
  })
}

@Extend(Image)
function imageStyle() {
  .width($r("app.integer.listitem_overflow_icon_size"))
  .height($r("app.integer.listitem_overflow_icon_size"))
  .margin($r("app.integer.listitem_overflow_default_margin"))
}

@Preview
@Component
export struct AboutMeComponent {
  popPage: (() => void) | undefined = undefined;

  build() {
    Column() {
      // TODO 知识点：List占满整个窗口或者不可滚动的情况下，也可以可以在List外部使用Row占位
      // Row().height($r("app.integer.itemoverflow_avatar_outer_padding_height")) // 方式二：占位组件
      List({ initialIndex: 0, space: ITEMOVERFLOW_LIST_SPACING }) {
        // TODO 知识点：在List内部使用ListItem占位，包住超出的区域
        // 占位组件
        ListItem().height($r("app.integer.listitem_overflow_avatar_padding_height")).selectable(false)
        // 用户信息
        ListItemGroup({ style: ListItemGroupStyle.CARD }) {
          ListItem({ style: ListItemStyle.CARD }) {
            this.userInfoItem(
              $r("app.media.listitem_overflow_io_user_portrait"),
              $r("app.string.listitem_overflow_nickname"),
              $r("app.string.listitem_overflow_toast_no_edit")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.signItem(
              $r("app.string.listitem_overflow_signature"),
              $r("app.string.listitem_overflow_toast_no_edit")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))
        }
        .divider({ strokeWidth: 1, color: $r("app.color.listitem_overflow_aboubtme_pageBcColor") })

        // 功能列表
        ListItemGroup({ style: ListItemGroupStyle.CARD }) {
          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_bank_cards"),
              $r("app.string.listitem_overflow_purse"),
              $r("app.string.listitem_overflow_toast_no_card")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_gift_cards"),
              $r("app.string.listitem_overflow_gift_cards"),
              $r("app.string.listitem_overflow_toast_no_gift_cards")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_credit_card"),
              $r("app.string.listitem_overflow_credit_card"),
              $r("app.string.listitem_overflow_toast_no_credit_card")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_payment"),
              $r("app.string.listitem_overflow_payment"),
              $r("app.string.listitem_overflow_toast_no_payment")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_health"),
              $r("app.string.listitem_overflow_health"),
              $r("app.string.listitem_overflow_toast_no_health")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_travel"),
              $r("app.string.listitem_overflow_travel"),
              $r("app.string.listitem_overflow_toast_no_travel")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_ticket"),
              $r("app.string.listitem_overflow_ticket"),
              $r("app.string.listitem_overflow_toast_no_ticket")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))
        }
        .divider({
          strokeWidth: 1,
          color: $r("app.color.listitem_overflow_aboubtme_pageBcColor"),
          startMargin: $r("app.integer.listitem_overflow_divide_start_margin")
        })

        // 其他
        ListItemGroup({ style: ListItemGroupStyle.CARD }) {
          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_highlightsed"),
              $r("app.string.listitem_overflow_favorite"),
              $r("app.string.listitem_overflow_toast_no_favorite")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_settings"),
              $r("app.string.listitem_overflow_settings"),
              $r("app.string.listitem_overflow_toast_no_settings")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))

          ListItem({ style: ListItemStyle.CARD }) {
            this.featureItem(
              $r("app.media.listitem_overflow_io_about"),
              $r("app.string.listitem_overflow_about"),
              $r("app.string.listitem_overflow_toast_about")
            )
          }.height($r("app.integer.listitem_overflow_default_item_height"))
        }
        .divider({
          strokeWidth: 1,
          color: $r("app.color.listitem_overflow_aboubtme_pageBcColor"),
          startMargin: $r("app.integer.listitem_overflow_divide_start_margin")
        })

        // 页脚
        ListItem() {
          this.footerItem($r("app.string.listitem_overflow_logout"))
        }.height($r("app.integer.listitem_overflow_default_item_height"))
      }
      .layoutWeight(1)
      .listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r("app.color.listitem_overflow_aboubtme_pageBcColor"))
      .width($r("app.string.listitem_overflow_full_size"))
      .height($r("app.string.listitem_overflow_full_size"))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width($r("app.string.listitem_overflow_full_size"))
    .height($r("app.string.listitem_overflow_full_size"))

    // TODO 知识点：由于List组件clip属性默认为true，若使用在List外占位的方式，需同时设置List的clip属性为false：
    // .clip(false) // 方式二：List内组件将不再根据List进行形状裁剪，允许滚动时内部组件溢出List的布局范围
  }

  /**
   * 用户信息组件。
   * @param portrait 头像图片
   * @param username 用户名
   * @param prompt 点击后的提示语
   */
  @Builder userInfoItem(portrait: ResourceStr, username: ResourceStr, prompt: ResourceStr) {
    Row() {
      // TODO 知识点：通过设置负的margin值，移动头像框位置，使其超出父组件范围
      Image(portrait)
        .width($r("app.integer.listitem_overflow_avatar_size"))
        .height($r("app.integer.listitem_overflow_avatar_size"))
        .margin({
          top: $r("app.integer.listitem_overflow_avatar_top_margin"),
          left: $r("app.integer.listitem_overflow_default_margin")
        })
        .borderRadius($r("app.integer.listitem_overflow_avatar_border_radius"))
        .clip(true)
      Text(username)
        .fontSize($r("sys.float.ohos_id_text_size_sub_title1"))
        .margin($r("app.integer.listitem_overflow_default_margin"))
        .fontWeight(FontWeight.Bold)
    }
    .width("100%")
    .toastOnClick(prompt)
  }

  /**
   * 个性签名组件。
   * @param text 个性签名
   * @param prompt 点击后的提示语
   */
  @Builder signItem(text: ResourceStr, prompt: ResourceStr) {
    Text(text)
      .width("100%")
      .fontSize($r("sys.float.ohos_id_text_size_body2"))
      .fontColor(Color.Grey)
      .margin($r("app.integer.listitem_overflow_default_margin"))
      .width('100%')
      .clickEffect({ level: ClickEffectLevel.HEAVY })
      .onClick(() => {
        promptAction.showToast({ message: prompt });
      })
  }

  /**
   * 功能组件。
   * @param icon 图标
   * @param text 标签
   * @param prompt 点击后的提示语
   */
  @Builder featureItem(icon: ResourceStr, text: ResourceStr, prompt: ResourceStr) {
    Row() {
      Image(icon).imageStyle()
      Text(text)
        .fontSize($r("sys.float.ohos_id_text_size_body1"))
        .margin($r("app.integer.listitem_overflow_default_margin"))
    }
    .width("100%")
    .toastOnClick(prompt)
  }

  /**
   * 页脚组件
   * @param text 标签
   */
  @Builder footerItem(text: ResourceStr) {
    Text(text)
      .fontSize($r("sys.float.ohos_id_text_size_body2"))
      .fontColor(Color.Red)
      .margin($r("app.integer.listitem_overflow_default_margin"))
      .onClick(() => {
        if (this.popPage) {
          this.popPage();
        } else {
          // 未传入返回接口时给出弹框提示
          promptAction.showToast({
            message: $r('app.string.pageflip_back_error_message'),
            duration: 1000
          })
        }
      })
      .width('100%')
      .textAlign(TextAlign.Center)
  }
}
