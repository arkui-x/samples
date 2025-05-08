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
import Constants from '../common/Constants';
import { CardSwiperComponent } from '../utils/CardSwiperComponent';
import { CardInfo } from '../model/CardModel';

/**
 * 功能说明：本示例通过Swiper、Image组件实现卡片预览效果和滚动切换, 通过linearGradient实现主题背景色渐变和滑动边缘渐变
 *
 * 推荐场景：不同比例卡片滚动切换、主题色随卡片中图片渐变
 *
 * 核心组件：
 * 1. CardSwiperComponent: 卡片组件滚动切换组件, 叠底渐变背景, 遮盖渐变边缘
 * 2. CardComponent: 卡片子组件, 展示全模态窗图片或缩略图
 *
 * 实现步骤：
 * 1. 构建 initCardsList 数组, 向组件中传入初始化内容; 数组中每项包括 src: 图片路径, with: 单卡片宽度, height: 单卡片高度
 *    根据想要展示的比例设置对应宽度和高度，如宽: 高为1: 2展示时, width配置为1倍的CARD_UNIT_LENGTH, height配置为2倍的CARD_UNIT_LENGTH
 * @example
 * this.initCardsList = [
     // 卡片比例 1 x 1
     { src: $r('app.media.panda'), width: Constants.CARD_UNIT_LENGTH, height: Constants.CARD_UNIT_LENGTH },
     // 卡片比例 1 x 2
     { src: $r('app.media.kangaroo'), width: Constants.CARD_UNIT_LENGTH, height: 2 * Constants.CARD_UNIT_LENGTH },
     // 卡片比例 2 x 1
     { src: $r('app.media.bear'), width: 2 * Constants.CARD_UNIT_LENGTH, height: Constants.CARD_UNIT_LENGTH },
     // 卡片比例 2 x 2
     { src: $r('app.media.parrot'), width: 2 * Constants.CARD_UNIT_LENGTH, height: 2 * Constants.CARD_UNIT_LENGTH },
   ];
 * 2. 打开或关闭边缘渐变和主题渐变, isEdgeFading配置为滑动边缘渐变, isBackgroundColorChange配置为主题背景渐变
 *    如需调整边缘渐变的颜色、宽度, 则修改Constants中边缘渐变配置的部分, 如：BEGIN_COLOR
 *    如需调整主题背景渐变的方向、宽度, 则修改Constants中背景渐变配置的部分, 如：LINEAR_GRADIENT_ANGLE
 * @example
 * isEdgeFading : boolean = true;
 * isBackgroundColorChange : boolean = true;
 * isShowPreviewImage : boolean = true;
 * 3. 构建 CardSwiperComponent 卡片组件滚动切换组件
 * @example
 * CardSwiperComponent({
    initCardsList : this.initCardsList
    isEdgeFading : this.isEdgeFading,
    isBackgroundColorChange: this.isBackgroundColorChange,
    isShowPreviewImage : this.isShowPreviewImage
   })
 *
 */
@Component
export struct CardSwiperAnimationComponent {
  // 卡片列表
  initCardsList : CardInfo[] = [];
  // 边缘渐变
  isEdgeFading : boolean = true;
  // 主题背景渐变
  isBackgroundColorChange : boolean = true;
  // 开启预览大图
  isShowPreviewImage : boolean = true;

  aboutToAppear() :void {
    this.initCardsList = [
      // 卡片比例 1 x 1
      { src: $r('app.media.panda'), width: Constants.CARD_UNIT_LENGTH, height: Constants.CARD_UNIT_LENGTH },
      // 卡片比例 1 x 2
      { src: $r('app.media.kangaroo'), width: Constants.CARD_UNIT_LENGTH, height: 2 * Constants.CARD_UNIT_LENGTH },
      // 卡片比例 2 x 1
      { src: $r('app.media.bear'), width: 2 * Constants.CARD_UNIT_LENGTH, height: Constants.CARD_UNIT_LENGTH },
      // 卡片比例 2 x 2
      { src: $r('app.media.parrot'), width: 2 * Constants.CARD_UNIT_LENGTH, height: 2 * Constants.CARD_UNIT_LENGTH },
    ];

  }

  build() {
    Column() {
      /**
       * 卡片组件滚动切换
       * initCardsList: 初始化数据列表
       * isEdgeFading: 边缘渐变开启
       * isBackgroundColorChange: 主题背景渐变开启
       * isShowPreviewImage : 预览大图开启
       */
      CardSwiperComponent({
        initCardsList : this.initCardsList,
        isEdgeFading : this.isEdgeFading,
        isBackgroundColorChange: this.isBackgroundColorChange,
        isShowPreviewImage : this.isShowPreviewImage
      })
        .height($r('app.string.card_swiper_component_size'))
    }
    .height($r('app.string.card_swiper_animation_component_size'))
    .width($r('app.string.card_swiper_animation_component_size'))
  }
}