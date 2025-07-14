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
import colorSpaceManager from "@ohos.graphics.colorSpaceManager";
import { TestBase } from '../../pages/testbase';
import { common2D } from "@kit.ArkGraphics2D";
import { PrintResult } from './arkuixutils'

export class ArkuiXBrushTest extends TestBase {
  roundRect_: drawing.RoundRect;
  roundRect2_: drawing.RoundRect;
  brush_: drawing.Brush;

  public constructor() {
    super();
    this.roundRect_ = new drawing.RoundRect({
      left: 50,
      top: 50,
      right: 300,
      bottom: 300
    }, 50, 50);
    this.roundRect2_ = new drawing.RoundRect({
      left: 50,
      top: 350,
      right: 300,
      bottom: 600
    }, 50, 50);
    this.brush_ = new drawing.Brush();
  }
}

export class ArkuiXBrushSetColorTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let brush2 = new drawing.Brush(brush);
    {
      this.brush_.setColor({
        alpha: 255,
        red: 255,
        green: 0,
        blue: 0
      });
    }

    {
      let brush_color: common2D.Color = {
        alpha: 0xFF,
        red: 0x00,
        green: 0xFF,
        blue: 0x00
      };
      brush.setColor(brush_color);
    }
    {
      brush2.setColor(0xFF0000FF);
    }
    canvas.attachBrush(this.brush_);
    canvas.drawRect({
      left: 50,
      top: 50,
      right: 200,
      bottom: 150
    });
    canvas.detachBrush();
    canvas.attachBrush(brush);
    canvas.drawRect({
      left: 50,
      top: 200,
      right: 200,
      bottom: 300
    });
    canvas.detachBrush();
    canvas.attachBrush(brush2);
    canvas.drawCircle(120, 400, 70);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushGetColorTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let color = this.brush_.getColor();
    let text = " getColor: color.alpha = " + color.alpha + ", color.red = " + color.red + ", color.green = " +
    color.green + ", color.blue = " + color.blue;
    PrintResult(canvas, text);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetColor4fTest1 extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let color4f: common2D.Color4f = {
      alpha: 0.5,
      red: 0.5,
      green: 0.4,
      blue: 0.7,
    };
    brush.setColor4f(color4f, null);
    const rowCount = 3; // 3 row count
    let row = 0;
    let column = 0;
    for (
      let i = colorSpaceManager.ColorSpace.UNKNOWN + 1;
      i <= colorSpaceManager.ColorSpace.BT2020_HLG;
      i++
    ) {
      if (i == colorSpaceManager.ColorSpace.CUSTOM) {
        continue;
      }
      //unknown,custom, will crash when create
      let colorSpace = colorSpaceManager.create(i);
      brush.setColor4f(color4f, colorSpace);
      row = Math.floor((i - 1) / rowCount);
      column = (i - 1) % rowCount;
      canvas.attachBrush(brush);
      let rect: common2D.Rect = {
        left: column * 200,
        top: row * 200,
        right: column * 200 + 198,
        bottom: row * 200 + 198,
      };
      canvas.drawRect(rect);
    }
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetColor4fTest2 extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let color4f: common2D.Color4f = {
      alpha: 1,
      red: 0.5,
      green: 0.4,
      blue: 0.7,
    };
    let rowCount = 3;
    let row = 0;
    let column = 0;

    for (
      let i = colorSpaceManager.ColorSpace.BT2020_HLG;
      i <= colorSpaceManager.ColorSpace.BT601_EBU_LIMIT;
      i++
    ) {
      let colorSpace = colorSpaceManager.create(i);
      brush.setColor4f(color4f, colorSpace);
      row = Math.floor(
        (i - colorSpaceManager.ColorSpace.BT2020_HLG) / rowCount
      );
      column = (i - colorSpaceManager.ColorSpace.BT2020_HLG) % rowCount;
      canvas.attachBrush(brush);
      let rect: common2D.Rect = {
        left: column * 200,
        top: row * 200,
        right: column * 200 + 198,
        bottom: row * 200 + 198,
      };
      canvas.drawRect(rect);
    }
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetColor4fTest3 extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let brush = new drawing.Brush();
    let color4f: common2D.Color4f = {
      alpha: 1,
      red: 0.5,
      green: 0.4,
      blue: 0.7,
    };
    // colorSpaceManager
    let rowCount = 3;
    let row = 0;
    let column = 0;
    let colorSpace = null;
    for (
      let i = colorSpaceManager.ColorSpace.BT601_SMPTE_C_LIMIT;
      i <= colorSpaceManager.ColorSpace.LINEAR_BT2020;
      i++
    ) {
      if (i != colorSpaceManager.ColorSpace.CUSTOM) {
        //unknown,custom, will crash when create
        colorSpace = colorSpaceManager.create(i);
      }
      brush.setColor4f(color4f, colorSpace);
      row = Math.floor(
        (i - colorSpaceManager.ColorSpace.BT601_SMPTE_C_LIMIT) / rowCount
      );
      column =
        (i - colorSpaceManager.ColorSpace.BT601_SMPTE_C_LIMIT) % rowCount;
      canvas.attachBrush(brush);
      let rect: common2D.Rect = {
        left: column * 200,
        top: row * 200,
        right: column * 200 + 198,
        bottom: row * 200 + 198,
      };
      canvas.drawRect(rect);
    }
    canvas.detachBrush();
  }
}

export class ArkuiXBrushGetColor4fTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let color = this.brush_.getColor4f();
    let text = "getColor4f: color.alpha = " + color.alpha + ", color.red = " + color.red + ", color.green = " +
      color.green + ", color.blue = " + color.blue;
    PrintResult(canvas, text);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushGetHexColorTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let hex_color: number = this.brush_.getHexColor();
    let text = ' getHexColor: ' + hex_color.toString(16);
    PrintResult(canvas, text);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetAntiAliasTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    this.brush_.setAntiAlias(true);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    canvas.attachBrush(brush);
    canvas.drawRoundRect(this.roundRect2_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushIsAntiAliasTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    this.brush_.setAntiAlias(true);
    let isAntiAlias = this.brush_.isAntiAlias();
    let text = " isAntiAlias is " + isAntiAlias;
    PrintResult(canvas, text);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetAlphaTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    this.brush_.setAlpha(100);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}


export class ArkuiXBrushGetAlphaTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    this.brush_.setAlpha(100);
    let num = this.brush_.getAlpha();
    let text = "getAlpha = " + num;
    PrintResult(canvas, text);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetColorFilterTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let colorFilter = drawing.ColorFilter.createLumaColorFilter();
    this.brush_.setColorFilter(colorFilter);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
    let brush = new drawing.Brush();
    brush.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    brush.setColorFilter(null);
    canvas.attachBrush(brush);
    canvas.drawRoundRect(this.roundRect2_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushGetColorFilterTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {

    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let colorFilter = drawing.ColorFilter.createLumaColorFilter();
    this.brush_.setColorFilter(colorFilter);
    let filter = this.brush_.getColorFilter();
    if (filter == null) {
      console.log("DrawingTestArkuiX000" + " BrushGetColorFilter failed: getColorFilter is null");
    }
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}


export class ArkuiXBrushSetImageFilterTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let imgFilter = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.CLAMP, null);
    this.brush_.setImageFilter(imgFilter);
    canvas.attachBrush(this.brush_);
    canvas.drawCircle(150, 250, 50);
    canvas.detachBrush();

    let imgFilter1 = drawing.ImageFilter.createBlurImageFilter(10, 5, drawing.TileMode.REPEAT, null);
    this.brush_.setImageFilter(imgFilter1);
    canvas.attachBrush(this.brush_);
    canvas.drawCircle(400, 250, 50);
    canvas.detachBrush();

    let imgFilter2 = drawing.ImageFilter.createBlurImageFilter(10, 5, drawing.TileMode.MIRROR, null);
    this.brush_.setImageFilter(imgFilter2);
    canvas.attachBrush(this.brush_);
    canvas.drawCircle(150, 550, 50);
    canvas.detachBrush();

    this.brush_.setImageFilter(null);
    canvas.attachBrush(this.brush_);
    canvas.drawCircle(400, 550, 50);
    canvas.detachBrush();

  }
}

export class ArkuiXBrushSetMaskFilterTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let maskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.OUTER, 100);
    this.brush_.setMaskFilter(maskFilter);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetShadowLayerTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let font = new drawing.Font();
    font.setSize(60);
    let textBlob =
      drawing.TextBlob.makeFromString("hello, OpenHarmony !", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    let color: common2D.Color = {
      alpha: 0xFF,
      red: 0x00,
      green: 0xFF,
      blue: 0x00
    };
    let shadowLayer = drawing.ShadowLayer.create(3, -3, 3, color);
    this.brush_.setShadowLayer(shadowLayer);
    canvas.attachBrush(this.brush_);
    canvas.drawTextBlob(textBlob, 80, 200);
    canvas.detachBrush();
  }
}


export class ArkuiXBrushSetShaderEffectTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let shaderEffect =
      drawing.ShaderEffect.createLinearGradient({ x: 100, y: 100 }, { x: 300, y: 300 }, [0xFF00FF00, 0xFFFF0000],
        drawing.TileMode.REPEAT);
    this.brush_.setShaderEffect(shaderEffect);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
  }
}

export class ArkuiXBrushSetBlendModeTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    {
      canvas.saveLayer(null, null);
      const brushRect = new drawing.Brush();
      const colorRect: common2D.Color = {alpha: 255, red: 255, green: 255, blue: 0};
      brushRect.setColor(colorRect);
      canvas.attachBrush(brushRect);
      const rect: common2D.Rect = {left:50, top:50, right:200, bottom:200};
      canvas.drawRect(rect);
      canvas.detachBrush();

      this.brush_.setBlendMode(drawing.BlendMode.LUMINOSITY);
      canvas.saveLayer(rect, this.brush_);

      const brushCircle = new drawing.Brush();
      const colorCircle: common2D.Color = {alpha: 255, red: 0, green: 0, blue: 255};
      brushCircle.setColor(colorCircle);
      canvas.attachBrush(brushCircle);
      canvas.drawCircle(200, 200, 100);
      canvas.restore();
      canvas.restore();
      canvas.detachBrush();
    }
    // {
    //   canvas.saveLayer(null, null);
    //   const brushRect = new drawing.Brush();
    //   const colorRect: common2D.Color = {alpha: 255, red: 255, green: 255, blue: 0};
    //   brushRect.setColor(colorRect);
    //   canvas.attachBrush(brushRect);
    //   const rect: common2D.Rect = {left:50, top:350, right:200, bottom:500};
    //   canvas.drawRect(rect);
    //   canvas.detachBrush();
    //
    //   this.brush_.setBlendMode(drawing.BlendMode.SCREEN);
    //   canvas.saveLayer(rect, this.brush_);
    //
    //   const brushCircle = new drawing.Brush();
    //   const colorCircle: common2D.Color = {alpha: 255, red: 0, green: 0, blue: 255};
    //   brushCircle.setColor(colorCircle);
    //   canvas.attachBrush(brushCircle);
    //   canvas.drawCircle(200, 500, 100);
    //   canvas.restore();
    //   canvas.restore();
    //   canvas.detachBrush();
    // }
  }
}

export class ArkuiXBrushResetTest extends ArkuiXBrushTest {
  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    this.brush_.setColor({
      alpha: 255,
      red: 128,
      green: 0,
      blue: 120
    });
    this.brush_.setAntiAlias(true);
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect_);
    canvas.detachBrush();
    this.brush_.reset();
    canvas.attachBrush(this.brush_);
    canvas.drawRoundRect(this.roundRect2_);
    canvas.detachBrush();
  }
}