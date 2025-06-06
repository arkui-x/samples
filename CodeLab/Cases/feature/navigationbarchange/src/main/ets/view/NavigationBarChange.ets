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
import { promptAction } from "@kit.ArkUI";

/**
 * 功能描述: 本示例介绍使用Scroll组件的滚动事件 onScroll 实现状态栏显隐变化
 *
 * 推荐场景: 各种软件的首页、我的等页面
 *
 * 核心组件:
 * 1. Header
 *
 * 实现步骤：
 * 1. 在置顶位置使用stack组件添加两层状态栏
 * 2. 通过获取Scroll的偏移量，计算透明度，分别对状态栏的组件设置透明度来实现状态栏的显隐变化效果
 */
@Component
export struct NavigationBarChangeView {
  // Scroll的偏移量
  @State scrollOffset: number = 0;
  // 状态栏组件的透明度
  @State headOpacity: number = 0;
  // 是否在顶部的标志
  @State isTop: Boolean = true;
  // 状态栏的背景颜色
  @State titleBackgroundColor: Resource = $r('app.color.navigationbarchange_color_background');
  // 透明度默认值
  private opacityDefaultValue: number = 1;
  // 透明度计算基数
  private opacityComputeRadix: number = 35;
  // 内容相隔距离
  private columnSpace: number = 15;
  // 创建Scroll对象
  private scroller: Scroller = new Scroller();

  build() {
    Stack() {
      Scroll(this.scroller) {
        Column({ space: this.columnSpace }) {
          Text($r('app.string.navigationbarchange_text_welcome'))
            .fontSize($r('app.integer.navigationbarchange_font_size_twenty_two'))
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .textAlign(TextAlign.Start)
            .margin({ top: $r('app.integer.navigationbarchange_top_interval_sixty') })

          Text($r('app.string.navigationbarchange_text_new_user_registration'))
            .fontSize($r('app.integer.navigationbarchange_font_size_fourteen'))
            .margin({ top: $r('app.integer.navigationbarchange_top_interval_minus_five') })
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .textAlign(TextAlign.Start)

          Button($r('app.string.navigationbarchange_text_load'), { type: ButtonType.Capsule })
            .margin({ top: $r('app.integer.navigationbarchange_top_interval_twenty') })
            .fontSize($r('app.integer.navigationbarchange_font_size_eighteen'))
            .height($r('app.integer.navigationbarchange_width_and_height_forty'))
            .width($r('app.integer.navigationbarchange_width_and_height_one_hundred_and_thirty'))
            .position({ y: $r('app.integer.navigationbarchange_positionY') })

          // "购物"功能区
          Text($r('app.string.navigationbarchange_text_shopping'))
            .fontColor(Color.Black)
            .fontSize($r('app.integer.navigationbarchange_font_size_twenty'))
            .margin({
              top: $r('app.integer.navigationbarchange_top_interval_sixty'),
              bottom: $r('app.integer.navigationbarchange_bottom_interval_minus_five')
            })
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .textAlign(TextAlign.Center)

          Image($r('app.media.navigationbarchange_shopping'))
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .height($r('app.string.navigationbarchange_width_and_height_twenty_five_percent'))
            .borderRadius($r('app.integer.navigationbarchange_borderRadius_twelve'))

          // "娱乐"功能区
          Text($r('app.string.navigationbarchange_text_happy'))
            .fontColor(Color.Black)
            .fontSize($r('app.integer.navigationbarchange_font_size_twenty'))
            .margin({
              top: $r('app.integer.navigationbarchange_top_interval_ten'),
              bottom: $r('app.integer.navigationbarchange_bottom_interval_minus_ten')
            })
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .textAlign(TextAlign.Center)

          Image($r('app.media.navigationbarchange_happly'))
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .height($r('app.string.navigationbarchange_width_and_height_twenty_five_percent'))
            .borderRadius($r('app.integer.navigationbarchange_borderRadius_twelve'))

          // "休闲"功能区
          Text($r('app.string.navigationbarchange_text_relaxation'))
            .fontColor(Color.Black)
            .fontSize($r('app.integer.navigationbarchange_font_size_twenty'))
            .margin({
              top: $r('app.integer.navigationbarchange_top_interval_ten'),
              bottom: $r('app.integer.navigationbarchange_bottom_interval_minus_ten')
            })
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .textAlign(TextAlign.Center)

          Image($r('app.media.navigationbarchange_relaxation'))
            .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
            .height($r('app.string.navigationbarchange_width_and_height_twenty_five_percent'))
            .borderRadius($r('app.integer.navigationbarchange_borderRadius_twelve'))
            .margin({ bottom: $r('app.integer.navigationbarchange_bottom_interval_five') })

        }
        .id('navigation_bar_change_content')
        .width($r('app.string.navigationbarchange_width_and_height_ninety_two_percent'))
      }
      .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
      .height($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      // 高性能知识点：onScroll属于频繁回调接口，应该避免在内部进行冗余和耗时操作，例如避免打印日志
      .onScroll(() => {
        // TODO 知识点：显隐变化效果，获取Scroll偏移量，计算透明度，实现效果
        this.scrollOffset = this.scroller.currentOffset().yOffset;
        if (this.scrollOffset <= this.opacityComputeRadix) {
          this.headOpacity = this.scrollOffset / this.opacityComputeRadix;
        } else {
          this.headOpacity = this.opacityDefaultValue;
        }
      })

      // 添加置顶状态栏
      Header({
        headOpacity: this.headOpacity,
        titleBackgroundColor: $r('app.color.navigationbarchange_color_background'),
        isTop: false
      });
      // 添加置顶状态栏
      Header({
        headOpacity: this.opacityDefaultValue,
        titleBackgroundColor: $r('app.color.navigationbarchange_transparent_color'),
        isTop: true
      });
    }
    .id('navigation_bar_change_page')
    .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
    .height($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
    .backgroundColor($r('app.color.navigationbarchange_mine_background'))
    .alignContent(Alignment.Top)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

// 置顶状态栏实现
@Component
struct Header {
  // 状态栏组件的透明度
  @Prop headOpacity: number;
  // 状态栏的背景颜色
  @Prop titleBackgroundColor: Resource;
  // 是否在顶部的标志
  @Prop isTop: Boolean;
  // 内容相隔距离
  private columnSpace: number = 15;
  // 组件置顶时透明度
  private opacityTopValue: number = 0;
  // 组件非置顶时透明度
  private opacityUnTopValue: number = 1;

  build() {
    Row() {
      Row({ space: this.columnSpace }) {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.navigationbarchange_button_setting_configuration'))
            .width($r('app.integer.navigationbarchange_width_and_height_thirty_five'))
            .height($r('app.integer.navigationbarchange_width_and_height_thirty_five'))
        }
        .onClick(() => {
          promptDialog()
        })
        .backgroundColor($r('app.color.navigationbarchange_transparent_color'))

        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.navigationbarchange_button_scan'))
            .width($r('app.integer.navigationbarchange_width_and_height_thirty'))
            .height($r('app.integer.navigationbarchange_width_and_height_thirty'))
        }
        .onClick(() => {
          promptDialog()
        })
        .backgroundColor($r('app.color.navigationbarchange_transparent_color'))
      }
      .justifyContent(FlexAlign.Start)
      .margin({ left: $r('app.integer.navigationbarchange_left_interval_value') })
      .width($r('app.string.navigationbarchange_width_and_height_thirty_percent'))

      Text($r('app.string.navigationbarchange_text_mine'))
        .fontColor(Color.Black)
        .fontSize($r('app.integer.navigationbarchange_font_size_twenty_two'))
        .opacity(this.isTop ? this.opacityTopValue : this.opacityUnTopValue)

      Row() {
        Button({ type: ButtonType.Normal }) {
          Image($r('app.media.navigationbarchange_button_customer_service_line'))
            .width($r('app.integer.navigationbarchange_width_and_height_thirty'))
            .height($r('app.integer.navigationbarchange_width_and_height_thirty'))
        }
        .onClick(() => {
          promptDialog()
        })
        .backgroundColor($r('app.color.navigationbarchange_transparent_color'))
      }
      .justifyContent(FlexAlign.End)
      .margin({ right: $r('app.integer.navigationbarchange_right_interval_value') })
      .width($r('app.string.navigationbarchange_width_and_height_thirty_percent'))
    }
    .id('navigation_bar_change_title_button')
    .opacity(this.headOpacity)
    .height($r('app.integer.navigationbarchange_width_and_height_sixty'))
    .width($r('app.string.navigationbarchange_width_and_height_one_hundred_percent'))
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.titleBackgroundColor)
  }
}

function promptDialog() {
  promptAction.showToast({
    message: $r('app.string.navigationbarchange_prompt_action'),
    duration: 3000
  })
}

// 功能模块结构
interface ItemInfo {
  name: string
  image: Resource
  prompt?: string
}