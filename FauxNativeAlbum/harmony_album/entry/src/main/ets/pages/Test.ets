import { ICallBack, IFrameCallBack, MP4Parser } from "@ohos/mp4parser";
import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';

@Entry
@Component
struct GetImageData {
  @State videoUri: string = 'file:///data/storage/el2/base/haps/entry/files/douyin1.mp4';
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offCanvas: OffscreenCanvas = new OffscreenCanvas(600, 600)
  private img: ImageBitmap = new ImageBitmap('common/images/default_img.png')

  aboutToAppear() {
    this.getFrameAtTimeRang();
  }

  private getFrameAtTimeRang() {
    let getLocalDirPath = getContext(this).filesDir;
    console.log('getLocalDirPath：' + getLocalDirPath);
    let sourceMP4 = getLocalDirPath + "/douyin1.mp4";

    let filePath = getLocalDirPath + "/douyin1.mp4";
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.closeSync(file);

    let filenames = fs.listFileSync(getLocalDirPath);
    console.info("listFile succeed");
    console.info("listFile succeed" + filenames.length);
    for (let i = 0; i < filenames.length; i++) {
      console.info("filename: %s", filenames[i]);
    }

    let callBack: ICallBack = {
      callBackResult(code: number) {
        if (code == 0) {
          let frameCallBack: IFrameCallBack = {
            async callBackResult(data: ArrayBuffer, timeUs: number) {
            }
          }
          MP4Parser.getFrameAtTimeRang("1000000", "9000000", MP4Parser.OPTION_CLOSEST, frameCallBack);
        }
      }
    }
    MP4Parser.setDataSource(sourceMP4, callBack);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Video({
        src: this.videoUri,
        controller: new VideoController()
      })
        .width(300)
        .height(300)
        .autoPlay(true)

      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {
          let offContext = this.offCanvas.getContext("2d", this.settings)
          // 使用drawImage接口将图片画在（0，0）为起点，宽高130的区域
          offContext.drawImage(this.img, 0, 0, 130, 130);
          // 使用getImageData接口，获得canvas组件区域中，（50，50）为起点，宽高130范围内的绘制内容
          let imagedata = offContext.getImageData(50, 50, 130, 130);
          // 使用putImageData接口将得到的ImageData画在起点为（150， 150）的区域中
          offContext.putImageData(imagedata, 150, 150);
          // 将离屏绘制的内容画到canvas组件上
          let image = this.offCanvas.transferToImageBitmap();
          this.context.transferFromImageBitmap(image);
        })
    }
    .width('100%')
    .height('100%')
  }
}
