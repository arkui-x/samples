/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 * 文本展开视图模型
 * @param {ResourceStr} title - 文本内容
 * @param {boolean} needProcess - 是否展示展开收起按钮
 * @param {exceedOneLine} boolean - 加上'收起'二字时超过一行需要换行
 */
export class TextExpandModel {
  title: ResourceStr = '';
  needProcess: boolean = true;
  exceedOneLine: boolean = false;
}

/**
 * 文本章节属性
 *
 * @param {ResourceStr} title - 文本内容
 * @param {number} {maxLines} - 设置文本的最大行数
 * @param {ResourceStr} {fontColor} - 文本颜色
 * @param { Resource | number | string} {fontSize} - 文本大小
 * @param {number} lineHeight - 行高
 * @param {Resource | number | string} contraintWidth - 设置文本的行所占最大宽度
 */

export class TextSectionAttribute {
  title: ResourceStr = '';
  maxLines: number;
  fontColor: ResourceStr;
  fontSize: Resource | number | string;
  lineHeight: number;
  constraintWidth: Resource | number | string;

  constructor(title: ResourceStr = '', maxLines: number = 2, fontColor: ResourceStr = '#000',
    fontSize: Resource | number | string = '16vp', lineHeight: number = 16,
    constraintWidth: Resource | number | string = 350) {
    this.title = title;
    this.maxLines = maxLines;
    this.fontColor = fontColor;
    this.fontSize = fontSize;
    this.lineHeight = lineHeight;
    this.constraintWidth = constraintWidth;
  }
}

/**
 * 控制文本折叠的文本或者图片属性
 *
 * @param {number} lastSpanType - 类型(0为文本，1为图片)
 * @param {number} charactersNumber - 折叠文本或者图片所占字符个数
 * @param {ResourceStr[]} -文本或者图片内容
 * @param {size} 文本或者图片大小
 * @param {color} 文本颜色
 */
export class LastSpanAttribute {
  lastSpanType: number;
  charactersNumber: number;
  content: ResourceStr[];
  size: ResourceStr | number;
  color: ResourceStr | Color;

  constructor(lastSpanType: number, charactersNumber: number = 1,
    content: ResourceStr[], size: ResourceStr | number, color: ResourceStr | Color = Color.Orange) {
    this.lastSpanType = lastSpanType;
    this.charactersNumber = charactersNumber;
    this.content = content;
    this.size = size;
    this.color = color;
  }
}


