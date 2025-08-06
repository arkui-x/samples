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

export class ArkuiXDashStyleTranslateTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    const penColor: common2D.Color = { alpha: 255, red: 255, green: 0, blue: 0 }
    pen.setColor(penColor);
    pen.setStrokeWidth(10);
    const path = new drawing.Path();
    path.moveTo(50, 50);
    path.lineTo(200, 100);
    path.lineTo(100, 200);
    path.close();
    let pathEffect: drawing.PathEffect = drawing.PathEffect.createPathDashEffect(path, 10, 5,
      drawing.PathDashStyle.TRANSLATE);
    pen.setPathEffect(pathEffect);
    canvas.attachPen(pen);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXDashStyleMorphTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    const penColor: common2D.Color = { alpha: 255, red: 255, green: 0, blue: 0 }
    pen.setColor(penColor);
    pen.setStrokeWidth(10);
    const path = new drawing.Path();
    path.moveTo(50, 50);
    path.lineTo(200, 100);
    path.lineTo(100, 200);
    path.close();
    let pathEffect: drawing.PathEffect = drawing.PathEffect.createPathDashEffect(path, 10, 5,
      drawing.PathDashStyle.MORPH);
    pen.setPathEffect(pathEffect);
    canvas.attachPen(pen);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}

export class ArkuiXDashStyleRotateTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    const penColor: common2D.Color = { alpha: 255, red: 255, green: 0, blue: 0 }
    pen.setColor(penColor);
    pen.setStrokeWidth(10);
    const path = new drawing.Path();
    path.moveTo(50, 50);
    path.lineTo(200, 100);
    path.lineTo(100, 200);
    path.close();
    let pathEffect: drawing.PathEffect = drawing.PathEffect.createPathDashEffect(path, 10, 5,
      drawing.PathDashStyle.ROTATE);
    pen.setPathEffect(pathEffect);
    canvas.attachPen(pen);
    canvas.drawPath(path);
    canvas.detachPen();
  }
}
