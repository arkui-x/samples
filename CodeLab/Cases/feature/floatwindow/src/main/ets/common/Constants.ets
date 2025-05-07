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
  static readonly PAGE_PADDING: number = 12; // 页面内容内边距，用于悬浮窗位置计算
  static readonly ASPECT_RATIO: number = 1; // 图标宽高比
  static readonly PRODUCT_SERVICE_SPACE: number = 16; // 商品服务项间距
  static readonly FLOAT_WINDOW_WIDTH: number = 120; // 悬浮窗宽度
  static readonly FLOAT_WINDOW_HEIGHT: number = 160; // 悬浮窗高度
  static readonly INIT_POSITION_Y: number = 300; // 悬浮窗相对父容器左上角的Y坐标初始值
  static readonly FLEX_SHRINK: number = 1;
  static readonly FLEX_GROW: number = 1;
  static readonly LAYOUT_WEIGHT: number = 1;
}