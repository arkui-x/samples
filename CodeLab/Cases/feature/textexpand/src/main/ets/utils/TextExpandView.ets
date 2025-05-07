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

import { MeasureText } from "@kit.ArkUI";
import { TextUtils } from "./TextUtils";
import { LastSpanAttribute, TextExpandModel, TextSectionAttribute } from "./Model";

const MEASURE_ELLIPSIS: string = '...'; // 省略符

/**
 * 功能描述：
 * 1. 点击"展开"按钮文本展开，点击"收起"按钮，文本收起。
 *
 *
 * 实现原理：
 * 1. 使用measure.measureTextSize方法来判断总体文字的高度
 * 2. 使用measure.measureTextSize方法来判断两行文字的高度，当前为两行文字的高度
 * 3. 减少接收文字字符数。当接收文字高度小于指定行数高度时，使文字显示两行，达到实现收起状态的目的。否则继续计算直到小于指定行数的高度
 *
 * @param {ResourceStr} rawTitle - 初始化文本内容
 * @param {TextSectionAttribute} textSectionAttribute - 文本章节属性类
 * @param {LastSpanAttribute} lastSpanAttribute - 控制文本折叠的文本或者图片属性
 *
 */


@Component
export struct TextExpandView {
  // ---------------对外暴露变量--------------------
  // 文本章节属性类
  textSectionAttribute: TextSectionAttribute = new TextSectionAttribute();
  // 控制文本折叠的文本或者图片属性
  @Prop lastSpanAttribute: LastSpanAttribute;
  // ----------------私有变量----------------------
  // 是否展开
  @State expanded: boolean = true;
  // 文本展开属性
  @State textModifier: TextExpandModel = new TextExpandModel();
  // 末尾文本代替内容(根据charactersNumber来生成文本，用来计算文本占用宽度)
  private lastSpan: string = '';

  aboutToAppear(): void {
    let titleSize: SizeOptions = MeasureText.measureTextSize({
      textContent: this.textSectionAttribute.title, // 被计算文本内容
      lineHeight: this.textSectionAttribute.lineHeight,
      constraintWidth: this.textSectionAttribute.constraintWidth, // 被计算文本布局宽度
      fontSize: this.textSectionAttribute.fontSize // 被计算文本字体大小
    })
    let height = px2vp(Number(titleSize.height));
    if (height <= this.textSectionAttribute.lineHeight * 2) {
      this.textModifier.needProcess = false;
      this.textModifier.title = this.textSectionAttribute.title;
      return;
    } else {
      this.textModifier.needProcess = true;
    }
    for (let index = 0; index < this.lastSpanAttribute.charactersNumber; index++) {
      this.lastSpan += '的'
    }
    this.process();
  }

  build() {
    Column() {
      if (this.lastSpanAttribute.lastSpanType === 0) {
        this.lastSpanBuilder();
      } else {
        this.lastSpanWithIconBuilder();

      }
    }
    .onClick(() => {
      if (!this.textModifier.needProcess) {
        return;
      }
      this.process();
    })
    .margin({
      left: $r('app.integer.text_expand_item_main_body_column_margin'),
      bottom: $r('app.integer.text_expand_item_main_body_column_margin'),
      right: $r('app.integer.text_expand_item_main_body_column_margin')
    })

  }

  process(): void {
    // TODO：知识点：使用 measure.measureTextSize 方法计算全部文字占用的高度
    if (this.expanded) {
      this.collapseText();
    } else {
      this.expandText();
    }
  }

  // 展开文字
  expandText(): void {
    if (this.textModifier.needProcess) {
      this.textModifier.title = this.textSectionAttribute.title;
      this.expanded = true;
      this.textModifier.exceedOneLine = true;
    }
  }

  // 收起文字
  collapseText(): void {
    if (!this.textModifier.needProcess) {
      return;
    }
    this.textModifier.title =
      TextUtils.getShortText(TextUtils.getStringFromResource(this.textSectionAttribute.title),
        this.textSectionAttribute.fontSize,
        this.textSectionAttribute.maxLines,
        this.textSectionAttribute.constraintWidth, MEASURE_ELLIPSIS, `${this.lastSpan}`);
    this.textModifier.exceedOneLine = false;
    this.expanded = false;
  }

  @Builder
  lastSpanBuilder() {
    Text() {
      Span(this.textModifier.title)
      if (this.textModifier.needProcess && !this.textModifier.exceedOneLine) {
        Span(this.lastSpanAttribute.content[0])
          .fontColor(this.lastSpanAttribute.color)
      }
    }
    .fontSize(this.lastSpanAttribute.size)
    .width(this.textSectionAttribute.constraintWidth)
    .lineHeight(this.textSectionAttribute.lineHeight)

    if (this.textModifier.exceedOneLine) {
      Text(this.lastSpanAttribute.content[1])
        .fontSize(this.lastSpanAttribute.size)
        .width(this.textSectionAttribute.constraintWidth)
        .fontColor(this.lastSpanAttribute.color)
        .textAlign(TextAlign.End)
        .lineHeight(this.textSectionAttribute.lineHeight)
    }
  }

  @Builder
  lastSpanWithIconBuilder() {
    Text() {
      Span(this.textModifier.title)
      if (this.textModifier.needProcess && !this.textModifier.exceedOneLine) {
        ImageSpan(this.lastSpanAttribute.content[0])
          .width(this.lastSpanAttribute.size)
          .aspectRatio(1)
      }
      if (this.textModifier.exceedOneLine) {
        ImageSpan(this.lastSpanAttribute.content[1])
          .width(this.lastSpanAttribute.size)
          .aspectRatio(1)
      }
    }
    .fontSize(this.lastSpanAttribute.size)
    .width(this.textSectionAttribute.constraintWidth)
    .lineHeight(this.textSectionAttribute.lineHeight)
  }
}

