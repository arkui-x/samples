import { text } from "@kit.ArkGraphics2D"
import { image } from "@kit.ImageKit";
import { drawing } from '@kit.ArkGraphics2D';
import { TitleBar } from '../title';

let fontCollection = new text.FontCollection();
export function buildParagraph() {
  fontCollection.loadFontSync('NotoSansMyanmar-Regular',
    $rawfile("NotoSansMyanmar-Regular.ttf"));
  let fontFamilies: Array<string> = ["NotoSansMyanmar-Regular"];
  let myTextStyle: text.TextStyle = {
    color: {
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    },
    fontWeight: text.FontWeight.W100,
    fontSize: 10,
    fontFamilies: fontFamilies,
  };
  let myParagraphStyle: text.ParagraphStyle = {
    textStyle: myTextStyle
  };

  const ParagraphGraphBuilder = new text.ParagraphBuilder(myParagraphStyle, fontCollection);
  ParagraphGraphBuilder.addText("မြန်မာစာသည်ဗြာဟ္မီအက္ခရာမှဆင်းသက်လာပြီး ၁၂၃၄ ပါဝင်သည်။");
  return ParagraphGraphBuilder.build();
}

const color: ArrayBuffer = new ArrayBuffer(160000);
let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
let pixelMap: image.PixelMap = image.createPixelMapSync(color, opts);


@Entry
@Component
struct TestRun {
  @State fontCollection: text.FontCollection = new text.FontCollection();
  @State paragraph: text.Paragraph = buildParagraph();
  @State path: drawing.Path = new drawing.Path();
  @State canvas: drawing.Canvas = new drawing.Canvas(pixelMap);
  @State pixelmap?: PixelMap = undefined;
  @State msg: string = "Test_Graphics_Text"

  async prepareLayoutPromise() {
    this.paragraph.layout(200).then((data) => {
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
          Text("--测试缅甸文--")
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
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              GlyphRuns[0].paint(canvas, 0, 0);
            })
          Row() {
            Button("getGlyphCount")
              .margin(5).width('40%').height(30)

              .onClick(() => {
                let lines = this.paragraph.getTextLines();
                let GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const glyphCount = GlyphRuns[0].getGlyphCount();
                console.info(this.msg = `glyphCount:${glyphCount}`);
              })

            Button("getGlyphs")
              .margin(5).width('40%').height(30)

              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Glyphs = GlyphRuns[0].getGlyphs();
                console.info(this.msg = `Glyphs:${Glyphs}`);
              })

          }

          Button("getGlyphs({start: 0, end: 1})")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              const Glyphs = GlyphRuns[0].getGlyphs({ start: 0, end: 1 });
              console.info(this.msg = `Glyphs:${Glyphs}`);
            })

          Button("getGlyphs({start:0, end:-10})")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              const Glyphs = GlyphRuns[0].getGlyphs({ start: 0, end: -10 });
              console.info(this.msg = `Glyphs:${Glyphs}`);

            })

          Button("getGlyphs({ start: -1, end: 2 })")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              const Glyphs = GlyphRuns[0].getGlyphs({ start: -1, end: 2 });
              console.info(this.msg = ` Glyphs:${Glyphs}`);
            })
          Row() {
            Button("getGlyphs(null)")
              .margin(5).width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Glyphs = GlyphRuns[0].getGlyphs(null);
                console.info(this.msg = ` Glyphs:${Glyphs}`);
              })

            Button("getGlyphs(undefined)")
              .margin(5).width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();

                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Glyphs = GlyphRuns[0].getGlyphs(undefined);
                console.info(this.msg = ` Glyphs:${Glyphs}`);
              })
          }

          Row() {
            Button("getTextDirection")
              .width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                let TextDirection = GlyphRuns[0].getTextDirection();
                console.info(this.msg = '  TextDirection :' + JSON.stringify(TextDirection))
              })

            Button("getPositions()")
              .margin(5).width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (lines.length === 0) {
                  console.error(this.msg + " no text lines");
                  return;
                }
                const Positions = GlyphRuns[0].getPositions();
                console.info(this.msg = ' Positions:' + JSON.stringify(Positions));
              })
          }


          Button("getPositions({ start: 1, end: 2 })")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();

              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              const Positions = GlyphRuns[0].getPositions({ start: 1, end: 2 });
              console.info(this.msg = ' Positions:' + JSON.stringify(Positions));
            })

          Button("getPositions({ start: -1, end: 2 })")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();

              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              const Positions = GlyphRuns[0].getPositions({ start: -1, end: 2 });
              console.info(this.msg = ' Positions:' + JSON.stringify(Positions));
            })

          Button("getPositions({ start: 0, end: -10 })")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();

              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              const Positions = GlyphRuns[0].getPositions({ start: 0, end: -10 });
              console.info(this.msg = ' Positions:' + JSON.stringify(Positions));
            })
          Row() {
            Button("getPositions(null)")
              .margin(5).width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();

                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Positions = GlyphRuns[0].getPositions(null);
                console.info(this.msg = ' Positions:' + JSON.stringify(Positions));
              })

            Button("getPositions(undefined)")
              .margin(5).width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();

                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Positions = GlyphRuns[0].getPositions(undefined);
                console.info(this.msg = ' Positions:' + JSON.stringify(Positions));
              })
          }

          Row() {
            Button("getOffsets")
              .margin(5).height(30)
              .width('40%')
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();

                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Offsets = GlyphRuns[0].getOffsets();
                console.info(this.msg = ' Offsets:' + JSON.stringify(Offsets));
              })

            Button("getFont")
              .margin(5).width('40%').height(30)
              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                const Font = GlyphRuns[0].getFont();
                console.info(this.msg = ` Font:${Font}`);
              })
          }

          Row() {
            Button("getStringRange")
              .margin(5).width('40%').height(30)

              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                let stringRange: text.Range = GlyphRuns[0].getStringRange();
                console.info(this.msg =
                  '  stringRange start:' + JSON.stringify(stringRange.start) + '  stringRange end:' +
                  JSON.stringify(stringRange.end));
              })

            Button("getStringIndices")
              .margin(5).width('40%').height(30)

              .onClick(() => {
                const lines = this.paragraph.getTextLines();
                const GlyphRuns = lines[0].getGlyphRuns();
                if (GlyphRuns.length === 0) {
                  console.error(this.msg + " no text Runs");
                  return;
                }
                let StringIndices = GlyphRuns[0].getStringIndices();
                console.info(this.msg = '  StringIndices :' + JSON.stringify(StringIndices.length))
              })

          }

          Button("getStringIndices({start:1, end:2})")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let StringIndices = GlyphRuns[0].getStringIndices({ start: 1, end: 2 });
              console.info(this.msg = '  StringIndices :' + JSON.stringify(StringIndices.length))
            })

          Button("getStringIndices({start:-1, end:2})")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              try {
                let StringIndices = GlyphRuns[0].getStringIndices({ start: -1, end: 2 });
                console.info(this.msg = '  StringIndices :' + JSON.stringify(StringIndices.length))
              } catch (err) {
                console.info(this.msg = '  Failed in Runs.StringIndices : ' + JSON.stringify(err.code));

              }
            })

          Button("getStringIndices({start:0, end:-10})")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              try {
                let StringIndices = GlyphRuns[0].getStringIndices({ start: 0, end: -10 });
                console.info(this.msg = '  StringIndices :' + JSON.stringify(StringIndices.length))
              } catch (err) {
                console.info(this.msg = '  Failed in Runs.StringIndices : ' + JSON.stringify(err.code));
              }
            })

          Button("getStringIndices(null)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let StringIndices = GlyphRuns[0].getStringIndices(null);
              console.info(this.msg = '  StringIndices :' + JSON.stringify(StringIndices))
            })

          Button("getStringIndices(undefined)")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              try {
                let StringIndices = GlyphRuns[0].getStringIndices(undefined);
                console.info(this.msg = '  StringIndices :' + JSON.stringify(StringIndices))
              } catch (err) {
                console.info(this.msg = '  Failed in Runs.StringIndices : ' + JSON.stringify(err));
              }
            })

          Button("getImageBounds")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let ImageBounds = GlyphRuns[0].getImageBounds();
              console.info(this.msg = '  ImageBounds :' + JSON.stringify(ImageBounds))
            })

          Button("getTypographicBounds")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let TypographicBounds = GlyphRuns[0].getTypographicBounds();
              console.info(this.msg = '  TypographicBounds :' + JSON.stringify(TypographicBounds))
            })

          Button("getAdvances set:{ start: 1, end: 2 }")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let Advances = GlyphRuns[0].getAdvances({ start: 1, end: 2 });
              console.info(this.msg = '  Advances :' + JSON.stringify(Advances))
            })

          Button("getAdvances({start:-1, end:2}) = undefined")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let Advances = GlyphRuns[0].getAdvances({ start: -1, end: 2 });
              console.info(this.msg = '  Advances :' + JSON.stringify(Advances))
            })

          Button("getAdvances({start:0, end:-10}) = undefined")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let Advances = GlyphRuns[0].getAdvances({ start: 0, end: -10 });
              console.info(this.msg = '  Advances :' + JSON.stringify(Advances))
            })

          Button("getAdvances(null) = undefined")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let Advances = GlyphRuns[0].getAdvances(null);
              console.info(this.msg = '  Advances :' + JSON.stringify(Advances))
            })

          Button("getAdvances(undefined) = undefined")
            .margin(5).width('80%').height(30)
            .onClick(() => {
              const lines = this.paragraph.getTextLines();
              const GlyphRuns = lines[0].getGlyphRuns();
              if (GlyphRuns.length === 0) {
                console.error(this.msg + " no text Runs");
                return;
              }
              let Advances = GlyphRuns[0].getAdvances(undefined);
              console.info(this.msg = '  Advances :' + JSON.stringify(Advances))
            })
        }
      }
    }
  }
}

