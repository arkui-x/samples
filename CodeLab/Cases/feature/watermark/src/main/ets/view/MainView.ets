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

import { fileIo as fs } from '@kit.CoreFileKit';
import { promptAction } from '@kit.ArkUI';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { ICallBack, MP4Parser } from '@ohos/mp4parser';
import { createWaterMarkView } from '../utils/WaterMarkView';
import { FeatureData, ImageData } from '../model/MockData';
import { DataType, FeatureDataType, TextModify } from '../model/DataType';
import { logger } from '../utils/Logger';
import { CommonConstants } from '../common/CommonConstants';
import { WaterMarkModel } from '../utils/WaterMarkModel';

const CONTEXT: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
const DURATION: number = 300;

/**
 * 功能说明：本案例通过Canvas组件以及OffscreenCanvas实现了页面添加水印以及保存图片时添加水印的功能。
 *
 * 推荐场景：图片以及视图页面添加水印
 *
 * 核心组件：
 * 1. WaterMarkView：水印视图组件
 * 2. WaterMarkModel：水印方法类
 *
 * 实现步骤：
 *
 * 本章节主要通过两种方法来实现水印的添加。
 *
 * 方法一
 * 1. 组件添加水印。构建水印视图（WaterMarkView），使用overlay把水印视图作为组件的浮层形成水印的效果。
 * @example
 * @Builder
   contentView() {
     Stack() {
       Column() {
          ···
       }
    .height(CommonConstants.COMPONENT_VIEW_FULL)
    .overlay(createWaterMarkView(this.textModify))
    }

 * 方法二
 * 2. 图片添加水印。引入WaterMarkModel类，调用addImageWaterMark函数，传递文本属性参数。
 * @example
 * const IMAGE_TEXT_PARAM: TextModify = new TextModify(CommonConstants.TEXT_CONTENT2, CommonConstants.FONT_SIZE1,
   CommonConstants.FONT_COLOR2, CommonConstants.TEXT_ALIGN,CommonConstants.TEXT_BASE_LINE, data.size.width - 20, data.size.height - 20);
   this.pixelMap = await waterMarkModel.addImageWaterMark(pixelMap, data.size, IMAGE_TEXT_PARAM);
 *
 *
 *
 * 本示例主要从两个方面添加水印，一方面Canvas组件绘制水印，然后将水印组件通过overlay属性将水印作为浮层放置在页面中，另一方面获取初始图片的pixelMap对象，
 * 通过OffscreenCanvas绘制水印，并生成一个新的pixelMap对象进行保存。
 */
@Component
export struct MainViewComponent {
  @State imageDataSource: DataType[] = ImageData;
  @State imageScale: number = 1; // 初始化放大比例
  @State pixelMap: image.PixelMap | undefined = undefined; // pixelMap对象
  @State source: Resource = $r('app.media.water_mark_image_1');
  @State currentIndex: number = 0;
  @State isShow: boolean = false; // 控制班模态页面的显示
  @State translateY: number = 0;
  textModify: TextModify =
    new TextModify(CommonConstants.TEXT_CONTENT1, CommonConstants.FONT_SIZE1, CommonConstants.FONT_COLOR1);

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.water_mark_toast_message')
    })
  }

  /**
   * 隐藏半模态页面
   */
  hideHalfModule() {
    this.isShow = false;
    animateTo({ curve: Curve.Friction, duration: DURATION }, () => {
      this.translateY = 0;
    })
  }

  /**
   * 添加水印
   */
  addWaterMark() {
    CONTEXT.resourceManager.getMediaContent(this.source.id, (error, value) => {
      if (error) {
        return;
      }
      const imageSource: image.ImageSource = image.createImageSource(value.buffer);
      imageSource.getImageInfo((err, data) => {
        if (err) {
          return;
        }
        let opts: image.DecodingOptions = {
          editable: true,
          desiredSize: {
            height: data.size.height,
            width: data.size.width
          }
        }
        imageSource.createPixelMap(opts, async (err, pixelMap) => {
          if (err) {
            return;
          }
          let waterMarkModel = new WaterMarkModel();
          const IMAGE_TEXT_PARAM: TextModify =
            new TextModify(CommonConstants.TEXT_CONTENT2, CommonConstants.FONT_SIZE2, CommonConstants.FONT_COLOR2,
              CommonConstants.TEXT_ALIGN, CommonConstants.TEXT_BASE_LINE, data.size.width - 130,
              data.size.height - 30);
          this.pixelMap = await waterMarkModel.addImageWaterMark(pixelMap, data.size, IMAGE_TEXT_PARAM);
          const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(CONTEXT);
          const uri = await phAccessHelper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'png');
          if (this.pixelMap !== undefined) {
            // 保存图片到本地
            const imagePacker = image.createImagePacker();
            // TODO:知识点:最终生成图片的占用空间大小会受到图片数据设置的宽高大小和质量影响，取值根据开发者实际需求决定
            const imageBuffer = await imagePacker.packing(this.pixelMap, { format: 'image/png', quality: 80 });
            try {
              // 通过uri打开媒体库文件
              let file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              logger.info(`openFile success, fd: ${file.fd}`);
              // 写到媒体库文件中
              fs.writeSync(file.fd, imageBuffer);
              fs.closeSync(file.fd);
            } catch (err) {
              logger.error(`fs failed ${err.code},errMessage:message`);
            }
          }
        })
      })
    })
  }

  writeFile(filePath: string, buffer: ArrayBuffer | string) {
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.truncateSync(file.fd);
    fs.writeSync(file.fd, buffer);
    fs.closeSync(file.fd);
  }

  async addVideoWaterMark() {
    let getLocalDirPath = getContext(this).cacheDir + '/';

    let videoBuffer: ArrayBuffer =
      this.uint8ArrayToBuffer(getContext(this).resourceManager.getMediaContentSync($r('app.media.water_mark_video_1')));
    let cacheVideoPath = getLocalDirPath + 'testVideo.mp4';

    let waterMarkBuffer: ArrayBuffer =
      this.uint8ArrayToBuffer(getContext(this).resourceManager.getMediaContentSync($r('app.media.water_mark')));
    let cacheWaterMarkPath = getLocalDirPath + 'testWaterMark.png';
    let outVideoPath: string = getLocalDirPath + 'outVideo.mp4';

    this.writeFile(cacheVideoPath, videoBuffer);

    this.writeFile(cacheWaterMarkPath, waterMarkBuffer);

    this.writeFile(outVideoPath, '');

    let ffmpegCmd =
      `ffmpeg -y -i ${cacheVideoPath} -loop 1 -i ${cacheWaterMarkPath} -filter_complex [1:v]rotate=a='t*PI*0.5':ow='rotw(PI/4)':oh='roth(PI/4)':fillcolor='none'[out],[0:v][out]overlay=x=50:y=50:shortest=1 ${outVideoPath}`;
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(CONTEXT);
    let photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.VIDEO;
    let uri = '';
    uri = await phAccessHelper.createAsset(photoType, 'mp4');

    let callBack: ICallBack = {
      callBackResult: async (code: number) => {
        let filet = fs.openSync(outVideoPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        let stat = fs.statSync(outVideoPath);
        let buf = new ArrayBuffer(stat.size);
        fs.readSync(filet.fd, buf);
        fs.close(filet.fd);
        try {
          this.writeFile(uri, buf);
        } catch (err) {
          console.error(`createAsset failed, error: ${err.code}, ${err.message}`);
        }
      }
    }

    try {
      MP4Parser.ffmpegCmd(ffmpegCmd, callBack);
    } catch (e) {
      console.log(JSON.stringify(e));
    }
  }

  uint8ArrayToBuffer(array: Uint8Array): ArrayBuffer {
    return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset);
  }

  build() {
    Stack() {
      Column() {
        // 标题
        this.titleBar();
        // 内容
        this.contentView();
      }

      this.maskBuilder();
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  @Builder
  maskBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
      .opacity(0.4)
      .onClick(() => {
        this.hideHalfModule();
      })

      this.halfModuleView();
    }.visibility(this.isShow ? Visibility.Visible : Visibility.None)

  }

  @Builder
  titleBar() {
    Row() {
      Image($r("app.media.water_mark_image_3"))
        .width($r('app.integer.water_mark_avatar_image_size'))
        .height($r('app.integer.water_mark_avatar_image_size'))
        .borderRadius($r('app.integer.water_mark_avatar_image_border_radius'))
      Text($r('app.string.water_mark_user_name'))
        .margin({ left: $r('app.string.ohos_id_elements_margin_vertical_l') })
      Blank()
      Text($r('app.string.water_mark_care_text'))
        .width($r('app.integer.water_mark_care_text_width'))
        .height($r('app.integer.water_mark_care_text_height'))
        .textAlign(TextAlign.Center)
        .fontColor($r('app.color.water_mark_color_4'))
        .border({
          color: $r('app.color.water_mark_color_4'),
          width: 1,
          radius: $r('app.integer.water_mark_care_text_border_radius')
        })
        .onClick(() => {
          this.showToast();
        })
    }.width('100%')
    .padding($r('app.string.ohos_id_card_padding_start'))
  }

  @Builder
  contentView() {
    Stack() {
      Column() {
        Swiper() {
          ForEach(this.imageDataSource, (item: DataType, index: number) => {
            if (item.type === 'image') {
              Image(item.source)
                .width('100%')
                .height($r('app.integer.water_mark_show_image_height'))
                .draggable(false)
                .gesture(
                  LongPressGesture()
                    .onAction(() => {
                      this.isShow = true;
                      animateTo({ curve: Curve.Friction, duration: DURATION }, () => {
                        // 半模态页面向上偏移300
                        this.translateY = -300;
                      })
                    })
                )
            } else {
              Video({
                src: item.source,
              })
                .width('80%')
                .height(200)
                .gesture(
                  LongPressGesture()
                    .onAction(() => {
                      this.isShow = true;
                      animateTo({ curve: Curve.Friction, duration: DURATION }, () => {
                        // 半模态页面向上偏移300
                        this.translateY = -300;
                      })
                    })
                )
            }
          })
        }
        .height($r('app.integer.water_mark_show_image_height'))
        .indicator(false)
        .onChange((index: number) => {
          this.source = this.imageDataSource[index].source;
          this.currentIndex = index;
        })

        // 自定义导航点
        Row() {
          ForEach(this.imageDataSource, (item: DataType, index: number) => {
            Text()
              .width($r('app.integer.water_mark_indicator_size'))
              .height($r('app.integer.water_mark_indicator_size'))
              .borderRadius($r('app.integer.water_mark_indicator_border_radius'))
              .backgroundColor(this.currentIndex === index ? $r('app.color.water_mark_color_2') :
              $r('app.color.water_mark_color_3'))
              .margin($r('app.integer.water_mark_indicator_margin_size'))
          })
        }

        // 内容介绍
        Column() {
          Text($r('app.string.water_mark_content'))
            .width('100%')
            .padding($r('app.string.ohos_id_card_padding_start'))
        }
      }
      .height(CommonConstants.COMPONENT_VIEW_FULL)
      /**
       * 组件浮层
       * @param createWaterMarkView(this.textModify)：水印视图（参数为文本属性）
       */
      .overlay(createWaterMarkView(this.textModify))

    }
  }

  @Builder
  halfModuleView() {
    Column() {
      Row() {
        ForEach(FeatureData, (item: FeatureDataType, index: number) => {
          // 保存按钮的下标为1，除了保存功能，其他功能使用弹窗显示
          if (index !== 1) {
            Column() {
              Image(item.image)
                .width($r('app.integer.water_mark_feature_image_size'))
                .height($r('app.integer.water_mark_feature_image_size'))
              Text(item.text)
                .fontWeight(FontWeight.Medium)
                .fontFamily('HarmonyOS Sans')
                .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_m') })
            }
            .width($r('app.integer.water_mark_feature_area_size'))
            .height($r('app.integer.water_mark_feature_area_size'))
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius($r('app.string.ohos_id_corner_radius_default_l'))
            .onClick(() => {
              this.showToast();
              this.hideHalfModule();
            })
          } else {
            SaveButton({ icon: SaveIconStyle.FULL_FILLED, text: SaveDescription.SAVE, buttonType: ButtonType.Normal })
              .fontColor(Color.Black)
              .width($r('app.integer.water_mark_feature_area_size'))
              .height($r('app.integer.water_mark_feature_area_size'))
              .iconColor(Color.Black)
              .iconSize($r('app.integer.water_mark_save_button_icon_size'))
              .backgroundColor(Color.White)
              .layoutDirection(SecurityComponentLayoutDirection.VERTICAL)
              .borderRadius($r('app.integer.water_mark_save_button_border_radius'))
              .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
                console.info(`mast SaveButtonOnClickResult.${JSON.stringify(result)}`); //符合条件则进入
                this.isShow = false;
                if (result === SaveButtonOnClickResult.SUCCESS) {
                  try {
                    if (this.imageDataSource[this.currentIndex].type === 'image') {
                      this.addWaterMark();
                    } else {
                      this.addVideoWaterMark()
                    }
                    this.hideHalfModule();
                  } catch (err) {
                    logger.error(`the err is ${err.code},errMessage:${err.message}`);
                  }
                }
              })
          }
        })
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Image($r('app.media.water_mark_chat'))
          .width($r('app.integer.water_mark_share_image_size'))
          .height($r('app.integer.water_mark_share_image_size'))
          .borderRadius($r('app.integer.water_mark_share_image_border_radius'))
        Text($r('app.string.water_mark_share_text'))
          .margin({ left: $r('app.string.ohos_id_elements_margin_vertical_m') })
      }
      .width('100%')
      .height($r('app.integer.water_mark_share_area_height'))
      .backgroundColor(Color.White)
      .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_l') })
      .padding($r('app.string.ohos_id_card_padding_start'))
      .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
      .onClick(() => {
        this.showToast();
        this.hideHalfModule();
      })
    }
    .width('100%')
    .height($r('app.integer.water_mark_half_module_height'))
    .backgroundColor($r('app.color.water_mark_color_1'))
    .position({ x: 0, y: '100%' })
    .translate({ x: 0, y: this.translateY })
    .padding($r('app.string.ohos_id_card_padding_start'))
    .border({
      radius: {
        topLeft: $r('app.string.ohos_id_corner_radius_default_l'),
        topRight: $r('app.string.ohos_id_corner_radius_default_l')
      }
    })
  }
}