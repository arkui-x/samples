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
 * 功能描述: 通过自定义Span类型，在Text组件中使用ForEach遍历，根据不同的Span类型生成不同样式和功能的Span组件，实现部分文本高亮和超链接。
 *
 * 实现原理：
 * 1. 使用 `MyCustomSpan[]` 类型的数组 `spans` 作为数据源，每个 `MyCustomSpan` 对象代表一个文本片段，包含类型（普通文本、超链接、视频链接等）和内容。
 * 2. 遍历 `spans` 数组，根据每个 `span` 的类型动态生成相应的UI元素（如普通文本、可点击的超链接或视频链接）。
 * 3. 如果最终的文本内容超过指定字符长度，则截断字符串并在末尾添加“...全文”链接。
 * 4. 对于超链接和视频链接，提供回调函数 `linkClickCallback` 来处理用户的点击事件，根据不同类型触发不同的交互行为。
 *
 * @param {MyCustomSpan[]} [spans] - 包含不同类型文本片段的数组（如普通文本、超链接等）。
 * @param {number} [maxStringLength] - 正文内容最大字符长度，默认值为140。
 * @param {string | number | Resource} [defaultFontSize] - 正文内容字体大小，默认14fp。
 * @param {ResourceColor} [defaultFontColor] - 正文内容字体颜色。
 * @param {ResourceColor} [linkColor] - 超链接字体颜色。
 * @param {string | number | Resource} [linkFontSize] - 超链接字体大小，默认与正文相同。
 * @param {ResourceStr | image.PixelMap} [videoLinkIcon] - 视频超链接图标。
 * @param {(span: MyCustomSpan) => void} [linkClickCallback] - 链接点击回调函数，在用户点击链接时调用。
 * @param {ResourceColor} [clickedBackgroundColor] - 点击链接背景颜色。
 * @param {number} [backgroundChangeDelay] - 背景颜色变化的延迟时间，单位毫秒，默认为100毫秒。
 */

@Component
export struct TextAndSpanComponent {
  // -------------------对外暴露变量-----------------------
  @State spans: MyCustomSpan[] = []; // 自定义span列表数据
  maxStringLength: number = 140; // 正文内容最大字符长度，默认值140
  defaultFontSize: string | number | Resource = $r('app.string.styled_text_font_size_default'); // 正文内容字体大小
  defaultFontColor: ResourceColor = Color.Black; // 正文内容字体颜色
  linkColor: ResourceColor = $r('app.color.styled_text_link_font_color'); // 超链接字体颜色
  linkFontSize: string | number | Resource = $r('app.string.styled_text_font_size_default'); // 超链接字体大小
  videoLinkIcon: ResourceStr | image.PixelMap = $r('app.media.styled_text_ic_public_video'); // 视频超链接图标
  linkClickCallback?: (span: MyCustomSpan) => void; // 超链接点击回调
  clickedBackgroundColor: ResourceColor = $r('app.color.styled_text_link_clicked_background_color'); // 点击链接背景颜色
  backgroundChangeDelay: number = 100; // 背景颜色变化的延迟时间，用于展示背景颜色变化效果
  // --------------------私有属性----------------------------
  @State clickSpanId: number | string = ''; // 当前点击span的id

  aboutToAppear(): void {
    this.processCustomSpans(this.spans);
  }

  aboutToReuse(params: Record<string, MyCustomSpan[] | string | number>): void {
    this.processCustomSpans(params.spans as MyCustomSpan[]);
  }
  /**
   * 处理自定义span列表数据，确保最终拼接后不超过指定字符长度。如果超过，则截取字符串并在末尾添加“...全文”链接。
   * @param {MyCustomSpan[]} spans - 包含不同类型文本片段的数组（如普通文本、链接等）。
   */
  processCustomSpans(spans: MyCustomSpan[]): void {
    let charCount = 0; // 遍历拼接customMessage.spans，记录已拼接的字符串长度
    let data: MyCustomSpan[] = []; // 用于存储处理后的文本

    spans.forEach((span: MyCustomSpan, index: number) => {
      // 如果当前累积字符数已经达到最大允许长度，则停止处理后续文本片段
      if (charCount >= this.maxStringLength) {
        return;
      }
      // 如果添加当前文本片段后将超过最大允许长度
      if (charCount + span.content.length >= this.maxStringLength) {
        // 检查文本片段的类型，决定如何处理超出部分
        if (span.type === MyCustomSpanType.Normal) {
          // 如果是普通文本，则截断并添加省略号
          data.push(new MyCustomSpan(span.id, MyCustomSpanType.Normal,
            `${span.content.substring(0, this.maxStringLength - charCount)}...`));
        } else {
          // 对于链接类型，直接用省略号代替剩余部分
          data.push(new MyCustomSpan(span.id, MyCustomSpanType.Normal, '...'));
        }
        // 添加全文链接文本
        data.push(new MyCustomSpan(-1, MyCustomSpanType.DetailLink, '全文'));
        return;
      } else {
        data.push(span);
      }
      charCount += span.content.length;
    })
    this.spans = data;
  }

  // 仅文本的超链接Span组件
  @Builder
  textLinkSpanBuilder(item: MyCustomSpan) {
    Span(item.content)
      .fontColor(this.linkColor)
      .fontSize(this.linkFontSize)
      .textBackgroundStyle({
        color: this.clickSpanId === item.id ? $r('app.color.styled_text_link_clicked_background_color') :
        Color.Transparent
      })
      .onClick(() => {
        setTimeout(() => {
          this.clickSpanId = '';
        }, this.backgroundChangeDelay)
        this.clickSpanId = item.id;
        if(this.linkClickCallback){
          this.linkClickCallback(item);
        }
      })
  }

  // 带有图标的视频链接Span组件
  @Builder
  videoLinkSpanBuilder(item: MyCustomSpan) {
    ContainerSpan() {
      ImageSpan(this.videoLinkIcon)
        .height($r('app.integer.styled_text_video_link_icon_height'))
        .verticalAlign(ImageSpanAlignment.CENTER)
        .onClick(() => {
          setTimeout(() => {
            this.clickSpanId = '';
          }, this.backgroundChangeDelay)
          this.clickSpanId = item.id;
          if(this.linkClickCallback){
            this.linkClickCallback(item);
          }
        })
      Span(item.content)
        .fontColor(this.linkColor)
        .fontSize(this.linkFontSize)
        .onClick(() => {
          setTimeout(() => {
            this.clickSpanId = '';
          }, this.backgroundChangeDelay)
          this.clickSpanId = item.id;
          if(this.linkClickCallback){
            this.linkClickCallback(item);
          }
        })
    }
    .textBackgroundStyle({
      color: this.clickSpanId === item.id ? $r('app.color.styled_text_link_clicked_background_color') :
      Color.Transparent
    })
  }

  build() {
    // 文本消息，一次加载完成，不使用LazyForEach
    // TODO：知识点：Text组件通过ForEach遍历文本数据，根据文本数据的类型渲染相应的组件，实现部分文本的特殊样式和点击处理。
    Text() {
      ForEach(this.spans, (item: MyCustomSpan) => {
        if (item.type === MyCustomSpanType.Normal) {
          Span(item.content)
        } else if (item.type === MyCustomSpanType.Hashtag || item.type === MyCustomSpanType.Mention ||
          item.type === MyCustomSpanType.DetailLink) {
          this.textLinkSpanBuilder(item)
        } else {
          this.videoLinkSpanBuilder(item)
        }
      }, (item: MyCustomSpan, index: number) => `${index}_${JSON.stringify(item)}`)
    }
    .width($r('app.string.styled_text_layout_full_size'))
    .fontSize(this.defaultFontSize)
    .fontColor(this.defaultFontColor)
  }
}