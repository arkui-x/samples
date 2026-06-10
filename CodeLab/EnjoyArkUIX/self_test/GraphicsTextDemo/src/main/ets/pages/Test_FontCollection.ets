import { drawing, text } from '@kit.ArkGraphics2D'
import { TitleBar } from './title';
import deviceInfo from '@ohos.deviceInfo';

let osFullNameInfo: string = deviceInfo.osFullName;
console.info('the deviceInfo osFullName is :' + osFullNameInfo);
let platform = osFullNameInfo.split(' ')[0].split('-')[0];

@Entry
@Component
struct FontCollectionTest {
  @State msg: string = "Test_Graphics_Text"
  @State ret: string = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Accusantium asperiores"
  @State content: string = "默认字体"
  @State pixelmap?: PixelMap = undefined;


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

          Text('FontCollection：')
          Text(this.ret)
            .fontFamily(this.content)
            .fontColor(Color.Blue)

          Text(this.msg)
            .fontSize(20)
            .margin(20)
            .fontWeight(FontWeight.Bold)
            .border({ width: 1, color: Color.Gray })

          Button("Test getGlobalInstance")
            .margin(5).width('80%')
            .onClick(() => {
              try {
                let fontCollection = text.FontCollection.getGlobalInstance();
                console.info(this.msg = ` Succeed in text.FontCollection.getGlobalInstance :${fontCollection}`);
              } catch (err) {
                console.info(this.msg = ' Failed in fontCollection.loadFontSync.    Cause: ' + JSON.stringify(err));
              }
            })

          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证loadFontSync，unloadFontSync接口')

          Button("Test loadFontSync:安装rawfile方式加载的字体")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));
              this.content = "HarmonyOS_Sans_SC"
            })

          Button("Test unloadFontSync：卸载rawfile方式加载的字体")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.unloadFontSync("HarmonyOS_Sans_SC")
            })

          Button("Test loadFontSync：加载系统自带字体")
            .margin(5).width('80%')
            .onClick(() => {
              if (platform == "Android") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('qq', 'file:///system/fonts/DancingScript-Regular.ttf');
                this.content = "qq"
              } else if (platform == "iOS") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('ww', 'file:///System/Library/Fonts/AppFonts/Noteworthy.ttc');
                this.content = "ww"
              } else if (platform == "OpenHarmony") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('mm', 'file:///system/fonts/HarmonyOS_Sans_Italic.ttf');
                this.content = "mm"
              }
            })


          Button("Test unloadFontSync：卸载系统自带字体")
            .margin(5).width('80%')
            .onClick(() => {
              if (platform == "Android") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.unloadFontSync("qq")
              } else if (platform == "iOS") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.unloadFontSync("ww")
              } else if (platform == "OpenHarmony") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.unloadFontSync("mm")
              }
            })


          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证loadFont，unloadFont接口')

          Button("Test loadFont：安装rawfile方式加载的字体")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.loadFont('HarmonyOS_Sans_SC',
                $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf")).then((data) => {
                console.info(this.msg + ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
                this.content = "HarmonyOS_Sans_SC"
              }).catch((error: Error) => {
                console.error(this.msg +
                  ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })

          Button("Test unloadFont：卸载rawfile方式加载的字体")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.unloadFont("HarmonyOS_Sans_SC").then((data) => {
              }).catch((error: Error) => {
                console.error(`  Failed to do unloadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })

          Button("Test loadFont：安装rawfile方式加载otf文件字体")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.loadFont('ee',
                $rawfile("SmileySans-Oblique.otf")).then((data) => {
                console.info(this.msg + ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
                this.content = "ee"
              }).catch((error: Error) => {
                console.error(this.msg +
                  ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })
          Button("Test unloadFont：卸载rawfile方式加载otf文件字体")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.unloadFont("ee").then((data) => {
              }).catch((error: Error) => {
                console.error(` Failed to do unloadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })

          Button("Test loadFont：安装系统自带字体")
            .margin(5).width('80%')
            .onClick(() => {
              if (platform == "Android") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFont('dd', 'file:///system/fonts/DancingScript-Regular.ttf').then((data) => {
                  console.info(this.msg + ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
                  this.content = "dd"
                }).catch((error: Error) => {
                  console.error(this.msg +
                    ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              } else if (platform == "iOS") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFont('rr', 'file:///System/Library/Fonts/AppFonts/Noteworthy.ttc').then((data) => {
                  console.info(this.msg + ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
                  this.content = "rr"
                }).catch((error: Error) => {
                  console.error(this.msg +
                    ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              } else if (platform == "OpenHarmony") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFont('gg', 'file:///system/fonts/HarmonyOS_Sans_Italic.ttf').then((data) => {
                  console.info(this.msg + ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
                  this.content = "gg"
                }).catch((error: Error) => {
                  console.error(this.msg +
                    ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              }
            })

          Button("Test unloadFont：卸载系统自带字体")
            .margin(5).width('80%')
            .onClick(() => {
              if (platform == "Android") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.unloadFont("dd").then((data) => {
                }).catch((error: Error) => {
                  console.error(` Failed to do unloadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              } else if (platform == "iOS") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.unloadFont("rr").then((data) => {
                }).catch((error: Error) => {
                  console.error(` Failed to do unloadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              } else if (platform == "OpenHarmony") {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.unloadFont("gg").then((data) => {
                }).catch((error: Error) => {
                  console.error(` Failed to do unloadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
                });
              }
            })

          Button("Test loadFont：加载损坏ttf文件")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.loadFont("sa", $rawfile("1.ttf")).then((data) => {
                console.info(this.msg = ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
                this.content = "sa"
              }).catch((error: Error) => {
                console.error(this.msg =
                  ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })
          Button("Test loadFont：设置参数NULL")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.loadFont(null, null).then((data) => {
                console.info(this.msg = ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
              }).catch((error: Error) => {
                console.error(this.msg =
                  ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })

          Button("Test loadFont：设置参数undefined")
            .margin(5).width('80%')
            .onClick(() => {
              let fontCollection = text.FontCollection.getGlobalInstance();
              fontCollection.loadFont(undefined, undefined).then((data) => {
                console.info(this.msg = ` Succeeded in doing loadFont ${JSON.stringify(data)} `);
              }).catch((error: Error) => {
                console.error(this.msg =
                  ` Failed to do loadFont, error: ${JSON.stringify(error)} message: ${error.message}`);
              });
            })

          Divider().margin({ top: 8, bottom: 4 })

          Button("Test clearCaches")
            .margin(5).width('80%')
            .onClick(() => {
              text.FontCollection.getGlobalInstance().clearCaches();
              this.ret = "清理字体排版缓存成功"
            })
        }
      }
    }
  }
}

