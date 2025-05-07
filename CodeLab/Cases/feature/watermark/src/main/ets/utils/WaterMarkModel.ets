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

import { image } from "@kit.ImageKit";
import { TextModify } from "../model/DataType";
import { CommonConstants } from '../common/CommonConstants';

/**
 * 水印类
 */
export class WaterMarkModel {
  /**
   * 图片添加水印。通过OffscreenCanvas绘制水印，并生成一个新的pixelMap对象进行保存
   * @param {image.PixelMap} pixelMap - 原图pixelMap数据
   * @param {Size} imageInfo - 图片尺寸
   * @param {TextModify} textModify - 水印文本属性
   * @returns {image.PixelMap} 返回带水印pixelMap数据
   */
  async addImageWaterMark(pixelMap: image.PixelMap, imageInfo: Size, textModify: TextModify) {
    // TODO:知识点:通过OffscreenCanvasRenderingContext2D绘制水印
    const offScreenCanvas = new OffscreenCanvas(imageInfo.width, imageInfo.height);
    const offScreenContext: OffscreenCanvasRenderingContext2D = offScreenCanvas.getContext('2d');
    offScreenContext.drawImage(pixelMap, 0, 0, offScreenCanvas.width, offScreenCanvas.height);
    offScreenContext.textAlign = textModify.textAlign;
    offScreenContext.textBaseline = textModify.textBaseline;
    offScreenContext.fillStyle = textModify.fontColor;
    // 设置字体大小
    offScreenContext.font = textModify.fontSize;
    // 添加文字阴影
    offScreenContext.shadowBlur = CommonConstants.TEXT_SHADOW_BLUE;
    offScreenContext.shadowColor = CommonConstants.TEXT_SHADOW_COLOR;
    // 绘制文本
    offScreenContext.fillText(textModify.text, textModify.offsetX,
      textModify.offsetY);
    let lastPixelMap: image.PixelMap =
      offScreenContext.getPixelMap(0, 0, offScreenCanvas.width, offScreenCanvas.height);
    return lastPixelMap;
  }
}