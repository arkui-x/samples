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

import { STYLE_CONFIG } from '../model/ConstData';
import { ToDo } from '../model/ToDo';

@Component
export struct ToDoListItem {
  @Link achieveData: ToDo[]; // 已完成列表项
  @Link toDoData: ToDo[]; // 未完成列表项
  @ObjectLink toDoItem: ToDo; // item数据项
  @State isEdited: boolean = false; // 编辑状态

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row({ space: STYLE_CONFIG.ICON_GUTTER }) {
        if (!this.isEdited) {
          Row() {
            if (this.toDoItem.isFinished) {
              Image($r('app.media.pendingitems_ic_public_ok_filled'))
                .id('complete_image')
                .width(STYLE_CONFIG.IMAGE_ICON_OK_SIZE)
                .aspectRatio(1)
                .borderRadius(STYLE_CONFIG.IMAGE_ICON_OK_SIZE)
                .fillColor(Color.White)
                .transition(TransitionEffect.IDENTITY)
            }
          }
          .id('choose_border')
          .width(STYLE_CONFIG.CUSTOM_CHECKBOX_SIZE)
          .justifyContent(FlexAlign.Center)
          .aspectRatio(1)
          .borderRadius(STYLE_CONFIG.CUSTOM_CHECKBOX_SIZE)
          .backgroundColor(this.toDoItem.isFinished ? $r('sys.color.ohos_id_color_floating_button_bg_normal') :
          Color.Transparent)
          .borderWidth(1)
          .borderColor($r('sys.color.ohos_id_color_focused_content_tertiary'))
          .onClick(() => {
            this.addAchieveData();
          })

          Text(`${this.toDoItem.name}`)
            .fontSize($r('sys.float.ohos_id_text_size_headline9'))
            .maxFontSize(STYLE_CONFIG.FONT_SIZE_MAX)
            .minFontSize(STYLE_CONFIG.FONT_SIZE_MIN)
            .layoutWeight(1)
            .maxLines(3)
            .textAlign(TextAlign.JUSTIFY)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .decoration({ type: this.toDoItem.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
        } else {
          TextInput({ text: `${this.toDoItem.name}` })
            .maxLines(1)
            .fontSize($r('sys.float.ohos_id_text_size_headline9'))
            .layoutWeight(1)
            .backgroundColor(Color.Transparent)
            .id('textEdit')
            .onChange((value: string) => {
              this.toDoItem.name = value; // 更新待办事项数据
            })
            .onAppear(() => {
              focusControl.requestFocus('textEdit'); // 请求输入框获取焦点
            })
        }
        Blank()
        if (this.isEdited) {
          Image($r('app.media.pendingitems_ic_public_ok_filled'))
            .id('edit_complete')
            .width(STYLE_CONFIG.MENU_IMAGE_SIZE)
            .aspectRatio(1)
            .onClick(() => {
              this.isEdited = false;
            })
        } else {
          Text($r('app.string.pendingitems_edit'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .onClick(() => {
              this.isEdited = true;
            })
        }
      }
      .width($r('app.string.pendingitems_max_size'))
    }
    .width($r('app.string.pendingitems_max_size'))
    .height(STYLE_CONFIG.TODO_ITEM_HEIGHT)
    .padding({
      left: $r('sys.float.ohos_id_default_padding_start'),
      right: $r('sys.float.ohos_id_default_padding_end'),
      top: STYLE_CONFIG.TODO_ITEM_PADDING_VERTICAL,
      bottom: STYLE_CONFIG.TODO_ITEM_PADDING_VERTICAL
    })
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
    .backgroundColor(Color.White)
  }

  /**
   * 添加已完成数据项
   */
  addAchieveData() {
    this.toDoItem.isFinished = true;
    if (this.toDoItem.isFinished) {
      animateTo({ duration: STYLE_CONFIG.ANIMATION_DURATION }, () => {
        const tempData = this.toDoData.filter(item => item.key !== this.toDoItem.key);
        this.toDoData = tempData;
        this.achieveData.push(this.toDoItem);
      })
    }
  }
}