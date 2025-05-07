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

import emitter from '@ohos.events.emitter';
import promptAction from '@ohos.promptAction';
export const entryName: string = 'LoadContent';

const EVENT_ID = 1234565; // 持续订阅事件ID
const DURATION = 400; // 动画时间
const IMAGE_SCALE = 0.8; // 弹窗画面缩放大小

@Entry({
  routeName: entryName,
  storage: LocalStorage.getShared()
}) // window单独加载的命名路由页面: LoadContent
@Component
export struct LoadContent {
  @LocalStorageLink('content') content: string = '';
  build() {
    Column() {
      Row() {
        Image($r('app.media.custom_dialog_cancel_icon'))
          .height($r('app.integer.custom_dialog_image_size'))
          .width($r('app.integer.custom_dialog_image_size'))
          .onClick(() => {
            const event: emitter.InnerEvent = {
              eventId: EVENT_ID
            }
            // 触发回调，关闭弹窗
            emitter.emit(event);
          })
          .id('close_button')
      }
      .height($r('app.integer.custom_dialog_row_height2'))
      .width($r('app.integer.custom_dialog_row_width2'))
      .padding({ bottom: $r('app.integer.custom_dialog_padding') })
      .justifyContent(FlexAlign.End)
      Stack() {
        Image($r('app.media.custom_dialog_red_envelope'))
          .height($r('app.integer.custom_dialog_image_height'))
          .width($r('app.integer.custom_dialog_row_width2'))
          .borderRadius($r('app.integer.custom_dialog_border_radius2'))
        Column() {
          Text() {
            Span(this.content)
              .fontSize($r('app.integer.custom_dialog_content_font_size3'))
            Span($r('app.string.custom_dialog_yuan'))
              .fontSize($r('app.integer.custom_dialog_content_font_size'))
          }
          Button($r('app.string.custom_dialog_content3'))
            .fontSize($r('app.integer.custom_dialog_content_font_size'))
            .fontColor($r('app.color.ohos_id_color_foreground'))
            .backgroundColor($r('app.color.ohos_id_color_palette11'))
            .onClick(() => {
              promptAction.showToast({
                message: $r('app.string.custom_dialog_prompt_text')
              });
            })
        }
        .height($r('app.integer.custom_dialog_column_height3'))
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: $r('app.integer.custom_dialog_column_margin') })
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .transition(TransitionEffect.OPACITY.animation({
      duration: DURATION,
      curve: Curve.Ease
    }).combine(TransitionEffect.scale({
      x: IMAGE_SCALE,
      y: IMAGE_SCALE
    })))
  }
}