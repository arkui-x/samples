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
  // default icon
  static readonly DEFAULT_ICON = $r('app.media.custom_tab_default_icon')
  // tab标题
  static readonly DEFAULT_TITLE1_TAB = "标题1";
  // tab标题
  static readonly DEFAULT_TITLE2_TAB = "标题2";
  // tab标题
  static readonly DEFAULT_TITLE3_TAB = "标题3";
  // tab标题
  static readonly DEFAULT_TITLE4_TAB = "标题4";
  // 默认页签文本颜色
  static readonly DEFAULT_TITLE_FONT_COLOR = "#6D7278";
  // 被选中页签文本颜色
  static readonly SELECTED_TITLE_FONT_COLOR = "#0091FF";
  // 初始化社区的tab下标
  static readonly COMMUNITY_TAB_BAR_INDEX: number = 2;
  // 圆弧的上外间距为-15
  static readonly ARC_MARGIN_TOP: number = -15;
  // 自定义tab动画时长
  static readonly CUSTOM_ANIMATION_DURATION: number = 400;
  // 动画播放次数
  static readonly CUSTOM_ANIMATION_ITERATIONS: number = 1;
}