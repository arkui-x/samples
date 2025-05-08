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

import { CommonSettingView } from "../dialog/CommonSettingView";
import { LimitedHeightBottomDialog } from "../dialog/LimitedHeightBottomDialog";
import { SecuritySettingView } from "../dialog/SecuritySettingView";
import { promptAction } from "@kit.ArkUI";
import { ActionItem } from "../model/ActionItem";
import { ActionSectionView } from "./ActionSectionView";

const DIALOG_MAX_SCROLL_HEIGHT = 600;  // 弹窗可滚动区域最大高度

/**
 * 创建常用设置底部弹窗视图
 */
@Builder
function createCommonSettingView() {
  CommonSettingView()
}

/**
 * 创建安全设置底部弹窗视图
 */
@Builder
function createSecuritySettingView() {
  SecuritySettingView()
}

/**
 * 功能描述: 本示例介绍了如何实现一个限制高度的底部弹窗，以购物应用的“我的”页面来呈现。当给一个底部弹窗的可滚动区域设置最大高度后，
 * 如果弹窗内部视图的高度超过了这个最大高度，弹窗可滚动区域的高度就是这个最大高度，视图内容不会展示完全，需要滚动查看；
 * 如果弹窗内部视图的高度没有超过这个最大高度，弹窗可滚动区域高度就是视图的高度，视图内容展示完全。
 *
 * 推荐场景: 需要出现底部弹窗
 *
 * 核心组件:
 * LimitedHeightBottomDialog
 *
 * 实现步骤:
 * 1. 创建一个限制高度的底部弹窗，这个弹窗内部视图和可滚动区域的最大高度可以通过外部传入。
 * 2. 创建常用设置底部弹窗的视图和安全设置底部弹窗的视图。
 * 3. 创建常用设置底部弹窗的CustomDialogController和创建安全设置底部弹窗的CustomDialogController，传入需要的参数。
 * 4. 调用常用设置底部弹窗的CustomDialogController或安全设置底部弹窗的CustomDialogController的open方法，让弹窗展示出来。
 */
@Component
export struct LimitedHeightBottomDialogComponent {
  popPage: (() => void) | undefined = undefined;

  private firstSectionActionItems: ActionItem[] =
    [{ id: '0', title: $r('app.string.limited_height_bottom_dialog_my_order'), subTitle: '' },
      { id: '1', title: $r('app.string.limited_height_bottom_dialog_my_collect'), subTitle: '' },
      { id: '2', title: $r('app.string.limited_height_bottom_dialog_footprint'), subTitle: '' },
      { id: '3', title: $r('app.string.limited_height_bottom_dialog_coupon'), subTitle: '' }]

  private secondSectionActionItems: ActionItem[] =
    [{ id: '4', title: $r('app.string.limited_height_bottom_dialog_common_setting'), subTitle: $r('app.string.limited_height_bottom_dialog_see_reached_the_limit_height_bottom_dialog') },
      { id: '5', title: $r('app.string.limited_height_bottom_dialog_security_setting'), subTitle: $r('app.string.limited_height_bottom_dialog_see_not_reached_the_limit_height_bottom_dialog') },
      { id: '6', title: $r('app.string.limited_height_bottom_dialog_feedback'), subTitle: '' },
      { id: '7', title: $r('app.string.limited_height_bottom_dialog_about'), subTitle: '' }]

  // 常用设置底部弹窗是否显示标记，与LimitedHeightBottomDialog中的showFlag双向绑定，用于底部弹窗出现与消失时的动效处理
  @State commonSettingDialogShowFlag: Visibility = Visibility.Visible;

  // 安全设置底部弹窗是否显示标记，与LimitedHeightBottomDialog中的showFlag双向绑定，用于底部弹窗出现与消失时的动效处理
  @State securitySettingDialogShowFlag: Visibility = Visibility.Visible;

  // 常用设置底部弹窗的CustomDialogController
  commonSettingDialogController: CustomDialogController = new CustomDialogController({
    builder: LimitedHeightBottomDialog({
      title: $r('app.string.limited_height_bottom_dialog_common_setting'),
      maxScrollHeight: DIALOG_MAX_SCROLL_HEIGHT,
      wrapBuilder: wrapBuilder(createCommonSettingView),
      showFlag: this.commonSettingDialogShowFlag
    }),
    alignment: DialogAlignment.Bottom,
    width: $r('app.string.limited_height_bottom_dialog_full_width'),
    customStyle: true,         // customStyle需要设置为true，否则底部弹窗出现的动效会有问题
    autoCancel: true,
    onWillDismiss: () => {     // 修改点击弹窗外部区域和返回操作时弹窗消失的方式，这里的处理会有一个动效。不加这个处理方式的话，弹窗会以默认的方式消失
      this.commonSettingDialogShowFlag = Visibility.Hidden;
    }
  });

  // 安全设置底部弹窗的CustomDialogController
  securitySettingDialogController: CustomDialogController = new CustomDialogController({
    builder: LimitedHeightBottomDialog({
      title: $r('app.string.limited_height_bottom_dialog_security_setting'),
      maxScrollHeight: DIALOG_MAX_SCROLL_HEIGHT,
      wrapBuilder: wrapBuilder(createSecuritySettingView),
      showFlag: this.securitySettingDialogShowFlag
    }),
    alignment: DialogAlignment.Bottom,
    width: $r('app.string.limited_height_bottom_dialog_full_width'),
    customStyle: true,
    autoCancel: true,
    onWillDismiss: () => {
      this.securitySettingDialogShowFlag = Visibility.Hidden;
    }
  });

  // 操作项点击处理
  private onClickItem = (id: string) => {
    switch (id) {
      case '4':
        // 这里需要将commonSettingDialogShowFlag设置为Visibility.Visible，否则可能无法显示弹窗，
        // 因为在弹窗关闭的时候将commonSettingDialogShowFlag设置为了Visibility.Hidden
        this.commonSettingDialogShowFlag = Visibility.Visible;
        // 弹出常用设置底部弹窗
        this.commonSettingDialogController.open();
        break;

      case '5':
        // 这里需要将securitySettingDialogShowFlag设置为Visibility.Visible，否则可能无法显示弹窗，
        // 因为在弹窗关闭的时候将securitySettingDialogShowFlag设置为了Visibility.Hidden
        this.securitySettingDialogShowFlag = Visibility.Visible;
        // 弹出安全设置底部弹窗
        this.securitySettingDialogController.open();
        break;

      default:
        promptAction.showToast({
          message: $r('app.string.limited_height_bottom_dialog_toast_tips')
        });
        break;
    }
  };

  build() {
    Column() {
      // 头像和昵称
      Row() {
        Image($r('app.media.limited_height_bottom_dialog_avatar'))
          .width($r('app.integer.limited_height_bottom_dialog_avatar_diameter'))
          .height($r('app.integer.limited_height_bottom_dialog_avatar_diameter'))
          .objectFit(ImageFit.Cover)
          .borderRadius($r('app.integer.limited_height_bottom_dialog_avatar_radius'))

        Text($r('app.string.limited_height_bottom_dialog_nickname'))
          .fontSize($r('app.integer.limited_height_bottom_dialog_nickname_font_size'))
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .margin({
            left: $r('app.integer.limited_height_bottom_dialog_nickname_left_margin')
          })
      }.width($r('app.string.limited_height_bottom_dialog_full_width'))
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.limited_height_bottom_dialog_toast_tips')
        });
      })

      // 可操作的栏目
      ActionSectionView({
        actionItems: this.firstSectionActionItems
      }).margin({
        top: $r('app.integer.limited_height_bottom_dialog_section_gap')
      })

      // 可操作的栏目
      ActionSectionView({
        actionItems: this.secondSectionActionItems,
        onClickItem: this.onClickItem
      }).margin({
        top: $r('app.integer.limited_height_bottom_dialog_section_gap')
      })

      Text($r('app.string.limited_height_bottom_dialog_explain'))
        .fontSize($r('app.integer.limited_height_bottom_dialog_explain_font_size'))
        .fontColor(Color.Gray)
        .margin({
          top: $r('app.integer.limited_height_bottom_dialog_section_gap')
        })
    }.width($r('app.string.limited_height_bottom_dialog_full_width'))
    .height($r('app.string.limited_height_bottom_dialog_full_width'))
    .padding({
      left: $r('app.integer.limited_height_bottom_dialog_left_and_right_padding'),
      right: $r('app.integer.limited_height_bottom_dialog_left_and_right_padding'),
      top: $r('app.integer.limited_height_bottom_dialog_top_padding')
    })
    .backgroundColor($r('app.color.limited_height_bottom_dialog_background_color'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }

}