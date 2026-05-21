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
import { DrawableDescriptor, LayeredDrawableDescriptor, PixelMapDrawableDescriptor } from '@ohos.arkui.drawableDescriptor'
import { image } from '@kit.ImageKit';

interface ImageResources  {
  foreground: Resource;
  background: Resource;
  mask: Resource;
}


@Entry
@Component
struct LayeredDrawableDescriptor_2 {

  private resManager = this.getUIContext().getHostContext()?.resourceManager;
  @State drawable_as: DrawableDescriptor | undefined = this.resManager?.getDrawableDescriptor($r('app.media.drawable_png').id);

  @State layeredDrawableDescriptor_as : LayeredDrawableDescriptor = (this.drawable_as as LayeredDrawableDescriptor);

  // 测试格式选项
  @State formatOptions: string[] = ['PNG', 'JPG', 'JPEG', 'BMP', 'SVG', 'WEBP', 'GIF'];
  @State selectedFormat: string = 'PNG';
  @State isSelectorVisible: boolean = false;

  // 使用PixelMapDrawableDescriptor创建的LayeredDrawableDescriptor
  @State LayeredDrawable: LayeredDrawableDescriptor | undefined = undefined;


  // 使用JSON文件创建的LayeredDrawableDescriptor
  @State jsonLayeredDrawable: LayeredDrawableDescriptor | undefined = undefined;

  // 各个组件的DrawableDescriptor（用于get方法测试）
  @State foregroundDrawable: DrawableDescriptor | undefined = undefined;
  @State backgroundDrawable: DrawableDescriptor | undefined = undefined;
  @State maskDrawable: DrawableDescriptor | undefined = undefined;

  // 不同格式的图片资源映射
  private formatResourceMap: Map<string, ImageResources > = new Map();
  private jsonResourceMap: Map<string, Resource> = new Map();

  // Scroller实例 - 修复滑动问题
  scroller: Scroller = new Scroller();

  // 初始化资源映射
  aboutToAppear() {
    // 初始化各种格式的资源路径
    this.formatResourceMap.set('PNG', {
      foreground: $r('app.media.1cut_png'),
      background: $r('app.media.background_png'),
      mask: $r('app.media.mask_png')
    });
    this.formatResourceMap.set('JPG', {
      foreground: $r('app.media.1cut_jpg'),
      background: $r('app.media.background_jpg'),
      mask: $r('app.media.mask_jpg')
    });
    this.formatResourceMap.set('JPEG', {
      foreground: $r('app.media.1cut_jpeg'),
      background: $r('app.media.background_jpeg'),
      mask: $r('app.media.mask_jpeg')
    });
    this.formatResourceMap.set('BMP', {
      foreground: $r('app.media.1cut_bmp'),
      background: $r('app.media.background_bmp'),
      mask: $r('app.media.mask_bmp')
    });
    this.formatResourceMap.set('SVG', {
      foreground: $r('app.media.1_svg'),
      background: $r('app.media.2_svg'),
      mask: $r('app.media.3_svg')
    });
    this.formatResourceMap.set('WEBP', {
      foreground: $r('app.media.1cut_webp'),
      background: $r('app.media.background_webp'),
      mask: $r('app.media.mask_webp')
    });
    this.formatResourceMap.set('GIF', {
      foreground: $r('app.media.gif'),
      background: $r('app.media.background_gif'),
      mask: $r('app.media.mask_gif')
    });
    this.jsonResourceMap.set('PNG', $r('app.media.drawable_png'));
    this.jsonResourceMap.set('JPG', $r('app.media.drawable_jpg'));
    this.jsonResourceMap.set('JPEG', $r('app.media.drawable_jpeg'));
    this.jsonResourceMap.set('BMP', $r('app.media.drawable_bmp'));
    this.jsonResourceMap.set('SVG', $r('app.media.drawable_svg'));
    this.jsonResourceMap.set('WEBP', $r('app.media.drawable_webp'));
    this.jsonResourceMap.set('GIF', $r('app.media.drawable_gif'));

    // 加载默认格式的图片
    this.loadFormatImages(this.selectedFormat);
  }

  // 根据资源获取PixelMap
  private async getPixelMapFromResource(resource: Resource): Promise<image.PixelMap | undefined> {
    try {
      let unit8Array = await this.getUIContext().getHostContext()?.resourceManager?.getMediaContent(resource.id);
      let imageSource = image.createImageSource(unit8Array?.buffer.slice(0, unit8Array.buffer.byteLength));
      let createdPixelMap: image.PixelMap = await imageSource.createPixelMap({
        desiredPixelFormat: image.PixelMapFormat.BGRA_8888
      });
      await imageSource.release();
      return createdPixelMap;
    } catch (error) {
      console.error(`Failed to create PixelMap for resource: ${resource.id}`, error);
      return undefined;
    }
  }

  // 加载指定格式的图片
  async loadFormatImages(format: string) {
    this.LayeredDrawable = undefined
    this.selectedFormat = format;
    this.isSelectorVisible = false;

    const resources = this.formatResourceMap.get(format);
    const jsonResource = this.jsonResourceMap.get(format);
    if (!resources || !jsonResource) return;

    try {
      // 创建各个组件的PixelMapDrawableDescriptor
      const foregroundPixelMap = await this.getPixelMapFromResource(resources.foreground);
      const backgroundPixelMap = await this.getPixelMapFromResource(resources.background);
      const maskPixelMap = await this.getPixelMapFromResource(resources.mask);

      if (foregroundPixelMap && backgroundPixelMap && maskPixelMap) {
        this.foregroundDrawable = new PixelMapDrawableDescriptor(foregroundPixelMap);
        this.backgroundDrawable = new PixelMapDrawableDescriptor(backgroundPixelMap);
        this.maskDrawable = new PixelMapDrawableDescriptor(maskPixelMap);

        // 创建LayeredDrawableDescriptor
        this.LayeredDrawable = new LayeredDrawableDescriptor(
          this.foregroundDrawable,
          this.backgroundDrawable,
          this.maskDrawable
        );
      }
      const jsonDrawable = this.resManager?.getDrawableDescriptor(jsonResource.id);
      if (jsonDrawable instanceof LayeredDrawableDescriptor) {
        this.jsonLayeredDrawable = jsonDrawable;
      } else {
        console.warn(`JSON资源 ${format} 不是LayeredDrawableDescriptor类型`);
      }

    } catch (error) {
      console.error(`Failed to load images for format: ${format}`, error);
    }

  }


  build() {
    // 使用Row包裹Scroll，确保正确的布局
    Row() {
      Scroll(this.scroller) {
        Column({ space: 15 }) {
          Button('back')
            .onClick(() => {
              this.getUIContext().getRouter().back();
            })
          // 标题
          Text('LayeredDrawableDescriptor 测试页面')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10 })

          // 格式选择器
          Column() {
            Text('选择图片格式:')
              .fontSize(16)
              .margin({ bottom: 8 })

            // 选择框
            Row() {
              Text(this.selectedFormat)
                .fontSize(18)
                .layoutWeight(1)
            }
            .width('80%')
            .height(45)
            .padding(10)
            .backgroundColor(Color.White)
            .border({ color: Color.Gray, width: 1 })
            .borderRadius(8)
            .onClick(() => {
              this.isSelectorVisible = !this.isSelectorVisible;
            })

            // 下拉选项
            if (this.isSelectorVisible) {
              Column() {
                ForEach(this.formatOptions, (format: string) => {
                  Text(format)
                    .fontSize(16)
                    .width('100%')
                    .height(40)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(format === this.selectedFormat ? Color.Blue : Color.White)
                    .fontColor(format === this.selectedFormat ? Color.White : Color.Black)
                    .onClick(() => {
                      this.loadFormatImages(format);
                    })
                })
              }
              .width('80%')
              .margin({ top: 5 })
              .border({ color: Color.Gray, width: 1 })
              .borderRadius(8)
            }
          }
          .alignItems(HorizontalAlign.Center)
          .width('100%')

          Divider()
            .margin({ top: 10, bottom: 10 })

          // 测试结果展示
          // Column({ space: 20 }) {
            // 方法1: 使用PixelMapDrawableDescriptor创建
            Text('方法1: 构造函数创建LayeredDrawableDescriptor')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Blue)
              .width('100%')
              .textAlign(TextAlign.Center)

            Column({ space: 10 }) {
              Text('DrawableDescriptor as LayeredDrawableDescriptor调用显示')
                .fontSize(14)
              Image(this.layeredDrawableDescriptor_as)
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })
                Text('LayeredDrawableDescriptor显示:')
                  .fontSize(14)
              Image(this.LayeredDrawable)
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })

                Text('getForeground():')
                  .fontSize(14)
              Image(this.LayeredDrawable?.getForeground())
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })

                Text('getBackground():')
                  .fontSize(14)
              Image(this.LayeredDrawable?.getBackground())
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })


                Text('getMask():')
                  .fontSize(14)
              Image(this.LayeredDrawable?.getMask())
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })
            // }
            // .width('90%')
            // .padding(10)
            // .borderRadius(8)

            // 方法2: 使用JSON文件创建
            Text('方法2: 使用json文件创建LayeredDrawableDescriptor')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.Blue)
              .width('100%')
              .textAlign(TextAlign.Start)
              .margin({ top: 10 })

            // Column({ space: 10 }) {
                Text('LayeredDrawableDescriptor显示:')
                  .fontSize(14)
                Image(this.jsonLayeredDrawable)
                  .width(200)
                  .height(200)
                  .objectFit(ImageFit.Contain)
                  .border({ color: Color.Black, width: 1 })

                  Text('getForeground():')
                    .fontSize(14)
              Image(this.jsonLayeredDrawable?.getForeground())
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })


                  Text('getBackground():')
                    .fontSize(14)
              Image(this.jsonLayeredDrawable?.getBackground())
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })

                  Text('getMask():')
                    .fontSize(14)
              Image(this.jsonLayeredDrawable?.getMask())
                .width(200)
                .height(200)
                .objectFit(ImageFit.Contain)
                .border({ color: Color.Black, width: 1 })

            }
            .width('90%')
            .padding(10)
            .borderRadius(8)
          }
          .width('100%')
          .padding(10)


      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray)
      .scrollBarWidth(10)
      .width('100%')
      .height('100%') // Scroll必须设置明确的高度
    }
    .width('100%')
    .height('100%')
  }
}