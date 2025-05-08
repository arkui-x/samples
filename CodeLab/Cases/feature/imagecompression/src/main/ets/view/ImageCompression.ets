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

import { HelpDescription } from './HelpDescription';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit'; // 相册管理模块
import { promptAction } from '@kit.ArkUI';
import { window, KeyboardAvoidMode } from '@kit.ArkUI';
import { inputMethod } from '@kit.IMEKit';
import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { emitter } from '@kit.BasicServicesKit';

/**
 * 使用图片压缩组件样例
 *
 * 核心组件:
 * 1. autoCompression
 * 2. manualCompression
 *
 * 实现步骤:
 * 1. 拉起图库选择要压缩的图片。使用photoAccessHelper.PhotoViewPicker创建图库选择器实例photoViewPicker，调用photoViewPicker.select()
 * 接口拉起图库界面进行图片选择。图片选择成功后，返回photoSelectResult结果集。从photoSelectResult.photoUris中获取返回图库选择后的媒体文件
 * 的uri数组，从而获取图片大小，并在页面上显示选择的图片。
 * 2. 手动模式压缩图片。先获取从图库选择的图片uris，然后将图片数据读取到buffer。通过createImageSource(buffer)创建图片源实例，设置解码参数
 * DecodingOptions，传入createPixelMap创建PixelMap图片对象originalPixelMap。使用scale进行图片尺寸压缩，使用packing进行图片质量压缩。
 * 3. 自动模式（指定压缩目标大小）优先压缩图片尺寸。优先使用scale对图片进行尺寸缩放，采用while循环每次递减reduceScaleVal倍数（对应‘scale每次
 * 缩小倍数’）进行尺寸缩放，再用packing（其中图片质量参数quality根据‘最低图片质量’设置）获取压缩后的图片大小，最终查找压缩到最接近指定图片压缩
 * 目标的大小，并获取图片压缩数据用于后续图片保存。
 * 4. 自动模式（指定压缩目标大小）优先压缩图片质量。先判断设置图片质量参数为0时，packing能压缩到的图片最小字节大小compressedImageData.byteLength
 * 是否满足指定的图片压缩大小。如果满足，则使用packing方式二分查找最接近指定图片压缩目标大小的quality来压缩图片。如果不满足，则图片质量按最低0进
 * 行设置，并调用scalePriorityCompress进行scale尺寸压缩。
 * 5. 压缩后的图片数据保存到相册。通过photoAccessHelper.getPhotoAccessHelper获取相册管理模块的实例，使用createAsset创建图片资源，然后使用
 * createImagePacker创建ImagePacker实例。最后调用imagePacker.packToFile传入压缩后的PixelMap图片源，对应的图片格式和质量参数packOpts，
 * 编码后打包进图片文件，图片将自动保存到相册。需要说明packToFile内部会进行packing操作，所以传入packToFile的PixelMap对象只是scale尺寸缩放
 * 后的图片数据，最终需要压缩的图片质量通过packOpts进行设置。
 */

const TAG = 'IMAGE_COMPRESSION';
const SPACE_SIX: number = 6; // 组件间距
const SPACE_THIRTY: number = 30; // 组件间距
const FONT_WEIGHT: number = 500;
const BYTE_CONVERSION: number = 1024; // 字节转换
const IMAGE_QUALITY_ZERO: number = 0; // 图片质量0
const IMAGE_QUALITY_HUNDRED: number = 100; // 图片质量100
const LAYOUT_WEIGHT: number = 1;
const SLIDER_ZERO_POINT_ZERO_ONE: number = 0.01;
const SLIDER_ZERO_POINT_FIVE: number = 0.50;
const SLIDER_ZERO: number = 0;
const SLIDER_ONE: number = 1;
const SLIDER_THIRTY: number = 30;
const SLIDER_ONE_HUNDRED: number = 100;

@Component
export struct ImageCompressionComponent {
  @State uris: Array<string> = []; // 保存图库选择的结果uri
  @State photoCount: number = 0; // 选择图片的个数
  @State beforeCompressFmt: string = ''; // 压缩前图片格式
  @State afterCompressFmt: string = ''; // 压缩后图片格式
  @State strMaxCompressedImageSize: string = ''; // 指定图片压缩目标大小
  @State beforeCompressByteLength: number = 0; // 压缩前图片字节长度
  @State @Watch('afterCompressChange') afterCompressionSize: string = ''; // 压缩后的图片大小,单位kb
  @State showPixelMap: image.PixelMap | undefined = undefined; // 页面上显示压缩后的图片
  @State savePixelMap: image.PixelMap | undefined = undefined; // 保存压缩后的图片
  @State @Watch('compressFormatChange') showCompressFormat: string = ''; // 在页面上显示压缩后的图片格式
  @State outputFormatIndex: number = 0; // 输出格式初始项，默认原格式
  @State isAutoMode: boolean = true; // 是否自动压缩模式
  @State isQualityPriority: boolean = true; // 是否质量优先
  @State imageQualityVal: number = 100; // 图片质量
  @State autoModeQuality: number = 0; // 自动模式保存图片的质量
  @State imageScaleVal: number = 100; // 图片缩放尺寸
  @State reduceScaleVal: number = 0.40; // 自动压缩如果需要压缩尺寸，在循环压缩尺寸过程中设置每次缩小的尺寸倍数
  @State minBisectUnit: number = 10; // packing最小二分单位
  @State minQuality: number = 100; // 最低图片质量
  @State beforeCompressImgSize: string = ''; // 压缩前图片宽高
  @State afterCompressImgSize: string = ''; // 压缩后图片宽高
  @State keyboardHeight: number = 0; // 软键盘高度
  private scrollerForLiftUp: Scroller = new Scroller();
  private maxCompressedImageSize: number = 0; // 指定图片压缩目标大小，单位kb
  private outputFormat: string[] = ['原格式', 'PNG', 'JPG', 'WEBP']; // 图片输出格式
  private context: Context = getContext(this); // 获取getPhotoAccessHelper需要的context
  private testUri: string = ''; // 测试图片uri

  aboutToAppear(): void {
    // 虚拟键盘抬起时，页面的避让模式设置为RESIZE模式
    let context = getContext(this) as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (data: number) => {
        this.keyboardHeight = px2vp(data);
      })
    })
  }

  /**
   * 压缩后图片大小，仅用于自动化用例验证
   */
  afterCompressChange() {
    emitter.emit('ImageCompression0', {
      data: {
        afterCompressionSize: this.afterCompressionSize
      }
    });
  }

  /**
   * 压缩后图片格式，仅用于自动化用例验证
   */
  compressFormatChange() {
    emitter.emit('ImageCompression1', {
      data: {
        showCompressFormat: this.showCompressFormat
      }
    });
  }

  /**
   * 测试图片保存到图库
   */
  async saveTestPhoto(context: common.UIAbilityContext) {
    let helper = photoAccessHelper.getPhotoAccessHelper(context);
    try {
      this.beforeCompressFmt = 'jpeg';
      this.afterCompressFmt = this.beforeCompressFmt;
      // 创建图片文件
      this.uris[0] = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpeg');
      // 打开文件
      let file = await fileIo.open(this.uris[0], fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      // 获取测试图片
      context.resourceManager.getMediaContent($r('app.media.image_compression_test').id, 0)
        .then(async value => {
          let media = value.buffer;
          await fileIo.write(file.fd, media);
          this.beforeCompressByteLength = fs.statSync(file.fd).size;
          await fileIo.close(file.fd);
          promptAction.showToast({ message: $r('app.string.image_compression_save_test_image') });
          // 设置photoCount，用于刷新显示压缩前图片
          this.photoCount = 1;
          this.testUri = this.uris[0];
          emitter.emit('ImageCompression2', {
            data: {
              testUri: this.testUri
            }
          });
        });
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      hilog.error(0x0000, TAG, `Failed to save photo. Code is ${err.code}, message is ${err.message}`);
    }
  }

  /**
   * 自动压缩
   */
  autoCompression() {
    // 获取图库中选择的图片路径
    const ALBUM_PATH: string = this.uris[0];
    const file = fs.openSync(ALBUM_PATH, fs.OpenMode.READ_ONLY);
    let buffer: ArrayBuffer = new ArrayBuffer(fs.statSync(file.fd).size);
    // 读取图片到buffer
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);
    // 通过缓冲区创建图片源实例
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    // 设置解码参数DecodingOptions，解码获取PixelMap图片对象。
    const decodingOptions: image.DecodingOptions = {
      editable: true, // 是否可编辑。当取值为false时，图片不可二次编辑，如crop等操作将失败。
    }
    // 创建pixelMap
    imageSource.createPixelMap(decodingOptions).then((originalPixelMap: image.PixelMap) => {
      // 压缩图片
      this.compressedImage(originalPixelMap, this.maxCompressedImageSize).then(() => {
        promptAction.showToast({ message: $r('app.string.image_compression_compress_completed') });
      })
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Failed to create PixelMap, error code: ${err.code}, message: ${err.message}.`);
    });
  }

  /**
   * 手动压缩
   */
  manualCompression() {
    // TODO 知识点：手动压缩图片。先获取从图库选择的图片uris，然后将图片数据读取到buffer。通过createImageSource(buffer)创建图片源实例，设置解码参数DecodingOptions，传入createPixelMap创建PixelMap图片对象originalPixelMap。使用scale进行图片尺寸压缩，使用packing进行图片质量压缩。
    const ALBUM_PATH: string = this.uris[0];
    const file = fs.openSync(ALBUM_PATH, fs.OpenMode.READ_ONLY);
    let buffer = new ArrayBuffer(fs.statSync(file.fd).size);
    fs.readSync(file.fd, buffer);
    fs.closeSync(file);
    const decodingOptions: image.DecodingOptions = { editable: true };
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    imageSource.createPixelMap(decodingOptions).then(async (originalPixelMap: image.PixelMap) => {
      // 使用scale对图片进行缩放。入参分别为图片宽高的缩放倍数
      await originalPixelMap.scale(this.imageScaleVal / 100, this.imageScaleVal / 100);
      // savePixelMap用于把压缩后的图片保存到图库时使用。由于保存图片时调用的packToFile内部会做类似packing的处理，所以这里只保存scale缩放尺寸后的PixelMap。
      this.savePixelMap = originalPixelMap;
      // packing压缩图片
      let compressedImageData: ArrayBuffer =
        await this.packing(originalPixelMap, this.imageQualityVal, this.afterCompressFmt);
      // 压缩后的ArrayBuffer数据转PixelMap
      let imageSource = image.createImageSource(compressedImageData);
      let opts: image.DecodingOptions = { editable: true };
      // showPixelMap用于显示压缩后的图片
      this.showPixelMap = await imageSource.createPixelMap(opts);
      // showCompressFormat用于显示压缩后的图片格式
      this.showCompressFormat = this.afterCompressFmt;
      // 显示估算packing压缩后的图片大小。该图片在内存中作为ArrayBuffer数据的压缩后大小，这一数值并不直接等同于该图片在最终保存到相册时的实际文件大小。
      this.afterCompressionSize = (compressedImageData.byteLength / BYTE_CONVERSION).toFixed(1);
      promptAction.showToast({ message: $r('app.string.image_compression_compress_completed') });
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `Failed to create PixelMap, error code: ${err.code}, message: ${err.message}.`);
    });
  }

  /**
   * 图片压缩
   * @param sourcePixelMap：原始待压缩图片的PixelMap对象
   * @param maxCompressedImageSize：指定图片的压缩目标大小，单位kb
   */
  async compressedImage(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number): Promise<void> {
    // 判断是优先压缩质量还是优先压缩尺寸
    if (this.isQualityPriority) {
      // 优先压缩质量
      await this.qualityPriorityCompress(sourcePixelMap, maxCompressedImageSize);
    } else {
      // 优先压缩尺寸
      await this.scalePriorityCompress(sourcePixelMap, maxCompressedImageSize, this.minQuality);
    }
  }

  /**
   * 优先压缩图片质量
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param maxCompressedImageSize 指定图片的压缩目标大小
   */
  async qualityPriorityCompress(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number) {
    // TODO 知识点：自动模式（指定压缩目标大小）优先压缩图片质量。先判断设置图片质量参数为0时，packing能压缩到的图片最小字节大小compressedImageData.byteLength是否满足指定的图片压缩大小。如果满足，则使用packing方式二分查找最接近指定图片压缩目标大小的quality来压缩图片。如果不满足，则图片质量按最低0进行设置，并调用scalePriorityCompress进行scale尺寸压缩。
    let compressedImageData: ArrayBuffer =
      await this.packing(sourcePixelMap, IMAGE_QUALITY_ZERO, this.afterCompressFmt);
    // 先判断图片质量参数设置最低0能否满足目标大小。如果能满足目标大小，则直接使用packing二分图片质量。如果不满足，则质量参数固定为0，进行scale尺寸压缩
    if (compressedImageData.byteLength <= maxCompressedImageSize * BYTE_CONVERSION) {
      // 满足目标大小，直接使用packing二分
      await this.packingImage(sourcePixelMap, compressedImageData, maxCompressedImageSize * BYTE_CONVERSION);
    } else {
      // 不满足目标大小，质量参数设置为0，再进行scale尺寸压缩
      await this.scalePriorityCompress(sourcePixelMap, maxCompressedImageSize, IMAGE_QUALITY_ZERO);
    }
    // 更新显示压缩后的图片格式
    this.showCompressFormat = this.afterCompressFmt;
  }

  /**
   * 优先压缩图片尺寸
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param maxCompressedImageSize 指定图片的压缩目标大小
   * @param quality
   */
  async scalePriorityCompress(sourcePixelMap: image.PixelMap, maxCompressedImageSize: number, quality: number) {
    // TODO 知识点：自动模式（指定压缩目标大小）优先压缩图片尺寸。优先使用scale对图片进行尺寸缩放，采用while循环每次递减reduceScaleVal倍数（对应‘scale每次缩小倍数’）进行尺寸缩放，再用packing（其中图片质量参数quality根据‘最低图片质量’设置）获取压缩后的图片大小，最终查找压缩到最接近指定图片压缩目标的大小，并获取图片压缩数据用于后续图片保存。
    let compressedImageData: ArrayBuffer = await this.packing(sourcePixelMap, quality, this.afterCompressFmt);
    // 如果调整过最低图片质量，先计算最低图片质量是否满足要求。如果设定的最低图片质量已经满足目标大小，则直接返回
    if (quality !== IMAGE_QUALITY_HUNDRED &&
      (compressedImageData.byteLength <= maxCompressedImageSize * BYTE_CONVERSION)) {
      // 保存最终压缩的图片质量，用于保存到图库时使用
      this.autoModeQuality = quality;
      // ArrayBuffer转PixelMap，并保存图片相关数据
      let imageSource = image.createImageSource(compressedImageData);
      let opts: image.DecodingOptions = { editable: true };
      this.showPixelMap = await imageSource.createPixelMap(opts);
      this.savePixelMap = sourcePixelMap;
      this.afterCompressionSize = (compressedImageData.byteLength / BYTE_CONVERSION).toFixed(1);
      // 更新显示压缩后的图片格式
      this.showCompressFormat = this.afterCompressFmt;
      return;
    }
    // scale压缩图片尺寸。采用while循环每次递减reduceScaleVal，最终查找到最接近指定图片压缩目标大小的缩放倍数的图片压缩数据。
    let imageScale = 1; // 定义图片宽高的缩放倍数，1表示原比例。
    const REDUCE_SCALE = this.reduceScaleVal;
    const AFTER_COMPRESS_FMT = this.afterCompressFmt;
    // 判断压缩后的图片大小是否大于指定图片的压缩目标大小，如果大于，继续降低缩放倍数压缩。
    while (compressedImageData.byteLength > maxCompressedImageSize * BYTE_CONVERSION) {
      if (imageScale > 0) {
        // 性能知识点: 由于scale会直接修改图片PixelMap数据，所以不适用二分查找scale缩放倍数。这里采用循环递减reduceScaleVal倍缩放图片，
        // 来查找确定最适合的缩放倍数。如果对图片压缩质量要求不高，建议调高每次递减的缩放倍数，减少循环，提升scale压缩性能。
        imageScale = imageScale - REDUCE_SCALE; // 每次缩放倍数减
        // 使用scale对图片尺寸进行缩放
        await sourcePixelMap.scale(imageScale, imageScale);
        // packing压缩
        compressedImageData = await this.packing(sourcePixelMap, quality, AFTER_COMPRESS_FMT);
      } else {
        // imageScale缩放倍数小于等于0时，没有意义，结束压缩。
        break;
      }
    }
    this.autoModeQuality = quality;
    let imageSource = image.createImageSource(compressedImageData);
    let opts: image.DecodingOptions = { editable: true };
    this.showPixelMap = await imageSource.createPixelMap(opts);
    this.savePixelMap = sourcePixelMap;
    this.afterCompressionSize = (compressedImageData.byteLength / BYTE_CONVERSION).toFixed(1);
    this.showCompressFormat = this.afterCompressFmt;
    // 可能会存在scale每次缩小倍数设置过大，导致无法压缩到图片压缩目标大小，弹窗提示
    if (compressedImageData.byteLength > maxCompressedImageSize * BYTE_CONVERSION) {
      AlertDialog.show({
        message: $r('app.string.image_compression_scale_priority_compress_msg'),
        alignment: DialogAlignment.Center
      });
    }
  }

  /**
   * packing二分方式循环压缩
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param compressedImageData 图片压缩的ArrayBuffer
   * @param maxCompressedImageByte 压缩目标图像字节长度
   */
  async packingImage(sourcePixelMap: image.PixelMap, compressedImageData: ArrayBuffer, maxCompressedImageByte: number) {
    let imageQuality: number = 0;
    const DICHOTOMY_ACCURACY = this.minBisectUnit;
    // 图片质量参数范围为0-100，这里以minBisectUnit为最小二分单位创建用于packing二分图片质量参数的数组。
    const packingArray: number[] = [];
    // 性能知识点: 如果对图片压缩质量要求不高，建议调高minBisectUnit（对应‘packing最小二分单位’），减少循环，提升packing压缩性能。
    for (let i = 0; i <= 100; i += DICHOTOMY_ACCURACY) {
      packingArray.push(i);
    }
    let left = 0; // 定义二分搜索范围的左边界
    let right = packingArray.length - 1; // 定义二分搜索范围的右边界
    const AFTER_COMPRESS_FMT = this.afterCompressFmt;
    // 二分压缩图片
    while (left <= right) {
      const mid = Math.floor((left + right) / 2); // 定义二分搜索范围的中间位置
      imageQuality = packingArray[mid]; // 获取二分中间位置的图片质量值
      // 根据传入的图片质量参数进行packing压缩，返回压缩后的图片文件流数据。
      compressedImageData = await this.packing(sourcePixelMap, imageQuality, AFTER_COMPRESS_FMT);
      // 判断查找一个尽可能接近但不超过压缩目标的压缩大小
      if (compressedImageData.byteLength <= maxCompressedImageByte) {
        // 二分目标值在右半边，继续在更高的图片质量参数（即mid + 1）中搜索
        left = mid + 1;
        // 判断mid是否已经二分到最后，如果二分完了，退出
        if (mid === packingArray.length - 1) {
          break;
        }
        // 获取下一次二分的图片质量参数（mid+1）压缩的图片文件流数据
        compressedImageData = await this.packing(sourcePixelMap, packingArray[mid + 1], AFTER_COMPRESS_FMT);
        // 判断用下一次图片质量参数（mid+1）压缩的图片大小是否大于指定图片的压缩目标大小。如果大于，说明当前图片质量参数（mid）压缩出来的
        // 图片大小最接近指定图片的压缩目标大小。传入当前图片质量参数mid，得到最终目标图片压缩数据。
        if (compressedImageData.byteLength > maxCompressedImageByte) {
          compressedImageData = await this.packing(sourcePixelMap, packingArray[mid], AFTER_COMPRESS_FMT);
          break;
        }
      } else {
        // 目标值不在当前范围的右半部分，将搜索范围的右边界向左移动，以缩小搜索范围并继续在下一次迭代中查找左半部分。
        right = mid - 1;
      }
    }
    // 保存最终压缩的图片质量，用于保存到图库时使用
    this.autoModeQuality = imageQuality;
    // ArrayBuffer转PixelMap，并保存相关数据
    let imageSource = image.createImageSource(compressedImageData);
    let opts: image.DecodingOptions = { editable: true };
    this.showPixelMap = await imageSource.createPixelMap(opts);
    this.savePixelMap = sourcePixelMap;
    this.afterCompressionSize = (compressedImageData.byteLength / BYTE_CONVERSION).toFixed(1);
  }

  /**
   * packing压缩
   * @param sourcePixelMap 原始待压缩图片的PixelMap
   * @param imageQuality 图片质量参数
   * @param packingFormat 目标格式。当前只支持"image/jpeg"、"image/webp" 和 "image/png"
   * @returns data 返回压缩后的图片数据
   */
  async packing(sourcePixelMap: image.PixelMap, imageQuality: number, packingFormat: string): Promise<ArrayBuffer> {
    const imagePackerApi = image.createImagePacker();
    const packOpts: image.PackingOption = { format: 'image/' + packingFormat, quality: imageQuality };
    const data: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
    return data;
  }

  /**
   * 拉起图库选择图片
   */
  async selectPhotoFromAlbum() {
    // TODO 知识点：拉起图库选择要压缩的图片。使用photoAccessHelper.PhotoViewPicker创建图库选择器实例photoViewPicker，调用photoViewPicker.select()接口拉起图库界面进行图片选择。图片选择成功后，返回photoSelectResult结果集。从photoSelectResult.photoUris中获取返回图库选择后的媒体文件的uri数组，从而获取图片大小，并在页面上显示选择的图片。
    // 创建图库选项实例
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 设置选择的媒体文件类型为Image
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置选择媒体文件的最大数目
    photoSelectOptions.maxSelectNumber = 1;
    // 创建图库选择器实例
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    // 调用photoViewPicker.select()接口拉起图库界面进行图片选择，图片选择成功后，返回photoSelectResult结果集。
    photoViewPicker.select(photoSelectOptions).then((photoSelectResult) => {
      // select返回的uri权限是只读权限，需要将uri写入全局变量@State中即可进行读取文件数据操作。
      this.uris = photoSelectResult.photoUris;
      this.photoCount = this.uris.length;
      if (this.photoCount > 0) {
        const ALBUM_PATH: string = photoSelectResult.photoUris[0];
        // 找到最后一个点（.）的索引位置
        let lastDotIndex = ALBUM_PATH.lastIndexOf('.');
        // 使用slice方法从最后一个点之后的位置开始截取字符串到末尾
        this.beforeCompressFmt =
          ALBUM_PATH.slice(lastDotIndex + 1) === 'jpg' ? 'jpeg' : ALBUM_PATH.slice(lastDotIndex + 1);
        this.afterCompressFmt = this.beforeCompressFmt;
        // 读取选择图片的buffer
        const file = fs.openSync(ALBUM_PATH, fs.OpenMode.READ_ONLY);
        // 获取选择图片的字节长度
        this.beforeCompressByteLength = fs.statSync(file.fd).size;
        fs.closeSync(file);
      }
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, `PhotoViewPicker.select failed :, error code: ${err.code}, message: ${err.message}.`);
    })
  }

  /**
   * 保存图片到图库
   * @returns
   */
  async saveImageToAlbum(): Promise<void> {
    // TODO 知识点：压缩后的图片数据保存到相册。通过photoAccessHelper.getPhotoAccessHelper获取相册管理模块的实例，使用createAsset创建图片资源，然后使用createImagePacker创建ImagePacker实例。最后调用imagePacker.packToFile传入压缩后的PixelMap图片源，对应的图片格式和质量参数packOpts，编码后打包进图片文件，图片将自动保存到相册。需要说明packToFile内部会进行packing操作，所以传入packToFile的PixelMap对象只是scale尺寸缩放后的图片数据，最终需要压缩的图片质量通过packOpts进行设置。
    // 获取相册管理模块的实例
    const HELPER = photoAccessHelper.getPhotoAccessHelper(this.context);
    // 指定待创建的文件类型、后缀和创建选项，创建图片资源
    const URI = await HELPER.createAsset(photoAccessHelper.PhotoType.IMAGE, this.afterCompressFmt);
    let file = await fs.open(URI, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let imagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = {
      format: 'image/' + this.afterCompressFmt,
      quality: this.isAutoMode ? this.autoModeQuality : this.imageQualityVal
    };
    // 指定打包参数，将PixelMap图片源编码后直接打包进文件
    imagePacker.packToFile(this.savePixelMap, file.fd, packOpts, async (err: BusinessError) => {
      if (err) {
        hilog.error(0x0000, TAG, `Failed to pack the image to file, error code: ${err.code}, message: ${err.message}.`);
      } else {
        promptAction.showToast({ message: $r('app.string.image_compression_save_image_msg') });
      }
      // TODO 知识点：使用packToFile方法，需要调用imagePacker.release主动释放imagePacker，打开图库时才能看到新存入的图片
      await fs.close(file.fd).finally(() => {
        imagePacker.release();
      })
    })
  }

  /**
   * 获取当前选中的输出格式
   * @returns selectFormat 格式名
   */
  getSelectFormat(): string {
    let selectFormat: string = '';
    switch (this.outputFormatIndex) {
      case 0: // 原格式
        selectFormat = this.beforeCompressFmt;
        break;
      case 1: // PNG
        selectFormat = 'png';
        break;
      case 2: // JPEG
        selectFormat = 'jpeg';
        break;
      case 3: // WEBP
        selectFormat = 'webp';
        break;
    }
    return selectFormat;
  }

  /**
   * 使用测试图片，点击按钮后测试图片会保存到相册
   */
  @Builder
  useTestImage() {
    Row() {
      Text($r('app.string.image_compression_use_test_image'))
        .fontWeight(FONT_WEIGHT)
        .fontSize($r('app.integer.image_compression_font_size_sixteen'))
      SaveButton({ text: SaveDescription.SAVE_TO_GALLERY, buttonType: ButtonType.Normal })
        .height($r('app.integer.image_compression_size_twenty_four'))
        .fontSize($r('app.integer.image_compression_font_size_thirteen'))
        .borderRadius($r('app.integer.image_compression_eight'))
        .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
          if (result === SaveButtonOnClickResult.SUCCESS) {
            const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            // 保存测试图片
            this.saveTestPhoto(context);
          }
        })
    }
    .width($r('app.string.image_compression_full_size'))
    .height($r('app.integer.image_compression_size_twenty_eight'))
    .padding({
      left: $r('app.integer.image_compression_fifteen')
    })
  }

  /**
   * 显示压缩前和压缩后图片
   */
  @Builder
  displayImage() {
    Row() {
      Text($r('app.string.image_compression_before_compression'))
        .fontWeight(FONT_WEIGHT)
        .fontSize($r('app.integer.image_compression_font_size_sixteen'))
      if (this.photoCount > 0) {
        Text((this.beforeCompressByteLength / BYTE_CONVERSION).toFixed(1))
          .fontWeight(FONT_WEIGHT)
          .fontSize($r('app.integer.image_compression_font_size_twenty'))
          .fontColor($r('app.color.image_compression_display_image_color'))
        Text($r('app.string.image_compression_before_compression_kb'))
          .fontSize($r('app.integer.image_compression_font_size_sixteen'))
        Text(this.beforeCompressFmt).fontSize($r('app.integer.image_compression_font_size_sixteen'))
      }
    }
    .width($r('app.string.image_compression_full_size'))
    .padding({
      left: $r('app.integer.image_compression_fifteen'),
      right: $r('app.integer.image_compression_fifteen')
    })
    .margin({ bottom: $r('app.integer.image_compression_five') })

    Column() {
      if (this.photoCount > 0) {
        Image(this.uris[0])
          .objectFit(ImageFit.Contain)
          .onComplete((event) => {
            if (event) {
              this.beforeCompressImgSize = event?.width.toString() + '*' + event?.height.toString();
            }
          })
        Text(this.beforeCompressImgSize)
          .fontSize($r('app.integer.image_compression_font_size_thirteen'))
          .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
          .margin($r('app.integer.image_compression_ten'))
      } else {
        Image($r("app.media.image_compression_add_photo"))
          .objectFit(ImageFit.None)
          .height($r('app.integer.image_compression_fifty'))
          .margin({ top: $r('app.integer.image_compression_thirty'), bottom: $r('app.integer.image_compression_ten') })
        Text($r('app.string.image_compression_click_add_image'))
          .fontSize($r('app.integer.image_compression_font_size_fourteen'))
      }
    }
    .onClick(() => {
      // 初始化
      this.afterCompressionSize = '';
      this.outputFormatIndex = 0;
      // 拉起图库选择图片
      this.selectPhotoFromAlbum();
    })
    .width($r('app.string.image_compression_seventy_percent'))
    .height($r('app.integer.image_compression_hundred_fifty'))
    .backgroundColor(Color.White)
    .padding($r('app.integer.image_compression_five'))
    .margin({ bottom: $r('app.integer.image_compression_fifteen') })
    .borderRadius($r('app.integer.image_compression_five'))

    Row() {
      Text($r('app.string.image_compression_after_compression'))
        .fontWeight(FONT_WEIGHT)
        .fontSize($r('app.integer.image_compression_font_size_sixteen'))
      Text(this.afterCompressionSize)
        .fontWeight(FONT_WEIGHT)
        .fontSize($r('app.integer.image_compression_font_size_twenty'))
        .fontColor($r('app.color.image_compression_display_image_color'))
      if (this.afterCompressionSize !== '') {
        Text($r('app.string.image_compression_before_compression_kb'))
          .fontSize($r('app.integer.image_compression_font_size_sixteen'))
        Text(this.showCompressFormat)
          .fontSize($r('app.integer.image_compression_font_size_sixteen'))
      }
      Blank()
      HelpDescription({ info: $r('app.string.image_compression_info_after_compress') })
    }
    .width($r('app.string.image_compression_full_size'))
    .padding({
      left: $r('app.integer.image_compression_fifteen'),
      right: $r('app.integer.image_compression_fifteen')
    })
    .margin({ top: $r('app.integer.image_compression_ten'), bottom: $r('app.integer.image_compression_five') })

    Column() {
      if (this.afterCompressionSize !== '') {
        Image(this.showPixelMap)
          .objectFit(ImageFit.Contain)
          .onComplete((event) => {
            if (event) {
              this.afterCompressImgSize = event?.width.toString() + '*' + event?.height.toString();
              emitter.emit('ImageCompression3', {
                data: {
                  afterCompressImgSize: this.afterCompressImgSize
                }
              });
            }
          })
        Text(this.afterCompressImgSize)
          .fontSize($r('app.integer.image_compression_font_size_thirteen'))
          .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
          .margin($r('app.integer.image_compression_ten'))
      }
    }
    .width($r('app.string.image_compression_seventy_percent'))
    .height($r('app.integer.image_compression_hundred_fifty'))
    .backgroundColor(Color.White)
    .padding($r('app.integer.image_compression_five'))
    .margin({ bottom: $r('app.integer.image_compression_twenty') })
    .borderRadius($r('app.integer.image_compression_five'))
  }

  /**
   * 压缩模式
   */
  @Builder
  compressMode() {
    Row() {
      Text($r('app.string.image_compression_compress_mode'))
        .fontWeight(FONT_WEIGHT)
        .fontSize($r('app.integer.image_compression_font_size_sixteen'))
      Radio({ value: 'autoMode', group: 'compressMode' })
        .width($r('app.integer.image_compression_twenty'))
        .height($r('app.integer.image_compression_twenty'))
        .checked(true)
        .id('autoMode')
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.isAutoMode = true;
          }
        })
      Text($r('app.string.image_compression_auto_mode'))
        .fontSize($r('app.integer.image_compression_font_size_fourteen'))
        .margin({ right: $r('app.integer.image_compression_fifteen') })
      Radio({ value: 'manualMode', group: 'compressMode' })
        .width($r('app.integer.image_compression_twenty'))
        .height($r('app.integer.image_compression_twenty'))
        .checked(false)
        .id('manualMode')
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.isAutoMode = false;
          }
        })
      Text($r('app.string.image_compression_manual_mode'))
        .fontSize($r('app.integer.image_compression_font_size_fourteen'))
      Blank()
      HelpDescription({ info: $r('app.string.image_compression_info_compress_mode') })
    }
    .width($r('app.string.image_compression_full_size'))
    .height($r('app.integer.image_compression_forty_eight'))
    .padding({
      left: $r('app.integer.image_compression_fifteen'),
      right: $r('app.integer.image_compression_fifteen'),
      top: $r('app.integer.image_compression_ten'),
      bottom: $r('app.integer.image_compression_ten')
    })
    .borderRadius($r('app.integer.image_compression_ten'))
    .backgroundColor(Color.White)
  }

  /**
   * 压缩相关设置
   */
  @Builder
  compressSettingItems() {
    Scroll() {
      Column({ space: SPACE_SIX }) {
        Column() {
          Row() {
            Text($r('app.string.image_compression_max_compressed_image_size'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            TextInput({
              text: $$this.strMaxCompressedImageSize // $$运算符为系统内置组件提供TS变量的引用，使得TS变量和系统内置组件的内部状态保持同步。
            })
              .id('textInput')
              .width($r('app.integer.image_compression_hundred'))
              .height($r('app.integer.image_compression_thirty_six'))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .enabled(this.isAutoMode)
              .type(InputType.NUMBER_DECIMAL)// 带小数点的数字输入模式。支持数字，小数点（只能存在一个小数点）。
              .onChange((value: string) => {
                // 由于TextInput组件的InputType.NUMBER_DECIMAL能力对输入的0个数和'.'的位置没有限制，会存在'000.8'，'008'和'.008'也能输入的情况，所以需要手动限制'0'和'.'。
                if (value.charAt(0) === '.') {
                  // 如果字符串第一个字符是'.'时,TextInput的值重置为''
                  this.strMaxCompressedImageSize = '';
                } else if (value.charAt(0) === '0' && value.length > 1 && value.charAt(1) !== '.') {
                  // value长度为2时，第一个字符是'0'，第二个字符输入还是'0'，则TextInput重置为'0'。否则，用空字符串替换字符串开头所有0。比如，数字8006，删除'8'后，TextInput显示为6。
                  this.strMaxCompressedImageSize =
                    (value.length === 2 && value.charAt(1) === '0') ? '0' : value.replace(/^0+/, '');
                } else {
                  this.strMaxCompressedImageSize = value;
                }
                this.maxCompressedImageSize = Number(value);
              })
            Text($r('app.string.image_compression_kb'))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
              .margin({ left: $r('app.integer.image_compression_twelve') })
            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_max_compress_image_size') })
          }
          .width($r('app.string.image_compression_full_size'))
          .height($r('app.integer.image_compression_forty_eight'))

          Row() {
            Text($r('app.string.image_compression_reduce_scale'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Slider({
              value: this.reduceScaleVal,
              min: SLIDER_ZERO_POINT_ZERO_ONE,
              max: SLIDER_ZERO_POINT_FIVE,
              style: SliderStyle.OutSet,
              step: SLIDER_ZERO_POINT_ZERO_ONE
            })
              .id('scaleSlider')
              .enabled(this.isAutoMode)
              .width($r('app.integer.image_compression_hundred'))
              .onChange((value: number) => {
                this.reduceScaleVal = Number(value.toFixed(2));
              })
            Text(this.reduceScaleVal.toString())
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_every_time_reduce_scale') })
          }
          .width($r('app.string.image_compression_full_size'))
          .height($r('app.integer.image_compression_forty_eight'))

          Row() {
            Text($r('app.string.image_compression_compress_priority'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Radio({ value: 'qualityPriority', group: 'compressPriority' })
              .width($r('app.integer.image_compression_twenty'))
              .height($r('app.integer.image_compression_twenty'))
              .enabled(this.isAutoMode)
              .checked(true)
              .id('qualityPriority')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.isQualityPriority = true;
                }
              })
            Text($r('app.string.image_compression_quality_priority'))
              .fontSize($r('app.integer.image_compression_font_size_thirteen'))
              .margin({ right: $r('app.integer.image_compression_five') })
            Radio({ value: 'scalePriority', group: 'compressPriority' })
              .width($r('app.integer.image_compression_twenty'))
              .height($r('app.integer.image_compression_twenty'))
              .enabled(this.isAutoMode)
              .checked(false)
              .id('scalePriority')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.isQualityPriority = false;
                }
              })
            Text($r('app.string.image_compression_scale_priority'))
              .fontSize($r('app.integer.image_compression_font_size_thirteen'))

            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_compress_priority') })
          }
          .width($r('app.string.image_compression_full_size'))
          .height($r('app.integer.image_compression_forty_eight'))

          Row() {
            Text($r('app.string.image_compression_bisect_unit'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Slider({
              value: this.minBisectUnit,
              min: SLIDER_ONE,
              max: SLIDER_THIRTY,
              style: SliderStyle.OutSet
            })
              .id('packingSlider')
              .width($r('app.integer.image_compression_hundred'))
              .enabled(this.isAutoMode && this.isQualityPriority)
              .onChange((value: number) => {
                this.minBisectUnit = value;
              })
            Text(this.minBisectUnit.toFixed(0))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_min_bisect_unit') })
          }
          .height($r('app.integer.image_compression_forty_eight'))
          .width($r('app.string.image_compression_full_size'))
          .opacity(this.isQualityPriority ? $r('app.integer.image_compression_opacity_one') :
          $r('app.float.image_compression_opacity_zero_point_five'))

          Row() {
            Text($r('app.string.image_compression_min_quality'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Slider({
              value: this.minQuality,
              min: SLIDER_ZERO,
              max: SLIDER_ONE_HUNDRED,
              style: SliderStyle.OutSet
            })
              .id('minQualitySlider')
              .width($r('app.integer.image_compression_hundred'))
              .enabled(this.isAutoMode && !this.isQualityPriority)
              .onChange((value: number) => {
                this.minQuality = value;
              })
            Text(this.minQuality.toFixed(0))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_min_quality') })
          }
          .width($r('app.string.image_compression_full_size'))
          .height($r('app.integer.image_compression_forty_eight'))
          .opacity(!this.isQualityPriority ? $r('app.integer.image_compression_opacity_one') :
          $r('app.float.image_compression_opacity_zero_point_five'))
        }
        .width($r('app.string.image_compression_full_size'))
        .height($r('app.integer.image_compression_two_hundred_fifty_six'))
        .borderRadius($r('app.integer.image_compression_ten'))
        .backgroundColor(Color.White)
        .opacity(this.isAutoMode ? $r('app.integer.image_compression_opacity_one') :
        $r('app.float.image_compression_opacity_zero_point_five'))
        .padding({
          left: $r('app.integer.image_compression_fifteen'),
          right: $r('app.integer.image_compression_fifteen'),
          top: $r('app.integer.image_compression_eight'),
          bottom: $r('app.integer.image_compression_eight')
        })

        Column() {
          Row() {
            Text($r('app.string.image_compression_image_quality'))
              .width($r('app.integer.image_compression_eighty'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Slider({
              value: this.imageQualityVal,
              min: SLIDER_ZERO,
              max: SLIDER_ONE_HUNDRED,
              style: SliderStyle.OutSet
            })
              .enabled(!this.isAutoMode)
              .width($r('app.integer.image_compression_hundred_fifty'))
              .id('imageQuality')
              .onChange((value: number) => {
                this.imageQualityVal = value;
              })
            Text(this.imageQualityVal.toFixed(0))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_image_quality_value') })
          }
          .width($r('app.string.image_compression_full_size'))

          Row() {
            Text($r('app.string.image_compression_image_scale'))
              .width($r('app.integer.image_compression_eighty'))
              .fontWeight(FONT_WEIGHT)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Slider({
              value: this.imageScaleVal,
              min: SLIDER_ONE,
              max: SLIDER_ONE_HUNDRED,
              style: SliderStyle.OutSet
            })
              .enabled(!this.isAutoMode)
              .width($r('app.integer.image_compression_hundred_fifty'))
              .id('imageScale')
              .onChange((value: number) => {
                this.imageScaleVal = value;
              })
            Text(this.imageScaleVal.toFixed(0))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
            Text($r('app.string.image_compression_percentage'))
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
              .opacity($r('app.float.image_compression_opacity_zero_point_eight'))
            Blank()
            HelpDescription({ info: $r('app.string.image_compression_info_image_scale_value') })
          }
          .width($r('app.string.image_compression_full_size'))
        }
        .opacity(!this.isAutoMode ? $r('app.integer.image_compression_opacity_one') :
        $r('app.float.image_compression_opacity_zero_point_five'))
        .width($r('app.string.image_compression_full_size'))
        .height($r('app.integer.image_compression_ninety_six'))
        .borderRadius($r('app.integer.image_compression_ten'))
        .backgroundColor(Color.White)
        .padding({
          left: $r('app.integer.image_compression_fifteen'),
          right: $r('app.integer.image_compression_fifteen'),
          top: $r('app.integer.image_compression_eight'),
          bottom: $r('app.integer.image_compression_eight')
        })
      }
    }
    .id('setScroll')
    .scrollBar(BarState.Off)
    .height($r('app.integer.image_compression_one_hundred_seventy'))
  }

  /**
   * 输出格式
   */
  @Builder
  outputFormatSet() {
    Row() {
      Text($r('app.string.image_compression_output_format'))
        .fontSize($r('app.integer.image_compression_font_size_sixteen'))
        .fontWeight(FONT_WEIGHT)
      Blank()
      Row() {
        Text(this.outputFormat[this.outputFormatIndex])
          .fontSize($r('app.integer.image_compression_font_size_fifteen'))
          .opacity($r('app.float.image_compression_opacity_zero_point_eight'))

        Image($r('app.media.image_compression_spinner'))
          .width($r('app.integer.image_compression_twenty_two'))
          .height($r('app.integer.image_compression_sixteen'))
          .opacity($r('app.float.image_compression_opacity_zero_point_five'))
          .margin({ left: $r('app.integer.image_compression_eight'), right: $r('app.integer.image_compression_eight') })
      }
      .id('outputFormat')
      .bindMenu(this.outputFormatMenu(), { placement: Placement.Top })

      HelpDescription({ info: $r('app.string.image_compression_info_output_format_set') })
    }
    .width($r('app.string.image_compression_full_size'))
    .height($r('app.integer.image_compression_forty_eight'))
    .borderRadius($r('app.integer.image_compression_ten'))
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.integer.image_compression_fifteen'),
      right: $r('app.integer.image_compression_fifteen'),
      top: $r('app.integer.image_compression_ten'),
      bottom: $r('app.integer.image_compression_ten')
    })
  }

  /**
   * 输出格式菜单
   */
  @Builder
  outputFormatMenu() {
    Column() {
      ForEach(this.outputFormat, (item: string, index: number) => {
        Column() {
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Text(item)
              .fontSize($r('app.integer.image_compression_font_size_fifteen'))
            Image($r('app.media.image_compression_ok'))
              .visibility(this.outputFormatIndex === index ? Visibility.Visible : Visibility.Hidden)
              .width($r('app.integer.image_compression_twenty'))
              .height($r('app.integer.image_compression_twenty'))
          }
          .height($r('app.integer.image_compression_forty_eight'))

          Divider()
            .visibility(index !== 3 ? Visibility.Visible : Visibility.Hidden)
            .width($r('app.string.image_compression_full_size'))
        }
        .width($r('app.integer.image_compression_eighty'))
        .onClick(() => {
          this.outputFormatIndex = index;
          switch (item) {
            case '原格式':
              this.afterCompressFmt = this.beforeCompressFmt;
              break;
            case 'PNG':
              this.afterCompressFmt = 'png';
              break;
            case 'JPG':
              this.afterCompressFmt = 'jpeg';
              break;
            case 'WEBP':
              this.afterCompressFmt = 'webp';
              break;
          }
        })
      }, (item: string) => item)
    }
    .borderRadius($r('app.integer.image_compression_ten'))
    .backgroundColor(Color.White)
    .width($r('app.integer.image_compression_hundred'))
    .focusable(false)
  }

  /**
   * 压缩和保存到相册
   */
  @Builder
  compressAndSave() {
    Row({ space: SPACE_THIRTY }) {
      Button($r('app.string.image_compression_compress'), { type: ButtonType.Normal })
        .fontSize($r('app.integer.image_compression_eighteen'))
        .borderRadius($r('app.integer.image_compression_twelve'))
        .height($r('app.integer.image_compression_forty'))
        .onClick(() => {
          if (this.photoCount <= 0) {
            AlertDialog.show({
              message: $r('app.string.image_compression_add_image_compressed_first'),
              alignment: DialogAlignment.Center
            });
            return;
          }
          if (this.isAutoMode) {
            if (this.strMaxCompressedImageSize === '') {
              AlertDialog.show({
                message: $r('app.string.image_compression_input_max_compressed_image_size'),
                alignment: DialogAlignment.Center
              });
              return;
            }
            if (this.maxCompressedImageSize === 0) {
              AlertDialog.show({
                message: $r('app.string.image_compression_prompt_enter_value_greater_than_zero'),
                alignment: DialogAlignment.Center
              });
              return;
            }
            this.afterCompressionSize = '';
            if (this.maxCompressedImageSize * BYTE_CONVERSION > this.beforeCompressByteLength) {
              if (this.beforeCompressByteLength === 0) {
                AlertDialog.show({
                  message: $r('app.string.image_compression_image_get_failed'),
                  alignment: DialogAlignment.Center
                });
              } else {
                AlertDialog.show({
                  message: $r('app.string.image_compression_prompt_not_require_compression'),
                  alignment: DialogAlignment.Center
                });
              }
              return;
            }
            // 自动压缩图片（需要指定图片压缩目标大小）
            this.autoCompression();
          } else {
            // 手动压缩图片
            this.manualCompression();
          }
          // 点击收起键盘
          inputMethod.getController().stopInputSession();
        })

      SaveButton({ text: SaveDescription.SAVE_TO_GALLERY, buttonType: ButtonType.Normal })
        .height($r('app.integer.image_compression_forty'))
        .fontSize($r('app.integer.image_compression_eighteen'))
        .borderRadius($r('app.integer.image_compression_twelve'))
        .onClick(async () => {
          if (this.afterCompressionSize === '') {
            AlertDialog.show({
              message: $r('app.string.image_compression_please_compress_first'),
              alignment: DialogAlignment.Center
            });
            return;
          }
          if (this.showCompressFormat !== this.getSelectFormat()) {
            AlertDialog.show({
              message: $r('app.string.image_compression_compress_output_format_first_try_again'),
              alignment: DialogAlignment.Center
            });
            return;
          }
          await this.saveImageToAlbum();
        })
    }
  }

  build() {
    Column({ space: SPACE_SIX }) {
      Scroll(this.scrollerForLiftUp) {
        Column() {
          // 使用测试图片
          this.useTestImage()
          // 显示压缩前和压缩后图片
          this.displayImage()
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(LAYOUT_WEIGHT)

      // 压缩模式
      this.compressMode()
      // 压缩相关设置
      this.compressSettingItems()
      // 输出格式
      this.outputFormatSet()
      // 压缩和保存到相册
      this.compressAndSave()
    }
    .onClick(() => {
      // 点击收起键盘
      inputMethod.getController().stopInputSession();
    })
    .width($r('app.string.image_compression_full_size'))
    .height($r('app.string.image_compression_full_size'))
    .padding({
      left: $r('app.integer.image_compression_padding_twenty'),
      right: $r('app.integer.image_compression_padding_twenty'),
      bottom: $r('app.integer.image_compression_ten')
    })
    .backgroundColor($r('app.color.image_compression_bg_color'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}




