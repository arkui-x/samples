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
  static readonly PEN_STROKE_WIDTH: number = 10; // 画笔线宽
  static readonly GRADIENT_LEVELS: number = 9; // 渐变色阶数
  static readonly GRADIENT_START_POINT: number = 30; // 渐变开始点的亮度值
  static readonly GRADIENT_END_POINT: number = 90; // 渐变结束点的亮度值
  static readonly DIVIDER_STROKE_WIDTH: number = 1; // 分割线宽度
  static readonly GRID_TEMPLATE_UINT: string = '1fr'; // Gird 行列等分后的一份
  // 组件id
  static readonly CONTAINER_ID: string = '__container__'; // 相对容器布局时父容器默认id
  static readonly TOP_BUTTON_LINE_ID: string = 'topButtonLine'; // 页面顶部按钮容器id
  static readonly BOTTOM_PEN_SHAPE_ID: string = 'bottomPenShape'; // 页面底部涂鸦组件id
}