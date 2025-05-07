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

import { CommonConstants as Const } from '../common/CommonConstants';
import { logger } from '../utils/Logger';

/**
 * 代表自定义类型数据的接口。
 *
 * @interface
 * @property {Resource} name - 名字。
 * @property {Resource} image - 图片。
 * @property {Resource} prompt - 角标。
 */
interface GridItemInfo {
  name: Resource
  image: Resource
  prompt?: Resource
};


@CustomDialog
struct CustomDialogExample{
  controller: CustomDialogController;

  build() {
    Column() {
      Text($r('app.string.swipersmoothvariation_message_custom_dialog'))
    }
    .justifyContent(FlexAlign.Start)
  }
}
/**
 * 自定义组件
 * 功能：自定义一个图标+文字组合
 */
@Component
struct ViewItem {
  item: GridItemInfo = {
    name: $r('app.string.swipersmoothvariation_name_pageone'),
    image: $r("app.media.swipersmoothvariation_taxi"),
    prompt: $r('app.string.swipersmoothvariation_first_prompt')
  };

  build() {
    Column() {
      Stack() {
        Image(this.item.image)
          .height($r('app.float.swipersmoothvariation_app_side_length'))
          .width($r('app.float.swipersmoothvariation_app_side_length'))
        Text(this.item.prompt)
          .fontColor($r('app.color.swipersmoothvariation_color_white'))
          .fontSize($r('app.float.swipersmoothvariation_badge_font_size'))
          .backgroundColor($r('app.color.swipersmoothvariation_badge_color'))
          .borderRadius({
            topLeft: $r('app.float.swipersmoothvariation_text_border_radius'),
            topRight: $r('app.float.swipersmoothvariation_text_border_radius'),
            bottomRight: $r('app.float.swipersmoothvariation_text_border_radius')
          })
          .textAlign(TextAlign.Center)
          .width($r('app.integer.swipersmoothvariation_item_width'))
          .height($r('app.integer.swipersmoothvariation_item_height'))
          .margin({ top: $r('app.integer.swipersmoothvariation_margin_top'), left: $r('app.integer.swipersmoothvariation_margin_left') })
            // TODO: 知识点: Text绑定visibility属性方法，进而控制组件的显隐状态，避免组件的频繁创建与销毁，提升性能。
            // 性能知识点: Text绑定visibility属性方法，避免组件的频繁创建与销毁，提升性能。
          .visibility(this.item.prompt !== undefined ? Visibility.Visible : Visibility.None)
      }
      .width(Const.FULL_PERCENT)
      Text(this.item.name)
        .margin({ top: $r('app.float.swipersmoothvariation_item_text_offset') })
        .fontSize($r('app.float.swipersmoothvariation_small_font_size'))
    }
  }
}



/**
 * 功能描述: 在很多应用中，swiper组件每一个page的高度是不一致的，所以需要swiper组件下方页面的高度跟着一起变化。
 *
 * 推荐场景: 页面高度随着swiper高度平滑变化
 *
 * 核心组件:
 * 1. onGestureSwipe
 *
 * 实现步骤：
 * 1. 生成四个Swiper页面，来进行左右滑动，GridBuilderFunction是生成Swiper的page。
 * 2. Swiper组件的回调，通过左右滑动的距离来计算对应的上下位置的变化，在页面跟手滑动过程中，逐帧触发onGestureSwipe回调，swiperDistance发生变化。
 * 3. Swiper组件的回调，用来达到平滑变化的效果，切换动画开始时触发onAnimationStart回调。
 */

@Component
export struct SwiperSmoothVariationComponent {
  // scroller控制器初始化
  private gridScroller: Scroller = new Scroller();
  private dialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample()
  });
  // swiper的第一个页面数据
  private dataPageOne: GridItemInfo[] = [
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi"), prompt: $r('app.string.swipersmoothvariation_first_prompt') },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi"), prompt: $r('app.string.swipersmoothvariation_sec_prompt') },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
    { name: $r('app.string.swipersmoothvariation_name_pageone'), image: $r("app.media.swipersmoothvariation_taxi") },
  ];
  // swiper的第二个页面数据
  private dataPageTwo: GridItemInfo[] = [
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
    { name: $r('app.string.swipersmoothvariation_name_pagetwo'), image: $r("app.media.swipersmoothvariation_car_icon2") },
  ];
  // swiper的第三个页面数据
  private dataPageThree: GridItemInfo[] = [
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
    { name: $r('app.string.swipersmoothvariation_name_pagethree'), image: $r("app.media.swipersmoothvariation_car_icon") },
  ];
  // swiper的第四个页面数据
  private dataPageFour: GridItemInfo[] = [
    { name: $r('app.string.swipersmoothvariation_name_pagefour'), image: $r("app.media.swipersmoothvariation_taxi") }
  ];
  // 下方页面对应swiper上下位置的变化
  @State swiperDistance: number = 0;

  // 自定义构建函数，生成每一个swiper页面的函数
  @Builder
  GridBuilderFunction(page: GridItemInfo[], height: number, template: string) {
    Column() {
      Grid(this.gridScroller) {
        ForEach(page, (item: GridItemInfo) => {
          GridItem() {
            ViewItem({ item: item })
              .onClick(() => {
                this.dialog.open();
              })
          }
          .width(Const.FULL_PERCENT)
          .height(height)
          .width($r('app.float.swipersmoothvariation_scroll_width'))
        })
      }
      .height(height)
      .width($r('app.string.swipersmoothvariation_width_full'))
      .borderRadius($r('app.float.swipersmoothvariation_border_radius'))
      .edgeEffect(EdgeEffect.None)
      .columnsTemplate(Const.COLUMN_TEMPLATE)
      .rowsTemplate(template)

      // 如果页面是swiper的第一个page的话，上方有其他组件，swiper需要降低高度
      if (page === this.dataPageOne) {
        Column()
          .margin({ top: this.swiperDistance })
          .height($r('app.float.swipersmoothvariation_blank_height'))
          .width($r('app.float.swipersmoothvariation_scroll_width'))
      } else {
        Column()
          .margin(height === Const.GRID_SINGLE_HEIGHT ?
            { top: Const.SWIPER_OFFSET + Const.GRID_SINGLE_HEIGHT + this.swiperDistance } :
            { top: Const.SWIPER_OFFSET + this.swiperDistance })
          .height($r('app.float.swipersmoothvariation_blank_height'))
          .width($r('app.float.swipersmoothvariation_scroll_width'))
      }
    }
    .margin(page === this.dataPageOne ? { top: $r('app.float.swipersmoothvariation_swiper_offset') } : 0)
  }

  /**
   * 创建一个stack组件，用来显示swiper和下方页面（下方column），创建swiper组件用来显示滑动效果
   * 当swiper滑动时，下方页面（column）高度也会变化
   */
  build() {
    Stack() {
      Swiper() {
        Column() {
          Stack() {
            Text('功能栏')
              .textAlign(TextAlign.Center)
              .margin({ top: $r('app.integer.swipersmoothvariation_margin_small'), left: $r('app.integer.swipersmoothvariation_default_padding') })
            // swiper第一个page
            this.GridBuilderFunction(this.dataPageOne, Const.GRID_DOUBLE_HEIGHT, Const.GRID_TEMPLATE)
          }
          .alignContent(Alignment.TopStart)
        }

        // swiper第二个page
        this.GridBuilderFunction(this.dataPageTwo, Const.GRID_DOUBLE_HEIGHT, Const.GRID_TEMPLATE)
        // swiper第三个page
        this.GridBuilderFunction(this.dataPageThree, Const.GRID_DOUBLE_HEIGHT, Const.GRID_TEMPLATE)
        // swiper第四个page
        this.GridBuilderFunction(this.dataPageFour, Const.GRID_SINGLE_HEIGHT, Const.GRID_SINGLE_TEMPLATE)
      }
      .width($r('app.string.swipersmoothvariation_width_full'))
      .backgroundColor($r('app.color.swipersmoothvariation_color_white'))
      .borderRadius($r('app.integer.swipersmoothvariation_border_radius'))
      .margin({ top: $r('app.float.swipersmoothvariation_margin_fifteen') })
      .effectMode(EdgeEffect.None)
      .loop(false)
      // TODO: 知识点: Swiper组件绑定onGestureSwipe事件，在页面跟手滑动过程中，逐帧触发该回调
      // 性能知识点: onGestureSwipe属于频繁回调，不建议在onGestureSwipe做耗时和冗余操作
      .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
        animateTo({
          duration: Const.DURATION_SWIPER,
          curve: Curve.EaseOut,
          playMode: PlayMode.Normal,
          onFinish: () => {
            logger.info('play end');
          }
        }, () => { // 通过左右滑动的距离来计算对应的上下位置的变化
          if (index === 0 && extraInfo.currentOffset < 0) {
            this.swiperDistance = extraInfo.currentOffset / Const.SCROLL_WIDTH * Const.SMALL_FONT_SIZE;
          } else if (index === 1 && extraInfo.currentOffset > 0) {
            this.swiperDistance = extraInfo.currentOffset / Const.SCROLL_WIDTH * Const.SMALL_FONT_SIZE - Const.SMALL_FONT_SIZE;
          } else if (index === 2 && extraInfo.currentOffset < 0) {
            this.swiperDistance = extraInfo.currentOffset / Const.SCROLL_WIDTH * Const.GRID_SINGLE_HEIGHT - Const.SMALL_FONT_SIZE;
          } else if (index === 3 && extraInfo.currentOffset > 0) {
            this.swiperDistance = extraInfo.currentOffset / Const.SCROLL_WIDTH * Const.GRID_SINGLE_HEIGHT - Const.SMALL_FONT_SIZE - Const.GRID_SINGLE_HEIGHT;
          }
        })
      })
      // 平滑变化的动画效果
      .onAnimationStart((_: number, targetIndex: number) => {
        animateTo({
          duration: Const.DURATION_DOWN_PAGE,
          curve: Curve.EaseOut,
          playMode: PlayMode.Normal,
          onFinish: () => {
            logger.info('play end');
          }
        }, () => {
          if (targetIndex === 0) {
            this.swiperDistance = 0;
          } else if (targetIndex === 1 || targetIndex === 2) {
            this.swiperDistance = -Const.SMALL_FONT_SIZE;
          } else {
            this.swiperDistance = -Const.SMALL_FONT_SIZE - Const.GRID_SINGLE_HEIGHT;
          }
        })
      })
      // swiper指示器
      .indicator(new DotIndicator()
        .selectedItemWidth($r('app.float.swipersmoothvariation_select_item_width'))
        .selectedItemHeight($r('app.float.swipersmoothvariation_select_item_height'))
        .itemWidth($r('app.float.swipersmoothvariation_default_item_width'))
        .itemHeight($r('app.float.swipersmoothvariation_default_item_height'))
        .selectedColor($r('app.color.swipersmoothvariation_swiper_selected_color'))
        .color($r('app.color.swipersmoothvariation_swiper_unselected_color')))
      // swiper下方的页面
      Image($r("app.media.swipersmoothvariation_test"))
        .height($r('app.integer.swipersmoothvariation_height_1'))
        .borderRadius($r('app.integer.swipersmoothvariation_border_radius'))
        .width($r('app.string.swipersmoothvariation_width_full'))
        .offset({ y: this.swiperDistance })
        .margin({ top: $r('app.float.swipersmoothvariation_colum_offset_one') })
    }
    .backgroundColor($r('app.color.swipersmoothvariation_stack_color'))
    .padding($r('app.integer.swipersmoothvariation_default_padding'))
    .alignContent(Alignment.TopStart)
  }
}