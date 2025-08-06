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
import {TestBase, TestFunctionStyleType, StyleType} from '../../pages/testbase';
import { OHRandom } from '../../utils/OHRandom';
import { common2D } from "@kit.ArkGraphics2D";
import globalThis from '../../utils/globalThis'
import image from '@ohos.multimedia.image';

const TAG = '[ArkuiXCanvasTest]';

export class ArkuiXCanvasTest extends TestBase {

  rand_: OHRandom | undefined;
  x_: number | 0xFF;
  y_: number | 0xFF;
  dx_: number | 0xFF;
  dy_: number | 0xFF;
  pen_: drawing.Pen;
  brush_: drawing.Brush;

  public constructor() {
    super();
    this.rand_ = new OHRandom();
    this.x_ = this.rand_.nextULessThan(20);
    this.y_ = this.rand_.nextULessThan(20);
    this.dx_ = this.rand_.nextULessThan(200);
    this.dy_ = this.rand_.nextULessThan(200);

    this.pen_ = new  drawing.Pen();
    this.brush_ = new drawing.Brush();
    this.pen_.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
    this.pen_.setStrokeWidth(5);
    this.brush_.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
  }

  public static printResults(canvas: drawing.Canvas, isPassed: Boolean) {
    let font: drawing.Font = new drawing.Font();
    font.setSize(50);
    let blob: drawing.TextBlob = drawing.TextBlob.makeFromString(isPassed ? "Passed": "Not Passed",
      font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 10, 50);
  }
}

async function createPixelsMap(width: number, height: number): Promise<image.PixelMap> {
  const color: ArrayBuffer = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = {
    editable: true,
    pixelFormat: 3,
    size: { height: height, width: width },
    alphaType: image.AlphaType.PREMUL,
    scaleMode: image.ScaleMode.FIT_TARGET_SIZE,
    srcPixelFormat: image.PixelMapFormat.BGRA_8888
  }
  let pixelsMap = await image.createPixelMap(color, opts);
  if (pixelsMap == null || pixelsMap == undefined) {
    console.log("DrawingTestArkuiX000" + " canvas: createPixelMapSync failed")
  }
  return pixelsMap;
}

export class CanvasDrawRectTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let rect: common2D.Rect = { left: 20, top: 20, right: 200, bottom: 200 };
    canvas.drawRect(rect);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
  }

}

export class CanvasDrawRectParamTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.drawRect({left: 25, top: 25, right: 250, bottom: 250});
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
  }

}

export class CanvasDrawRoundRectTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let roundRect = new drawing.RoundRect({left: 0, top: 0, right: 300, bottom: 300}, 50, 50);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(roundRect);
    canvas.detachPen();
    canvas.detachBrush();

    this.pen_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });
    this.brush_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });

    try {
      roundRect.offset(this.dx_, this.dy_);
    } catch (e) {
      console.log("DrawingTestArkuiX000" + " offset exception " + e);
      ArkuiXCanvasTest.printResults(canvas, false);
    }

    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(roundRect);
    canvas.detachPen();
    canvas.detachBrush();
  }

}

export class CanvasDrawRoundNestedRectTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let outerRoundRect = new drawing.RoundRect({left: 0, top: 0, right: 300, bottom: 300}, 50, 50);
    let innerRoundRect = new drawing.RoundRect({left: 10, top: 10, right: 290, bottom: 290}, 50, 50);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawNestedRoundRect(outerRoundRect, innerRoundRect);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasDrawBackgroundTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    this.ApplyBrushStyle(brush, TestFunctionStyleType.DRAW_STYLE_TYPE_2)
    canvas.drawBackground(brush);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
  }
}

export class CanvasDrawShadowTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    const path = new drawing.Path();
    path.addCircle(200, 200, 200, drawing.PathDirection.CLOCKWISE);
    let point1 : common2D.Point3d = {x: 100, y: 80, z:80};
    let point2 : common2D.Point3d = {x: 200, y: 10, z:40};
    let shadowFlag : drawing.ShadowFlag = drawing.ShadowFlag.ALL;
    canvas.drawShadow(path, point1, point2, 30, 0xFF0000FF, 0xFFFF0000, shadowFlag);
  }
}

export class CanvasDrawShadowParamTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    const path = new drawing.Path();
    path.addCircle(350, 600, 100, drawing.PathDirection.CLOCKWISE);
    let point1 : common2D.Point3d = {x: 100, y: 80, z:80};
    let point2 : common2D.Point3d = {x: 200, y: 10, z:40};
    let shadowFlag : drawing.ShadowFlag = drawing.ShadowFlag.ALL;
    canvas.drawShadow(path, point1, point2, 30, {alpha:0xFF, red:0x00, green:0x00, blue:0xFF},
      {alpha:0xFF, red:0xFF, green:0x00, blue:0x00}, shadowFlag);
  }
}

export class CanvasDrawCircleTest extends TestBase {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_1);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle(brush, TestFunctionStyleType.DRAW_STYLE_TYPE_1);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      canvas.drawCircle(10, 10, 50);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_2);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle(brush, TestFunctionStyleType.DRAW_STYLE_TYPE_2);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      canvas.drawCircle(102.6, 67.6, 60.8);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle (brush, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      canvas.drawCircle(350.6, 238.6, 265.8);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_4);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle (brush, TestFunctionStyleType.DRAW_STYLE_TYPE_4);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      canvas.drawCircle(50.6, 496.6, 67.8);
      canvas.detachPen();
      canvas.detachBrush();
    }
  }
}

export class CanvasDrawImageTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public async OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
    // let pixelMap = await createPixelsMap(this.width_, this.height_);
    // this.ApplyPenStyle(this.pen_, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
    // canvas.attachPen(this.pen_);
    canvas.drawImage(pixelMap, 10, 10);
    // canvas.detachPen();
  }
}

export class CanvasDrawImageLatticeTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_2.jpg");
    let xDivs: Array<number> = [30, 432];
    let yDivs: Array<number> = [30, 300, 450, 682];
    let lattice = drawing.Lattice.createImageLattice(xDivs, yDivs, 2, 4);
    let dst: common2D.Rect = { left: 64, top: 10, right: 130, bottom: 150 };
    this.ApplyPenStyle(this.pen_, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
    canvas.attachPen(this.pen_)
    canvas.attachBrush(this.brush_)
    canvas.drawImageLattice(pixelMap, lattice, dst, drawing.FilterMode.FILTER_MODE_NEAREST);
    canvas.detachPen()
    canvas.detachBrush()

  }
}

export class CanvasDrawImageNineTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_2.jpg");
    {
      this.ApplyPenStyle(this.pen_, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      let center: common2D.Rect = { left: 100, top: 100, right: 402, bottom: 500 };
      let dst: common2D.Rect = { left: 48, top: 10, right: 100, bottom: 150 };
      canvas.attachPen(this.pen_)
      canvas.drawImageNine(pixelMap, center, dst, drawing.FilterMode.FILTER_MODE_NEAREST);
      canvas.detachPen()
    }

    {
      this.ApplyPenStyle(this.pen_, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      let center: common2D.Rect = { left: 100, top: 100, right: 402, bottom: 500 };
      let dst: common2D.Rect = { left: 100, top: 80, right: 190, bottom: 131 };
      canvas.attachPen(this.pen_)
      canvas.drawImageNine(pixelMap, center, dst, drawing.FilterMode.FILTER_MODE_NEAREST);
      canvas.detachPen()
    }

    {
      this.ApplyPenStyle(this.pen_, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      let center: common2D.Rect = { left: 100, top: 100, right: 402, bottom: 500 };
      let dst: common2D.Rect = { left: 230, top: 80, right: 350, bottom: 120 };
      canvas.attachPen(this.pen_)
      canvas.drawImageNine(pixelMap, center, dst, drawing.FilterMode.FILTER_MODE_NEAREST);
      canvas.detachPen()
    }
  }
}

export class CanvasDrawImageRectTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public async OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
    // let pixelMap = await createPixelsMap(this.width_, this.height_);
    let pmSize: image.Size = pixelMap.getImageInfoSync().size;
    let rect: common2D.Rect = { left: 0, top: 0, right: pmSize.width, bottom: pmSize.height };
    canvas.drawImageRect(pixelMap, rect);
    canvas.detachPen();
  }
}

export class CanvasDrawImageRectWithSrcTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_2.jpg");
    let pmSize: image.Size = pixelMap.getImageInfoSync().size;
    let srcRect: common2D.Rect = { left: 0, top: 0, right: (pmSize.width / 2), bottom: (pmSize.height / 2) };
    let opts = new drawing.SamplingOptions();
    {
      let dstRect: common2D.Rect = { left: 0, top: 0, right: pmSize.width, bottom: pmSize.height };
      canvas.drawImageRectWithSrc(pixelMap, srcRect, dstRect, opts, drawing.SrcRectConstraint.STRICT);
    }
    {
      let dstRect: common2D.Rect = { left: 100, top: 100, right: 200, bottom: 200 };
      canvas.drawImageRectWithSrc(pixelMap, srcRect, dstRect, opts, drawing.SrcRectConstraint.FAST);
    }
  }
}

export class CanvasDrawColorTest extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_2);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle(brush, TestFunctionStyleType.DRAW_STYLE_TYPE_2);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      canvas.drawCircle(102.6, 67.6, 60.8);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let rect: common2D.Rect = {
        left: 2.7,
        top: 175.7,
        right: 450.7,
        bottom: 315.9
      };
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle(brush, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      canvas.drawRect(rect);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let color: common2D.Color = { alpha: 255, red: 168, green: 48, blue: 176 };
      canvas.drawColor(color, drawing.BlendMode.MULTIPLY);
    }
    {
      canvas.clipRect( { left: 100, top: 200, right:200, bottom: 400 });
      canvas.drawColor({ alpha: 255, red: 168, green: 48, blue: 176 }, drawing.BlendMode.LUMINOSITY);
      canvas.restore();
    }
    {
      const brush = new drawing.Brush();
      brush.setAlpha(255);
      canvas.saveLayer({ left: 200, top: 300, right:500, bottom: 500 }, brush);
      const opaqueColor: common2D.Color = {
        alpha: 0xFF,  // 不透明
        red: 0xFF,    // 白色（可自定义）
        green: 0xFF,
        blue: 0xFF
      };
      canvas.drawColor(opaqueColor, drawing.BlendMode.SRC_OVER);
      canvas.clipRect( { left: 300, top: 200, right:400, bottom: 400 });
      canvas.drawColor(0xFF0F0F0F, drawing.BlendMode.CLEAR);
      canvas.restore();
    }
  }
}

export class CanvasDrawOvalTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.attachPen(this.pen_);
    let rect: common2D.Rect = { left: 20, top: 20, right: 200, bottom: 200 };
    canvas.drawOval(rect);
    canvas.detachPen();
  }
}

export class CanvasDrawArcTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.attachPen(this.pen_);
    let rect: common2D.Rect = { left: 20, top: 20, right: 200, bottom: 200 };
    canvas.drawArc(rect,0,60);
    canvas.detachPen();
  }
}

export class CanvasDrawArcWithCenterTest extends ArkuiXCanvasTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.attachPen(this.pen_);
    {
      let rect: common2D.Rect = {left: 20, top: 20, right: 120, bottom: 120};
      canvas.drawArcWithCenter(rect, 80, 280, true);
    }
    {
      let rect: common2D.Rect = {left: 20, top: 140, right: 120, bottom: 240};
      canvas.drawArcWithCenter(rect, -90, 180, false);
    }
  }
}

export class CanvasDrawPointTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawPoint(200, 200);
      canvas.drawPoint(201, 201);
      canvas.drawPoint(202, 202);
      canvas.drawPoint(203, 203);
      canvas.drawPoint(204, 204);
      canvas.drawPoint(205, 205);
      canvas.detachPen();
      canvas.detachBrush();
    }
    {
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawPoint(400, 400);
      canvas.drawPoint(401, 401);
      canvas.drawPoint(402, 402);
      canvas.drawPoint(403, 403);
      canvas.drawPoint(404, 404);
      canvas.drawPoint(405, 405);
      canvas.detachPen();
      canvas.detachBrush();
    }
  }
}

export class CanvasDrawPointsTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let point1 : common2D.Point = {x: 100, y: 300};
    let point2 : common2D.Point = {x: 200, y: 500};
    let pointArray :Array<common2D.Point>= [point1,point2];
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawPoints(pointArray, drawing.PointMode.POINTS);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasDrawPathTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    const path = new drawing.Path();
    {
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      path.moveTo(10, 12.5);
      path.lineTo(112, 67.81);
      for (let i = 0; i < 5; i++) {
        path.lineTo(112 + i * 12, 67.81 + i * 23.4);
      }
      path.close();
      canvas.drawPath(path);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_2);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle(brush, TestFunctionStyleType.DRAW_STYLE_TYPE_2);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      path.reset();
      path.arcTo(323.7, 87.69, 438.3, 195.81, -81, 167.3);
      canvas.drawPath(path);
      path.reset();
      path.arcTo(469.7, 168.69, 537.41, 328.4, -127.36, 36.5 );
      canvas.drawPath(path);

      path.reset();
      path.moveTo(500, 563.9);
      path.quadTo(416.3, 376.81, 515.3, 465.81);
      canvas.drawPath(path);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle (brush, TestFunctionStyleType.DRAW_STYLE_TYPE_3);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      path.reset();
      path.cubicTo(17.6, 168, 216.9, 316.8, 378.16, 698.4);
      canvas.drawPath(path);
      canvas.detachPen();
      canvas.detachBrush();
    }

    {
      let pen = new drawing.Pen();
      this.ApplyPenStyle(pen, TestFunctionStyleType.DRAW_STYLE_TYPE_4);
      let brush = new drawing.Brush();
      this.ApplyBrushStyle (brush, TestFunctionStyleType.DRAW_STYLE_TYPE_4);
      canvas.attachPen(pen);
      canvas.attachBrush(brush);
      path.reset();
      path.moveTo(150, 300);
      path.lineTo(-57, -30.41);
      canvas.drawPath(path);
      canvas.detachPen();
      canvas.detachBrush();
    }
  }
}

export class CanvasDrawLineTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawLine(11, 110, 200.7, 150.9);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasDrawSingleCharacterTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let font: drawing.Font = new drawing.Font();
    font.setSize(50);
    let text: string = 'C';
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawSingleCharacter(text, font, 100, 100);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasDrawTextBlobTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let font: drawing.Font = new drawing.Font();
    font.setSize(50);
    let text: string = 'drawTextBlob';
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    font.setTypeface(new drawing.Typeface());
    font.enableSubpixel(true);
    font.enableEmbolden(true);
    font.setSize(30);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 100);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasDrawPixelMapMeshTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg")
    canvas.attachBrush(this.brush_);
    // let verts: Array<number> = [100, 100, 200, 100, 150, 200, 200, 200];
    // let colors: Array<number> = [0x00ff0088, 0x00ff0088, 0x00ff0088, 0x00ff0088];
    // canvas.drawPixelMapMesh(pixelMap, 10, 50, verts, 0, colors, 0);
    let verts : Array<number> = [0, 0, 50, 0, 410, 0, 0, 180, 50, 180, 410, 180, 0, 360, 50, 360, 410, 360]; // 18
    canvas.drawPixelMapMesh(pixelMap, 2, 2, verts, 0, null, 0);
    canvas.detachBrush();
  }
}

export class CanvasDrawRegionTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
    this.brush_.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
    let region: drawing.Region = new drawing.Region();
    region.setRect(0, 0, 500, 500);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawRegion(region);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasSaveAndRestoreTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let rect: common2D.Rect = { left: 100, top: 100, right: 200, bottom: 200 };
      canvas.attachBrush(this.brush_);
      canvas.drawRect(rect);
      canvas.detachBrush();
    }

    {
      let rect: common2D.Rect = { left: 210, top: 10, right: 300, bottom: 100};
      canvas.save();
      canvas.clipRect(rect);
      canvas.drawColor(0xffff0000);
      canvas.restore();
    }
  }
}

export class CanvasSaveLayerTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let rect: common2D.Rect = { left: 100, top: 100, right: 200, bottom: 200 };
    canvas.attachBrush(this.brush_);
    canvas.drawRect(rect);
    canvas.detachBrush();
    canvas.saveLayer();
    canvas.drawColor(0xffff0000);
    canvas.restore();
  }
}

export class CanvasClearTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.clear({ alpha: 255, red: 255, green: 0, blue: 0});
    canvas.clear(0xffff0000);
  }
}

export class CanvasRestoreAndSaveCountTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let rect: common2D.Rect = { left: 100, top: 100, right: 200, bottom: 200 };
    canvas.attachBrush(this.brush_);
    canvas.drawRect(rect);
    canvas.detachBrush();
    let count = canvas.save();
    canvas.restoreToCount(count);
    canvas.save();
    canvas.getSaveCount();
  }
}

export class CanvasGetWidthAndHeightTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let width = canvas.getWidth();
    let height = canvas.getHeight();
    let font: drawing.Font = new drawing.Font();
    font.setSize(30);
    let text: string = 'width:' + width + ",height:" + height;
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 100);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasGetLocalClipBoundsTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    let rect : common2D.Rect =canvas.getLocalClipBounds();
    let text: string = 'left:' + rect.left + ",top:" + rect.top + ",right:" + rect.right + ",bottom:" + rect.bottom;
    let font: drawing.Font = new drawing.Font();
    font.setSize(30);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 100);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasGetTotalMatrixTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    let matrix : drawing.Matrix =canvas.getTotalMatrix();
    let text: string = '';
    let actualValues = matrix.getAll();
    for (let i = 0; i < actualValues.length; i++) {
      text = text + "matrix[" + i + "]:" + actualValues[i];
    }
    let font: drawing.Font = new drawing.Font();
    font.setSize(30);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    let blob : drawing.TextBlob = drawing.TextBlob.makeFromString(text, font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 100);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasScaleTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let rect1: common2D.Rect = { left: 10, top: 20, right: 30, bottom: 60 };
    let rect2: common2D.Rect = { left: 30, top: 20, right: 50, bottom: 60 };
    canvas.drawRect(rect1);
    this.brush_.setColor({ alpha: 255, red: 0, green: 0, blue: 255 });
    canvas.attachBrush(this.brush_);
    canvas.scale(2, 3);
    canvas.drawRect(rect2);
    canvas.detachBrush();
  }
}

export class CanvasSkewTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.skew(2, 2);
    let rect: common2D.Rect = { left: 10, top: 20, right: 30, bottom: 60 };
    canvas.attachBrush(this.brush_);
    canvas.drawRect(rect);
    canvas.detachBrush();
  }
}

export class CanvasRotateTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.rotate(-30, 10, 20);
    let rect: common2D.Rect = { left: 10, top: 20, right: 30, bottom: 60 };
    canvas.attachBrush(this.brush_)
    canvas.drawRect(rect)
    canvas.detachBrush()
  }
}

export class CanvasTranslateTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.translate(0, 60);
    let rect: common2D.Rect = { left: 10, top: 20, right: 30, bottom: 60 };
    canvas.attachBrush(this.brush_)
    canvas.drawRect(rect)
    canvas.detachBrush()
  }
}

export class CanvasClipPathTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let failure: boolean = false;
    const path = new drawing.Path();
    canvas.save();
    if (canvas.isClipEmpty()) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.isClipEmpty() returned TRUE for empty clipPath");
      failure = true;
    }
    canvas.clipPath(path);
    if (!(canvas.isClipEmpty())) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.isClipEmpty() returned FALSE for non-empty clipPath");
      failure = true;
    }
    canvas.restore();
    if (canvas.isClipEmpty()) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.isClipEmpty() returned TRUE for empty (restored) clipPath");
      failure = true;
    }
    ArkuiXCanvasTest.printResults(canvas, !failure);
  }
}

export class CanvasClipRectTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.clipRect( { left: 100, top: 200, right:200, bottom: 400 });
    canvas.drawColor({ alpha: 255, red: 168, green: 48, blue: 176 }, drawing.BlendMode.LUMINOSITY);
    canvas.restore();
  }
}

export class CanvasConcatMatrixTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.preRotate(-30, 10, 20)
    canvas.concatMatrix(matrix);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawRect({left: 25, top: 25, right: 250, bottom: 250});
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasClipRegionTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas): void {
    let region : drawing.Region = new drawing.Region();
    region.setRect(200, 200, 300, 300);
    canvas.clipRegion(region);
    let color: common2D.Color = {alpha: 255, red: 255, green: 0, blue: 0};
    canvas.clear(color);
  }
}

export class CanvasClipRoundRectTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    let rectOne: common2D.Rect = { left: 10, top: 100, right: 200, bottom: 300 };
    let roundRectOne = new drawing.RoundRect(rectOne, 10, 10);
    canvas.clipRoundRect(roundRectOne);
    canvas.drawRect(rectOne);
    let rectTwo: common2D.Rect = { left: 100, top: 200, right: 300, bottom: 400 };
    let roundRectTwo = new drawing.RoundRect(rectTwo, 10, 10);
    canvas.clipRoundRect(roundRectTwo, drawing.ClipOp.INTERSECT);
    canvas.drawRect(rectTwo);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class CanvasIsClipEmptyTest extends ArkuiXCanvasTest {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let failure: boolean = false;
    const path = new drawing.Path();
    canvas.save();
    if (canvas.isClipEmpty()) {
      console.log("DrawingTestArkuiX000" + TAG, "canvas.isClipEmpty() returned TRUE for empty clipPath");
      failure = true;
    }
    canvas.clipPath(path);
    if (!(canvas.isClipEmpty())) {
      console.log("DrawingTestArkuiX000" + TAG, "canvas.isClipEmpty() returned FALSE for non-empty clipPath");
      failure = true;
    }
    canvas.restore();
    if (canvas.isClipEmpty()) {
      console.log("DrawingTestArkuiX000" + TAG, "canvas.isClipEmpty() returned TRUE for empty (restored) clipPath");
      failure = true;
    }
    ArkuiXCanvasTest.printResults(canvas, !failure);
  }
}

export class CanvasSetMatrixTest extends ArkuiXCanvasTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let rect: common2D.Rect = { left: 100, top: 300, right: 300, bottom: 600 };
    canvas.translate(100, 0)
    canvas.resetMatrix()
    canvas.attachBrush(this.brush_)
    canvas.drawRect(rect)
    canvas.detachBrush()
    this.brush_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 })
    canvas.attachBrush(this.brush_)
    let matrix = new drawing.Matrix();
    matrix.setTranslation(300, 0);
    canvas.setMatrix(matrix)
    canvas.drawRect(rect)
    canvas.detachBrush()
  }
}

export class CanvasResetMatrixTest extends ArkuiXCanvasTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let rect1: common2D.Rect = { left: 10, top: 20, right: 30, bottom: 60 };
    let rect2: common2D.Rect = { left: 30, top: 20, right: 50, bottom: 60 };
    canvas.attachBrush(this.brush_);
    canvas.drawRect(rect1);
    this.brush_.setColor({ alpha: 255, red: 0, green: 0, blue: 255 });
    canvas.attachBrush(this.brush_);
    canvas.scale(2, 3);
    canvas.drawRect(rect2);
    canvas.resetMatrix();
    canvas.detachBrush();
  }
}

export class CanvasQuickRejectPathTest extends ArkuiXCanvasTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let failure: boolean = false;
    let path = new drawing.Path();
    path.moveTo(10, 10);
    path.cubicTo(10, 10, 10, 10, 15, 15);
    path.close();
    if (canvas.quickRejectPath(path)) {
      console.log("DrawingTestArkuiX000" + " canvas and path do not intersect.");
      failure = true;
    } else {
      console.log("DrawingTestArkuiX000" + " canvas and path intersect.");
    }
    ArkuiXCanvasTest.printResults(canvas, !failure);
  }
}

export class CanvasQuickRejectRectTest extends ArkuiXCanvasTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let failure: boolean = false;
    let rect: common2D.Rect = { left : 10, top : 20, right : 50, bottom : 30 };
    if (canvas.quickRejectRect(rect)) {
      console.log("DrawingTestArkuiX000" + "canvas and rect do not intersect.");
      failure = true;
    } else {
      console.log("DrawingTestArkuiX000" + "canvas and rect intersect.");
    }
    ArkuiXCanvasTest.printResults(canvas, !failure);
  }
}



