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

import { TabBarData, TabBarType, TabsInfo } from '../model/TabBarModel';
import { promptAction } from '@kit.ArkUI';

const FONT_WEIGHT: number = 600; // 设置文本的字体粗细
const INITIAL_MARGIN: number = 0; //非选中状态的外边距初始值
const MARGIN: number = -15; //选中状态的外边距值

/**
 * 首页底部tabs效果，可用于切换不同页面，本案例仅做展示，不参与功能开发
 * @param {TabBarType} currentIndex - Tab组件当前选中index值（必需）
 */
@Component
export struct CustomTabBar {
  @Link currentIndex: TabBarType; // Tab组件当前选中index值

  build() {
    Row() {
      ForEach(TabsInfo, (item: TabBarData) => {
        this.TabItem(item.id);
      }, (item: TabBarData) => item.id.toString())
    }
    .id('customTabBar')
    .backgroundColor(Color.White)
    .clip(false)
    .width($r('app.string.multiple_screening_all_percentage'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  TabItem(index: number) {
    Column() {
      Image(this.currentIndex === index ? TabsInfo[index].activeIcon : TabsInfo[index].defaultIcon)
        .size(index === TabBarType.CHALLENGE ?
          {
            width: $r('app.integer.multiple_screening_custom_tab_bar_initial_image_width'),
            height: $r('app.integer.multiple_screening_custom_tab_bar_initial_image_height')
          } :
          {
            width: $r('app.integer.multiple_screening_custom_tab_bar_image_height'),
            height: $r('app.integer.multiple_screening_custom_tab_bar_image_height')
          })
        .margin({ top: index === TabBarType.CHALLENGE ? MARGIN : INITIAL_MARGIN })
      Text(TabsInfo[index].title)
        .fontSize($r('app.integer.multiple_screening_custom_tab_bar_text'))
        .margin({ top: $r('app.integer.multiple_screening_custom_tab_bar_text_margin') })
        .fontWeight(FONT_WEIGHT)
        .fontColor(this.currentIndex === index ? $r('app.color.multiple_screening_custom_tab_bar_text_color') :
        $r('app.color.multiple_screening_custom_title_search_color'))
    }
    .clip(false)
    .padding({
      top: $r('app.integer.multiple_screening_custom_tab_bar_item_padding'),
      bottom: $r('app.integer.multiple_screening_custom_tab_bar_item_padding')
    })
    .height($r('app.integer.multiple_screening_custom_tab_bar_height'))
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 调用Toast显示提示:此样式仅为案例展示
      promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
    })
  }
}