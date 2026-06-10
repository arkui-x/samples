import { common2D, text } from "@kit.ArkGraphics2D"
import { drawing } from '@kit.ArkGraphics2D';
import { TitleBar } from '../title';
import { image } from "@kit.ImageKit";

let fontCollection = new text.FontCollection();
fontCollection.loadFontSync('HarmonyOS_Sans_SC_Light',
  $rawfile("HarmonyOS_Sans_SC_Light.ttf"));
let fontFamilies: Array<string> = ["HarmonyOS_Sans_SC_Light"];
let decoration: text.Decoration = {
  textDecoration: text.TextDecorationType.UNDERLINE,
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  decorationStyle: text.TextDecorationStyle.SOLID,
  decorationThicknessScale: 20
};
let myTextStyle: text.TextStyle = {
  decoration: decoration,
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  fontWeight: text.FontWeight.W100,
  fontStyle: text.FontStyle.ITALIC,
  baseline: text.TextBaseline.ALPHABETIC,
  fontSize: 30,
  letterSpacing: 20,
  wordSpacing: 20,
  heightScale: 20,
  halfLeading: true,
  heightOnly: true,
  ellipsis: "456",
  ellipsisMode: text.EllipsisMode.START,
  locale: "789",
  fontFamilies: fontFamilies,

};

let myParagraphStyle: text.ParagraphStyle = {
  textStyle: myTextStyle,
}

export function buildParagraph() {

  let myTextStyle: text.TextStyle = {
    color: {
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    },
    fontWeight: text.FontWeight.W100,
    fontStyle: text.FontStyle.ITALIC,
    baseline: text.TextBaseline.ALPHABETIC,
    fontFamilies: fontFamilies,
  };
  let myParagraphStyle: text.ParagraphStyle = {
    textStyle: myTextStyle,
    breakStrategy: text.BreakStrategy.HIGH_QUALITY
  };
  const ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
  ParagraphGraphBuilder.addText("!@#$%^&*()_)(*&^%$#@#$%^&*()_)(*&^%$)");
;
  return ParagraphGraphBuilder.build();

}

function callback(offset: number, index: number, leadingEdge: boolean): boolean {
  console.info('textLine: offset: ' + offset + ', index: ' + index + ', leadingEdge: ' + leadingEdge);
  return index > 50;
}

@Entry
@Component
struct TestTextLine {
  @State fontCollection: text.FontCollection = new text.FontCollection();
  @State paragraph: text.Paragraph = buildParagraph();
  @State path: drawing.Path = new drawing.Path();
  @State paragraphBuilder: text.ParagraphBuilder = new text.ParagraphBuilder(myParagraphStyle, this.fontCollection);
  @State msg: string = "Test_Graphics_Text"
  @State pixelmap?: PixelMap = undefined;

  async prepareLayoutPromise() {
    // 排版对象进行布局计算
    this.paragraph.layout(200).then((data) => {
      console.info(this.msg + `Succeeded in doing layout,  ${JSON.stringify(data)}`);
    }).catch((error: Error) => {
      console.error(this.msg + `Failed to do layout, error: ${JSON.stringify(error)} message: ${error.message}`);
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
          Text("--测试特殊符号--")
            .fontSize(20)
            .margin(20)
            .fontWeight(FontWeight.Bold)

          Text(this.msg)
            .fontSize(20)
            .margin(20)
            .fontWeight(FontWeight.Bold)
            .border({ width: 1, color: Color.Gray })

          Image(this.pixelmap).width('80%').height('30%').border({ width: 1, color: Color.Gray });

          Button("Test paint")
            .margin(5).width('50%')
            .onClick(() => {
              const color: ArrayBuffer = new ArrayBuffer(160000);
              let opts: image.InitializationOptions =
                { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
              this.pixelmap = image.createPixelMapSync(color, opts);
              let canvas = new drawing.Canvas(this.pixelmap);
              const lines = this.paragraph.getTextLines();
              lines[0].paint(canvas, 0, 50);
            })

          Row() {
            Button("getGlyphCount")
              .margin(5)
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                const glyphCount = lines[0].getGlyphCount();
                console.info(this.msg = ` glyphCount:${glyphCount}`);
              })

            Button("getTextRange")
              .margin(5)
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                const textRange: text.Range = lines[0].getTextRange();
                console.info(this.msg = ' textRange:' + JSON.stringify(textRange));
              })
          }

          Row() {
            Button("getGlyphRuns")
              .margin(5)
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                const GlyphRuns = lines[0].getGlyphRuns();
                console.info(this.msg = ` GlyphRuns:${GlyphRuns}`);
              })

            Button("getTypographicBounds")
              .margin(5)
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                const bounds = lines[0].getTypographicBounds();
                console.info(this.msg = '  textLine ascent:' + bounds.ascent + ', descent:' + bounds.descent +
                  ', leading:' +
                bounds.leading + ', width:' + bounds.width);
              })
          }

          Row() {
            Button("getImageBounds")
              .margin(5)
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                let imageBounds = lines[0].getImageBounds();
                console.info(this.msg = ' imageBounds:' + JSON.stringify(imageBounds));
              })

            Button("getTrailingSpaceWidth")
              .margin(5)
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                const trailingSpaceWidth = lines[0].getTrailingSpaceWidth();
                console.info(this.msg = ` trailingSpaceWidth:${trailingSpaceWidth}`);
              })
          }

          Button("getStringIndexForPosition")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let point: common2D.Point = { x: 15.0, y: 2.0 };
              let index = lines[0].getStringIndexForPosition(point);
              console.info(this.msg = ` getStringIndexForPosition:${index}`);
            })

          Button("getStringIndexForPosition（-100）")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let point: common2D.Point = { x: -100, y: -100 };
              let index = lines[0].getStringIndexForPosition(point);
              console.info(this.msg = ` getStringIndexForPosition:${index}`);
            })

          Button("getStringIndexForPosition(null)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let index = lines[0].getStringIndexForPosition(null);
              console.info(this.msg = ` getStringIndexForPosition:${index}`);
            })

          Button("getStringIndexForPosition(undefined)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let index = lines[0].getStringIndexForPosition(undefined);
              console.info(this.msg = ` getStringIndexForPosition:${index}`);
            })

          Button("getOffsetForStringIndex")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let offset = lines[0].getOffsetForStringIndex(3);
              console.info(this.msg = ` getOffsetForStringIndex:${offset}`);
            })

          Button("getOffsetForStringIndex(-100)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let offset = lines[0].getOffsetForStringIndex(-100);
              console.info(this.msg = ` getOffsetForStringIndex:${offset}`);
            })

          Button("getOffsetForStringIndex(null)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let offset = lines[0].getOffsetForStringIndex(null);
              console.info(this.msg = ` getOffsetForStringIndex:${offset}`);
            })

          Button("getOffsetForStringIndex(undefined)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let offset = lines[0].getOffsetForStringIndex(undefined);
              console.info(this.msg = ` getOffsetForStringIndex:${offset}`);
            })


          Button("enumerateCaretOffsets")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              lines[0].enumerateCaretOffsets(callback);
            })

          Button("getAlignmentOffset")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();

              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let alignmentOffset = lines[0].getAlignmentOffset(2.0, 200);
              console.info(this.msg = ` getAlignmentOffset:${alignmentOffset}`);
            })


          Button("getAlignmentOffset（-100）")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();

              if (lines.length === 0) {
                console.error(this.msg + " no text lines");
                return;
              }
              let alignmentOffset = lines[0].getAlignmentOffset(-100, 200);
              console.info(this.msg = ` getAlignmentOffset:${alignmentOffset}`);
            })

          Button("getAlignmentOffset(null)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              try {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg = " no text lines");
                  return;
                }
                let alignmentOffset = lines[0].getAlignmentOffset(null, null);
                console.info(this.msg = ` getAlignmentOffset:${alignmentOffset}`);
              } catch (err) {
                console.info(this.msg = ' Failed in lineTypeset.getAlignmentOffset Cause: ' + JSON.stringify(err));
              }
            })

          Button("getAlignmentOffset(undefined)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              try {
                const lines = this.paragraph.getTextLines();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                let alignmentOffset = lines[0].getAlignmentOffset(undefined, undefined);
                console.info(this.msg = ` getAlignmentOffset:${alignmentOffset}`);
              } catch (err) {
                console.info(this.msg = ' Failed in lineTypeset.getAlignmentOffset Cause: ' + JSON.stringify(err));
              }
            })

          Row({ space: 8 }) { // 两列之间留 8
            Column({ space: 4 }) {
              Button("getLineBreak")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  this.paragraphBuilder.addText("123456789");

                  let startIndex = 1;
                  let width = 5;
                  let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                  let LineBreak = lineTypeset.getLineBreak(startIndex, width);
                  console.info(this.msg = ` getLineBreak:${LineBreak}`);
                })

              Button("getLineBreak（100）")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  this.paragraphBuilder.addText("123456789");
                  try {
                    let startIndex = 100;
                    let width = 5;
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let LineBreak = lineTypeset.getLineBreak(startIndex, width);
                    console.info(this.msg = ` getLineBreak:${LineBreak}`);
                  } catch (error) {
                    console.error(this.msg =
                      ` Failed to do getLineBreak, error: ${JSON.stringify(error)} message: ${error.message}`);
                  }
                })
              Button("getLineBreak（-100）")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  this.paragraphBuilder.addText("123456789");

                  try {
                    let startIndex = -100;
                    let width = 5;
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let LineBreak = lineTypeset.getLineBreak(startIndex, width);
                    console.info(this.msg = ` getLineBreak:${LineBreak}`);
                  } catch (error) {
                    console.error(this.msg =
                      ` Failed to do getLineBreak, error: ${JSON.stringify(error)} message: ${error.message}`);
                  }
                })

              Button("getLineBreak(null)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  try {
                    this.paragraphBuilder.addText("123456789");
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let LineBreak = lineTypeset.getLineBreak(null, null);
                    console.info(this.msg = ` getLineBreak:${LineBreak}`);
                  } catch (err) {
                    console.info(this.msg = ' Failed in lineTypeset.getLineBreak Cause: ' + JSON.stringify(err));
                  }
                })

              Button("getLineBreak(undefined)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  try {
                    this.paragraphBuilder.addText("123456789");

                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let LineBreak = lineTypeset.getLineBreak(undefined, undefined);
                    console.info(this.msg = ` getLineBreak:${LineBreak}`);
                  } catch (err) {
                    console.info(this.msg = ' Failed in lineTypeset.getLineBreak Cause: ' + JSON.stringify(err));
                  }
                })
            }.width('50%')

            Column({ space: 4 }) {
              Button("createLine")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  this.paragraphBuilder.addText("123456");

                  let startIndex = 1;
                  let width = 5;
                  let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                  let LineBreak = lineTypeset.getLineBreak(startIndex, width);
                  let line: text.TextLine = lineTypeset.createLine(startIndex, LineBreak);
                  console.info(this.msg = ' createLine getGlyphCount:' + JSON.stringify(line.getGlyphCount()));
                })


              Button("createLine（100）")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  this.paragraphBuilder.addText("123456");
                  try {
                    let startIndex = 100;
                    let width = 5;
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let LineBreak = lineTypeset.getLineBreak(startIndex, width);
                    let line: text.TextLine = lineTypeset.createLine(startIndex, LineBreak);
                    console.info(this.msg = ' createLine getGlyphCount:' + JSON.stringify(line.getGlyphCount()));
                  } catch (error) {
                    console.error(this.msg =
                      ` Failed to do createLine, error: ${JSON.stringify(error)} message: ${error.message}`);
                  }
                })

              Button("createLine（-100）")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  this.paragraphBuilder.addText("123456");

                  try {
                    let startIndex = -100;
                    let width = 5;
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let LineBreak = lineTypeset.getLineBreak(startIndex, width);
                    let line: text.TextLine = lineTypeset.createLine(startIndex, LineBreak);
                    console.info(this.msg = ' createLine getGlyphCount:' + JSON.stringify(line.getGlyphCount()));
                  } catch (error) {
                    console.error(this.msg =
                      ` Failed to do createLine, error: ${JSON.stringify(error)} message: ${error.message}`);
                  }
                })

              Button("createLine(null)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  try {
                    this.paragraphBuilder.addText("123456");
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let line: text.TextLine = lineTypeset.createLine(null, null);
                    console.info(this.msg = ' createLine getGlyphCount:' + JSON.stringify(line.getGlyphCount()));
                  } catch (err) {
                    console.info(this.msg = ' Failed in lineTypeset.createLine Cause: ' + JSON.stringify(err));
                  }
                })

              Button("createLine(undefined)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  try {
                    this.paragraphBuilder.addText("123456");
                    let lineTypeset = this.paragraphBuilder.buildLineTypeset();
                    let line: text.TextLine = lineTypeset.createLine(undefined, undefined);
                    console.info(this.msg = ' createLine getGlyphCount:' + JSON.stringify(line.getGlyphCount()));
                  } catch (err) {
                    console.info(this.msg = ' Failed in lineTypeset.createLine Cause: ' + JSON.stringify(err));
                  }
                })
            }.width('50%')
          }
        }
      }
    }
  }
}

