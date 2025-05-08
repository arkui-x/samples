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

import { CubeRotateAnimationSwiper } from '../components/CubeRotateAnimationSwiper';
import { CubeSwiperController, MyGridItem, MySwiperItem, MyTabItem } from '../model/DataModel';
import { promptAction } from '@kit.ArkUI';
import { IMAGES, GRID_ITEMS, SWIPER_LIST, TAB_ITEMS } from '../mock/MockData';

 /**
 * 功能描述: 本示例展示了CubeRotateAnimationSwiper组件在实际应用中的使用场景。通过在首页中集成该组件，实现了热门卡片中轮播项的3D立方体旋转切换效果，提供了流畅的用户体验。
 * 同时，示例包含了常见的应用首页元素，以展示组件的实际应用效果。通过组件控制器可以实现轮播数据的动态更新。
 *
 * 推荐场景: 政务服务、新闻资讯、电商平台等应用的首页，需要展示多样化内容和功能入口的场景。
 *
 * 核心组件:
 * 1. CubeRotateAnimationSwiper - 3D立方体旋转轮播组件。
 * 2. Swiper - 轮播组件，提供子组件滑动轮播显示的能力。
 * 3. rotate - 组件旋转属性，用于实现3D旋转功能。
 * 4. customContentTransition - 自定义Swiper页面切换动画。
 * 5. CubeSwiperController - 组件控制器，用于动态更新轮播数据。
 *
 * 实现步骤：
 * 1. 创建数据源：定义并初始化轮播数据。
 * 2. 通过swiperItemSlotParam自定义轮播项内容，例如标题、副标题和背景图片。
 * 3. 导入并构建CubeRotateAnimationSwiper组件，配置组件参数。
 * 4. 使用Grid组件布局多个CubeRotateAnimationSwiper组件。
 * 5. 添加页面基础结构（搜索栏、导航栏等）以展示完整应用场景。
 */
 
@Component
export struct CubeRotateAnimationSamplePage {
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  @State headerOpacity: number = 0; // 顶部搜索栏透明度
  @State currentIndex: number = 0; // 当前选中的标签页索引
  private tabsController: TabsController = new TabsController(); // 标签页控制器
  private swiperController: SwiperController = new SwiperController(); // 轮播控制器
  private scroller: Scroller = new Scroller(); // 滚动控制器
  // 动画Swiper布局配置
  layoutOptions: GridLayoutOptions = {
    regularSize: [1, 1],
    onGetRectByIndex: (index: number) => {
      if (index == 0) {
        return [0, 0, 2, 1]
      } else if (index == 1) {
        return [0, 1, 1, 1]
      } else {
        return [1, 1, 1, 1]
      }
    }
  };
  // Grid数据源
  private gridItems: MyGridItem[] = GRID_ITEMS;
  // Tabs数据
  private tabItems: MyTabItem[] = TAB_ITEMS;
  // 顶部轮播图数据
  private bannerItems: Resource[] = IMAGES;
  // Swiper数据
  private swiperList: MySwiperItem[][] = [];
  // 组件控制器
  private cubeSwiperControllers: CubeSwiperController[] = [];

  aboutToAppear(): void {
    // 初始化Swiper数据
    SWIPER_LIST.forEach((swiperItems: MySwiperItem[]) =>{
      this.swiperList.push([...swiperItems]);
      this.cubeSwiperControllers.push(new CubeSwiperController());
    })
  }

  // 顶部搜索栏
  @Builder
  headerBuilder() {
    Row() {
      Search({
        value: '',
        placeholder: $r('app.string.cube_animation_search_placeholder')
      })
        .width($r('app.string.cube_animation_search_width'))
        .height($r('app.integer.cube_animation_search_height'))
        .backgroundColor($r('app.color.cube_animation_search_bg'))
        .placeholderColor($r('app.color.cube_animation_search_placeholder'))
        .borderRadius($r('app.integer.cube_animation_search_radius'))

      Image(this.headerOpacity < 0.5 ?
      $r('app.media.cube_animation_scan_white') :
      $r('app.media.cube_animation_scan_black'))
        .width($r('app.integer.cube_animation_icon_size'))
        .height($r('app.integer.cube_animation_icon_size'))
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.cube_animation_toast'),
          });
        })
    }
    .width($r('app.string.cube_animation_full_size'))
    .height($r('app.integer.cube_animation_header_height'))
    .backgroundColor(`rgba(255, 255, 255, ${this.headerOpacity})`)
    .position({ x: 0, y: 0 })
    .zIndex(1)
    .padding({
      left: $r('app.integer.cube_animation_padding_common'),
      right: $r('app.integer.cube_animation_padding_common')
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 顶部轮播UI
  @Builder
  bannerModule() {
    Column() {
      Text($r('app.string.cube_animation_greeting'))
        .fontColor($r('app.color.cube_animation_text_light'))
        .fontSize($r('app.integer.cube_animation_text_large'))
      Text($r('app.string.cube_animation_weather'))
        .fontColor($r('app.color.cube_animation_text_light'))
        .fontSize($r('app.integer.cube_animation_text_small'))
        .margin({ top: $r('app.integer.cube_animation_margin_xs') })

      Swiper(this.swiperController) {
        ForEach(this.bannerItems, (item: Resource) => {
          Image(item)
            .width($r('app.string.cube_animation_full_size'))
            .height($r('app.integer.cube_animation_banner_height'))
            .onClick(() => {
              promptAction.showToast({
                message: $r('app.string.cube_animation_toast'),
              });
            })
        })
      }
      .indicator(
        new DotIndicator()
          .itemWidth($r('app.integer.cube_animation_dot_width'))
          .itemHeight($r('app.integer.cube_animation_dot_height'))
          .selectedItemWidth($r('app.integer.cube_animation_dot_width'))
          .selectedItemHeight($r('app.integer.cube_animation_dot_height'))
          .color($r('app.color.cube_animation_dot_normal'))
          .selectedColor($r('app.color.cube_animation_dot_selected'))
          .maxDisplayCount(4))
      .borderRadius($r('app.integer.cube_animation_radius_medium'))
      .width($r('app.string.cube_animation_full_size'))
      .autoPlay(true)
      .margin({ top: $r('app.integer.cube_animation_margin_medium') })
    }
    .width($r('app.string.cube_animation_full_size'))
    .alignItems(HorizontalAlign.Start)
    .margin({ top: $r('app.integer.cube_animation_margin_negative') })
    .padding($r('app.integer.cube_animation_padding_common'))
  }

  // 功能图标网格UI
  @Builder
  functionGird() {
    Grid() {
      ForEach(this.gridItems, (item: MyGridItem) => {
        GridItem() {
          Column() {
            Image(item.icon)
              .width($r('app.integer.cube_animation_icon_size'))
              .height($r('app.integer.cube_animation_icon_size'))
            Text(item.title)
              .fontSize($r('app.integer.cube_animation_text_small'))
              .margin({ top: $r('app.integer.cube_animation_margin_small') })
          }
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.cube_animation_toast'),
            });
          })
        }
      })
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsTemplate('1fr 1fr')
    .width($r('app.string.cube_animation_full_size'))
    .height($r('app.integer.cube_animation_grid_height'))
    .padding($r('app.integer.cube_animation_padding_common'))
    .backgroundColor($r('app.color.cube_animation_bg_white'))
  }

  // 自定义3D立方体旋转轮播项内容
  @Builder
  mySwiperItem(item: MySwiperItem) {
    Stack({ alignContent: Alignment.TopStart }) {
      Rect()
        .width($r('app.string.cube_animation_full_size'))
        .height($r('app.string.cube_animation_full_size'))
        .fill($r('app.color.cube_animation_mask'))
        .fillOpacity($r('app.float.cube_animation_mask_opacity'))

      Column() {
        Text(item.title)
          .fontColor($r('app.color.cube_animation_text_light'))
          .fontSize($r('app.integer.cube_animation_text_large'))
          .fontWeight(FontWeight.Bold)
        Text(item.subTitle)
          .fontColor($r('app.color.cube_animation_text_light'))
          .fontSize($r('app.integer.cube_animation_text_small'))
          .margin({ top: $r('app.integer.cube_animation_margin_small') })
      }
      .margin({
        top: $r('app.integer.cube_animation_margin_large'),
        left: $r('app.integer.cube_animation_margin_large')
      })
      .alignItems(HorizontalAlign.Start)
    }
    .width($r('app.string.cube_animation_full_size'))
    .height($r('app.string.cube_animation_full_size'))
    .backgroundImage(item.image)
    .backgroundImageSize(ImageSize.Cover)
    .onClick(() => {
      promptAction.showToast({
        message: $r('app.string.cube_animation_toast'),
      });
    })
  }

  // 热门UI
  @Builder
  popularModule() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.cube_animation_popular'))
            .fontSize($r('app.integer.cube_animation_text_medium'))
            .fontWeight(FontWeight.Bold)
          Text($r('app.string.cube_animation_more'))
            .fontSize($r('app.integer.cube_animation_text_small'))
            .fontColor($r('app.color.cube_animation_text_gray'))
            .onClick(() => {
              promptAction.showToast({
                message: $r('app.string.cube_animation_toast'),
              });
            })
        }
        .width($r('app.string.cube_animation_full_size'))
        .padding({
          left: $r('app.integer.cube_animation_padding_common'),
          right: $r('app.integer.cube_animation_padding_common')
        })
        .margin({ bottom: $r('app.integer.cube_animation_margin_medium') })
        .backgroundColor($r('app.color.cube_animation_bg_white'))
        .justifyContent(FlexAlign.SpaceBetween)

        // 轮播网格
        Grid(undefined, this.layoutOptions) {
          ForEach(this.swiperList, (item: MyGridItem[], index: number) => {
            GridItem() {
              /**
               * 构建3D立方体旋转动画组件
               * items: 轮播数据
               * cubeSwiperController: 组件控制器
               * swiperItemSlotParam: 自定义3D立方体旋转轮播项内容
               */
              CubeRotateAnimationSwiper({
                items: item,
                cubeSwiperController: this.cubeSwiperControllers[index],
                swiperItemSlotParam: (item: MySwiperItem) => {
                  this.mySwiperItem(item);
                }
              })
            }
            .width($r('app.string.cube_animation_full_size'))
            .height($r('app.string.cube_animation_full_size'))
          })
        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(0)
        .rowsGap(0)
        .scrollBar(BarState.Off)
        .backgroundColor($r('app.color.cube_animation_bg_white'))
        .width($r('app.string.cube_animation_full_size'))
        .height($r('app.integer.cube_animation_hot_grid_height'))
      }
      .width($r('app.string.cube_animation_full_size'))
      .borderRadius($r('app.integer.cube_animation_radius_medium'))
      .padding({
        top: $r('app.integer.cube_animation_padding_common'),
        bottom: $r('app.integer.cube_animation_padding_common')
      })
      .backgroundColor($r('app.color.cube_animation_bg_white'))
    }
    .padding($r('app.integer.cube_animation_padding_common'))
    .width($r('app.string.cube_animation_full_size'))
  }

  // 首页内容
  @Builder
  mainContent() {
    Stack({ alignContent: Alignment.Top }) {
      Scroll(this.scroller) {
        Column() {
          // 顶部背景图
          Image($r('app.media.cube_animation_background'))
            .width($r('app.string.cube_animation_full_size'))
            .height($r('app.integer.cube_animation_bg_height'))
          // 顶部轮播UI
          this.bannerModule()
          // 功能图标网格UI
          this.functionGird()
          // 热门模块UI
          this.popularModule()
        }
        .width($r('app.string.cube_animation_full_size'))
      }
      .scrollBar(BarState.Off)
      .onWillScroll(() => {
        // 随着页面滑动修改搜索栏背景透明度
        let yOffset = this.scroller.currentOffset().yOffset;
        this.headerOpacity = Math.min(1, yOffset / 100);
      })

      this.headerBuilder()
    }
    .width($r('app.string.cube_animation_full_size'))
    .height($r('app.string.cube_animation_full_size'))
  }

  // 首页外其余Tab页内容，用于UX展示
  @Builder
  tabContent(info: ResourceStr) {
    Text(info)
      .fontSize($r('app.integer.cube_animation_text_large'))
  }

  // 自定义TabBar
  @Builder
  TabBuilder(item: MyTabItem, index: number) {
    Column() {
      Image(this.currentIndex === index ? item.selectedIcon : item.icon)
        .width($r('app.integer.cube_animation_icon_size'))
        .height($r('app.integer.cube_animation_icon_size'))
        .margin({ top: $r('app.integer.cube_animation_margin_small') })
      Text(item.title)
        .fontSize($r('app.integer.cube_animation_text_small'))
        .margin({ top: $r('app.integer.cube_animation_margin_xs') })
        .fontColor(this.currentIndex === index ?
        $r('app.color.cube_animation_tab_selected') :
        $r('app.color.cube_animation_tab_normal'))
    }
    .width($r('app.string.cube_animation_full_size'))
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = index;
      this.tabsController.changeIndex(index);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      ForEach(this.tabItems, (item: MyTabItem, index: number) => {
        TabContent() {
          if (index === 0) {
            this.mainContent()
          } else {
            this.tabContent(item.title)
          }
        }.tabBar(this.TabBuilder(item, index))
      })
    }
    .width($r('app.string.cube_animation_full_size'))
    .height($r('app.string.cube_animation_full_size'))
    .barHeight('auto')
    .barBackgroundColor($r('app.color.cube_animation_bg_white'))
    .backgroundColor($r('app.color.cube_animation_bg_gray'))
    .divider({
      strokeWidth: $r('app.integer.cube_animation_divider_width'),
      startMargin: 0,
      endMargin: 0
    })
    .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
      if (index === targetIndex) {
        return;
      }
      this.currentIndex = targetIndex;
    })
  }
} 