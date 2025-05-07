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
 * Span类型枚举
 */
export enum SpanType {
  IMAGE, // 图片
  TEXT, // 文字
}

/**
 * 表情对话框参数配置
 */
export class FaceGridConstants {
  static readonly EMOJI_IMAGE_SIZE: number = 28; // 表情图片大小
  static readonly GRID_MAX_COUNT: number = 6; // 一行最大item数量
  static readonly ROWS_GAP: number = 20; // 行距
  static readonly GRID_HEIGHT: number = 288; // 高度
  static readonly EMOJI_MARGIN: number = 2; // 表情之间间距
}