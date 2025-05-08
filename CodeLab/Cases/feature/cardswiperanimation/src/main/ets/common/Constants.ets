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

import { CardInfo } from '../model/CardModel';

/**
 * 默认属性及常量值
 */
export default class Constants {
  // 判断是否平板展示使用的常量：
  // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示
  static readonly DEVICESIZE: number = 600;
  // CardSwiperComponent大小100%
  static readonly CARD_SWIPER_FULL_SIZE = "100%";
  // 卡片的单位长度，便于设置卡片的比例
  public static readonly CARD_UNIT_LENGTH: number = 120;
  // 卡片列表测试用例，若未传入数据则按照CARD_TEST_CASE展示（与示例传入数据顺序相逆）
  public static readonly CARD_TEST_CASE: CardInfo[] = [
    // 卡片比例 2 x 1
    { src: $r('app.media.bear'), width: 2 * this.CARD_UNIT_LENGTH, height: this.CARD_UNIT_LENGTH },
    // 卡片比例 2 x 2
    { src: $r('app.media.parrot'), width: 2 * this.CARD_UNIT_LENGTH, height: 2 * this.CARD_UNIT_LENGTH },
    // 卡片比例 1 x 2
    { src: $r('app.media.kangaroo'), width: this.CARD_UNIT_LENGTH, height: 2 * this.CARD_UNIT_LENGTH },
    // 卡片比例 1 x 1
    { src: $r('app.media.panda'), width: this.CARD_UNIT_LENGTH, height: this.CARD_UNIT_LENGTH },
  ];
  // 卡片懒加载的预加载数量
  public static readonly SWIPER_CACHE_COUNT: number = 4;
  // Swiper 的偏移量
  public static readonly SWIPER_MARGIN: number = 25;
  // 图片动画透明度值
  public static readonly OPACITY: number = 0.99;
  // 图片动画时长
  public static readonly DURATION: number = 280;
  // 所有动画默认曲线，Friction(阻尼曲线)
  public static readonly DEFAULT_ANIMATION_CURVE = Curve.Friction;

  // 边缘渐变配置
  // 边缘渐变起始和终止颜色
  public static readonly BEGIN_COLOR: string = '#00ffffff';
  public static readonly END_COLOR: string = '#ffffffff';
  // 渐变颜色位置
  public static readonly OVERLAY_LINEAR_GRADIENT_COLOR_POS: number[] = [0.0, 0.03, 0.97, 1.0];
  // 渐变角度
  public static readonly OVERLAY_LINEAR_GRADIENT_ANGLE: number = 90;
  // 渐变遮盖层高度，设置为卡片列表中最高卡片的高度
  public static readonly FADING_OVERLAY_LENGTH: number = 2 * this.CARD_UNIT_LENGTH;
  // 边缘渐变动画时长
  public static readonly OVERLAY_DURATION: number = 220;
  // 边缘渐变动画曲线
  public static readonly OVERLAY_ANIMATION_CURVE = Curve.Friction;

  // 背景渐变配置
  // 背景线性渐变起始角度, 180即为从上至下渐变
  public static readonly LINEAR_GRADIENT_ANGLE = 180;
  // 背景渐变颜色位置
  public static readonly BACKGROUND_LINEAR_GRADIENT_COLOR_POS: number[] = [0.0, 0.3, 0.7, 1.0];
  // 背景起始颜色
  public static readonly BACKGROUND_END_COLOR: string = '#00ffffff';
}