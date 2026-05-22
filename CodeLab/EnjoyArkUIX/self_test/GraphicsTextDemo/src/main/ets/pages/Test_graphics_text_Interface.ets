/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { drawing, text } from '@kit.ArkGraphics2D'
import { TitleBar } from './title';
import { BusinessError } from '@kit.BasicServicesKit';
import deviceInfo from '@ohos.deviceInfo';
import { router } from '@kit.ArkUI';

let osFullNameInfo: string = deviceInfo.osFullName;
console.info('the deviceInfo osFullName is :' + osFullNameInfo);
let platform = osFullNameInfo.split(' ')[0].split('-')[0];


@Entry
@Component
struct TestParagraphBuilder {
  @State content: string = "默认字体"
  @State pixelmap?: PixelMap = undefined;
  @State msg: string = "Test_Graphics_Text"
  @State osName: string = deviceInfo.osFullName;

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

          Text(this.content)
            .fontFamily("HarmonyOS_Sans_SC")
            .fontColor(Color.Red)

          TextArea({ text: this.msg, })
            .placeholderColor(Color.Grey)
            .placeholderFont({ size: 14, weight: 400 })
            .caretColor(Color.Blue)
            .height('30%')
            .margin(20)
            .fontSize(18)
            .fontColor(Color.Black)
            .borderWidth(2)
            .fontFamily('HarmonyOS_Sans_SC3')


          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证getSystemFontFullNamesByType：')
          Row() {
            Button("ALL")
              .width('22%')
              .onClick(() => {
                this.msg = '';
                let fontType: text.SystemFontType = text.SystemFontType.ALL
                let promise = text.getSystemFontFullNamesByType(fontType)
                promise.then((data) => {
                  console.info(this.msg += ` then font list size: ${data.length}`)
                  data.forEach((fontItem) => {
                    console.info(this.msg += '  getSystemFontFullNamesByType(ALL): ' + fontItem + '\n')
                  })
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
                });
              })

            Button("GENERIC")
              .margin(2).width('22%')
              .onClick(() => {
                this.msg = '';
                let fontType: text.SystemFontType = text.SystemFontType.GENERIC
                let promise = text.getSystemFontFullNamesByType(fontType)
                promise.then((data) => {
                  console.info(this.msg += ` then font list size: ${data.length}`)
                  data.forEach((fontItem) => {
                    console.info(this.msg += ' getSystemFontFullNamesByType(GENERIC): ' + fontItem)
                  })
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
                });
              })

            Button("CUSTOMIZED")
              .margin(2).width('26%')
              .onClick(() => {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                  $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));

                this.msg = '';
                let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
                let promise = text.getSystemFontFullNamesByType(fontType)
                promise.then((data) => {
                  console.info(this.msg = ` then font list size: ${data.length}`)
                  data.forEach((fontItem) => {
                    console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                  })
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
                });
                fontCollection.unloadFontSync("HarmonyOS_Sans_SC")

              })

          }

          Row() {
            Button("undefined")
              .width('33%')
              .onClick(() => {
                this.msg = '';
                let promise = text.getSystemFontFullNamesByType(undefined)
                promise.then((data) => {
                  console.info(this.msg = ` then font list size: ${data.length}`)
                  data.forEach((fontItem) => {
                    console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                  })
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
                });
              })

            Button("null")
              .width('33%')
              .margin(5)
              .onClick(() => {
                this.msg = '';
                let promise = text.getSystemFontFullNamesByType(null)
                promise.then((data) => {
                  console.info(this.msg = ` then font list size: ${data.length}`)
                  data.forEach((fontItem) => {
                    console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                  })
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
                });
              })
          }



          Button("验证获取自定义字体，loadFontSync设置为null")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('HarmonyOS_Sans_SC234',
                null);

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getSystemFontFullNamesByType(fontType)
              promise.then((data) => {
                console.info(this.msg = ` then font list size: ${data.length}`)
                data.forEach((fontItem) => {
                  console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
              });
            })
          Button("验证获取自定义字体，loadFontSync设置为空字符")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('HarmonyOS_Sans_SC1',
                '');

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getSystemFontFullNamesByType(fontType)
              promise.then((data) => {
                console.info(this.msg = ` then font list size: ${data.length}`)
                data.forEach((fontItem) => {
                  console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
              });
            })

          Button("验证获取自定义字体， loadFontSync设置损坏的ttf文件")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('test',
                $rawfile("1.ttf"));

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getSystemFontFullNamesByType(fontType)
              promise.then((data) => {
                console.info(this.msg = ` then font list size: ${data.length}`)
                data.forEach((fontItem) => {
                  console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
              });
            })

          Button("验证获取自定义字体， loadFontSync设置otf文件")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('SmileySans',
                $rawfile("SmileySans-Oblique.otf"));
              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getSystemFontFullNamesByType(fontType)
              promise.then((data) => {
                console.info(this.msg = ` then font list size: ${data.length}`)
                data.forEach((fontItem) => {
                  console.info(this.msg += ' getSystemFontFullNamesByType(CUSTOMIZED): ' + fontItem)
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get font fullNames by type, error: ${JSON.stringify(error)}`);
              });

              fontCollection.unloadFontSync("SmileySans")

            })

          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证getFontDescriptorByFullName：')


          Row() {
            Button("ALL")
              .width('22%')
              .onClick(() => {
                if (platform == "Android" || platform == "OpenHarmony") {
                  this.msg = '';
                  let fontType: text.SystemFontType = text.SystemFontType.ALL
                  let promise = text.getFontDescriptorByFullName("Noto Sans Marchen Regular", fontType)
                  promise.then((fontdecriptor) => {
                    console.log(this.msg += ' getFontDescriptorByFullName(ALL): ' + JSON.stringify(fontdecriptor))
                  }).catch((error: BusinessError) => {
                    console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                  });
                } else if (platform == "iOS") {
                  this.msg = '';
                  let fontType: text.SystemFontType = text.SystemFontType.ALL
                  let promise = text.getFontDescriptorByFullName("American Typewriter", fontType)
                  promise.then((fontdecriptor) => {
                    console.log(this.msg += ' getFontDescriptorByFullName(ALL): ' + JSON.stringify(fontdecriptor))
                  }).catch((error: BusinessError) => {
                    console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                  });
                }
              })

            Button("GENERIC")
              .margin(2).width('22%')
              .onClick(() => {
                if (platform == "Android" || platform == "OpenHarmony") {
                  this.msg = '';
                  let fontType: text.SystemFontType = text.SystemFontType.GENERIC
                  let promise = text.getFontDescriptorByFullName("Noto Sans Pau Cin Hau Regular", fontType)
                  promise.then((fontdecriptor) => {
                    console.log(this.msg += ' getFontDescriptorByFullName(GENERIC): ' + JSON.stringify(fontdecriptor))
                  }).catch((error: BusinessError) => {
                    console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                  });
                } else if (platform == "iOS") {
                  this.msg = '';
                  let fontType: text.SystemFontType = text.SystemFontType.GENERIC
                  let promise = text.getFontDescriptorByFullName("American Typewriter", fontType)
                  promise.then((fontdecriptor) => {
                    console.log(this.msg += ' getFontDescriptorByFullName(GENERIC): ' + JSON.stringify(fontdecriptor))
                  }).catch((error: BusinessError) => {
                    console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                  });
                }
              })

            Button("CUSTOMIZED")
              .margin(2).width('26%')
              .onClick(() => {
                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                  $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));

                this.msg = '';
                let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
                let promise = text.getFontDescriptorByFullName("HarmonyOS_Sans_SC", fontType)
                promise.then((fontdecriptor) => {
                  console.log(this.msg += ' getFontDescriptorByFullName(CUSTOMIZED): ' + JSON.stringify(fontdecriptor))
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                });
              })
          }

          Row() {
            Button("null")
              .width('33%')
              .onClick(() => {
                this.msg = '';
                let fontType: text.SystemFontType = text.SystemFontType.GENERIC
                let promise = text.getFontDescriptorByFullName(null, fontType)
                promise.then((fontdecriptor) => {
                  console.log(this.msg += ' Succeed in text.getFontDescriptorByFullName  ' +
                  JSON.stringify(fontdecriptor))
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                });
              })

            Button("undefined")
              .width('33%')
              .margin(5)
              .onClick(() => {
                this.msg = '';
                let fontType: text.SystemFontType = text.SystemFontType.GENERIC
                let promise = text.getFontDescriptorByFullName(undefined, fontType)
                promise.then((fontdecriptor) => {
                  console.log(this.msg += ' Succeed in text.getFontDescriptorByFullName  ' +
                  JSON.stringify(fontdecriptor))
                }).catch((error: BusinessError) => {
                  console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
                });
              })

          }
          Button("验证获取自定义字体，loadFontSync设置为null")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('HarmonyOS_Sans_SC234',
                null);

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getFontDescriptorByFullName("HarmonyOS_Sans_SC234", fontType)
              promise.then((fontdecriptor) => {
                console.log(this.msg += ' getFontDescriptorByFullName(CUSTOMIZED): ' + JSON.stringify(fontdecriptor))
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
              });
            })
          Button("验证获取自定义字体，loadFontSync设置为空字符")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('HarmonyOS_Sans_SC1',
                '');

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getFontDescriptorByFullName("HarmonyOS_Sans_SC1", fontType)
              promise.then((fontdecriptor) => {
                console.log(this.msg += ' getFontDescriptorByFullName(CUSTOMIZED): ' + JSON.stringify(fontdecriptor))
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
              });
            })

          Button("验证获取自定义字体， loadFontSync设置损坏的ttf文件")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('test',
                $rawfile("1.ttf"));

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getFontDescriptorByFullName("test", fontType)
              promise.then((fontdecriptor) => {
                console.log(this.msg += ' getFontDescriptorByFullName(CUSTOMIZED): ' + JSON.stringify(fontdecriptor))
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
              });
            })

          Button("验证获取自定义字体， loadFontSync设置otf文件")
            .margin(2).width('80%')
            .onClick(() => {
              let fontCollection: text.FontCollection = new text.FontCollection();
              fontCollection.loadFontSync('SmileySans',
                $rawfile("SmileySans-Oblique.otf"));

              this.msg = '';
              let fontType: text.SystemFontType = text.SystemFontType.CUSTOMIZED
              let promise = text.getFontDescriptorByFullName("SmileySans", fontType)
              promise.then((fontdecriptor) => {
                console.log(this.msg += ' getFontDescriptorByFullName(CUSTOMIZED): ' + JSON.stringify(fontdecriptor))
              }).catch((error: BusinessError) => {
                console.error(this.msg += ` Failed to get fontDescriptor by fullName, error: ${JSON.stringify(error)}`);
              });
              fontCollection.unloadFontSync("SmileySans")
            })


          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证matchFontDescriptors：')
            Button('验证matchFontDescriptors')
              .width('40%')
              .onClick(() => {
                router.pushUrl({ url: 'pages/test1' });
              })


          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证setTextHighContrast高对比度：')
          Row() {
            Button("开启高对比度")
              .width('40%')
              .onClick(() => {
                text.setTextHighContrast(text.TextHighContrast.TEXT_APP_ENABLE_HIGH_CONTRAST)

                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                  $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));
              })

            Button("关闭高对比度")
              .margin(5).width('40%')
              .onClick(() => {
                text.setTextHighContrast(text.TextHighContrast.TEXT_APP_DISABLE_HIGH_CONTRAST)

                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                  $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));
              })
          }

          Divider().margin({ top: 8, bottom: 4 })
          this.groupTitle('验证setTextUndefinedGlyphDisplay设置字符映射到.notdef（未定义）字形：')
          Row() {
            Button("未定义字形显示豆腐")
              .width('40%')
              .visibility(this.osName.startsWith('iOS') ? Visibility.Hidden : Visibility.Visible)
              .onClick(() => {
                text.setTextUndefinedGlyphDisplay(text.TextUndefinedGlyphDisplay.USE_TOFU)
                this.content =
                  // '\uE000\u12000\u00A0\u0309a\u200B\u2764\u01C2\u202Eabc\u202D';
                  "\uE000 \u12000 \xc0\xa0 Testing combination: ả (should be an 'a' with an incorrect combining mark)"

                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                  $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));
              })

            Button("未定义字形显示默认空格")
              .margin(5).width('40%')
              .visibility(this.osName.startsWith('iOS') ? Visibility.Hidden : Visibility.Visible)
              .onClick(() => {
                text.setTextUndefinedGlyphDisplay(text.TextUndefinedGlyphDisplay.USE_DEFAULT)
                this.content =
                  // '\uE000\u12000\u00A0\u0309a\u200B\u2764\u01C2\u202Eabc\u202D';
                  "\uE000 \u12000 \xc0\xa0 Testing combination: ả (should be an 'a' with an incorrect combining mark)"

                let fontCollection = text.FontCollection.getGlobalInstance();
                fontCollection.loadFontSync('HarmonyOS_Sans_SC',
                  $rawfile("HarmonyOS Sans/HarmonyOS_Sans_SC/HarmonyOS_Sans_SC_Bold.ttf"));
              })

          }

          Divider().margin({ top: 8, bottom: 4 })

        }
      }
    }
  }
}