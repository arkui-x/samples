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

import { DialogBuilderParam } from "../../dialog/dto/DialogBuilderParam"
import { FileItem, FileType } from "../dto/FileItem"
import { promptAction } from "@kit.ArkUI";
import { PlatformTypeEnum, PlatformInfo } from 'utils'

@Component
export struct AddFileComponent {
  @Prop param: DialogBuilderParam;
  fileName: string = '';
  fileType: FileType = FileType.WORD;
  typeArr: FileType[] = [FileType.PPT, FileType.WORD, FileType.EXCEL, FileType.IMAGE];
  index: number = 1;

  build() {
    Column() {
      Text($r('app.string.encapsulation_dialog_new_file'))
        .fontSize($r('app.integer.encapsulation_dialog_integer_20'))
        .fontColor(Color.Black)
        .margin({
          top: $r('app.integer.encapsulation_dialog_integer_22')
        })
      Row() {
        Text($r('app.string.encapsulation_dialog_file_name',""))
          .fontSize($r('app.integer.encapsulation_dialog_integer_18'))
        TextInput()
          .onChange((value: string) => {
            this.fileName = value;
          })
          .layoutWeight(1)
          .backgroundColor($r('app.color.encapsulation_dialog_color_F5F7FA'))
          .borderRadius($r('app.integer.encapsulation_dialog_integer_40'))
      }
      .alignItems(VerticalAlign.Center)
      .width($r('app.string.encapsulation_dialog_hundred_percent'))
      .padding({ left: $r('app.integer.encapsulation_dialog_integer_20'), right: $r('app.integer.encapsulation_dialog_integer_20') })
      .margin({ top: $r('app.integer.encapsulation_dialog_integer_22') })

      Row() {
        Text($r('app.string.encapsulation_dialog_file_type_',""))
          .fontSize($r('app.integer.encapsulation_dialog_integer_18'))
        Select([{ value: FileType.PPT },
          { value: FileType.WORD },
          { value: FileType.EXCEL },
          { value: FileType.IMAGE }])
          .selected(this.index)
          .value(this.fileType)
          .font({ size: $r('app.integer.encapsulation_dialog_integer_14'), weight: 500 })
          .fontColor($r('app.color.encapsulation_dialog_color_182431'))
          .selectedOptionFont({ size: $r('app.integer.encapsulation_dialog_integer_16'), weight: 400 })
          .optionFont({ size: $r('app.integer.encapsulation_dialog_integer_16'), weight: 400 })
          .arrowPosition(ArrowPosition.END)
          .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
          .optionWidth($r('app.integer.encapsulation_dialog_integer_200'))
          .optionHeight($r('app.integer.encapsulation_dialog_integer_300'))
          .divider(null)
          .borderRadius($r('app.integer.encapsulation_dialog_integer_6'))
          .borderWidth($r('app.integer.encapsulation_dialog_integer_1'))
          .borderColor(Color.Grey)
          .backgroundColor(Color.White)
          .height($r('app.integer.encapsulation_dialog_integer_30'))
          .width($r('app.integer.encapsulation_dialog_integer_120'))
          .onSelect((index: number) => {
            this.fileType = this.typeArr[index];
            this.index = index;
          })
      }.width($r('app.string.encapsulation_dialog_hundred_percent'))
      .padding({ left: $r('app.integer.encapsulation_dialog_integer_20'), right: $r('app.integer.encapsulation_dialog_integer_20') })
      .margin({ top: $r('app.integer.encapsulation_dialog_integer_10') })

      Row() {
        Button($r('app.string.encapsulation_dialog_ok'))
          .width($r('app.integer.encapsulation_dialog_integer_88'))
          .height($r('app.integer.encapsulation_dialog_integer_42'))
          .backgroundColor($r('app.color.encapsulation_dialog_color_3C7CFC'))
          .fontColor(Color.White)
          .borderRadius($r('app.integer.encapsulation_dialog_integer_30'))
          .onClick(() => {
            if (this.fileName === '') {
              promptAction.showToast({ message: $r('app.string.encapsulation_dialog_file_name_not_empty') });
              return;
            }
            this.param.onConfirm!(true, new FileItem(this.fileName, this.fileType));
          })
        Button($r('app.string.encapsulation_dialog_cancel'))
          .width($r('app.integer.encapsulation_dialog_integer_88'))
          .height($r('app.integer.encapsulation_dialog_integer_42'))
          .fontColor(Color.Black)
          .backgroundColor(Color.White)
          .borderRadius($r('app.integer.encapsulation_dialog_integer_30'))
          .margin({
            left: $r('app.integer.encapsulation_dialog_integer_40')
          })
          .onClick(() => {
            this.param.closeDialog!();
          })
      }
      .justifyContent(FlexAlign.Center)
      .width($r('app.string.encapsulation_dialog_hundred_percent'))
      .margin({
        top: $r('app.integer.encapsulation_dialog_integer_22')
      })
    }
    .height($r('app.integer.encapsulation_dialog_integer_240'))
    .width($r('app.integer.encapsulation_dialog_integer_360'))
    .width(PlatformInfo.isArkUIX() ? "90%" : $r('app.integer.encapsulation_dialog_integer_360'))
    .backgroundColor(Color.White)
    .borderRadius($r('app.integer.encapsulation_dialog_integer_20'))
    .clip(true)
  }
}