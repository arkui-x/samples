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

export class CommonConstants {
  // 轮播切换动画时间
  static readonly SWIPER_ANIMATION_DURATION: number = 300;
  // 轮播图每5s切换一次
  static readonly SWIPER_SWITCH_DURATION: number = 2000;
  // 是否循环切换
  static readonly SWIPER_IS_LOOP: boolean = true;
  // 导航点间隔
  static readonly INDICATOR_SPACE: number = 10;
  // 导航点默认宽度
  static readonly INDICATOR_DEFAULT_WIDTH: number = 8;
  // 导航点选中宽度
  static readonly INDICATOR_SELECTED_WIDTH: number = 10;
  // 导航点高度
  static readonly INDICATOR_HEIGHT: number = 8;
  // 导航点透明度
  static readonly INDICATOR_FILL_OPACITY: number = 0.6;
  // 导航点上外间距
  static readonly INDICATOR_MARGIN_TOP: number = 12;
  // 百分之百
  static readonly CONTENT_FULL_VIEW: string = '100%';
  // 轮播图蒙层透明度
  static readonly SWIPER_MASK_OPACITY: number = 0.3;
  // 标题名称字体大小
  static readonly SWIPER_TITLE_NAME_FONT_SIZE: number = 16;
  // 轮播图模糊效果值
  static readonly SWIPER_BLUR_VALUE: number = 12;
  // 轮播图圆角
  static readonly SWIPER_BORDER_RADIUS: number = 8;
  // 左滑临界值
  static readonly SWIPER_LEFT_SCROLL: number = 50;
  // 右滑临界值
  static readonly SWIPER_RIGHT_SCROLL: number = -50;
  // 横轴偏移量
  static readonly SWIPER_OFFSET_X: number = -35;
}