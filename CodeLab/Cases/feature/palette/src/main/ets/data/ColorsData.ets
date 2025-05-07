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

import { HslType } from '../model/ColorModel';

// 常用色相数据（HEX格式）
export const HEX_HUES_DATA: string[] = [
  '#E84026',
  '#ED6F21',
  '#F9A01E',
  '#F7CE00',
  '#A5D61D',
  '#64BB5C',
  '#61CFBE',
  '#46B1E3',
  '#564AF7',
  '#AC49F5',
  '#E64566',
  '#000000'
];

// 渐变基本色相数据（HSL格式）
export const HSL_HUES_DATA: HslType[] = [
  { hue: 359, saturation: 71, lightness: 37 },
  { hue: 27, saturation: 99, lightness: 32 },
  { hue: 36, saturation: 100, lightness: 32 },
  { hue: 45, saturation: 100, lightness: 32 },
  { hue: 81, saturation: 100, lightness: 27 },
  { hue: 119, saturation: 49, lightness: 34 },
  { hue: 184, saturation: 100, lightness: 25 },
  { hue: 197, saturation: 100, lightness: 30 },
  { hue: 210, saturation: 100, lightness: 32 },
  { hue: 232, saturation: 57, lightness: 37 },
  { hue: 271, saturation: 68, lightness: 34 },
  { hue: 328, saturation: 100, lightness: 29 },
  { hue: 0, saturation: 0, lightness: 0 }
];