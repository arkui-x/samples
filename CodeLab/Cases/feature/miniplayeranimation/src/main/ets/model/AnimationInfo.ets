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
 * 动画相关参数类
 */
@Observed
export class AnimationInfo {
  isExpand: boolean; // Mini条是否展开标志位
  isAnimating: boolean; // 是否正在动画标志位
  topUnsafeHeight: number; // 顶部非安全区域高度（状态栏高度）
  bottomUnsafeHeight: number; // 底部非安全区域高度（导航栏高度）
  detailsPageImgPositionY: number; // 全屏播放页歌曲封面Y轴位置
  miniImgPositionY: number; // Mini条歌曲封面Y轴位置
  screenHeight: number; // 屏幕高度(包含顶部和底部非安全区域高度)
  screenWidth: number; // 屏幕宽度
  miniDistanceToTop: number; // Mini条距离屏幕顶部的高度（包含顶部状态栏高度）
  miniDistanceToBottom: number; // Mini条距离屏幕底部的高度（Mini条高度+TabBar高度+底部非安全区域高度（导航栏高度））
  miniImgOpacity: number; // Mini条实际歌曲封面的透明度
  miniImgAnimateOpacity: number; // 用于动画的Mini条歌曲封面的透明度
  miniImgToDetailsPageImgDistance: number; // Mini条歌曲封面Y轴位置到全屏播放页歌曲封面Y轴位置的距离
  miniImgOffsetY: number; // Mini条歌曲封面一镜到底动画过程中偏移的距离
  miniImgOffsetSize: number; // Mini条歌曲封面动画过程中尺寸变化量
  miniPlayerOpacity: number; // Mini条透明度
  miniImgOffsetX: number; // Mini条歌曲封面动画过程中X轴偏移量
  detailsPageOffsetY: number; // 全屏播放页Y轴偏移距离
  miniChangeHeight: number; // Mini条动画过程中高度拉伸大小
  detailsPageTopOpacity: number; // 全屏播放页收起按钮父容器Row透明度控制
  detailsPagePositionY: number; // 动画过程中全屏播放页Y轴位置
  detailsPageOpacity: number; // 全屏播放页透明度

  constructor(
    isExpand: boolean = false,
    isAnimating: boolean = false,
    topUnsafeHeight: number = 0,
    bottomUnsafeHeight: number = 0,
    detailsPageImgPositionY: number = 0,
    miniImgPositionY: number = 0,
    screenHeight: number = 0,
    screenWidth: number = 0,
    miniDistanceToTop: number = 0,
    miniDistanceToBottom: number = 0,
    miniImgOpacity: number = 1,
    miniImgAnimateOpacity: number = 0,
    miniImgToDetailsPageImgDistance: number = 0,
    miniImgOffsetY: number = 0,
    miniImgOffsetSize: number = 0,
    miniPlayerOpacity: number = 1,
    miniImgOffsetX: number = 0,
    detailsPageOffsetY: number = 0,
    miniChangeHeight: number = 0,
    detailsPageTopOpacity: number = 1,
    detailsPagePositionY: number = 0,
    detailsPageOpacity: number = 0
  ) {
    this.isExpand = isExpand;
    this.isAnimating = isAnimating;
    this.topUnsafeHeight = topUnsafeHeight;
    this.bottomUnsafeHeight = bottomUnsafeHeight;
    this.detailsPageImgPositionY = detailsPageImgPositionY;
    this.miniImgPositionY = miniImgPositionY;
    this.screenHeight = screenHeight;
    this.screenWidth = screenWidth;
    this.miniDistanceToTop = miniDistanceToTop;
    this.miniDistanceToBottom = miniDistanceToBottom;
    this.miniImgOpacity = miniImgOpacity;
    this.miniImgAnimateOpacity = miniImgAnimateOpacity;
    this.miniImgToDetailsPageImgDistance = miniImgToDetailsPageImgDistance;
    this.miniImgOffsetY = miniImgOffsetY;
    this.miniImgOffsetSize = miniImgOffsetSize;
    this.miniPlayerOpacity = miniPlayerOpacity;
    this.miniImgOffsetX = miniImgOffsetX;
    this.detailsPageOffsetY = detailsPageOffsetY;
    this.miniChangeHeight = miniChangeHeight;
    this.detailsPageTopOpacity = detailsPageTopOpacity;
    this.detailsPagePositionY = detailsPagePositionY;
    this.detailsPageOpacity = detailsPageOpacity;
  }
}