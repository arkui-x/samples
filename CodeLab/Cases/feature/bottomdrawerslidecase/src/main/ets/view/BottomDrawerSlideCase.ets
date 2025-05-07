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

import { TopTitle, ImageMapView, SettingItemView } from '../components/Component';
import { SettingItem } from '../utils/dataSource';
import { CommonConstants } from '../constants/CommonConstants';
import { BottomDrawer } from '../utils/BottomDrawer';
import { promptAction, window } from '@kit.ArkUI';
import { BottomDrawerHeight } from '../model/DataType';
import WindowModel from '../utils/WindowModel';
import { common } from '@kit.AbilityKit';
import { logger } from '../utils/Logger';
import { DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

/**
 * 功能描述: 本示例主要介绍了利用List实现底部抽屉滑动效果场景，并将界面沉浸式（全屏）显示，及背景地图可拖动
 *
 * 推荐场景: 需要实现抽屉滑动效果的场景，如：打车页面、导航页面上拉显示更多内容等
 *
 * 核心组件:
 * 1. BottomDrawer-抽屉效果视图
 *
 * 实现步骤：
 * 1. 构建初始数据。
 * @example
 * const LIST_ITEM: SettingItem[] = [
         new SettingItem('list_item_id_first'),
         new SettingItem('list_item_id_second'),
         new SettingItem('list_item_id_third'),
         new SettingItem('list_item_id_fourth'),
         new SettingItem('list_item_id_fifth'),
         new SettingItem('list_item_id_sixth'),
         new SettingItem('list_item_id_seventh'),
         new SettingItem('list_item_id_eighth'),
 ];
 *
 * 2. 构建抽屉视图。其中listBuilder为列表模块，开发者可以自定义。
 * @example
 * BottomDrawer({
     searchAddress: this.searchAddress,
     listBuilder: this.listBuilder,
     isShow: this.isShow,
     bottomDrawerHeight: this.bottomDrawerHeight
   })
 *
 *
 */

// list内容项
const LIST_ITEM: SettingItem[] = [
  new SettingItem('list_item_id_first'),
  new SettingItem('list_item_id_second'),
  new SettingItem('list_item_id_third'),
  new SettingItem('list_item_id_fourth'),
  new SettingItem('list_item_id_fifth'),
  new SettingItem('list_item_id_sixth'),
  new SettingItem('list_item_id_seventh'),
  new SettingItem('list_item_id_eighth'),
];


@Component
export struct BottomDrawerSlideCase {
  @State isShow: boolean = false; // 顶部遮蔽导航栏区域是否显示
  @State bottomDrawerHeight: BottomDrawerHeight = new BottomDrawerHeight() // 抽屉组件阶段高度属性
  @State bottomHeight: number = 0; // 底部导航栏高度
  windowHeight: number = 0; // window高度
  statusBarHeight: number = 0; // 顶部状态栏高度
  private windowModel: WindowModel = WindowModel.getInstance(); // 窗口管理model

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      RelativeContainer() {
        // Image地图
        ImageMapView()
          .id('map')
        // list上部的标题栏
        this.itemHead('安全出行季')
        /**
         * 抽屉视图
         * @param { ()=>void } searchAddress - 搜索视图
         * @param {()=>void} listBuilder - 列表视图
         * @param { boolean } isShow - 控制标题栏是否显示
         * @param {BottomDrawerHeight} BottomDrawerHeight - 列表阶段高度属性
         */
        BottomDrawer({
          searchAddress: this.searchAddress,
          listBuilder: ()=>{
            this.listBuilder();
          },
          isShow: this.isShow,
          bottomDrawerHeight: this.bottomDrawerHeight
        })
      }

      /**
       * 顶部标题
       * @param {boolean} isShow - 顶部遮蔽导航栏区域是否显示
       */
      TopTitle({
        isShow: this.isShow
      })
        .id('title_bar')
    }.width(CommonConstants.FULL_SIZE)
    .height(CommonConstants.FULL_SIZE)
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

  // 搜索视图
  @Builder
  searchAddress() {
    Column() {
      Row() {
        Text($r("app.string.bottomdrawerslidecase_set_out"))
          .fontSize($r("app.integer.bottomdrawerslidecase_number_15"))
        Text($r("app.string.bottomdrawerslidecase_destination_new"))
          .fontSize($r("app.integer.bottomdrawerslidecase_number_15"))
          .fontColor(Color.Green)
        Text($r("app.string.bottomdrawerslidecase_get_on_the_car"))
          .fontSize($r("app.integer.bottomdrawerslidecase_number_15"))
      }
      .margin({ left: $r("app.integer.bottomdrawerslidecase_number_10") })
      .height($r("app.integer.bottomdrawerslidecase_height_50"))
      .width($r('app.string.bottom_drawer_slide_full_percent'))

      Text($r("app.string.bottomdrawerslidecase_please_destination"))
        .padding({ left: $r("app.integer.bottomdrawerslidecase_number_10") })
        .fontSize($r("app.integer.bottomdrawerslidecase_number_20"))
        .fontWeight(2)
        .height($r("app.integer.bottomdrawerslidecase_number_60"))
        .backgroundColor($r("app.color.bottomdrawerslidecase_list_first_backgroundcolor"))
        .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
        .width($r('app.string.bottom_drawer_slide_full_percent'))
        .onClick(() => {
          promptAction.showToast({
            message: $r("app.string.bottomdrawerslidecase_promotion"),
            duration: 2000
          })
        })
    }
    .height(this.bottomDrawerHeight.minHeight)
    .width($r('app.string.bottom_drawer_slide_90_percent'))
    .padding({
      left: $r("app.integer.bottomdrawerslidecase_number_15"),
      right: $r("app.integer.bottomdrawerslidecase_number_15")
    })
    .justifyContent(FlexAlign.Center)
    .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
    .shadow({
      radius: $r("app.integer.bottomdrawerslidecase_number_30"), // 阴影模糊半径
      color: $r("app.color.bottomdrawerslidecase_list_first_backgroundcolor"),
      offsetY: $r("app.integer.bottomdrawerslidecase_number_5") // Y轴偏移量
    })
  }

  // 列表视图
  @Builder
  listBuilder() {
    ForEach(LIST_ITEM, (item: SettingItem, index: number) => {
      ListItem() {
        SettingItemView()
      }
      .backgroundColor(Color.White)
      .width(CommonConstants.FULL_SIZE)
      .margin({
        bottom: index === LIST_ITEM.length - 1 ? this.bottomHeight : 0
      })
    }, (item: SettingItem) => item.id.toString())
  }

  // list上部的标题栏
  @Builder
  itemHead(text: string) {
    Column() {
      Row() {
        Text(text)
          .fontSize($r('app.string.bottomdrawerslidecase_fontsize_15'))
          .fontColor($r("app.color.bottomdrawerslidecase_list_header_text"))
      }
      .shadow({
        radius: $r("app.integer.bottomdrawerslidecase_number_10"), // 阴影模糊半径
        color: $r("app.color.bottomdrawerslidecase_list_header_shadow"),
      })
      .height($r("app.integer.bottomdrawerslidecase_height_50"))
      .width($r('app.string.bottom_drawer_slide_40_percent'))
      .margin({ left: $r("app.integer.bottomdrawerslidecase_number_30") })
      .backgroundColor($r("app.color.bottomdrawerslidecase_list_header_backgroundcolor"))
      .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
      .padding({ left: $r("app.integer.bottomdrawerslidecase_number_15") })

      Blank()
        .height($r("app.integer.bottomdrawerslidecase_number_10"))
        .backgroundColor(Color.Transparent)
    }
    .id('listHeader')
    .alignRules({
      'bottom': { 'anchor': 'scrollPart', 'align': VerticalAlign.Top },
      'left': { 'anchor': '__container', 'align': HorizontalAlign.Start },
      'right': { 'anchor': '__container', 'align': HorizontalAlign.End },
    })
    .height(CommonConstants.LIST_HEADER_HEIGHT)
    .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
  }

  aboutToAppear(): void {
    // 初始化窗口管理model
    let context = getContext() as common.UIAbilityContext;
    const windowStage: window.WindowStage | undefined =
      PlatformInfo.isArkUIX() ? AppStorage.get('windowStage') : context.windowStage;
    // 没有windowStage将无法执行下列逻辑
    if (!windowStage) {
      logger.warn('windowStage init error!');
      return;
    }
    this.windowModel.setWindowStage(windowStage);
    this.windowModel.getStatusBarHeight((statusBarHeight) => {
      this.statusBarHeight = px2vp(statusBarHeight);
    })
    this.windowModel.getBottomAvoidHeight((bottomHeight) => {
      this.bottomHeight = px2vp(bottomHeight);
    })
    if (PlatformInfo.isArkUIX()) {
      this.windowModel.getArkuiXWindowHeight((arkuiXWindowHeight) => {
        this.bottomDrawerHeight.maxHeight = px2vp(arkuiXWindowHeight) - CommonConstants.LIST_HEADER_HEIGHT;
      })
    } else {
      // 获取窗口高度
      this.windowModel.getWindowHeight().then(s => {
        this.windowHeight = s;
        this.bottomDrawerHeight.maxHeight = this.windowHeight - this.statusBarHeight - CommonConstants.LIST_HEADER_HEIGHT; // 设置list最大高度
      })
    }

  }
}


