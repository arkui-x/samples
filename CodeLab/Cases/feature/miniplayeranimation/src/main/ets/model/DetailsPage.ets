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

import { AnimationInfo } from '../model/AnimationInfo';
import Constants from '../model/Constants';
import { AnimatorResult } from '@ohos.animator';

// 表示需要设置渐变色的容器的开始处
const GRADIENT_COLORS_START: number = 0.0;
// 表示需要设置渐变色的容器的结尾处
const GRADIENT_COLORS_END: number = 1.0;

/**
 * 全屏播放页
 */
@Component
export struct DetailsPage {
  // 设置手势滑动方向为上下滑动。用于全屏播放页手指上下滑动动画。
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Up | PanDirection.Down });
  // 动画相关参数类
  @ObjectLink animationInfo: AnimationInfo;
  // 动画对象
  @Link animatorObject: AnimatorResult;
  @StorageLink('statusHeight') statusHeight: number = 0; // 顶部状态栏高度

  // 自定义播放组件。仅用于UX展示
  @Builder
  playComponent() {
    Column() {
      Row() {
        Text($r('app.string.mini_player_animation_playback_duration'))
          .fontSize($r('app.float.mini_player_animation_font_size'))
          .opacity($r('app.float.mini_player_animation_time_opacity'))
          .fontColor(Color.White)
        Slider({
          value: Constants.SLIDER_CURRENT_VA,
          min: Constants.SLIDER_MIN_VAL,
          max: Constants.SLIDER_MAX_VAL,
          style: SliderStyle.OutSet
        })
          .width($r('app.string.mini_player_animation_slider_width'))
          .enabled(false) // 仅用于ux展示，不使能slider
          .trackColor($r('app.color.mini_player_animation_track_color'))
          .selectedColor($r('app.color.mini_player_animation_selected_color'))
          .trackThickness($r('app.float.mini_player_animation_track_thickness'))
          .onClick(() => {
            AlertDialog.show({
              message: $r('app.string.mini_player_animation_prompt_info'),
              alignment: DialogAlignment.Center
            });
          })
        Text($r('app.string.mini_player_animation_total_playback_duration'))
          .fontSize($r('app.float.mini_player_animation_font_size'))
          .opacity($r('app.float.mini_player_animation_time_opacity'))
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width($r('app.string.mini_player_animation_row_width'))
      .margin({
        top: $r('app.float.mini_player_animation_margin'),
        bottom: $r('app.float.mini_player_animation_margin')
      })

      Row() {
        Image($r('app.media.miniplayeranimation_single_play'))
          .size({
            width: $r('app.float.mini_player_animation_size'),
            height: $r('app.float.mini_player_animation_size')
          })

        Image($r('app.media.miniplayeranimation_play_previous'))
          .size({
            width: $r('app.float.mini_player_animation_play_size'),
            height: $r('app.float.mini_player_animation_play_size')
          })

        Image($r('app.media.miniplayeranimation_play'))
          .size({
            width: $r('app.float.mini_player_animation_big_play_size'),
            height: $r('app.float.mini_player_animation_big_play_size')
          })

        Image($r('app.media.miniplayeranimation_play_next'))
          .size({
            width: $r('app.float.mini_player_animation_play_size'),
            height: $r('app.float.mini_player_animation_play_size')
          })

        Image($r('app.media.miniplayeranimation_collect'))
          .size({
            width: $r('app.float.mini_player_animation_size'),
            height: $r('app.float.mini_player_animation_size')
          })
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width($r('app.string.mini_player_animation_full_size'))
    }.layoutWeight(Constants.LAYOUT_WEIGHT)
    .onClick(() => {
      AlertDialog.show({
        message: $r('app.string.mini_player_animation_prompt_info'),
        alignment: DialogAlignment.Center
      });
    })
  }

  build() {
    Stack() {
      // 全屏播放页背景,浅蓝色到浅灰色渐变
      Row()
        .width($r('app.string.mini_player_animation_full_size'))
        .height($r('app.string.mini_player_animation_full_size'))
        .linearGradient({
          direction: GradientDirection.Bottom, // 渐变方向
          repeating: true, // 渐变颜色是否重复
          colors: [[$r('app.color.mini_player_animation_light_blue_color'), GRADIENT_COLORS_START], [$r('app.color.mini_player_animation_light_gray_color'), GRADIENT_COLORS_END]] // 0.0表示需要设置渐变色的容器的开始处，1.0表示容器的结尾处
        })
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]) // 通过expandSafeArea属性支持组件不改变布局情况下扩展其绘制区域至安全区外。本例中设置全屏播放页背景图占满整个屏幕。

      Column() {
        Row() {
          Image($r('app.media.miniplayeranimation_down_arrow'))
            .width($r('app.float.mini_player_animation_down_arrow_size'))
            .height($r('app.float.mini_player_animation_down_arrow_size'))
            .opacity($r('app.float.mini_player_animation_down_arrow_opacity'))
            .margin({
              top: $r('app.float.mini_player_animation_margin_size'),
              left: $r('app.float.mini_player_animation_margin_size')
            })
            .id('retract')
            .onClick(() => {
              if (this.animatorObject) {
                // 启动动画。这里为收起动画
                this.animatorObject.play();
                this.animationInfo.isAnimating = true;
              }
            })

          Image($r('app.media.miniplayeranimation_share'))
            .width($r('app.float.mini_player_animation_size'))
            .height($r('app.float.mini_player_animation_size'))
            .margin({
              top: $r('app.float.mini_player_animation_margin_size'),
              right: $r('app.float.mini_player_animation_margin_size')
            })
            .onClick(() => {
              AlertDialog.show({
                message: $r('app.string.mini_player_animation_prompt_info'),
                alignment: DialogAlignment.Center
              });
            })
        }
        .height(Constants.DOWN_ARROW_ROW_HEIGHT)
        .width($r('app.string.mini_player_animation_full_size'))
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: Constants.ROW_MARGIN_BOTTOM })
        .opacity(this.animationInfo.detailsPageTopOpacity)

        // 占位不显示。和全屏播放页歌曲封面图位置相同
        Row()
          .width(Constants.DETAILS_PAGE_IMG_SIZE)
          .height(Constants.DETAILS_PAGE_IMG_SIZE)
          .opacity($r('app.float.mini_player_animation_transparent'))
          .margin({ bottom: $r('app.float.mini_player_animation_margin_bottom') })
        // 自定义播放组件。仅用于UX展示
        this.playComponent()
      }
      .padding({ top: this.statusHeight + 'px' })
      .width($r('app.string.mini_player_animation_full_size'))
      .height($r('app.string.mini_player_animation_full_size'))
    }
    .height($r('app.string.mini_player_animation_one_hundred_four_percent'))
    .opacity(this.animationInfo.detailsPageOpacity)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .position({
      x: Constants.MINI_POSITION_X,
      y: this.animationInfo.screenHeight - this.animationInfo.detailsPageOffsetY - this.animationInfo.miniDistanceToBottom // 全屏播放页Y轴位置=屏幕高度-全屏播放页Y轴偏移距离-Mini条距离屏幕底部的高度
    })
    .id('detailsPage')
    // 上下滑动全屏播放页触发该手势事件
    .gesture(
      PanGesture(this.panOption)
        // TODO 知识点：本例中全屏播放页上下拖动的手势动画和Mini条收起动画实现方式类似。Mini条收起动画是在动画帧回调onframe中通过参数value获取动画进度，而拖动手势动画是在PanGesture拖动手势的onActionUpdate移动回调中，通过滑动偏移量event.offsetY，计算动画进度，然后根据动画进度实时改变自定义动画相关属性AnimationInfo的值来实现全屏播放页上下拖动的手势动画。
        .onActionUpdate((event?: GestureEvent) => {
          /**
           * 性能知识点: onActionUpdate是系统高频回调函数，避免在函数中进行冗余或耗时操作。例如应该减少或避免在函数打印日志，会有较大的性能损耗。
           */
          if (this.animationInfo.isAnimating) {
            // 如果正在Mini条展开收起的一镜到底动画过程中，不触发手势动画
            return;
          }
          if (event) {
            // 向下滑动，offsetY为正，单位vp
            if (event.offsetY >= 0) {
              // 动画进度。向下滑动和Mini条收起动画类似.这里动画进度用1-全屏播放页下滑偏移量offsetY/Mini条距离屏幕顶部的高度miniDistanceToTop计算得到
              const progress: number = 1 - event.offsetY / this.animationInfo.miniDistanceToTop;
              // 全屏播放页下滑偏移量小于等于Mini条距离屏幕顶部的高度，做类似收起动画的滑动效果
              if (event.offsetY <= this.animationInfo.miniDistanceToTop) {
                // Mini条歌曲封面一镜到底动画过程中偏移的距离
                this.animationInfo.miniImgOffsetY = this.animationInfo.miniImgToDetailsPageImgDistance * progress;
                if (progress < Constants.ANIMATION_PROGRESS) {
                  // 为了达到更好的动画效果。动画进度0%-30%时，全屏播放页Y轴偏移距离和Mini条，Mini条歌曲封面保持相同的偏移距离
                  this.animationInfo.detailsPageOffsetY = this.animationInfo.miniImgOffsetY;
                  // Mini条透明度。动画进度0%-30%时，Mini条透明度从1降低到0。动画进度30%-100%时，Mini条透明度为0。
                  this.animationInfo.miniPlayerOpacity = 1 - progress / Constants.ANIMATION_PROGRESS;
                } else {
                  // 由于动画进度0%-30%时改变了原全屏播放页的偏移距离。所以需要在动画进度30%-100%时重新计算全屏播放页Y轴偏移距离，以达到在动画进度100%时全屏播放页能偏移到屏幕顶部位置。
                  this.animationInfo.detailsPageOffsetY = this.animationInfo.miniDistanceToTop * progress -
                    (this.animationInfo.miniDistanceToTop - this.animationInfo.miniImgToDetailsPageImgDistance) *
                    Constants.ANIMATION_PROGRESS * ((1 - Constants.ANIMATION_PROGRESS) - (progress -
                    Constants.ANIMATION_PROGRESS)) / (1 - Constants.ANIMATION_PROGRESS);
                  this.animationInfo.miniPlayerOpacity = 0;
                }
                // Mini条动画过程中高度拉伸大小
                this.animationInfo.miniChangeHeight = this.animationInfo.miniImgOffsetY;
                // Mini条歌曲封面动画过程中尺寸变化量
                this.animationInfo.miniImgOffsetSize = (Constants.DETAILS_PAGE_IMG_SIZE - Constants.MINI_IMG_SIZE) * progress;
                // Mini条歌曲封面动画过程中X轴偏移量。
                this.animationInfo.miniImgOffsetX = ((this.animationInfo.screenWidth - Constants.MINI_IMG_SIZE -
                this.animationInfo.miniImgOffsetSize) / 2 - Constants.MINI_POSITION_X - Constants.MINI_IMG_MARGIN_LEFT) * progress;
                // 动画进度0%-30%时，全屏播放页透明度从0上升到1。
                // 为了达到更好的动画效果。在一开始全屏播放页出现时透明度快速变大。这里在动画进度0%-5%时，全屏播放页透明度从0上升到0.5，在动画进度5%-30%时，全屏播放页透明度从0.5上升到1。
                if (progress <= Constants.PROGRESS_PERCENTAGE_FIVE) {
                  this.animationInfo.detailsPageOpacity = progress * (1 - Constants.DETAILS_PAGE_INTERIM_OPACITY) / Constants.PROGRESS_PERCENTAGE_FIVE;
                } else if (progress < Constants.ANIMATION_PROGRESS) { // 动画进度0.1-0.3，透明度从0.5变1
                  this.animationInfo.detailsPageOpacity = (progress - Constants.PROGRESS_PERCENTAGE_FIVE) * (1 -
                  Constants.DETAILS_PAGE_INTERIM_OPACITY) / (Constants.ANIMATION_PROGRESS - Constants.PROGRESS_PERCENTAGE_FIVE) +
                  Constants.DETAILS_PAGE_INTERIM_OPACITY;
                } else {
                  this.animationInfo.detailsPageOpacity = 1;
                }
                // 动画过程中全屏播放页Y轴位置。全屏播放页Y轴位置=屏幕高度-全屏播放页Y轴偏移距离-Mini条距离屏幕底部的高度（Mini条高度+TabBar高度+底部非安全区域高度（导航栏高度））
                this.animationInfo.detailsPagePositionY = this.animationInfo.screenHeight - this.animationInfo.detailsPageOffsetY - this.animationInfo.miniDistanceToBottom;
                // 动画过程中全屏播放页Y轴位置如果在0-1/2屏幕高度，全屏播放页收起按钮父容器Row的透明度从0上升到1。动画过程中全屏播放页Y轴位置如果大于1/2屏幕高度，则全屏播放页收起按钮父容器Row的透明度为0。
                if (this.animationInfo.detailsPagePositionY <= this.animationInfo.screenHeight / 2) {
                  this.animationInfo.detailsPageTopOpacity = 1 - this.animationInfo.detailsPagePositionY / (this.animationInfo.screenHeight / 2);
                } else {
                  this.animationInfo.detailsPageTopOpacity = 0;
                }
              } else {
                // 全屏播放页下滑偏移量大于Mini条距离屏幕顶部的高度时，不再滑动。更新相关动画参数。
                this.animationInfo.detailsPageOpacity = 0;
                this.animationInfo.miniPlayerOpacity = 1;
              }
            }
            else {
              // 如果全屏播放页已经滑到顶部位置，不再上滑。
              this.animationInfo.detailsPageOffsetY = this.animationInfo.screenHeight - this.animationInfo.miniDistanceToBottom;
            }
          }
        })
        .onActionEnd(() => { // 手指抬起后触发回调
          if (this.animationInfo.isAnimating) {
            // 正在动画过程中，不执行手势回弹动画
            return;
          }
          // TODO 知识点：本例中全屏播放页拖动松手后的回弹动画使用显示动画animateTo，在PanGesture拖动手势的onActionEnd手指抬起回调中，通过前面拖动手势动画中计算的动画过程中全屏播放页Y轴位置detailsPagePositionY。判断抬手时，当全屏播放页Y轴位置小于等于1/2屏幕高度，全屏播放页做向上回弹动画。当全屏播放页Y轴位置大于1/2屏幕高度时，做向下回弹动画。
          animateTo({
            duration: Constants.REBOUND_ANIMATION_DURATION,
            curve: Curve.LinearOutSlowIn,
            onFinish: () => {
              // 向下的回弹动画结束后，重置动画相关标志位。
              if (this.animationInfo.detailsPagePositionY > this.animationInfo.screenHeight / 2) {
                this.animationInfo.isExpand = false;
                this.animationInfo.miniDistanceToBottom = 0;
                this.animationInfo.miniImgOpacity = 1;
                this.animationInfo.miniImgAnimateOpacity = 0;
              }
            }
          }, () => {
            if (this.animationInfo.detailsPagePositionY <= this.animationInfo.screenHeight / 2) {
              // 在上半屏幕手指抬起后,设置向上回弹动画属性
              this.animationInfo.detailsPageOffsetY = this.animationInfo.screenHeight - this.animationInfo.miniDistanceToBottom;
              this.animationInfo.miniImgOffsetY = this.animationInfo.miniImgToDetailsPageImgDistance;
              this.animationInfo.miniImgOffsetSize = Constants.DETAILS_PAGE_IMG_SIZE - Constants.MINI_IMG_SIZE;
              this.animationInfo.miniImgOffsetX = ((this.animationInfo.screenWidth - Constants.MINI_IMG_SIZE - this.animationInfo.miniImgOffsetSize) / 2 - Constants.MINI_POSITION_X - Constants.MINI_IMG_MARGIN_LEFT);
              this.animationInfo.detailsPageTopOpacity = 1;
            } else {
              // 在下半屏幕手指抬起后,设置向下回弹动画属性
              this.animationInfo.detailsPageOffsetY = 0;
              this.animationInfo.miniImgOffsetY = 0;
              this.animationInfo.miniImgOffsetSize = 0;
              this.animationInfo.miniPlayerOpacity = 1;
              this.animationInfo.miniImgOffsetX = 0;
              this.animationInfo.detailsPageOpacity = 0;
              this.animationInfo.miniChangeHeight = 0;
            }
          })
        })
    )
  }
}