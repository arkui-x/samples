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

export default class Const {
  // 示例图片间距
  public static readonly EXAMPLE_IMAGE_GAP: number = 10;
  // 示例图片数量
  public static readonly ITEM_COUNT: number = 6;
  // 动画时长
  public static readonly DURATION: number = 220;
  // 边缘渐变起始和终止颜色
  public static readonly BEGIN_COLOR: string = '#00ffffff';
  public static readonly END_COLOR: string = '#ffffffff';
  // 根容器组件默认间距
  public static readonly ROOT_GAP: number = 20;
  // 顶部菜单栏间距
  public static readonly MENU_ITEM_SPACE: number = 5;
  // 顶部菜单栏Item中文字与图片间距
  public static readonly MENU_ITEM_COL_SPACE: number = 5;
  // 渐变角度
  public static readonly OVERLAY_LINEAR_GRADIENT_ANGLE: number = 90;
  // 渐变颜色位置
  public static readonly OVERLAY_LINEAR_GRADIENT_COLOR_POS: number[] = [0.0, 0.15, 0.85, 1.0];
  // tosat提示框持续时间
  public static readonly PROMPT_TOAST_DURATION: number = 1200;
}