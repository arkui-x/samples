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

export class ArkuiXShadowFlagTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    let pen_color : common2D.Color = { alpha: 0xFF, red: 0xFF, green: 0x00, blue: 0x00 };
    pen.setColor(pen_color);
    pen.setStrokeWidth(10.0);
    canvas.attachPen(pen);
    let brush = new drawing.Brush();
    let brush_color : common2D.Color = { alpha: 0xFF, red: 0x00, green: 0xFF, blue: 0x00 };
    brush.setColor(brush_color);
    canvas.attachBrush(brush);
    {
      let path = new drawing.Path();
      path.addCircle(200, 200, 100, drawing.PathDirection.CLOCKWISE);
      let point1 : common2D.Point3d = {x: 100, y: 80, z:80};
      let point2 : common2D.Point3d = {x: 200, y: 10, z:40};
      let color1 : common2D.Color = {alpha: 0xFF, red:0, green:0, blue:0xFF};
      let color2 : common2D.Color = {alpha: 0xFF, red:0xFF, green:0, blue:0};
      let shadowFlag : drawing.ShadowFlag = drawing.ShadowFlag.NONE;
      canvas.drawShadow(path, point1, point2, 10, color1, color2, shadowFlag);
    }
    {
      let path = new drawing.Path();
      path.addCircle(450, 200, 100, drawing.PathDirection.CLOCKWISE);
      let point1 : common2D.Point3d = {x: 400, y: 80, z:80};
      let point2 : common2D.Point3d = {x: 400, y: 10, z:40};
      let color1 : common2D.Color = {alpha: 0xFF, red:0, green:0, blue:0xFF};
      let color2 : common2D.Color = {alpha: 0xFF, red:0xFF, green:0, blue:0};
      let shadowFlag : drawing.ShadowFlag = drawing.ShadowFlag.ALL;
      canvas.drawShadow(path, point1, point2, 10, color1, color2, shadowFlag);
    }
    {
      let path = new drawing.Path();
      path.addCircle(200, 500, 100, drawing.PathDirection.CLOCKWISE);
      let point1 : common2D.Point3d = {x: 100, y: 400, z:80};
      let point2 : common2D.Point3d = {x: 200, y: 400, z:40};
      let color1 : common2D.Color = {alpha: 0xFF, red:0, green:0, blue:0xFF};
      let color2 : common2D.Color = {alpha: 0xFF, red:0xFF, green:0, blue:0};
      let shadowFlag : drawing.ShadowFlag = drawing.ShadowFlag.TRANSPARENT_OCCLUDER;
      canvas.drawShadow(path, point1, point2, 10, color1, color2, shadowFlag);
    }
    {
      let path = new drawing.Path();
      path.addCircle(450, 500, 100, drawing.PathDirection.CLOCKWISE);
      let point1 : common2D.Point3d = {x: 400, y: 400, z:80};
      let point2 : common2D.Point3d = {x: 400, y: 400, z:40};
      let color1 : common2D.Color = {alpha: 0xFF, red:0, green:0, blue:0xFF};
      let color2 : common2D.Color = {alpha: 0xFF, red:0xFF, green:0, blue:0};
      let shadowFlag : drawing.ShadowFlag = drawing.ShadowFlag.GEOMETRIC_ONLY;
      canvas.drawShadow(path, point1, point2, 5, color1, color2, shadowFlag);
    }
      canvas.detachPen();
      canvas.detachBrush();
  }
}