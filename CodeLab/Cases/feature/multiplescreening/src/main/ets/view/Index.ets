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

import { DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { SiteItem, SITE_LIST_DATA } from '../model/SiteItemModel';
import { SiteListDataSource } from '../model/SiteListDataSource';
import { TabBarType } from '../model/TabBarModel';
import { CustomTabBar } from '../components/CustomComponent';
import { CustomTitle } from '../components/CustonTitle';
import { FilterComponent } from '../components/FilterComponent';
import { InfoCard } from '../components/InfoCard';

const MASK_OPACITY = 0.3; // 蒙层透明度
const LAYOUT_WEIGHT = 1; // 列表布局权重

/**
 * 功能描述：本示例主要介绍多重筛选场景，利用数组方法过滤满足条件的数据，利用LazyForEach实现列表信息的渲染以及刷新。
 *
 * 推荐场景：需多条件筛选时使用
 *
 * 核心组件：
 * 1.FilterComponent 筛选条件组件
 * 2.InfoCard 列表组件
 * 3.SiteListDataSource 筛选处理
 *
 * 实现步骤：
 * 1.设置Tab组件当前选中index值。
 * @example
 * @State currentIndex: TabBarType = TabBarType.CHALLENGE;
 * 2.设置是否显示筛选页面。
 * @example
 * @State isShow: boolean = false;
 * 3.设置选中的数据。
 * @example
 * @State changData: Array<string> = [];
 * 4.设置场地信息集合。
 * @example
 * @State siteList: SiteListDataSource = new SiteListDataSource();
 * 5.构建标题组件。
 * @example
 *  CustomTitle();
 * 6.构建筛选条件组件。
 * @example
 *  PipWindowComponent();
 * 6.构建列表组件。
 * @example
 *  InfoCard();
 * 7.构建底部tabs组件。
 * @example
 *  CustomTabBar();
 *
 */
@Component
export struct MultipleScreeningComponent {
  @State currentIndex: TabBarType = TabBarType.CHALLENGE; // Tab组件当前选中index值
  @State isShow: boolean = false; // 是否显示筛选页面
  @State changData: Array<string> = []; // 选中的数据
  @State siteList: SiteListDataSource = new SiteListDataSource(); // 场地信息集合
  @StorageLink('avoidAreaTopToModule') avoidAreaTopToModule: number = 0;

  aboutToAppear(): void {
    // 将场地信息推入空数组
    SITE_LIST_DATA.forEach((site: SiteItem) => {
      this.siteList?.pushData(site);
    })
    // 存储列表数据
    AppStorage.setOrCreate('siteList', JSON.stringify(this.siteList));
  }

  build() {
    Column() {
      Column() {
        /**
         * 标题组件
         */
        CustomTitle()
        /**
         * 筛选条件组件
         * siteList:场地信息集合,
         * isShow:是否显示筛选页面,
         * changData:选中的数据
         */
        FilterComponent({ siteList: $siteList, isShow: this.isShow, changData: $changData })
      }
      .zIndex(1)

      Stack() {
        /**
         * 列表组件
         * siteList:场地信息集合,
         * changData:选中的数据
         */
        InfoCard({ siteList: $siteList, changData: $changData })
        // 蒙层
        Column() {

        }
        .width($r('app.string.multiple_screening_all_percentage'))
        .height($r('app.string.multiple_screening_all_percentage'))
        .visibility(this.isShow ? Visibility.Visible : Visibility.None)
        .backgroundColor(Color.Black)
        .opacity(MASK_OPACITY)
        .onClick(() => {
          this.isShow = !this.isShow
        })
      }
      .width($r('app.string.multiple_screening_all_percentage'))
      .height($r('app.string.multiple_screening_all_percentage'))
      .layoutWeight(LAYOUT_WEIGHT)

      /**
       * 底部tabs组件
       * currentIndex:Tab组件当前选中index值
       */
      CustomTabBar({ currentIndex: $currentIndex })
    }
    .backgroundColor($r('app.color.multiple_screening_background_color'))
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}