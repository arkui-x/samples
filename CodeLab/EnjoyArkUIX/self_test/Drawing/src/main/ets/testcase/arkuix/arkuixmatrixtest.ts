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
import { common2D } from "@kit.ArkGraphics2D";

const TAG = '[ArkuiXMatrixTest]';

export class ArkuiXMatrixTest extends TestBase {

  public constructor() {
    super();
  }

  public static printResults(canvas: drawing.Canvas, isPassed: Boolean) {
    let font: drawing.Font = new drawing.Font();
    font.setSize(50);
    let blob: drawing.TextBlob = drawing.TextBlob.makeFromString(isPassed ? "Passed": "Not Passed",
      font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    canvas.drawTextBlob(blob, 100, 500);
  }

  public static checkMatrix(actualMatrix : drawing.Matrix, expectedValues: Array<number>): boolean {
    let failure: boolean = false;
    let fractionDigits: number = 5;
    for (let i = 0; i < expectedValues.length; i++) {
      if (actualMatrix.getValue(i).toFixed(fractionDigits) != expectedValues[i].toFixed(fractionDigits) ) {
        failure = true;
        console.log("DrawingTestArkuiX000" + TAG, " The matrix[" + i + "] is incorrect (actual: " + actualMatrix.getValue(i)
          + ", expected: " + expectedValues[i] + ")");
      }
    }
    return !failure;
  }

}

export class MatrixSetRotationTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let degree: number = 2;
    let px: number = 3;
    let py: number = 4;
    matrix.setRotation(degree, px, py);

    let c = Math.cos(degree * Math.PI / 180);
    let s = Math.sin(degree * Math.PI / 180);
    let dx = s * py + (1 - c) * px;
    let dy = -s * px + (1 - c) * py;
    let expectedValues: Array<number> = [c, -s, dx, s, c, dy, 0, 0, 1];

    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixSetScaleTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let sx: number = 2;
    let sy: number = 0.5;
    let px: number = 1;
    let py: number = 1;
    let dx = px - sx * px;
    let dy = py - sy * py;
    matrix.setScale(sx, sy, px, py);
    let expectedValues: Array<number> = [sx, 0, dx, 0, sy, dy, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixSetTranslationTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let dx: number = 3;
    let dy: number = 4;
    matrix.setTranslation(dx, dy);
    let expectedValues: Array<number> = [1, 0, dx, 0, 1, dy, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixSetMatrixTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let values: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    matrix.setMatrix(values);
    let expectedValues: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixPreConcatTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let values: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    let matrix2 = new drawing.Matrix();
    matrix2.setMatrix(values);
    matrix.preConcat(matrix2);
    let expectedValues: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixIsEqualTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let values: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    let matrix1 = new drawing.Matrix();
    matrix1.setMatrix(values);
    let matrix2 = new drawing.Matrix();
    matrix2.setMatrix(values);
    let isEqual : Boolean =matrix1.isEqual(matrix2);
    ArkuiXMatrixTest.printResults(canvas, isEqual);
  }
}

export class MatrixInvertTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let values: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    let matrix = new drawing.Matrix();
    let matrix2 = new drawing.Matrix();
    matrix.setMatrix(values);
    matrix.invert(matrix2);
    let expectedValues: Array<number> = [0.5, 0, -1.5, 0, 1, -4, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix2, expectedValues));
  }
}

export class MatrixIsIdentityTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let isIdentity : Boolean = matrix.isIdentity();
    ArkuiXMatrixTest.printResults(canvas, isIdentity);
  }
}

export class MatrixGetValueTest extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let expectedValues: Array<number> = [1, 0, 0, 0, 1, 0, 0, 0, 1];
    let matrix = new drawing.Matrix();

    let failure: boolean = false;
    for (let i = 0; i < expectedValues.length; i++) {
      if (matrix.getValue(i) != expectedValues[i]) {
        failure = true;
        console.log("DrawingTestArkuiX000" + TAG, " The matrix[" + i + "] is incorrect (actual: " + matrix.getValue(i)
          + ", expected: " + expectedValues[i] + ")");
      }
    }
    ArkuiXMatrixTest.printResults(canvas, !failure);
  }
}

export class MatrixPostRotateTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let degree: number = 2;
    let px: number = 3;
    let py: number = 4;
    matrix.postRotate(degree, px, py);

    let c = Math.cos(degree * Math.PI / 180);
    let s = Math.sin(degree * Math.PI / 180);
    let dx = s * py + (1 - c) * px;
    let dy = -s * px + (1 - c) * py;
    let expectedValues: Array<number> = [c, -s, dx, s, c, dy, 0, 0, 1];

    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixPostScaleTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let sx: number = 2;
    let sy: number = 0.5;
    let px: number = 1;
    let py: number = 1;

    let dx = px - sx * px;
    let dy = py - sy * py;
    matrix.preScale(sx, sy, px, py);

    let expectedValues: Array<number> = [sx, 0, dx, 0, sy, dy, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }

}

export class MatrixPostTranslateTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let dx: number = 3;
    let dy: number = 4;
    matrix.postTranslate(dx, dy);
    let expectedValues: Array<number> = [1, 0, dx, 0, 1, dy, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixPreRotateTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let degree: number = 2;
    let px: number = 3;
    let py: number = 4;
    matrix.preRotate(degree, px, py);

    let c = Math.cos(degree * Math.PI / 180);
    let s = Math.sin(degree * Math.PI / 180);
    let dx = s * py + (1 - c) * px;
    let dy = -s * px + (1 - c) * py;
    let expectedValues: Array<number> = [c, -s, dx, s, c, dy, 0, 0, 1];

    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixPreScaleTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let sx: number = 2;
    let sy: number = 0.5;
    let px: number = 1;
    let py: number = 1;

    let dx = px - sx * px;
    let dy = py - sy * py;
    matrix.preScale(sx, sy, px, py);

    let expectedValues: Array<number> = [sx, 0, dx, 0, sy, dy, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixPreTranslateTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let dx: number = 3;
    let dy: number = 4;
    matrix.preTranslate(dx, dy);

    let expectedValues: Array<number> = [1, 0, dx, 0, 1, dy, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixResetTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let expectedValues: Array<number> = [1, 0, 0, 0, 1, 0, 0, 0, 1];
    let matrix = new drawing.Matrix();
    matrix.postRotate(2, 3, 4);
    matrix.reset();
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixMapPointsTest extends TestBase {

  public constructor(){
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      let matrix = new drawing.Matrix();
      canvas.setMatrix(matrix);
      let src: Array<common2D.Point> = [{x: 300, y:500}, {x: 100, y:150}, {x: 50, y:400}];
      let dst: Array<common2D.Point> = matrix.mapPoints(src);
      if (dst.length != 3) {
        console.error(TAG, ' Invalid dst length!');
        ArkuiXMatrixTest.printResults(canvas, false);
      } else {
        let pen = new drawing.Pen();
        pen.setStrokeWidth(10);
        let brush: drawing.Brush = new drawing.Brush();
        brush.setColor({
          alpha: 255,
          red: 0,
          green: 0,
          blue: 255
        });
        canvas.attachPen(pen);
        canvas.attachBrush(brush);
        dst.forEach(point => {
          canvas.drawPoint(point.x, point.y)
        });
        canvas.detachPen();
        canvas.detachBrush();
      }
    }
  }
}

export class MatrixGetAllTest extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let failure: boolean = false;
    let matrix = new drawing.Matrix();
    let expectedValues: Array<number> = [1, 0, 0, 0, 1, 0, 0, 0, 1];

    let actualValues = matrix.getAll();
    if (actualValues.length != expectedValues.length) {
      failure = true;
      console.log("DrawingTestArkuiX000" + TAG, " The length of returned array is incorrect (actual: " + actualValues.length
        + ", expected: " + expectedValues.length  + ")");
    } else {
      for (let i = 0; i < actualValues.length; i++) {
        if (actualValues[i] != expectedValues[i]) {
          failure = true;
          console.log("DrawingTestArkuiX000" + TAG, " The matrix[" + i + "] is incorrect (actual: " + actualValues[i]
            + ", expected: " + expectedValues[i] + ")");
        }
      }
    }
    ArkuiXMatrixTest.printResults(canvas, !failure);
  }
}

export class MatrixMapRectTest extends TestBase {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let dst: common2D.Rect = { left: 100, top: 20, right: 130, bottom: 60 };
    let src: common2D.Rect = { left: 100, top: 80, right: 130, bottom: 120 };
    let brush = new drawing.Brush();
    let color: common2D.Color = { alpha: 255, red: 0, green: 255, blue: 0 };
    let matrix = new drawing.Matrix();
    canvas.setMatrix(matrix);
    brush.setColor(color);
    canvas.attachBrush(brush);
    console.log("DrawingTestArkuiX000" + TAG, " matrix.mapRect");
    if (matrix.mapRect(dst, src)) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.drawRect");
      canvas.drawRect(dst);
    }
    canvas.detachBrush();
  }
}

export class MatrixSetRectToRectTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let src: common2D.Rect = { left: 100, top: 20, right: 130, bottom: 60 };
    let dst: common2D.Rect = { left: 100, top: 80, right: 130, bottom: 120 };
    let dst1: common2D.Rect = { left: 150, top: 100, right: 180, bottom: 200 };
    let dst2: common2D.Rect = { left: 200, top: 200, right: 230, bottom: 220 };
    let dst3: common2D.Rect = { left: 300, top: 380, right: 430, bottom: 420 };
    let stf: drawing.ScaleToFit = drawing.ScaleToFit.FILL_SCALE_TO_FIT;
    let stf1: drawing.ScaleToFit = drawing.ScaleToFit.START_SCALE_TO_FIT;
    let stf2: drawing.ScaleToFit = drawing.ScaleToFit.CENTER_SCALE_TO_FIT;
    let stf3: drawing.ScaleToFit = drawing.ScaleToFit.END_SCALE_TO_FIT;
    let brush = new drawing.Brush();
    let color: common2D.Color = { alpha: 255, red: 0, green: 255, blue: 0 };
    let matrix = new drawing.Matrix();
    canvas.setMatrix(matrix);
    brush.setColor(color);
    canvas.attachBrush(brush);
    console.log("DrawingTestArkuiX000" + TAG, " matrix.setRectToRect1");
    if (matrix.setRectToRect(src, dst, stf)) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.drawRect");
      canvas.drawRect(dst);
    }
    if (matrix.setRectToRect(src, dst1, stf1)) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.drawRect");
      canvas.drawRect(dst1);
    }
    if (matrix.setRectToRect(src, dst2, stf2)) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.drawRect");
      canvas.drawRect(dst2);
    }
    if (matrix.setRectToRect(src, dst3, stf3)) {
      console.log("DrawingTestArkuiX000" + TAG, " canvas.drawRect");
      canvas.drawRect(dst3);
    }
    canvas.detachBrush();
  }
}

export class MatrixSetPolyToPolyTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let srcPoints: Array<common2D.Point> = [ { x: 0, y: 20 }, { x: 200, y: 60 } ];
    let dstPoints: Array<common2D.Point> = [ { x:100, y: 40 }, { x:300, y: 80 } ];
    let pen = new drawing.Pen();
    let color: common2D.Color = { alpha: 255, red: 0, green: 255, blue: 0 };
    let matrix = new drawing.Matrix();

    pen.setColor(color);
    canvas.attachPen(pen);
    console.log("DrawingTestArkuiX000" + TAG, "matrix.setPolyToPoly1");
    let result: boolean = false;
    try {
      if (matrix.setPolyToPoly(srcPoints, dstPoints, 2)) {
        console.log("DrawingTestArkuiX000" + TAG, "canvas.drawLine(dstPoints");
        canvas.setMatrix(matrix);
        canvas.drawLine(200, 200, 300, 300);
        result = true;
      }
    } catch(err) {
      console.error("Matrix.setPolyToPoly exception: ", err.name, ":", err.message, err.stack);
    }
    canvas.detachBrush();
    ArkuiXMatrixTest.printResults(canvas, result);
  }
}

export class MatrixConstructorTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let values: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    matrix.setMatrix(values);
    let matrix2 = new drawing.Matrix(matrix);
    let expectedValues: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix2, expectedValues));
  }
}

export class MatrixIsAffineTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.setMatrix([1, 0.5, 1, 0.5, 1, 1, 0, 0, 1]);
    let isAff = matrix.isAffine();
    if(isAff) {
      let expectedValues: Array<number> = [1, 0.5, 1, 0.5, 1, 1, 0, 0, 1];
      ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
    } else {
      console.log("DrawingTestArkuiX000" + 'isAff :', isAff);
    }
  }
}

export class MatrixRectStaysRectTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.setMatrix([1, 0, 0, 0, 1, 0, 0, 0, 1]);
    let matrix2 = new drawing.Matrix(matrix);
    let isRect = matrix2.rectStaysRect();
    if(isRect) {
      let expectedValues: Array<number> = [1, 0, 0, 0, 1, 0, 0, 0, 1];
      ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
    } else {
      console.log("DrawingTestArkuiX000" + 'isRect :', isRect);
    }
  }
}

export class MatrixSetSkewTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.setMatrix([1, 0.5, 1, 0.5, 1, 1, 1, 1, 1]);
    matrix.setSkew(2, 0.5, 0.5, 2);
    let expectedValues: Array<number> = [1, 2, -4, 0.5, 1, -0.25, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixSetSinCosTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.setMatrix([1, 0.5, 1, 0.5, 1, 1, 1, 1, 1]);
    matrix.setSinCos(0, 1, 1, 0);
    let expectedValues: Array<number> = [1, 0, 0, 0, 1, 0, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixSetMatrixWithMatrixTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    let values: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    matrix.setMatrix(values);
    let matrix2 = new drawing.Matrix();
    matrix2.setMatrix(matrix);
    let expectedValues: Array<number> = [2, 0, 3, 0, 1, 4, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix2, expectedValues));
  }
}

export class MatrixSetConcatTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix1 = new drawing.Matrix();
    matrix1.setMatrix([2, 1, 3, 1, 2, 1, 3, 1, 2]);
    let matrix2 = new drawing.Matrix();
    matrix2.setMatrix([-2, 1, 3, 1, 0, -1, 3, -1, 2]);
    matrix1.setConcat(matrix2, matrix1);
    let expectedValues: Array<number> = [6, 3, 1, -1, 0, 1, 11, 3, 12];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix1, expectedValues));
  }
}

export class MatrixPostConcatTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix1 = new drawing.Matrix();
    matrix1.setMatrix([2, 1, 3, 1, 2, 1, 3, 1, 2]);
    let matrix2 = new drawing.Matrix();
    matrix2.setMatrix([-2, 1, 3, 1, 0, -1, 3, -1, 2]);
    matrix1.postConcat(matrix2);
    let expectedValues: Array<number> = [6, 3, 1, -1, 0, 1, 11, 3, 12];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix1, expectedValues));
  }
}

export class MatrixPreSkewTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.preSkew(2.0, 1.0, 2.0, 1.0);
    let expectedValues: Array<number> = [1, 2, -2, 1, 1, -2, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixPostSkewTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.postSkew(2.0, 1.0, 2.0, 1.0);
    let expectedValues: Array<number> = [1, 2, -2, 1, 1, -2, 0, 0, 1];
    ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
  }
}

export class MatrixMapRadiusTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let matrix = new drawing.Matrix();
    matrix.setMatrix([2, 1, 0, 1, 2, 0, 0, 0, 1]);
    let radius = matrix.mapRadius(10);
    if (radius > 22) {
      let expectedValues: Array<number> = [2, 1, 0, 1, 2, 0, 0, 0, 1];
      ArkuiXMatrixTest.printResults(canvas, ArkuiXMatrixTest.checkMatrix(matrix, expectedValues));
    } else {
      console.log("DrawingTestArkuiX000" + 'radius', radius);
    }
  }
}




