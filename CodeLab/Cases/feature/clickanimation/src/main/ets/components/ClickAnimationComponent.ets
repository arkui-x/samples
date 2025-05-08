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

import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { ICON_LIST } from '../mock/MockData';
import { ClickIconDataSource, ClickIconItem, IconAnimationType, MoveUpAndFadeOutOptions, ScaleUpAndFadeOutOptions } from '../model/ClickIconDataModel';
import { logger } from '../utils/Logger';

const TAG = 'ClickAnimationComponent';

/**
 * 功能描述: 提供点击动画组件，能够在用户进行点击交互时展示生动的动画效果，如图标放大淡出或向上移动淡出等。此组件支持自定义背景内容和上方叠加的其他UI元素，
 *          并且支持通过参数自定义动画行为，例如调整动画速度、改变图标尺寸等。
 *
 * 实现原理：
 * 1. 定义Stack布局来承载背景视频和点击出现的动画元素以及可能存在其他功能模块。
 * 2. 点击效果区域使用Stack组件，结合LazyForEach实现图像元素的动态上下树和叠加显示。
 * 3. 为点击效果区域添加TapGesture手势，当用户双击或连续快速点击区域时，添加新的图标项到LazyForEach数据源末尾。
 * 4. 为显示图标的Image组件设置transition属性，根据设定的动画类型（ScaleUpAndFadeOut 或 MoveUpAndFadeOut），应用不同的动画效果，并利用combine函数实现多个转场效果的组合。
 * 5. 动画ScaleUpAndFadeOut类型使用入场动画实现图标放大抖动淡入效果，使用出场动画实现图标放大淡出的效果。
 *    MoveUpAndFadeOut类型使用入场动画实现图标缩小淡入效果，使用出场动画实现图标位移放大淡出的效果。
 * 6. 两种类型的动画都在入场动画结束后，从数据源移除对应的图标数据，触发图标出场动画，并保证图标数据不会一直累积。
 * 7. 当父组件传入点击回调时，在每次触发动画后调用，以便在每次触发动画后进行其他操作，例如常见的点赞计数等。
 *
 * @param {number} [iconWidth] - 图标的宽度，默认为60像素。
 * @param {number} [iconHeight] - 图标的高度，默认为60像素。
 * @param {IconAnimationType} [animationType] - 动画类型，默认为放大淡出动画。
 * @param {Resource[]} [iconArray] - 图标资源数组，默认使用预定义的ICON_LIST。
 * @param {ScaleUpAndFadeOutOptions} [scaleUpAndFadeOutOptions] - 放大淡出动画参数，默认新建实例。
 * @param {MoveUpAndFadeOutOptions} [moveUpAndFadeOutOptions] - 向上移动淡出动画参数，默认新建实例。
 * @param {boolean} [isOpenVibration] - 点击时是否开启振动效果，默认值true。
 * @param {vibrator.HapticFeedback} [presetVibration] - 预设振动效果ID，默认值vibrator.HapticFeedback.EFFECT_SOFT。
 * @param {number} [intensity] - 振动强度，取值范围0到100，默认值100。若振动效果不支持强度调节或设备不支持时，则按默认强度振动。
 * @param {() => void} [clickCallback] - 点击回调函数，在每次点击后执行。
 * @param {() => void} [videoBackgroundSlotParam] - 视频背景插槽参数，用于定义背景内容。
 * @param {() => void} [otherFunctionModuleSlotParam] - 其他功能模块插槽参数，用于扩展更多功能。
 */
@Component
export struct ClickAnimationComponent {
  // -------------------对外暴露变量-----------------------
  iconWidth: number = 60; // 图标的宽度，默认60像素。
  iconHeight: number = 60; // 图标的高度，默认60像素。
  animationType: IconAnimationType = IconAnimationType.ScaleUpAndFadeOut; // 动画类型，默认为放大淡出动画。
  iconArray: Resource[] = ICON_LIST; // 图标资源数组。
  scaleUpAndFadeOutOptions: ScaleUpAndFadeOutOptions = new ScaleUpAndFadeOutOptions(); // 放大淡出动画参数。
  moveUpAndFadeOutOptions: MoveUpAndFadeOutOptions = new MoveUpAndFadeOutOptions(); // 向上移动淡出动画参数。
  isOpenVibration: boolean = true; // 点击时是否开启振动效果
  presetVibration: vibrator.HapticFeedback | null =
    PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS ? vibrator.HapticFeedback.EFFECT_SOFT : null // 预设振动效果ID
  intensity: number = 100; // 振动强度，取值范围0到100，默认值100。若振动效果不支持强度调节或设备不支持时，则按默认强度振动。
  clickCallback?: () => void; // 点击回调
  // 视频背景插槽参数
  @BuilderParam videoBackgroundSlotParam: () => void = this.videoBackgroundSlot;
  // 其他功能模块插槽参数，可选
  @BuilderParam otherFunctionModuleSlotParam: () => void;
  // --------------------私有属性----------------------------
  private data: ClickIconDataSource = new ClickIconDataSource(); // 数据源，用于管理图标的集合。
  private num: number = 0; // 当前插入图标的编号。
  private isDoubleClick: boolean = false; // 是否双击
  private timeoutId: number | null = null; // 定时器ID

  /**
   * 获取动画效果。
   * @returns {TransitionEffect} 返回一个 TransitionEffect 实例，根据动画类型不同返回不同的动画效果。
   */
  getAnimation(): TransitionEffect {
    if (this.animationType === IconAnimationType.ScaleUpAndFadeOut) {
      // TODO：知识点：使用TransitionEffect.asymmetric()方法设置不同的出入场动画，实现两种不同的动画效果，并利用combine函数实现透明度、旋转角度、位移和缩放组合的转场效果。
      return TransitionEffect.asymmetric(
        // 入场动画配置：放大抖动淡入
        // 出场动画配置：放大淡出
        TransitionEffect.OPACITY.animation({
          duration: this.scaleUpAndFadeOutOptions.transitionInDuration,
          curve: Curve.Linear
        })
          .combine(TransitionEffect.scale({
            x: this.scaleUpAndFadeOutOptions.transitionInScale,
            y: this.scaleUpAndFadeOutOptions.transitionInScale
          }).animation({ duration: this.scaleUpAndFadeOutOptions.transitionInDuration, curve: Curve.EaseOut }))
          .combine(TransitionEffect.rotate({
            angle: this.scaleUpAndFadeOutOptions.transitionInRotateAngle
          }).animation({ curve: this.scaleUpAndFadeOutOptions.transitionInRotateCurve })),
        TransitionEffect.OPACITY.animation({
          duration: this.scaleUpAndFadeOutOptions.transitionOutDuration,
          curve: Curve.EaseIn
        })
          .combine(TransitionEffect.scale({
            x: this.scaleUpAndFadeOutOptions.transitionOutScale,
            y: this.scaleUpAndFadeOutOptions.transitionOutScale
          }).animation({ duration: this.scaleUpAndFadeOutOptions.transitionOutDuration, curve: Curve.EaseOut })))
    } else {
      return TransitionEffect.asymmetric(
        // 入场动画配置：缩小抖动淡入
        // 出场动画配置：放大淡出和位移
        TransitionEffect.OPACITY.animation({
          duration: this.moveUpAndFadeOutOptions.transitionInDuration,
          curve: Curve.Linear
        })
          .combine(TransitionEffect.scale({
            x: this.moveUpAndFadeOutOptions.transitionInScale,
            y: this.moveUpAndFadeOutOptions.transitionInScale
          }).animation({ duration: this.moveUpAndFadeOutOptions.transitionInDuration, curve: Curve.EaseOut }))
          .combine(TransitionEffect.rotate({
            angle: this.moveUpAndFadeOutOptions.transitionInRotateAngle
          }).animation({ curve: this.moveUpAndFadeOutOptions.transitionInRotateCurve })),
        TransitionEffect.OPACITY.animation({
          duration: this.moveUpAndFadeOutOptions.transitionOutDuration,
          curve: Curve.EaseIn
        })
          .combine(TransitionEffect.translate({ x: 0, y: this.moveUpAndFadeOutOptions.transitionOutTranslateY })
            .animation({ duration: this.moveUpAndFadeOutOptions.transitionOutDuration, curve: Curve.EaseOut }))
          .combine(TransitionEffect.scale({
            x: this.moveUpAndFadeOutOptions.transitionOutScale,
            y: this.moveUpAndFadeOutOptions.transitionOutScale
          }).animation({ duration: this.moveUpAndFadeOutOptions.transitionOutDuration, curve: Curve.EaseOut }))
      )
    }
  }

  /**
   * 设置振动效果。
   */
  setVibrator() {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // 查询设备是否支持预设振动效果
      vibrator.isSupportEffect(this.presetVibration, (err: BusinessError, state: boolean) => {
        if (err) {
          logger.error(TAG, `Failed to query effect. Code: ${err.code}, message: ${err.message}`);
          return;
        }
        if (state) {
          // 触发马达振动，使用预设效果HapticFeedback.EFFECT_SOFT，强度默认为100，用途设置为‘touch'
          vibrator.startVibration({
            type: 'preset',
            effectId: this.presetVibration,
            intensity: this.intensity,
          }, {
            usage: 'touch'
          }, (error: BusinessError) => {
            if (error) {
              logger.error(TAG, `Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
            } else {
              logger.info(TAG, 'Succeed in starting vibration');
            }
          });
        }
      })
    }
  }

  /**
   * 背景视频插槽。
   */
  @Builder
  videoBackgroundSlot() {
    Video({ src: $r('app.media.click_animation_test_video') })
      .height($r('app.string.click_animation_full_size'))
      .width($r('app.string.click_animation_full_size'))
      .autoPlay(true)
      .loop(true)
      .controls(false)
  }

  build() {
    Stack() {
      // 背景视频
      this.videoBackgroundSlotParam()

      // 显示点击效果区域
      Stack() {
        // TODO：性能知识点: 动态加载数据或者数据量比较多的情况下，建议使用LazyForEach
        LazyForEach(this.data, (item: ClickIconItem, index: number) => {
          Image(item.icon)
            .width(this.iconWidth)
            .height(this.iconHeight)
            .position({
              x: item.position.x !== undefined ? (item.position.x as number) - this.iconWidth / 2 : 0,
              y: item.position.y !== undefined ? (item.position.y as number) - this.iconHeight / 2 : 0,
            })
            .transition(
              this.getAnimation(), // 获取动画效果
              (transitionIn: boolean) => {
                // 入场动画结束后，从数据源移除数据
                if (transitionIn) {
                  this.data.shiftData();
                }
              }
            )
        }, (item: ClickIconItem, index: number) => item.id)
      }
      .height($r('app.string.click_animation_full_size'))
      .width($r('app.string.click_animation_full_size'))
      .gesture(
        TapGesture({ count: 1 })
          .onAction((event: GestureEvent) => {
            // 通过isDoubleClick变量控制动画触发方式，首次触发动画需要双击，后续每次点击之间的间隔在500ms内时（配置多击时默认的超时时间）单击即可触发动画
            if (this.isDoubleClick) {
              // 添加新的图标项到数据源，并更新编号
              this.data.pushData({
                id: this.num.toString(),
                icon: this.iconArray[Math.floor(Math.random() * 5)],
                position: {
                  x: event.fingerList[0].localX,
                  y: event.fingerList[0].localY
                }
              });
              this.num++;
              if (this.isOpenVibration) {
                if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                  // 设置振动效果
                  this.setVibrator();
                }
              }
              // 如果父组件设置了点击回调，则执行回调
              if (this.clickCallback) {
                this.clickCallback();
              }
            } else {
              this.isDoubleClick = true;
            }
            // 防抖控制，每次点击后都重置定时器，最后一次点击后，延时500ms后，isDoubleClick恢复为false
            if (this.timeoutId !== null) {
              clearTimeout(this.timeoutId);
            }
            this.timeoutId = setTimeout(() => {
              this.isDoubleClick = false;
              this.timeoutId = null;
            }, 500);
          })
      )

      // 其他功能模块
      if (this.otherFunctionModuleSlotParam) {
        this.otherFunctionModuleSlotParam()
      }
    }
    .height($r('app.string.click_animation_full_size'))
    .width($r('app.string.click_animation_full_size'))
  }
}