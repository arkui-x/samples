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

@CustomDialog
export struct CustomDialogView {
  @Link visible: boolean;
  controller: CustomDialogController;
  // 弹窗交互事件参数，点击确认和取消按钮时的回调函数
  onCancel?: () => void;
  onConfirm?: () => void;

  build() {
    Column() {
      Text($r('app.string.custom_dialog_bind_card'))
        .fontSize($r('app.integer.custom_dialog_content_font_size'))
        .padding({ top: $r('app.string.ohos_id_card_padding_start') })
      Row() {
        Button($r('app.string.custom_dialog_cancel'))
          .backgroundColor($r('app.color.ohos_id_color_background'))
          .fontColor($r('app.color.ohos_id_color_emphasize'))
          .fontSize($r('app.integer.custom_dialog_content_font_size'))
          .width($r('app.integer.custom_dialog_button_width3'))
          .onClick(() => {
            this.visible = false;
            this.onCancel?.();
          })
        Button($r('app.string.custom_dialog_goto'))
          .backgroundColor($r('app.color.ohos_id_color_background'))
          .fontColor($r('app.color.ohos_id_color_emphasize'))
          .fontSize($r('app.integer.custom_dialog_content_font_size'))
          .width($r('app.integer.custom_dialog_button_width3'))
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.custom_dialog_prompt_text')
            });
          })
      }
      .justifyContent(FlexAlign.Center)
    }
    .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.ohos_id_color_background'))
    .height($r('app.integer.custom_dialog_column_height3'))
    .width($r('app.integer.custom_dialog_column_width'))
  }
}