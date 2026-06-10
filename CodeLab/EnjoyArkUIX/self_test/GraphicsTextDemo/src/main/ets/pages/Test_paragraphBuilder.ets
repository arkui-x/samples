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
import { image } from '@kit.ImageKit'
import { TitleBar } from './title';

let fontCollection = text.FontCollection.getGlobalInstance();
fontCollection.loadFontSync('HarmonyOS_Sans_SC3',
  $rawfile("HarmonyOS_Sans_SC_Light.ttf"));
let fontFamilies_symbol: Array<string> = ["HarmonyOS_Sans_SC3", "HM Symbol"];


let textStyleRed: text.TextStyle = {
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  fontSize: 10,
  fontWeight: text.FontWeight.W400

};
let textStyleGreen: text.TextStyle = {
  color: {
    alpha: 255,
    red: 0,
    green: 255,
    blue: 0
  },
  fontSize: 10,
  fontStyle: text.FontStyle.ITALIC,
  fontWeight: text.FontWeight.W200

};
let textStyleBlue: text.TextStyle = {
  color: {
    alpha: 255,
    red: 0,
    green: 0,
    blue: 255
  },
  fontSize: 10,
  fontWeight: text.FontWeight.W600

};
let textStyleYellow: text.TextStyle = {
  color: {
    alpha: 255,
    red: 255,
    green: 255,
    blue: 0
  },
  fontSize: 10,
  fontFamilies: fontFamilies_symbol,
  fontWeight: text.FontWeight.W800
};
let textStyleGray: text.TextStyle = {
  color: {
    alpha: 255,
    red: 128,
    green: 128,
    blue: 128
  },
  fontSize: 10,
  fontWeight: text.FontWeight.W400
};

let paragraphStyle: text.ParagraphStyle = {
  textStyle: textStyleRed,
};

let paragraphBuilder = new text.ParagraphBuilder(paragraphStyle, fontCollection);
// 添加文本字符串

paragraphBuilder.addText("红色文本\n"); // red
paragraphBuilder.pushStyle(textStyleGreen);
paragraphBuilder.addText("绿色文本\n"); // green

paragraphBuilder.pushStyle(textStyleYellow);
paragraphBuilder.addText("黄色文本\n"); // yellow

paragraphBuilder.pushStyle(textStyleBlue);
paragraphBuilder.addText("蓝色文本\n"); // blue


paragraphBuilder.pushStyle(textStyleGray);
paragraphBuilder.addText("灰色文本\n"); // gray

paragraphBuilder.popStyle();
paragraphBuilder.addText("蓝色文本\n"); // blue

paragraphBuilder.popStyle();
let myPlaceholderSpan: text.PlaceholderSpan = {
  width: 10,
  height: 20,
  align: text.PlaceholderAlignment.ABOVE_BASELINE,
  baseline: text.TextBaseline.IDEOGRAPHIC,
  baselineOffset: 5
};

paragraphBuilder.addPlaceholder(myPlaceholderSpan)
paragraphBuilder.addSymbol(0xF03DA);
paragraphBuilder.addText("黄色文本\n"); // yellow


let myPlaceholderSpan1: text.PlaceholderSpan = {
  width: 10,
  height: 20,
  align: text.PlaceholderAlignment.BOTTOM_OF_ROW_BOX,
  baseline: text.TextBaseline.IDEOGRAPHIC,
  baselineOffset: 5
};

paragraphBuilder.addPlaceholder(myPlaceholderSpan1)
paragraphBuilder.addText("测试占位符\n"); // yellow


let myPlaceholderSpan2: text.PlaceholderSpan = {
  width: 10,
  height: 20,
  align: text.PlaceholderAlignment.BELOW_BASELINE,
  baseline: text.TextBaseline.IDEOGRAPHIC,
  baselineOffset: 5
};

paragraphBuilder.addPlaceholder(myPlaceholderSpan2)
paragraphBuilder.addText("测试占位符1\n"); // yellow


let paragraph = paragraphBuilder.build();
console.info('build successed first' + paragraph);

function textFunc(pixelmap: PixelMap) {
  console.info('textFunc begin')
  let canvas = new drawing.Canvas(pixelmap);
  paragraph.paint(canvas, 80, 50);

}

@Entry
@Component
struct TestParagraphBuilder {
  @State content: string = "默认字体"
  @State pixelmap?: PixelMap = undefined;
  fun: Function = textFunc;
  @State msg: string = "Test_Graphics_Text"

  async prepareLayoutPromise() {
    paragraph.layoutSync(200);
  }

  aboutToAppear() {
    this.prepareLayoutPromise();
  }

  aboutToDisappear() {
    fontCollection.unloadFontSync("HarmonyOS_Sans_SC3")
  }
  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar()
          Text('Test paragraphBuilder:')
            .fontSize(20)
            .margin(20)
            .fontWeight(FontWeight.Bold)

          Text(this.msg)
            .width('90%')
            .height('10%')
            .fontSize(20)
            .margin(20)
            .border({ width: 1, color: Color.Gray })
            .fontFamily('HarmonyOS_Sans_SC3')

          Image(this.pixelmap).width('100%').height('50%').border({ width: 1, color: Color.Gray }).margin(10);

          Button("Test paragraphBuilder interface")
            .margin(5).width('50%')
            .onClick(() => {
              const color: ArrayBuffer = new ArrayBuffer(160000);
              let opts: image.InitializationOptions =
                { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
              this.pixelmap = image.createPixelMapSync(color, opts);
              this.fun(this.pixelmap);
            })

          Button("paragraphBuilder:buildLineTypeset")
            .margin(5).width('50%')
            .onClick(() => {
              paragraphBuilder.addText("123456789");
              let lines = paragraphBuilder.buildLineTypeset();
              console.info(this.msg = `  paragraphBuilder buildLineTypeset::${lines}`)
            })

          Button("paragraphBuilder:build")
            .margin(5).width('50%')
            .onClick(() => {
              let paragraph1 = paragraphBuilder.build();
              console.info(this.msg = `  paragraphBuilder build::${paragraph1}`);
            })


        }
      }
    }
  }
}