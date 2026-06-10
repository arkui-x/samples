import { common2D, text } from "@kit.ArkGraphics2D"
import { image } from "@kit.ImageKit";
import { drawing } from '@kit.ArkGraphics2D';
import { TitleBar } from '../title';

let fontCollection = new text.FontCollection();
export function buildParagraph() {
  fontCollection.loadFontSync('HarmonyOS_Sans_SC_Light',
    $rawfile("HarmonyOS_Sans_SC_Light.ttf"));
  let fontFamilies: Array<string> = ["HarmonyOS_Sans_SC_Light"];

  let myTextStyle: text.TextStyle = {
    color: {
      alpha: 255,
      red: 255,
      green: 0,
      blue: 255
    },
    fontFamilies: fontFamilies,
  };
  let myParagraphStyle: text.ParagraphStyle = {
    textStyle: myTextStyle
  };
  let myPlaceholderSpan: text.PlaceholderSpan = {
    width: 12,
    height: 21,
    align: text.PlaceholderAlignment.BELOW_BASELINE,
    baseline: text.TextBaseline.ALPHABETIC,
    baselineOffset: 66
  };
  const ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
  ParagraphGraphBuilder.addPlaceholder(myPlaceholderSpan);
  ParagraphGraphBuilder.addText("中文English123");
  ParagraphGraphBuilder.pushStyle(myTextStyle);
  return ParagraphGraphBuilder.build();
}

const color: ArrayBuffer = new ArrayBuffer(160000);
let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
let pixelMap: image.PixelMap = image.createPixelMapSync(color, opts);

@Entry
@Component
struct ParagraphTest {
  @State paragraph: text.Paragraph = buildParagraph();
  @State path: drawing.Path = new drawing.Path();
  @State canvas: drawing.Canvas = new drawing.Canvas(pixelMap);
  @State msg: string = "Test_Graphics_Text"
  @State pixelmap?: PixelMap = undefined;

  aboutToDisappear() {
    fontCollection.unloadFontSync("HarmonyOS_Sans_SC_Light")
  }
  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar()
          Text("--测试中英文--")
            .fontSize(20)
            .margin(20)
            .fontWeight(FontWeight.Bold)

          Text(this.msg)
            .fontSize(20)
            .margin(20)
            .fontWeight(FontWeight.Bold)
            .border({ width: 1, color: Color.Gray })

          Image(this.pixelmap).width(200).height(200).border({ width: 1, color: Color.Gray });

          Button("Test paint")
            .margin(5).width('50%')
            .onClick(() => {
              const color: ArrayBuffer = new ArrayBuffer(160000);
              let opts: image.InitializationOptions =
                { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
              this.pixelmap = image.createPixelMapSync(color, opts);
              let canvas = new drawing.Canvas(this.pixelmap);
              this.paragraph.paint(canvas, 0, 0);
            })

          Row() {
            Button("layoutSync")
              .width('50%').height(30)
              .onClick(() => {
                this.paragraph.layoutSync(100);
                console.info(this.msg = ` Succeeded in doing layoutSync`);
              })

            Button("layout")
              .margin(5)
              .width('50%').height(30)
              .onClick(() => {
                this.paragraph.layout(100).then((data) => {
                  console.info(this.msg = ` Succeeded in doing layout`);
                }).catch((error: Error) => {
                  console.error(this.msg =
                    ` Failed to do layout, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              })
          }

          Row() {
            Button("layout(null)")
              .width('50%')
              .height(30)
              .onClick(() => {
                this.paragraph.layout(null).then((data) => {
                  console.info(this.msg + ` Succeeded in doing layout`);
                }).catch((error: Error) => {
                  console.error(this.msg =
                    ` 1 Failed to do layout, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              })

            Button("layout(undefined)")
              .margin(5)
              .width('50%').height(30)
              .onClick(() => {
                this.paragraph.layout(undefined).then((data) => {
                  console.info(this.msg + ` Succeeded in doing layout`);
                }).catch((error: Error) => {
                  console.error(this.msg =
                    ` 2 Failed to do layout, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              })
          }

          Row() {
            Button("layout(-100)")
              .margin(5)
              .width('50%').height(30)
              .onClick(() => {
                this.paragraph.layout(-100).then((data) => {
                  console.info(this.msg = ` Succeeded in doing layout`);
                }).catch((error: Error) => {
                  console.error(this.msg =
                    ` Failed to do layout, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              })
            Button("getMaxIntrinsicWidth")
              .width('50%').height(30)
              .onClick(() => {
                const MaxIntrinsicWidth = this.paragraph.getMaxIntrinsicWidth();
                console.info(this.msg = '  MaxIntrinsicWidth:' + JSON.stringify(MaxIntrinsicWidth));
              })
          }


          Row() {
            Button("getMaxWidth")
              .width('50%').height(30)
              .onClick(() => {
                const maxWidth = this.paragraph.getMaxWidth();
                console.info(this.msg = '  maxWidth:' + JSON.stringify(maxWidth));
              })

            Button("getHeight")
              .margin(5)
              .width('50%').height(30)
              .onClick(() => {
                const height = this.paragraph.getHeight();
                console.info(this.msg = '  height:' + JSON.stringify(height));
              })
          }

          Row() {
            Button("getLongestLine")
              .width('50%').height(30)
              .onClick(() => {
                const longestLineWithIndent = this.paragraph.getLongestLine();
                console.info(this.msg = '  longestLine:' + JSON.stringify(longestLineWithIndent));
              })
            Button("getLongestLineWithIndent")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                const longestLine = this.paragraph.getLongestLineWithIndent();
                console.info(this.msg = '  LongestLineWithIndent:' + JSON.stringify(longestLine));
              })
          }


          Row() {
            Button("getMinIntrinsicWidth")
              .width('50%').height(30)
              .onClick(() => {
                const MinIntrinsicWidth = this.paragraph.getMinIntrinsicWidth();
                console.info(this.msg = '  MinIntrinsicWidth:' + JSON.stringify(MinIntrinsicWidth));
              })
            Button("getAlphabeticBaseline")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                const alphabeticBaseline = this.paragraph.getAlphabeticBaseline();
                console.info(this.msg = '  alphabeticBaseline:' + JSON.stringify(alphabeticBaseline));
              })
          }

          Row() {
            Button("getIdeographicBaseline")
              .width('50%').height(30)
              .onClick(() => {
                const ideographicBaseline = this.paragraph.getIdeographicBaseline();
                console.info(this.msg = '  ideographicBaseline:' + JSON.stringify(ideographicBaseline));
              })

            Button("getRectsForPlaceholders")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                let placeholderRects = this.paragraph.getRectsForPlaceholders();
                console.info(this.msg = '  placeholderRects:' + JSON.stringify(placeholderRects));
              })
          }

          Row({ space: 8 }) { // 两列之间留 8
            Column({ space: 4 }) {
              Button("getRectsForRange")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let range: text.Range = { start: 0, end: 1 };
                  const rects =
                    this.paragraph.getRectsForRange(range, text.RectWidthStyle.TIGHT, text.RectHeightStyle.TIGHT);
                  console.info(this.msg = '  rects:' + JSON.stringify(rects));
                })

              Button("getRectsForRange（-10）")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let range: text.Range = { start: -10, end: -10 };
                  const rects =
                    this.paragraph.getRectsForRange(range, text.RectWidthStyle.TIGHT, text.RectHeightStyle.TIGHT);
                  console.info(this.msg = '  rects:' + JSON.stringify(rects));
                })

              Button("getRectsForRange(null)")
                .width('100%').height(30).margin(5)
                .onClick(() => {
                  const rects =
                    this.paragraph.getRectsForRange(null, null, null);
                  console.info(this.msg = '  rects:' + JSON.stringify(rects));
                })

              Button("getRectsForRange(undefined)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  const rects =
                    this.paragraph.getRectsForRange(undefined, undefined, undefined);
                  console.info(this.msg = '  rects:' + JSON.stringify(rects));
                })
            }.width('50%')

            Column({ space: 4 }) {
              Button("getGlyphPositionAtCoordinate")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let positionWithAffinity = this.paragraph.getGlyphPositionAtCoordinate(0, 0);
                  console.info(this.msg = '  positionWithAffinity:' + JSON.stringify(positionWithAffinity));
                })

              Button("getGlyphPosition..(null)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let positionWithAffinity = this.paragraph.getGlyphPositionAtCoordinate(null, null);
                  console.info(this.msg = '  positionWithAffinity:' + JSON.stringify(positionWithAffinity));
                })

              Button("getGlyphPosition..(undefined)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let positionWithAffinity = this.paragraph.getGlyphPositionAtCoordinate(undefined, undefined);
                  console.info(this.msg = '  positionWithAffinity:' + JSON.stringify(positionWithAffinity));
                })

              Button("getGlyphPosition..(-100)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let positionWithAffinity = this.paragraph.getGlyphPositionAtCoordinate(-100, -100);
                  console.info(this.msg = '  positionWithAffinity:' + JSON.stringify(positionWithAffinity));
                })
            }.width('50%')
          }

          Row({ space: 8 }) { // 两列之间留 8
            Column({ space: 4 }) {
              Button("getActualTextRange")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let rang = this.paragraph.getActualTextRange(0, true);
                  console.info(this.msg = '  ActualTextRange:' + JSON.stringify(rang));
                })

              Button("getActualTextRange (-100)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let rang = this.paragraph.getActualTextRange(-100, true);
                  console.info(this.msg = '  ActualTextRange:' + JSON.stringify(rang));
                })

              Button("getActualTextRange(null)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let rang = this.paragraph.getActualTextRange(null, null);
                  console.info(this.msg = '  ActualTextRange:' + JSON.stringify(rang));
                })

              Button("getActualTextRange(undefined)")
                .margin(5).width('100%').height(30)
                .onClick(() => {
                  let rang = this.paragraph.getActualTextRange(undefined, undefined);
                  console.info(this.msg = '  ActualTextRange:' + JSON.stringify(rang));
                })

            }.width('50%')

            Column({ space: 4 }) {
              Button("getWordBoundary").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let wordRange = this.paragraph.getWordBoundary(0);
                  console.info(this.msg = '  wordRange:' + JSON.stringify(wordRange));
                })


              Button("getWordBoundary(-100)").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let wordRange = this.paragraph.getWordBoundary(-100);
                  console.info(this.msg = '  wordRange:' + JSON.stringify(wordRange));
                })

              Button("getWordBoundary(null)").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let wordRange = this.paragraph.getWordBoundary(null);
                  console.info(this.msg = '  wordRange:' + JSON.stringify(wordRange));
                })

              Button("getWordBoundary(undefined)").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let wordRange = this.paragraph.getWordBoundary(undefined);
                  console.info(this.msg = '  wordRange:' + JSON.stringify(wordRange));
                })
            }.width('50%')
          }

          Row({ space: 8 }) { // 两列之间留 8
            Column({ space: 4 }) {
              Button("getLineHeight").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let lineHeight = this.paragraph.getLineHeight(0);
                  console.info(this.msg = '  lineHeight:' + JSON.stringify(lineHeight));
                })

              Button("getLineHeigh(-100)").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let lineHeight = this.paragraph.getLineHeight(-100);
                  console.info(this.msg = '  lineHeight:' + JSON.stringify(lineHeight));
                })

              Button("getLineHeight(null)")
                .width('100%').height(30).margin(5)
                .onClick(() => {
                  let lineHeight = this.paragraph.getLineHeight(null);
                  console.info(this.msg = '  lineHeight:' + JSON.stringify(lineHeight));
                })

              Button("getLineHeight(undefined)").margin(5)
                .width('100%').height(30)
                .onClick(() => {
                  let lineHeight = this.paragraph.getLineHeight(undefined);
                  console.info(this.msg = '  lineHeight:' + JSON.stringify(lineHeight));
                })
            }.width('50%')

            Column({ space: 4 }) {
              Button("getLineWidth")
                .width('100%').height(30).margin(5)
                .onClick(() => {
                  let lineWidth = this.paragraph.getLineWidth(0);
                  console.info(this.msg = '  lineWidth:' + JSON.stringify(lineWidth));
                })
              Button("getLineWidth(-100)")
                .width('100%').height(30).margin(5)
                .onClick(() => {
                  let lineWidth = this.paragraph.getLineWidth(-100);
                  console.info(this.msg = '  lineWidth:' + JSON.stringify(lineWidth));
                })
              Button("getLineWidth(null)")
                .width('100%').height(30).margin(5)
                .onClick(() => {
                  let lineWidth = this.paragraph.getLineWidth(null);
                  console.info(this.msg = '  lineWidth:' + JSON.stringify(lineWidth));
                })

              Button("getLineWidth(undefined)")
                .width('100%').height(30).margin(5)
                .onClick(() => {
                  let lineWidth = this.paragraph.getLineWidth(undefined);
                  console.info(this.msg = '  lineWidth:' + JSON.stringify(lineWidth));
                })
            }.width('50%')
          }

          Row() {
            Button("getTextLines")
              .width('50%').height(30)
              .onClick(() => {
                let lines = this.paragraph.getTextLines();
                console.info(this.msg = ` Succeed getTextLines :${lines}`);
              })
            Button("didExceedMaxLines")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                let didExceed = this.paragraph.didExceedMaxLines();
                console.info(this.msg = '  didExceed:' + JSON.stringify(didExceed));
              })
          }

          Row() {
            Button("getLineMetrics")
              .width('50%').height(30)
              .onClick(() => {
                let arrLineMetrc = this.paragraph.getLineMetrics();
                console.info(this.msg = '  LineMetrics:' + JSON.stringify(arrLineMetrc));
              })

            Button("getLineMetrics(0)")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                let arrLineMetrc = this.paragraph.getLineMetrics(0);
                console.info(this.msg = '  arrLineMetrc:' + JSON.stringify(arrLineMetrc));
              })
          }


          Row() {
            Button("getLineMetrics(100)")
              .width('50%').height(30)
              .onClick(() => {
                let arrLineMetrc = this.paragraph.getLineMetrics(100);
                console.info(this.msg = '  arrLineMetrc:' + JSON.stringify(arrLineMetrc));
              })

            Button("getLineMetrics(-100)")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                let arrLineMetrc = this.paragraph.getLineMetrics(-100);
                console.info(this.msg = '  arrLineMetrc:' + JSON.stringify(arrLineMetrc));
              })
          }

          Row() {
            Button("getLineMetrics(null)")
              .width('50%').height(30)
              .onClick(() => {
                let arrLineMetrc = this.paragraph.getLineMetrics(null);
                console.info(this.msg = '  arrLineMetrc:' + JSON.stringify(arrLineMetrc));
              })

            Button("getLineMetrics(undefined)")
              .margin(5).width('50%').height(30)
              .onClick(() => {
                let arrLineMetrc = this.paragraph.getLineMetrics(undefined);
                console.info(this.msg = '  arrLineMetrc:' + JSON.stringify(arrLineMetrc));
              })
          }

        }
      }
    }
  }
}



