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

import { HslType, RgbType } from '../model/ColorModel';

/**
 * 将 HSL 颜色模型转换为 HEX 颜色模型
 *
 * @param {number} hue - 色相 (Hue)，范围为 0 到 360
 * @param {number} saturation - 饱和度 (Saturation)，范围为 0 到 100
 * @param {number} lightness - 亮度 (Lightness)，范围为 0 到 100
 * @returns {string} - 返回 HEX 颜色值，格式为 '#RRGGBB'
 */
export function hslToHex(hue: number, saturation: number, lightness: number): string {
  // 将 HSL 转换为 RGB
  const rgb: RgbType = hslToRgb(hue, saturation, lightness);
  // 返回 HEX 颜色值
  return rgbToHex(rgb.red, rgb.green, rgb.blue);
}

/**
 * 将 HSL 颜色值转换为 RGB 颜色格式。
 *
 * @param {number} hue - 色相，范围为 0-360。
 * @param {number} saturation - 饱和度，范围为 0-100，表示颜色的强度。
 * @param {number} lightness - 亮度，范围为 0-100，表示颜色的明暗程度。
 * @returns {rgbType} - 返回一个包含 RGB 值的对象，格式为 { red, green, blue }，每个值的范围为 0-255。
 */
function hslToRgb(hue: number, saturation: number, lightness: number): RgbType {
  let red: number, green: number, blue: number;

  // 将饱和度和亮度从百分比转换为小数
  saturation /= 100;
  lightness /= 100;

  if (saturation === 0) {
    // 无饱和度，返回灰色
    red = Math.round(lightness * 255); // 灰色的 Red 值
    green = Math.round(lightness * 255); // 灰色的 Green 值
    blue = Math.round(lightness * 255); // 灰色的 Blue 值
  } else {
    // 辅助函数：根据 HSL 值计算 RGB 值，处理不同的色相区间
    const convertHueToRgb = (baseValue: number, brightnessMultiplier: number, hueFraction: number): number => {
      // 确保 hueFraction 在 0 到 1 之间
      if (hueFraction < 0) {
        hueFraction += 1;
      }
      if (hueFraction > 1) {
        hueFraction -= 1;
      }
      // 第一个区间
      if (hueFraction < 1 / 6) {
        return baseValue + (brightnessMultiplier - baseValue) * 6 * hueFraction;
      }
      // 第二个区间
      if (hueFraction < 1 / 2) {
        return brightnessMultiplier;
      }
      // 第三个区间
      if (hueFraction < 2 / 3) {
        return baseValue + (brightnessMultiplier - baseValue) * (2 / 3 - hueFraction) * 6;
      }
      // 第四个区间
      return baseValue;
    };

    // 根据亮度计算中间值 brightnessMultiplier 和 baseValue
    const brightnessMultiplier = lightness < 0.5 ? lightness * (1 + saturation) : lightness + saturation - lightness * saturation;
    const baseValue = 2 * lightness - brightnessMultiplier;

    // 计算 RGB 值
    red = Math.round(convertHueToRgb(baseValue, brightnessMultiplier, hue / 360 + 1 / 3) * 255);
    green = Math.round(convertHueToRgb(baseValue, brightnessMultiplier, hue / 360) * 255);
    blue = Math.round(convertHueToRgb(baseValue, brightnessMultiplier, hue / 360 - 1 / 3) * 255);
  }
  return {
    red: red,
    green: green,
    blue: blue
  }
}

/**
 * 将 RGB 颜色值转换为十六进制格式。
 *
 * @param {number} red - 红色分量，范围为 0-255。
 * @param {number} green - 绿色分量，范围为 0-255。
 * @param {number} blue - 蓝色分量，范围为 0-255。
 * @returns {string} - 返回表示 RGB 颜色的十六进制字符串，格式为 "#RRGGBB"。
 */
function rgbToHex(red: number, green: number, blue: number): string {
  return '#' + ((1 << 24) + (red << 16) + (green << 8) + blue).toString(16).slice(1);
}

/**
 * 将十六进制颜色值转换为 HSL 颜色格式。
 *
 * @param {string} hex - 输入的十六进制颜色字符串，可以是格式如 #RRGGBB 或 #RGB。
 * @returns { HslType | null} - 返回一个包含 HSL 值的数组，或者在输入无效时返回 null。
 */
export function hexToHsl(hex: string): HslType | null {
  // 将 HEX 类型颜色转为 RGB 类型
  let rgb = hexToRgb(hex);
  if (rgb === null) {
    return null;
  }
  // 将 RGB 类型颜色转为 HSL 类型
  return rgbToHsl(rgb.red, rgb.green, rgb.blue);
}

/**
 * 将十六进制颜色字符串转换为 RGB 对象。
 *
 * @param {string} hex - 十六进制颜色字符串，可以以 "#" 开头或不带 "#"。
 * @returns {RgbType | null} - 返回一个 RgbType 对象，如果输入无效则返回 null。
 */
export function hexToRgb(hex: string): RgbType | null {
  // 使用正则表达式匹配十六进制颜色字符串
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  if (result) {
    // 将匹配的十六进制值转换为十进制 RGB 值
    return {
      red: parseInt(result[1], 16),
      green: parseInt(result[2], 16),
      blue: parseInt(result[3], 16)
    }
  } else {
    // 如果输入无效，返回 null
    return null;
  }
}

/**
 * 将 RGB 颜色值转换为 HSL 颜色对象。
 *
 * @param {number} red - 红色分量，范围为 0-255。
 * @param {number} green - 绿色分量，范围为 0-255。
 * @param {number} blue - 蓝色分量，范围为 0-255。
 * @returns {HslType} - 返回一个 HslType 对象，包含色相、饱和度和亮度。
 */
function rgbToHsl(red: number, green: number, blue: number): HslType {
  // 将 RGB 值归一化到 0-1 范围
  red /= 255;
  green /= 255;
  blue /= 255;

  // 计算最大值和最小值
  let max = Math.max(red, green, blue);
  let min = Math.min(red, green, blue);

  // 计算亮度 lightness
  let hue: number = (max + min) / 2;
  let saturation: number = (max + min) / 2;
  let lightness: number = (max + min) / 2;

  if (max === min) {
    // 如果最大值和最小值相等，色相和饱和度为 0
    hue = 0;
    saturation = 0;
  } else {
    let difference = max - min; // 计算色差

    // 计算饱和度 saturation
    saturation = lightness > 0.5 ? difference / (2 - max - min) : difference / (max + min);

    // 计算色相 hue
    if (max === red) {
      hue = (green - blue) / difference + (green < blue ? 6 : 0);
    } else if (max === green) {
      hue = (blue - red) / difference + 2;
    } else {
      hue = (red - green) / difference + 4;
    }
    hue *= 60; // 将色相转换为度数
  }

  // 返回 HSL 值，四舍五入后返回
  return { hue: Math.round(hue), saturation: Math.round(saturation * 100), lightness: Math.round(lightness * 100) };
}