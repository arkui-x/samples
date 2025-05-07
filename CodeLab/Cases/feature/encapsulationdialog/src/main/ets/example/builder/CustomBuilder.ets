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

import { AddFileComponent } from "../components/AddFileComponent";
import { DialogBuilderParam } from "../../dialog/dto/DialogBuilderParam";
import { FileType } from "../dto/FileItem";
import { PlatformTypeEnum, PlatformInfo } from 'utils'


@Builder
export function addFileDialogBuilder(param: DialogBuilderParam) {
  AddFileComponent({ param: param })
}

@Builder
export function siftFileDialogBuilder(param: DialogBuilderParam) {
  if (PlatformInfo.isArkUIX()) {
    Column() {
      Text($r('app.string.encapsulation_dialog_file_type'))
        .fontSize($r('app.integer.encapsulation_dialog_integer_20'))
        .fontColor(Color.Black)
      Blank()
      Divider()
        .width($r('app.string.encapsulation_dialog_hundred_percent'))
        .strokeWidth(1)
        .color($r('app.color.encapsulation_dialog_color_E5E5E5'))
      Blank()
      Row() {
        siftItem(param, $r("app.media.encapsulation_dialog_ppt"), FileType.PPT)
        siftItem(param, $r("app.media.encapsulation_dialog_png"), FileType.IMAGE)
        siftItem(param, $r("app.media.encapsulation_dialog_word"), FileType.WORD)
        siftItem(param, $r("app.media.encapsulation_dialog_excel"), FileType.EXCEL)
      }
      .width($r('app.string.encapsulation_dialog_hundred_percent'))
      .padding({
        left: $r('app.integer.encapsulation_dialog_integer_20'),
        right: $r('app.integer.encapsulation_dialog_integer_20')
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      Blank()
      Button($r('app.string.encapsulation_dialog_clear'))
        .backgroundColor($r('app.color.encapsulation_dialog_color_3C7CFC'))
        .fontColor(Color.White)
        .fontSize($r('app.integer.encapsulation_dialog_integer_18'))
        .height($r('app.integer.encapsulation_dialog_integer_42'))
        .width($r('app.integer.encapsulation_dialog_integer_137'))
        .onClick(() => {
          param.onConfirm!(true, FileType.UN_KNOWN);
        })
    }
    .borderRadius($r('app.integer.encapsulation_dialog_integer_10'))
    .width($r('app.string.encapsulation_dialog_hundred_percent'))
    .height($r('app.string.encapsulation_dialog_percent_32'))
    .backgroundColor(Color.White)
    .padding({
      top: px2vp(param.data.topHeight),
      bottom: $r('app.integer.encapsulation_dialog_integer_16')
    })
  } else {
    Column() {
      Text($r('app.string.encapsulation_dialog_file_type'))
        .margin({
          top: $r('app.integer.encapsulation_dialog_integer_10')
        })
        .fontSize($r('app.integer.encapsulation_dialog_integer_20'))
        .fontColor(Color.Black)
      Divider()
        .margin({
          top: $r('app.integer.encapsulation_dialog_integer_15')
        })
        .width($r('app.string.encapsulation_dialog_hundred_percent'))
        .strokeWidth(1)
        .color($r('app.color.encapsulation_dialog_color_E5E5E5'))
      Row() {
        siftItem(param, $r("app.media.encapsulation_dialog_ppt"), FileType.PPT)
        siftItem(param, $r("app.media.encapsulation_dialog_png"), FileType.IMAGE)
        siftItem(param, $r("app.media.encapsulation_dialog_word"), FileType.WORD)
        siftItem(param, $r("app.media.encapsulation_dialog_excel"), FileType.EXCEL)
      }
      .width($r('app.string.encapsulation_dialog_hundred_percent'))
      .margin({
        top: $r('app.integer.encapsulation_dialog_integer_15')
      })
      .padding({
        left: $r('app.integer.encapsulation_dialog_integer_20'),
        right: $r('app.integer.encapsulation_dialog_integer_20')
      })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Button($r('app.string.encapsulation_dialog_clear'))
        .backgroundColor($r('app.color.encapsulation_dialog_color_3C7CFC'))
        .fontColor(Color.White)
        .fontSize($r('app.integer.encapsulation_dialog_integer_18'))
        .height($r('app.integer.encapsulation_dialog_integer_42'))
        .width($r('app.integer.encapsulation_dialog_integer_137'))
        .margin({
          top: $r('app.integer.encapsulation_dialog_integer_13')
        })
        .onClick(() => {
          param.onConfirm!(true, FileType.UN_KNOWN);
        })
    }
    .borderRadius($r('app.integer.encapsulation_dialog_integer_10'))
    .width($r('app.string.encapsulation_dialog_hundred_percent'))
    .height($r('app.string.encapsulation_dialog_percent_32'))
    .backgroundColor(Color.White)
    .padding({
      top: px2vp(param.data.topHeight),
      bottom: $r('app.integer.encapsulation_dialog_integer_16')
    })
  }
}

@Builder
function siftItem(param: DialogBuilderParam, icon: Resource, fileType: FileType) {
  Column({ space: 5 }) {
    Image(icon)
      .height($r('app.integer.encapsulation_dialog_integer_48'))
      .width($r('app.integer.encapsulation_dialog_integer_48'))
    Text(fileType)
      .fontSize($r('app.integer.encapsulation_dialog_integer_18'))
      .fontColor(param.data.siftType === fileType ? Color.White : Color.Black)
  }
  .onClick(() => {
    param.onConfirm!(true, fileType);
  })
  .padding($r('app.integer.encapsulation_dialog_integer_10'))
  .borderRadius($r('app.integer.encapsulation_dialog_integer_10'))
  .backgroundColor(param.data.siftType === fileType ? Color.Green : undefined)
}

@Builder
export function deleteConfirmDialogBuilder(param: DialogBuilderParam) {
  Column({ space: 8 }) {
    Text($r('app.string.encapsulation_dialog_tips'))
      .fontSize($r('app.integer.encapsulation_dialog_integer_24'))
      .fontColor(Color.Black)
      .margin({
        top: $r('app.integer.encapsulation_dialog_integer_22')
      })
    Text($r('app.string.encapsulation_dialog_sure_to_delete'))
      .fontSize($r('app.integer.encapsulation_dialog_integer_20'))
      .fontColor($r('app.color.encapsulation_dialog_color_383838'))
      .margin({
        top: $r('app.integer.encapsulation_dialog_integer_26')
      })
    Row() {
      Button($r('app.string.encapsulation_dialog_ok'))
        .width($r('app.integer.encapsulation_dialog_integer_88'))
        .height($r('app.integer.encapsulation_dialog_integer_42'))
        .backgroundColor($r('app.color.encapsulation_dialog_color_3C7CFC'))
        .fontColor(Color.White)
        .borderRadius($r('app.integer.encapsulation_dialog_integer_30'))
        .onClick(() => {
          param.onConfirm!(true);
        })

      Button($r('app.string.encapsulation_dialog_cancel'))
        .width($r('app.integer.encapsulation_dialog_integer_88'))
        .height($r('app.integer.encapsulation_dialog_integer_42'))
        .fontColor(Color.Black)
        .backgroundColor(Color.White)
        .borderRadius($r('app.integer.encapsulation_dialog_integer_30'))
        .fontColor(Color.Black)
        .margin({
          left: $r('app.integer.encapsulation_dialog_integer_40')
        })
        .onClick(() => {
          param.closeDialog!();
        })
    }
    .margin({ top: $r('app.integer.encapsulation_dialog_integer_25') })
    .width($r('app.string.encapsulation_dialog_hundred_percent'))
    .justifyContent(FlexAlign.Center)
  }
  .backgroundColor(Color.White)
  .width($r('app.integer.encapsulation_dialog_integer_340'))
  .height($r('app.integer.encapsulation_dialog_integer_200'))
  .borderRadius($r('app.integer.encapsulation_dialog_integer_20'))
}

@Builder
export function fileInfoDialogBuilder(param: DialogBuilderParam) {
  Column() {
    Stack({ alignContent: Alignment.TopEnd }) {
      // 关闭按钮
      Button({ type: ButtonType.Circle, stateEffect: true }) {
        Image($r("app.media.encapsulation_dialog_close_button"))
          .width($r('app.integer.encapsulation_dialog_integer_32'))
          .height($r('app.integer.encapsulation_dialog_integer_32'))
          .id("close_button")
      }
      .backgroundColor($r('app.color.encapsulation_dialog_color_FEFEFE'))
      .width($r('app.integer.encapsulation_dialog_integer_20'))
      .height($r('app.integer.encapsulation_dialog_integer_20'))
      .margin({ left: $r('app.integer.encapsulation_dialog_integer_300') })
      .onClick(() => {
        param.closeDialog!();
      })
    }.margin({ top: $r('app.integer.encapsulation_dialog_integer_25') })
    Column() {
      Image(param.data.icon)
        .width($r('app.integer.encapsulation_dialog_integer_100'))
        .height($r('app.integer.encapsulation_dialog_integer_100'))
      Text(param.data.name)
        .fontColor(Color.Black)
        .fontSize($r('app.integer.encapsulation_dialog_integer_18'))
        .margin({ top: $r('app.integer.encapsulation_dialog_integer_23') })
      Text($r('app.string.encapsulation_dialog_file_type_', param.data.type))
        .fontColor(Color.Black)
        .fontSize($r('app.integer.encapsulation_dialog_integer_16'))
        .margin({ top: $r('app.integer.encapsulation_dialog_integer_30') })
      Text($r('app.string.encapsulation_dialog_file_size_', param.data.size))
        .fontColor(Color.Black)
        .fontSize($r('app.integer.encapsulation_dialog_integer_16'))
        .margin({ top: $r('app.integer.encapsulation_dialog_integer_8') })
      Text($r('app.string.encapsulation_dialog_file_update_time_', param.data.time))
        .fontSize($r('app.integer.encapsulation_dialog_integer_14'))
        .fontColor($r('app.color.encapsulation_dialog_color_A6A6A6'))
        .margin({ top: $r('app.integer.encapsulation_dialog_integer_20') })
    }
    .layoutWeight(1)
  }
  .width($r('app.string.encapsulation_dialog_hundred_percent'))
  .height(PlatformInfo.isArkUIX() ?
          px2vp((param.data.screenHeight * 0.4) + (param.data.bottomHeight * 0.8)) :
          $r('app.string.encapsulation_dialog_percent_40'))
  .backgroundColor(Color.White)
  .borderRadius({
    topLeft: $r('app.integer.encapsulation_dialog_integer_10'),
    topRight: $r('app.integer.encapsulation_dialog_integer_10')
  })
}