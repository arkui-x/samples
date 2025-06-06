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

import { EKeyType, EKeyboardType, IKeyAttribute } from '../model/Constants';

@Component
export struct CustomKeyboard {
  @Prop items: IKeyAttribute[];
  @Prop curKeyboardType: EKeyboardType;
  @Link inputValue: string;
  private controller: TextInputController = new TextInputController();
  private onKeyboardEvent: Function | null = null;
  private rowSpace: number = 5; // 行间距
  private rowCount: number = 4; // 行数
  private columnSpace: number = 5; // 列间距
  private itemHeight: number = 42; // Item尺寸
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部导航栏高度

  @Builder
  myGridItem(item: IKeyAttribute) {
    if (typeof item.label === 'object') {
      Image(item.label)
        .width($r("app.integer.customsafekeyboard_key_image_size"))
        .height($r("app.integer.customsafekeyboard_key_image_size"))
        .objectFit(ImageFit.Contain)
    } else {
      Text(item.label)
        .fontSize(item.fontSize)
        .fontColor(item.fontColor)
        .fontWeight(FontWeight.Bold)
    }
  }

  @Builder
  titleBar() {
    Stack() {
      Text($r("app.string.customsafekeyboard_keyboard_title"))
        .fontSize($r("app.integer.customsafekeyboard_keyboard_title_font_size"))
        .fontColor(Color.Grey)

      Row() {
        Text($r("app.string.customsafekeyboard_keyboard_submit"))
          .fontSize($r("app.integer.customsafekeyboard_keyboard_title_font_size"))
          .fontColor(Color.Blue)
          .onClick(() => {
            this.controller.stopEditing();
          })
      }
      .width($r("app.string.customsafekeyboard_one_hundred_percent"))
      .justifyContent(FlexAlign.End)
    }
    .width($r("app.string.customsafekeyboard_one_hundred_percent"))
    .margin({ top: $r("app.integer.customsafekeyboard_keyboard_title_margin_top"), bottom: $r("app.integer.customsafekeyboard_keyboard_title_margin_bottom") })
  }

  build() {
    Column() {
      this.titleBar();

      Grid() {
        // 性能知识点：此处数据项较少，一屏内可以展示所有数据项，使用了ForEach。在数据项多的列表git滚动场景下，推荐使用LazyForEach。
        ForEach(this.items, (item: IKeyAttribute) => {
          GridItem() {
            this.myGridItem(item)
          }
          .width($r("app.string.customsafekeyboard_one_hundred_percent"))
          .height(this.itemHeight)
          .rowStart(item?.position?.[0])
          .rowEnd(item?.position?.[1])
          .columnStart(item?.position?.[2])
          .columnEnd(item?.position?.[3])
          .backgroundColor(item.backgroundColor)
          .borderRadius($r("app.integer.customsafekeyboard_keyboard_radius"))
          .onClick(() => {
            this.onKeyboardEvent?.(item);
            if (item.type === EKeyType.CAPSLOCK && typeof item.label === 'object') {
              if (this.curKeyboardType === EKeyboardType.LOWERCASE) {
                item.label = $r("app.media.customsafekeyboard_capslock_white");
              } else {
                item.label = $r("app.media.customsafekeyboard_capslock_black");
              }
            }
          })
        }, (item: IKeyAttribute, index: number) => JSON.stringify(item) + index)
      }
      .margin({ bottom: this.bottomHeight + 'px' })
      .columnsTemplate(this.curKeyboardType === EKeyboardType.NUMERIC ? "1fr 1fr 1fr" :
        "1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr")
      .rowsTemplate("1fr 1fr 1fr 1fr") // Grid高度均分成4份
      .rowsGap(this.rowSpace) // 设置行间距
      .columnsGap(this.columnSpace) // 设置列间距
      .width($r("app.string.customsafekeyboard_one_hundred_percent"))
      .height(this.itemHeight * this.rowCount + this.rowSpace * (this.rowCount - 1))
    }
    .width($r("app.string.customsafekeyboard_one_hundred_percent"))
    .padding({ left: this.columnSpace, right: this.columnSpace })
    .backgroundColor(Color.Black)
  }
}