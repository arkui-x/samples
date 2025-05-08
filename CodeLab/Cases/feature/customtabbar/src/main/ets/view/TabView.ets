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

import { CustomTabBar } from '../util/CustomTabBar';
import { TabBarInfo } from '../model/DataType';
import { TAB_INFO } from '../model/TabBarData';

/**
 * 功能描述：自定义tab组件样例
 *
 * 推荐场景：需要使用tab和tabContent实现主页切换的场景
 *
 * 核心组件:
 * 1. CustomTabBar: 自定义动效tab构建组件
 *
 * 实现步骤:
 * 1. 数据准备: 首先构建一个TabInfo数组，然后向CustomTabBar传入对应的内容
 * @example
 *
 * const TAB_INFO: TabBarInfo[] = [
                   new TabBarInfo(0, $r('app.string.custom_tab_home'), $r("app.media.custom_tab_home_selected"),
                   $r("app.media.custom_tab_home"), $r('app.color.custom_tab_selected_text_color'),$r('app.color.custom_tab_text_color')),
                   new TabBarInfo(1, $r('app.string.custom_tab_news'), $r("app.media.custom_tab_new_selected"),
                   $r("app.media.custom_tab_new"), $r('app.color.custom_tab_selected_text_color'),$r('app.color.custom_tab_text_color')),
                   new TabBarInfo(2, $r("app.string.custom_tab_video"), $r("app.media.custom_tab_video_selected"),
                   $r("app.media.custom_tab_video"), $r('app.color.custom_tab_selected_text_color'),$r('app.color.custom_tab_text_color')),
                   new TabBarInfo(3, $r("app.string.custom_tab_friend"), $r("app.media.custom_tab_friend_selected"),
                   $r("app.media.custom_tab_friend"), $r('app.color.custom_tab_selected_text_color'),$r('app.color.custom_tab_text_color')),
                   new TabBarInfo(4, $r('app.string.custom_tab_mine'), $r("app.media.custom_tab_user_selected"),
                   $r("app.media.custom_tab_user"), $r('app.color.custom_tab_selected_text_color'),$r('app.color.custom_tab_text_color'))];
 *
 * private tabsInfoArr: TabBarInfo[] = TAB_INFO;
 * 2. 双向数据绑定当前选定的tabBar的下标，开发者可以根据获取的selectedIndex来进行一些操作，如获取某个TabContent所需要的数据等。
 * @example
 * CustomTabBar({ selectedIndex: this.selectedIndex, tabsInfo: this.tabsInfoArr })
 * */

@Preview
@Component
export struct TabViewComponent {
  // 配置起始的页签索引
  @State selectedIndex: number = 0;
  // 初始化Tab控制器
  private controller: TabsController = new TabsController();
  // tab数据
  private tabsInfoArr: TabBarInfo[] = TAB_INFO;

  build() {
    Column() {
      Tabs({ index: this.selectedIndex, barPosition: BarPosition.End, controller: this.controller }) {
        // 首页模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_tab_home'))
            .fontSize($r('app.integer.custom_tab_title_font_size'))
            .padding(20)
        }

        // 新闻模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_tab_news'))
            .fontSize($r('app.integer.custom_tab_title_font_size'))
        }

        // 视频模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r("app.string.custom_tab_video"))
            .fontSize($r('app.integer.custom_tab_title_font_size'))
        }

        // 朋友圈模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r("app.string.custom_tab_friend"))
            .fontSize($r('app.integer.custom_tab_title_font_size'))
        }

        // 我的模块，可根据开发者实际业务替换TabContent中的布局
        TabContent() {
          Text($r('app.string.custom_tab_mine'))
            .fontSize($r('app.integer.custom_tab_title_font_size'))
        }
      }
      .vertical(false)
      .scrollable(true)
      .layoutWeight(1)
      .backgroundColor('#ffdbd9d9')
      .barHeight($r('app.integer.custom_tab_common_size_0'))
      .onAnimationStart((index: number, targetIndex: number) => {
        this.selectedIndex = targetIndex;
      })

      /**
       * 自定义TabBar组件
       * selectedIndex: 配置起始的页签索引
       * tabsInfo: tab数据源，类型为TabBarInfo
       */
      CustomTabBar({ selectedIndex: this.selectedIndex, tabsInfo: this.tabsInfoArr })
    }
    .width($r('app.string.custom_tab_full_size'))
    .height($r('app.string.custom_tab_full_size'))
  }
}

