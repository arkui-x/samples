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
import { buffer } from '@kit.ArkTS';

export class ArkuiXFontSubpixelTest extends TestBase {

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
    font.enableSubpixel(true);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    let values = font.isSubpixel();
    console.log("DrawingTestArkuiX000" + " values = ", values);
    canvas.detachPen();
  }
}

export class ArkuiXFontEmboldenTest extends TestBase {

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
    font.enableEmbolden(true);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    let values = font.isEmbolden();
    console.log("DrawingTestArkuiX000" + " values = ", values);
    canvas.detachPen();
  }
}

export class ArkuiXFontLinearMetricsTest extends TestBase {

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
    font.enableLinearMetrics(true);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.attachPen(pen);
    canvas.drawTextBlob(blob, 100, 200);
    let values = font.isLinearMetrics()
    console.log("DrawingTestArkuiX000" + " values = ", values);
    canvas.detachPen();
  }
}

export class ArkuiXFontSizeTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 200);
    let size = font.getSize();
    console.log("DrawingTestArkuiX000" + " size = " + size);
    let font2 : drawing.Font = new drawing.Font();
    font2.setSize(0);
    font2.setTypeface(myTypeFace);
    let blob2 : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob2, 100, 200);
    let size2 = font2.getSize();
    console.log("DrawingTestArkuiX000" + " size2 = " + size2);
    let font3 : drawing.Font = new drawing.Font();
    font3.setSize(-20);
    font3.setTypeface(myTypeFace);
    let blob3 : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font3, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob3, 100, 200);
    let size3 = font3.getSize();
    console.log("DrawingTestArkuiX000" + " size3 = " + size3);
    canvas.detachPen();

  }
}

export class ArkuiXFontTypefaceTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    let text : string = 'Hello World!';
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 200);
    let typeFace = font.getTypeface();
    let familyName = typeFace.getFamilyName();
    console.log("DrawingTestArkuiX000" + " familyName : " + familyName);
    canvas.detachPen();
  }
}

export class ArkuiXFontMetricsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);

    let font2: drawing.Font = new drawing.Font();
    font2.setSize(30);
    let text2: string = 'Hello World!';
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font2.setTypeface(myTypeFace);
    let blob2: drawing.TextBlob = drawing.TextBlob.makeFromString(text2, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob2, 10, 100);
    let metrics2 = font2.getMetrics();
    const fontMetricsArray2 = Object.entries(metrics2).map(([key, value]) => `${key}: ${value}`);
    console.log("DrawingTestArkuiX000" + ' fontMetricsArray2 ： ' + fontMetricsArray2);
    let text3: string = ' ' + fontMetricsArray2;
    let blob3: drawing.TextBlob = drawing.TextBlob.makeFromString(text3, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob3, 0, 200);
    let text4: string = 'flags:' + metrics2.flags;
    let blob4: drawing.TextBlob = drawing.TextBlob.makeFromString(text4, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob4, 0, 300);
    canvas.detachPen();
  }
}

export class ArkuiXMeasureSingleCharacterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text: string = "你";
    canvas.drawSingleCharacter(text, font, 200, 200);
    let width = font.measureSingleCharacter(text);
    console.log("DrawingTestArkuiX000" + " width = ", width);
    canvas.detachPen();
  }
}

export class ArkuiXMeasureTextTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let width = font.measureText(text, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    console.log("DrawingTestArkuiX000" + " width = ", width);
    canvas.detachPen();
  }
}

export class ArkuiXFontScaleXTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(50);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setScaleX(2);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let values = font.getScaleX();
    console.log("DrawingTestArkuiX000" + " values = " + values);
    canvas.detachPen();
  }
}

export class ArkuiXFontSkewXTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setSkewX(1);
    let text: string = "你 好";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let values = font.getSkewX();
    console.log("DrawingTestArkuiX000" + "values = " + values);

    let font2 : drawing.Font = new drawing.Font();
    font2.setSize(100);
    font2.setTypeface(myTypeFace);
    font2.setSkewX(-1);
    let blob2 : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob2, 200, 400);
    let values2 = font.getSkewX();
    console.log("DrawingTestArkuiX000" + "values2 = " + values2);
    canvas.detachPen();
  }
}

export class ArkuiXFontEdgingTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setEdging(drawing.FontEdging.SUBPIXEL_ANTI_ALIAS);
    let text: string = "你好，鸿蒙！";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 200);
    let values = font.getEdging();
    console.log("DrawingTestArkuiX000" + "values = " + values);

    let font2 : drawing.Font = new drawing.Font();
    font2.setSize(100);
    font2.setTypeface(myTypeFace);
    font2.setEdging(drawing.FontEdging.ANTI_ALIAS);
    let blob2 : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob2, 100, 350);
    let values2 = font2.getEdging();
    console.log("DrawingTestArkuiX000" + "values2 = " + values2);

    let font3 : drawing.Font = new drawing.Font();
    font3.setSize(100);
    font3.setTypeface(myTypeFace);
    font3.setEdging(drawing.FontEdging.ALIAS);
    let blob3 : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font3, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob3, 100, 500);
    let values3 = font3.getEdging();
    console.log("DrawingTestArkuiX000" + "values3 = " + values3);
    canvas.detachPen();
  }
}

export class ArkuiXFontHintingTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setHinting(drawing.FontHinting.NONE);
    let text: string = "你好，鸿蒙！";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 150);
    let values = font.getHinting();
    console.log("DrawingTestArkuiX000" + "values = " + values);

    let font2 : drawing.Font = new drawing.Font();
    font2.setSize(100);
    font2.setTypeface(myTypeFace);
    font2.setHinting(drawing.FontHinting.SLIGHT);
    let blob2 : drawing.TextBlob =
      drawing.TextBlob.makeFromString(text, font2, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob2, 100, 300);
    let values2 = font2.getHinting();
    console.log("DrawingTestArkuiX000" + "values2 = " + values2);

    let font3 : drawing.Font = new drawing.Font();
    font3.setSize(100);
    font3.setTypeface(myTypeFace);
    font3.setHinting(drawing.FontHinting.NORMAL);
    let blob3 : drawing.TextBlob =
      drawing.TextBlob.makeFromString(text, font3, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob3, 100, 450);
    let values3 = font3.getHinting();
    console.log("DrawingTestArkuiX000" + "values3 = " + values3);

    let font4 : drawing.Font = new drawing.Font();
    font4.setSize(100);
    font4.setTypeface(myTypeFace);
    font4.setHinting(drawing.FontHinting.FULL);
    let blob4 : drawing.TextBlob =
      drawing.TextBlob.makeFromString(text, font4, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob4, 100, 600);
    let values4 = font4.getHinting();
    console.log("DrawingTestArkuiX000" + "values4 = " + values4);
    canvas.detachPen();
  }
}

export class ArkuiXCountTextTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let resultNumber = font.countText(text);
    console.log("DrawingTestArkuiX000" + "resultNumber = ", resultNumber);
    canvas.detachPen();
  }
}

export class ArkuiXBaselineSnapTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setBaselineSnap(true);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let result = font.isBaselineSnap();
    console.log("DrawingTestArkuiX000" + "result = ", result);
    canvas.detachPen();
  }
}

export class ArkuiXEmbeddedBitmapsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setEmbeddedBitmaps(true);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let result = font.isEmbeddedBitmaps();
    console.log("DrawingTestArkuiX000" + "result = ", result);
    canvas.detachPen();
  }
}

export class ArkuiXForceAutoHintingTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setForceAutoHinting(true);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let result = font.isForceAutoHinting();
    console.log("DrawingTestArkuiX000" + "result = ", result);
    canvas.detachPen();
  }
}

export class ArkuiXThemeFontFollowedTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    font.setThemeFontFollowed(true);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 200, 200);
    let result = font.isThemeFontFollowed();
    console.log("DrawingTestArkuiX000" + "result = ", result);
    canvas.detachPen();
  }
}

export class ArkuiXGetWidthsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text: string = "drawing";
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    let glyphs: number[] = font.textToGlyphs(text, font.countText(text));
    let fontWidths: Array<number> = font.getWidths(glyphs);
    for (let index = 0; index < fontWidths.length; index++) {
      console.log("DrawingTestArkuiX000" + "get fontWidths[", index, "]:", fontWidths[index]);
    }
    canvas.drawTextBlob(blob, 200, 200);
    canvas.detachPen();
  }
}

export class ArkuiXTextToGlyphsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text : string = 'hello world';
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    let glyphs : number[] = font.textToGlyphs(text);
    console.log("DrawingTestArkuiX000" + 'textToGlyphs array = [', glyphs, ']');
    canvas.drawTextBlob(blob, 100, 200);
    canvas.detachPen();
  }
}

export class ArkuiXPathForGlyphTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text : string = '你好！';
    let glyphs : number[] = font.textToGlyphs(text);
    for (let index = 0; index < glyphs.length; index++) {
      let path: drawing.Path = font.createPathForGlyph(glyphs[index]);
      canvas.translate(100, 200);
      canvas.drawPath(path);
    }
    canvas.detachPen();
  }
}

export class ArkuiXGetBoundsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text : string = 'hello world';
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    let glyphs : number[] = font.textToGlyphs(text);
    let fontBounds: Array<common2D.Rect> = font.getBounds(glyphs);
    for (let index = 0; index < fontBounds.length; index++) {
      console.log("DrawingTestArkuiX000" + "get fontBoundRect[", index, "] left:", fontBounds[index].left, " top:", fontBounds[index].top,
        " right:", fontBounds[index].right, " bottom:", fontBounds[index].bottom);
    }
    canvas.drawTextBlob(blob, 100, 200);
    canvas.detachPen();
  }
}

export class ArkuiXGetTextPathTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let font : drawing.Font = new drawing.Font();
    font.setSize(100);
    const myTypeFace = drawing.Typeface.makeFromRawFile($rawfile('HarmonyOS_Sans_SC.ttf'));
    font.setTypeface(myTypeFace);
    let text : string = 'hello world';
    let length = buffer.from(text).length;
    let path = font.getTextPath(text, length, 0, 100)
    canvas.drawPath(path)
    canvas.detachPen();
  }
}

