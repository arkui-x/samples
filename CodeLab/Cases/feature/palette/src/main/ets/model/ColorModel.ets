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
 * 表示 RGB 颜色模型的类。
 *
 * RGB 颜色模型由红色、绿色和蓝色三种颜色组成。
 * 每种颜色的值范围为 0 到 255。
 */
export class RgbType {
  /** 红色分量，范围为 0-255。默认为 0。 */
  red: number = 0;
  /** 绿色分量，范围为 0-255。默认为 0。 */
  green: number = 0;
  /** 蓝色分量，范围为 0-255。默认为 0。 */
  blue: number = 0;
}

/**
 * 表示 HSL 颜色模型的类。
 *
 * HSL 颜色模型由色相、饱和度和亮度三种属性组成。
 * 色相的范围为 0 到 360，饱和度和亮度的范围为 0 到 100。
 */
export class HslType {
  /** 色相，范围为 0-360。默认为 0。 */
  hue: number = 0;
  /** 饱和度，范围为 0-100。默认为 0。 */
  saturation: number = 0;
  /** 亮度，范围为 0-100。默认为 0。 */
  lightness: number = 0;
}