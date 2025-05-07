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
import { curves } from '@kit.ArkUI';
import { BasicDataSource } from './BasicDataSource';

/**
 * ClickIconItem 点击出现的图标项。
 * 包含唯一标识符、图标的资源引用以及其在界面上的位置信息。
 */
export interface ClickIconItem {
  id: string; // 图标唯一标识
  icon: Resource; // 图标资源
  position: Position; // 图标位置
}

/**
 * ScaleUpAndFadeOutOptions 点击时图标放大淡出动画的参数。
 */
export class ScaleUpAndFadeOutOptions {
  transitionInDuration: number = 200; // 入场动画时长
  transitionInScale: number = 0; // 入场缩放动画比例
  transitionInRotateAngle: number = 30; // 入场旋转抖动角度
  transitionInRotateCurve: ICurve = curves.springMotion(0.2, 0.3); // 入场旋转抖动动画曲线，使用弹性动画曲线
  transitionOutDuration: number = 400; // 出场动画时长
  transitionOutScale: number = 1.8; // 出场缩放动画比例
}

/**
 * MoveUpAndFadeOutOptions 点击时图标向上位移淡出动画的参数。
 */
export class MoveUpAndFadeOutOptions {
  transitionInDuration: number = 200; // 入场动画时长
  transitionInScale: number = 1.3; // 入场缩放动画比例
  transitionInRotateAngle: number = 30; // 入场旋转抖动角度
  transitionInRotateCurve: ICurve = curves.springMotion(0.2, 0.3); // 入场旋转抖动动画曲线，使用弹性动画曲线
  transitionOutDuration: number = 400; // 出场动画时长
  transitionOutTranslateY: number = -120; // 出场位移动画时长，负值向上，正值向下
  transitionOutScale: number = 1.5; // 出场缩放动画比例
}

/**
 * 定义动画类型枚举
 */
export enum IconAnimationType {
  ScaleUpAndFadeOut, // 放大淡出动画
  MoveUpAndFadeOut // 向上移动淡出动画
}

/**
 * ClickIconDataSource 类继承自 BasicDataSource<ClickIconItem>，处理图标集合数据源操作
 * @extends {BasicDataSource<ClickIconItem>}
 */
export class ClickIconDataSource extends BasicDataSource<ClickIconItem> {}