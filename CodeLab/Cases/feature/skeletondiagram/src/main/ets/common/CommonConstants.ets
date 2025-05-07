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

/**
 * Common constants for common component.
 */
export class CommonConstants {
  // font family
  static readonly HARMONY_HEI_TI_FONT_FAMILY = 'HarmonyHeiTi';
  static readonly HARMONY_HEI_TI_MEDIUM_FONT_FAMILY = 'HarmonyHeiTi-Medium';
  // opacity
  static readonly FIRST_LEVEL_OPACITY: number = 0.9;
  static readonly SECOND_LEVEL_OPACITY: number = 0.6;
  static readonly HALF_OPACITY: number = 0.5;
  // space
  static readonly SPACE_4: number = 4;
  static readonly SPACE_8: number = 8;
  static readonly SPACE_12: number = 12;
  // maxLines
  static readonly MAX_LINE_ONE: number = 1;
  static readonly MAX_LINE_TWO: number = 2;
  // percent
  static readonly FULL_PERCENT: string = '100%';
  // layout weight
  static readonly LAYOUT_WEIGHT: number = 1;
  // responseCode
  static readonly SUCCESS: number = 200;
  // border width
  static readonly BORDER_WIDTH: number = 1;
  // aspect ratio
  static readonly IMAGE_ASPECT_RATIO_ONE: number = 1;
  static readonly IMAGE_ASPECT_RATIO_ONE_POINT_SIX: number = 1.6;
  // skeleton animation config
  static readonly SKELETON_ANIMATION: AnimateParam = {
    duration: 400, // 动画持续时间，为400毫秒。
    tempo: 0.6, // 动画播放速度，值越大动画播放越快，值越小播放越慢，为0时无动画效果。
    curve: Curve.EaseInOut, // 动画曲线,动画以低速开始和结束。
    delay: 200, // 动画延迟播放时间，为200毫秒
    iterations: -1, // 动画播放次数,设置为-1时表示无限次播放。
    playMode: PlayMode.Alternate // 动画播放模式，动画在奇数次（1、3、5...）正向播放，在偶数次（2、4、6...）反向播放。
  }
}

/**
 * SkeletonData for SkeletonView
 */
export const SkeletonData: SkeletonType[] = [
  {
    isMine: false
  },
  {
    isMine: false
  },
  {
    isMine: false
  },
  {
    isMine: true
  },
  {
    isMine: false
  },
  {
    isMine: true
  },
  {
    isMine: true
  },
  {
    isMine: false
  },
  {
    isMine: false
  },
  {
    isMine: false
  },
  {
    isMine: false
  },
  {
    isMine: true
  },
  {
    isMine: false
  },
  {
    isMine: false
  }
]

export interface SkeletonType {
  isMine: boolean;
}