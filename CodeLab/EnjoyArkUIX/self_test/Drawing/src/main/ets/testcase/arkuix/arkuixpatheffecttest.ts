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

export class ArkuiXDashPathEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen =new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let pathEffect = drawing.PathEffect.createDashPathEffect([30, 10], 0);
    pen.setPathEffect(pathEffect);
    canvas.attachPen(pen);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachPen();
  }
}

export class ArkuiXPathDashEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    canvas.detachBrush();
    let pen = new drawing.Pen();
    pen.setAntiAlias(true);
    const penColor: common2D.Color = { alpha: 255, red: 255, green: 0, blue: 0 }
    pen.setColor(penColor);
    pen.setStrokeWidth(2);
    const path = new drawing.Path();
    path.moveTo(5, 5);
    path.lineTo(20, 10);
    path.lineTo(10, 20);
    path.close();
    let pathEffect: drawing.PathEffect = drawing.PathEffect.createPathDashEffect(path, 40, 0,
      drawing.PathDashStyle.TRANSLATE);
    pen.setPathEffect(pathEffect);
    let rect1: common2D.Rect = { left: 150, top: 150, right: 250, bottom: 250 };

    canvas.attachPen(pen);
    canvas.drawRect(rect1);
    canvas.detachPen();
  }
}

export class ArkuiXCornerPathEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen =new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let effect = drawing.PathEffect.createCornerPathEffect(30);
    pen.setPathEffect(effect);
    canvas.attachPen(pen);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachPen();
  }
}

export class ArkuiXDiscretePathEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen =new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let effect = drawing.PathEffect.createDiscretePathEffect(100, -50, 0);
    pen.setPathEffect(effect);
    canvas.attachPen(pen);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachPen();
  }
}

export class ArkuiXComposePathEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen =new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let pathEffect1 = drawing.PathEffect.createCornerPathEffect(100);
    let pathEffect2 = drawing.PathEffect.createCornerPathEffect(30);
    let effect = drawing.PathEffect.createComposePathEffect(pathEffect1, pathEffect2);
    pen.setPathEffect(effect);
    canvas.attachPen(pen);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachPen();
  }
}

export class ArkuiXSumPathEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen =new drawing.Pen();
    pen.setStrokeWidth(20.0);
    pen.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let path: drawing.Path = new drawing.Path();
    path.moveTo(100, 100);
    path.lineTo(400, 100);
    path.lineTo(400, 400);
    path.lineTo(100, 400);
    path.close();
    let intervals = [10, 5];
    let pathEffectOne = drawing.PathEffect.createDashPathEffect(intervals, 2);
    let pathEffectTwo = drawing.PathEffect.createDashPathEffect(intervals, 3);
    let effect = drawing.PathEffect.createSumPathEffect(pathEffectOne, pathEffectTwo);
    pen.setPathEffect(effect);
    canvas.attachPen(pen);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}