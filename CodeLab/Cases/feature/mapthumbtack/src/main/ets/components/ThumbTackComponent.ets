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

import { ThumbTackCommonConstants, ThumbTackState } from '../model/CommonConstants';
import { Animator as animator, AnimatorResult } from '@kit.ArkUI';

/**
 * 定位大头针组件
 * @param thumbTackState 用于设置大头针状态：
 * ThumbTackState.EMPTY（无动画）、
 * ThumbTackState.LOADING（展示波纹动画）、
 * ThumbTackState.SHOWING（展示弹跳动画）。
 * @param thumbTackWidth 用于设置大头针的宽度。
 * @param animationFinishCallback 大头针动画结束时回调。
 */
@Component
export struct ThumbTackComponent {
  @Prop thumbTackState: ThumbTackState = ThumbTackState.EMPTY;
  // 20, 大头针宽度未设置时，默认20
  public thumbTackWidth: number = 20;
  public animationFinishCallback: () => void = () => {
  };
  @State private greenTackHatBrimWidth: number = 0;
  @State private greenTackHatWidth: number = 0;
  @State private greenHatZIdx: number = ThumbTackCommonConstants.ICON_UP_LAYER_RING_Z_IDX;
  @State private whiteTackHatBrimWidth: number = 0;
  @State private whiteTackHatWidth: number = 0;
  @State private whiteHatZIdx: number = ThumbTackCommonConstants.ICON_DOWN_LAYER_RING_Z_IDX;
  @State private tackPostOffset: number = 0;
  @State private tackPostHeight: number = 0;
  @State private tackPostWidth: number = 0;
  private hatBrimWidthAnimator: AnimatorResult = {} as AnimatorResult;
  private postOffsetAnimator: AnimatorResult = {} as AnimatorResult;
  private postHeightAnimator: AnimatorResult = {} as AnimatorResult;

  aboutToAppear(): void {
    this.tackPostWidth = this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_WIDTH_RATIO;
    this.greenTackHatWidth = this.thumbTackWidth;
    this.greenTackHatBrimWidth = this.thumbTackWidth * ThumbTackCommonConstants.TACK_HAT_BRIM_WIDTH_RATIO;
    this.whiteTackHatWidth = this.thumbTackWidth;
    this.tackPostHeight = this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_HEIGHT_RATIO;
  }
  // 创建大头针针杆动画
  createVerticalPostAnimation() {
    // 创建针杆位置偏移动画
    this.postOffsetAnimator = animator.create({
      // 100, 大头针针尖位置偏移动画持续时间100ms
      duration: 100,
      easing: 'fast-out-slow-in',
      // 200, 动画延时200ms执行
      delay: 200,
      fill: 'forwards',
      direction: 'alternate',
      iterations: 2,
      begin: 0,
      end: this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_ANIMATION_OFFSET_RATIO
    })

    this.postOffsetAnimator.onFinish = () => {
      // 5， 动画结束，延时5ms停止动画
      setTimeout(() => {
        this.postOffsetAnimator.cancel();
      }, 5);
    }

    this.postOffsetAnimator.onCancel = () => {
      this.tackPostOffset = 0;
    }
    this.postOffsetAnimator.onFrame = (value) => {
      this.tackPostOffset = value;
    }

    // 创建针杆长度变化动画
    this.postHeightAnimator = animator.create({
      // 大头针针柄长度动画持续200ms
      duration: 200,
      easing: 'fast-out-slow-in',
      delay: 0,
      fill: 'forwards',
      direction: 'alternate',
      iterations: 2,
      begin: this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_HEIGHT_RATIO,
      end: this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_ANIMATION_HEIGHT_RATIO
    })

    this.postHeightAnimator.onFinish = () => {
      // 5， 动画结束，延时5ms停止动画
      this.animationFinishCallback();
      setTimeout(() => {
        this.postHeightAnimator.cancel();
      }, 5);
    }
    this.postHeightAnimator.onCancel = () => {
      this.tackPostHeight = this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_HEIGHT_RATIO;
    }
    this.postHeightAnimator.onFrame = (value) => {
      this.tackPostHeight = value;
    }
  }

  // 创建帧帽波纹动画
  createRingAnimation() {
    // 创建帽檐宽度变化动画
    this.hatBrimWidthAnimator = animator.create({
      // 400， 大头针帽檐动画持续400ms
      duration: 400,
      easing: 'linear',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: -1,
      begin: 0,
      end: this.thumbTackWidth * ThumbTackCommonConstants.TACK_HAT_BRIM_WIDTH_RATIO
    })
    this.hatBrimWidthAnimator.onRepeat = () => {
      let tmp: number = this.greenHatZIdx;
      this.greenHatZIdx = this.whiteHatZIdx;
      this.whiteHatZIdx = tmp;
    }
    this.hatBrimWidthAnimator.onCancel = () => {
      this.whiteTackHatWidth = this.thumbTackWidth * ThumbTackCommonConstants.TACK_HAT_ANIMATION_HEIGHT_RATIO;
      this.whiteHatZIdx = ThumbTackCommonConstants.ICON_DOWN_LAYER_RING_Z_IDX;
      this.greenHatZIdx = ThumbTackCommonConstants.ICON_UP_LAYER_RING_Z_IDX;
      this.greenTackHatBrimWidth = this.thumbTackWidth * ThumbTackCommonConstants.TACK_HAT_BRIM_WIDTH_RATIO;
      this.greenTackHatWidth = this.thumbTackWidth;
    }
    this.hatBrimWidthAnimator.onFrame = (value) => {
      if (this.greenHatZIdx === ThumbTackCommonConstants.ICON_UP_LAYER_RING_Z_IDX) {
        this.greenTackHatBrimWidth = value;
        this.greenTackHatWidth =
          this.thumbTackWidth * (1 - 2 * ThumbTackCommonConstants.TACK_HAT_BRIM_WIDTH_RATIO) + 2 * value;
      }
      if (this.whiteHatZIdx === ThumbTackCommonConstants.ICON_UP_LAYER_RING_Z_IDX) {
        this.whiteTackHatBrimWidth = value;
        this.whiteTackHatWidth =
          this.thumbTackWidth * (1 - 2 * ThumbTackCommonConstants.TACK_HAT_BRIM_WIDTH_RATIO) + 2 * value;
      }
    }
  }

  build() {
    Column() {
      RelativeContainer() {
        Column()
          .width(this.tackPostWidth)
          .height(this.tackPostOffset)
          .backgroundColor(Color.Transparent)
          .zIndex(0)
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .id('invisiblePost')
        Column()
          .width(this.tackPostWidth)
          .height(this.tackPostHeight)
          .borderRadius(this.thumbTackWidth * ThumbTackCommonConstants.TACK_POST_RADIUS_RATIO)
          .backgroundColor(Color.Green)
          .zIndex(0)
          .alignRules({
            bottom: { anchor: 'invisiblePost', align: VerticalAlign.Top },
            middle: { anchor: 'invisiblePost', align: HorizontalAlign.Center }
          })
          .id('tackPost')
        Button()
          .type(ButtonType.Circle)
          .height(this.greenTackHatWidth)
          .backgroundColor(Color.White)
          .borderWidth(this.greenTackHatBrimWidth)
          .borderColor(Color.Green)
          .id('littleCircle')
          .zIndex(this.greenHatZIdx)
          .alignRules({
            center: { anchor: 'tackPost', align: VerticalAlign.Top },
            middle: { anchor: 'tackPost', align: HorizontalAlign.Center }
          })
        if ((this.thumbTackState === ThumbTackState.LOADING)) {
          Button()
            .type(ButtonType.Circle)
            .height(this.whiteTackHatWidth)
            .backgroundColor(Color.Green)
            .borderWidth(this.whiteTackHatBrimWidth)
            .borderColor(Color.White)
            .id('little1Circle')
            .zIndex(this.whiteHatZIdx)
            .alignRules({
              center: { anchor: 'tackPost', align: VerticalAlign.Top },
              middle: { anchor: 'tackPost', align: HorizontalAlign.Center }
            })
            .onAppear(() => {
              setTimeout(() => {
                this.createRingAnimation();
                this.hatBrimWidthAnimator.play();
              }, ThumbTackCommonConstants.ICON_START_ANIMATION_DELAY);
            })
            .onDisAppear(() => {
              setTimeout(() => {
                this.hatBrimWidthAnimator.cancel();
                if (this.thumbTackState === ThumbTackState.SHOWING) {
                  this.createVerticalPostAnimation();
                  this.postOffsetAnimator.play();
                  this.postHeightAnimator.play();
                }
              }, ThumbTackCommonConstants.ICON_START_ANIMATION_DELAY);
            })
        }
      }
      .backgroundColor(Color.Transparent)
      .hitTestBehavior(HitTestMode.Transparent)
      .width('100%')
      .height('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
