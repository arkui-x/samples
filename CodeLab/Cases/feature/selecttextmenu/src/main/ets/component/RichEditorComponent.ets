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

/**
 * 自定义富文本组件RichEditorComponent
 *
 * 功能描述：
 * 1.提供富文本编辑文字组件。
 * 2.提供拓展自定义文字选择菜单功能。
 *
 * 实现思路
 * 1.使用RichEditor组件实现文字编辑。
 * 2.使用富文本组件的editMenuOptions属性拓展文字选择菜单，通过onCreateMenu和onMenuItemClick两个参数分别配置菜单项和选择后实现的功能。
 *
 * 接口：
 * RichEditorComponent({ controller: RichEditorController, selectMenu: string, selectText: Array<RichEditorTextSpanResult | RichEditorImageSpanResult>, menuItemsContent: Array<TextMenuItem> })
 *
 * 参数：
 * @param { RichEditorController } controller - 富文本控制器，用于父组件设置富文本组件的各种属性和调用各种方法，具体可参考富文本组件官方文档。必选项。
 *
 * @param { string } selectMenu - 当前选中的菜单名。必选项
 *
 * @param { Array<RichEditorTextSpanResult | RichEditorImageSpanResult> } selectText - 当前选中的文本内容。必选项
 *
 * @param { Array<TextMenuItem> } menuItemsContent - 父组件传入的拓展菜单选项。必选项
 * 包含以下子项：
 * @param { ResourceStr } content - 选项名称。必选项。
 * @param { TextMenuItemId } id - 选项ID。必选项。
 * @param { ResourceStr | undefined } icon - 选项icon。可选项。
 *
 * 基本用法：
 * RichEditorComponent({ controller: RichEditorController, selectMenu: string, selectText: Array<RichEditorTextSpanResult | RichEditorImageSpanResult>, menuItemsContent: Array<TextMenuItem> }) // 传入自定义数组menuItemsContent拓展富文本菜单，传入RichEditorController对象在父组件控制富文本组件。
 */

import { CreateMenuCallback, MenuItemClickCallback } from '../model/SelectMenuOption';

const PRESETS_TEXT: string = '请长按本文打开编辑菜单'; // 预置文本内容
const EDITOR_ID: string = 'RichEditor'; // 富文本ID

@Component
export struct RichEditorComponent {
  controller: RichEditorController = new RichEditorController(); // 富文本控制器
  @Link selectMenu: string;
  @Link selectText: Array<RichEditorTextSpanResult | RichEditorImageSpanResult>;
  menuItemsContent: Array<TextMenuItem> = []; // 传入菜单数组
  private onCreatMenu?: CreateMenuCallback;
  private onMenuItemClick?: MenuItemClickCallback;

  // 初始化文本选择按钮
  initMenuOptions() {
    this.onCreatMenu = (textMenuItems: Array<TextMenuItem>) => {
      if (this.menuItemsContent) {
        // 循环遍历新增选项数组，传入RichEditor组件中
        this.menuItemsContent.forEach((value) => {
          textMenuItems.push(value);
        })
      }
      return textMenuItems;
    }
    this.onMenuItemClick = (textMenuItems: TextMenuItem, textRange: TextRange) => {
      // 每次点击循环遍历传入的选项数组，判断当前点击的选项是否为新增选项
      for (let item of this.menuItemsContent) {
        if (textMenuItems.id.equals(item.id)) {
          // 传递当前选中的文本信息
          if (this.controller) {
            this.selectText = this.controller.getSpans({ start: textRange.start, end: textRange.end });
          }
          // 传递当前选中的选项
          this.selectMenu = textMenuItems.content.toString();
          return true;
        }
      }
      return false;
    }
  }

  aboutToAppear(): void {
    this.initMenuOptions();
  }

  build() {
    Column() {
      Scroll() {
        RichEditor({ controller: this.controller })
          // TODO: 知识点：富文本组件使用editMenuOptions方法配置选中菜单
          // onCreateMenu对象实现按钮新增
          // onMenuItemClick对象配置各按钮对应的方法
          .editMenuOptions({
            onCreateMenu: this.onCreatMenu, onMenuItemClick: this.onMenuItemClick
          })
          // 在富文本组件渲染完成后修改文字大小等基础属性
          .onReady(() => {
            this.controller?.setTypingStyle({
              fontSize: $r('app.integer.select_text_menu_editor_fontsize')
            });
            // 添加富文本预设内容
            this.controller.addTextSpan(PRESETS_TEXT,
              { style: { fontSize: $r('app.integer.select_text_menu_editor_fontsize') } })
          })
          .id(EDITOR_ID)
          .caretColor(Color.Black)
          .padding({
            left: $r('app.integer.select_text_menu_editor_margin_left'),
            right: $r('app.integer.select_text_menu_editor_margin_right'),
            top: $r('app.integer.select_text_menu_editor_margin_top')
          })
          .backgroundColor($r('app.color.select_text_menu_editor_background_color'))
          .height($r('app.string.select_text_menu_editor_height'))
          .width($r('app.string.select_text_menu_editor_width'))
      }
    }
    .height($r('app.string.select_text_menu_editor_height'))
  }
}