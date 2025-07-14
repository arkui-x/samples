/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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
import { OHRandom } from '../../utils/OHRandom';
import common2D from '@ohos.graphics.common2D';

const TAG = '[BezierBench]';
 function  printResults(canvas: drawing.Canvas, isPassed: Boolean) {
  let font: drawing.Font = new drawing.Font();
  font.setSize(50);
  let blob: drawing.TextBlob = drawing.TextBlob.makeFromString(isPassed ? "Passed": "Not Passed",
    font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
  canvas.drawTextBlob(blob, 10, 50);
}

function setPen(canvas: drawing.Canvas) {
  let pen = new drawing.Pen();
  pen.setColor(0xFF000000);
  pen.setStrokeWidth(5);
  canvas.attachPen(pen);
}

export class ArkuiXPathMoveTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    setPen(canvas);
    path.moveTo(100, 50);
    path.lineTo(200, 400);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathLineTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    setPen(canvas);
    path.moveTo(0, 0);
    path.lineTo(200, 200);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathArcTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas): void {
    let path:drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.arcTo(100, 100, 150, 150, 0, 150);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathQuadTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    path.moveTo(1, 0);
    path.quadTo(100 , 100, 200 , 80);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathConicTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path:drawing.Path = new drawing.Path();
    path.moveTo(50, 100);
    path.lineTo(200, 400);
    path.conicTo(100, 100, 150, 140, 1);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathCubicTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.cubicTo(100, 100, 150, 140, 200, 80);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathRMoveTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    setPen(canvas);
    path.moveTo(0, 0);
    path.lineTo(100, 100);
    path.rMoveTo(100,100);
    path.rLineTo(200, 100);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathRLineTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    setPen(canvas);
    path.moveTo(0, 0);
    path.lineTo(100, 100);
    path.rMoveTo(100,100);
    path.rLineTo(200, 100);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathRQuadTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    path.moveTo(1, 0);
    path.rQuadTo(100 , 100, 200 , 80);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathRConicTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path:drawing.Path = new drawing.Path();
    path.moveTo(50, 50);
    path.rConicTo(100, 100, 200, 400, 200);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathRCubicTo extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let rand: OHRandom = new OHRandom();
    let path:drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.rCubicTo(100, 100, 150, 140, 200, 80);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathAddPolygon extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path = new drawing.Path();

    let pointsArray = new Array<common2D.Point>();
    const point1: common2D.Point = { x: 200, y: 200 };
    const point2: common2D.Point = { x: 400, y: 200 };
    const point3: common2D.Point = { x: 100, y: 400 };
    const point4: common2D.Point = { x: 300, y: 400 };
    pointsArray.push(point1);
    pointsArray.push(point2);
    pointsArray.push(point3);
    pointsArray.push(point4);
    path.addPolygon(pointsArray, false);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathOp extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path = new drawing.Path();
      let path1 = new drawing.Path();
      path.addCircle(200,120,100,drawing.PathDirection.CLOCKWISE);
      path1.addCircle(230,150,100,drawing.PathDirection.CLOCKWISE);
      path.op(path1, drawing.PathOp.DIFFERENCE);
      canvas.drawPath(path);
    }
    {
      let path = new drawing.Path();
      let path1 = new drawing.Path();
      path.addCircle(200,300,100,drawing.PathDirection.CLOCKWISE);
      path1.addCircle(230,330,100,drawing.PathDirection.CLOCKWISE);
      path.op(path1, drawing.PathOp.INTERSECT);
      canvas.drawPath(path);
    }
    {
      let path = new drawing.Path();
      let path1 = new drawing.Path();
      path.addCircle(200,530,100,drawing.PathDirection.CLOCKWISE);
      path1.addCircle(230,560,100,drawing.PathDirection.CLOCKWISE);
      path.op(path1, drawing.PathOp.UNION);
      canvas.drawPath(path);
    }
    {
      let path = new drawing.Path();
      let path1 = new drawing.Path();
      path.addCircle(450,220,100,drawing.PathDirection.CLOCKWISE);
      path1.addCircle(480,250,100,drawing.PathDirection.CLOCKWISE);
      path.op(path1, drawing.PathOp.XOR);
      canvas.drawPath(path);
    }
    {
      let path = new drawing.Path();
      let path1 = new drawing.Path();
      path.addCircle(450,480,100,drawing.PathDirection.CLOCKWISE);
      path1.addCircle(480,510,100,drawing.PathDirection.CLOCKWISE);
      path.op(path1, drawing.PathOp.REVERSE_DIFFERENCE);
      canvas.drawPath(path);
    }
    canvas.detachPen();
  }
}

export class ArkuiXPathAddArc extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path = new drawing.Path();
    let rect: common2D.Rect = { left:100, top:100, right:500, bottom:500 };
    path.addArc(rect, 90, 50);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathAddCircle extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path = new drawing.Path();
    path.addCircle(200, 200, 100, drawing.PathDirection.CLOCKWISE);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathAddOval extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path = new drawing.Path();
    let rect: common2D.Rect = { left: 10, right: 200, top: 100, bottom: 200 };
    path.addOval(rect, 10, drawing.PathDirection.CLOCKWISE);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathAddRect extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path = new drawing.Path();
    let rect: common2D.Rect = { left: 10, right: 200, top: 100, bottom: 300 };
    path.addRect(rect, drawing.PathDirection.CLOCKWISE);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathAddRoundRect extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path = new drawing.Path();
    let rect: common2D.Rect = { left: 10, right: 200, top: 100, bottom: 300 };
    let roundRect = new drawing.RoundRect(rect, 10, 10);
    path.addRoundRect(roundRect, drawing.PathDirection.CLOCKWISE);
    canvas.drawPath(path);
  }
}


export class ArkuiXPathAddPath extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(100,100);
    let path1 = new drawing.Path();
    path1.moveTo(100, 100);
    path1.lineTo(150,200);
    path.addPath(path1,null);
    canvas.drawPath(path);
    let matrix  = new drawing.Matrix();
    matrix.setScale(2, 2, 0, 0);
    path.addPath(path1, matrix);
    canvas.translate(200,0);
    canvas.drawPath(path);
    canvas.restore();
    path.addPath(path1);
    canvas.translate(0,400);
    canvas.drawPath(path);
    canvas.restore();
    canvas.detachPen();
  }
}

export class ArkuiXPathTransform extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path = new drawing.Path();
    let matrix = new drawing.Matrix();
    matrix.setScale(1.5, 1.5, 10, 10);
    const rect: common2D.Rect = {left:100, top:100, right:400, bottom:400};
    let roundRect = new drawing.RoundRect(rect, 50, 50);
    path.addRoundRect(roundRect, drawing.PathDirection.CLOCKWISE);
    path.transform(matrix);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathContains extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path = new drawing.Path();
    path.moveTo(100, 100);
    path.lineTo(300,300);
    canvas.drawPath(path);
    printResults(canvas, path.contains(100, 100));
    canvas.translate(0,400);
    canvas.drawPath(path);
    printResults(canvas, !path.contains(44, 0));
    canvas.restore();
    canvas.detachPen();
  }
}

export class ArkuiXPathSetFillType extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
      setPen(canvas);
      let brush = new drawing.Brush();
      brush.setColor(0xFFFF0000);
      canvas.attachBrush(brush);
    {
      let path = new drawing.Path();
      path.addCircle(100, 100, 100, drawing.PathDirection.CLOCKWISE);
      path.addCircle(130, 130, 100, drawing.PathDirection.CLOCKWISE);
      path.setFillType(drawing.PathFillType.EVEN_ODD);
      canvas.drawPath(path);
    }
    {
      let path = new drawing.Path();
      path.addCircle(100, 350, 100, drawing.PathDirection.CLOCKWISE);
      path.addCircle(130, 380, 100, drawing.PathDirection.CLOCKWISE);
      path.setFillType(drawing.PathFillType.WINDING);
      canvas.drawPath(path);
    }
    canvas.detachBrush();
    canvas.detachPen();
  }
}

export class ArkuiXPathClose extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let path: drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(100, 100);
    path.lineTo(200, 0);
    path.close();
    canvas.drawPath(path);
  }
}

export class ArkuiXPathOffset extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(100, 100);
    path.lineTo(200, 0);
    let path1 =  path.offset(200,200);
    canvas.drawPath(path);
    canvas.drawPath(path1);
    canvas.detachPen();
  }
}

export class ArkuiXPathReset extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    canvas.attachPen(pen);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(100, 100);
    path.lineTo(300, 300);
    path.reset();
    canvas.drawPath(path);
    path.moveTo(100, 200);
    path.lineTo(200, 400);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathIsClosed extends TestBase {
  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let path: drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(0, this.height_);
    path.lineTo(this.width_, 0);
    path.close();
    let flags = path.isClosed();
    canvas.drawPath(path);
    if (flags) {
      console.log("DrawingTestArkuiX000" + " path is closed.");
    } else {
      console.log("DrawingTestArkuiX000" + " path is not closed.");
    }
  }
}

export class ArkuiXPathGetPositionAndTangent extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let pen: drawing.Pen = new drawing.Pen();
    canvas.attachPen(pen);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(100, 100);
    let position = {x:0,y:0};
    let position1 = {x:0,y:0};
    let tangent = {x:0,y:0};
    let tangent1 = {x:0,y:0};
    let flags = path.getPositionAndTangent(false, 30, position, tangent);
    if (flags) {
      console.log("DrawingTestArkuiX000" + " getPositionAndTangent.positionX = "+ position.x);
      console.log("DrawingTestArkuiX000" + " getPositionAndTangent.positionY = "+ position.y);
      console.log("DrawingTestArkuiX000" + " getPositionAndTangent.tangentX = "+ tangent.x);
      console.log("DrawingTestArkuiX000" + " getPositionAndTangent.tangentY = "+ tangent.y);
    }
    printResults(canvas, (position != position1 && tangent != tangent1))
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathGetSegment extends TestBase {
  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(100, 100);
    path.lineTo(200, 200);
    let path1: drawing.Path = new drawing.Path();
    path1.moveTo(200, 200);
    path1.lineTo(210, 230);
    let flags = path1.getSegment(false, 0, 20, true, path);
    console.log("DrawingTestArkuiX000" + " getSegment:", flags);
    printResults(canvas, flags);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathGetMatrix extends TestBase {
  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(0, 0);
      path.lineTo(0, this.height_);
      path.lineTo(this.width_, 0);
      let matrixRes = new drawing.Matrix();
      let flags = path.getMatrix(false, 10, matrixRes, drawing.PathMeasureMatrixFlags.GET_POSITION_MATRIX);
      if (flags) {
        canvas.drawPath(path);
      }
    }
  }
}

export class ArkuiXPathBuildFromSvgString extends TestBase {
  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let path: drawing.Path = new drawing.Path();
    let svgStr: string = "M150 100 L75 300 L225 300 Z";
    let flags = path.buildFromSvgString(svgStr);
    canvas.drawPath(path);
    if (flags) {
      console.log("DrawingTestArkuiX000" + " buildFromSvgString return true");
    } else {
      console.log("DrawingTestArkuiX000" + " buildFromSvgString return false");
    }
  }
}

export class ArkuiXPathConstructor extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(0, this.height_);
    path.lineTo(this.width_, 0);
    path.close();
    let path2: drawing.Path;
    path2 = new drawing.Path(path);
    canvas.drawPath(path2);
    canvas.detachPen();
  }
}

export class ArkuiXPathGetBounds extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(50,50);
    path.lineTo(200, 400)
    let rect : common2D.Rect = {left: 100, top: 100, right: 400, bottom: 400};
    rect = path.getBounds();
    console.log("DrawingTestArkuiX000" + " test rect.left: " + rect.left);
    console.log("DrawingTestArkuiX000" + " test rect.top: " + rect.top);
    console.log("DrawingTestArkuiX000" + " test rect.right: " + rect.right);
    console.log("DrawingTestArkuiX000" + " test rect.bottom: " + rect.bottom);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathGetPathIterator extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setAntiAlias(true);
    pen.setColor({ alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 });
    pen.setStrokeWidth(5.0);
    canvas.attachPen(pen);
    let path: drawing.Path = new drawing.Path();
    path.moveTo(0, 0);
    path.lineTo(100, 100);
    let iter = path.getPathIterator();
    let verb = iter.peek();
    console.log("DrawingTestArkuiX000" + "PathGetPathIterator: verb = ", verb);
    canvas.drawPath(path);
  }
}

export class ArkuiXPathGetLength extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let path = new drawing.Path();
    path.arcTo(100, 100, 300, 300, 180, 90);
    let len = path.getLength(false);
    console.log("DrawingTestArkuiX000" + "path length = " + len);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXPathDirection extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path = new drawing.Path();
      path.addCircle(300, 200, 100, drawing.PathDirection.CLOCKWISE);
      canvas.drawPath(path);
    }
    {
      let path = new drawing.Path();
      path.addCircle(300, 450, 100, drawing.PathDirection.COUNTER_CLOCKWISE);
      canvas.drawPath(path);
    }
    canvas.detachPen();
  }
}

export class ArkuiXPathMeasureMatrixFlags extends TestBase {
  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(100, 100);
      path.lineTo(200, 300);
      path.lineTo(100, 150);
      path.close();
      let matrixRes = new drawing.Matrix();
      let flags = path.getMatrix(false, 10, matrixRes, drawing.PathMeasureMatrixFlags.GET_POSITION_MATRIX);
      if (flags) {
        canvas.drawPath(path);
      }
    }

    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(200, 350);
      path.lineTo(300, 550);
      path.lineTo(200, 400);
      path.close();
      let matrixRes = new drawing.Matrix();
      let flags = path.getMatrix(false, 10, matrixRes, drawing.PathMeasureMatrixFlags.GET_TANGENT_MATRIX);
      if (flags) {
        canvas.drawPath(path);
      }
    }

    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(300, 200);
      path.lineTo(400, 400);
      path.lineTo(300, 250);
      path.close();
      let matrixRes = new drawing.Matrix();
      let flags = path.getMatrix(false, 10, matrixRes, drawing.PathMeasureMatrixFlags.GET_POSITION_AND_TANGENT_MATRIX);
      if (flags) {
        canvas.drawPath(path);
      }
    }
  }
}

export class ArkuiXPathSet extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(0, 0);
      path.lineTo(0, 700);
      path.lineTo(700, 0);
      path.close();
      let path1: drawing.Path = new drawing.Path();
      path1.set(path);
      canvas.drawPath(path1);
      canvas.detachPen();
    }
  }
}

export class ArkuiXPathSetLastPoint extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(0, 0);
      path.lineTo(0, 700);
      canvas.drawPath(path);
      path.setLastPoint(50, 50);
      canvas.drawPath(path);
      canvas.detachPen();
    }
  }
}

export class ArkuiXPathGetFillType extends TestBase {

  public constructor(styleType: number) {
    super();
    this.styleType_ = styleType;
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    let brush = new drawing.Brush();
    brush.setColor(0xFFFF0000);
    canvas.attachBrush(brush);
    {
      let path = new drawing.Path();
      path.addCircle(100, 100, 100, drawing.PathDirection.CLOCKWISE);
      path.addCircle(130, 130, 100, drawing.PathDirection.CLOCKWISE);
      path.setFillType(drawing.PathFillType.EVEN_ODD);
      let type = path.getFillType();
      if(type == drawing.PathFillType.EVEN_ODD){
        canvas.drawPath(path);
      }
    }
    canvas.detachBrush();
    canvas.detachPen();
  }
}

export class ArkuiXPathReWindAndIsEmpty extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path = new drawing.Path();
      path.moveTo(10,10);
      path.lineTo(20,20);
      path.rewind();
      let empty = path.isEmpty();
      console.log("DrawingTestArkuiX000" + 'empty : ', empty);
    }
    canvas.detachPen();
  }
}

export class ArkuiXPathIsRect extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path = new drawing.Path();
      path.moveTo(10,10);
      path.lineTo(20,10);
      let isRect = path.isRect(null);
      console.log("DrawingTestArkuiX000" + "isRect: ", isRect);
      let rect: common2D.Rect = { left : 100, top : 100, right : 400, bottom : 500 };
      path.lineTo(20, 20);
      path.lineTo(10, 20);
      path.lineTo(10, 10);
      isRect = path.isRect(rect);
      if (isRect) {
        canvas.drawPath(path);
      }
    }
    canvas.detachPen();
  }
}

export class ArkuiXPathApproximate extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(100, 100);
      path.lineTo(500, 500);
      let points: number[] = path.approximate(0.5);
      for (let i = 0; i < points.length; i += 3) {
        console.log("DrawingTestArkuiX000" + "PathApproximate Fraction =" + points[i] + ", X =" + points[i + 1] + ", Y =" + points[i + 2] + "\n");
      }
    }
    canvas.detachPen();
  }
}

export class ArkuiXPathInterpolate extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(50, 50);
      path.lineTo(100, 100);
      path.lineTo(200, 200);
      let other: drawing.Path = new drawing.Path();
      other.moveTo(80, 80);
      other.lineTo(300, 300);
      other.lineTo(400, 400);
      let interpolatedPath: drawing.Path = new drawing.Path();
      if (path.interpolate(other, 0.0, interpolatedPath)) {
        canvas.drawPath(interpolatedPath);
      } else {
        console.log("DrawingTestArkuiX000" + 'interpolate return false');
      }
    }
    canvas.detachPen();
  }
}

export class ArkuiXPathIsInterpolate extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    setPen(canvas);
    {
      let path: drawing.Path = new drawing.Path();
      path.moveTo(0, 0);
      path.lineTo(100, 100);
      let other: drawing.Path = new drawing.Path();
      other.moveTo(0, 1);
      other.lineTo(200, 200);
      if (path.isInterpolate(other)) {
        canvas.drawPath(path);
      } else {
        console.log("DrawingTestArkuiX000" + 'isInterpolate return false');
      }
    }
    canvas.detachPen();
  }
}