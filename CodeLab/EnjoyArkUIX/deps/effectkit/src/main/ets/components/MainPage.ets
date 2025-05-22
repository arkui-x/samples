/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import image from '@ohos.multimedia.image';
import effectKit from '@ohos.effectKit';
import resourceManager from '@ohos.resourceManager';
import window from '@ohos.window';
import { router } from '@kit.ArkUI';

@Component
export struct MainPageComponent {
  @State imgData: Resource[] = [
    $r('app.media.image4'),
    $r('app.media.image5'),
    $r('app.media.image6'),
    $r('app.media.image7')
  ];
  @State bgColor: string = "#fffffff";
  @State topSafeHeight: number = 0;
  private swiperController: SwiperController = new SwiperController();
  private swiperInterval: number = 3500;
  private swiperDuration: number = 500;
  private swiperItemSpace: number = 10;

  async aboutToAppear() {
    let windowHight: window.Window = await window.getLastWindow(getContext(this));
    await windowHight.setWindowLayoutFullScreen(false);
    this.topSafeHeight = px2vp(windowHight.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
    const context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    const fileData: Uint8Array = await resourceMgr.getMediaContent(this.imgData[0]);
    const buffer = fileData.buffer as ArrayBuffer;
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();
    effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
      let color = colorPicker.getMainColorSync();
      this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16)
    })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back({ url: 'pages/Index' });
          })
        Text('平台视图示例')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 8, right: 8 })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })

      Swiper(this.swiperController) {
        ForEach(this.imgData, (item: Resource) => {
          Image(item).borderRadius($r('app.integer.effectKit_image_borderRadius'))
            .margin({ top: $r('app.integer.effectKit_image_margin_top') })
        })
      }
      .width($r('app.string.effectKit_swiper_width'))
      .padding({
        left: $r('app.integer.effectKit_swiper_padding_left'),
        right: $r('app.integer.effectKit_swiper_padding_right')
      })
      .autoPlay(true)
      .interval(this.swiperInterval)
      .duration(this.swiperDuration)
      .loop(true)
      .itemSpace(this.swiperItemSpace)
      .indicator(false)
      .onAnimationStart(async (index, targetIndex) => {
        try {
          const context = getContext(this);
          const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
          const fileData: Uint8Array = await resourceMgr.getMediaContent(this.imgData[targetIndex]);
          const buffer = fileData.buffer as ArrayBuffer;
          const imageSource: image.ImageSource = image.createImageSource(buffer);
          const pixelMap: image.PixelMap = await imageSource.createPixelMap();
          effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
            let color = colorPicker.getMainColorSync();
            animateTo({ duration: 500, curve: Curve.Linear, iterations: 1 }, () => {
              this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) +
              color.blue.toString(16);
            })
          })
        } catch (e) {
        }
      })
    }
    .width($r('app.string.effectKit_column_width'))
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[this.bgColor, 0.0], [Color.White, 0.5]]
    })
    .padding({
      bottom: this.topSafeHeight,
      top: this.topSafeHeight
    })
  }
}