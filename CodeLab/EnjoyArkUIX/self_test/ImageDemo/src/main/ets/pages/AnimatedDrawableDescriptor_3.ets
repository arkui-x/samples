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
import { DrawableDescriptor, LayeredDrawableDescriptor, PixelMapDrawableDescriptor, AnimationOptions, AnimatedDrawableDescriptor } from '@ohos.arkui.drawableDescriptor'
import { image } from '@kit.ImageKit';

@Entry
@Component
struct AnimatedDrawableDescriptor_3 {

  pixelMaps: Array<image.PixelMap> = [];

  options1: AnimationOptions = {
    duration: 3000,
    iterations: -1,
  };
  @State animated?: DrawableDescriptor = undefined;

  // 添加测试状态
  @State currentDuration: number = 3000;
  @State currentIterations: number = -1;
  @State testInfo: string = 'duration: 3000ms, iterations: -1 (无限播放)';


  // 根据资源，通过图片框架获取pixelMap。
  private async getPixmapFromMedia(resource: Resource) {
    let unit8Array = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(resource.id);
    let imageSource = image.createImageSource(unit8Array?.buffer.slice(0, unit8Array.buffer.byteLength));
    let createPixelMap: image.PixelMap = await imageSource.createPixelMap({
      desiredPixelFormat: image.PixelMapFormat.BGRA_8888
    });
    await imageSource.release();
    return createPixelMap;
  }
  async aboutToAppear() {

    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.1_png')));
    // $r('app.media.png2')需要替换为开发者所需的图像资源文件。
    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.1_jpg')));
    // $r('app.media.png3')需要替换为开发者所需的图像资源文件。
    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.1_jpeg')));
    // $r('app.media.png4')需要替换为开发者所需的图像资源文件。
    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.1_bmp')));
    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.1_svg')));
    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.1_webp')));
    this.pixelMaps.push(await this.getPixmapFromMedia($r('app.media.gif')));
    this.animated = new AnimatedDrawableDescriptor(this.pixelMaps, this.options1);

  }

  // 重新创建动画的方法
  recreateAnimation() {
    this.options1 = {
      duration: this.currentDuration,
      iterations: this.currentIterations
    };
    this.animated = new AnimatedDrawableDescriptor(this.pixelMaps, this.options1);
    this.updateTestInfo();
  }

  // 更新测试信息显示
  updateTestInfo() {
    let durationText = '';
    let iterationText = '';

    // duration解释
    if (this.currentDuration === -1) {
      durationText = 'duration: -1 (默认每帧1秒)';
    } else if (this.currentDuration === 0){
      durationText = 'duration: 0 (默认每帧1秒)';
    } else {
      durationText = `duration: ${this.currentDuration}ms`;
    }

    // iterations解释
    switch (this.currentIterations) {
      case -1:
        iterationText = 'iterations: -1 (无限播放)';
        break;
      case 0:
        iterationText = 'iterations: 0 (不播放)';
        break;
      case 1:
        iterationText = 'iterations: 1 (播放一次)';
        break;
      default:
        iterationText = `iterations: ${this.currentIterations}`;
    }

    this.testInfo = `${durationText}, ${iterationText}`;
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Button('back')
            .onClick(() => {
              this.getUIContext().getRouter().back();
            })
          // 测试信息显示
          Text('当前设置: ' + this.testInfo)
            .fontSize(14)
            .fontColor(Color.Blue)
            .padding(10)
            .width('100%')
            .textAlign(TextAlign.Center)

          // Duration测试按钮
          Text('duration测试:')
            .fontSize(14)
            .padding(5)
            .width('100%')
            .textAlign(TextAlign.Start)

          Row({ space: 10 }) {
            Button('-1')
              .layoutWeight(1)
              .height(50)
              .fontSize(10)
              .onClick(() => {
                this.currentDuration = -1;
                this.recreateAnimation();
              })

            Button('0')
              .layoutWeight(1)
              .height(50)
              .fontSize(10)
              .onClick(() => {
                this.currentDuration = 0;
                this.recreateAnimation();
              })

            Button('1000')
              .layoutWeight(1)
              .height(50)
              .fontSize(10)
              .onClick(() => {
                this.currentDuration = 1000;
                this.recreateAnimation();
              })

            Button('3000')
              .layoutWeight(1)
              .height(50)
              .fontSize(10)
              .onClick(() => {
                this.currentDuration = 3000;
                this.recreateAnimation();
              })

            Button('7000')
              .layoutWeight(1)
              .height(50)
              .fontSize(10)
              .onClick(() => {
                this.currentDuration = 7000;
                this.recreateAnimation();
              })
          }
          .width('100%')
          .padding(10)

          // Iterations测试按钮
          Text('iterations测试:')
            .fontSize(14)
            .padding(5)
            .width('100%')
            .textAlign(TextAlign.Start)

          Row({ space: 10 }) {
            Button('-1')
              .width('23%')
              .height(50)
              .fontSize(10)
              .backgroundColor(Color.Blue)
              .onClick(() => {
                this.currentIterations = -1;
                this.recreateAnimation();
              })

            Button('0')
              .width('23%')
              .height(50)
              .fontSize(10)
              .backgroundColor(Color.Gray)
              .onClick(() => {
                this.currentIterations = 0;
                this.recreateAnimation();
              })

            Button('1')
              .width('23%')
              .height(50)
              .fontSize(10)
              .backgroundColor(Color.Green)
              .onClick(() => {
                this.currentIterations = 1;
                this.recreateAnimation();
              })

            Button('3')
              .width('23%')
              .height(50)
              .fontSize(10)
              .backgroundColor(Color.Orange)
              .onClick(() => {
                this.currentIterations = 3;
                this.recreateAnimation();
              })
          }
          .width('100%')
          .padding(10)

          // 原有的显示内容
          Text('image传入AnimatedDrawableDescriptor类型作为其输入对象')
            .textAlign(TextAlign.Center)
            .fontSize(15)
            .padding(10)
            .width('100%')
          Text('使用PixelMap数组创建AnimatedDrawableDescriptor')
            .textAlign(TextAlign.Center)
            .fontSize(15)
            .padding(10)
            .width('100%')
          Image(this.animated)
            .width('400px').height('400px').margin({ top: 15 }).border({ color: Color.Black, width: 1 })

        }.width('100%')
      }.scrollBar(BarState.Off)
    }.height('100%')
  }
}