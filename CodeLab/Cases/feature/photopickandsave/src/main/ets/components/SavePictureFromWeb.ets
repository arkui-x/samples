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

import { webview } from '@kit.ArkWeb';
import { common } from '@kit.AbilityKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError, request } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { buffer } from '@kit.ArkTS';
import { fileUri } from '@kit.CoreFileKit';
import { logger } from '../utils/Logger';
import { promptAction } from '@kit.ArkUI';

const TAG: string = 'savePictureFromWeb';
const ANIMATION_DURATION: number = 1000; // 弹窗出现持续时间

/**
 * 实现步骤：
 * 1. 长按图片获取图片链接。
 * 2. 使用request.download将图片下载到沙箱路径。
 * 3. 使用phAccessHelper.showAssetsCreationDialog获取将图片写入相册的权限，将沙箱路径下的图片转为buffer，写入路径。
 */
@Component
export struct SavePictureFromWeb {
  controller: webview.WebviewController = new webview.WebviewController();
  @State imageUrl: string = ''; // web上的图片链接
  @State showMenu: boolean = false; // 控制bindPopup是否显示
  private context = getContext(this) as common.UIAbilityContext;

  /**
   * 下载图片到沙箱路径，并且保存到相册
   */
  downloadImage() {
    // 获取沙箱路径
    let filesDir = this.context.filesDir;

    try {
      // 将web页面的图片下载到沙箱路径
      request.downloadFile(this.context, {
        url: this.imageUrl,
        filePath: `${filesDir}/savePictureFromWeb.png`
      }).then((downloadTask: request.DownloadTask) => {
        downloadTask.on('complete', async () => {
          logger.info(TAG, 'download image succeed');
          // 下载成功后图片的沙箱路径
          const srcFileUris: string[] = [`${filesDir}/savePictureFromWeb.png`];
          await this.saveImage(srcFileUris);
        })
      }).catch((err: BusinessError) => {
        logger.error(TAG, `wq Invoke downloadTask failed, code is ${err.code}, message is ${err.message}`);
      });
    } catch (error) {
      logger.error(TAG, `download image failed, code is: ${error.code}, message is: ${error.message}`);
    }
  }

  /**
   * 将沙箱路径下的图片写入到相册
   * @param srcFileUris 图片的沙箱路径
   */
  async saveImage(srcFileUris: Array<string>) {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);

    try {
      let photoCreationConfigs: Array<photoAccessHelper.PhotoCreationConfig> = [
        {
          title: 'savePictureFromWeb',
          fileNameExtension: 'png',
          photoType: photoAccessHelper.PhotoType.IMAGE,
          subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
        }
      ];
      // 拉起授予权限的弹窗，获取将图片保存到相册的权限
      let desFileUris: Array<string> = await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
      logger.info(TAG, 'showAssetsCreationDialog success, data is:' + desFileUris);
      // 转换为uri
      let uri: string = fileUri.getUriFromPath(srcFileUris[0]);
      // 打开沙箱路径下图片
      const file: fs.File = fs.openSync(uri, fs.OpenMode.READ_WRITE);
      // 读取沙箱路径下图片为buffer
      const photoSize: number = fs.statSync(file.fd).size;
      let arrayBuffer: ArrayBuffer = new ArrayBuffer(photoSize);
      let readLength: number = fs.readSync(file.fd, arrayBuffer);
      let imageBuffer: ArrayBuffer = buffer.from(arrayBuffer, 0, readLength).buffer;

      try {
        // 打开相册下路径
        let fileInAlbum = fs.openSync(desFileUris[0], fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

        // 写入相册
        await fs.write(fileInAlbum.fd, imageBuffer);
        // 关闭文件
        await fs.close(file.fd);
        await fs.close(fileInAlbum.fd);

        logger.info(TAG, 'save image succeed');
        // 图片保存成功后，删掉沙箱路径下图片
        fs.unlinkSync(srcFileUris[0]);

        promptAction.showToast({
          message: $r('app.string.photo_pick_and_save_success_message'),
          duration: ANIMATION_DURATION
        });
        // 关闭bindPopup
        this.showMenu = false;
      } catch (error) {
        logger.error(TAG, `save image failed, code is: ${error.code}, message is: ${error.message}`);
      }
    } catch (err) {
      logger.error(TAG, `showAssetsCreationDialog failed, errCode is: ${err.code}, message is: ${err.message}`);
    }
  }

  /**
   * 保存图片弹窗
   */
  @Builder
  savePopBuilder() {
    Column() {
      Text($r('app.string.photo_pick_and_save_is_save_picture'))
        .fontSize($r('app.string.photo_pick_and_save_is_save_picture_message_font_size'))
        .height($r('app.string.photo_pick_and_save_is_save_picture_message_height'))
        .textAlign(TextAlign.Center)
      Row() {
        Button($r('app.string.photo_pick_and_save_picture_message'))
          .width($r('app.string.photo_pick_and_save_button_width'))
          .onClick(() => {
            this.downloadImage();
          })
          .backgroundColor($r('app.color.photo_pick_and_save_button_background_color'))
          .fontSize($r('app.string.photo_pick_and_save_button_font_size'))

        Button($r('app.string.photo_pick_and_save_cancel_save'))
          .backgroundColor($r('app.color.photo_pick_and_save_button_background_color'))
          .width($r('app.string.photo_pick_and_save_button_width'))
          .onClick(() => {
            this.showMenu = false;
          })
          .fontSize($r('app.string.photo_pick_and_save_button_font_size'))
      }
      .width($r('app.string.photo_pick_and_save_button_container_width'))
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width($r('app.string.photo_pick_and_save_pop_container_width'))
    .height($r('app.string.photo_pick_and_save_pop_container_height'))
  }

  build() {
    Column() {
      Web({ src: $rawfile('index.html'), controller: this.controller })
        .onContextMenuShow((event) => {
          // 判断是否是图片
          if (event && event.param.existsImageContents()) {
            // 获取图片链接
            this.imageUrl = event.param.getSourceUrl();
            logger.info(TAG, 'save image url success');
            this.showMenu = true;
          }
          return true;
        })
        .bindPopup(this.showMenu, {
          builder: this.savePopBuilder(),
          placement: Placement.Top,
          popupColor: $r('app.color.photo_pick_and_save_bind_popup_color'),
          autoCancel: false,
          backgroundBlurStyle: BlurStyle.Thin,
          enableArrow: false,
          mask: { color: $r('app.color.photo_pick_and_save_bind_popup_mask_color') }
        })
        .draggable(false)
        .id('web')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .align(Alignment.Center)
  }
}

