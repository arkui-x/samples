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

import Constants from './Constants';

/**
 * 行程信息类型
 *
 * @param id
 * @param trainNumber 列车号
 * @param wholeCourse 全程
 * @param startingTime 起始时间
 * @param endingTime 终止时间
 * @param timeDifference 距出发时间
 * @param origin 起始位置
 * @param destination 目的地
 * @param ticketEntrance 检票口
 * @param vehicleModel 车型
 */
export interface TripDataType {
  id: number;
  trainNumber: string;
  wholeCourse: ResourceStr;
  startingTime: string;
  endingTime: string;
  timeDifference: ResourceStr;
  origin: ResourceStr;
  destination: ResourceStr;
  ticketEntrance: ResourceStr;
  vehicleModel: ResourceStr;
}

/**
 * 跑马灯滚动动画属性
 * @param {number} [iterations] - 动画播放次数。默认播放一次，设置为-1时表示无限次播放。设置为0时表示无动画效果
 * @param {number} [duration] - 动画持续时间，单位为毫秒
 * @param {number} [tempo] - 动画播放速度，值越大动画播放越快，值越小播放越慢，为0时无动画效果
 * @param {PlayMode} [playMode] - 控制跑马灯向左还是向右滚动。方向向右的时候，文本需要取反，如牌匾 -> 匾牌，这样可以给用户良好的阅读体验
 * @param {number} [delayTime] - 动画延迟播放时间，单位为ms(毫秒)，默认延时1s播放
 */
export class MarqueeAnimationModifier {
  iterations: number;
  duration: number;
  tempo: number;
  playMode: PlayMode;
  delayTime: number;

  constructor(iterations: number = -1, duration: number = Constants.ANIMATION_DURATION, tempo: number = 1,
    playMode: PlayMode = PlayMode.Normal, delayTime: number = Constants.DELAY_TIME) {
    this.iterations = iterations;
    this.duration = duration;
    this.tempo = tempo;
    this.playMode = playMode;
    this.delayTime = delayTime;
  }
}

/**
 * 跑马灯滚动文本属性
 * @param {Length} [scrollWidth] - 滚动轴宽度
 * @param {number} [space] - 文本间隔
 */
export class MarqueeScrollModifier {
  scrollWidth: Length;
  space: number;

  constructor(scrollWidth: Length = Constants.DEFAULT_SCROLL_WIDTH, space: number = Constants.BLANK_SPACE) {
    this.scrollWidth = scrollWidth;
    this.space = space;
  }
}