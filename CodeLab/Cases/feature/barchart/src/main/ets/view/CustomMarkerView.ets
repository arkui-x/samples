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
import { EntryOhos, Highlight, IMarker, MPPointF } from '@ohos/mpchart';

/**
 * 自定义MarkerView弹窗。使用三方库中MarkerView源码，修改弹窗中字体大小
 */
export default class CustomMarkerView implements IMarker {
  private mOffset: MPPointF = new MPPointF();
  private mOffset2: MPPointF = new MPPointF();

  constructor() {
  }

  /**
   * 获取第一个偏移量对象
   */
  getOffset(): MPPointF {
    return this.mOffset;
  }

  /**
   * 根据给定的X和Y位置计算并返回第二个偏移量对象
   */
  getOffsetForDrawingAtPoint(posX: number, posY: number): MPPointF {
    let offset: MPPointF = this.getOffset();
    this.mOffset2.x = offset.x;
    this.mOffset2.y = offset.y;
    return this.mOffset2;
  }

  /**
   * 在指定位置绘制MarkerView弹窗
   */
  draw(c: CanvasRenderingContext2D, posX: number, posY: number, e: EntryOhos, highlight: Highlight) {
    let offset: MPPointF = this.getOffsetForDrawingAtPoint(posX, posY);
    c.save();
    // 设置MarkerView弹窗中的字体大小
    c.font = "normal normal 10vp";
    // 将x坐标和y坐标都保留到小数点后一位
    let roundX = Number(e.getX().toFixed(1));
    let roundY = Number(e.getY().toFixed(1));
    let text: string = 'x:' + Math.round(roundX) + 'y:' + Math.round(roundY);
    let textMetrics: TextMetrics = c.measureText(text);
    let measureWidth: number = textMetrics.width;
    let measureHeight: number = textMetrics.height;
    // MarkerView弹窗内边距
    let padding: number = 5;
    c.beginPath();
    // 设置MarkerView弹窗的背景颜色
    c.fillStyle = '#bcbcbc';
    let left: number = posX + offset.x;
    let top: number = posY + offset.y;
    // 计算左右内边距的总和
    const TEXT_WIDTH_MAX = 32;
    const TEXT_HEIGHT_MAX = 12;
    // 左右内边距为2*padding
    const LEFT_AND_RIGHT_PADDING = 2 * padding;
    /**
     * 计算矩形弹窗的位置和大小：
     * - left - measureWidth / 2 - padding：计算矩形弹窗中心点的水平偏移量，并减去左内边距。
     * - top - measureHeight - 4 * padding：确定矩形的顶部位置，4 * padding是在文本高度基础上额外增加的距离，用于留出空间给弹窗底部的倒三角箭头。
     * - measureWidth + LEFT_AND_RIGHT_PADDING：矩形弹窗的宽度，包括文本宽度和左右内边距。
     * - measureHeight + 3 * padding：矩形弹窗的高度，包括文本高度和上下内边距（3 * padding用于在顶部和底部留出空间）。
     */
    c.fillRect(left - measureWidth / 2 - padding, top - measureHeight - 4 * padding,
      measureWidth + LEFT_AND_RIGHT_PADDING, measureHeight + 3 * padding);
    if (measureWidth < TEXT_WIDTH_MAX) {
      measureWidth = TEXT_WIDTH_MAX;
    }
    if (measureHeight < TEXT_HEIGHT_MAX) {
      measureHeight = TEXT_HEIGHT_MAX;
    }
    // 绘制弹窗底部的倒三角箭头
    c.beginPath();
    c.moveTo(left - LEFT_AND_RIGHT_PADDING, top - LEFT_AND_RIGHT_PADDING);
    // padding/2用于确定箭头顶点相对于弹窗底部的垂直偏移量
    c.lineTo(left, top + padding / 2);
    c.lineTo(left + LEFT_AND_RIGHT_PADDING, top - LEFT_AND_RIGHT_PADDING);
    c.fill();
    c.closePath();
    c.fillStyle = Color.Black;
    c.textAlign = 'center';
    // 在矩形弹窗内绘制文本，top-3*padding是文本的垂直位置，3*padding是在top基础上向上偏移的距离
    c.fillText(text, left, top - 3 * padding);
    c.restore();
  }
}