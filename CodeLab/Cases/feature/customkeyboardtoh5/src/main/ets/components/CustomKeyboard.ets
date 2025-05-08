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

@CustomDialog
export struct CustomKeyboard {
  customController: CustomDialogController;
  @Link dialogClose: boolean; // 输入法弹窗是否关闭
  @Link dialogOpen: boolean; // 输入法弹窗是否开启
  @Link items: IKeyAttribute[]; // 键盘按键数组
  @Link curKeyboardType: EKeyboardType; // 当前键盘类型，默认为数字键盘
  @Link inputValue: string; // 输入框内容
  private closeDialog: Function | null = null; // 关闭弹窗事件
  private onKeyboardEvent: Function | null = null; // 键盘按键事件响应函数
  private rowSpace: number = 5; // 行间距
  private rowCount: number = 4; // 行数
  private columnSpace: number = 5; // 列间距
  private itemHeight: number = 42; // Item尺寸
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部导航栏高度

  @Builder
  myGridItem(item: IKeyAttribute) {
    if (typeof item.label === 'object') {
      Image(item.label)
        .width($r("app.integer.custom_keyboard_to_h5_key_image_size"))
        .height($r("app.integer.custom_keyboard_to_h5_key_image_size"))
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
      Text($r("app.string.custom_keyboard_to_h5_keyboard_title"))
        .fontSize($r("app.integer.custom_keyboard_to_h5_keyboard_title_font_size"))
        .fontColor(Color.Grey)

      Row() {
        Text($r("app.string.custom_keyboard_to_h5_keyboard_submit"))
          .fontSize($r("app.integer.custom_keyboard_to_h5_keyboard_title_font_size"))
          .fontColor(Color.Blue)
          .onClick(() => {
            this.closeDialog?.();
          })
      }
      .width($r("app.string.custom_keyboard_to_h5_one_hundred_percent"))
      .justifyContent(FlexAlign.End)
    }
    .width($r("app.string.custom_keyboard_to_h5_one_hundred_percent"))
    .margin({
      top: $r("app.integer.custom_keyboard_to_h5_keyboard_title_margin_top"),
      bottom: $r("app.integer.custom_keyboard_to_h5_keyboard_title_margin_bottom")
    })
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
          .width($r("app.string.custom_keyboard_to_h5_one_hundred_percent"))
          .height(this.itemHeight)
          .rowStart(item?.position?.[0])
          .columnEnd(item?.position?.[1])
          .columnStart(item?.position?.[2])
          .columnEnd(item?.position?.[3])
          .backgroundColor(item.backgroundColor)
          .borderRadius($r("app.integer.custom_keyboard_to_h5_keyboard_radius"))
          .onClick(() => {
            this.onKeyboardEvent?.(item);
            if (item.type === EKeyType.CAPSLOCK && typeof item.label === 'object') {
              if (this.curKeyboardType === EKeyboardType.LOWERCASE) {
                item.label = $r("app.media.custom_keyboard_to_h5_capslock_white");
              } else {
                item.label = $r("app.media.custom_keyboard_to_h5_capslock_black");
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
      .width($r("app.string.custom_keyboard_to_h5_one_hundred_percent"))
      .height(this.itemHeight * this.rowCount + this.rowSpace * (this.rowCount - 1))
    }
    .width($r("app.string.custom_keyboard_to_h5_one_hundred_percent"))
    .padding({ left: this.columnSpace, right: this.columnSpace })
    .backgroundColor(Color.Black)
  }
}