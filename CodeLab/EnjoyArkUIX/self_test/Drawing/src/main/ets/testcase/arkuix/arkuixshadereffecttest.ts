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
import globalThis from '../../utils/globalThis'
import image from '@ohos.multimedia.image';

export class ArkuiXColorShaderTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let shaderEffect = drawing.ShaderEffect.createColorShader(0xFF00FF00);
    brush.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachBrush();
  }
}

export class ArkuiXLinearGradientTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let startPt: common2D.Point = { x: 100, y: 100 };
    let endPt: common2D.Point = { x: 300, y: 300 };
    let shaderEffect =
      drawing.ShaderEffect.createLinearGradient(startPt, endPt, [0xFF00FF00, 0xFFFF0000], drawing.TileMode.REPEAT);
    brush.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachBrush();
  }
}

export class ArkuiXRadialGradientTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let centerPt: common2D.Point = { x: 100, y: 100 };
    let shaderEffect =
      drawing.ShaderEffect.createRadialGradient(centerPt, 100, [0xFF00FF00, 0xFFFF0000], drawing.TileMode.REPEAT);
    brush.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachBrush();
  }
}

export class ArkuiXSweepGradientTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let centerPt: common2D.Point = { x: 100, y: 100 };
    let shaderEffect =
      drawing.ShaderEffect.createSweepGradient(centerPt, [0xFF00FF00, 0xFFFF0000], drawing.TileMode.REPEAT, 100, 200);
    brush.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachBrush();
  }
}

export class ArkuiXConicalGradientTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let startPt: common2D.Point = { x: 100, y: 100 };
    let endPt: common2D.Point = {x: 200, y: 200};
    let shaderEffect =
      drawing.ShaderEffect.createConicalGradient(startPt, 100, endPt, 50, [0xFF00FF00, 0xFFFF0000], drawing.TileMode.REPEAT);
    brush.setShaderEffect(shaderEffect);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachBrush();
  }
}

export class ArkuiXCreateImageShaderTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
    let brush = new drawing.Brush();
    let matrix = new drawing.Matrix();
    let options = new drawing.SamplingOptions(drawing.FilterMode.FILTER_MODE_NEAREST);
    if (pixelMap != null) {
      let imageShader =
        drawing.ShaderEffect.createImageShader(pixelMap, drawing.TileMode.REPEAT, drawing.TileMode.MIRROR, options,
          matrix);
      brush.setShaderEffect(imageShader);
      canvas.attachBrush(brush);
      canvas.drawRect(100, 100, 400, 400);
      canvas.detachBrush();
    } else {
      console.log("DrawingTestArkuiX000" + ' pixelMap = null');
    }
  }
}

export class ArkuiXCreateComposeShaderTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let dstShader = drawing.ShaderEffect.createColorShader(0xFF0000FF);
    let srcShader = drawing.ShaderEffect.createColorShader(0xFFFF0000);
    let shader = drawing.ShaderEffect.createComposeShader(dstShader, srcShader, drawing.BlendMode.SRC);
    brush.setShaderEffect(shader);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 400, 400);
    canvas.detachBrush();
  }
}

