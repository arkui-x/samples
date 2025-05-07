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

import { TabInfo } from '../model/TabInfo';
import { CustomTabsComponent } from '../pages/CustomTabsComponent';

const LIST_IMAGE = [$r('app.media.background_pic_1'), $r('app.media.background_pic_2'),
  $r('app.media.background_pic_3'), $r('app.media.background_pic_4')];

/**
 * 功能介绍：在一些主页的场景中，为了实现更好的视觉体验，会给TabBar加上透明的背景模糊效果。
 *
 * 推荐场景：为了体验需要实现模糊效果的场景，例如购物商场的主页下方的TabBar效果。
 *
 * 核心组件:CustomTabsComponent.ets
 *
 * 实现步骤:
 * 1.使用backgroundBrightness和backgroundBlurStyleTabBar属性实现TabBar背景模糊效果：
 * 在自定义的TabBar实现中，添加backgroundBrightness和backgroundBlurStyleTabBar属性，实现透明模糊效果。其中backgroundBrightness
 * 属性可以控制背景的亮度等效果，backgroundBlurStyleTabBar属性控制背景的透明度等效果。
 * 2.实现底部TabBar页签的沉浸式效果：
 * 为了实现底部TabBar页签的沉浸式效果，需要在**所有**TabBar的嵌套路径中，添加expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
 */

@Builder
function myContent(info: string) {
  Text(info)
    .fontSize(24)
}


@Builder
function myScrollContent(info: string) {
  MainContent({ info: info })
}

@Preview
@Component
export struct TabsSample {
  TAB_INFO_LIST: TabInfo[] = [
    new TabInfo(0, $r('app.string.background_blur_main'), $r('app.media.backgroundblur_main_select'),
      $r('app.media.backgroundblur_main_normal'),
      wrapBuilder(myScrollContent)),
    new TabInfo(0, $r('app.string.background_blur_hot'), $r('app.media.backgroundblur_hot_select'),
      $r('app.media.backgroundblur_hot_normal'),
      wrapBuilder(myContent)),
    new TabInfo(0, $r('app.string.background_blur_discover'), $r('app.media.backgroundblur_find_select'),
      $r('app.media.backgroundblur_find_normal'),
      wrapBuilder(myContent)),
    new TabInfo(0, $r('app.string.background_blur_my'), $r('app.media.backgroundblur_my_select'),
      $r('app.media.backgroundblur_my_normal'),
      wrapBuilder(myContent))
  ];

  build() {
    CustomTabsComponent({ tabsInfoList: this.TAB_INFO_LIST })
  }
}

@Component
export struct MainContent {
  info: string = '';
  scroller: Scroller = new Scroller();
  // 数据演示用
  private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  build() {
    Scroll(this.scroller) {
      Column() {
        ForEach(this.arr, (item: number) => {
          if (item == this.arr.length - 1) {
            Column()
              // 由于底部tabBar和tabContent是Stack堆叠布局，因此需要在底部突出一个tabBar高度
              .height($r('app.integer.background_blur_tab_bar_height'))
          } else {
            Image(LIST_IMAGE[item % LIST_IMAGE.length])
              .width('100%')
              // 高度演示用
              .height(200)
          }
        }, (item: string) => item)
      }
    }
    .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
    .scrollBar(BarState.On) // 滚动条常驻显示
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM]) // 沉浸式效果
  }
}