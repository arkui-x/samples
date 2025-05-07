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

export class Constants {
  // font family
  static readonly HARMONY_HEI_TI_FONT_FAMILY = 'HarmonyHeiTi';
  static readonly HARMONY_HEI_TI_MEDIUM_FONT_FAMILY = 'HarmonyHeiTi-Medium';
  static readonly HARMONY_HEI_TI_BOLD_FONT_FAMILY = 'HarmonyHeiTi-Bold';
  // StatusBarContentColor
  static readonly StatusBarContentWhiteColor: string = '#ffffff';
  static readonly StatusBarContentBlackColor: string = '#000000';
  // list上部的标题高度
  static readonly LIST_HEADER_HEIGHT: number = 60;
  // 页面状态栏标题高度
  static readonly PAGE_HEADER_HEIGHT: number = 62;
  // opacity
  static readonly FIRST_LEVEL_OPACITY: number = 0.9;
  static readonly SECOND_LEVEL_OPACITY: number = 0.6;
  static readonly HALF_OPACITY: number = 0.5;
  static readonly NAVIGATION_BAR_OPACITY_MAX: number = 1;
  // percent
  static readonly FULL_PERCENT: string = '100%';
  static readonly BANNER_HEIGHT_PERCENT: string = '35%';
  // zIndex
  static readonly Z_INDEX_ONE: number = 1;
  static readonly Z_INDEX_TWO: number = 2;
  static readonly Z_INDEX_THREE: number = 3;
  // aspectRatio
  static readonly ASPECT_RATIO_ONE: number = 1;
  static readonly ASPECT_RATIO_SECOND: number = 1.6;
  // duration
  static readonly ANIMATION_DURATION: number = 150;
  static readonly ANIMATION_DURATION1: number = 200;
  static readonly ANIMATION_DURATION2: number = 300;
  // offset
  static readonly MAIN_SCROLLER_OFFSET_X: number = 0;
  static readonly MAIN_SCROLLER_OFFSET_Y: number = 0;
  static readonly MAIN_SCROLLER_OFFSET_Y_ZERO: number = 0;
  static readonly MAIN_SCROLLER_OFFSET_Y_MAX: number = 54;
  static readonly MAIN_SCROLLER_OFFSET_STATUS_CHANGE: number = 24;
  // postion
  static readonly FAVOR_POSITION_X: number = 0;
  static readonly HIGHLIGHT_POSITION_X: number = 0;
  static readonly HIGHLIGHT_POSITION_X2: number = 40;
  static readonly COLLECTED_POSITION_X: number = 0;
  static readonly COLLECTED_POSITION_X2: number = 80;
  static readonly SEARCH_POSITION_RIGHT: number = 0;
  // layoutWeight
  static readonly LAYOUT_WEIGHT: number = 1;
  // borderRadius
  static readonly SEARCH_BORDER_RADIUS1: number = 5;
  static readonly SEARCH_BORDER_RADIUS2: number = 17;
  static readonly SHARE_BORDER_RADIUS: number = 15;
  static readonly SCAN_BORDER_RADIUS: number = 15;
  static readonly SETTING_BORDER_RADIUS: number = 15;
  static readonly TYPE_BORDER_RADIUS: number = 4;
  static readonly ITEM_BORDER_RADIUS: number = 8;
  static readonly ITEM_IMAGE_BORDER_RADIUS: number = 8;
  // space
  static readonly TOOL_VIEW_SPACE: number = 10;
  static readonly ARTICLES_LIST_SPACE: number = 10;
  static readonly ARTICLES_LABEL_SPACE: number = 12;
  // status-navigationBarHeight
  static readonly NAVIGATION_BAR_HEIGHT: number = 44;
  static readonly STATUS_BAR_HEIGHT: number = 54;
  // linearGradientSet
  static readonly LIST_LINEAR_GRADIENT_START: number = 0.0;
  static readonly LIST_LINEAR_GRADIENT_END: number = 0.1;
  static readonly LIST_LINEAR_GRADIENT_START_COLOR: string = '#FF0091FF';
  static readonly LIST_LINEAR_GRADIENT_END_COLOR: string = '#FFF1F3F5';
  static readonly ITEM_LINEAR_GRADIENT_ANGLE: string = '90';
  static readonly ITEM_LINEAR_GRADIENT_START: number = 0;
  static readonly ITEM_LINEAR_GRADIENT_END: number = 1;
  static readonly ITEM_LINEAR_GRADIENT_START_COLOR: string = '#FFDCEAF9';
  static readonly ITEM_LINEAR_GRADIENT_END_COLOR: string = '#FFF1F3F5';
  // maxLines
  static readonly MAX_LINES_ONE: number = 1;
  static readonly MAX_LINES_TWO: number = 2;
  // cachedCount
  static readonly CACHE_COUNT: number = 2;
}