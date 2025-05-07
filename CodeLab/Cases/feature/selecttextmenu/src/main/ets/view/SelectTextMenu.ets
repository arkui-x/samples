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
 * 功能描述：拓展富文本组件文字选择菜单选项，通过富文本组件editMenuOptions属性添加自定义选择菜单，在编辑文字时选择更多选项打开额外菜单栏。
 *
 * 推荐场景：备忘录、短信等编辑文字场景
 *
 * 核心组件：
 * 1. RichEditor
 *
 * 实现步骤：
 * 1. 子组件中使用RichEditor富文本组件实现文本编辑功能。
 * 2. 使用富文本组件的editMenuOptions属性扩展文本选择菜单。
 * 3. 父组件传入需要新增的菜单选项，并在点击选项后获取到当前选项和当前选中的文本信息。
 */

import { RichEditorComponent } from '../component/RichEditorComponent';
import { promptAction, ToolBar, ToolBarOptions, ItemState, window, KeyboardAvoidMode } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

const FONT_WEIGHT_NORMAL_SIZE: number = 10; // RichEditorTextStyleResult值中fontWeight normal参数与值的对照
const LAYOUT_WEIGHT: number = 1;
const TOOLBAR_ACTIVE_INDEX: number = 2;

@Component
export struct SelectTextMenuComponent {
  @Watch('selectMenuChange') @State selectMenu: string = ''; // 当前选中的按钮选项
  @State selectText: Array<RichEditorTextSpanResult | RichEditorImageSpanResult> = []; // 当前选中的文本内容
  richEditorController: RichEditorController = new RichEditorController(); // 富文本控制器
  @State keyboardHeight: number = 0; // 键盘高度
  private scrollerForLiftUp: Scroller = new Scroller();
  @State toolbarList: ToolBarOptions = new ToolBarOptions(); // 初始化底部工具栏
  // 将按钮对象TextMenuItem传入子组件
  menuItemsContent: Array<TextMenuItem> = [
    {
      content: $r('app.string.select_text_menu_search_menu'),
      id: TextMenuItemId.of('search'),
      icon: $r("app.media.select_menu_search")
    },
    {
      content: $r('app.string.select_text_menu_translate_menu'),
      id: TextMenuItemId.of('translate'),
      icon: $r("app.media.select_menu_translate")
    },
    {
      content: $r('app.string.select_text_menu_share_menu'),
      id: TextMenuItemId.of('share'),
      icon: $r("app.media.select_menu_share")
    },
  ];

  aboutToAppear(): void {
    // 虚拟键盘抬起时，页面的避让模式设置为RESIZE
    let context = getContext(this) as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (data: number) => {
        this.keyboardHeight = px2vp(data);
      })
    })
    // 初始化底部工具栏
    this.toolbarList.push(
      {
        content: '加粗',
        icon: $r('app.media.select_menu_type_bold'),
        action: () => {
          if (this.richEditorController.getSpans().length ) {
            // 更新富文本样式
            this.richEditorController.updateSpanStyle({
              textStyle: {
                // 判断当前文字FontWeight样式是否加粗
                fontWeight: (this.richEditorController.getSpans()[0] as RichEditorTextSpanResult).textStyle.fontWeight ==
                  FONT_WEIGHT_NORMAL_SIZE ? FontWeight.Bolder : FontWeight.Normal
              }
            });
          }
        }
      },
      {
        content: '倾斜',
        icon: $r('app.media.select_menu_type_italic'),
        action: () => {
          if (this.richEditorController.getSpans().length) {
            this.richEditorController.updateSpanStyle({
              textStyle: {
                // 判断当前文字FontStyle样式是否倾斜
                fontStyle: (this.richEditorController.getSpans()[0] as RichEditorTextSpanResult).textStyle.fontStyle ==
                FontStyle.Italic ? FontStyle.Normal : FontStyle.Italic
              }
            });
          }
        }
      },
      {
        content: '字体',
        icon: $r('app.media.select_menu_fonts'),
        action: () => {
        },
        state: ItemState.DISABLE
      },
      {
        content: '图片',
        icon: $r('app.media.select_menu_image'),
        action: () => {
        },
        state: ItemState.DISABLE
      });
  }

  // 监听到选中按钮发生改变时触发相应方法
  selectMenuChange() {
    promptAction.showToast({
      message: $r('app.string.select_text_menu_tips')
    });
  }

  build() {
    Column() {
      Scroll(this.scrollerForLiftUp) {
        Column() {
          RichEditorComponent({
            menuItemsContent: this.menuItemsContent,
            selectMenu: this.selectMenu,
            selectText: this.selectText,
            controller: this.richEditorController
          })
        }
      }
      .layoutWeight(LAYOUT_WEIGHT)

      Row() {
        ToolBar({
          activateIndex: TOOLBAR_ACTIVE_INDEX,
          toolBarList: this.toolbarList
        })
      }
      .height($r('app.integer.select_text_menu_toolbar_height'))
      .width($r('app.string.select_text_menu_toolbar_width'))
    }
    .width($r('app.string.select_text_menu_body_width'))
    .height($r('app.string.select_text_menu_body_width'))
  }
}