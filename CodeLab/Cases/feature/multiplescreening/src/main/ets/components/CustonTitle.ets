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

import { promptAction } from "@kit.ArkUI";

const FONT_WEIGHT: number = 600; // 设置文本的字体粗细

/**
 * 首页顶部标题，渲染效果不参与筛选功能开发
 */
@Component
export struct CustomTitle {
  build() {
    Column() {
      Text($r('app.string.multiple_screening_custom_title_text'))
        .fontSize($r('app.integer.multiple_screening_custom_title_text_font'))
        .width($r('app.string.multiple_screening_all_percentage'))
        .textAlign(TextAlign.Center)
        .fontStyle(FontStyle.Italic)
        .fontWeight(FontWeight.Bold)

      Row() {
        Search({ placeholder: $r('app.string.multiple_screening_custom_title_search') })
          .width($r('app.string.multiple_screening_info_card_product_details_row'))
          .height($r('app.integer.multiple_screening_custom_title_search_height'))
          .margin($r('app.integer.multiple_screening_custom_title_search_margin'))
          .placeholderColor($r('app.color.multiple_screening_custom_title_search_color'))
          .searchIcon({
            size: $r('app.integer.multiple_screening_custom_title_search_size'),
            color: $r('app.color.multiple_screening_custom_title_search_color')
          })
          .focusable(false)
          .onClick(() => {
            // 调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
          })
        Column() {
          Image($r('app.media.multiple_screening_tab_mine_off'))
            .size({
              width: $r('app.integer.multiple_screening_custom_title_map_size'),
              height: $r('app.integer.multiple_screening_custom_title_map_size')
            })
            .margin({ top: $r('app.integer.multiple_screening_custom_title_map_margin') })
          Text($r('app.string.multiple_screening_custom_title_map'))
            .fontSize($r('app.integer.multiple_screening_custom_title_map_text'))
            .margin({ top: $r('app.integer.multiple_screening_custom_title_map_text_margin') })
            .fontWeight(FONT_WEIGHT)
            .fontColor($r('app.color.multiple_screening_custom_title_search_color'))
        }
        .clip(false)
        .padding({
          top: $r('app.integer.multiple_screening_custom_title_map_text_padding'),
          bottom: $r('app.integer.multiple_screening_custom_title_map_text_padding')
        })
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          // 调用Toast显示提示:此样式仅为案例展示
          promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
        })
      }
    }
    .id('customTitle')
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}