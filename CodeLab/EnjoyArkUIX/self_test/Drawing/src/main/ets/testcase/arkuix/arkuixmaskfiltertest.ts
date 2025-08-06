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

export class ArkuiXMaskFilterTest extends TestBase {

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
    let maskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.NORMAL, 20);
    brush.setMaskFilter(maskFilter);
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
    let maskFilter2 = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.SOLID, 20);
    brush2.setMaskFilter(maskFilter2);
    canvas.attachBrush(brush2);
    canvas.drawRect(100, 450, 300, 650);
    canvas.detachBrush();

    let brush3 = new drawing.Brush();
    brush3.setColor({
      alpha: 255,
      red: 255,
      green: 0,
      blue: 0
    });
    let maskFilter3 = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.OUTER, 20);
    brush3.setMaskFilter(maskFilter3);
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
    let maskFilter4 = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.INNER, 20);
    brush4.setMaskFilter(maskFilter4);
    canvas.attachBrush(brush4);
    canvas.drawRect(400, 450, 600, 650);
    canvas.detachBrush();
  }
}
