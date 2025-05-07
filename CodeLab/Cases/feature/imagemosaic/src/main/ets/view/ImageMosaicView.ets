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

import image from '@ohos.multimedia.image'; // 导入Image模块
import resourceManager from '@ohos.resourceManager'; // 导入资源管理模块
import taskpool from '@ohos.taskpool';
import { BusinessError } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import { MosaicConstants } from '../constants/MosaicConstants';
import { logger } from '../utils/Logger';

/**
 * 获取图片内容
 */
@Concurrent
async function getImageContent(imgPath: string, context: Context): Promise<Uint8Array | undefined> {
  // 获取resourceManager资源管理
  const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
  // 获取rawfile中的图片资源
  const fileData: Uint8Array = await resourceMgr.getRawFileContent(imgPath);
  return fileData;
}

/**
 * 图片马赛克处理函数
 */
@Concurrent
async function applyMosaic(dataArray: Uint8Array, imageWidth: number, imageHeight: number, blockSize: number,
  offMinX: number, offMinY: number, offMaxX: number, offMaxY: number): Promise<Uint8Array | undefined> {
  try {
    // 计算横排和纵排的块数
    let xBlocks = Math.floor((Math.abs(offMaxX - offMinX)) / blockSize);
    let yBlocks = Math.floor((Math.abs(offMaxY - offMinY)) / blockSize);
    // 不足一块的，按一块计算
    if (xBlocks < 1) {
      xBlocks = 1;
      offMaxX = offMinX + blockSize;
    }
    if (yBlocks < 1) {
      yBlocks = 1;
      offMaxY = offMinY + blockSize;
    }

    // 遍历每个块
    for (let y = 0; y < yBlocks; y++) {
      for (let x = 0; x < xBlocks; x++) {
        const startX = x * blockSize + offMinX;
        const startY = y * blockSize + offMinY;

        // 计算块内的平均颜色
        let totalR = 0;
        let totalG = 0;
        let totalB = 0;
        let pixelCount = 0;
        for (let iy = startY; iy < startY + blockSize && iy < imageHeight && iy < offMaxY; iy++) {
          for (let ix = startX; ix < startX + blockSize && ix < imageWidth && ix < offMaxX; ix++) {
            // TODO 知识点：像素点数据包括RGB通道的分量值及图片透明度
            const index = (iy * imageWidth + ix) * 4; // 4 像素点数据包括RGB通道的分量值及图片透明度
            totalR += dataArray[index];
            totalG += dataArray[index + 1];
            totalB += dataArray[index + 2];
            pixelCount++;
          }
        }
        const averageR = Math.floor(totalR / pixelCount);
        const averageG = Math.floor(totalG / pixelCount);
        const averageB = Math.floor(totalB / pixelCount);
        // TODO 知识点： 将块内平均颜色应用到块内的每个像素
        for (let iy = startY; iy < startY + blockSize && iy < imageHeight && iy < offMaxY; iy++) {
          for (let ix = startX; ix < startX + blockSize && ix < imageWidth && ix < offMaxX; ix++) {
            const index = (iy * imageWidth + ix) * 4; // 4 像素点数据包括RGB通道的分量值及图片透明度
            dataArray[index] = averageR;
            dataArray[index + 1] = averageG;
            dataArray[index + 2] = averageB;
          }
        }
      }
    }
    return dataArray;
  } catch (error) {
    logger.error(MosaicConstants.TAG, 'applyMosaic fail,err:' + error);
    return undefined;
  }
}

/**
 * 功能描述: 本实例介绍如何将图片中手指划过的区域分割成若干个大小一致的小方格，并通过createPixelMapSync接口将新的像素点数据写入图片，实现局部马赛克的效果。
 *
 * 推荐场景: 图片编辑场景
 *
 * 核心组件:
 * 1. PixelMap
 * 2. 马赛克处理函数applyMosaic
 *
 * 实现步骤:
 * 1. 获取源图片PixelMap。从资源管理器获取图片，创建ImageSource实例，使用createPixelMap创建PixelMap图片对象，保存其宽高。
 * 2. 执行马赛克任务，调用马赛克处理函数applyMosaic。手势在图片上移动时，执行马赛克任务，并将手指移动的起始坐标传入。
 * 3. 实现马赛克处理函数applyMosaic。将传入的起始坐标映射到图片原始位置，进行马赛克处理。
 */
@Component
export struct ImageMosaicViewComponent {
  private imageSource: image.ImageSource | undefined = undefined;
  private opts: image.InitializationOptions | undefined = undefined;
  @State pixelMapSrc: PixelMap | undefined | null = undefined; // 源PixelMap
  private displayWidth: number = 0; // 图片显示的宽度
  @State displayHeight: number = 1; // 图片显示的高度,根据图片分辨率计算
  private imageWidth: number = 0; // 图片原始宽度
  private imageHeight: number = 0; // 图片原始高度
  // 手势移动位置
  private startX: number = 0;
  private startY: number = 0;
  private endX: number = 0;
  private endY: number = 0;
  private isMosaic: boolean = false; // 当前图片是否马赛克
  private fileData: Uint8Array = new Uint8Array(0);
  /**
   * 获取原始图片信息
   */
  async getSrcImageInfo(): Promise<void> {
    // TODO: 性能知识点：使用new taskpool.Task()创建任务项，传入获取图片内容函数和所需参数
    const task: taskpool.Task = new taskpool.Task(getImageContent, MosaicConstants.RAWFILE_PICPATH, getContext(this));
    try {
      this.fileData = await taskpool.execute(task) as Uint8Array;
      // 获取图片的ArrayBuffer
      const buffer = this.fileData.buffer.slice(this.fileData.byteOffset, this.fileData.byteLength + this.fileData.byteOffset);
      // 获取原图imageSource
      this.imageSource = image.createImageSource(buffer);
      // TODO 知识点： 将图片设置为可编辑
      const decodingOptions: image.DecodingOptions = {
        editable: true,
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
      }
      // 创建PixelMap
      this.pixelMapSrc = await this.imageSource.createPixelMap(decodingOptions);
    } catch (err) {
      logger.error(MosaicConstants.TAG, "getSrcImageInfo: execute fail, err:" + (err as BusinessError).toString());
    }
  }

  /**
   * 执行马赛克任务
   */
  async doMosaicTask(offMinX: number, offMinY: number, offMaxX: number, offMaxY: number): Promise<void> {
    // TODO 知识点：将手势移动的起始坐标转换为原始图片中的坐标
    offMinX = Math.round(offMinX * this.imageWidth / this.displayWidth);
    offMinY = Math.round(offMinY * this.imageHeight / this.displayHeight);
    offMaxX = Math.round(offMaxX * this.imageWidth / this.displayWidth);
    offMaxY = Math.round(offMaxY * this.imageHeight / this.displayHeight);
    // 处理起始坐标大于终点坐标的情况
    if (offMinX > offMaxX) {
      const temp = offMinX;
      offMinX = offMaxX;
      offMaxX = temp;
    }
    if (offMinY > offMaxY) {
      const temp = offMinY;
      offMinY = offMaxY;
      offMaxY = temp;
    }
    // 获取像素数据的字节数
    const bufferData = new ArrayBuffer(this.pixelMapSrc!.getPixelBytesNumber());
    await this.pixelMapSrc!.readPixelsToBuffer(bufferData);
    // 将像素数据转换为 Uint8Array 便于像素处理
    let dataArray = new Uint8Array(bufferData);
    // 计算横排和纵排的块数
    let blockSize = MosaicConstants.BLOCK_SIZE;
    let xBlocks = Math.floor((Math.abs(offMaxX - offMinX)) / blockSize);
    let yBlocks = Math.floor((Math.abs(offMaxY - offMinY)) / blockSize);
    // 不足一块的，按一块计算
    if (xBlocks < 1) {
      xBlocks = 1;
      offMaxX = offMinX + blockSize;
    }
    if (yBlocks < 1) {
      yBlocks = 1;
      offMaxY = offMinY + blockSize;
    }

    // 遍历每个块
    for (let y = 0; y < yBlocks; y++) {
      for (let x = 0; x < xBlocks; x++) {
        const startX = x * blockSize + offMinX;
        const startY = y * blockSize + offMinY;

        // 计算块内的平均颜色
        let totalR = 0;
        let totalG = 0;
        let totalB = 0;
        let pixelCount = 0;
        for (let iy = startY; iy < startY + blockSize && iy < this.imageHeight && iy < offMaxY; iy++) {
          for (let ix = startX; ix < startX + blockSize && ix < this.imageWidth && ix < offMaxX; ix++) {
            // TODO 知识点：像素点数据包括RGB通道的分量值及图片透明度
            const index = (iy * this.imageWidth + ix) * 4; // 4 像素点数据包括RGB通道的分量值及图片透明度
            totalR += dataArray[index];
            totalG += dataArray[index + 1];
            totalB += dataArray[index + 2];
            pixelCount++;
          }
        }
        const averageR = Math.floor(totalR / pixelCount);
        const averageG = Math.floor(totalG / pixelCount);
        const averageB = Math.floor(totalB / pixelCount);
        // TODO 知识点： 将块内平均颜色应用到块内的每个像素
        for (let iy = startY; iy < startY + blockSize && iy < this.imageHeight && iy < offMaxY; iy++) {
          for (let ix = startX; ix < startX + blockSize && ix < this.imageWidth && ix < offMaxX; ix++) {
            const index = (iy * this.imageWidth + ix) * 4; // 4 像素点数据包括RGB通道的分量值及图片透明度
            dataArray[index] = averageR;
            dataArray[index + 1] = averageG;
            dataArray[index + 2] = averageB;
          }
        }
      }
    }
    this.pixelMapSrc = image.createPixelMapSync(dataArray.buffer, this.opts);
    this.isMosaic = true;
  }

  async aboutToAppear(): Promise<void> {
    // 初始化图片
    await this.getSrcImageInfo();
    // 获取图片参数
    this.opts = {
      editable: false,
      pixelFormat: this.pixelMapSrc!.getImageInfoSync().pixelFormat,
      size: {
        height: this.pixelMapSrc!.getImageInfoSync().size.height,
        width: this.pixelMapSrc!.getImageInfoSync().size.width
      },
      srcPixelFormat: this.pixelMapSrc!.getImageInfoSync().pixelFormat,
      alphaType: this.pixelMapSrc!.getImageInfoSync().alphaType
    };
    // 读取图片信息
    const imageInfo: image.ImageInfo = await this.pixelMapSrc!.getImageInfo();
    // 获取图片的宽度和高度
    this.imageWidth = imageInfo.size.width;
    this.imageHeight = imageInfo.size.height;
    // 获取屏幕尺寸
    const displayData: display.Display = display.getDefaultDisplaySync();
    // 计算图片的显示尺寸
    this.displayWidth = px2vp(displayData.width);
    this.displayHeight = this.displayWidth * this.imageHeight / this.imageWidth;
    logger.info(MosaicConstants.TAG,
      'displayWidth: ' + this.displayWidth.toString() + ' ,displayHeight:' + this.displayHeight.toString());
  }

  build() {
    Column() {
      Row() {
        Image(this.pixelMapSrc).objectFit(ImageFit.Fill)
          .id('img_mosaic')
      }.width($r('app.string.mosaic_percent_100'))
      .height(this.displayHeight)
      .backgroundColor(Color.White)
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          PanGesture({ distance: 20 })
            .onActionStart((event: GestureEvent) => {
              const finger: FingerInfo = event.fingerList[0];
              if (finger == undefined) {
                return;
              }
              this.startX = finger.localX;
              this.startY = finger.localY;
            })
            .onActionUpdate(async (event: GestureEvent) => {
              const finger: FingerInfo = event.fingerList[0];
              if (finger == undefined) {
                return;
              }
              this.endX = finger.localX;
              this.endY = finger.localY;
              // 执行马赛克任务
              await this.doMosaicTask(this.startX, this.startY, this.endX, this.endY);
              this.startX = this.endX;
              this.startY = this.endY;
            })
        )
      )

      Button($r('app.string.mosaic_btn_restore'))
        .id('btn_restore_pic')
        .fontSize($r('app.integer.image_mosaic_font_size'))
        .width($r('app.string.mosaic_percent_50'))
        .margin({ top: $r('app.integer.image_mosaic_padding') })
        .onClick(async () => {
          if (this.isMosaic) {
            await this.getSrcImageInfo();
            this.isMosaic = false;
          }
        })
    }
  }
}