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

import { componentUtils } from '@kit.ArkUI';
import { RaisedCircleSetPostionXYType } from '../types/RaisedCircleTypes';
import { getChamferXY as utilGetChamferXY, getMinWidth as utilGetMinWidth } from './Functions';

/**
 * 悬浮的球和凸起的球 选中时大小需要小于正常尺寸
 * 6 则是多余的尺寸
 */
export const SURPLUSRADIUS = 6;

interface CircleClassConstructorType {
  width: number;
  height: number;
  menuLength: number
}

/**
 * 基础类
 */
@Observed
class CircleClass {
  // 宽度
  @Track
  width: number;
  // 高度
  @Track
  height: number;
  // 记录tabs 有几个菜单
  @Track
  menuLength: number = 0;

  constructor(options: CircleClassConstructorType) {
    this.width = options.width;
    this.height = options.height;
    this.menuLength = options.menuLength;

  }

  /**
   * 获取兼容性的半径
   * @returns { number }
   */
  getMinWidth(): number {
    return utilGetMinWidth(this.width, this.height, this.menuLength);
  }

  /**
   * 获取菜单选项的中间点
   * @param  { number } index - 当前选中菜单的下标
   * @returns { number }
   */
  getMenuCenterX(index: number): number {
    let itemWidth = this.width / this.menuLength;
    let basicsX = itemWidth * index;
    // 获取当前选项的中间点所以用 宽度 / 2
    let centerWidth = itemWidth / 2;
    return basicsX + centerWidth;
  }
}

/**
 * 凹槽使用类
 */
@Observed
export class ConcaveCircle extends CircleClass {
  // X的定位
  @Track
  positionX: number = 0;
  // Y的定位
  @Track
  positionY: number = 0;
  // 旧的定位
  oldPositionX: number = 0
  oldPositionY: number = 0
  // 悬浮球半径
  @Track
  circleRadius: number = 0;
  @Track
  circleDiameter: number = 0;

  constructor(context: CanvasRenderingContext2D, menuLength: number) {
    super({
      width: context.width,
      height: context.height,
      menuLength: menuLength
    });
    this.initCircleRadius();
    this.resetXY();
  }

  /**
   * 设置悬浮球半径 -- 比正常半径要小一圈
   */
  initCircleRadius(): void {
    // 半径
    this.circleRadius = this.getMinWidth() / 2 - SURPLUSRADIUS;
    // 直径
    this.circleDiameter = this.circleRadius * 2;
  }

  /**
   * 初始化  X Y
   */
  resetXY(): void {
    this.positionY = -this.circleRadius
    this.positionX = this.getAutoPositionX(0)
    this.oldPositionX = 0
    this.oldPositionY = 0
  }

  /**
   * 根据选项自动获取距离  X  值
   * @param { number } index - 当球选中项的下标
   * @returns { number }
   */
  getAutoPositionX(index: number): number {
    return this.getMenuCenterX(index) - this.circleRadius
  }

  /**
   * 设置坐标
   * @param { RaisedCircleSetPostionXYType } obj
   */
  setPositionXY(position: RaisedCircleSetPostionXYType): void {
    if (position.x || position.x === 0) {
      this.oldPositionX = this.positionX;
      this.positionX = position.x;
    }
    if (position.y || position.y === 0) {
      this.oldPositionY = this.positionY
      this.positionY = position.y;
    }
  }
}

/**
 * 凸起使用类
 */
@Observed
export class ChamferInfo extends CircleClass {
  // 悬浮球直径
  @Track
  circleDiameter: number = 0;
  // 悬浮球半径
  @Track
  circleRadius: number = 0;
  // 偏移量
  @Track
  circleOffsetX: number = 0;
  @Track
  circleOffsetY: number = 0;
  // 悬浮球左右俩边倒角坐标
  @Track
  chamferXY: [number, number] = [0, 0];
  // 悬浮球俩测倒角半径
  @Track
  chamferRadius: number;

  constructor(context: componentUtils.ComponentInfo, menuLength: number, ChamferRadius: number = 30) {
    super({
      width: px2vp(context.size.width),
      height: px2vp(context.size.height),
      menuLength: menuLength
    });

    this.initCircleRadius();
    // 设置倒角半径
    this.chamferRadius = ChamferRadius;
    this.getChamferXY();
  }

  /**
   * 设置悬浮球直径
   */
  initCircleRadius(): void {
    this.circleDiameter = this.getMinWidth();
    // 获取半径
    this.circleRadius = this.circleDiameter / 2;

    this.circleOffsetX = this.circleRadius;
    // 悬浮球 y 轴偏移直径的 三分之一
    this.circleOffsetY = this.circleDiameter / 3;
  }

  /**
   * 获取俩边倒角中心位置
   */
  getChamferXY(): void {
    this.chamferXY = utilGetChamferXY(this.circleDiameter, this.chamferRadius)
  }
}

/**
 * 凸起中选中时 图片Y轴偏移量
 */
@Observed
export class RaisedSelectImageInfo extends CircleClass {
  // Y轴偏移量
  @Track
  offsetY: number = 0;

  constructor(context: componentUtils.ComponentInfo) {
    super({
      width: px2vp(context.size.width),
      height: px2vp(context.size.height),
      menuLength: 0
    });
    this.offsetY = px2vp(context.localOffset.y);
  }

  /**
   * 获取添加自身后的偏移量
   * @returns { number }
   */
  getCenterOffsetY(): number {
    // 获取自身的一半
    let widthHalf = this.width / 2;
    return this.offsetY + widthHalf
  }
}



