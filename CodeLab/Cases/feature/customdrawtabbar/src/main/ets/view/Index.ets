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

import { TabsConcaveCircle } from '../components/tabsConcaveCircle/TabsConcaveCircle';
import { TabsRaisedCircle } from '../components/tabsRaisedCircle/TabsRaisedCircle';
import { TabMenusInterfaceIRequired } from '../types/TabMenusInterface';

/**
 * 功能描述: 通过canvas，clipShape，radialGradient实现自定义TabBar选择时凸起点交界处的圆滑过渡动效以及扩展了一个凹陷选择时不遮挡原本内容的功能。
 *
 * 推荐场景: 自定义TabBar页签需要实现一圈圆弧外轮廓或者凹陷轮廓，点击TabBar页签之后需要改变图标显示，并有平移滑动切换页签动效的场景。
 *
 * 核心组件:
 * 1. TabsRaisedCircle
 * 2. TabsConcaveCircle
 *
 * 实现步骤：
 * 1. TabBar页面实现有一圈圆弧外轮廓：单独绘制一个圆，然后将圆向上偏移1/3。通过 radialGradient 设置选中的圆心的背景色，然后在单独绘制左右俩边的圆角过渡。
 * 2. TabBar页面实现有一圈凹陷的轮廓：通过canvas来绘制TabBar的背景和凹槽部分，然后通过Stack来将球体和菜单层叠在一起组合成一个完整的 TabBar 。
 * 3. TabBar页签点击之后会改变图标显示，并有一小段动画效果：改变图标显示功能可以先声明一个变量selectedIndex，此变量代表被选定的tabBar下标，点击的时候将当前tabBar的下标值进行赋值。
 *    通过当前被选中的tabBar下标值和tabBar自己的下标值进行判断来达到点击之后改变图标显示的效果。动画效果使用animateTo来触发动画。
 */
@Component
export struct CustomDrawTabbarComponent {
  @State currentIndex: number = 0;
  @State TabsMenu: TabMenusInterfaceIRequired[] = [
    {
      text: $r("app.string.custom_tab_home"),
      image: $r("app.media.tab_home"),
      selectImage: $r("app.media.tab_community")
    },
    {
      text: $r("app.string.custom_tab_friend"),
      image: $r("app.media.tab_cart"),
      selectImage: $r("app.media.tab_community")
    },
    {
      text: $r("app.string.custom_tab_news"),
      image: $r("app.media.tab_new"),
      selectImage: $r("app.media.tab_community")
    },
    {
      text: $r("app.string.custom_tab_mine"),
      image: $r("app.media.tab_user"),
      selectImage: $r("app.media.tab_community")
    }
  ];

  build() {
    Column() {
      TabsRaisedCircle({
        tabsMenu: this.TabsMenu,
        selectIndex: this.currentIndex,
      })
      Divider()
        .margin(30)
      TabsConcaveCircle({
        tabsMenu: this.TabsMenu,
        selectIndex: this.currentIndex,
      });
    }
    .width('100%')
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .linearGradient({
      direction: GradientDirection.Left,
      repeating: false,
      colors: [[Color.White, 0.0], [Color.Pink, 1]]
    })
  }
}