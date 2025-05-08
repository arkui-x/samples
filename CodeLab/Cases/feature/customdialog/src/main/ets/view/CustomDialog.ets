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

import window from '@ohos.window';
import * as api from '../components/SubWindowApi'; // 导入命名路由页面
import { hideApiSubWindow, showApiSubWindow } from '../components/SubWindowFunction';
import { common } from '@kit.AbilityKit';
import { Dialog } from '../components/Dialog'
import { PlatformInfo } from 'utils';

const context = getContext(this) as common.UIAbilityContext; // 获取当前页面的上下文

@Component
export struct CustomDialogComponent {
  @State visible: boolean = false;
  @StorageLink('windowStage') windowStage: window.WindowStage | undefined =
    AppStorage.get('windowStage'); //获取windowStage
  private SubWindowApi: api.SubWindowApi | null = null; //初始化SubWindowApi对象

  aboutToAppear() {
    if (this.windowStage) {
      this.SubWindowApi = new api.SubWindowApi();
    }
    showApiSubWindow(this.SubWindowApi, this.windowStage);
  }

  aboutToDisappear(): void {
    if (PlatformInfo.isArkUIX()) {
      if (this.SubWindowApi) {
        hideApiSubWindow(this.SubWindowApi)
      } else {
        if (this.windowStage) {
          this.SubWindowApi = new api.SubWindowApi();
        }
        hideApiSubWindow(this.SubWindowApi)
      }
    }
  }

  build() {
    Column({ space: context.resourceManager.getNumber($r('app.integer.custom_dialog_elements_margin').id) }) {
      Text($r('app.string.custom_dialog_title'))
        .fontSize($r('app.integer.custom_dialog_title_font_size'))
        .fontColor($r('app.color.ohos_id_color_palette_aux9'))
      Row() {
        Image($r('app.media.custom_dialog_blue_pocket_icon'))
          .height($r('app.integer.custom_dialog_icon_size'))
          .width($r('app.integer.custom_dialog_icon_size'))
        Text() {
          Span($r('app.string.custom_dialog_sum'))
            .fontSize($r('app.integer.custom_dialog_content_font_size'))
            .fontColor($r('app.color.ohos_id_color_background'))
          Span($r('app.string.custom_dialog_yuan'))
            .fontSize($r('app.integer.custom_dialog_content_font_size2'))
            .fontColor($r('app.color.ohos_id_color_background'))
        }

        Button($r('app.string.custom_dialog_withdrawal'))
          .fontSize($r('app.integer.custom_dialog_content_font_size2'))
          .fontColor($r('app.color.ohos_id_color_foreground'))
          .height($r('app.integer.custom_dialog_button_height'))
          .width($r('app.integer.custom_dialog_button_width'))
          .backgroundColor($r('app.color.ohos_id_color_palette11'))
          .onClick(() => {
            this.visible = !this.visible;
          })
        Image($r('app.media.custom_dialog_red_pocket_icon'))
          .height($r('app.integer.custom_dialog_icon_size'))
          .width($r('app.integer.custom_dialog_icon_size'))
        Text() {
          Span($r('app.string.custom_dialog_sum'))
            .fontSize($r('app.integer.custom_dialog_content_font_size'))
            .fontColor($r('app.color.ohos_id_color_background'))
          Span($r('app.string.custom_dialog_yuan'))
            .fontSize($r('app.integer.custom_dialog_content_font_size2'))
            .fontColor($r('app.color.ohos_id_color_background'))
        }

        Button($r('app.string.custom_dialog_withdrawal'))
          .fontSize($r('app.integer.custom_dialog_content_font_size2'))
          .fontColor($r('app.color.ohos_id_color_foreground'))
          .height($r('app.integer.custom_dialog_button_height'))
          .width($r('app.integer.custom_dialog_button_width'))
          .backgroundColor($r('app.color.ohos_id_color_palette11'))
          .onClick(() => {
            this.visible = !this.visible;
          })
        Dialog({
          visible: $visible
        })
      }
      .height($r('app.integer.custom_dialog_row_height'))
      .justifyContent(FlexAlign.SpaceAround)
      .width($r('app.integer.custom_dialog_row_width'))
      .borderRadius($r('app.integer.custom_dialog_border_radius'))
      .backgroundColor($r('app.color.ohos_id_color_text_secondary'))

      Stack({ alignContent: Alignment.Top }) {
        Column() {
          Button($r('app.string.custom_dialog_content'))
            .fontColor($r('app.color.ohos_id_color_foreground'))
            .backgroundColor($r('app.color.ohos_id_color_palette11'))
            .fontSize($r('app.integer.custom_dialog_content_font_size'))
            .height($r('app.integer.custom_dialog_button_height2'))
            .width($r('app.integer.custom_dialog_button_width2'))
            .margin({ bottom: $r('app.integer.custom_dialog_button_margin') })
            .onClick(() => {
              if (PlatformInfo.isArkUIX()) {
                if (this.SubWindowApi) {
                  showApiSubWindow(this.SubWindowApi, this.windowStage);
                } else {
                  if (this.windowStage) {
                    this.SubWindowApi = new api.SubWindowApi();
                  }
                  showApiSubWindow(this.SubWindowApi, this.windowStage);
                }
              } else {
                if (this.windowStage) {
                  this.SubWindowApi = new api.SubWindowApi();
                }
                  showApiSubWindow(this.SubWindowApi, this.windowStage);
              }
            })
        }
        .height($r('app.integer.custom_dialog_column_height'))
        .width($r('app.integer.custom_dialog_column_width'))
        .backgroundColor($r('app.color.custom_dialog_packet_color'))
        .borderRadius($r('app.integer.custom_dialog_border_radius2'))
        .offset({
          x: $r('app.integer.custom_dialog_offset_x'),
          y: $r('app.integer.custom_dialog_offset_y')
        })
        .justifyContent(FlexAlign.End)

        Column() {
          Text($r('app.string.custom_dialog_content2'))
            .fontSize($r('app.integer.custom_dialog_content_font_size'))
            .margin({ bottom: $r('app.integer.custom_dialog_button_margin2') })
          Text() {
            Span($r('app.string.custom_dialog_sum2'))
              .fontSize($r('app.integer.custom_dialog_content_font_size3'))
            Span($r('app.string.custom_dialog_yuan'))
              .fontSize($r('app.integer.custom_dialog_content_font_size'))
          }
        }
        .borderRadius($r('app.integer.custom_dialog_border_radius2'))
        .backgroundColor($r('app.color.ohos_id_color_palette11'))
        .height($r('app.integer.custom_dialog_column_height2'))
        .width($r('app.integer.custom_dialog_column_width2'))
        .justifyContent(FlexAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
    .backgroundImage($r('app.media.custom_dialog_background'))
    .backgroundImageSize(ImageSize.Cover)
    .padding($r('app.integer.custom_dialog_padding'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}
