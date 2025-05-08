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

import { curves } from '@kit.ArkUI';

/**
 * 功能描述：
 * 1. 点击中间的交换图标，左右两侧的地址可以交换，图标也会进行旋转，伴随着动画效果
 *
 * 实现原理：
 * 1. 点击交换图标，通过animateTo修改偏移量的值和图标的旋转角度，完成动画效果
 *
 * @param { () => void } exchangeIconBuilderParam - 交换图标模块
 * @param { () => void } leftAddressBuilderParam - 左侧地址模块
 * @param { () => void } rightAddressBuilderParam - 右侧地址模块
 * @param { AnimateParam } translateAnimationParam - 地址交换动画的配置
 * @param { number } distance - 单次偏移距离
 * @param { FlexDirection } flexDirection - 初始化地址交换组件容器Flex内组件的排列方向
 * @param { () => void } exchangeIconAnimationFunction - 图标旋转动画执行函数
 */
@Component
export struct AddressExchangeComponent {
  // -------------------对外暴露变量-----------------------
  // 交换图标模块
  @BuilderParam exchangeIconBuilderParam: () => void = this.exchangeIconBuilder;
  // 左侧地址模块
  @BuilderParam leftAddressBuilderParam: () => void = this.leftAddressBuilder;
  // 右侧地址模块
  @BuilderParam rightAddressBuilderParam: () => void = this.rightAddressBuilder;
  // 地址交换动画的配置
  @State translateAnimationParam?: AnimateParam = { curve: curves.springMotion() };
  // 单次偏移距离
  @Link distance: number;
  // 地址交换组件容器Flex的排列方向
  @State flexDirection?: FlexDirection = FlexDirection.Row;
  // 图标旋转动画执行函数
  exchangeIconAnimationFunction?: () => void = () => {
  };
  // --------------------私有属性----------------------------
  @State translateOffset: number = 0;
  // 判断是否已交换
  @State swap: boolean = false;
  // 初始化偏移距离
  private zeroTranslate: number = 0;

  // 左侧地址
  @Builder
  leftAddressBuilder() {
  };

  // 右侧地址
  @Builder
  rightAddressBuilder() {
  };

  // 交换图标
  @Builder
  exchangeIconBuilder() {
  };

  build() {
    Flex({ direction: this.flexDirection, justifyContent: FlexAlign.SpaceBetween }) {
      Column() {
        this.leftAddressBuilderParam();
      }
      .translate(this.flexDirection === FlexDirection.Column ? { y: this.translateOffset } :
        { x: this.translateOffset })

      Stack() {
        this.exchangeIconBuilderParam();
      }
      .onClick(() => {
        this.swap = !this.swap
        // TODO 知识点：动画效果，修改偏移量
        animateTo(this.translateAnimationParam, () => {
          if (this.swap) {
            this.translateOffset = this.distance;
          } else {
            this.translateOffset = this.zeroTranslate;
          }
        });

        if (this.exchangeIconAnimationFunction) {
          this.exchangeIconAnimationFunction();
        }
      })

      Column() {
        this.rightAddressBuilderParam();
      }
      .translate(this.flexDirection === FlexDirection.Column ? { y: -this.translateOffset } :
        { x: -this.translateOffset })
    }
    .margin({ top: $r('app.string.address_exchange_flex_margin_top_size') })
  }
}