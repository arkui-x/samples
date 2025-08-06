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

export class ArkuiXShadowLayerTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let pen = new drawing.Pen();
    pen.setStrokeWidth(5.0);
    pen.setColor({
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
    pen.setShadowLayer(shadowLayer);
    canvas.attachPen(pen);
    canvas.drawTextBlob(textBlob, 80, 200);
    canvas.detachPen();
    let pen2 = new drawing.Pen();
    pen2.setStrokeWidth(5.0);
    pen2.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let textBlob2 =
      drawing.TextBlob.makeFromString("hello, OpenHarmony !", font, drawing.TextEncoding.TEXT_ENCODING_UTF8);
    let shadowLayer2 = drawing.ShadowLayer.create(3, -3, 3, 0xff0000ff);
    pen2.setShadowLayer(shadowLayer2);
    canvas.attachPen(pen2);
    canvas.drawTextBlob(textBlob2, 80, 400);
    canvas.detachPen();
  }
}
