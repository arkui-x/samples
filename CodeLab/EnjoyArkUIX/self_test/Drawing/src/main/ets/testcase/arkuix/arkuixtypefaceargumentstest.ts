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

import drawing from "@ohos.graphics.drawing";
import { PlatformInfo } from "../../pages/platformInfo";
import { TestBase } from '../../pages/testbase';

export class ArkuiXMakeFromCurrentTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let typeArguments = new drawing.TypefaceArguments();
    typeArguments.addVariation("wght", 100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    const typeFace1 = myTypeFace.makeFromCurrent(typeArguments);
    let font = new drawing.Font();
    font.setTypeface(typeFace1);
    const textBlob = drawing.TextBlob.makeFromString("Hello World", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, 60, 100);
  }
}

export class ArkuiXMakeFromFileWithArgumentsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let font = new drawing.Font();

    let str = "/system/fonts/HarmonyOS_Sans_Italic.ttf";
    if (PlatformInfo.isAndroid()) {
      str = "/system/fonts/Roboto-Regular.ttf"
    } else if (PlatformInfo.isIOS()) {
      str = "/System/Library/Fonts/LanguageSupport/PingFang.ttc"
    }
    let typeFaceArgument = new drawing.TypefaceArguments();
    const myTypeFace = drawing.Typeface.makeFromFileWithArguments(str, typeFaceArgument);
    font.setTypeface(myTypeFace);
    const textBlob = drawing.TextBlob.makeFromString("Hello World", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(textBlob, 60, 100);
  }
}

export class ArkuiXMakeFromRawFileWithArgumentsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    let typeFaceArgument = new drawing.TypefaceArguments();
    const myTypeFace = drawing.Typeface.makeFromRawFileWithArguments($rawfile('SansSerif.ttf'), typeFaceArgument);
    font.setTypeface(myTypeFace);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    let typeFace = font.getTypeface();
    let familyName = typeFace.getFamilyName();
    console.log("familyName : " + familyName);
    canvas.detachPen();
  }
}
