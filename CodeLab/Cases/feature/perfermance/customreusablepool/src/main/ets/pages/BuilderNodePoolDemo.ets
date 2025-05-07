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

import { TabNode } from '../view/TabNode';
import { Title } from '../data/TitleBean';
import { TitleDataSource } from '../data/TitleDataSource';
import { TitleView } from '../view/TitleView';
import { Constants } from '../constants/Constants';


/**
 * 功能描述: 本示例是全局自定义组件复用实现的示例代码，主要讲解如何通过BuilderNode创建全局的自定义组件复用池，实现跨页面的组件复用。
 *
 * 推荐场景: 自定义全局组件复用
 *
 * 核心组件:
 * 1. BuilderNodePool
 *
 * 实现步骤：
 * 1. 使用List+Swiper实现Tabs页面切换
 * 2. 继承NodeController，实现makeNode，用于组件的创建或刷新，并在组件隐藏时（aboutToDisappear）回收组件
 * 3. 使用单例模式实现复用池，应用内统一管理组件复用。添加getNode方法，根据传入的type参数，获取对应的Node组件，如果未找到，则重新创建，实现recycleNode方法，回收Node组件
 * 4. 使用NodeContainer占位轮播图组件和瀑布流子组件的位置，并通过NodePool获取组件加载到页面中
 */

@Component
export struct BuilderNodePoolDemoComponent {
  @State arrayTitle: Title[] = [];
  arrayStr: string[] = [Constants.HOME, Constants.FILM, Constants.TELEPLAY, Constants.ANIMATION, Constants.SPORT];
  @State array: TitleDataSource = new TitleDataSource();
  swiperController: SwiperController = new SwiperController();
  @State selectIndex: number = 0;

  aboutToAppear(): void {
    // 添加标题模拟数据
    for (let i = 0; i < this.arrayStr.length; i++) {
      let title: Title = new Title();
      if (i === 0) {
        title.isSelected = true;
      }
      title.name = this.arrayStr[i];
      this.arrayTitle.push(title);
      this.array.addItem(this.arrayStr[i]);
    }
  }

  build() {
    NavDestination() {
      List() {
        ForEach(this.arrayTitle, (title: Title, index: number) => {
          ListItem() {
            TitleView({
              title: title, clickListener: () => {
                if (title.isSelected) {
                  return;
                }
                // 点击标题时，Swiper组件跳转到对应的页面
                this.swiperController.changeIndex(index, true);
                // 设置标题为选中状态
                this.arrayTitle[index].isSelected = true;
                this.arrayTitle[this.selectIndex].isSelected = false;
                this.selectIndex = index;
              }
            }).padding({
              left: index === 0 ? $r('app.integer.customreusablepool_title_view_padding_left_side') :
              $r('app.integer.customreusablepool_title_view_padding_left'),
              right: index === this.arrayTitle.length - 1 ?
              $r('app.integer.customreusablepool_title_view_padding_right_side') :
              $r('app.integer.customreusablepool_title_view_padding_right')
            })
          }
        })
      }
      .height($r('app.integer.customreusablepool_title_view_list_height'))
      .listDirection(Axis.Horizontal)
      .id('id_custom_reusable_pool_title_list')

      Swiper(this.swiperController) {
        LazyForEach(this.array, (item: string, index: number) => {
          TabNode({ index: index })
        }, (title: string) => title)
      }
      .loop(false)
      .onChange((index: number) => {
        // Swiper滑动切换页面时，改变标题栏的选中状态
        if (this.selectIndex !== index) {
          this.arrayTitle[index].isSelected = true;
          this.arrayTitle[this.selectIndex].isSelected = false;
          this.selectIndex = index;
        }
      })
      .indicator(false)
      .cachedCount(0)
      .id('id_custom_reusable_pool_main_swiper')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
  }
}