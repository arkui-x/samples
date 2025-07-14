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

export class ArkuiXTileModeTest extends TestBase {

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
      red: 0,
      green: 255,
      blue: 0
    });
    let imgFilter2 = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode. REPEAT);
    brush2.setImageFilter(imgFilter2);
    canvas.attachBrush(brush2);
    canvas.drawRect(100, 450, 300, 650);
    canvas.detachBrush();

    let brush3 = new drawing.Brush();
    brush3.setColor({
      alpha: 255,
      red: 0,
      green: 0,
      blue: 255
    });
    let imgFilter3 = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.MIRROR);
    brush3.setImageFilter(imgFilter3);
    canvas.attachBrush(brush3);
    canvas.drawRect(400, 100, 600, 300);
    canvas.detachBrush();

    let brush4 = new drawing.Brush();
    brush4.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let imgFilter4 = drawing.ImageFilter.createBlurImageFilter(5, 10, drawing.TileMode.DECAL);
    brush4.setImageFilter(imgFilter4);
    canvas.attachBrush(brush4);
    canvas.drawRect(400, 450, 600, 650);
    canvas.detachBrush();
  }
}
