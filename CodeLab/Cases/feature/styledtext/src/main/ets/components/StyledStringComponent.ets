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

import { MyCustomSpan, MyCustomSpanType } from '../model/TextModel';
import { image } from '@kit.ImageKit';

/**
 * 功能描述: 使用属性字符串灵活设置文本样式，实现多行文本中部分文本高亮和超链接的效果，并允许用户点击超链接或视频链接触发相应的交互行为。
 *
 * 实现原理：
 * 1. 使用 `MyCustomSpan[]` 类型的数组 `spans` 作为数据源，每个 `MyCustomSpan` 对象代表一个文本片段，包含类型（普通文本、超链接、视频链接等）和内容。
 * 2. 遍历 `spans` 数组，为每个 `span` 创建属性字符串对象，然后根据不同的Span类型为属性字符串对象添加相应的样式和手势，如果字符长度超过限制需要在末尾添加“...全文”，创建好的属性字符串放入数组styledStrings保存。
 * 3. 对于超链接和视频链接，属性字符串设置点击手势，通过回调函数 `linkClickCallback` 处理用户的点击事件，触发不同的交互行为。
 * 4. 将数组styledStrings中的属性字符串按顺序拼接到属性字符串paragraphStyledString上。
 * 5. Text组件挂载完成后通过TextController控制器将拼接完成的属性字符串绑定到Text组件上展示出来。
 *
 * @param {MyCustomSpan[]} [spans] - 包含不同类型文本片段的数组（如普通文本、超链接等）。
 * @param {number} [maxStringLength] - 正文内容最大字符长度，默认值为140。
 * @param {string | number | Resource} [defaultFontSize] - 正文内容字体大小，默认14fp。
 * @param {ResourceColor} [defaultFontColor] - 正文内容字体颜色。
 * @param {TextStyle} [textAttribute] - 超链接字体样式。
 * @param {image.PixelMap | undefined} [videoLinkIcon] - 视频超链接图标的PixelMap。
 * @param {(span: MyCustomSpan) => void} [linkClickCallback] - 链接点击回调函数，在用户点击链接时调用。
 */

@Component
export struct StyledStringComponent {
  // -------------------对外暴露变量-----------------------
  maxStringLength: number = 140; // 正文内容最大字符长度，默认值140
  spans: MyCustomSpan[] = []; // 自定义span列表数据
  defaultFontSize: string | number | Resource = $r('app.string.styled_text_font_size_default'); // 正文内容字体大小
  defaultFontColor: ResourceColor = Color.Black; // 正文内容字体颜色
  textAttribute: TextStyle = new TextStyle({ fontColor: $r('app.color.styled_text_link_font_color') }); // 高亮文本样式
  imagePixelMap: image.PixelMap | undefined; // 视频链接图标的pixelMap
  linkClickCallback?: (span: MyCustomSpan) => void; // 超链接点击回调

  // --------------------私有属性----------------------------
  private controller: TextController = new TextController(); // 文本控制器
  private styledStrings: MutableStyledString[] = []; // 正文处理完成后的属性字符串数组
  private paragraphStyledString: MutableStyledString = new MutableStyledString('', []); // 拼接完成进行展示的属性字符串

  aboutToAppear(): void {
    // 处理文本
    this.handleStyledString();
  }

  aboutToReuse(params: Record<string, MyCustomSpan[]>): void {
    this.spans = params.spans;
    this.handleStyledString();
    this.controller.setStyledString(this.paragraphStyledString);
  }

  /**
   * 将文本处理成最终展示的属性字符串
   */
  handleStyledString() {
    this.paragraphStyledString = new MutableStyledString('', []);
    // 处理自定义span列表数据，生成属性字符串数组
    this.styledStrings = this.processCustomSpans(this.spans);
    // 将每个文本片段生成的属性字符串追加到属性字符串paragraphStyledString中
    this.styledStrings.forEach((mutableStyledString: MutableStyledString, index: number) => {
      this.paragraphStyledString.appendStyledString(mutableStyledString);
    })
  }

  /**
   * 处理自定义span列表数据，生成属性字符串数组
   * @param {MyCustomSpan[]} spans - 包含不同类型文本片段的数组（如普通文本、链接等）
   * @returns {MutableStyledString[]} - 生成的属性字符串数组
   */
  processCustomSpans(spans: MyCustomSpan[]): MutableStyledString[] {
    let charCount = 0; // 遍历拼接customMessage.spans，记录已拼接的字符串长度
    const styledStrings: MutableStyledString[] = []; // 已生成的属性字符串数组

    spans.forEach((span, index) => {
      // 如果当前累积字符数已经达到最大允许长度，则停止处理后续文本片段
      if (charCount >= this.maxStringLength) {
        return;
      }
      // 判断添加当前文本片段后是否超过最大允许长度
      // TODO：知识点：遍历消息片段并检查字符长度，为每个片段创建MutableStyledString对象，添加对应样式和手势
      if (charCount + span.content.length >= this.maxStringLength) {
        this.handleExceedingSize(span, charCount, styledStrings);
      } else {
        this.processWithinSize(span, styledStrings);
      }
      charCount += span.content.length;
    })
    return styledStrings;
  }

  /**
   * 处理字符数超过指定字符长度的情况，末尾添加“...全文”
   * @param {MyCustomSpan} span - 自定义文本片段，包含文本类型和内容
   * @param {number} charCount - 当前已拼接的字符长度
   * @param {MutableStyledString[]} styledStrings - 生成的属性字符串数组
   */
  handleExceedingSize(span: MyCustomSpan, charCount: number, styledStrings: MutableStyledString[]) {
    const ELLIPSIS: string = '...';
    const FULL_TEXT: string = '全文';
    // 检查文本片段的类型，决定如何处理超出部分
    if (span.type === MyCustomSpanType.Normal) {
      // 如果是普通文本，则截断并拼接 ...全文
      styledStrings.push(new MutableStyledString(`${span.content.substring(0,
        this.maxStringLength - charCount)}${ELLIPSIS}${FULL_TEXT}`, [
        {
          start: this.maxStringLength - charCount + ELLIPSIS.length,
          length: FULL_TEXT.length,
          styledKey: StyledStringKey.FONT,
          styledValue: this.textAttribute
        },
        {
          start: this.maxStringLength - charCount + ELLIPSIS.length,
          length: FULL_TEXT.length,
          styledKey: StyledStringKey.GESTURE,
          styledValue: this.generateClickStyle(span)
        }]));
    } else {
      // 对于链接类型，不截断直接拼接 ...全文，如果视频链接图标的pixelMap已存在，在对应类型的链接前添加图片类型的属性字符串
      if (span.type === MyCustomSpanType.VideoLink && this.imagePixelMap !== undefined) {
        styledStrings.push(new MutableStyledString(new ImageAttachment({
          value: this.imagePixelMap,
          size: {
            width: $r('app.integer.styled_text_video_link_icon_size'),
            height: $r('app.integer.styled_text_video_link_icon_size')
          },
          verticalAlign: ImageSpanAlignment.CENTER,
          objectFit: ImageFit.Contain
        })));
      }
      styledStrings.push(new MutableStyledString(`${span.content}${ELLIPSIS}${FULL_TEXT}`, [
        {
          start: 0,
          length: span.content.length,
          styledKey: StyledStringKey.FONT,
          styledValue: this.textAttribute
        },
        {
          start: 0,
          length: span.content.length,
          styledKey: StyledStringKey.GESTURE,
          styledValue: this.generateClickStyle(span)
        },
        {
          start: span.content.length + ELLIPSIS.length,
          length: FULL_TEXT.length,
          styledKey: StyledStringKey.FONT,
          styledValue: this.textAttribute
        },
        {
          start: span.content.length + ELLIPSIS.length,
          length: FULL_TEXT.length,
          styledKey: StyledStringKey.GESTURE,
          styledValue: this.generateClickStyle(span)
        }]));
    }
  }

  /**
   * 处理字符数未超过指定字符长度的情况，生成属性字符串
   * @param {MyCustomSpan} span - 自定义文本片段
   * @param {MutableStyledString[]} styledStrings - 属性字符串数组
   */
  processWithinSize(span: MyCustomSpan, styledStrings: MutableStyledString[]) {
    if (span.type === MyCustomSpanType.Hashtag || span.type === MyCustomSpanType.Mention ||
      span.type === MyCustomSpanType.DetailLink) {
      styledStrings.push(new MutableStyledString(span.content, [
        {
          start: 0,
          length: span.content.length,
          styledKey: StyledStringKey.GESTURE,
          styledValue: this.generateClickStyle(span)
        },
        {
          start: 0,
          length: span.content.length,
          styledKey: StyledStringKey.FONT,
          styledValue: this.textAttribute
        }
      ]));
    } else if (span.type === MyCustomSpanType.VideoLink) {
      // 如果视频链接图标的pixelMap已存在，在对应类型的链接前添加图片类型的属性字符串
      if (this.imagePixelMap !== undefined) {
        styledStrings.push(new MutableStyledString(new ImageAttachment({
          value: this.imagePixelMap,
          size: {
            width: $r('app.integer.styled_text_video_link_icon_size'),
            height: $r('app.integer.styled_text_video_link_icon_size')
          },
          verticalAlign: ImageSpanAlignment.CENTER,
          objectFit: ImageFit.Contain
        })));
      }
      styledStrings.push(new MutableStyledString(span.content, [
        {
          start: 0,
          length: span.content.length,
          styledKey: StyledStringKey.GESTURE,
          styledValue: this.generateClickStyle(span)
        },
        {
          start: 0,
          length: span.content.length,
          styledKey: StyledStringKey.FONT,
          styledValue: this.textAttribute
        }
      ]));
    } else {
      styledStrings.push(new MutableStyledString(span.content, []));
    }
  }

  /**
   * 生成点击手势样式
   * @param {MyCustomSpan} span - 自定义文本片段，包含文本类型和内容
   * @returns {GestureStyle} - 包含点击事件处理的手势样式对象
   */
  generateClickStyle(span: MyCustomSpan): GestureStyle {
    return new GestureStyle({
      onClick: () => {
        if(this.linkClickCallback){
          this.linkClickCallback(span);
        }
      }
    })
  }

  build() {
    Text(undefined, { controller: this.controller })
      .width($r('app.string.styled_text_layout_full_size'))
      .fontSize(this.defaultFontSize)
      .fontColor(this.defaultFontColor)
      .onAppear(() => {
        // TODO：知识点：在Text组件挂载完成后绑定处理后的属性字符串
        this.controller.setStyledString(this.paragraphStyledString);
      })
  }
}