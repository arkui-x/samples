import { drawing, text } from '@kit.ArkGraphics2D'
import { image } from '@kit.ImageKit'
import { TitleBar } from '../title';

let textStyle: text.TextStyle = {
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  fontSize: 30,
};
let textStyle1: text.TextStyle = {
  color: {
    alpha: 255,
    red: 0,
    green: 0,
    blue: 255
  },
  fontSize: 30,
};
let paragraphStyle: text.ParagraphStyle = {
  textStyle: textStyle,
};
let paragraphStyle1: text.ParagraphStyle = {
  textStyle: textStyle1,
};
let fontCollection: text.FontCollection = new text.FontCollection();
let paragraphBuilder = new text.ParagraphBuilder(paragraphStyle, fontCollection);
let paragraphBuilder1 = new text.ParagraphBuilder(paragraphStyle1, fontCollection);

// 添加文本字符串
paragraphBuilder.addText("test 112233");
paragraphBuilder1.addText("test 445566");

// 生成排版对象
let paragraph = paragraphBuilder.build();
let paragraph1 = paragraphBuilder1.build();

function textFunc(pixelmap: PixelMap) {
  let canvas = new drawing.Canvas(pixelmap);
  paragraph.layoutSync(150);
  paragraph.paint(canvas, 0, 0);
}

function textFunc1(pixelmap: PixelMap) {
  let canvas = new drawing.Canvas(pixelmap);
  let path = new drawing.Path();
  path.arcTo(20, 20, 180, 180, 180, 90);
  paragraph1.layoutSync(200);
  paragraph1.paintOnPath(canvas, path, 0, 0);
}


@Entry
@Component
struct TestParagraph_paint {
  @State pixelmap?: PixelMap = undefined;
  @State pixelmap1?: PixelMap = undefined;
  fun: Function = textFunc;
  fun1: Function = textFunc1;

  @Builder
  groupTitle(title: string) {
    Text(title)
      .fontSize(14)
      .fontColor('#FF666666')
      .width('100%')
      .padding({ top: 8, bottom: 4 })
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar()

          Row() {
            Column() {
              Text("paintOnPath:")
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              Image(this.pixelmap1).width(200).height(200).border({ width: 1, color: Color.Gray })
            }

            Column() {
              Text("paint:")
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
              Image(this.pixelmap).width(200).height(200).border({ width: 1, color: Color.Gray })
            }
          }

          Row() {
            Button("paintOnPath")
              .width('35%')
              .height(30)
              .onClick(() => {
                const color: ArrayBuffer = new ArrayBuffer(160000);
                let opts: image.InitializationOptions =
                  { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
                this.pixelmap1 = image.createPixelMapSync(color, opts);
                this.fun1(this.pixelmap1);
              })
            Button("paint")
              .width('35%')
              .height(30)
              .margin(5)
              .onClick(() => {
                const color: ArrayBuffer = new ArrayBuffer(160000);
                let opts: image.InitializationOptions =
                  { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
                this.pixelmap = image.createPixelMapSync(color, opts);

                this.fun(this.pixelmap);
              })
          }

          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证paragraph：updateColor接口')
          Row() {
            Button("green")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateColor({
                  alpha: 255,
                  red: 0,
                  green: 255,
                  blue: 0
                });
              })

            Button("blue")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateColor({
                  alpha: 255,
                  red: 0,
                  green: 0,
                  blue: 255
                });
              })

            Button("black")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateColor({
                  alpha: 255,
                  red: 0,
                  green: 0,
                  blue: 0
                });
              })
            Button("yellow")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateColor({
                  alpha: 255,
                  red: 255,
                  green: 255,
                  blue: 0
                });
              })
          }

          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证paragraph：updateDecoration接口')

          this.groupTitle('设置TextDecorationType：')
          Row() {
            Button("OVERLINE")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.OVERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationThicknessScale: 2.0,
                });
              })

            Button("UNDERLINE")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.UNDERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationThicknessScale: 2.0,
                });
              })

            Button("LINE_THROUGH")
              .width('25%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.LINE_THROUGH,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  // decorationStyle: text.TextDecorationStyle.DOUBLE,
                  decorationThicknessScale: 2.0,
                });
              })
            Button("NONE")
              .width('20%')
              .height(30)
              .margin(5)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.NONE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  // decorationStyle: text.TextDecorationStyle.DOUBLE,
                  decorationThicknessScale: 2.0,
                });
              })
          }

          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('设置decorationStyle：')
          Row() {
            Button("SOLID")
              .width('20%')
              .height(30)
              // .margin(5)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.OVERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationStyle: text.TextDecorationStyle.SOLID,
                  decorationThicknessScale: 2.0,
                });
              })

            Button("DOUBLE")
              .width('20%')
              .height(30)
              .margin(3)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.OVERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationStyle: text.TextDecorationStyle.DOUBLE,
                  decorationThicknessScale: 2.0,
                });
              })

            Button("DOTTED")
              .width('20%')
              .height(30)
              .margin(3)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.OVERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationStyle: text.TextDecorationStyle.DOTTED,
                  decorationThicknessScale: 2.0,
                });
              })

            Button("DASHED")
              .width('20%')
              .height(30)
              .margin(3)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.OVERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationStyle: text.TextDecorationStyle.DASHED,
                  decorationThicknessScale: 2.0,
                });
              })

            Button("WAVY")
              .width('20%')
              .height(30)
              // .margin(5)
              .onClick(() => {
                paragraph.updateDecoration({
                  textDecoration: text.TextDecorationType.OVERLINE,
                  color: {
                    alpha: 255,
                    red: 0,
                    green: 0,
                    blue: 255
                  },
                  decorationStyle: text.TextDecorationStyle.WAVY,
                  decorationThicknessScale: 2.0,
                });
              })
          }

        }
      }
    }
  }
}
