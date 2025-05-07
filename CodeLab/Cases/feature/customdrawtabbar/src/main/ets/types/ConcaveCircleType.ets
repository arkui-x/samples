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
 * canvas 底下矩形
 */
export interface CanvasCreateRectangleType {
  // CanvasRenderingContext2D 控制器
  context: CanvasRenderingContext2D,

  // 整个 tabs 所占据的高度
  tabsBgColor: string,

  /**
   * 左上和右上 是否有倒角  默认没有
   * - 暂时在 canvas 绘制时没有使用
   * - 如果需要可以在 [CanvasCreateRectangle](../Utils/Functions/CanvasCreateRectangle) 方法中使用，给左上角和右上角倒角
   */
  chamfer?: number
}

/**
 * canvas 中的 凹槽
 */
export interface CanvasClipGrooveType extends Omit<CanvasCreateRectangleType, "tabsBgColor"> {
  // 菜单数量
  menuLength: number,

  // 凹槽中心点
  center?: number
}
