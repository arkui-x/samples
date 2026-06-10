import { drawing, text } from '@kit.ArkGraphics2D'
import { image } from '@kit.ImageKit'
import { display, router } from '@kit.ArkUI'
import { TitleBar } from './title';

// ============  全局常量  ============
const MULTI_LANG_TEXT: Record<string, string> = {
  "en": 'This Is AVery Long English Word Without Any Space 中文长文本测试断行规则验证 ',
  "ko": '한 국어는개의음절을활용합니 다안녕하세요,만나서 반갑습니다!',
  "ja": '日 本の四季は非常に美しく、多くの人々を魅了しています。',
  "my": 'မြန်မာစာသည်-ြာဟ္မီအက္ခရာမှဆင်းသက်လာပြီး၁၂၃၄-ပါဝင်သည်။',
  "bo": 'བོད་ནང་- ༡༢༣༤- ཡོད་པས།- ཕྱག་ཞུ་བ་དང-་ དགའ་བསུ་ཞུས་ཏེ།',
  "ar": 'اللغة العربية -تُكتب من -اليمين -إلى اليسار، -وتُستخدم -في ١٢٣٤- دولة.',
  "mn": 'ᠮᠣᠩᠭᠣᠯ- ᠪᠢᠴᠢᠭ ᠢᠨ- ᠲᠣᠯᠢ- ᠪᠣᠯ- ᠑᠒᠓᠔- ᠪᠠᠢᠨ᠎ᠠ ᠠᠭᠤᠯᠬᠤ ᠪᠣᠯᠠᠢ᠃',
  "ze": '中文English123©#     ',
};

interface FontInfo {
  name: string;
  file: string;
}


const LANG_FONT_MAP: Record<string, FontInfo> = {
  "en": { name: 'HarmonyOS_Sans_SC1', file: "HarmonyOS_Sans_SC_Light.ttf" },
  "ko": { name: 'HarmonyOS_Sans_SC_Light2', file: "NotoSansKR-Regular.otf" },
  "ja": { name: 'HarmonyOS_Sans_SC_Light3', file: "HarmonyOS_Sans_SC_Light.ttf" },
  "my": { name: 'NotoSansMyanmar', file: "NotoSansMyanmar-Regular.ttf" },
  "bo": { name: 'NotoSansTibetan', file: "NotoSansTibetan-Regular.ttf" },
  "ar": { name: 'NotoSansArabic', file: "NotoNaskhArabic-Regular.ttf" },
  "mn": { name: 'NotoSansMongolian', file: "NotoSansMongolian-Regular.ttf" },
  "ze": { name: 'HarmonyOS_Sans_SC_Light4', file: "HarmonyOS_Sans_SC_Light.ttf" },
};



// ============  页面入口  ============
@Entry
@Component
export struct Index {
  private fontCollection: text.FontCollection = new text.FontCollection()
  private fontFamilies: Array<string> = ["HarmonyOS_Sans_SC_Light"]
  @State pixelMap?: PixelMap = undefined
  @State paragraph?: text.Paragraph = undefined
  @State textContent: string = MULTI_LANG_TEXT.en; // 当前显示的文本
  @State currentLang: string = 'en'; // 当前语种 key  // 所有可变属性 → 状态变量
  @State fontSize: number = 20
  @State heightScale: number = 0
  @State wordSpacing: number = 0
  @State letterSpacing: number = 0
  @State lineHeightMaximum: number = 0
  @State lineHeightMinimum: number = 0
  @State halfLeading: boolean = false
  @State baselineShift: number = 0
  @State verticalAlign: text.TextVerticalAlign = text.TextVerticalAlign.CENTER
  @State fontWeight: text.FontWeight = text.FontWeight.W100
  @State autoSpace: boolean = false
  @State wordBreak: text.WordBreak = text.WordBreak.BREAK_WORD
  @State heightOnly: boolean = false
  @State fontStyle: text.FontStyle = text.FontStyle.NORMAL
  @State fontWidth: text.FontWidth = text.FontWidth.NORMAL
  @State ellipsisMode: text.EllipsisMode = text.EllipsisMode.END
  @State badgeType: text.TextBadgeType = text.TextBadgeType.TEXT_BADGE_NONE
  @State breakStrategy: text.BreakStrategy = text.BreakStrategy.GREEDY
  @State textHeightBehavior: text.TextHeightBehavior = text.TextHeightBehavior.ALL
  @State trailingSpaceOptimized: boolean = false
  @State maxLines: number = 1e9
  @State lineSpacing: number = 0
  @State textDirection: text.TextDirection = text.TextDirection.LTR
  @State align1: text.TextAlign = text.TextAlign.START
  @State useBgRect: boolean = false
  @State enabled1: boolean = false
  @State textDecoration: text.TextDecorationType = text.TextDecorationType.UNDERLINE
  @State decorationStyle: text.TextDecorationStyle = text.TextDecorationStyle.SOLID
  @State decorationThicknessScale: number = 1
  @State baseline: text.TextBaseline = text.TextBaseline.ALPHABETIC

  private screenDensity: number = display.getDefaultDisplaySync().densityPixels;

  // 固定像素值转换（实际显示像素 = 设计像素 / 屏幕密度）
  private px2vp(px: number): number {
    return px / this.screenDensity;
  }
  // 生命周期：创建 PixelMap + 初始段落
  aboutToAppear(): void {
    this.fontCollection.loadFontSync('HarmonyOS_Sans_SC_Light',
      $rawfile("HarmonyOS_Sans_SC_Light.ttf"));
    this.createPixelMap()
    this.rebuildParagraph() // 初始构建
  }

  aboutToDisappear() {
    Object.values(LANG_FONT_MAP).forEach((fontInfo: FontInfo) => {
      try {
        this.fontCollection.unloadFontSync(fontInfo.name)
      } catch (_err) {
      }
    })
    try {
      this.fontCollection.unloadFontSync("HarmonyOS_Sans_SC_Light")
    } catch (_err) {
    }
  }

  // 创建画板
  private createPixelMap(): void {
    const color: ArrayBuffer = new ArrayBuffer(160000);
    let opts: image.InitializationOptions =
      { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
    this.pixelMap = image.createPixelMapSync(color, opts);
  }

  // 根据当前状态重新构建段落
  private rebuildParagraph(): void {
    this.createPixelMap()

    const liveDecoration: text.Decoration = {
      textDecoration: this.textDecoration,
      color: {
        alpha: 255,
        red: 0,
        green: 0,
        blue: 255
      },
      decorationStyle: this.decorationStyle,
      decorationThicknessScale: this.decorationThicknessScale
    };

    // 1. TextStyle
    const textStyle: text.TextStyle = {
      decoration: liveDecoration,
      color: {
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      },
      fontWeight: this.fontWeight,
      fontStyle: this.fontStyle,
      fontSize: this.fontSize,
      letterSpacing: this.letterSpacing,
      wordSpacing: this.wordSpacing,
      heightScale: this.heightScale,
      halfLeading: this.halfLeading,
      heightOnly: this.heightOnly,
      ellipsis: "456",
      ellipsisMode: this.ellipsisMode,
      locale: 'en',
      baselineShift: this.baselineShift,
      badgeType: this.badgeType,
      fontFamilies: this.fontFamilies
    }

    const myStrutStyle1: text.StrutStyle = {
      fontStyle: text.FontStyle.ITALIC,
      fontWeight: text.FontWeight.W900,
      fontWidth: text.FontWidth.EXTRA_CONDENSED,
      fontSize: 24,
      height: 2,
      forceHeight: true,
      leading: 0,
      enabled: this.enabled1,
      heightOverride: true,
      halfLeading: this.halfLeading,
    }

    // 2. ParagraphStyle
    const paraStyle: text.ParagraphStyle = {
      textStyle,
      textDirection: this.textDirection,
      align: this.align1,
      wordBreak: this.wordBreak,
      maxLines: this.maxLines, // 不限行
      breakStrategy: this.breakStrategy,
      strutStyle: myStrutStyle1,
      textHeightBehavior: this.textHeightBehavior, //设置heightOnly为true，设置heightScale值，再使用
      trailingSpaceOptimized: this.trailingSpaceOptimized, //开始加载的页面末尾会显示空格蓝线上，设置false就不显示
      autoSpace: this.autoSpace,
      verticalAlign: this.verticalAlign, //设置heightOnly为true，设置heightScale值,再使用
    }

    // 3. build + layout
    const builder = new text.ParagraphBuilder(paraStyle, this.fontCollection)
    builder.addText(this.textContent)
    this.paragraph = builder.build()
    this.paragraph.layoutSync(180)
    this.draw()
  }

  // 绘制到 PixelMap
  private draw(): void {
    if (!this.pixelMap || !this.paragraph) {
      return
    }
    const canvas = new drawing.Canvas(this.pixelMap)
    canvas.clear(0xFFFFFFFF) // 清底
    this.paragraph.paint(canvas, 10, 10)
  }

  @Builder
  groupTitle(title: string) {
    Text(title)
      .fontSize(14)
      .fontColor('#FF666666')
      .width('100%')
      .padding({ top: 8, bottom: 4 })
  }

  // UI
  build() {
    Column({ space: 10 }) {
      Scroll() {
        Column() {
          TitleBar()

          // 1. 实时预览区
          Image(this.pixelMap)
            .width('100%')
            .border({ width: 1, color: Color.Gray })
            .margin({ top: 10 })

          Row() {
            // 3. 一键应用/刷新
            Button('应用 / 刷新属性')
              .width('40%')
              .onClick(() => {
                this.rebuildParagraph()
              })
            Button('测试其他属性')
              .width('40%')
              .onClick(() => {
                router.pushUrl({ url: 'pages/common2' });
              })
          }.padding(4)

          Text('设置语种：').fontSize(12)
          Select([
            { value: '中英文' }, { value: '韩文' }, { value: '日文' },
            { value: '缅甸文' }, { value: '藏文' }, { value: '阿拉伯文' }, { value: '蒙文' }, { value: '混合 ' }
          ]).fontColor(Color.Blue).width('40%')
            .selected(['en', 'ko', 'ja', 'my', 'bo', 'ar', 'mn', 'ze'].indexOf(this.currentLang))
            .onSelect((i, t) => {
              const map = ['en', 'ko', 'ja', 'my', 'bo', 'ar', 'mn', 'ze'];
              const newLang = map[i];
              if (newLang === this.currentLang) {
                return;
              }

              this.currentLang = newLang;
              this.textContent = MULTI_LANG_TEXT[this.currentLang];
              const fontInfo = LANG_FONT_MAP[this.currentLang];
              try {
                this.fontCollection.unloadFontSync(this.fontFamilies[0]);
                this.fontCollection.loadFontSync(fontInfo.name, $rawfile(fontInfo.file));
                this.fontFamilies = [fontInfo.name];
                console.info(`切换语言: ${this.currentLang}, 加载字体: ${fontInfo.name}, 文件: ${fontInfo.file}`);
              } catch (err) {
                console.error(`字体加载失败: ${err.message}`);
                this.fontFamilies = ['HarmonyOS_Sans_SC_Light'];
              }
              this.rebuildParagraph();
            })

          GridRow({ columns: { xs: 2, sm: 3, md: 3 }, gutter: 10 }) {
            // ====== TextStyle 组 ======
            GridCol({ span: { xs: 2, sm: 3, md: 3 } }) {
              this.groupTitle('TextStyle:')
            }

            GridCol({ span: { xs: 2, sm: 3, md: 3 } }) {
              Divider().margin({ top: 8, bottom: 4 })
              this.groupTitle('decoration:')
            }

            GridCol({ span: 1 }) {
              Column({ space: 1 }) {
                Text('textDecoration:').fontSize(12)
                Select([
                  { value: 'NONE' },
                  { value: 'UNDERLINE' },
                  { value: 'OVERLINE' },
                  { value: 'LINE_THROUGH' },
                ])
                  .selected(this.textDecoration === 0 ? 0 :
                    this.textDecoration === 1 ? 1 :
                      this.textDecoration === 2 ? 2 : 3)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'NONE':
                        this.textDecoration = text.TextDecorationType.NONE
                        break
                      case 'UNDERLINE':
                        this.textDecoration = text.TextDecorationType.UNDERLINE
                        break
                      case 'OVERLINE':
                        this.textDecoration = text.TextDecorationType.OVERLINE
                        break
                      case 'LINE_THROUGH':
                        this.textDecoration = text.TextDecorationType.LINE_THROUGH
                        break
                    }
                  })

              }.padding(4)
            }

            GridCol({ span: 1 }) {
              Column({ space: 1 }) {
                Text('decorationStyle:').fontSize(12)
                Select([
                  { value: 'SOLID' },
                  { value: 'DOUBLE' },
                  { value: 'DOTTED' },
                  { value: 'DASHED' },
                  { value: 'WAVY' },
                ])
                  .selected(this.decorationStyle === 0 ? 0 :
                    this.decorationStyle === 1 ? 1 :
                      this.decorationStyle === 2 ? 2 :
                        this.decorationStyle === 3 ? 3 : 4)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'SOLID':
                        this.decorationStyle = text.TextDecorationStyle.SOLID
                        break
                      case 'DOUBLE':
                        this.decorationStyle = text.TextDecorationStyle.DOUBLE
                        break
                      case 'DOTTED':
                        this.decorationStyle = text.TextDecorationStyle.DOTTED
                        break
                      case 'DASHED':
                        this.decorationStyle = text.TextDecorationStyle.DASHED
                        break
                      case 'WAVY':
                        this.decorationStyle = text.TextDecorationStyle.WAVY
                        break
                    }
                  })
              }.padding(4)
            }

            GridCol({ span: 1 }) {
              Column({ space: 1 }) {
                Text('decorationThicknessScale:').fontSize(12)
                Select([
                  { value: '1' },
                  { value: '2' },
                ])
                  .selected(this.decorationThicknessScale === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '1':
                        this.decorationThicknessScale = 1
                        break
                      case '2':
                        this.decorationThicknessScale = 2
                        break
                    }
                  })
              }.padding(4)
            }

            GridCol({ span: { xs: 2, sm: 3, md: 3 } }) {
              Divider().margin({ top: 8, bottom: 4 })
            }

            GridCol({ span: 1 }) { // 每块占 1 列
              Column({ space: 4 }) {
                Text('fontSize:').fontSize(12)
                Select([
                  { value: '5' },
                  { value: '40' },
                ])
                  .selected(this.fontSize === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '5':
                        this.fontSize = 5
                        break
                      case '40':
                        this.fontSize = 40
                        break
                    }
                  })

                Text('letterSpacing:').fontSize(12)
                Select([
                  { value: '0' },
                  { value: '30' },
                ])
                  .selected(this.letterSpacing === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '0':
                        this.letterSpacing = 0
                        break
                      case '30':
                        this.letterSpacing = 30
                        break
                    }
                  })

                Text('wordSpacing:').fontSize(12)
                Select([
                  { value: '0' },
                  { value: '30' },
                ])
                  .selected(this.wordSpacing === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '0':
                        this.wordSpacing = 0
                        break
                      case '30':
                        this.wordSpacing = 30
                        break
                    }
                  })

                Text('baselineShift:').fontSize(12)
                Select([
                  { value: '0' },
                  { value: '10' },
                ])
                  .selected(this.baselineShift === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '0':
                        this.baselineShift = 0
                        break
                      case '10':
                        this.baselineShift = 10
                        break
                    }
                  })

              }.padding(4)
            }

            GridCol({ span: 1 }) {
              Column({ space: 4 }) {
                Text('ellipsisMode:').fontSize(12)
                Select([
                  { value: 'START' },
                  { value: 'MIDDLE' },
                  { value: 'END' },
                ])
                  .selected(this.ellipsisMode === 0 ? 0 :
                    this.ellipsisMode === 1 ? 1 : 2)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'START':
                        this.ellipsisMode = text.EllipsisMode.START
                        break
                      case 'MIDDLE':
                        this.ellipsisMode = text.EllipsisMode.MIDDLE
                        break
                      case 'END':
                        this.ellipsisMode = text.EllipsisMode.END
                        break
                    }
                  })

                Text('badgeType:').fontSize(12)
                Select([
                  { value: 'TEXT_BADGE_NONE' },
                  { value: 'TEXT_SUPERSCRIPT' },
                  { value: 'TEXT_SUBSCRIPT' },
                ])
                  .selected(this.badgeType === 0 ? 0 :
                    this.badgeType === 1 ? 1 : 2)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'TEXT_BADGE_NONE':
                        this.badgeType = text.TextBadgeType.TEXT_BADGE_NONE
                        break
                      case 'TEXT_SUPERSCRIPT':
                        this.badgeType = text.TextBadgeType.TEXT_SUPERSCRIPT
                        break
                      case 'TEXT_SUBSCRIPT':
                        this.badgeType = text.TextBadgeType.TEXT_SUBSCRIPT
                        break
                    }
                  })


                Text('fontWeight:').fontSize(12)
                Select([
                  { value: 'W100' },
                  { value: 'W200' },
                  { value: 'W300' },
                  { value: 'W400' },
                  { value: 'W500' },
                  { value: 'W600' },
                  { value: 'W700' },
                  { value: 'W800' },
                  { value: 'W900' },
                ])
                  .selected(this.fontWeight === 0 ? 0 :
                    this.fontWeight === 1 ? 1 :
                      this.fontWeight === 2 ? 2 :
                        this.fontWeight === 3 ? 3 :
                          this.fontWeight === 4 ? 4 :
                            this.fontWeight === 5 ? 5 :
                              this.fontWeight === 6 ? 6 :
                                this.fontWeight === 7 ? 7 : 8
                  )

                  .onSelect((v, t) => {
                    switch (t) {
                      case 'W100':
                        this.fontWeight = text.FontWeight.W100
                        break
                      case 'W200':
                        this.fontWeight = text.FontWeight.W200
                        break
                      case 'W300':
                        this.fontWeight = text.FontWeight.W300
                        break
                      case 'W400':
                        this.fontWeight = text.FontWeight.W400
                        break
                      case 'W500':
                        this.fontWeight = text.FontWeight.W500
                        break
                      case 'W600':
                        this.fontWeight = text.FontWeight.W600
                        break
                      case 'W700':
                        this.fontWeight = text.FontWeight.W700
                        break
                      case 'W800':
                        this.fontWeight = text.FontWeight.W800
                        break
                      case 'W900':
                        this.fontWeight = text.FontWeight.W900
                        break
                    }
                  })

                Text('fontStyle:').fontSize(12)
                Select([
                  { value: 'NORMAL' },
                  { value: 'ITALIC' },
                  { value: 'OBLIQUE' },
                ])
                  .selected(this.fontStyle === 0 ? 0 :
                    this.fontStyle === 1 ? 1 : 2)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'NORMAL':
                        this.fontStyle = text.FontStyle.NORMAL
                        break
                      case 'ITALIC':
                        this.fontStyle = text.FontStyle.ITALIC
                        break
                      case 'OBLIQUE':
                        this.fontStyle = text.FontStyle.OBLIQUE
                        break
                    }
                  })
              }.padding(4)
            }


            GridCol({ span: 1 }) {
              Column({ space: 4 }) {
                Text('heightScale:').fontSize(12)
                Select([
                  { value: '0' },
                  { value: '2' },
                ])
                  .selected(this.heightScale === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '0':
                        this.heightScale = 0
                        break
                      case '2':
                        this.heightScale = 2
                        break
                    }
                  })

                Text('heightOnly:').fontSize(12)
                Button((this.heightOnly ? 'true' : 'false'))
                  .fontSize(12)
                  .backgroundColor('#FFD3D3D3')
                  .onClick(() => this.heightOnly = !this.heightOnly)

                Text('halfLeading:').fontSize(12)
                Button((this.halfLeading ? 'true' : 'false'))
                  .fontSize(12)
                  .backgroundColor('#FFD3D3D3')
                  .onClick(() => this.halfLeading = !this.halfLeading)
              }.padding(4)
            }

            // ====== ParagraphStyle 组 ======

            GridCol({ span: { xs: 2, sm: 3, md: 3 } }) {
              Divider().margin({ top: 8, bottom: 4 })
              this.groupTitle('ParagraphStyle:')
            }

            GridCol({ span: 1 }) {
              Column({ space: 4 }) {
                Text('breakStrategy:').fontSize(12)
                Select([
                  { value: 'GREEDY' },
                  { value: 'HIGH_QUALITY' },
                  { value: 'BALANCED' },
                ])
                  .selected(this.breakStrategy === 0 ? 0 :
                    this.breakStrategy === 1 ? 1 : 2)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'GREEDY':
                        this.breakStrategy = text.BreakStrategy.GREEDY
                        break
                      case 'HIGH_QUALITY':
                        this.breakStrategy = text.BreakStrategy.HIGH_QUALITY
                        break
                      case 'BALANCED':
                        this.breakStrategy = text.BreakStrategy.BALANCED
                        break
                    }
                  }).padding(4)

                Text('textHeightBehavior:').fontSize(12)
                Select([
                  { value: 'ALL' },
                  { value: 'DISABLE_FIRST_ASCENT' },
                  { value: 'DISABLE_LAST_ASCENT' },
                  { value: 'DISABLE_ALL' },
                ]).selected(this.textHeightBehavior === 0 ? 0 :
                  this.textHeightBehavior === 1 ? 1 :
                    this.textHeightBehavior === 2 ? 2 : 3)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'ALL':
                        this.textHeightBehavior = text.TextHeightBehavior.ALL
                        break
                      case 'DISABLE_FIRST_ASCENT':
                        this.textHeightBehavior = text.TextHeightBehavior.DISABLE_FIRST_ASCENT
                        break
                      case 'DISABLE_LAST_ASCENT':
                        this.textHeightBehavior = text.TextHeightBehavior.DISABLE_LAST_ASCENT
                        break
                      case 'DISABLE_ALL':
                        this.textHeightBehavior = text.TextHeightBehavior.DISABLE_ALL
                        break
                    }
                  })

                Text('textDirection:').fontSize(12)
                Select([
                  { value: 'RTL' },
                  { value: 'LTR' },
                ]).selected(this.textDirection === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'RTL':
                        this.textDirection = text.TextDirection.RTL;
                        break
                      case 'LTR':
                        this.textDirection = text.TextDirection.LTR;
                        break
                    }
                  })

                Text('wordBreak:').fontSize(12)
                Select([
                  { value: 'NORMAL' },
                  { value: 'BREAK_ALL' },
                  { value: 'BREAK_WORD' },
                  { value: 'BREAK_HYPHEN' }
                ]).selected(this.wordBreak === 0 ? 0 :
                  this.wordBreak === 1 ? 1 : this.wordBreak === 2 ? 2 : 3)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'NORMAL':
                        this.wordBreak = text.WordBreak.NORMAL;
                        break
                      case 'BREAK_ALL':
                        this.wordBreak = text.WordBreak.BREAK_ALL;
                        break
                      case 'BREAK_WORD':
                        this.wordBreak = text.WordBreak.BREAK_WORD;
                        break
                      case 'BREAK_HYPHEN':
                        this.wordBreak = text.WordBreak.BREAK_HYPHEN;
                        break
                    }
                  }).padding(4)
              }
            }

            GridCol({ span: 1 }) {
              Column({ space: 4 }) {
                Text('verticalAlign:').fontSize(12)
                Select([
                  { value: 'TOP' },
                  { value: 'CENTER' },
                  { value: 'BOTTOM' },
                  { value: 'BASELINE' }
                ]).selected(this.verticalAlign === 0 ? 0 :
                  this.verticalAlign === 1 ? 1 : this.verticalAlign === 2 ? 2 : 3)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'TOP':
                        this.verticalAlign = text.TextVerticalAlign.TOP;
                        break
                      case 'CENTER':
                        this.verticalAlign = text.TextVerticalAlign.CENTER;
                        break
                      case 'BOTTOM':
                        this.verticalAlign = text.TextVerticalAlign.BOTTOM;
                        break
                      case 'BASELINE':
                        this.verticalAlign = text.TextVerticalAlign.BASELINE;
                        break
                    }
                  }).padding(4)

                Text('maxLines:').fontSize(12)
                Select([
                  { value: '1e9' },
                  { value: '1' },
                ])
                  .selected(this.maxLines === 0 ? 0 : 1)
                  .onSelect((v, t) => {
                    switch (t) {
                      case '1e9':
                        this.maxLines = 1e9;
                        break
                      case '1':
                        this.maxLines = 1;
                        break
                    }
                  })

                Text('align:').fontSize(12)
                Select([
                  { value: 'LEFT' },
                  { value: 'RIGHT' },
                  { value: 'CENTER' },
                  { value: 'JUSTIFY' },
                  { value: 'START' },
                  { value: 'END' },
                ]).selected(this.align1 === 0 ? 0 :
                  this.align1 === 1 ? 1 :
                    this.align1 === 2 ? 2 :
                      this.align1 === 3 ? 3 :
                        this.align1 === 4 ? 4 : 5)
                  .onSelect((v, t) => {
                    switch (t) {
                      case 'LEFT':
                        this.align1 = text.TextAlign.LEFT;
                        break
                      case 'RIGHT':
                        this.align1 = text.TextAlign.RIGHT;
                        break
                      case 'CENTER':
                        this.align1 = text.TextAlign.CENTER;
                        break
                      case 'JUSTIFY':
                        this.align1 = text.TextAlign.JUSTIFY;
                        break
                      case 'START':
                        this.align1 = text.TextAlign.START;
                        break
                      case 'END':
                        this.align1 = text.TextAlign.END;
                        break
                    }
                  })
              }
            }

            GridCol({ span: 1 }) {
              Column({ space: 4 }) {

                Text('trailingSpaceOptimized:').fontSize(12)
                Button((this.trailingSpaceOptimized ? 'true' : 'false'))
                  .fontSize(12)
                  .backgroundColor('#FFD3D3D3')
                  .onClick(() => this.trailingSpaceOptimized = !this.trailingSpaceOptimized)

                Text('enabled:').fontSize(12)
                Button((this.enabled1 ? 'true' : 'false'))
                  .fontSize(12)
                  .backgroundColor('#FFD3D3D3')
                  .onClick(() => this.enabled1 = !this.enabled1)

                Text('autoSpace:').fontSize(12)
                Button((this.autoSpace ? 'true' : 'false'))
                  .fontSize(12)
                  .backgroundColor('#FFD3D3D3')
                  .onClick(() => this.autoSpace = !this.autoSpace)
              }
            }
          }.padding({ left: 10, right: 10 })
        }
      }
    }
    .height('100%')
    .padding(10)
  }
}