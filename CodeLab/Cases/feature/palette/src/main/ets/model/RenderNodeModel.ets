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

import { common2D, drawing } from '@kit.ArkGraphics2D';
import { Constants } from '../constants/Contants';
import { DrawContext, FrameNode, NodeController, RenderNode, Size } from '@kit.ArkUI';

/**
 * MyRenderNode类，初始化画笔和绘制路径
 */
export class MyRenderNode extends RenderNode {
  path: drawing.Path = new drawing.Path(); // 新建路径对象，用于绘制手指移动轨迹
  penColor: common2D.Color = {
    alpha: 0xFF,
    red: 0x00,
    green: 0x00,
    blue: 0x00
  }; // 画笔颜色，默认为黑色

  // 创建节点时设置画笔颜色
  constructor(penColor: common2D.Color) {
    super();
    this.penColor = penColor;
  }

  // RenderNode进行绘制时会调用draw方法
  draw(context: DrawContext): void {
    const canvas = context.canvas;
    // 创建一个画笔Pen对象，Pen对象用于形状的边框线绘制
    const pen = new drawing.Pen();
    // 设置画笔开启反走样，可以使得图形的边缘在显示时更平滑
    pen.setAntiAlias(true);
    pen.setColor(this.penColor);
    // 开启画笔的抖动绘制效果。抖动绘制可以使得绘制出的颜色更加真实。
    pen.setDither(true);
    // 设置画笔的线宽为10px
    pen.setStrokeWidth(Constants.PEN_STROKE_WIDTH);
    // 将Pen画笔设置到canvas中
    canvas.attachPen(pen);
    // 绘制path
    canvas.drawPath(this.path);
  }
}

/**
 * NodeController的子类MyNodeController
 */
export class MyNodeController extends NodeController {
  private rootNode: FrameNode | null = null; // 根节点
  rootRenderNode: RenderNode | null = null; // 从NodeController根节点获取的RenderNode，用于添加和删除新创建的MyRenderNode实例

  // MyNodeController实例绑定的NodeContainer创建时触发，创建根节点rootNode并将其挂载至NodeContainer
  makeNode(uiContext: UIContext): FrameNode {
    this.rootNode = new FrameNode(uiContext);
    if (this.rootNode !== null) {
      this.rootRenderNode = this.rootNode.getRenderNode();
    }
    return this.rootNode;
  }

  // 绑定的NodeContainer布局时触发，获取NodeContainer的宽高
  aboutToResize(size: Size): void {
    if (this.rootRenderNode !== null) {
      // NodeContainer布局完成后设置rootRenderNode的背景透明
      this.rootRenderNode.backgroundColor = 0X00000000;
      // rootRenderNode的位置从组件NodeContainer的左上角(0,0)坐标开始，大小为NodeContainer的宽高
      this.rootRenderNode.frame = {
        x: 0,
        y: 0,
        width: size.width,
        height: size.height
      };
    }
  }

  // 添加节点
  addNode(node: RenderNode): void {
    if (this.rootNode === null) {
      return;
    }
    if (this.rootRenderNode !== null) {
      this.rootRenderNode.appendChild(node);
    }
  }

  // 清空节点
  clearNodes(): void {
    if (this.rootNode === null) {
      return;
    }
    if (this.rootRenderNode !== null) {
      this.rootRenderNode.clearChildren();
    }
  }
}