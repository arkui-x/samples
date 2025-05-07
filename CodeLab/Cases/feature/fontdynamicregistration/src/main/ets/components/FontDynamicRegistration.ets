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

import { AppRouter } from 'routermodule';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { font, promptAction } from '@kit.ArkUI';
import { connection } from '@kit.NetworkKit';
import fs from '@ohos.file.fs';
import { logger } from 'utils';

const TAG: string = '[FontDynamicRegistration] '

// 字体下载链接
const URL: string = "https://gitee.com/coufran/font-online/raw/master/fonts/SourceHanSerif/SourceHanSerif-ExtraLight.otf";
//字体文件名
const FILE_NAME: string = '/font.TTF';
// 字体下载目录
const CACHE_DIR: string = getContext().cacheDir;
// 下载文件头
const DOWNLOAD_HEADER: string = 'file://';
const DIVIDER_STROKEWIDTH: number = 1;

@AppRouter({ name: "fontdynamicregistration/FontDynamicRegistration" })
@Preview
@Component
export struct FontDynamicRegistration {
  @State buttonEnabled: boolean = true;
  @State buttonSelection: number = 0;
  @State targetFont: ResourceStr = $r('app.string.fontdynamicregistration_font_sans');
  @State buttonContent: ResourceStr = $r('app.string.fontdynamicregistration_font_SourceHanSerif');

  build() {
    Column() {
      Column() {
        Column() {
          Text($r('app.string.fontdynamicregistration_main_title'))
            .fontSize($r('app.integer.fontdynamicregistration_title_font_size'))
            .textAlign(TextAlign.Start)
          Text($r('app.string.fontdynamicregistration_question'))
            .fontFamily(this.targetFont)
            .fontSize($r('app.integer.fontdynamicregistration_body_font_size'))
            .margin({ top: $r('app.integer.fontdynamicregistration_body_text_margin') })
            .padding($r('app.integer.fontdynamicregistration_body_text_padding'))
            .width($r('app.string.fontdynamicregistration_text_dialog_width'))
            .borderRadius($r('app.integer.fontdynamicregistration_body_text_borderRadius'))
            .fontColor(Color.White)
            .backgroundColor($r('app.color.fontdynamicregistration_global_bg'))
            .alignSelf(ItemAlign.End)

          Text($r('app.string.fontdynamicregistration_answer'))
            .fontFamily(this.targetFont)
            .fontSize($r('app.integer.fontdynamicregistration_body_font_size'))
            .margin({ top: $r('app.integer.fontdynamicregistration_body_text_margin') })
            .padding($r('app.integer.fontdynamicregistration_body_text_padding'))
            .width($r('app.string.fontdynamicregistration_text_dialog_width'))
            .borderRadius($r('app.integer.fontdynamicregistration_body_text_borderRadius'))
            .backgroundColor($r('app.color.fontdynamicregistration_gery_bg'))

        }.width($r('app.string.fontdynamicregistration_text_wrapper_width'))
        .alignItems(HorizontalAlign.Start)

        Column() {
          Text() {
            Span($r('app.string.fontdynamicregistration_target_font'))
            Span(this.targetFont)
          }
          .id('text_font')

          Divider()
            .margin($r('app.integer.fontdynamicregistration_divider_margin'))
            .strokeWidth(DIVIDER_STROKEWIDTH)
          Row() {
            Button($r('app.string.fontdynamicregistration_font_sans'))
              .width($r('app.integer.fontdynamicregistration_bt_width'))
              .height($r('app.integer.fontdynamicregistration_bt_height'))
              .backgroundColor($r('app.color.fontdynamicregistration_global_bg'))
              .margin({ right: $r('app.integer.fontdynamicregistration_button_spacing') })
              .onClick(() => {
                this.buttonSelection = 0;
                this.targetFont = $r('app.string.fontdynamicregistration_font_sans');
              })
            Button(this.buttonContent)
              .id('change_font')
              .enabled(this.buttonEnabled)
              .width($r('app.integer.fontdynamicregistration_bt_width'))
              .height($r('app.integer.fontdynamicregistration_bt_height'))
              .backgroundColor($r('app.color.fontdynamicregistration_global_bg'))
              .margin({ right: $r('app.integer.fontdynamicregistration_button_spacing') })
              .onClick(() => {
                this.buttonSelection = 1;
                connection.hasDefaultNet().then((res: boolean) => {
                  logger.info(TAG, 'connection.hasDefaultNet successed; res is ' + res);
                  if (res) {
                    this.downloadAndRegister();
                  } else {
                    promptAction.showToast({
                      message: '网络未连接，请先连接网络'
                    });
                  }
                }).catch((error: BusinessError) => {
                  logger.error(TAG, 'connection.hasDefaultNet failed;' +
                    ' error.code is ' + JSON.stringify(error.code) + '; error.message is' + JSON.stringify(error.message));
                })
              })
          }
        }
        .width($r('app.string.fontdynamicregistration_bottom_wrapper_width'))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .height($r('app.string.fontdynamicregistration_second_wrapper_size'))
      .width($r('app.string.fontdynamicregistration_second_wrapper_size'))
    }.width($r('app.string.fontdynamicregistration_top_wrapper_size'))
    .height($r('app.string.fontdynamicregistration_top_wrapper_size'))
    .justifyContent(FlexAlign.Center)
  }

  downloadAndRegister() {
    // 检查字体是否注册
    if (font.getFontByName('思源宋体')) {
      this.targetFont = $r('app.string.fontdynamicregistration_font_SourceHanSerif');
      return;
    }
    // 检查文件是否存在
    const filePath = CACHE_DIR + FILE_NAME;
    let res = fs.accessSync(filePath);
    logger.info(TAG, `file exist:${res}`);
    if (res) {
      // TODO ：知识点：注册自定义字体
      this.getUIContext().getFont().registerFont({
        familyName: '思源宋体',
        familySrc: DOWNLOAD_HEADER + filePath
      })
      // 字体变更为思源宋体
      this.targetFont = $r('app.string.fontdynamicregistration_font_SourceHanSerif');
      logger.info(TAG, 'registerFont successful');
      return;
    }
    try {
      this.buttonEnabled = false;
      this.buttonContent = $r('app.string.fontdynamicregistration_downloading')
      // TODO ：知识点：下载网络文件
      request.downloadFile(getContext(), { url: URL, filePath: filePath }, (err, downloadTask) => {
        if (err) {
          logger.error(TAG, `Failed to request the download. Cause: ${JSON.stringify(err)}`);
          return;
        }
        // 监听下载进度，赋值到状态变量
        downloadTask.on('progress', (receivedSize, totalSize) => {
          logger.info(TAG, `Download receivedSize:${receivedSize},totalSize: ${totalSize}`);
        });

        // 监听下载完成事件
        downloadTask.on('complete', () => {
          downloadTask.off('progress');
          downloadTask.off('fail');
          this.getUIContext().getFont().registerFont({
            familyName: '思源宋体',
            familySrc: DOWNLOAD_HEADER + filePath
          })
          this.buttonEnabled = true;
          this.buttonContent = $r('app.string.fontdynamicregistration_font_SourceHanSerif')
          if (this.buttonSelection === 1) {
            this.targetFont = $r('app.string.fontdynamicregistration_font_SourceHanSerif');
          }
        })

        // 监听下载失败事件
        downloadTask.on('fail', (err: number) => {
          logger.error(TAG, "DownloadTask failed");
          let res = fs.accessSync(filePath);
          if (res) {
            fs.unlink(filePath);
            downloadTask.off('fail');
          }
        })
      });
    } catch (err) {
      logger.error(TAG, `Download failed with error message:  + ${err.message} + , error code:  + ${err.code}`);
    }
  }
}


