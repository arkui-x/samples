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

export class ArkuiXGetFamilyNameTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    let typeFace = font.getTypeface();
    let familyName = typeFace.getFamilyName();
    console.log("DrawingTestArkuiX000" + " familyName : " + familyName);
    canvas.detachPen();
  }
}

export class ArkuiXMakeFromFileTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    let str = "/system/fonts/HarmonyOS_Sans_Italic.ttf";
    if (PlatformInfo.isAndroid()) {
      str = "/system/fonts/Roboto-Regular.ttf"
    } else if (PlatformInfo.isIOS()) {
      str = "/System/Library/Fonts/LanguageSupport/PingFang.ttc"
    }
    const typeFace = drawing.Typeface.makeFromFile(str)
    font.setTypeface(typeFace);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    canvas.detachPen();
  }
}

export class ArkuiXMakeFromRawFileTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    let text : string = "你好，鸿蒙！";
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
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
