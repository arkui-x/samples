/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

let myFontFeature: text.FontFeature = {
  name: 'frac',
  value: 900
}

let myFontVariation: text.FontVariation = {
  axis: 'wght',
  value: 900
}

let textTab: text.TextTab = {
  alignment: text.TextAlign.CENTER,
  location: 200,
}

let myTextShadow: text.TextShadow = {
  color: {
    alpha: 255,
    red: 0,
    green: 0,
    blue: 255
  },
  point: {
    x: 15, y: 20
  },
  blurRadius: 0.8
};

let myRectStyle: text.RectStyle = {
  color: {
    alpha: 255,
    red: 0,
    green: 255,
    blue: 0
  },
  leftTopRadius: 15,
  rightTopRadius: 15,
  rightBottomRadius: 15,
  leftBottomRadius: 15
}

let myStrutStyle: text.StrutStyle = {
  fontWidth: text.FontWidth.ULTRA_EXPANDED,
  forceHeight: true,
  heightOverride: true,
  leading: 1.0,
  enabled: true,
}

let textStyleRed: text.TextStyle = {
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  ellipsis: "456",
};

let paragraphStyle: text.ParagraphStyle = {
  textStyle: textStyleRed,
  align: text.TextAlign.START,
  tab: textTab, //12 345有空格

};


let textStyleGray: text.TextStyle = {
  color: {
    alpha: 255,
    red: 128,
    green: 128,
    blue: 128
  },
  fontSize: 10,
  fontFeatures: [myFontFeature], //设置后成为 ½
};
let textStylegreen: text.TextStyle = {
  color: {
    alpha: 255,
    red: 0,
    green: 255,
    blue: 0
  },
  fontSize: 10,
  fontVariations: [myFontVariation], //设置后字体变粗
};

let textStylegreen1: text.TextStyle = {
  color: {
    alpha: 255,
    red: 0,
    green: 255,
    blue: 0
  },
  fontSize: 10,
  textShadows: [myTextShadow], //出现蓝色阴影文本字体
};

let textStylered: text.TextStyle = {
  color: {
    alpha: 255,
    red: 255,
    green: 0,
    blue: 0
  },
  fontSize: 10,
  backgroundRect: myRectStyle, //文本绿色填充
};

let textStylered2: text.TextStyle = {
  color: {
    alpha: 255,
    red: 128, // 0~255
    green: 0,
    blue: 255
  },
  fontSize: 10,
  fontWeight: text.FontWeight.W100,
  fontFamilies: ['cc']
};
let myPlaceholderSpan: text.PlaceholderSpan = {
  width: 200,
  height: 10,
  align: text.PlaceholderAlignment.BOTTOM_OF_ROW_BOX,
  baseline: text.TextBaseline.ALPHABETIC,
  baselineOffset: 0
};

@Entry
@Component
struct TestParagraphBuilder {
  @State content: string = "默认字体"
  @State pixelmap?: PixelMap = undefined;
  @State msg: string = "Test_Graphics_Text"
  private fontCollection: text.FontCollection = new text.FontCollection();
  private paragraph?: text.Paragraph = undefined;

  private buildParagraph(): text.Paragraph {
    let paragraphBuilder = new text.ParagraphBuilder(paragraphStyle, this.fontCollection);
    paragraphBuilder.addText("12\t345\n");

    // 第 1 块：1/2
    paragraphBuilder.pushStyle(textStyleGray);
    paragraphBuilder.addText('1/2\n');
    paragraphBuilder.popStyle();

    // 第 2 块：myFontVariation（换行）
    paragraphBuilder.pushStyle(textStylegreen);
    paragraphBuilder.addText('FontVariation\n');
    paragraphBuilder.popStyle();

    // 第 3 块：backgroundRect（再换行）
    paragraphBuilder.pushStyle(textStylered);
    paragraphBuilder.addText('backgroundRect\n');
    paragraphBuilder.popStyle();

    paragraphBuilder.pushStyle(textStylered2);
    paragraphBuilder.addText('ABCDZX中文1234\n');

    // 第 4 块：textShadows（再换行）
    paragraphBuilder.pushStyle(textStylegreen1);
    paragraphBuilder.addText('textShadows\n');
    paragraphBuilder.popStyle();

    paragraphBuilder.addPlaceholder(myPlaceholderSpan);
    return paragraphBuilder.build();
  }

  private drawParagraph(pixelmap: PixelMap) {
    if (!this.paragraph) {
      return;
    }
    console.info('textFunc begin')
    let canvas = new drawing.Canvas(pixelmap);
    this.paragraph.paint(canvas, 30, 50);
  }

  async prepareLayoutPromise() {
    this.paragraph = this.buildParagraph();
    this.paragraph.layoutSync(200);
  }

  aboutToAppear() {
    this.fontCollection.loadFontSync('cc', $rawfile("ComingSoon.ttf"));
    this.prepareLayoutPromise();
  }

  aboutToDisappear() {
    this.fontCollection.unloadFontSync("cc")
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          TitleBar()

          Image(this.pixelmap).width('100%').height('60%')
            .border({ width: 1, color: Color.Gray });

          Button("测试属性")
            .margin(5).width('100%')
            .onClick(() => {
              const color: ArrayBuffer = new ArrayBuffer(160000);
              let opts: image.InitializationOptions =
                { editable: true, pixelFormat: 3, size: { height: 200, width: 200 } }
              if (this.pixelmap == undefined) {
                this.pixelmap = image.createPixelMapSync(color, opts);
              }
              this.drawParagraph(this.pixelmap);
            })
        }
      }
    }
  }
}



