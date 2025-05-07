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

import { TabBarInfo } from '../model/DataType';
import { CommonConstants } from '../common/CommonConstants';

/**
 * 功能描述:
 * 1. 将Image组件外层包裹一层容器组件，通过设置borderRadius以及margin的top值实现圆弧外轮廓效果
 * 2. 通过当前被选中的tabBar下标值和tabBar自己的下标值进行判断来达到点击之后改变图标显示的效果
 *
 * 实现原理:
 * 场景1：TabBar中间页面如何实现有一圈圆弧外轮廓
 * 可以将Image外层包括一层容器组件，通过设置borderRadius以及margin的top值实现圆弧外轮廓效果。
 * 这里borderRadius的值设置为容器组件宽度的一半，margin的top值根据开发者的ux效果设置合适的值即可。
 * 场景2：TabBar页签点击之后会改变图标显示，并有一小段动画效果
 * 改变图标显示可以声明一个变量selectedIndex，此变量代表被选定的tabBar下标，点击的时候将当前tabBar的下标值进行赋值。
 * 通过当前被选中的tabBar下标值和tabBar的默认下标值进行判断来达到点击之后改变图标显示的效果。
 * 动画效果可以将Image添加一个offset属性和animation属性，offset属性可以控制组件的横向和纵向偏移量；
 * animation在组件的某些通用属性变化时，可以通过属性动画animation实现过渡效果。
 * 点击TabBar页签，改变offset的属性值，自动触发animation属性动画。
 * animation参考文档:
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-animatorproperty-V5
 *
 * @param {number} [selectedIndex] - 配置起始的页签索引（必传）
 * @param {TabInfo[]} [tabsInfo] - tab信息
 */

@Component
export struct CustomTabBar {
  // ----------------对外暴露变量----------------
  // 配置起始的页签索引（必传）
  @Link selectedIndex: number;
  // tabBar数据
  tabsInfo: TabBarInfo[] = [];
  // ------------------私有属性-----------------
  // 初始化tabBar图片的偏移量
  @State iconOffset: number = 0;
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;

  build() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceAround, alignItems: ItemAlign.Center }) {
      // 数据量比较少的情况下推荐使用ForEach，遇到数据量比较多的场景，如列表场景、瀑布流场景等，推荐使用LazyForEach(https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5)
      ForEach(this.tabsInfo, (item: TabBarInfo, tabBarIndex: number) => {
        // 单独一个TabBar组件
        this.tabItemBuilder(tabBarIndex)
      }, (item: TabBarInfo) => JSON.stringify(item))
    }
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .height($r('app.integer.custom_tab_height_size'))
  }

  aboutToAppear(): void {
    // 检查输入参数
    this.checkParam();
    // 私有变量初始化
    this.iconOffset = -3;
  }

  /**
   * 检查输入参数
   */
  checkParam() {
    if (!this.tabsInfo || this.tabsInfo.length === 0) {
      this.tabsInfo = [
        new TabBarInfo(0, CommonConstants.DEFAULT_TITLE1_TAB, CommonConstants.DEFAULT_ICON,
          CommonConstants.DEFAULT_ICON, CommonConstants.SELECTED_TITLE_FONT_COLOR, CommonConstants.DEFAULT_ICON),
        new TabBarInfo(1, CommonConstants.DEFAULT_TITLE2_TAB, CommonConstants.DEFAULT_ICON,
          CommonConstants.DEFAULT_ICON, CommonConstants.SELECTED_TITLE_FONT_COLOR, CommonConstants.DEFAULT_ICON),
        new TabBarInfo(2, CommonConstants.DEFAULT_TITLE3_TAB, CommonConstants.DEFAULT_ICON,
          CommonConstants.DEFAULT_ICON, CommonConstants.SELECTED_TITLE_FONT_COLOR, CommonConstants.DEFAULT_ICON),
        new TabBarInfo(3, CommonConstants.DEFAULT_TITLE4_TAB, CommonConstants.DEFAULT_ICON,
          CommonConstants.DEFAULT_ICON, CommonConstants.SELECTED_TITLE_FONT_COLOR, CommonConstants.DEFAULT_ICON)
      ]
    }
  }

  /**
   * tabBar
   * @param tabBarIndex: tabBar的下标
   */
  @Builder
  tabItemBuilder(tabBarIndex: number) {
    Column() {
      Stack() {
        // 判断tab的下标是否为2
        if (tabBarIndex === CommonConstants.COMMUNITY_TAB_BAR_INDEX) {
          Column() {
            Image(this.selectedIndex === tabBarIndex ? this.tabsInfo[tabBarIndex].selectedIcon :
            this.tabsInfo[tabBarIndex].defaultIcon)
              .size({
                width: $r('app.integer.custom_tab_community_image_size'),
                height: $r('app.integer.custom_tab_community_image_size')
              })
              .interpolation(ImageInterpolation.High) // TODO：知识点：使用interpolation属性对图片进行插值，使图片显示得更清晰
          }
          .width($r('app.integer.custom_tab_community_image_container_size'))
          .height($r('app.integer.custom_tab_community_image_container_size'))
          // TODO：知识点：通过设置borderRadius以及margin的top值实现圆弧外轮廓效果。
          .borderRadius($r('app.integer.custom_tab_community_image_container_border_radius_size'))
          .margin({ top: CommonConstants.ARC_MARGIN_TOP })
          .backgroundColor(Color.White)
          .justifyContent(FlexAlign.Center)
          .id('tab_button_' + tabBarIndex)
        } else {
          Column() {
            // 通过被选中的tabBar下标值和tabBar的默认下标值来改变图片显示
            Image(this.selectedIndex === tabBarIndex ? this.tabsInfo[tabBarIndex].selectedIcon :
            this.tabsInfo[tabBarIndex].defaultIcon)// TODO：知识点：使用interpolation属性对图片进行插值，使图片显示得更清晰
              .interpolation(ImageInterpolation.High)
              .size({
                width: $r('app.integer.custom_tab_image_size'),
                height: $r('app.integer.custom_tab_image_size')
              })// TODO：知识点：通过offset控制图片的纵向偏移。
              .offset({
                y: (this.selectedIndex === tabBarIndex &&
                  this.selectedIndex !== CommonConstants.COMMUNITY_TAB_BAR_INDEX) ?
                this.iconOffset : $r('app.integer.custom_tab_common_size_0')
              })// TODO：知识点：组件的某些通用属性变化时，可以通过属性动画animation实现过渡效果。本示例的动画效果是tabBar的图片向上偏移一小段距离
              .animation({
                duration: CommonConstants.CUSTOM_ANIMATION_DURATION,
                curve: Curve.Ease,
                iterations: CommonConstants.CUSTOM_ANIMATION_ITERATIONS,
                playMode: PlayMode.Normal
              })
              .id('tab_button_' + tabBarIndex)
          }
          .width($r('app.integer.custom_tab_image_container_size'))
          .height($r('app.integer.custom_tab_image_container_size'))
          .justifyContent(FlexAlign.Center)
        }
      }

      Text(this.tabsInfo[tabBarIndex].title)
        .fontSize($r('app.integer.custom_tab_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor(this.selectedIndex === tabBarIndex ? this.tabsInfo[tabBarIndex].selectedFontColor :
        this.tabsInfo[tabBarIndex].defaultFontColor)
    }
    .width($r('app.integer.custom_tab_height_size'))
    .onClick(() => {
      // 更新被选中的tabBar下标
      this.selectedIndex = tabBarIndex;
      // 此处控制tabBar的Image图片向上偏移
      this.iconOffset = -3;
    })
  }
}
