import { image } from '@kit.ImageKit';
import { DrawableDescriptor, LayeredDrawableDescriptor, PixelMapDrawableDescriptor, AnimationOptions, AnimatedDrawableDescriptor } from '@ohos.arkui.drawableDescriptor'
@Entry
@Component
struct PixelMapDrawableDescriptor_1 {
  @State message: string = 'Hello World';
  @State imageFormatOptions: string[] = ['PNG', 'JPG', 'JPEG', 'BMP', 'SVG', 'WEBP', 'GIF'];
  @State selectedFormat: string = 'PNG';
  @State isSelectorVisible: boolean = false;
  // 当前显示的图片
  @State currentImageDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  // 不同格式图片的DrawableDescriptor
  @State pngDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State jpgDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State jpegDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State bmpDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State svgDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State webpDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State gifDrawable: PixelMapDrawableDescriptor | undefined = undefined;
  @State heifDrawable: PixelMapDrawableDescriptor | undefined = undefined;

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
    // 这里需要根据实际资源路径修改
    this.pngDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.1_png')));
    this.jpgDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.1_jpg')));
    this.jpegDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.1_jpeg')));
    this.bmpDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.1_bmp')));
    this.webpDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.1_webp')));
    this.gifDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.gif')));
    this.svgDrawable = new PixelMapDrawableDescriptor(await this.getPixmapFromMedia($r('app.media.1_svg')));


    // 默认显示PNG图片
    this.currentImageDrawable = this.pngDrawable;
  }

  updateDisplayedImage(format: string) {
    this.selectedFormat = format;
    this.isSelectorVisible = false;

    switch (format) {
      case 'PNG':
        this.currentImageDrawable = this.pngDrawable;
        break;
      case 'JPG':
        this.currentImageDrawable = this.jpgDrawable;
        break;
      case 'JPEG':
        this.currentImageDrawable = this.jpegDrawable;
        break;
      case 'BMP':
        this.currentImageDrawable = this.bmpDrawable;
        break;
      case 'SVG':
        this.currentImageDrawable = this.svgDrawable;
        break;
      case 'WEBP':
        this.currentImageDrawable = this.webpDrawable;
        break;
      case 'GIF':
        this.currentImageDrawable = this.gifDrawable;
        break;
      case 'HEIF':
        this.currentImageDrawable = this.heifDrawable;
        break;
      default:
        this.currentImageDrawable = this.pngDrawable;
    }
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        Button('back')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        // 标题
        Text('图片格式选择器')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 30 })

        // 下拉选择器
        Column() {
          // 选择框
          Row() {
            Text(this.selectedFormat)
              .fontSize(18)
              .layoutWeight(1)
          }
          .width('80%')
          .height(50)
          .padding(10)
          .backgroundColor(Color.White)
          .border({ color: Color.Gray, width: 1 })
          .borderRadius(8)
          .onClick(() => {
            this.isSelectorVisible = !this.isSelectorVisible;
          })

          // 下拉选项列表
          if (this.isSelectorVisible) {
            Column() {
              ForEach(this.imageFormatOptions, (format: string) => {
                Text(format)
                  .fontSize(16)
                  .width('100%')
                  .height(40)
                  .textAlign(TextAlign.Center)
                  .backgroundColor(format === this.selectedFormat ? Color.Blue : Color.White)
                  .fontColor(format === this.selectedFormat ? Color.White : Color.Black)
                  .onClick(() => {
                    this.updateDisplayedImage(format);
                  })
              })
            }
            .width('80%')
            .margin({ top: 5 })
            .backgroundColor(Color.White)
            .border({ color: Color.Gray, width: 1 })
            .borderRadius(8)
          }
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')

        // 分隔线
        Divider()
          .vertical(false)
          .strokeWidth(1)
          .color(Color.Gray)
          .margin({ top: 20, bottom: 20 })

        // 图片显示区域
        Column() {
          Text('当前格式: ' + this.selectedFormat)
            .fontSize(18)
            .fontColor(Color.Blue)
            .margin({ bottom: 20 })

          if (this.currentImageDrawable) {
            Image(this.currentImageDrawable)
              .width(300)
              .height(300)
              .objectFit(ImageFit.Contain)
              .border({ color: Color.Black, width: 2 })
              .backgroundColor(Color.White)
          } else {
            Text('图片加载中...')
              .fontSize(16)
              .fontColor(Color.Gray)
              .width(300)
              .height(300)
              .textAlign(TextAlign.Center)
              .border({ color: Color.Gray, width: 1 })
          }
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')

        // 状态提示
        Text('支持多种图片格式显示测试')
          .fontSize(14)
          .fontColor(Color.Gray)
          .margin({ top: 20 })


        Text('DrawableDescriptor.getpixmap()调用显示')
          .fontSize(14)
          .fontColor(Color.Gray)
          .margin({ top: 20 })
        Image(this.currentImageDrawable?.getPixelMap())
          .width(300)
          .height(300)
          .objectFit(ImageFit.Contain)
          .border({ color: Color.Black, width: 2 })
          .backgroundColor(Color.White)
      }
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(10)
    .width('100%')
    .height('100%')
    .padding(20)
  }
}