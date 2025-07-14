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
import { common2D } from '@kit.ArkGraphics2D';

export class ArkuiXPointModeTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    const pen = new drawing.Pen();
    pen.setStrokeWidth(30);
    const color : common2D.Color = { alpha: 255, red: 255, green: 0, blue: 0 };
    pen.setColor(color);
    canvas.attachPen(pen);
    canvas.drawPoints([{x: 100, y: 50}, {x: 200, y: 100}, {x: 300, y: 150},{x:400, y:200}], drawing.PointMode.POINTS);
    canvas.drawPoints([{x: 100, y: 200}, {x: 200, y: 250}, {x: 300, y: 300}, {x:400, y:350}], drawing.PointMode.LINES);
    canvas.drawPoints([{x: 100, y: 350}, {x: 200, y: 400}, {x: 300, y: 450}, {x:400, y:500}], drawing.PointMode.POLYGON);
    canvas.detachPen();
  }
}
