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
 * 实现步骤：
 * 1.在native侧通过调用pread系统函数实现GetTotalRawFileContent接口读取rawfile文件全部内容、GetRawFileContent接口读取rawfile文件部分内容接口，导出接口。
 * 2.在native侧使用dlopen加载libnativerawfile.so获得句柄，通过句柄获取so库中的接口并暴露GetTotalRawFileContent接口和GetRawFileContent接口给ArkTS层。
 * 3.导入common模块的公共组件FunctionDescription。
 * 4.前端调用GetTotalRawFileContent与GetRawFileContent接口获取rawfile文件内容。
 */

import promptAction from '@ohos.promptAction';
import nativeRawfileApi from 'libnativerawfileapi.so';
import { AppRouter } from 'routermodule';

let rawfileTotalContent: string = "";

@AppRouter({ name: "nativerawfile/NativeRawfileDemo" })
@Component
export struct NativeRawfileDemo {
  @State ReadStartPos: number = 2;
  @State readLength: number = 5;
  @State rawfileContent: string = '';
  @State buttonEnabledStatus: boolean = true;
  private rawfileName: string = 'rawfile.txt';

  async aboutToAppear() {
    // TODO：知识点：通过Native暴露的接口getRawFileContent读取文件部分内容，getTotalRawFileContent接口读取文件全部内容
    this.rawfileContent = nativeRawfileApi.getRawFileContent(getContext()
      .resourceManager, this.rawfileName, this.ReadStartPos, this.readLength);
    rawfileTotalContent = nativeRawfileApi.getTotalRawFileContent(getContext().resourceManager, this.rawfileName);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.nativerawfile_rawFileContent'))
          .width('35%')
          .align(Alignment.End)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Normal)
          .margin($r('app.string.nativerawfile_margin'))
        Text(rawfileTotalContent)
          .id('rawFileContent')
          .width('50%')
          .fontWeight(FontWeight.Normal)
          .margin($r('app.string.nativerawfile_margin'))
      }
      .width('100%')

      Row() {
        Text($r('app.string.nativerawfile_ReadStartPos'))
          .width('35%')
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Normal)
          .margin($r('app.string.nativerawfile_margin'))
          .align(Alignment.End)
        TextInput({ text: this.ReadStartPos.toString() })
          .id('startPos')
          .width('50%')
          .type(InputType.Number)
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: $r('app.string.nativerawfile_font_size_14') })
          .caretColor(Color.Blue)
          .margin($r('app.string.nativerawfile_margin'))
          .fontColor(Color.Black)
          .onChange((value: string) => {
            if (value === '') {
              this.buttonEnabledStatus = false;
            } else {
              this.ReadStartPos = Number(value);
              if (rawfileTotalContent.length <= this.ReadStartPos) {
                promptAction.showToast({
                  message: `读取位置取值范围0-${rawfileTotalContent.length - 1}`
                });
                this.buttonEnabledStatus = false;
              } else {
                this.buttonEnabledStatus = true;
              }
            }
          })
      }
      .width('100%')

      Row() {
        Text($r('app.string.nativerawfile_ReadLength'))
          .width('35%')
          .fontWeight(FontWeight.Normal)
          .margin($r('app.string.nativerawfile_margin'))
          .textAlign(TextAlign.End)
          .align(Alignment.End)
        TextInput({ text: this.readLength.toString() })
          .id('readLen')
          .width('50%')
          .type(InputType.Number)
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: $r('app.string.nativerawfile_font_size_14') })
          .caretColor(Color.Blue)
          .margin($r('app.string.nativerawfile_margin'))
          .fontColor(Color.Black)
          .onChange((value: string) => {
            if (value === '') {
              this.buttonEnabledStatus = false;
            } else {
              this.readLength = Number(value);
              if (rawfileTotalContent.length < this.readLength + this.ReadStartPos) {
                promptAction.showToast({
                  message: $r('app.string.nativerawfile_ReadLength_toast')
                });
                this.buttonEnabledStatus = false;
              } else {
                this.buttonEnabledStatus = true;
              }
            }
          })
      }
      .width('100%')

      Row() {
        Text($r('app.string.nativerawfile_ReadResult'))
          .width('35%')
          .fontWeight(FontWeight.Normal)
          .margin($r('app.string.nativerawfile_margin'))
          .textAlign(TextAlign.End)
          .align(Alignment.Start)
        Text(this.rawfileContent)
          .id('readResult')
          .width('50%')
          .fontWeight(FontWeight.Normal)
          .margin($r('app.string.nativerawfile_margin'))
          .align(Alignment.Start)
      }
      .width('100%')
      .margin($r('app.string.ohos_id_elements_margin_vertical_m'))

      Button($r('app.string.nativerawfile_ReadButton'))
        .id('btnReadRawFile')
        .onClick(() => {
          this.rawfileContent = nativeRawfileApi.getRawFileContent(getContext()
            .resourceManager, this.rawfileName, this.ReadStartPos, this.readLength);
        })
        .margin($r('app.string.nativerawfile_margin'))
        .enabled(this.buttonEnabledStatus)
    }
    .backgroundColor('#FFFFFF')
    .border({
      width: 1,
      color: $r('app.color.nativerawfile_border_color'),
      radius: $r('app.string.nativerawfile_radius'),
      style: BorderStyle.Solid
    })
    .borderRadius($r('app.string.nativerawfile_borderRadius'))
    .padding($r('app.string.nativerawfile_padding'))
    .margin($r('app.string.nativerawfile_margin12'))
  }
}
