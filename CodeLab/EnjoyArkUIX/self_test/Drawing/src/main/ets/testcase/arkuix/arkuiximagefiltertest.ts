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

export class ArkuiXBlurImageFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let imgFilter = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.CLAMP);
    brush.setImageFilter(imgFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 300, 300);
    canvas.detachBrush();

    let brush2 = new drawing.Brush();
    brush2.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let imgFilter2 = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.CLAMP);
    let colorFilter = drawing.ColorFilter.createSRGBGammaToLinear();
    let imgFilter3 = drawing.ImageFilter.createFromColorFilter(colorFilter, imgFilter2);
    let imgFilter4 = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.CLAMP, imgFilter3);
    brush2.setImageFilter(imgFilter4);
    canvas.attachBrush(brush2);
    canvas.drawRect(100,350, 300, 550);
    canvas.detachBrush();
  }
}

export class ArkuiXFromColorFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let imgFilter = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.CLAMP);
    let colorFilter = drawing.ColorFilter.createSRGBGammaToLinear();
    let imgFilter1 = drawing.ImageFilter.createFromColorFilter(colorFilter, imgFilter);
    brush.setImageFilter(imgFilter1);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 300, 300);
    canvas.detachBrush();

    let brush2 = new drawing.Brush();
    brush2.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let colorFilter2 = drawing.ColorFilter.createSRGBGammaToLinear();
    let imgFilter2 = drawing.ImageFilter.createFromColorFilter(colorFilter2);
    brush2.setImageFilter(imgFilter2);
    canvas.attachBrush(brush2);
    canvas.drawRect(100,350, 300, 550);
    canvas.detachBrush();
  }
}

export class ArkuiXCreateOffsetImageFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let dx = 15.0;
    let dy = 10.0;
    let offsetFilter = drawing.ImageFilter.createOffsetImageFilter(dx, dy, null);
    brush.setImageFilter(offsetFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 300, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXCreateFromImageTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let pixelMap: image.PixelMap = globalThis.getInstance().getPixelMap("test_1.jpg");
    let srcRect: common2D.Rect = { left: 10, top: 10, right: 80, bottom: 80 };
    let dstRect: common2D.Rect = { left: 200, top: 200, right: 400, bottom: 400 };
    if (pixelMap != null) {
      let filter = drawing.ImageFilter.createFromImage(pixelMap, srcRect, dstRect);
      brush.setImageFilter(filter);
      canvas.attachBrush(brush);
      canvas.drawRect(100, 100, 300, 300);
      canvas.detachBrush();
    } else {
      console.log("DrawingTestArkuiX000" + ' pixelMap = null');
    }
  }
}

export class ArkuiXCreateBlendImageFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let dx = 15.0;
    let dy = 10.0;
    let offsetFilter1 = drawing.ImageFilter.createOffsetImageFilter(dx, dy, null);
    let x = 15.0;
    let y = 30.0;
    let offsetFilter2 = drawing.ImageFilter.createOffsetImageFilter(x, y, null);
    let blendImageFilter = drawing.ImageFilter.createBlendImageFilter(drawing.BlendMode.SRC_IN, offsetFilter1, offsetFilter2);
    brush.setImageFilter(blendImageFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 300, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXCreateComposeImageFilterTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let blurSigmaX = 10.0;
    let blurSigmaY = 10.0;
    let blurFilter = drawing.ImageFilter.createBlurImageFilter(blurSigmaX, blurSigmaY, drawing.TileMode.CLAMP, null);
    let colorMatrix:Array<number> = [
      0, 0, 0, 0, 0,
      0, 1, 0, 0, 0,
      0, 0, 1, 0, 0,
      0, 0, 0, 1, 0
    ];
    let redRemovalFilter = drawing.ColorFilter.createMatrixColorFilter(colorMatrix);
    let colorFilter = drawing.ImageFilter.createFromColorFilter(redRemovalFilter, null);
    let composedImageFilter = drawing.ImageFilter.createComposeImageFilter(colorFilter, blurFilter);
    brush.setImageFilter(composedImageFilter);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 300, 300);
    canvas.detachBrush();
  }
}

export class ArkuiXCreateFromShaderEffectTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let shaderEffect = drawing.ShaderEffect.createColorShader(0xFF00FF00);
    let renderEffect = drawing.ImageFilter.createFromShaderEffect(shaderEffect);
    brush.setImageFilter(renderEffect);
    canvas.attachBrush(brush);
    canvas.drawRect(100, 100, 300, 300);
    canvas.detachBrush();
  }
}
