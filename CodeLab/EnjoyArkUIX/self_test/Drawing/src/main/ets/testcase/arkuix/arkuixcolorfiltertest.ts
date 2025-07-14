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

export class ArkuiXBlendModeColorFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 255, blue: 0 };
    let colorFilter = drawing.ColorFilter.createBlendModeColorFilter(color, drawing.BlendMode.SRC);
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();

    let brush2 = new drawing.Brush();
    let colorFilter2 =
      drawing.ColorFilter.createBlendModeColorFilter({
        alpha: 255,
        red: 0,
        green: 255,
        blue: 0
      }, drawing.BlendMode.SRC);
    brush2.setColorFilter(colorFilter2);
    canvas.attachBrush(brush2);
    canvas.drawRect(100, 350, 400, 600);
    canvas.detachBrush();
  }
}

export class ArkuiXComposeColorFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 0, blue: 255 };
    const color2 : common2D.Color = { alpha: 255, red: 0, green: 255, blue: 0 };
    let colorFilter1 = drawing.ColorFilter.createBlendModeColorFilter(color, drawing.BlendMode.SRC);
    let colorFilter2 = drawing.ColorFilter.createBlendModeColorFilter(color2, drawing.BlendMode.DST);
    let colorFilter = drawing.ColorFilter.createComposeColorFilter(colorFilter1, colorFilter2);
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXLinearToSRGBGammaTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 0, blue: 255 };
    brush.setColor(color);
    let colorFilter = drawing.ColorFilter.createLinearToSRGBGamma();
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXSRGBGammaToLinearTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 0, blue: 255 };
    brush.setColor(color);
    let colorFilter = drawing.ColorFilter.createSRGBGammaToLinear();
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXLumaColorFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 0, blue: 255 };
    brush.setColor(color);
    let colorFilter = drawing.ColorFilter.createLumaColorFilter();
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXMatrixColorFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 0, blue: 255 };
    brush.setColor(color);
    let matrix: Array<number> = [
      1, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 100, 0, 0,
      0, 0, 0, 1, 0
    ];
    let colorFilter = drawing.ColorFilter.createMatrixColorFilter(matrix);
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXCreateLightingColorFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    const color : common2D.Color = { alpha: 255, red: 0, green: 0, blue: 255 };
    brush.setColor(color);
    let mulColor : common2D.Color = { alpha: 0, red: 0, green: 0, blue: 20 };
    let addColor : common2D.Color = { alpha: 0, red: 0, green: 0, blue: 125 };
    let colorFilter = drawing.ColorFilter.createLightingColorFilter(mulColor, addColor);
    brush.setColorFilter(colorFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 50, 400, 300);
    canvas.detachBrush();
  }
}