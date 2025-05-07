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


import { TextExpandView } from '../utils/TextExpandView';
import { LastSpanAttribute, TextSectionAttribute } from '../utils/Model';

@Component
export struct ItemPart {
  @Prop index: string;
  @Prop profileImg: string | Resource = ''; // 头像图片
  @Prop imgUrlList: Array<string | Resource> = []; // 展示图片
  @Prop rawTitle: Resource; // 接收到的文字
  @Prop tabItemIndex: number;

  build() {
    ListItem() {
      Flex({ direction: FlexDirection.Column }) {
        Row() {
          Image(this.profileImg)
            .width($r('app.integer.text_expand_image_width'))
            .height($r('app.integer.text_expand_image_height'))
            .borderRadius($r('app.integer.text_expand_image_border_radius'))
          Column() {
            Text($r('app.string.text_expand_text_name'))
              .fontSize($r('app.integer.text_expand_item_text_font_size'))
            Text($r('app.string.text_expand_text_date'))
              .fontSize($r('app.integer.text_expand_item_text_date_font_size'))
              .fontColor($r('app.color.text_expand_item_text_font_color'))
          }
          .margin({ left: $r('app.integer.text_expand_item_column_margin') })
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
        }
        .margin($r('app.integer.text_expand_item_row_margin'))

        /**
         * 文本的展开收起视图
         *
         * @param textSectionAttribute - 文本章节属性类
         * @param lastSpanAttribute - 控制文本折叠的文本或者图片属性
         *
         */
        TextExpandView({
          textSectionAttribute: new TextSectionAttribute(this.rawTitle),
          lastSpanAttribute: this.tabItemIndex % 2 === 0 ? new LastSpanAttribute(0, 2,
            [$r('app.string.text_expand_expand_title'), $r('app.string.text_expand_collapse_title')], 16,
            Color.Orange) :
            new LastSpanAttribute(1, 1,
              [$r("app.media.text_expand_arrow_down"), $r('app.media.text_expand_arrow_right')],
              16, Color.Orange)
        }).id(`textClick${this.index}`)
        Row() {
          ForEach(this.imgUrlList, (item: Resource, index: number) => {
            Image(item)
              .width($r('app.integer.text_expand_item_main_body_image_width'))
              .height($r('app.integer.text_expand_item_main_body_image_height'))
              .margin({
                right: index === this.imgUrlList.length - 1 ? 0 :
                $r('app.integer.text_expand_item_main_body_image_margin')
              })
          }, (item: Resource, index: number) => index.toString())
        }
        .margin({ left: $r('app.integer.text_expand_item_row_margin') })
      }
    }
  }
}