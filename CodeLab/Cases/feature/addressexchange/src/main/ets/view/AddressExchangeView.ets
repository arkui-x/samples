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
import curves from '@ohos.curves';
import { promptAction } from '@kit.ArkUI';
import { AddressExchangeComponent } from './AddressExchangeComponent';

/**
 * 使用交换元素组件样例
 *
 * 核心组件:
 *
 * 实现步骤:
 * 1. 创建左右两边Text组件显示地址。设置初始偏移量以及文本对齐方式
 * 2. 点击中间的图标时，修改是否切换的状态变量值和通过animateTo修改偏移量的值，来实现动态更新左右两边地址的显示，完成动画效果
 */


/**
 * 功能描述：左右两侧图标可以进行交换，图标也会旋转，伴随着动画效果
 *
 * 推荐场景： 购票软件选择地址时使用
 *
 * 核心组件：
 * 1. AddressExchangeComponent： 地址交换组件
 *
 * 实现步骤：
 * 1. 自定义左侧地址模块样式
 * @example
 * @Builder
 * leftAddressBuilder() {
 *   Text($r('app.string.address_exchange_address_left'))
 *     .width($r('app.string.address_exchange_address_width'))
 *     .textAlign(TextAlign.Center)
 *     .fontSize($r('app.string.address_exchange_font_size'))
 *     .onClick(() => {
 *       promptAction.showToast({
 *       message: $r('app.string.address_exchange_other_function'),
 *       duration: this.toastDuration
 *       });
 *     })
 * }
 * 2. 自定义右侧地址模块样式
 * @example
 * @Builder
 * rightAddressBuilder() {
 *   Text($r('app.string.address_exchange_address_left'))
 *     .width($r('app.string.address_exchange_address_width'))
 *     .textAlign(TextAlign.Center)
 *     .fontSize($r('app.string.address_exchange_font_size'))
 *     .onClick(() => {
 *       promptAction.showToast({
 *       message: $r('app.string.address_exchange_other_function'),
 *       duration: this.toastDuration
 *       });
 *     })
 * }
 * 3. 自定义交换图标模块样式
 * @example
 * @Builder
 * exchangeIcon() {
 *   Image($r('app.media.address_exchange_airplane'))
 *     .size({
 *       height: $r('app.integer.address_exchange_airplane_size'),
 *       width: $r('app.integer.address_exchange_airplane_size')
 *     })
 *  Image($r('app.media.address_exchange_recycle'))
 *    .id('translate_image')
 *    .size({
 *       height: $r('app.integer.address_exchange_recycle_size'),
 *       width: $r('app.integer.address_exchange_recycle_size')
 *     })
 *     .rotate({ angle: this.rotateAngle })
 * }
 * 4. 初始化地址交换动画配置（可选参数）
 * @example
 * private translateAnimationParam: AnimateParam = { curve: curves.springMotion() };
 * 5. 定义单次偏移距离
 * @example
 * @State distance: number = this.rowWidth * 0.84;
 * 6. 初始化地址交换组件容器Flex内组件的排列方向（可选参数，默认为横向）
 * @example
 * private flexDirection: FlexDirection = FlexDirection.Row;
 * 7. 定义交换图标动画执行函数（可选参数，若无动画可以不进行定义）
 * @example
 * exchangeIconAnimationFunction(): void {
 *   // 图标一次旋转的角度
 *   const rotateAddAngle: number = 180;
 *   animateTo({ curve: curves.springMotion() }, () => {
 *   this.rotateAngle += rotateAddAngle;
 *   })
 *  }
 * 8. 构建地址交换组件
 * @example
 * AddressExchangeComponent({
 *   leftAddressBuilderParam: this.leftAddressBuilder,
 *   rightAddressBuilderParam: this.rightAddressBuilder,
 *   translateAnimationParam: this.translateAnimationParam,
 *   exchangeIconBuilderParam: this.exchangeIcon.bind(this),
 *   exchangeIconAnimationFunction: this.exchangeIconAnimationFunction.bind(this),
 *   distance: this.distance,
 *   flexDirection: this.flexDirection
 * })
 */

@Component
export struct AddressExchangeViewComponent {
  // 旋转角度
  @State rotateAngle: number = 0;
  // 整体内容区宽度
  private rowWidth: number = 300;
  // 内容相隔距离
  private columnSpace: number = 16;
  // toast弹窗时长
  private toastDuration: number = 2000;
  // 地址交换动画的配置，可由开发者自定义
  private translateAnimationParam: AnimateParam = { curve: curves.springMotion() };
  // 地址交换组件容器Flex的排列方向
  private flexDirection: FlexDirection = FlexDirection.Row;
  // 单次偏移距离
  @State distance: number = this.rowWidth * 0.84;

  /**
   * 左侧的地址
   */
  @Builder
  leftAddressBuilder() {
    Text($r('app.string.address_exchange_address_left'))
      .width($r('app.string.address_exchange_address_width'))
      .textAlign(TextAlign.Center)
      .fontSize($r('app.string.address_exchange_font_size'))
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.address_exchange_other_function'),
          duration: this.toastDuration
        });
      })
  }

  /**
   * 右侧的地址
   */
  @Builder
  rightAddressBuilder() {
    Text($r('app.string.address_exchange_address_right'))
      .width($r('app.string.address_exchange_address_width'))
      .textAlign(TextAlign.Center)
      .fontSize($r('app.string.address_exchange_font_size'))
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.address_exchange_other_function'),
          duration: this.toastDuration
        });
      })
  }

  /**
   * 点击即可交换的图标
   */
  @Builder
  exchangeIcon() {
    Image($r('app.media.address_exchange_airplane'))
      .size({
        height: $r('app.integer.address_exchange_airplane_size'),
        width: $r('app.integer.address_exchange_airplane_size')
      })
    Image($r('app.media.address_exchange_recycle'))
      .id('translate_image')
      .size({
        height: $r('app.integer.address_exchange_recycle_size'),
        width: $r('app.integer.address_exchange_recycle_size')
      })
      .rotate({ angle: this.rotateAngle })
  }

  /**
   * 图标旋转动画
   */
  exchangeIconAnimationFunction(): void {
    // 图标一次旋转的角度
    const rotateAddAngle: number = 180;
    animateTo({ curve: curves.springMotion() }, () => {
      this.rotateAngle += rotateAddAngle;
    })
  }

  build() {
    // 地址交换
    Column({ space: this.columnSpace }) {
      Column() {
        /**
         * 构建地址交换组件
         * leftAddressBuilderParam：左侧地址模块
         * rightAddressBuilderParam：右侧地址模块
         * translateAnimationConfig：地址交换动画的配置
         * exchangeIconBuilderParam：交换图标模块
         * exchangeIconAnimationFunction：图标旋转动画执行函数
         * distance：单次偏移距离
         * flexDirection：地址交换组件容器Flex的排列方向
         */
        AddressExchangeComponent({
          leftAddressBuilderParam: this.leftAddressBuilder,
          rightAddressBuilderParam: this.rightAddressBuilder,
          translateAnimationParam: this.translateAnimationParam,
          exchangeIconBuilderParam: this.exchangeIcon.bind(this),
          exchangeIconAnimationFunction: this.exchangeIconAnimationFunction.bind(this),
          distance: this.distance,
          flexDirection: this.flexDirection
        })
      }
      .width(this.rowWidth)

      Row({ space: this.columnSpace }) {
        Text($r('app.string.address_exchange_date'))
          .fontSize($r('app.string.ohos_id_text_size_headline'))
          .fontWeight(FontWeight.Medium)
          .height($r('app.integer.address_exchange_date_height'))
        Text($r('app.string.address_exchange_week'))
          .height($r('app.integer.address_exchange_date_height'))
      }
      .width(this.rowWidth)
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.address_exchange_other_function'),
          duration: this.toastDuration
        });
      })

      Button($r('app.string.address_exchange_search_ticket'))
        .fontColor(Color.White)
        .height($r('app.integer.address_exchange_button_height'))
        .width(this.rowWidth)
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.address_exchange_other_function'),
            duration: this.toastDuration
          });
        })
    }
    .backgroundColor($r('app.string.ohos_id_color_sub_background'))
    .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    .width($r('app.string.address_exchange_content_size'))
    .height($r('app.integer.address_exchange_total_height'))
    .margin($r('app.string.ohos_id_card_margin_start'))
  }
}



