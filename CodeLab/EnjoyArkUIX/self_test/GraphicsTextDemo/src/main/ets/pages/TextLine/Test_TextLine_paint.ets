import { drawing, text } from '@kit.ArkGraphics2D'
import { image } from '@kit.ImageKit'
import { TitleBar } from './../title';

let textStyle: text.TextStyle = {
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  fontSize: 30,
};
let paragraphStyle: text.ParagraphStyle = {
  textStyle: textStyle,
  maxLines: 1,
};
let fontCollection: text.FontCollection = new text.FontCollection();
let paragraphBuilder = new text.ParagraphBuilder(paragraphStyle, fontCollection);
// 添加文本字符串
paragraphBuilder.addText("test 1122333");
// 生成排版对象
let paragraph = paragraphBuilder.build();

function textFunc(pixelmap: PixelMap) {
  // 通过图片对象构造画布
  let canvas = new drawing.Canvas(pixelmap);
  // 进行绘制文本字符串
  const lines = paragraph.getTextLines();
  let truncatedTextLine = lines[0].createTruncatedLine(100, text.EllipsisMode.END, "ABC");
  truncatedTextLine.paint(canvas, 0, 100);


}

function textFunc1(pixelmap: PixelMap) {
  // 通过图片对象构造画布
  let canvas = new drawing.Canvas(pixelmap);
  // 进行绘制文本字符串
  const lines = paragraph.getTextLines();
  let truncatedTextLine = lines[0].createTruncatedLine(100, text.EllipsisMode.START, "ABC");
  truncatedTextLine.paint(canvas, 0, 100);
}

@Entry
@Component
struct Index {
  @State pixelmap?: PixelMap = undefined;
  @State pixelmap1?: PixelMap = undefined;
  @State pixelmap2?: PixelMap = undefined;
  fun: Function = textFunc;
  fun1: Function = textFunc1;

  async prepareLayoutPromise() {
    // 排版对象进行布局计算
    paragraph.layout(200).then((data) => {
      console.info(`Succeeded in doing layout,  ${JSON.stringify(data)}`);
    }).catch((error: Error) => {
      console.error(`Failed to do layout, error: ${JSON.stringify(error)} message: ${error.message}`);
    });
  }

  aboutToAppear() {
    this.prepareLayoutPromise();
  }
  aboutToDisappear() {
    fontCollection.unloadFontSync("HarmonyOS_Sans_SC_Light")
  }
  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar()
          Text("设置ABC文本在尾部截断").margin(5)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Image(this.pixelmap).width(200).height(200).border({ width: 1, color: Color.Gray });

          Button("Test createTruncatedLine(END)")
            .width('50%')
            .height(50)
            .margin(5)
            .onClick(() => {
              const color: ArrayBuffer = new ArrayBuffer(160000);
              let opts: image.InitializationOptions =
                { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
              if (this.pixelmap == undefined) {
                this.pixelmap = image.createPixelMapSync(color, opts);
              }
              this.fun(this.pixelmap);
            })


          Text("设置ABC文本在头部截断").margin(5)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Image(this.pixelmap1).width(200).height(200).border({ width: 1, color: Color.Gray });

          Button("Test createTruncatedLine(START)")
            .width('50%')
            .height(50)
            .margin(5)
            .onClick(() => {
              const color: ArrayBuffer = new ArrayBuffer(160000);
              let opts: image.InitializationOptions =
                { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
              if (this.pixelmap1 == undefined) {
                this.pixelmap1 = image.createPixelMapSync(color, opts);
              }
              this.fun1(this.pixelmap1);
            })
        }
      }
    }
  }
}
