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

import { promptAction } from '@kit.ArkUI';
import { ICallBack, MP4Parser } from '@ohos/mp4parser';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { fileIo as fs, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { getTimeString } from '../util/TimeTools';
import { logger } from '../util/Logger';
import { CustomLoadingDialog } from './CustomLoadingDialog';

/**
 * gif生成页面
 */
@Component
export struct GifCreateView {
  private startTime: number = 0;        // 截取gif的起始时间
  private endTime: number = 0;          // 截断gif的结束时间
  private srcFilePath: string = '';     // 视频文件路径
  private back?: () => void;            // 返回按钮处理
  private gifSandBoxPath: string = '';  // 保存gif的沙箱路径

  @State gifFilePath: string = '';      // gif路径

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomLoadingDialog({
      content: $r('app.string.video_create_gif_creating')
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    width: $r('app.integer.video_create_gif_dialog_width'),
    height: $r('app.integer.video_create_gif_dialog_width'),
    cornerRadius: $r('app.integer.video_create_gif_dialog_corner_radius')
  })

  aboutToAppear(): void {
    this.dialogController.open();
    // 开始生成gif文件
    this.createGif(this.srcFilePath, this.startTime, this.endTime);
  }

  build() {
    RelativeContainer() {
      // 返回按钮
      Image($r("app.media.video_create_gif_back"))
        .width($r('app.integer.video_create_gif_gif_create_back_button_width'))
        .height($r('app.integer.video_create_gif_gif_create_back_button_height'))
        .alignRules({
          top: { anchor: "__container__", align: VerticalAlign.Top },
          left: { anchor: "__container__", align: HorizontalAlign.Start }
        })
        .padding({
          left: $r('app.integer.video_create_gif_gif_create_back_button_left_padding'),
          top: $r('app.integer.video_create_gif_gif_create_back_button_top_and_bottom_padding'),
          bottom: $r('app.integer.video_create_gif_gif_create_back_button_top_and_bottom_padding')
        })
        .margin({
          left: $r('app.integer.video_create_gif_gif_create_back_button_left_margin')
        })
        .onClick(() => {
          if (this.back) {
            this.back();
          }
        })
        .id('gif_create_back')

      // 显示创建的gif图片
      Image(this.gifFilePath)
        .objectFit(ImageFit.Contain)
        .width($r('app.integer.video_create_gif_gif_create_image_width'))
        .height($r('app.integer.video_create_gif_gif_create_image_height'))
        .borderWidth(1)
        .borderColor(Color.Gray)
        .alignRules({
          top: {anchor: "__container__", align: VerticalAlign.Top},
          left: {anchor: "__container__", align: HorizontalAlign.Start}
        })
        .offset({
          x: $r('app.integer.video_create_gif_gif_create_image_offset_x'),
          y: $r('app.integer.video_create_gif_gif_create_image_offset_y')
        })
        .id("image1")

      Row() {
        // 保存至图库
        Column() {
          SaveButton({
            icon:SaveIconStyle.FULL_FILLED,
          })
            .width($r('app.integer.video_create_gif_gif_create_action_item_width'))
            .height($r('app.integer.video_create_gif_gif_create_action_item_width'))
            .iconSize($r('app.integer.video_create_gif_gif_create_save_button_icon_size'))
            .iconColor(Color.White)
            .backgroundColor($r('app.color.video_create_gif_view_save_button_background_color'))
            .borderRadius($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
            .borderWidth(1)
            .borderColor(Color.White)
            .borderStyle(BorderStyle.Solid)
            .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
              this.handleSaveButtonClick(result);
            })

          SaveButton({
            text: SaveDescription.SAVE_TO_GALLERY,
            buttonType: ButtonType.Normal
          })
            .fontSize($r('app.integer.video_create_gif_middle_font_size'))
            .fontColor(Color.White)
            .backgroundColor($r('app.color.video_create_gif_view_save_button_background_color'))
            .fontWeight(600)
            .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
              this.handleSaveButtonClick(result);
            })
        }
        .height($r('app.string.video_create_gif_full_width'))
        .justifyContent(FlexAlign.SpaceBetween)

        // 分享
        Column() {
          Row() {
            Image($r("app.media.video_create_gif_share"))
              .width($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
              .height($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
          }.width($r('app.integer.video_create_gif_gif_create_action_item_width'))
          .height($r('app.integer.video_create_gif_gif_create_action_item_width'))
          .borderRadius($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
          .borderWidth(1)
          .borderColor(Color.White)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Text($r('app.string.video_create_gif_share'))
            .fontSize($r('app.integer.video_create_gif_middle_font_size'))
            .fontColor(Color.White)
            .fontWeight(600)
        }
        .height($r('app.string.video_create_gif_full_width'))
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          bottom: $r('app.integer.video_create_gif_gif_create_action_item_share_and_comment_bottom_padding')
        })
        .margin({
          left: $r('app.integer.video_create_gif_gif_create_action_item_share_left_margin')
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.video_create_gif_toast_tips')
          });
        })

        // 评论
        Column() {
          Row() {
            Image($r("app.media.video_create_gif_comment"))
              .width($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
              .height($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
          }.width($r('app.integer.video_create_gif_gif_create_action_item_width'))
          .height($r('app.integer.video_create_gif_gif_create_action_item_width'))
          .borderRadius($r('app.integer.video_create_gif_gif_create_action_item_circle_diameter'))
          .borderWidth(1)
          .borderColor(Color.White)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Text($r('app.string.video_create_gif_comment'))
            .fontSize($r('app.integer.video_create_gif_middle_font_size'))
            .fontColor(Color.White)
            .fontWeight(600)
        }
        .height($r('app.string.video_create_gif_full_width'))
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          bottom: $r('app.integer.video_create_gif_gif_create_action_item_share_and_comment_bottom_padding')
        })
        .margin({
          left: $r('app.integer.video_create_gif_gif_create_action_item_comment_left_margin')
        })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.video_create_gif_toast_tips')
          });
        })
      }.alignRules({
        center: {anchor: "image1", align: VerticalAlign.Center},
        left: {anchor: "image1", align: HorizontalAlign.End}
      })
      .offset({
        x: $r('app.integer.video_create_gif_gif_create_action_regin_offset_x'),
        y: $r('app.integer.video_create_gif_gif_create_action_regin_offset_y')
      })
      .height($r('app.integer.video_create_gif_gif_create_action_regin_height'))
    }
    .width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_full_width'))
    .backgroundColor($r('app.color.video_create_gif_view_background_color'))
  }

  /**
   * SaveButton点击处理
   * @param result
   */
  private handleSaveButtonClick(result: SaveButtonOnClickResult) {
    if (result === SaveButtonOnClickResult.SUCCESS) {
      this.savePhotoToGallery();
    } else {
      promptAction.showToast({ message: $r('app.string.video_create_gif_failed_to_set_permission') });
    }
  }

  /**
   * 创建gif图片
   * @param src
   * @param sTime
   * @param eTime
   */
  private createGif(srcFilePath: string, sTime: number, eTime: number) {
    let dst = getContext().cacheDir + '/output' + Date.now() + '.gif';
    let startTime = getTimeString(sTime);
    let duration = Math.floor((eTime - sTime) / 1000);

    let that = this;
    let callBack: ICallBack = {
      callBackResult(code: number) {
        that.gifSandBoxPath = dst;
        that.gifFilePath = fileUri.getUriFromPath(dst);

        that.dialogController.close();

        promptAction.showToast({
          message: code == 0 ? $r('app.string.video_create_gif_create_success')
            : $r('app.string.video_create_gif_create_fail')
        });
      }
    }

    // TODO: 知识点: 可以用以下的FFmpeg命令生成gif图，这里也可以加参数以生成需要的gif图
    MP4Parser.ffmpegCmd("ffmpeg -i " + srcFilePath + " -ss " + startTime + " -t " + duration + " " + dst, callBack);
  }

  /**
   * 保存图片至相册
   */
  async savePhotoToGallery() {
    let helper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
    try {
      // onClick触发后5秒内通过createAsset接口创建图片文件，5秒后createAsset权限收回。
      let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'gif');
      // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
      let destFile = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);

      // 打开文件
      let srcFile = fs.openSync(this.gifSandBoxPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      // 读取源文件内容并写入至目的文件
      let bufSize = 4096;
      let readSize = 0;
      let buf = new ArrayBuffer(bufSize);

      let readOptions: ReadOptions = {
        offset: readSize,
        length: bufSize
      };

      let readLen = fs.readSync(srcFile.fd, buf, readOptions);
      while (readLen > 0) {
        readSize += readLen;
        let writeOptions: WriteOptions = {
          length: readLen
        };
        fs.writeSync(destFile.fd, buf, writeOptions);
        readOptions.offset = readSize;
        readLen = fs.readSync(srcFile.fd, buf, readOptions);
      }

      // 关闭文件
      fs.closeSync(srcFile);
      fs.closeSync(destFile);

      promptAction.showToast({
        message: $r('app.string.video_create_gif_save_success')
      });
    }
    catch (error) {
      const err: BusinessError = error as BusinessError;
      logger.error(`Failed to save photo. Code is ${err.code}, message is ${err.message}`);
      promptAction.showToast({
        message: $r('app.string.video_create_gif_save_fail')
      });
    }
  }

}