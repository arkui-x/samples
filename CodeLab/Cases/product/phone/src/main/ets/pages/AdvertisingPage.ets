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

import { display, router, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger, PreferenceManager, PlatformInfo, PlatformTypeEnum } from 'utils';
import { CommonConstants } from '../constants/CommonConstants'
import { getwaterFlowData } from '../data/WaterFlowData';
import { PrivacyAgreementDialog } from '../view/PrivacyAgreementDialog';

const TAG = '[AdvertisingPage] '

@Entry
@Component
struct AdvertisingPage {
  @StorageProp('windowSize') windowSize: window.Size = {
    width: display.getDefaultDisplaySync().width,
    height: display.getDefaultDisplaySync().height
  };
  @StorageLink('isAgree') @Watch('isConfirm') isAgree: boolean = false;
  @State pageCountDown: number = 6;
  /*
   * 持久化存储是否同意隐私弹窗
   * */
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();
  private timer: number = 0;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: PrivacyAgreementDialog(),
    autoCancel: false,
    width: 340,
    height: 372,
    customStyle: true,
    backgroundColor: Color.White,
    alignment: DialogAlignment.Center,
    cornerRadius: 11,
    onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
      //禁止通过点击遮罩层、侧滑返回关闭弹窗
      return;
    }
  })

  /*
   * 隐私弹窗同意后设置定时器
   * */
  isConfirm() {
    this.preferenceManager.getValue<boolean>('isConfirmPrivacyAgreement').then((isConfirm: boolean | null) => {
      if (isConfirm) {
        this.timer = setInterval(() => {
          this.pageCountDown--;
          if (this.pageCountDown === 0) {
            clearInterval(this.timer);
            router.replaceUrl({ url: 'pages/EntryView' });
          }
        }, 1000)
      } else {
        this.dialogController.open();
      }
    }).catch((err: BusinessError) => {
      logger.error(TAG, 'check isAgreedPrivacy Failed, err: ' + err);
    });
  }

  onPageShow() {
    this.isConfirm();
    // 首页瀑布流列表数据提前排序;依据序号,默认从小至大（a-->b）
    getwaterFlowData().sort((a, b) => a.serialNumber - b.serialNumber)
  }

  onPageHide(): void {
    this.dialogController?.close();
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Column() {
        Row() {
          Image($r('app.media.enter_app_animation'))
            .objectFit(ImageFit.Contain)
            .width('100%')
            .aspectRatio(1.4)
        }.margin({ top: $r('app.integer.advertising_page_gif_margin') })

        Column() {
          Text($r('app.string.advertising_page'))
            .fontSize($r('app.integer.advertising_page_font_size'))
          Text($r('app.string.advertising_description'))
            .margin({ top: $r('app.integer.advertising_description_text_margin') })
            .fontSize($r('app.integer.advertising_description_font_size'))
            .opacity(0.6)
        }.margin({ top: $r('app.integer.advertising_description_margin') })
      }.width('100%')

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text($r('app.string.skip'))
          .fontSize($r('app.integer.advertising_description_skip_font_size'))
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
        Text(`${this.pageCountDown}`)
          .fontSize($r('app.integer.advertising_description_skip_font_size'))
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          .margin({ left: $r('app.integer.advertising_description_pageCountDown_margin') })
      }
      .position({
        x: px2vp(this.windowSize.width - CommonConstants.OFFSET_RIGHT_LEN)
      })
      .width($r('app.integer.advertising_description_skip_width'))
      .aspectRatio(2.4)
      .backgroundColor($r('app.string.advertising_description_backgroundColor'))
      .borderRadius($r('app.integer.advertising_description_skip_borderRadius'))
      .onClick(() => {
        this.pageCountDown = 0;
        clearInterval(this.timer);
        router.replaceUrl({ url: 'pages/EntryView' });
      })
    }
    .width('100%')
    .backgroundColor($r('app.color.advertising_backgroundColor'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}