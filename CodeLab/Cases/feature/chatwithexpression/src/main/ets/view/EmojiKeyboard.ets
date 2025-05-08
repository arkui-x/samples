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
import { EmojiDetail } from './EmojiDetail';
import { FaceGridConstants } from '../constants/ChatConstants';

// 表情键盘
@Component
export struct EmojiKeyboard {
  // 控制器，用以将表情添加到输入框
  controllerRich: RichEditorController | undefined = undefined;
  msgFontSize: number = 0;
  // 最近使用的表情数据，点击表情之后添加到数据中
  @Link lastEmojiData: LastEmojiData;
  // 表情键盘的表情数据列表
  emojiList: Array<EmojiModel> = [];

  build() {
    Grid() {
      // TODO: 性能知识点：使用ForEach组件循环渲染数据
      ForEach(this.emojiList, (item: EmojiModel) => {
        GridItem() {
          // 表情明细组件
          EmojiDetail({
            controllerRich: this.controllerRich,
            EmojiItem: item,
            msgFontSize: this.msgFontSize,
            lastEmojiData: this.lastEmojiData
          })
        }
        .id('faceGridId')
      })
    }
    .maxCount(FaceGridConstants.GRID_MAX_COUNT)
    .columnsTemplate("1fr 1fr 1fr 1fr 1fr 1fr") // 分成6份
    .rowsGap(FaceGridConstants.ROWS_GAP)
    .margin($r('app.integer.chat_with_expression_grid_item_margin'))
    .width($r('app.string.chat_with_expression_layout_100'))
  }
}