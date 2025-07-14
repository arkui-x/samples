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

export class ArkuiXMakeEmptyTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeEmpty();
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + " rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXMakeLtrbTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + " rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXMakeCopyTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    let rect2 = drawing.RectUtils.makeCopy(rect);
    canvas.attachPen(pen);
    canvas.drawRect(rect2);
    console.log("DrawingTestArkuiX000" + " rect2.left: " + rect2.left + ", rect2.top: " + rect2.top + ", rect2.right: "
      + rect2.right + ", rect2.bottom: " + rect2.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXGetWidthTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 300, 300);
    let rect2 = drawing.RectUtils.makeLtrb(300, 400, 100, 600);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    let width = drawing.RectUtils.getWidth(rect);
    console.log("DrawingTestArkuiX000" + ' width ：', width);
    canvas.drawRect(rect2);
    let width2 = drawing.RectUtils.getWidth(rect2);
    console.log("DrawingTestArkuiX000" + ' width2 ：', width2);
    canvas.detachPen();
  }
}

export class ArkuiXGetHeightTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 300, 300);
    let rect2 = drawing.RectUtils.makeLtrb(100, 600, 300, 400);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    let height = drawing.RectUtils.getHeight(rect);
    console.log("DrawingTestArkuiX000" + ' height ：', height);
    canvas.drawRect(rect2);
    let height2 = drawing.RectUtils.getHeight(rect2);
    console.log("DrawingTestArkuiX000" + ' height2 ：', height2);
    canvas.detachPen();
  }
}

export class ArkuiXCenterXYTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    let centerX = drawing.RectUtils.centerX(rect);
    let centerY = drawing.RectUtils.centerX(rect);
    console.log("DrawingTestArkuiX000" + " centerX: " + centerX);
    console.log("DrawingTestArkuiX000" + " centerY: " + centerY);
    canvas.detachPen();
  }
}

export class ArkuiXContainsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 300, 300);
    let rect2 = drawing.RectUtils.makeLtrb(100, 400, 300, 600);
    let rect3 = drawing.RectUtils.makeLtrb(400, 300, 600, 500);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    canvas.drawRect(rect2);
    let isContains = drawing.RectUtils.contains(rect, rect2);
    if(isContains == true){
      console.log("DrawingTestArkuiX000" + ' rect contains rect2');
    } else {
      console.log("DrawingTestArkuiX000" + ' rect not contains rect2');
    }
    canvas.drawRect(rect3);
    let isContains2 = drawing.RectUtils.contains(rect3, 430, 330, 570, 470);
    if(isContains2 === true){
      console.log("DrawingTestArkuiX000" + ' rect3 contains');
    } else {
      console.log("DrawingTestArkuiX000" + ' rect3 not contains');
    }

    if(drawing.RectUtils.contains(rect, 10, 20)){
      console.log("DrawingTestArkuiX000" + ' rect contains this point');
    } else {
      console.log("DrawingTestArkuiX000" + 'rect not contains this point');
    }
    if(drawing.RectUtils.contains(rect, 200, 200)){
      console.log("DrawingTestArkuiX000" + ' rect contains this point');
    } else {
      console.log("DrawingTestArkuiX000" + ' rect not contains this point');
    }
    canvas.detachPen();
  }
}

export class ArkuiXInsetTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 300, 300);
    drawing.RectUtils.inset(rect, 10, -20, 30, 60);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXIntersectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    let rect2 = drawing.RectUtils.makeLtrb(200, 300, 500, 600);
    let intersect = drawing.RectUtils.intersect(rect, rect2);
    let isIntersect = drawing.RectUtils.isIntersect(rect, rect2);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + 'intersect :', intersect);
    console.log("DrawingTestArkuiX000" + 'isIntersect :', isIntersect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXUnionTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    let rect2 = drawing.RectUtils.makeLtrb(200, 300, 500, 600);
    drawing.RectUtils.union(rect, rect2);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXIsEmptyTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeEmpty();
    let isEmpty = drawing.RectUtils.isEmpty(rect);
    console.log("DrawingTestArkuiX000" + 'isEmpty :', isEmpty);
    let rect2 = drawing.RectUtils.makeLtrb(200, 300, 500, 600);
    isEmpty = drawing.RectUtils.isEmpty(rect2);
    console.log("DrawingTestArkuiX000" + 'isEmpty :', isEmpty);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    canvas.drawRect(rect2);
    canvas.detachPen();
  }
}

export class ArkuiXOffsetTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    drawing.RectUtils.offset(rect, 10, 20);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXOffsetToTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    drawing.RectUtils.offsetTo(rect, 50, 50);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXSetRectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    let rect2 = drawing.RectUtils.makeEmpty();
    drawing.RectUtils.setRect(rect, rect2);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}


export class ArkuiXSetLtrbTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    drawing.RectUtils.setLtrb(rect, 50, 50, 350, 350);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXSetEmptyTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    drawing.RectUtils.setEmpty(rect);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXSortTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(400, 400, 100, 100);
    drawing.RectUtils.sort(rect);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    console.log("DrawingTestArkuiX000" + "rect.left: " + rect.left + ", rect.top: " + rect.top + ", rect.right: "
      + rect.right + ", rect.bottom: " + rect.bottom);
    canvas.detachPen();
  }
}

export class ArkuiXIsEqualTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let rect = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    let rect2 = drawing.RectUtils.makeEmpty();
    let rect3 = drawing.RectUtils.makeLtrb(100, 100, 400, 400);
    canvas.attachPen(pen);
    canvas.drawRect(rect);
    canvas.drawRect(rect2);
    canvas.drawRect(rect3);
    let isEqual = drawing.RectUtils.isEqual(rect, rect2);
    console.log("DrawingTestArkuiX000" + 'isEqual :', isEqual);
    isEqual = drawing.RectUtils.isEqual(rect, rect3);
    console.log("DrawingTestArkuiX000" + 'isEqual :', isEqual);
    canvas.detachPen();
  }
}
