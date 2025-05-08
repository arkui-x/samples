/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { EncapsulateDialogBuilderParam } from '../dto/EncapsulateDialogBuilderParam';
import { DialogTypeEnum } from '../enum/DialogTypeEnum';

@Builder
export function DialogBuilder(param: EncapsulateDialogBuilderParam) {
  Stack({ alignContent: getAlignment(param.dialogType) }) {
    Stack()
      .width($r('app.string.encapsulation_dialog_hundred_percent'))
      .height($r('app.string.encapsulation_dialog_percent_300'))
      .backgroundColor($r('app.color.encapsulation_dialog_color_33000000'))
      .onClick(() => {
        if (param.isModalClosedByOverlayClick) {
          param.closeDialog!();
        }
      })
    param.builder.builder({ onConfirm: param.onConfirm, closeDialog: param.closeDialog, data: param.data })

  }.width($r('app.string.encapsulation_dialog_hundred_percent'))
  .height($r('app.string.encapsulation_dialog_hundred_percent'))
}

function getAlignment(dialogType: DialogTypeEnum): Alignment {
  switch (dialogType) {
    case DialogTypeEnum.BOTTOM:
      return Alignment.Bottom;
    case DialogTypeEnum.CENTER:
      return Alignment.Center;
    case DialogTypeEnum.TOP:
      return Alignment.Top;
    default:
      return Alignment.Center;
  }
}