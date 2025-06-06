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

import { CanvasClipGrooveType, CanvasCreateRectangleType } from '../types/ConcaveCircleType';
import { TabMenusInterfaceIRequired } from '../types/TabMenusInterface';

/**
 * 获取 图片地址
 * @param { TabMenusInterfaceIRequired } item  - menu 选项
 * @param { number } index - 当前图片下标
 * @returns { PixelMap | ResourceStr | DrawableDescriptor }
 */
export function getImageUrl(
  item: TabMenusInterfaceIRequired, index: number, selectIndex: number): PixelMap | ResourceStr | DrawableDescriptor {
  if (index === selectIndex) {
    if (item.selectImage) {
      return item.selectImage
    }
  }
  return item.image!
}

/**
 * 获取兼容性宽度
 * @param { number } width
 * @param { number } height
 * @param { number } menuLength
 * @returns { number } 适配当菜单数量，取菜单的宽度和tabs高度，把小数值返回作为后续使用
 */
export function getMinWidth(width: number, height: number, menuLength: number = 0): number {
  return Math.min(width / menuLength, height);
}

/**
 * 计算突起圆俩边倒角
 * @param { number } itemHeight - 悬浮球直径
 * @param { number } r - 倒角圆半径
 * @return { [string,string] } 坐标 [x,y] vp
 */
export function getChamferXY(itemHeight: number, r: number = 30): [number, number] {
  // 超出矩形高度 / 3 是因为偏移了 1/3
  let topH = itemHeight / 3;
  // 获取圆心 - 高度 / 2
  let center = itemHeight / 2
  // 圆心距离Tabs上边高度
  let cenToTop = center - topH;
  // 倒角圆中心高度 y
  let chamferY = cenToTop + r;
  // 三角形斜边
  let sr = r + center
  // 倒角圆水平坐标
  let chamferX = Math.sqrt(Math.pow(sr, 2) - Math.pow(chamferY, 2))
  return [chamferX, chamferY]
}

/**
 * 绘制 Canvas 大小和填充颜色
 * @param { CanvasCreateRectangleType } canvasInfo - canvas一些信息详见 CanvasCreateRectangleType
 */
export function CanvasCreateRectangle(canvasInfo: CanvasCreateRectangleType) {
  // CanvasRenderingContext2D
  let ctx = canvasInfo.context;
  // canvas 宽度
  let cW = canvasInfo.context.width;
  // canvas 高度
  let cH = canvasInfo.context.height;

  ctx.clearRect(0, 0, cW, cH);
  ctx.beginPath()
  ctx.moveTo(0, 0)
  ctx.lineTo(cW, 0)
  ctx.lineTo(cW, cH)
  ctx.lineTo(0, cH)
  ctx.closePath()
  ctx.fillStyle = canvasInfo.tabsBgColor // 设置填充颜色
  ctx.fill()
  ctx.closePath()
}

/**
 * 给 Canvas 切割悬浮槽
 * TODO: 知识点：通过 clip 来实现切割后保留的圆弧实现平滑过渡
 * @param  { CanvasClipGrooveType } canvasInfo - canvas一些信息详见 CanvasClipGrooveType
 */
export function CanvasClipGroove(canvasInfo: CanvasClipGrooveType) {
  // CanvasRenderingContext2D
  let ctx = canvasInfo.context;
  // canvas 宽度
  let cW = ctx.width;
  // canvas 高度
  let cH = ctx.height;
  // 半径
  let radius = getMinWidth(cW, cH, canvasInfo.menuLength) / 2;
  // 中间圆的中心点
  let Center = canvasInfo.center || cW / 2;
  // 计算左右俩倒角的x轴距离圆心的距离
  let aroundCenter = Math.sqrt(Math.pow(radius * 2, 2) - Math.pow(radius, 2));
  /**
   * canvas 绘制的度数  1°
   * 这里是 1° 如果需要多少度 直接 * 具体数字即可
   */
  const chamferDegrees1 = Math.PI / 180;
  // 330°
  const chamferDegrees330 = chamferDegrees1 * 330;
  // 270°
  const chamferDegrees270 = chamferDegrees1 * 270;
  // 210°
  const chamferDegrees210 = chamferDegrees1 * 210;
  // 150°
  const chamferDegrees150 = chamferDegrees1 * 150;
  // 30°
  const chamferDegrees30 = chamferDegrees1 * 30;

  ctx.beginPath()
  // 左边圆弧线
  ctx.arc(Center - aroundCenter, radius, radius, chamferDegrees270, chamferDegrees330)
  // 中间圆弧线
  ctx.arc(Center, 0, radius, chamferDegrees30, chamferDegrees150)
  // 右边圆弧线
  ctx.arc(Center + aroundCenter, radius, radius, chamferDegrees210, chamferDegrees270)
  ctx.closePath()
  // 应用剪裁路径
  ctx.clip()
  // 清除剪裁区域内的部分
  ctx.clearRect(0, 0, cW, cH);
}

