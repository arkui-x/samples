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

import { CommonConstants } from '../common/CommonConstants';
import { SwiperData, SwiperItemViewType } from '../components/model/SwiperData';
import { logger } from './Logger';

/**
 * 功能描述:
 * 1. isLoop为true，轮播图自动切换，向左或者向右滑动，轮播图可以切换。
 * 2. 点击轮播图图片，开发者可以根据自己的需求执行对应的功能效果，比如点击跳转到指定页面。
 *
 * 实现原理:
 * 1. 通过stack组件堆叠图片，实现多层级效果，配合手势滑动和显式动画实现切换的动画效果。同时通过改变数据中间值currentIndex来改变组件zIndex层级和高度来实现切换的效果
 *
 * @param swiperListView - 轮播模块列表
 * @param currentIndex - 双向数据绑定当前索引
 * @param swiperAnimationDuration - 轮播切换动画时间
 * @param swiperSwitchDuration - 轮播每5s切换一次
 * @param isLoop - 是否循环播放
 * @param indicatorBuilder - 导航点自定义视图
 * @param swiperItemHandle - 点击swiper逻辑处理函数
 */

@Component
export struct SwiperSection {
  // -------------------对外暴露变量-----------------------
  // 轮播模块列表
  swiperListView: SwiperItemViewType[] = [];
  // 双向数据绑定当前索引
  @Link currentIndex: number;
  // 轮播切换动画时间
  swiperAnimationDuration: number = CommonConstants.SWIPER_ANIMATION_DURATION;
  // 轮播每5s切换一次
  swiperSwitchDuration: number = CommonConstants.SWIPER_SWITCH_DURATION;
  // 是否循环播放
  isLoop: boolean = true;
  // 导航点自定义视图
  @BuilderParam indicatorBuilder?: () => void;
  // 点击swiper逻辑处理函数
  swiperItemHandle: (swiperItemData: SwiperData) => void = (swiperItemData: SwiperData) => {};
  // --------------------私有属性----------------------------
  // 定时器句柄
  private swiperInterval: number = 0;
  // 数据中间值
  private halfCount: number = 0;
  // 初始化触摸Swiper的偏移量
  private offsetX: number = 0;

  aboutToAppear(): void {
    this.halfCount = Math.floor(this.swiperListView.length / 2);
    this.currentIndex = this.halfCount;
    if (this.isLoop) {
      this.swiperInterval = setInterval(() => {
        this.startAnimation(true, this.swiperAnimationDuration);
      }, this.swiperSwitchDuration);
    } else {
      this.startAnimation(true, this.swiperAnimationDuration);
    }
  }

  aboutToDisappear(): void {
    if (this.swiperInterval && this.isLoop) {
      // 页面销毁时，清除定时器
      clearInterval(this.swiperInterval);
    }
  }

  /**
   * 获取图片系数
   * @param index：索引值
   * @returns
   */
  getImgCoefficients(index: number): number {
    const coefficient: number = this.currentIndex - index; // 计算图片左右位置
    const tempCoefficient: number = Math.abs(coefficient);
    if (tempCoefficient <= this.halfCount) {
      return coefficient;
    }
    let tempOffset: number = this.swiperListView.length - tempCoefficient; // 判断图片位于左右层级位置
    if (tempOffset <= this.halfCount) {
      if (coefficient > 0) {
        return -tempOffset;
      }
      return tempOffset;
    }
    return 0;
  }

  /**
   * 计算偏移量
   * @param index：索引值
   * @returns
   */
  getOffSetX(index: number): number {
    const offsetIndex: number = this.getImgCoefficients(index);
    const tempOffset: number = Math.abs(offsetIndex);
    let offsetX: number = 0;
    if (tempOffset === 1) {
      // 根据图片层级系数来决定左右偏移量
      offsetX = CommonConstants.SWIPER_OFFSET_X * offsetIndex;
    }
    return offsetX;
  }

  // 性能：显式动画(https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-explicit-animation-V5)
  startAnimation(isLeft: boolean, duration: number): void {
    animateTo({
      duration: duration,
    }, () => {
      const tempIndex: number = isLeft ? this.currentIndex + 1 : this.currentIndex - 1 + this.swiperListView.length;
      this.currentIndex = tempIndex % this.swiperListView.length;
    })
  }

  build() {
    Column() {
      Stack() {
        // LazyForEach必须在容器组件内使用，仅有List、Grid、Swiper以及WaterFlow组件支持数据懒加载，其他组件仍然是一次性加载所有的数据。
        ForEach(this.swiperListView, (item: SwiperItemViewType, index: number) => {
          Column() {
            item.contentBuilder.builder(item.data)
          }
          .shadow(ShadowStyle.OUTER_DEFAULT_SM)
          .backgroundColor(Color.White)
          .borderRadius(CommonConstants.SWIPER_BORDER_RADIUS)
          .clip(true)
          .offset({
            x: this.getOffSetX(index),
            y: 0
          })
          .blur(index !== this.currentIndex ? CommonConstants.SWIPER_BLUR_VALUE : 0)
          // TODO: 知识点:通过animateTo实现动画并且同时改变currentIndex数据中间值来判断组件zIndex实现切换动画
          .zIndex(this.halfCount + 1 - Math.abs(this.getImgCoefficients(index)))
          .width($r('app.string.swipercomponent_swiper_stack_width'))
          .height(index !== this.currentIndex ? $r('app.string.swipercomponent_swiper_stack_height1') :
          $r('app.string.swipercomponent_swiper_stack_height2'))
          .onClick(() => {
            // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
            this.swiperItemHandle(item.data);
          })
        }, (item: SwiperItemViewType) => JSON.stringify(item))
      }
      .height($r('app.string.swipercomponent_main_page_swiper_height'))
      .width(CommonConstants.CONTENT_FULL_VIEW)
      .gesture(
        PanGesture({ direction: PanDirection.Horizontal })
          .onActionStart((event: GestureEvent) => {
            if (this.isLoop) {
              clearInterval(this.swiperInterval);
            }
            this.offsetX = event.offsetX;
          })
          .onActionEnd((event: GestureEvent) => {
            logger.info(`onActionEnd start`);
            let isLeft: boolean = event.offsetX < this.offsetX;
            if (event.offsetX - this.offsetX >= CommonConstants.SWIPER_LEFT_SCROLL ||
              event.offsetX - this.offsetX <= CommonConstants.SWIPER_RIGHT_SCROLL) {
              this.startAnimation(isLeft, this.swiperAnimationDuration);
            }
            if (this.isLoop) {
              this.swiperInterval = setInterval(() => {
                this.startAnimation(true, this.swiperAnimationDuration);
              }, this.swiperSwitchDuration);
            }
          })
      )
      .alignContent(Alignment.Center)
      .padding({
        left: $r('app.string.swipercomponent_main_page_padding2'),
        right: $r('app.string.swipercomponent_main_page_padding2'),
        top: $r('app.string.swipercomponent_main_page_padding2')
      })

      if (this.indicatorBuilder) {
        this.indicatorBuilder()
      }
    }
    .width(CommonConstants.CONTENT_FULL_VIEW)
  }
}