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

import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { BridgeUtil, PlatformInfo, PreferenceManager } from 'utils';
import { CommonConstants } from '../constants/CommonConstants';

import('./PrivacyAgreementPage');

/*
 * 用户隐私弹窗
 * */
@CustomDialog
export struct PrivacyAgreementDialog {
  @StorageLink('isAgree') isAgree: boolean = false;
  @State isSheetShow: boolean = false;
  @State agreementSrc: string = '';
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();
  dialogController?: CustomDialogController;

  /*
   * 展示用户协议与隐私协议
   * */
  implicitStartAbility(name: string, uri: string) {
    router.pushNamedRoute({
      name: 'PrivacyAgreementPage',
      params: new Object({ name: name, uri: uri })
    });
  }

  build() {
    Column() {
      Text($r('app.string.privacy_agreement_dialog_title'))
        .fontWeight(700)
        .fontSize($r('app.integer.privacy_agreement_dialog_title_font_size'))
        .margin({ top: $r('app.integer.privacy_agreement_dialog_title_font_margin') })
      Column() {
        Text() {
          Span($r('app.string.privacy_agreement_dialog_content1'))
            .fontWeight(400)
            .fontColor($r('app.color.privacy_agreement_dialog_font_color1'))
            .fontSize($r('app.integer.privacy_agreement_dialog_content_font_size'))
          Span($r('app.string.privacy_agreement_dialog_content2'))
            .fontWeight(400)
            .fontColor($r('app.color.privacy_agreement_dialog_font_color2'))
            .onClick(() => {
              this.implicitStartAbility('用户协议', CommonConstants.USER_AGREEMENT_WEB_URL);
            })
            .fontColor(Color.Blue)
            .fontSize($r('app.integer.privacy_agreement_dialog_content_font_size'))
          Span($r('app.string.privacy_agreement_dialog_content3'))
            .fontWeight(400)
            .fontColor($r('app.color.privacy_agreement_dialog_font_color1'))
            .fontSize($r('app.integer.privacy_agreement_dialog_content_font_size'))
          Span($r('app.string.privacy_agreement_dialog_content4'))
            .fontWeight(400)
            .fontColor($r('app.color.privacy_agreement_dialog_font_color2'))
            .onClick(() => {
              this.implicitStartAbility('隐私协议', CommonConstants.PRIVACY_AGREEMENT_WEB_URL);
            })
            .fontColor(Color.Blue)
            .fontSize($r('app.integer.privacy_agreement_dialog_content_font_size'))
          Span($r('app.string.privacy_agreement_dialog_content6'))
            .fontWeight(400)
            .fontColor($r('app.color.privacy_agreement_dialog_font_color1'))
            .fontSize($r('app.integer.privacy_agreement_dialog_content_font_size'))
        }
        .textAlign(TextAlign.JUSTIFY)
        .lineHeight($r('app.integer.privacy_agreement_dialog_content_text_line_height'))

        Text($r('app.string.privacy_agreement_dialog_content5'))
          .fontWeight(400)
          .fontColor($r('app.color.privacy_agreement_dialog_font_color1'))
          .fontSize($r('app.integer.privacy_agreement_dialog_content_font_size'))
          .lineHeight($r('app.integer.privacy_agreement_dialog_content_text_line_height'))
          .margin({ top: 16 })
          .textAlign(TextAlign.JUSTIFY)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: $r('app.integer.privacy_agreement_dialog_content_column_margin') })

      Row() {
        Button($r('app.string.privacy_agreement_dialog_confirm'))
          .shadow({
            radius: 4,
            offsetX: 2,
            offsetY: 2,
            color: $r('app.color.privacy_agreement_dialog_button_confirm')
          })
          .borderRadius($r('app.integer.privacy_agreement_dialog_button_border_radius'))
          .width($r('app.integer.privacy_agreement_dialog_confirm_button_width'))
          .height($r('app.integer.privacy_agreement_dialog_button_confirm_height'))
          .backgroundColor('#3C7CFC')
          .fontColor(Color.White)
          .fontSize($r('app.integer.privacy_agreement_dialog_button_font_size'))
          .fontWeight(700)
          .id('btn_privacy_agreement')
          .onClick(() => {
            this.preferenceManager.setValue('isConfirmPrivacyAgreement', true)
            this.isAgree = true;
            this.dialogController?.close();
          })
        Text($r('app.string.privacy_agreement_dialog_refuse'))
          .fontSize($r('app.integer.privacy_agreement_dialog_button_refuse_font_size'))
          .fontWeight(400)
          .fontColor($r('app.color.privacy_agreement_dialog_button_refuse_font_color'))
          .margin({ left: $r('app.integer.privacy_agreement_dialog_content_column_margin') })
          .onClick(() => {
            this.preferenceManager.setValue('isConfirmPrivacyAgreement', false)
            this.isAgree = false;
            let context = getContext() as common.UIAbilityContext;
            context.terminateSelf();
            if (PlatformInfo.isArkUIX()) {
              BridgeUtil.getInstance().exit()
            }
          })
      }
      .margin({ top: $r('app.integer.privacy_agreement_dialog_button_margin') })
    }
    .borderRadius($r('app.integer.privacy_agreement_dialog_border_radius'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.integer.privacy_agreement_dialog_button_padding'),
      right: $r('app.integer.privacy_agreement_dialog_button_padding')
    })
    .width($r('app.integer.privacy_agreement_dialog_width'))
    .height($r('app.integer.privacy_agreement_dialog_height'))
  }
}
