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
import { display } from '@kit.ArkUI';


// let fontCollection = text.FontCollection.getGlobalInstance();
// fontCollection.loadFontSync('HarmonyOS_Sans_SC3',
//   $rawfile("HarmonyOS_Sans_SC_Light.ttf"));

@Entry
@Component
struct TestParagraphBuilder {
  @State content: string = ""
  @State pixelmap?: PixelMap = undefined;
  @State msg: string = "Test_Graphics_Text"
  @State osName: string = deviceInfo.osFullName;
  @State content1: string = ""
  // aboutToDisappear() {
  //   fontCollection.unloadFontSync("HarmonyOS_Sans_SC3")
  // }
  // 获取屏幕密度，用于计算
  private screenDensity: number = display.getDefaultDisplaySync().densityPixels;

  // 固定像素值转换（实际显示像素 = 设计像素 / 屏幕密度）
  private px2vp(px: number): number {
    return px / this.screenDensity;
  }

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
      Column() {
        TitleBar()

        TextArea({ text: this.msg, })
          .caretColor(Color.Blue)
          .width(this.px2vp(1000))
          .height(this.px2vp(1000))
          .margin(20)
          .fontSize(this.px2vp(40))
          .fontColor(Color.Black)
          .borderWidth(2)
        // .fontFamily('HarmonyOS_Sans_SC3')

        Divider().margin({ top: 8, bottom: 4 })
        this.groupTitle('验证matchFontDescriptors：')
        Row() {
          Button("不设置筛选条件")
            .margin(5).width('40%')
            .onClick(() => {
              this.msg = '';

              let promise = text.matchFontDescriptors({})
              promise.then((data) => {
                data.forEach((item, index) => {
                  console.info(this.msg += ` Font descriptor result: ${JSON.stringify(item)}` + '\n')
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg = ` Failed to match the font descriptor, error: ${JSON.stringify(error)}`);
              });
            })

          Button("设置筛选'Regular'")
            .width('40%')
            .onClick(() => {
              this.msg = '';
              console.info(`Get font descriptor start`)
              let promise = text.matchFontDescriptors({
                weight: text.FontWeight.W400,
                fontSubfamily: "Regular",
              })
              promise.then((data) => {
                data.forEach((item, index) => {
                  console.info(this.msg += ` Font descriptor result: ${JSON.stringify(item)}` + '\n')
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg = ` Failed to match the font descriptor, error: ${JSON.stringify(error)}`);
              });
            })

        }

        Row() {
          Button("null")
            .margin(5).width('40%')
            .onClick(() => {
              this.msg = '';
              console.info(`Get font descriptor start`)
              let promise = text.matchFontDescriptors(null)
              promise.then((data) => {
                data.forEach((item, index) => {
                  console.info(this.msg += ` Font descriptor result: ${JSON.stringify(item)}` + '\n')
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg = ` Failed to match the font descriptor, error: ${JSON.stringify(error)}`);
              });
            })

          Button("undefined")
            .width('40%')
            .onClick(() => {
              this.msg = '';
              console.info(`Get font descriptor start`)
              let promise = text.matchFontDescriptors(undefined)
              promise.then((data) => {
                data.forEach((item, index) => {
                  console.info(this.msg += ` Font descriptor result: ${JSON.stringify(item)}` + '\n')
                })
              }).catch((error: BusinessError) => {
                console.error(this.msg = ` Failed to match the font descriptor, error: ${JSON.stringify(error)}`);
              });
            })
        }
      }

      Divider().margin({ top: 8, bottom: 4 })

    }
  }
}