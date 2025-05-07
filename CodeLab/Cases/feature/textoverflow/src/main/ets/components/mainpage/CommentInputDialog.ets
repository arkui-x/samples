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

import promptAction from '@ohos.promptAction';

// 组件在相对布局中的锚点ID
const ID_TEXT_INPUT: string = "id_text_input";
const ID_TEXT_PUSH: string = "id_text_publish";


/**
 * 输入评论弹窗，用于展示输入文字与被回复的用户昵称
 * 实现步骤：
 * 1.添加发布按钮
 * 2.点击发布按钮，将评论添加到列表中
 */
@CustomDialog
export struct CommentInputDialog {
  // 选择的照片列表
  @State selectedImages: string[] = [];
  // 输入的文字
  @State text: string = "";
  @Link textInComment: string;
  @State placeholder: string = "";
  controller?: CustomDialogController;
  // 发布接口，用于主页面更新评论数据
  publish: () => void = (): void => {};

  build() {
    Column() {
      RelativeContainer() {
        TextInput({ placeholder: this.placeholder })
          .height($r('app.integer.text_flow_root_text_input_height'))
          .padding({
            left: $r('app.integer.text_flow_root_text_input_padding_left'),
            right: $r('app.integer.text_flow_root_text_input_padding_right'),
            top: $r('app.integer.text_flow_root_text_input_padding_top'),
            bottom: $r('app.integer.text_flow_root_text_input_padding_bottom')
          })
          .margin({
            right: $r('app.integer.text_flow_root_text_input_margin_right')
          })
          .onChange((textInComment: string) => {
            this.text = textInComment;
          })
          .defaultFocus(true)
          .alignRules({
            // 性能知识点：使用相对布局组件RelativeContainer，子组件通过alignRules接口将父组件或者其他组件设为锚点，可使布局扁平化，有利于性能提升
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: ID_TEXT_PUSH, align: HorizontalAlign.Start }
          })
          .id(ID_TEXT_INPUT)

        Button($r("app.string.text_flow_publish"))
          .width($r('app.integer.text_flow_root_btn_width'))
          .height($r('app.integer.text_flow_root_btn_height'))
          .borderRadius(15)
          .backgroundColor($r('app.color.text_flow_color_red'))
          .fontColor(Color.White)
          .onClick(() => {
            if (this.controller) {
              this.textInComment = this.text;
              this.publish();
              this.controller.close();
              this.textInComment = "";
              promptAction.showToast({ message: $r('app.string.text_flow_reply_success') });
            }
          })
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_TEXT_PUSH)
      }
      .height($r('app.integer.text_flow_relative_container_height'))
    }
    .padding($r('app.integer.text_flow_column_padding'))
    .backgroundColor(Color.White)
    .offset({
      y: 20
    }) // 添加y轴偏移量，否则弹窗和输入法间会有空白
  }
}