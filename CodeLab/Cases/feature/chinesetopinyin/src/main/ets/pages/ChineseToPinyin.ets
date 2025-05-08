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

// TODO: 知识点: 引入pinyin4js三方库
import { pinyin4js } from '@ohos/pinyin4js';
import promptAction from '@ohos.promptAction';

const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const LIST_SPACE: number = 16;
const PINYIN_ARRAY: number = 0; // 拼音列表项在数组中的位置
const STROKE_WIDTH: number = 1;
const MAX_LINE: number = 1; // text显示的最大行数
const INPUT_ID: string = 'chineseInput'; // 输入框ID

// 列表结构对象
@Observed
class ListConstruction {
  public id: Resource; // 唯一id
  public title: Resource; // 列表标题
  public content: Resource | string; // 列表内容

  constructor(id: Resource, title: Resource, content: Resource | string) {
    this.id = id;
    this.title = title;
    this.content = content;
  }
}

/**
 * 功能描述: 本示例介绍使用第三方库的pinyin4js组件实现汉字转大写拼音。
 *
 * 推荐场景: 身份信息展示场景
 *
 * 核心组件:
 * 1. 三方库pinyin4js组件
 *
 * 实现步骤:
 * 1. 引入第三方库pinyin4js组件。
 * 2. 使用convertToPinyinString实现汉字转拼音。
 */
@Component
export struct ChineseToPinyinComponent {
  @State userName: string | Resource = $r('app.string.pinyin_name_content');
  // 个人信息分组
  @State userGroup: ListConstruction[] = [
    new ListConstruction($r('app.string.pinyin_id'), $r('app.string.pinyin_name_change_title'), $r('app.string.pinyin_name_change_content')),
    new ListConstruction($r('app.string.pinyin_sex_id'), $r('app.string.pinyin_sex_title'), $r('app.string.pinyin_sex_content'))
  ];
  // 证件信息分组
  @State idGroup: ListConstruction[] = [
    new ListConstruction($r('app.string.pinyin_country_id'), $r('app.string.pinyin_country_title'), $r('app.string.pinyin_country_content')),
    new ListConstruction($r('app.string.pinyin_type_id'), $r('app.string.pinyin_id_type_title'), $r('app.string.pinyin_id_type_content')),
    new ListConstruction($r('app.string.pinyin_card_id'), $r('app.string.pinyin_id_title'), $r('app.string.pinyin_id_content')),
    new ListConstruction($r('app.string.pinyin_validity_id'), $r('app.string.pinyin_id_validity_title'), $r('app.string.pinyin_id_validity_content'))
  ];

  build() {
    Column() {
      Text($r('app.string.pinyin_title_content'))
        .fontSize($r('app.integer.pinyin_title_font_size'))
        .fontColor($r('app.color.pinyin_title_font_color'))
        .fontWeight(FontWeight.Bold)
        .width($r('app.string.pinyin_title_width'))
        .lineHeight($r('app.integer.pinyin_title_line_height'))
        .textAlign(TextAlign.Center)
        .height($r('app.integer.pinyin_title_height'))

      List({
        space: LIST_SPACE
      }) {
        ListItem() {
          Row() {
            Text($r('app.string.pinyin_name_title'))
              .width($r('app.string.pinyin_name_title_width'))
              .fontColor($r('app.color.pinyin_list_title_color'))
              .fontSize($r('app.integer.pinyin_list_title_size'))
              .layoutWeight(LAYOUT_WEIGHT)
              .lineHeight($r('app.integer.pinyin_list_line_height'))
            TextInput({
              text: this.userName
            })
              .id(INPUT_ID)
              .textAlign(TextAlign.End)
              .backgroundColor($r('app.color.pinyin_text_input_background'))
              .fontSize($r('app.integer.pinyin_list_content_size'))
              .layoutWeight(LAYOUT_WEIGHT)
              .selectionMenuHidden(true)
              .onChange((value: string) => {
                /** TODO: 知识点: 使用convertToPinyinString方法将汉字转换成拼音字母。
                 其中参数1为待转数据，参数2为拼音间隔字符，参数3设置是否带声调符号。
                 */
                const pinyin: string = pinyin4js.convertToPinyinString(value, '', pinyin4js.WITHOUT_TONE);
                this.userGroup[PINYIN_ARRAY].content = pinyin.toUpperCase();
              })
          }
          .height($r('app.integer.pinyin_pinyin_height'))
          .borderRadius($r('app.integer.pinyin_list_radius'))
          .backgroundColor($r('app.color.pinyin_list_background'))
          .margin({
            left: $r('app.integer.pinyin_margin_left'),
            right: $r('app.integer.pinyin_margin_right')
          })
          .padding({
            left: $r('app.integer.pinyin_padding_left'),
            right: $r('app.integer.pinyin_padding_right')
          })
        }

        ListItem() {
          ForEachItem({ dataGroup: this.userGroup })
        }
        .margin({
          left: $r('app.integer.pinyin_list_item_margin_left'),
          right: $r('app.integer.pinyin_list_item_margin_right')
        })

        ListItem() {
          ForEachItem({ dataGroup: this.idGroup })
        }
        .margin({
          left: $r('app.integer.pinyin_list_item_margin_left'),
          right: $r('app.integer.pinyin_list_item_margin_right')
        })
      }
      .width($r('app.string.pinyin_list_width'))
      .margin({ top: $r('app.integer.pinyin_list_margin_top') })

      Button($r('app.string.pinyin_button_content'))
        .width($r('app.string.pinyin_button_width'))
        .margin({ top: $r('app.integer.pinyin_button_margin_top') })
        .onClick(() => {
          promptAction.showToast({ message: $r('app.string.pinyin_only_show') });
        })
    }
    .backgroundColor($r('app.color.pinyin_body_background'))
    .height($r('app.string.pinyin_body_height'))
    .width($r('app.string.pinyin_body_width'))
  }
}

// 循环遍历列表
@Component
export struct ForEachItem {
  // 需要遍历的数据数组
  private dataGroup: ListConstruction[] = [];

  build() {
    Row() {
      List({
        space: LIST_SPACE
      }) {
        // TODO: 性能知识点：使用ForEach组件循环渲染数据
        ForEach(this.dataGroup, (item: ListConstruction) => {
          ListItem() {
            UserItemView({ text: item });
          }
        }, (item: ListConstruction) => JSON.stringify(item))
      }
      .divider({
        strokeWidth: STROKE_WIDTH,
        color: $r('app.color.pinyin_divider_color'),
        startMargin: $r('app.integer.pinyin_divider_start_margin'),
        endMargin: $r('app.integer.pinyin_divider_end_margin')
      })
    }
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.pinyin_list_background'))
    .borderRadius($r('app.integer.pinyin_list_radius'))
  }
}

// 列表组件
@Component
export struct UserItemView {
  // 列表项
  @ObjectLink text: ListConstruction;

  build() {
    Row() {
      Text(this.text.title)
        .fontSize($r('app.integer.pinyin_list_title_size'))
        .fontColor($r('app.color.pinyin_list_title_color'))
        .width($r('app.integer.pinyin_setting_title_width'))
        .lineHeight($r('app.integer.pinyin_list_line_height'))
      Text(this.text.content)
        .fontSize($r('app.integer.pinyin_list_content_size'))
        .layoutWeight(LAYOUT_WEIGHT)
        .fontColor($r('app.color.pinyin_list_content_color'))
        .lineHeight($r('app.integer.pinyin_list_line_height'))
        .textOverflow({
          overflow: TextOverflow.MARQUEE
        })
        .maxLines(MAX_LINE)
        .textAlign(TextAlign.End)
    }
    .width($r('app.string.pinyin_list_width'))
    .height($r('app.integer.pinyin_setting_item_height'))
    .padding({
      left: $r('app.integer.pinyin_setting_item_padding_left'),
      right: $r('app.integer.pinyin_setting_item_padding_right')
    })
    .alignItems(VerticalAlign.Center)
    .width($r('app.string.pinyin_list_width'))
    .alignSelf(ItemAlign.Center)
  }
}