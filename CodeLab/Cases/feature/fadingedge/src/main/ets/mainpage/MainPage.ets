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

import Const from '../common/Constants';
import { promptAction } from '@kit.ArkUI';

/**
 * 功能描述：本案例介绍组件内容边缘渐变的实现，通常用于提示长列表滑动到边缘的场景。
 *
 * 推荐场景：电商、邮箱、资讯、门户等需要降低视觉噪音的场景
 *
 * 核心组件：
 * 1.FadingEdgeComponent
 *
 * 实现思路：
 * 1. 创建可滚动的主页面。
 * 2. 利用颜色渐变通用属性，创建两端渐隐的自定义组件。
 * 3. 通过overlay通用属性，设置子组件为遮罩层。
 */

@Component
export struct FadingEdgeComponent {
  private textArray: number[] = [];
  // 渐变起始和终止颜色
  @State linearGradientBeginColor: string = Const.BEGIN_COLOR;
  @State linearGradientEndColor: string = Const.END_COLOR;
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    for (let i = 0; i < Const.ITEM_COUNT; i++) {
      this.textArray.push(i);
    }
  }

  build() {
    Scroll(){
      Column({ space: Const.ROOT_GAP }) {
        Row({ space: Const.MENU_ITEM_SPACE }) {
          this.controlBarItem($r("app.media.fadingedge_order"), $r('app.string.fadingedge_order'));
          this.controlBarItem($r("app.media.fadingedge_coupon"), $r('app.string.fadingedge_coupon'));
          this.controlBarItem($r("app.media.fadingedge_footprint"), $r('app.string.fadingedge_footprint'));
          this.controlBarItem($r("app.media.fadingedge_tip"), $r('app.string.fadingedge_tip'));
          this.controlBarItem($r("app.media.fadingedge_wallet"), $r('app.string.fadingedge_wallet'));
        }
        .width($r('app.string.fadingedge_fill_size'))
        .justifyContent(FlexAlign.SpaceAround)
        .backgroundColor($r('app.color.fadingedge_menu_background_color'))
        .padding($r('app.integer.fadingedge_menu_padding'))
        .borderRadius($r('app.integer.fadingedge_menu_border_radius'))
        .onClick(() => {
          this.promptToast();
        })

        // 广告图片banner
        Image($r("app.media.fadingedge_example3"))
          .width($r('app.string.fadingedge_fill_size'))
          .borderRadius($r('app.integer.fadingedge_banner_border_radius'))
          .backgroundColor($r('app.color.fadingedge_banner_background_color'))
          .padding($r('app.integer.fadingedge_banner_padding'))
          .onClick(() => {
            this.promptToast();
          })

        // 主体
        List({ space: Const.EXAMPLE_IMAGE_GAP, scroller: this.scroller }) {
          ForEach(this.textArray, () => {
            ListItem() {
              Image($r("app.media.fadingedge_example1"))
                .width($r('app.integer.fadingedge_example_image_width'))
                .height($r('app.integer.fadingedge_example_image_height'))
                .borderRadius($r('app.integer.fadingedge_example_image_border_radius'))
            }
          }, (item: number) => item.toString())
        }
        .listDirection(Axis.Horizontal)
        .width($r('app.string.fadingedge_fill_size'))
        .height($r('app.integer.fadingedge_list_height'))
        .overlay(this.fadingOverlay())
        .edgeEffect(EdgeEffect.None)
        .scrollBar(BarState.Off)
        .onReachStart(() => {
          this.linearGradientBeginColor = Const.BEGIN_COLOR;
          this.linearGradientEndColor = Const.END_COLOR;
        })
        .onReachEnd(() => {
          this.linearGradientBeginColor = Const.END_COLOR;
          this.linearGradientEndColor = Const.BEGIN_COLOR;
        })
        .onDidScroll((scrollOffset: number, scrollState: ScrollState)=>{
          // 列表滑动到于中间位置时，两侧都有边缘渐变效果
          if(this.scroller.currentOffset().xOffset !== 0 && !this.scroller.isAtEnd()){
            this.linearGradientBeginColor = Const.END_COLOR;
            this.linearGradientEndColor = Const.END_COLOR;
          }
        })

        // 其余填充
        Image($r("app.media.fadingedge_example2"))
          .objectFit(ImageFit.Contain)
          .borderRadius($r('app.integer.fadingedge_other_border_radius'))
          .width($r('app.string.fadingedge_fill_size'))
          .backgroundColor($r('app.color.fadingedge_others_background_color'))
          .borderRadius($r('app.integer.fadingedge_other_border_radius'))
          .onClick(() => {
            this.promptToast();
          })
      }
      .width($r('app.string.fadingedge_fill_size'))
      .padding($r('app.integer.fadingedge_root_padding'))
    }
    .width($r('app.string.fadingedge_fill_size'))
    .height($r('app.string.fadingedge_fill_size'))
    .scrollBar(BarState.Off)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  /**
   * 菜单栏组件。
   * @param image
   * @param text
   */
  @Builder
  controlBarItem(image: ResourceStr, text: ResourceStr) {
    Column({ space: Const.MENU_ITEM_COL_SPACE }) {
      Image(image)
        .width($r('app.integer.fadingedge_menu_item_image_width'))
        .height($r('app.integer.fadingedge_menu_item_image_height'))
      Text(text)
    }
    .padding($r('app.integer.fadingedge_menu_item_padding'))
  }

  /**
   * 浮层组件。
   */
  @Builder
  fadingOverlay() {
    Column()
      .width($r('app.string.fadingedge_fill_size'))
      .height($r('app.integer.fadingedge_list_height'))// TODO: 知识点: linearGradient 可以设置指定范围内的颜色渐变效果
      .linearGradient({
        angle: Const.OVERLAY_LINEAR_GRADIENT_ANGLE,
        colors: [
          [this.linearGradientBeginColor, Const.OVERLAY_LINEAR_GRADIENT_COLOR_POS[0]],
          [Const.BEGIN_COLOR, Const.OVERLAY_LINEAR_GRADIENT_COLOR_POS[1]],
          [Const.BEGIN_COLOR, Const.OVERLAY_LINEAR_GRADIENT_COLOR_POS[2]],
          [this.linearGradientEndColor, Const.OVERLAY_LINEAR_GRADIENT_COLOR_POS[3]],
        ]
      })
      .animation({
        curve: Curve.Ease,
        duration: Const.DURATION
      })
      .hitTestBehavior(HitTestMode.Transparent)
  }

  /**
   * 示例提示toast窗口
   */
  promptToast() {
    promptAction.showToast({
      message: $r('app.string.fadingedge_prompt_message'),
      duration: Const.PROMPT_TOAST_DURATION
    })
  }
}