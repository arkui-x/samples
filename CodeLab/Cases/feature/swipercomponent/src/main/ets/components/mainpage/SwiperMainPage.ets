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

import { SwiperData, SwiperItemViewType } from '../model/SwiperData';
import { SwiperSection } from '../../utils/SwiperSection';
import { CommonConstants } from '../../common/CommonConstants';

/**
 * 功能说明: 通过Stack组件堆叠图片，实现多层级效果，配合手势滑动和显式动画实现切换的动画效果。同时通过改变数据中间值currentIndex来改变组件zIndex层级和高度来实现切换的效果。
 *
 * 推荐场景: 购物类、资讯类应用的首页轮播
 *
 * 核心组件:
 *
 * 1. SwiperSection: 自定义轮播图
 *
 * 实现步骤:
 *
 * 1. 数据准备。设置SwiperItemViewType（轮播图属性配置）以及初始化轮播图数据。其中SwiperItemViewType包含SwiperData（轮播项数据类）以及
   contentBuilder（轮播项视图）两个属性。
   @example
   class SwiperItemViewType {
     data: SwiperData;
     contentBuilder: WrappedBuilder<[SwiperData]>;

     constructor(data: SwiperData, contentBuilder: WrappedBuilder<[SwiperData]>) {
       this.data = data;
       this.contentBuilder = contentBuilder;
     }
   }
   SwiperData包含imageSrc（图片路径-必传）、name（标题名称）、appUri（功能模块地址）以及param（传递的参数）。
   开发者可以使用以上默认的属性配置，也可以自行配置SwiperItemViewType和SwiperData的属性。
   根据以上属性初始化数据。
   @example
   aboutToAppear(): void {
     let swiperData: SwiperData[] = [
         new SwiperData($r('app.media.swipercomponent_mp_chart'), $r('app.string.swipercomponent_swiper_data1'),
         'barchart/BarChartPage'),
         new SwiperData($r('app.media.swipercomponent_lottie'), $r('app.string.swipercomponent_swiper_data2'),
         'lottieview/LottieComponent'),
         new SwiperData($r('app.media.swipercomponent_component_tack'), $r('app.string.swipercomponent_swiper_data3'),
         'componentstack/ComponentStack')];
     swiperData.forEach((item: SwiperData) => {
       this.swiperListView.push(new SwiperItemViewType(item, wrapBuilder(SwiperItemView)))
     })
   }
 * 2. 构建indicatorBuilder（自定义导航点）。
 * @Builder
   indicatorBuilder() {
     ···
   }
 * 3. 构造自定义轮播视图。
 * @example
 * SwiperSection({
     swiperListView: this.swiperListView,
     currentIndex: this.currentIndex,
     swiperAnimationDuration: CommonConstants.SWIPER_ANIMATION_DURATION,
     swiperSwitchDuration: CommonConstants.SWIPER_SWITCH_DURATION,
     isLoop: CommonConstants.SWIPER_IS_LOOP,
     indicatorBuilder: () => {
       this.indicatorBuilder();
     },
     swiperItemHandle: (swiperItemData: SwiperData) => {
       // TODO:点击swiper逻辑处理
       // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
       this.dynamicsRouterPush(swiperItemData);
     }
   })
 *
 */
@Component
export struct SwiperMainPage {
  // 轮播模块列表
  swiperListView: SwiperItemViewType[] = [];
  dynamicsRouterPush:(swiperItemData:SwiperData) => void = (swiperItemData:SwiperData)=>{};
  // 当前索引
  @State currentIndex: number = 0;

  aboutToAppear(): void {
    let swiperData: SwiperData[] = [
      new SwiperData($r('app.media.swipercomponent_mp_chart'), $r('app.string.swipercomponent_swiper_data1'),
        'barchart/BarChartPage'),
      new SwiperData($r('app.media.swipercomponent_lottie'), $r('app.string.swipercomponent_swiper_data2'),
        'lottieview/LottieComponent'),
      new SwiperData($r('app.media.swipercomponent_component_tack'), $r('app.string.swipercomponent_swiper_data3'),
        'componentstack/ComponentStack'),
    ];
    swiperData.forEach((item: SwiperData) => {
      // item单个轮播图数据，WrapBuilder单个轮播图视图。开发者可以自己配置轮播图数据和视图
      this.swiperListView.push(new SwiperItemViewType(item, wrapBuilder(SwiperItemView)));
    })
  }

  build() {
    Column() {
      /**
       * 轮播图视图
       * @param swiperListView: 轮播图列表视图数据
       * @param currentIndex: 当前索引值
       * @param swiperAnimationDuration: 轮播图切换动画时间
       * @param swiperSwitchDuration: 轮播图切换间隔时间
       * @param isLoop: 轮播图是否自动循环播放
       * @param indicatorBuilder: 导航点自定义视图
       * @param swiperItemHandle: 点击轮播图处理逻辑
       */
      SwiperSection({
        swiperListView: this.swiperListView,
        currentIndex: this.currentIndex,
        swiperAnimationDuration: CommonConstants.SWIPER_ANIMATION_DURATION,
        swiperSwitchDuration: CommonConstants.SWIPER_SWITCH_DURATION,
        isLoop: CommonConstants.SWIPER_IS_LOOP,
        indicatorBuilder: this.indicatorBuilder,
        swiperItemHandle: (swiperItemData: SwiperData) => {
          // TODO:点击swiper逻辑处理
          // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
          this.dynamicsRouterPush(swiperItemData);
        }
      })
    }
  }

  @Builder
  indicatorBuilder() {
    Row({ space: CommonConstants.INDICATOR_SPACE }) {
      ForEach(this.swiperListView, (item: SwiperData, index: number) => {
        Ellipse(index !== this.currentIndex ?
           { width: CommonConstants.INDICATOR_DEFAULT_WIDTH, height: CommonConstants.INDICATOR_HEIGHT } :
           { width: CommonConstants.INDICATOR_SELECTED_WIDTH, height: CommonConstants.INDICATOR_HEIGHT })
          .fill(index !== this.currentIndex ? Color.Black : Color.Red)
          .fillOpacity(CommonConstants.INDICATOR_FILL_OPACITY)
      })
    }
    .margin({ top: CommonConstants.INDICATOR_MARGIN_TOP })
  }
}

@Builder
function SwiperItemView(swiperItemData: SwiperData) {
  Stack({ alignContent: Alignment.BottomStart }) {
    Image(swiperItemData.imageSrc)
      .objectFit(ImageFit.Cover)
      .width(CommonConstants.CONTENT_FULL_VIEW)
      .height(CommonConstants.CONTENT_FULL_VIEW)
      .borderRadius($r('app.string.swipercomponent_main_page_top_borderRadius'))
    // 轮播图底部蒙层
    Stack() {
      Column() {
      }
      .width(CommonConstants.CONTENT_FULL_VIEW)
      .height(CommonConstants.CONTENT_FULL_VIEW)
      .backgroundColor(Color.Black)
      .opacity(CommonConstants.SWIPER_MASK_OPACITY)
      .borderRadius({
        topLeft: 0,
        topRight: 0,
        bottomLeft: $r('app.string.swipercomponent_main_page_top_borderRadius'),
        bottomRight: $r('app.string.swipercomponent_main_page_top_borderRadius')
      })

      Text(swiperItemData.name)
        .width(CommonConstants.CONTENT_FULL_VIEW)
        .height(CommonConstants.CONTENT_FULL_VIEW)
        .fontSize(CommonConstants.SWIPER_TITLE_NAME_FONT_SIZE)
        .fontColor(Color.White)
        .textAlign(TextAlign.Start)
        .padding($r('app.string.swipercomponent_main_page_padding5'))
    }
    .height($r('app.string.swipercomponent_bottom_title_height'))
  }
}