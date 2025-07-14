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
import {TestBase, TestFunctionStyleType, StyleType} from '../../pages/testbase';
import { common2D } from "@kit.ArkGraphics2D";

const TAG = '[ArkuiXToolTest]';

export class ToolMakeColorFromResourceColorTest1 extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let color1: common2D.Color = drawing.Tool.makeColorFromResourceColor(0x11ffa500);
    canvas.drawColor(color1);
  }
}

export class ToolMakeColorFromResourceColorTest2 extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let color2: common2D.Color = drawing.Tool.makeColorFromResourceColor('#ff0000');
    canvas.drawColor(color2);
  }
}

export class ToolMakeColorFromResourceColorTest3 extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let color3: common2D.Color = drawing.Tool.makeColorFromResourceColor($r('app.color.color_test'));
    canvas.drawColor(color3);
  }
}

export class ToolMakeColorFromResourceColorTest4 extends TestBase {

  public constructor() {
    super();
  }

  public OnTestFunction(canvas: drawing.Canvas) {
    let color4: common2D.Color = drawing.Tool.makeColorFromResourceColor(Color.Black);
    canvas.drawColor(color4);
  }
}


