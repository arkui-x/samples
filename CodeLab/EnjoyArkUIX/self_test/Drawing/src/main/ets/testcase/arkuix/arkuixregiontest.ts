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
import { PrintResult } from "./arkuixutils";

const TAG = '[ArkuiXRegionTest]';

export class ArkuiXRegionTest extends TestBase {
  pen_: drawing.Pen;
  brush_: drawing.Brush;
  public constructor() {
    super();
    this.pen_ = new  drawing.Pen();
    this.brush_ = new drawing.Brush();
    this.pen_.setColor({ alpha: 255, red: 255, green: 0, blue: 0 });
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

export class RegionIsPointContainedTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let region = new drawing.Region();
    region.setRect(0, 0, 500, 500);
    let isContained : Boolean = region.isPointContained(100,100);
    let isContained2 : Boolean = region.isPointContained(600,600);
    ArkuiXRegionTest.printResults(canvas, isContained);
    ArkuiXRegionTest.printResults(canvas, !isContained2);
  }
}

export class RegionIsRegionContainedTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let region = new drawing.Region();
    region.setRect(0, 0, 500, 500);
    let region2 = new drawing.Region();
    region2.setRect(200, 200, 300, 300);
    let region3 = new drawing.Region();
    region3.setRect(600, 600, 800, 800);
    let isContained : Boolean = region.isRegionContained(region2);
    let isContained2 : Boolean = region.isRegionContained(region3);
    ArkuiXRegionTest.printResults(canvas, isContained);
    ArkuiXRegionTest.printResults(canvas, !isContained2);
  }
}

export class RegionOpTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let bool : Boolean = false;
    {
      let region = new drawing.Region();
      region.setRect(0, 0, 500, 500);
      let region2 = new drawing.Region();
      region2.setRect(100, 100, 300, 300);
      let isContained : Boolean = region.op(region2, drawing.RegionOp.DIFFERENCE);
      if(isContained) {
        bool = true;
      }
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawRegion(region);
      canvas.detachPen();
      canvas.detachBrush();
    }
    {
      let region = new drawing.Region();
      region.setRect(0, 0, 500, 500);
      let region2 = new drawing.Region();
      region2.setRect(200, 200, 300, 300);
      let isContained : Boolean = region.op(region2, drawing.RegionOp.INTERSECT);
      if(isContained) {
        bool = true;
      }
      this.pen_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });
      this.brush_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawRegion(region);
      canvas.detachPen();
      canvas.detachBrush();
    }
    {
      let region = new drawing.Region();
      region.setRect(0, 0, 500, 500);
      let region2 = new drawing.Region();
      region2.setRect(300, 300, 400, 400);
      let isContained : Boolean = region.op(region2, drawing.RegionOp.UNION);
      if(isContained) {
        bool = true;
      }
      this.pen_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });
      this.brush_.setColor({ alpha: 255, red: 0, green: 255, blue: 0 });
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawRegion(region);
      canvas.detachPen();
      canvas.detachBrush();
    }
    {
      let region = new drawing.Region();
      region.setRect(0, 0, 500, 500);
      let region2 = new drawing.Region();
      region2.setRect(400, 400, 500, 500);
      let isContained : Boolean = region.op(region2, drawing.RegionOp.XOR);
      if(isContained) {
        bool = true;
      }
      this.pen_.setColor({ alpha: 255, red: 0, green: 0, blue: 255 });
      this.brush_.setColor({ alpha: 255, red: 0, green: 0, blue: 255 });
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawRegion(region);
      canvas.detachPen();
      canvas.detachBrush();
    }
    {
      let region = new drawing.Region();
      region.setRect(0, 0, 500, 500);
      let region2 = new drawing.Region();
      region2.setRect(250, 250, 500, 500);
      let isContained : Boolean = region.op(region2, drawing.RegionOp.REVERSE_DIFFERENCE);
      if(!isContained) {
        bool = true;
      }
      this.pen_.setColor({ alpha: 255, red: 150, green: 0, blue: 255 });
      this.brush_.setColor({ alpha: 255, red: 150, green: 0, blue: 255 });
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawRegion(region);
      canvas.detachPen();
      canvas.detachBrush();
    }
    {
      let region = new drawing.Region();
      region.setRect(0, 0, 500, 500);
      let region2 = new drawing.Region();
      region2.setRect(150, 150, 500, 500);
      let isContained : Boolean = region.op(region2, drawing.RegionOp.REPLACE);
      if(isContained) {
        bool = true;
      }
      this.pen_.setColor({ alpha: 255, red: 150, green: 150, blue: 150 });
      this.brush_.setColor({ alpha: 255, red: 150, green: 150, blue: 150 });
      canvas.attachPen(this.pen_);
      canvas.attachBrush(this.brush_);
      canvas.drawRegion(region);
      canvas.detachPen();
      canvas.detachBrush();
    }
    ArkuiXRegionTest.printResults(canvas, bool);
  }
}

export class RegionQuickRejectTest extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let region = new drawing.Region();
    region.setRect(100, 100, 400, 400);
    let flag: boolean = false;
    flag = region.quickReject(50, 50, 70, 70);
    console.log("DrawingTestArkuiX000" + "region quickReject : " + flag);
    canvas.drawRegion(region);
    canvas.detachPen();
  }
}

export class RegionSetPathTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let region = new drawing.Region();
    let path = new drawing.Path();
    region.setRect(100, 100, 400, 400);
    path.arcTo(50, 50, 300, 300, 0, 359);
    let flag: boolean = false;
    flag = region.setPath(path,region);
    console.log("DrawingTestArkuiX000" + "region setPath : " + flag);
    canvas.drawRegion(region);
    canvas.detachPen();
  }
}

export class RegionSetRectTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let region = new drawing.Region();
    let isContained : Boolean = region.setRect(100, 100, 500, 500);
    ArkuiXRegionTest.printResults(canvas, isContained);
    canvas.attachPen(this.pen_);
    canvas.attachBrush(this.brush_);
    canvas.drawRegion(region);
    canvas.detachPen();
    canvas.detachBrush();
  }
}

export class RegionConstructorTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    region.setRect(100, 100, 300, 300);
    canvas.drawRegion(region);
    region.setRect(100, 350, 300, 550);
    let region2 = new drawing.Region(region);
    canvas.drawRegion(region2);
    let region3 = new drawing.Region(350, 200, 550, 400);
    canvas.drawRegion(region3);
    canvas.detachPen();
  }
}

export class RegionIsEqualTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    let other = new drawing.Region();
    region.setRect(100, 100, 400, 400);
    other.setRect(150, 150, 250 ,250);
    let flag: boolean = false;
    flag = region.isEqual(other);
    console.log("DrawingTestArkuiX000" + 'flag: ', flag);
    canvas.drawRegion(region);
    canvas.drawRegion(other);
    canvas.detachPen();
  }
}

export class RegionIsComplexTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    let other = new drawing.Region();
    region.setRect(100, 100, 300, 300);
    region.op(new drawing.Region(200, 200, 400, 400), drawing.RegionOp.UNION);
    let flag: boolean = false;
    flag = region.isComplex();
    console.log("DrawingTestArkuiX000" + 'flag: ', flag);
    canvas.drawRegion(region);
    canvas.drawRegion(other);
    canvas.detachPen();
  }
}

export class RegionIsEmptyTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    canvas.drawRegion(region);
    let flag: boolean = region.isEmpty();
    console.log("DrawingTestArkuiX000" + 'flag: ', flag);
    region.setRect(100, 100, 400, 400);
    flag = region.isEmpty();
    console.log("DrawingTestArkuiX000" + 'flag: ', flag);
    canvas.drawRegion(region);
    canvas.detachPen();
  }
}

export class RegionGetBoundsTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    let other = new drawing.Region();
    region.setRect(100, 100, 300, 300);
    region.op(new drawing.Region(200, 200, 400, 400), drawing.RegionOp.UNION);
    canvas.drawRegion(region);
    canvas.drawRegion(other);
    let rect = region.getBounds();
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class RegionGetBoundaryPathTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    let other = new drawing.Region();
    region.setRect(100, 100, 300, 300);
    region.op(new drawing.Region(200, 200, 400, 400), drawing.RegionOp.UNION);
    canvas.drawRegion(region);
    canvas.drawRegion(other);
    let path = region.getBoundaryPath();
    console.log("DrawingTestArkuiX000" + "path: " + path.isClosed());
    let rect = path.getBounds();
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class RegionOffsetTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    region.setRect(100, 100, 400, 400);
    region.offset(10, 20);
    canvas.drawRegion(region);
    let rect = region.getBounds();
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class RegionQuickRejectRegionTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    let region2 = new drawing.Region();
    region2.setRect(100, 100, 400, 400);
    let flag: boolean = false;
    flag = region.quickRejectRegion(region2);
    console.log("DrawingTestArkuiX000" + "region quickRejectRegion: " + flag);
    canvas.drawRegion(region);
    canvas.drawRegion(region2);
    canvas.detachPen();
  }
}

export class RegionSetRegionTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    region.setRect(100, 100, 400, 400);
    let region2 = new drawing.Region();
    region2.setRegion(region);
    canvas.drawRegion(region2);
    let rect = region2.getBounds();
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}


export class RegionSetEmptyTest extends ArkuiXRegionTest {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.pen_.setStrokeWidth(20.0);
    canvas.attachPen(this.pen_);
    let region = new drawing.Region();
    region.setRect(100, 100, 400, 400);
    let isEmpty = region.isEmpty();
    console.log("DrawingTestArkuiX000" + "isEmpty :" + isEmpty);
    region.setEmpty();
    canvas.drawRegion(region);
    isEmpty = region.isEmpty();
    ArkuiXRegionTest.printResults(canvas, isEmpty);
    console.log("DrawingTestArkuiX000" + "isEmpty :" + isEmpty);
    canvas.detachPen();
  }
}