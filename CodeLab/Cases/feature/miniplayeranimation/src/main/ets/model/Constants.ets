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

/**
 * 常量类
 */
export default class Constants {
  // Mini条展开和收起动画时长
  public static readonly MINI_ANIMATION_DURATION: number = 500;
  // 全屏播放页拖动后松手的回弹动画时长
  public static readonly REBOUND_ANIMATION_DURATION: number = 200;
  // 全屏播放页收起按钮父容器Row高度
  public static readonly DOWN_ARROW_ROW_HEIGHT: number = 50;
  // 全屏播放页收起按钮父容器Row的底部外边距
  public static readonly ROW_MARGIN_BOTTOM: number = 80;
  // Mini条高度
  public static readonly MINI_HEIGHT: number = 48;
  // TabBar高度
  public static readonly BAR_HEIGHT: number = 56;
  // Mini条歌曲封面尺寸
  public static readonly MINI_IMG_SIZE: number = 32;
  // Mini条歌曲封面距离Mini条顶部距离
  public static readonly MINI_SPACE: number = (this.MINI_HEIGHT - this.MINI_IMG_SIZE) / 2;
  // Mini条歌曲封面Radius
  public static readonly MINI_IMG_RADIUS: number = 4;
  // Mini条歌曲封面距离左侧的外边距
  public static readonly MINI_IMG_MARGIN_LEFT: number = 12;
  // 子元素空间权重
  public static readonly LAYOUT_WEIGHT: number = 1;
  // slider当前进度值
  public static readonly SLIDER_CURRENT_VA: number = 75;
  // slider最小值
  public static readonly SLIDER_MIN_VAL: number = 0;
  // slider最大值
  public static readonly SLIDER_MAX_VAL: number = 100;
  // 全屏播放页歌曲封面尺寸
  public static readonly DETAILS_PAGE_IMG_SIZE: number = 300;
  // Mini条X轴位置
  public static readonly MINI_POSITION_X: number = 0;
  // tabBar选中时的字体粗细
  public static readonly SELECTED_FONT_WEIGHT: number = 500;
  // tabBar未选中时的字体粗细
  public static readonly NOT_SELECTED_FONT_WEIGHT: number = 400;
  // 首页index
  public static readonly TAB_BAR_HOME_INDEX: number = 0;
  // 排行index
  public static readonly TAB_BAR_RANK_INDEX: number = 1;
  // 我的index
  public static readonly TAB_BAR_USER_INDEX: number = 2;
  // 动画进度30%
  public static readonly ANIMATION_PROGRESS: number = 0.3;
  // 动画进度5%
  public static readonly PROGRESS_PERCENTAGE_FIVE: number = 0.05;
  // 全屏播放页动画进度5%时要达到的透明度
  public static readonly DETAILS_PAGE_INTERIM_OPACITY: number = 0.5;
}