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
 * 轮播图数据类
 */
export class DataType {
  id: string;
  source: Resource;
  type: string = 'image';

  constructor(id: string, source: Resource) {
    this.id = id;
    this.source = source;
  }
}

export class ImageDataType extends DataType {
  constructor(id: string, source: Resource) {
    super(id, source);
  }
}

export class VideoDataType extends DataType {
  constructor(id: string, source: Resource) {
    super(id, source);
    this.type = 'video';
  }
}

/**
 * 功能数据类
 */
export class FeatureDataType {
  image: Resource;
  text: ResourceStr;

  constructor(image: Resource, text: ResourceStr) {
    this.image = image;
    this.text = text;
  }
}

/**
 * 水印文本属性
 * @param {string} text - 内容
 * @param {string} [fontSize] - 字体大小
 * @param {string} [fontColor] - 字体颜色
 * @param {CanvasTextAlign} [textAlign] - 文本绘制中的文本对齐方式
 * @param {CanvasTextBaseline} [textBaseline] - 设置文本沿水平方向的对齐方式
 * @param {number} [offsetY] - 需要绘制的文本的左下角x坐标（图片添加水印方式中引用）
 * @param {number} [offsetX] - 需要绘制的文本的左下角y坐标（图片添加水印方式中引用）
 */
export class TextModify {
  text: string;
  fontSize: string;
  fontColor: string;
  textAlign: CanvasTextAlign;
  textBaseline: CanvasTextBaseline;
  offsetX: number;
  offsetY: number;

  constructor(text: string, fontSize: string = '16vp', fontColor: string = '#000', textAlign: CanvasTextAlign = 'center',
    textBaseline: CanvasTextBaseline = 'middle',
    offsetX: number = 0, offsetY: number = 0) {
    this.text = text;
    this.fontSize = fontSize;
    this.fontColor = fontColor;
    this.textAlign = textAlign ;
    this.textBaseline = textBaseline;
    this.offsetX = offsetX;
    this.offsetY = offsetY;
  }
}