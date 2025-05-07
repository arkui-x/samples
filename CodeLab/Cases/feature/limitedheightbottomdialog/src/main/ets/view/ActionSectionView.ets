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

import { ActionItem } from "../model/ActionItem"
import { promptAction } from "@kit.ArkUI"

/**
 * 操作组合组件
 */
@Component
export struct ActionSectionView {

  actionItems: ActionItem[] = [];       // 操作项数组
  onClickItem?: (id: string) => void;   // 操作项点击处理

  build() {
    Column() {
      ForEach(this.actionItems, (actionItem: ActionItem, index: number) => {
        this.createActionItem(actionItem, this.onClickItem)
        if (index < this.actionItems.length - 1) {
          this.createDivider()
        }
      })
    }.sectionStyle()
  }

  /**
   * 创建一条操作栏目的视图
   * @param title
   * @param onClick
   * @param subTitle
   */
  @Builder
  createActionItem(actionItem: ActionItem,
    onClickItem?: (id: string) => void) {
    Row() {
      Text(actionItem.title)
        .fontSize($r('app.integer.limited_height_bottom_dialog_section_item_title_font_size'))
        .fontColor(Color.Black)

      Text(actionItem.subTitle)
        .fontSize($r('app.integer.limited_height_bottom_dialog_section_item_sub_title_font_size'))
        .fontColor(Color.Gray)
        .margin({
          left: $r('app.integer.limited_height_bottom_dialog_section_item_sub_title_left_margin')
        })

      Blank()

      Image($r("app.media.limited_height_bottom_dialog_right_arrow"))
        .width($r('app.integer.limited_height_bottom_dialog_right_arrow_width'))
        .height($r('app.integer.limited_height_bottom_dialog_right_arrow_height'))
    }
    .alignItems(VerticalAlign.Center)
    .width($r('app.string.limited_height_bottom_dialog_full_width'))
    .height($r('app.integer.limited_height_bottom_dialog_section_item_height'))
    .onClick(() => {
      if (onClickItem) {
        onClickItem(actionItem.id)
      } else {
        promptAction.showToast({
          message: $r('app.string.limited_height_bottom_dialog_toast_tips')
        });
      }
    })
  }

  /**
   * 创建特定样式的分隔线
   */
  @Builder
  createDivider() {
    Divider()
      .vertical(false)
      .strokeWidth(0.5)
      .color($r('app.color.limited_height_bottom_dialog_divider_color'))
  }

  /**
   * section的样式
   */
  @Styles
  sectionStyle() {
    .width($r('app.string.limited_height_bottom_dialog_full_width'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.integer.limited_height_bottom_dialog_section_border_radius'))
    .padding({
      left: $r('app.integer.limited_height_bottom_dialog_section_left_and_right_padding'),
      right: $r('app.integer.limited_height_bottom_dialog_section_left_and_right_padding')
    })
  }

}