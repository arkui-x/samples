/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import {TestBase} from './testbase';
import {CaseFactory} from './casefactory';
import drawing from "@ohos.graphics.drawing";
import { NodeController, FrameNode, RenderNode, DrawContext, Size } from "@ohos.arkui.node"
import {PrintCallback} from "./printcallback";
import image from '@ohos.multimedia.image';

const TAG = '[DrawingTest]';
let printCallback: PrintCallback;

export class MyRenderNode extends RenderNode {
  testType: string = 'arkuix';
  drawingType: string = 'gpu';
  caseNameStr: string  = 'drawrect';
  testCount: number = 0;
  clear:boolean = false;
  pixelMap: image.PixelMap = null;

  async draw(context: DrawContext) {
    if (this.clear) {
      printCallback('Clear XNode');
      return;
    }

    console.log(TAG, 'MyRenderNode draw');
    const canvas = context.canvas;
    if (this.testType == 'arkuix') {
      console.log(TAG, 'MyRenderNode draw arkuix');
      this.TestArkuixGpuUpScreen(canvas);
    }
  }

  TestArkuixGpuUpScreen(canvas: drawing.Canvas) {
    console.info(TAG, 'MyRenderNode TestArkuixGpuUpScreen', this.caseNameStr);
    let test:TestBase = CaseFactory.getArkuixGpuCase(this.caseNameStr);
    if (test == null || test == undefined) {
      printCallback('Testcase name is invalid');
      return;
    }
    test.TestFunctionGpuUpScreen(canvas);
    printCallback('TestArkuixGpuUpScreen end');
  }
}

export class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null;
  myRenderNode = new MyRenderNode();

  makeNode(uiContext): FrameNode {
    console.info(TAG, 'MyNodeController makeNode');
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode === null) {
      console.error(TAG, 'failed to new FrameNode')
      return this.rootNode
    }

    const renderNode = this.rootNode.getRenderNode();
    if (renderNode !== null) {
      this.myRenderNode.backgroundColor = 0xffffffff;
      this.myRenderNode.frame = { x: 0, y: 0, width: 4800, height: 4800 }; //2:3 = 480:720  4800代表足够大，覆盖整个控件
      this.myRenderNode.pivot = { x: 0.2, y: 0.8 }
      this.myRenderNode.scale = { x: 1, y: 1 }
      renderNode.appendChild(this.myRenderNode);
      renderNode.clipToFrame = true
      console.info(TAG, 'MyNodeController appendChild end');
    }

    console.info(TAG, 'MyNodeController makeNode end');
    return this.rootNode;
  }

  TestArkuixGpuUpScreen(caseName: string) {
    console.info(TAG, "TestArkuixGpuUpScreen");
    this.myRenderNode.clear = false;
    this.myRenderNode.testType = 'arkuix';
    this.myRenderNode.drawingType = 'gpu';
    this.myRenderNode.caseNameStr = caseName;
    this.myRenderNode.invalidate();
  }

  Clear() {
    console.info(TAG, "Clear");
    this.myRenderNode.clear = true;
    this.myRenderNode.invalidate();
  }

  SetPrintCallback(callback: PrintCallback){
    printCallback = callback;
  }
}
