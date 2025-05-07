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
  static readonly STROKE_WIDTH: number = 1; // tabbar分割线线宽
  static readonly VIDEO_HEIGHT: number = 160; // 视频高度
  static readonly VIDEO_CARD_MARGIN_TOP: number = 16; // 视频卡片上边距
  static readonly NEWS_NAME_PADDING: number = 32; // 新闻标题上下内边距
  static readonly SECONDS_PER_MINUTE: number = 60; // 一分钟的秒数
  static readonly NEWS_LIST_SCROLL_TO_INDEX: number = 3; // 新闻列表切换选中项后的默认滚动位置在列表显示区域所处的下标
  static readonly NEWS_LIST_ITEM_HEIGHT: number = 40; // 新闻列表项高度
  static readonly MAX_LINES: number = 1; // Text最大行数
  static readonly LAYOUT_WEIGHT: number = 1; // Flex布局，自动分配剩余空间
}