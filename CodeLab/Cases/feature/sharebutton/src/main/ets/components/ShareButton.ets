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
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
// 导入码图生成需要的图片模块、错误码模块
import { generateBarcode, scanCore } from '@kit.ScanKit';
import { image } from '@kit.ImageKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { fileIo, fileUri } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 功能说明: 本示例介绍如何在应用中，通过url自动生成二维码，并通过Share Kit的接口拉起系统分享。
 *
 * 推荐场景: 需要通过url生成二维码分享的场景
 *
 * 核心组件:
 * 1. ShareButton: 分享按钮
 *
 * 实现步骤:
 * 1. 数据准备: 传入需要分享的url，按钮会自动生成图片
 * @example
 * ShareButton({
 url: this.helperUrl,
 })
 *
 */

/**
 * 功能描述：
 * 1.通过url自动生成二维码
 *
 * 实现原理：
 * 1.通过createBarcode生成二维码。
 * 2.将生成的二维码与当前图片合并。
 * 3.调用系统的Share Kit，构建出分享对象，拉起系统分享框。
 * @param {string} url - 需要分享的二维码
 * @param {slot} [slot] - 自定义分享按钮样式
 */
@Component
export struct ShareButton {
  @BuilderParam slot: () => void; // slot 供自定义UI使用
  @Prop @Watch("refreshUrl") url: string = ''; // 刷新的url
  @Prop linkTitle: string = ''; // 刷新的url
  @Prop linkDesc: string = ''; // 刷新的url
  private ctx: Context = getContext(this);
  private imageBarCode: image.PixelMap | null = null; // 前景二维码图
  private imageBackground: image.PixelMap | null = null; // 背景图
  private generatedImage: image.PixelMap | null = null; // 合成的最终图片
  private readonly shareTempDirPath: string = this.ctx.tempDir + "/shareTempImg"; // 图片落盘存放的临时路径文件夹
  private imagePath: string = ""; // 生成分享图片的路径
  private shareData: systemShare.SharedData | null = null; // 构建的分享数据
  private sharedController: systemShare.ShareController | null = null; // 分型控制器

  aboutToAppear(): void {
    if (!fileIo.accessSync(this.shareTempDirPath)) {
      // 不存在则创建
      fileIo.mkdirSync(this.shareTempDirPath);
    }

    Promise.all([getPixelFromResource(this.ctx, $r('app.media.lighthouse')), createBarcode(this.url, 400)])
      .then(async (result) => {
        this.imagePath = this.shareTempDirPath + `/${(new Date()).getTime()}.jpg`;
        this.imageBackground = result[0];
        this.imageBarCode = result[1];
        if (this.imageBackground && this.imageBarCode) {
          this.generatedImage = mixPixels(this.imageBackground, this.imageBarCode);
          await saveImgToFile(this.generatedImage, this.imagePath)
          await this.createShareData()
        }
      })
  }

  aboutToDisappear(): void {
    try {
      //删除落盘图片
      fileIo.unlinkSync(this.imagePath);
    } catch (error) {
      console.error(`ShareController show error. code: ${error.code}, message: ${error.message}`);
    }
  }

  /**
   * 构建分享数据并创建分享controller
   */
  async createShareData() {
    if (!this.generatedImage) {
      return
    }
    // 构造ShareData，需配置一条有效数据信息
    // 图片对象
    this.shareData = new systemShare.SharedData({
      utd: utd.UniformDataType.JPEG,
      uri: fileUri.getUriFromPath(this.imagePath),
    });

    // 创建ImagePacker实例，生成低质量缩略图
    const imagePackerApi = image.createImagePacker();

    let thumbnailBuffer: ArrayBuffer = await imagePackerApi.packing(this.generatedImage, {
      format: 'image/jpeg',
      quality: 10
    });

    //链接对象，需要生成缩略图
    this.shareData.addRecord({
      utd: utd.UniformDataType.HYPERLINK,
      content: this.url, // 仅为示例 使用时请替换为自己的链接
      thumbnail: new Uint8Array(thumbnailBuffer),
      description: this.linkDesc ?? this.url,
      title: this.linkTitle
    });

    // 构建ShareController
    this.sharedController = new systemShare.ShareController(this.shareData);
    console.debug("create sharecontroller successfully")
  }

  /**
   * 如果url发生了变化，需要重新生成
   */
  async refreshUrl() {
    console.debug("share url changed")
    // 二维码建议最小大小为400，不然可能会扫描不出。
    this.imageBarCode = await createBarcode(this.url, 400);
    if (this.imageBackground && this.imageBarCode) {
      this.generatedImage = mixPixels(this.imageBackground, this.imageBarCode);
      await saveImgToFile(this.generatedImage, this.imagePath)
      await this.createShareData()
    }
  }

  build() {
    Stack() {
      if (this.slot == undefined) {
        Column() {
        }
        .width($r('app.string.bg_width'))
        .height($r('app.string.bg_height'))
        .borderRadius($r('app.string.bg_border_radius'))
        .backgroundColor(Color.White)
        .opacity($r('app.float.background_opacity'))

        Button() {
          Image($r("sys.media.ohos_ic_public_share"))
            .fillColor(Color.White)
            .width($r('app.string.icon_width'))
            .height($r('app.string.icon_height'))
            .draggable(false)
        }
        .id("ShareButton")
        .backgroundColor(Color.Transparent)
      } else {
        this.slot()
      }
    }
    .id('ShareButton')
    .onClick(async () => {
      // 进行分享面板显示
      this.sharedController?.show(this.ctx as common.UIAbilityContext, {
        anchor: "ShareButton",
        selectionMode: systemShare.SelectionMode.SINGLE,
        previewMode: systemShare.SharePreviewMode.DETAIL
      }).then(() => {
        console.info('ShareController show success.');
      }).catch((error: BusinessError) => {
        console.error(`ShareController show error. code: ${error.code}, message: ${error.message}`);
      });
    })
  }
}

/**
 * 生成QR方形码
 * @param content 内容
 * @param size 大小
 * @returns PixelMap
 */
async function createBarcode(content: string, size: number): Promise<image.PixelMap | null> {
  if (canIUse("SystemCapability.Multimedia.Scan.Core") && canIUse("SystemCapability.Multimedia.Scan.GenerateBarcode")) {
    try {
      // 以QR码为例，码图生成参数
      let options: generateBarcode.CreateOptions = {
        scanType: scanCore.ScanType.QR_CODE,
        height: size,
        width: size
      };
      let pixelMap: image.PixelMap = await generateBarcode.createBarcode(content, options);
      console.debug("生成码图成功");
      return pixelMap;
    } catch (error) {
      hilog.error(0x0001, '[generateBarcode]',
        `Failed to createBarcode by promise with options. Code: ${error.code}, message: ${error.message}`);
      return null;
    }
  } else {
    console.error("该设备暂不支持生成二维码");
    return null;
  }
}

/**
 * 从Resource获取pixelMap·
 * @param context 上下文
 * @param res 资源
 * @returns PixelMap
 */
async function getPixelFromResource(context: Context, res: Resource): Promise<image.PixelMap | null> {
  try {
    let tempArray: Uint8Array = context.resourceManager.getMediaContentSync(res.id);
    let imageSource: image.ImageSource = image.createImageSource(tempArray.buffer);
    console.debug("从Resource获取pixelMap成功");
    return imageSource.createPixelMapSync({
      editable: true,
    });
  } catch (error) {
    hilog.error(0x0001, '[generateBarcode]',
      `Failed to getPixelFromResource. Code: ${error.code}, message: ${error.message}`);
    return null;
  }
}

/**
 * 合成图片，此操作会修改src图片
 * @param src 源文件
 * @param dst 二维码
 * @returns PixelMap
 */
function mixPixels(src: image.PixelMap, dst: image.PixelMap): image.PixelMap {
  try {
    let srcSize = src.getImageInfoSync().size;
    let dstSize = dst.getImageInfoSync().size;
    let dstBuffer = new ArrayBuffer(dstSize.height * dstSize.width * 4);
    dst.readPixelsToBufferSync(dstBuffer);
    src.writePixelsSync({
      pixels: dstBuffer,
      offset: 0,
      stride: dstSize.width * 4,
      region: {
        size: dstSize,
        x: (srcSize.width - dstSize.width) / 2,
        y: (srcSize.height - dstSize.height) / 2
      }
    });
    hilog.debug(0x0001, '[generateBarcode]',
      `Succeeded to mixPixels`);
    return src
  } catch (error) {
    hilog.error(0x0001, '[generateBarcode]',
      `Failed to mixPixels. Code: ${error.code}, message: ${error.message}`);
    return src;
  }
}

/**
 * 图片落盘
 * @param img 源文件
 * @param path 路径
 * @returns PixelMap
 */
async function saveImgToFile(img: image.PixelMap, path: string): Promise<string> {
  const file = fileIo.openSync(path,
    fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  // 创建ImagePacker实例
  const imagePackerApi = image.createImagePacker();
  /**
   * 设置打包参数
   * format：图片打包格式，只支持 jpg 和 webp
   * quality：JPEG 编码输出图片质量
   * bufferSize：图片大小，默认 10M
   */
  let fullBuffer: ArrayBuffer = await imagePackerApi.packing(img, {
    format: 'image/jpeg',
    quality: 98
  });

  fileIo.writeSync(file.fd, fullBuffer);
  fileIo.close(file.fd);
  return path;
}

/**
 *
 */
export function openShare(ctx: Context, url: string, callback: Function) {
  const shareTempDirPath: string = ctx.tempDir + "/shareTempImg";
  let imagePath: string = '';
  let imageBackground: image.PixelMap | null = null;
  let imageBarCode: image.PixelMap | null = null;
  let generatedImage: image.PixelMap | null = null;
  if (!fileIo.accessSync(shareTempDirPath)) {
    // 不存在则创建
    fileIo.mkdirSync(shareTempDirPath);
  }

  Promise.all([getPixelFromResource(ctx, $r('app.media.lighthouse')), createBarcode(url, 400)])
    .then(async (result) => {
      imagePath = shareTempDirPath + `/${(new Date()).getTime()}.jpg`;
      imageBackground = result[0];
      imageBarCode = result[1];
      if (imageBackground && imageBarCode) {
        console.debug("get img successfully")
        generatedImage = mixPixels(imageBackground, imageBarCode);
        await saveImgToFile(generatedImage, imagePath)
        if (generatedImage) {
          // 构造ShareData，需配置一条有效数据信息
          // 图片对象
          let shareData = new systemShare.SharedData({
            utd: utd.UniformDataType.JPEG,
            uri: fileUri.getUriFromPath(imagePath),
          });

          // 创建ImagePacker实例，生成低质量缩略图
          const imagePackerApi = image.createImagePacker();

          let thumbnailBuffer: ArrayBuffer = await imagePackerApi.packing(generatedImage, {
            format: 'image/jpeg',
            quality: 10
          });

          //链接对象，需要生成缩略图
          shareData.addRecord({
            utd: utd.UniformDataType.HYPERLINK,
            content: url,
            thumbnail: new Uint8Array(thumbnailBuffer),
          });

          // 构建ShareController
          let sharedController = new systemShare.ShareController(shareData);
          console.debug("create sharecontroller successfully")

          // 监听关闭回掉
          sharedController.on("dismiss", () => {
            callback && callback()
          })

          // 进行分享面板显示
          sharedController?.show(ctx as common.UIAbilityContext, {
            selectionMode: systemShare.SelectionMode.SINGLE,
            previewMode: systemShare.SharePreviewMode.DETAIL
          }).then(() => {
            console.info('ShareController show success.');
          }).catch((error: BusinessError) => {
            console.error(`ShareController show error. code: ${error.code}, message: ${error.message}`);
          });
        }
      }
    })
}
