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

import { EmojiModel, LastEmojiData } from '../model/Emoji';
import { FaceGridConstants } from '../constants/ChatConstants';

// 表情详细信息
@Component
export struct EmojiDetail {
  // 控制器，用以将表情添加到输入框
  controllerRich: RichEditorController | undefined = undefined;
  // 单个表情模型
  EmojiItem: EmojiModel | undefined = undefined;
  msgFontSize: number = 0;
  // popup状态
  @State isPopup: boolean = false;
  // 最近使用的表情数据，点击表情之后添加到该数据中
  @Link lastEmojiData: LastEmojiData;

  /**
   * popup表情详情弹框
   */
  @Builder
  popupBuilder() {
    Column() {
      Image(this.EmojiItem?.imgSrc)
        .width(FaceGridConstants.EMOJI_IMAGE_SIZE * 2) // 2, 放大两倍
        .height(FaceGridConstants.EMOJI_IMAGE_SIZE * 2) // 2, 放大两倍
        .id('popupImage')
      Text(this.EmojiItem?.meaning)
    }
    .justifyContent(FlexAlign.SpaceAround)
    .padding($r('app.integer.chat_with_expression_chat_item_padding'))
  }

  build() {
    Image(this.EmojiItem!.imgSrc)
      .width(FaceGridConstants.EMOJI_IMAGE_SIZE)
      .height(FaceGridConstants.EMOJI_IMAGE_SIZE)
      .id('detailId')
      .onClick(() => {
        // TODO 知识点：将表情添加到输入框中
        this.controllerRich!.addImageSpan(this.EmojiItem!.imgSrc, {
          imageStyle: {
            size: [this.msgFontSize / 3.2, this.msgFontSize / 3.2], // 3.2 调整表情在输入框中的尺寸
            verticalAlign: ImageSpanAlignment.CENTER,
            layoutStyle: { margin: FaceGridConstants.EMOJI_MARGIN }
          }
        });
        // TODO 知识点：将表情添加到最近使用表情中
        this.lastEmojiData.pushData(this.EmojiItem!);
      })
      .draggable(false)
      .gesture(
        // TODO 知识点：长按弹出表情明细
        LongPressGesture()
          .onAction(() => {
            this.isPopup = true;
          })
          .onActionEnd(() => {
            this.isPopup = false;
          })
      )
      .bindPopup(this.isPopup, {
        // TODO 知识点：使用bindPopup弹出表情明细
        builder: this.popupBuilder, onStateChange: (e) => {
          if (!e.isVisible) {
            this.isPopup = false;
          }
        }
      })
  }
}