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
import {
  ImageKnife,
  ImageKnifeComponent,
  ImageKnifeData,
  ImageKnifeGlobal,
  ImageKnifeOption,
  NONE,
  RequestOption
} from '@ohos/imageknife';
import { BusinessError } from '@kit.BasicServicesKit';
import { Size } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import {
  DEFAULT_IMG_URL,
  DEFAULT_REFER,
  IMAGE_THEFT_BUTTON_CLICK_SCALE,
  IMAGE_THEFT_COLUMN_SPACE,
  IMAGE_THEFT_IMAGEKNIFE_COMPONENT_HEIGHT,
  IMAGE_THEFT_IMAGEKNIFE_COMPONENT_WIDTH
} from '../constants/Constants';

/**
 * 功能描述: 使用第三方库imageknife，通过在请求头中添加Referer来实现防盗链图片的功能。
 *
 * 推荐场景: 网络图片资源需要防盗链的场景
 *
 * 核心组件:
 * 1. imageknife
 *
 * 实现步骤：
 * 1. 新建imageKnifeOption变量，作为ImageKnifeComponent的入参配置。
 * 2. 新建RequestOption对象实例，并在里面配置请求头，缓存规则，以及请求成功和回调等配置。
 * 3. 在imageknife实例调用call函数，传入步骤2里面的实例。
 */
@Component
export struct ImageTheftComponent {
  @State imgUrl: string = DEFAULT_IMG_URL; // 图片image的url
  @State refer: string = DEFAULT_REFER; // 图片image的refer
  @State imageKnifeOption: ImageKnifeOption = {
    // 图片组件ImageKnifeComponent的配置项
    loadSrc: '',
    isCacheable: false,
  };
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  emptyPixel: image.PixelMap | null = null; // 存储重置用的空白图片
  focusController = this.getUIContext().getFocusController(); // 组件焦点控制器

  build() {
    Column() {
      // 场景描述组件
      FunctionDescription({
        content: $r("app.string.image_theft_content")
      })
      // 输入框和按钮
      Column({ space: IMAGE_THEFT_COLUMN_SPACE }) {
        Row() {
          Text($r("app.string.image_theft_image_url"))
            .width($r("app.integer.image_theft_text_width"))
            .height($r("app.integer.image_theft_text_height"))
          TextArea({ text: $$this.imgUrl })
            .width($r("app.string.image_theft_textarea_width"))
            .enableKeyboardOnFocus(false)
            .enterKeyType(EnterKeyType.Done)
        }
        .alignItems(VerticalAlign.Top)

        Row() {
          Text($r("app.string.image_theft_image_refer"))
            .width($r("app.integer.image_theft_text_width"))
            .height($r("app.integer.image_theft_text_height"))
          TextArea({ text: $$this.refer })
            .width($r("app.string.image_theft_textarea_width"))
            .enableKeyboardOnFocus(false)
            .enterKeyType(EnterKeyType.Done)
        }
        .alignItems(VerticalAlign.Top)

        Row({ space: IMAGE_THEFT_COLUMN_SPACE }) {
          Button($r("app.string.image_theft_button_request"))
            .width($r("app.integer.image_theft_button_width"))
            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: IMAGE_THEFT_BUTTON_CLICK_SCALE })
            .onClick(() => {
              this.sendRequest(this.imgUrl, this.refer);
              // 清除输入框焦点
              if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                this.focusController.clearFocus();
              }
            })
          Button($r("app.string.image_theft_button_reset"))
            .width($r("app.integer.image_theft_button_width"))
            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: IMAGE_THEFT_BUTTON_CLICK_SCALE })
            .onClick(() => {
              // 清除输入框焦点
              if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                this.focusController.clearFocus();
              }
              this.imgUrl = DEFAULT_IMG_URL;
              this.refer = DEFAULT_REFER;
              if (this.emptyPixel) { // 如果已经有空白Pixel，则将其赋值，否则生成空白Pixel
                this.imageKnifeOption.loadSrc = this.emptyPixel;
              } else {
                const color: ArrayBuffer = new ArrayBuffer(4); // 4为需要创建的像素buffer大小，取值为：height * width * 4
                const opts: image.InitializationOptions = { size: { height: 1, width: 1 } }; // 为了展示空白，需要生成1*1像素的图片
                image.createPixelMap(color, opts).then(result => {
                  this.imageKnifeOption.loadSrc = result;
                });
              }
            })
        }
      }
      .margin({
        top: $r('app.integer.image_theft_column_margin_top'),
        bottom: $r('app.integer.image_theft_column_margin_bottom')
      })
      .width($r('app.string.image_theft_column_margin_width'))

      // 图片展示组件
      ImageKnifeComponent({
        imageKnifeOption: this.imageKnifeOption
      })
        .width(IMAGE_THEFT_IMAGEKNIFE_COMPONENT_HEIGHT)
        .border({ width: $r("app.integer.image_theft_imageknife_component_border_width"), color: Color.Gray })
        .borderRadius($r('app.integer.image_theft_imageknife_component_border_radius'))
        .clip(true)
        .id('myImage')
        .layoutWeight(1)
    }
    .padding({
      top: $r('app.integer.image_theft_outer_column_padding'),
      bottom: px2vp(this.avoidAreaBottomToModule),
      left: $r('app.integer.image_theft_outer_column_padding'),
      right: $r('app.integer.image_theft_outer_column_padding')
    })
  }

  /**
   * 发送请求
   * @param url 图片url
   * @param ref 图片来源
   */
  sendRequest(url: string, ref: string): void {
    const imageKnife: ImageKnife | undefined = ImageKnifeGlobal.getInstance().getImageKnife();
    if (imageKnife !== undefined) {
      imageKnife.removeAllMemoryCache() // 清理全部缓存
      imageKnife.removeAllFileCache() // 清理全部缓存
      // TODO: 知识点：自定义RequestOption来获取image图片。
      const request = new RequestOption();
      // TODO: 知识点：使用addHeader添加请求头。
      request.addHeader('Referer', ref);
      request.skipMemoryCache(true)
        .diskCacheStrategy(new NONE())// 取消磁盘缓存
        .errorholder($r("app.media.image_theft_failed"), {
          asyncSuccess: (data: ImageKnifeData) => {
            if (data.isPixelMap()) {
              this.imageKnifeOption.loadSrc = data.drawPixelMap?.imagePixelMap;
            }
          }
        })
        .load(url)// TODO: 知识点：添加请求url。
        .addListener({
          // TODO: 知识点：添加请求回调监听器。
          callback: (err: BusinessError | string, data: ImageKnifeData) => {
            if (data.isPixelMap()) {
              if (data.drawPixelMap) {
                // TODO: 知识点：在这里获取到请求返回的图片，将图片赋值给imageKnifeOption.loadSrc。
                this.imageKnifeOption.loadSrc = data.drawPixelMap.imagePixelMap;
              } else {
                this.imageKnifeOption.loadSrc = $r("app.media.image_theft_failed");
              }
            }
            return true;
          }
        })
      const compSize: Size = {
        width: IMAGE_THEFT_IMAGEKNIFE_COMPONENT_WIDTH,
        height: IMAGE_THEFT_IMAGEKNIFE_COMPONENT_HEIGHT
      };
      // (必传)这里setImageViewSize函数必传初始组件大小，因为涉及到图片变换效果都需要适配图像源和组件大小。
      // TODO: 知识点：如果是自适应组件等不确定初始图片宽高的情况，可以通过getInspectorByKey获取，参考https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs/faqs-arkui-kit-0000001769732210#section10880155113412。
      request.setImageViewSize(compSize);
      // 磁盘Lru缓存数量设置成0张，0字节
      imageKnife.setLruCacheSize(0, 0);
      // 最后使用ImageKnife的call函数调用request即可
      imageKnife.call(request);
    }
  }
}

/**
 * 模块功能描述组件
 * @param title 标题
 * @param context 内容
 */
@Component
struct FunctionDescription {
  private title: ResourceStr = '';
  private content: ResourceStr = '';

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize($r('app.string.image_theft_text_size_headline'))
          .fontWeight(FontWeight.Medium)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .margin({ bottom: $r('app.string.image_theft_elements_margin_vertical_m') })

      Row() {
        Text(this.content)
          .wordBreak(WordBreak.BREAK_ALL)
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor($r('app.color.image_theft_color_sub_background'))
    .borderRadius($r('app.string.image_theft_corner_radius_default_m'))
    .padding($r('app.string.image_theft_card_padding_start'))
  }
}
