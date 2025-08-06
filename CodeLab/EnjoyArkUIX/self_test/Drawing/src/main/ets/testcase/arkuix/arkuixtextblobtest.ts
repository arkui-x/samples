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
import { TestBase } from '../../pages/testbase';
import { common2D } from "@kit.ArkGraphics2D";

export class ArkuiXMakeFromStringTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    let blob2 : drawing.TextBlob =
      drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF16);
    let blob3 : drawing.TextBlob =
      drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF32);
    let blob4 : drawing.TextBlob =
      drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_GLYPH_ID);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    canvas.drawTextBlob(blob2, 100, 300);
    canvas.drawTextBlob(blob3, 100, 400);
    canvas.drawTextBlob(blob4, 100, 500);
    canvas.detachPen();
  }
}

export class ArkuiXMakeFromPosTextTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let length = font.countText(text);
    let points : common2D.Point[] = [];
    for (let i = 0; i !== length; ++i) {
      points.push({ x: i * 35, y: i * 35 });
    }
    let textBlob : drawing.TextBlob =drawing.TextBlob.makeFromPosText(text, points.length, points, font);
    canvas.attachPen(pen);
    canvas.drawTextBlob(textBlob, 100, 200);
    canvas.detachPen();
  }
}

export class ArkuiXMakeFromRunBufferTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let runBuffer : Array<drawing.TextBlobRunBuffer> = [
      { glyph: 65, positionX: 100, positionY: 100 },
      { glyph: 227, positionX: 140, positionY: 100 },
      { glyph: 280, positionX: 180, positionY: 100 },
      { glyph: 280, positionX: 220, positionY: 100 },
      { glyph: 299, positionX: 260, positionY: 100}
    ];
    const textBlob = drawing.TextBlob.makeFromRunBuffer(runBuffer, font, null);
    canvas.attachPen(pen);
    canvas.drawTextBlob(textBlob, 100, 200);
    canvas.detachPen();
  }
}

export class ArkuiXBoundsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    const textBlob = drawing.TextBlob.makeFromString("你好，鸿蒙！", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(textBlob, 100, 200);
    let bounds = textBlob.bounds();
    console.log("DrawingTestArkuiX000" + " bounds.left:", bounds.left, " bounds.top:", bounds.top,
      " bounds.right:", bounds.right, " bounds.bottom:", bounds.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXUniqueIDTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    let font : drawing.Font = new drawing.Font();
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    const textBlob = drawing.TextBlob.makeFromString("你好，鸿蒙！", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(textBlob, 100, 200);
    let id = textBlob.uniqueID();
    console.log("DrawingTestArkuiX000" + " uniqueID = " +id);
    canvas.detachPen();
  }
}