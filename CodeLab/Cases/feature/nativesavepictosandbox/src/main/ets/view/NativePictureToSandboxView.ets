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

import fileUri from '@ohos.file.fileuri';
import testNapi from 'libnativesavepictosandbox.so';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { logger } from '../utils/Logger';

const TAG: string = '[NativePictureToSandbox] '

/**
 * 功能描述: 本示例主要介绍Native如何将网络上的图片及Rawfile中的图片保存到应用沙箱中。
 *
 * 推荐场景: 将网络上的图片及Rawfile中的图片保存到应用沙箱中
 *
 * 核心组件:
 * 1. saveImageOfInternetCallback
 * 2. saveImageOfRawfileCallback
 *
 * 实现步骤：
 * 1. 调用native侧saveImageOfInternetCallback接口，将返回的沙箱路径转换为Uri路径后绑定到Image组件
 * 2. 调用native侧saveImageOfRawfileCallback接口，将返回的沙箱路径转换为Uri路径后绑定到Image组件
 */
@Component
export struct NativePictureToSandboxViewComponent {
  @State internetSandBoxPath: string = ""; // 网络下载图片保存的沙箱路径
  @State rawfileSandBoxPath: string = ""; // rawfile中图片保存的沙箱路径
  private resMgr = getContext().resourceManager; // 获取js的资源对象
  private fileDir = getContext().filesDir; // 获取应用的文件路径
  private rawfilePicPath: string = "sandBoxTest.jpg"; // rawfile中的图片名
  private internetPicUrl: string =
    "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/imagedepthcopy/src/main/resources/rawfile/depthCopy.png"; // 网络图片
  private internetSandBoxFileName: string = "internet_image.png"; // 网络图片保存到沙箱的图片名

  build() {
    Column() {

      if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
        // 保存网络图片到沙箱
        Row() {
          Column() {
            Image(this.internetSandBoxPath)
              .width($r('app.integer.nativesavepictosandbox_image_width'))
              .height($r('app.integer.nativesavepictosandbox_image_height'))
              .margin($r('app.integer.nativesavepictosandbox_margin'))
          }
          .width('30%')

          Column() {
            Button($r('app.string.nativesavepictosandbox_tbn_InternetPicture'))
              .id('btn_save_internet_pic')
              .onClick(() => {
                // TODO：知识点：通过Native暴露的接口saveImageOfInternetCallback接口获取下载的网络图片保存在沙箱中的路径
                testNapi.saveImageOfInternetCallback(this.internetPicUrl, this.fileDir, this.internetSandBoxFileName,
                  ((result: string) => {
                    if (result === undefined || result === '') {
                      AlertDialog.show({
                        message: $r('app.string.nativesavepictosandbox_internet_file_write_fail'),
                        alignment: DialogAlignment.Center
                      });
                      this.internetSandBoxPath = '';
                    } else {
                      this.internetSandBoxPath = fileUri.getUriFromPath(result);
                      logger.info(TAG, `saveImageOfInternet sandboxPath is ` + result);
                    }
                  }))
              })
              .margin($r('app.integer.nativesavepictosandbox_margin'))
              .align(Alignment.Start)
              .alignSelf(ItemAlign.Start)
            Text($r('app.string.nativesavepictosandbox_sandBox_path'))
              .fontWeight(FontWeight.Normal)
              .margin($r('app.integer.nativesavepictosandbox_margin'))
              .alignSelf(ItemAlign.Start)
              .textAlign(TextAlign.Start)
              .align(Alignment.Start)
            Text(this.internetSandBoxPath)
              .id('txt_internet_sandbox_path')
              .align(Alignment.Start)
              .margin($r('app.integer.nativesavepictosandbox_margin'))
              .fontSize($r('app.integer.nativesavepictosandbox_font_size_14'))
              .alignSelf(ItemAlign.Start)
          }
          .width('70%')
          .height($r('app.integer.nativesavepictosandbox_image_height180'))
        }
        .border({
          width: 1,
          color: $r('app.color.nativesavepictosandbox_border_color'),
          radius: $r('app.integer.nativesavepictosandbox_common_radius'),
          style: BorderStyle.Solid
        })
        .borderRadius($r('app.integer.nativesavepictosandbox_common_radius'))
        .padding($r('app.integer.nativesavepictosandbox_padding12'))
        .margin($r('app.integer.nativesavepictosandbox_margin12'))
        .width('100%')
      }

      // 保存Rawfile图片到沙箱
      Row() {
        Column() {
          Image(this.rawfileSandBoxPath)
            .width($r('app.integer.nativesavepictosandbox_image_width'))
            .height($r('app.integer.nativesavepictosandbox_image_height'))
            .margin($r('app.integer.nativesavepictosandbox_margin'))
        }.width('30%')

        Column() {
          Button($r('app.string.nativesavepictosandbox_tbn_RawFilePicture'))
            .id('btn_save_rawfile_pic')
            .onClick(() => {
              // TODO：知识点：通过Native暴露的接口saveImageOfRawfileCallback接口获取rawfile中图片保存在沙箱中的路径
              testNapi.saveImageOfRawfileCallback(this.resMgr, this.rawfilePicPath, this.fileDir, ((result: string) => {
                if (result === undefined || result === '') {
                  AlertDialog.show({
                    message: $r('app.string.nativesavepictosandbox_rawfile_write_fail'),
                    alignment: DialogAlignment.Center
                  });
                  this.rawfileSandBoxPath = '';
                } else {
                  if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                    this.rawfileSandBoxPath = fileUri.getUriFromPath(result);
                  } else if (PlatformInfo.isArkUIX()) {
                    this.rawfileSandBoxPath = 'file:///' + this.fileDir + '/' + this.rawfilePicPath;
                  }
                }
                logger.info(TAG, TAG + `saveImageOfRawfile this.rawfileSandBoxPath is ` + this.rawfileSandBoxPath);
              }))
            })
            .margin($r('app.integer.nativesavepictosandbox_margin'))
            .align(Alignment.Start)
            .alignSelf(ItemAlign.Start)
          Text($r('app.string.nativesavepictosandbox_sandBox_path'))
            .fontWeight(FontWeight.Normal)
            .margin($r('app.integer.nativesavepictosandbox_margin'))
            .alignSelf(ItemAlign.Start)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
          Text(this.rawfileSandBoxPath)
            .id('txt_rawfile_sandbox_path')
            .align(Alignment.Start)
            .margin($r('app.integer.nativesavepictosandbox_margin'))
            .fontSize($r('app.integer.nativesavepictosandbox_font_size_14'))
            .alignSelf(ItemAlign.Start)
        }
        .width('70%')
        .height($r('app.integer.nativesavepictosandbox_image_height180'))
      }
      .border({
        width: 1,
        color: $r('app.color.nativesavepictosandbox_border_color'),
        radius: $r('app.string.nativesavepictosandbox_radius'),
        style: BorderStyle.Solid
      })
      .borderRadius($r('app.string.nativesavepictosandbox_radius'))
      .padding($r('app.string.nativesavepictosandbox_padding'))
      .margin($r('app.string.nativesavepictosandbox_margin12'))
      .width('100%')
    }.padding($r('app.string.ohos_id_card_padding_start'))
    .height('100%')
  }
}
