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

export class ArkuiXFontMetricsFlagsTest extends TestBase {

  public constructor() {
    super();
  }
  public OnTestFunction(canvas: drawing.Canvas) {
    let flag  = drawing.FontMetricsFlags.UNDERLINE_THICKNESS_VALID;
    let flag2  = drawing.FontMetricsFlags.UNDERLINE_POSITION_VALID;
    let flag3  = drawing.FontMetricsFlags.STRIKETHROUGH_THICKNESS_VALID;
    let flag4  = drawing.FontMetricsFlags.STRIKETHROUGH_POSITION_VALID;
    let flag5  = drawing.FontMetricsFlags.BOUNDS_INVALID;

    let metrics: drawing.FontMetrics = {
      flags: flag,
      top: 1.2,
      ascent: 1.0,
      descent: -0.5,
      bottom: -1.2,
      leading: 0.4,
      avgCharWidth: 0.8,
      maxCharWidth: 1.5,
      xMin: -0.3,
      xMax: 1.0,
      xHeight: -0.2,
      capHeight: -0.4,
      underlineThickness: 0.1,
      underlinePosition: 0.2,
      strikethroughThickness: 0.1,
      strikethroughPosition: -0.6
    };
    console.log("DrawingTestArkuiX000" + ' metrics.flags：', metrics.flags, ', metrics.top: ', metrics.top, ', metrics.ascent: ', metrics.ascent);
    console.log("DrawingTestArkuiX000" + ' metrics.descent: ', metrics.descent, ', metrics.bottom: ',metrics.bottom, ', metrics.leading: ', metrics.leading);
    console.log("DrawingTestArkuiX000" + ' metrics.avgCharWidth: ', metrics.avgCharWidth, ', metrics.maxCharWidth: ', metrics.maxCharWidth);
    console.log("DrawingTestArkuiX000" + ' metrics.xMin: ',metrics.xMin, ', metrics.xMax: ', metrics.xMax, ', metrics.xHeight: ', metrics.xHeight);
    console.log("DrawingTestArkuiX000" + ' metrics.capHeight: ', metrics.capHeight, ', metrics.underlineThickness: ', metrics.underlineThickness,
      ', metrics.underlinePosition: ', metrics.underlinePosition);
    console.log("DrawingTestArkuiX000" + ' metrics.strikethroughThickness: ', metrics.strikethroughThickness,
      ', metrics.strikethroughPosition: ', metrics.strikethroughPosition);

    let metrics2: drawing.FontMetrics = {
      flags: flag2,
      top: 1.2,
      ascent: 1.0,
      descent: -0.5,
      bottom: -1.2,
      leading: 0.4,
      avgCharWidth: 0.8,
      maxCharWidth: 1.5,
      xMin: -0.3,
      xMax: 1.0,
      xHeight: -0.2,
      capHeight: -0.4,
      underlineThickness: 0.1,
      underlinePosition: 0.2,
      strikethroughThickness: 0.1,
      strikethroughPosition: -0.6
    };
    console.log("DrawingTestArkuiX000" + ' metrics2.flags：', metrics2.flags);

    let metrics3: drawing.FontMetrics = {
      flags: flag3,
      top: 1.2,
      ascent: 1.0,
      descent: -0.5,
      bottom: -1.2,
      leading: 0.4,
      avgCharWidth: 0.8,
      maxCharWidth: 1.5,
      xMin: -0.3,
      xMax: 1.0,
      xHeight: -0.2,
      capHeight: -0.4,
      underlineThickness: 0.1,
      underlinePosition: 0.2,
      strikethroughThickness: 0.1,
      strikethroughPosition: -0.6
    };
    console.log("DrawingTestArkuiX000" + ' metrics3.flags：', metrics3.flags);

    let metrics4: drawing.FontMetrics = {
      flags: flag4,
      top: 1.2,
      ascent: 1.0,
      descent: -0.5,
      bottom: -1.2,
      leading: 0.4,
      avgCharWidth: 0.8,
      maxCharWidth: 1.5,
      xMin: -0.3,
      xMax: 1.0,
      xHeight: -0.2,
      capHeight: -0.4,
      underlineThickness: 0.1,
      underlinePosition: 0.2,
      strikethroughThickness: 0.1,
      strikethroughPosition: -0.6
    };
    console.log("DrawingTestArkuiX000" + ' metrics4.flags：', metrics4.flags);

    let metrics5: drawing.FontMetrics = {
      flags: flag5,
      top: 1.2,
      ascent: 1.0,
      descent: -0.5,
      bottom: -1.2,
      leading: 0.4,
      avgCharWidth: 0.8,
      maxCharWidth: 1.5,
      xMin: -0.3,
      xMax: 1.0,
      xHeight: -0.2,
      capHeight: -0.4,
      underlineThickness: 0.1,
      underlinePosition: 0.2,
      strikethroughThickness: 0.1,
      strikethroughPosition: -0.6
    };
    console.log("DrawingTestArkuiX000" + ' metrics5.flags：', metrics5.flags);
  }
}
