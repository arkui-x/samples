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

import { HomePage } from '../model/HomePage'; // 首页
import { DetailsPage } from '../model/DetailsPage'; // 全屏播放页
import { AnimationInfo } from '../model/AnimationInfo'; // 动画相关参数类
import Constants from '../model/Constants'; // 常量类
import display from '@ohos.display'; // 屏幕属性模块。本例用于获取屏幕宽高信息。
import window from '@ohos.window'; // 窗口模块。本例用于获取屏幕中顶部和底部非安全区域高度。
import common from '@ohos.app.ability.common';
import animator, { AnimatorResult } from '@ohos.animator'; // 动画模块
import { emitter } from '@kit.BasicServicesKit';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

/**
 * 实现步骤
 * 本例中一镜到底动画分两块：1.Mini条展开和收起的一镜到底动画 2.全屏播放页上下拖动的手势动画和松手后的回弹动画
 * 1.Mini条展开和收起的一镜到底动画。本例中展开和收起动画(expandCollapseAnimation())大部分动画相同，且共用同一个动画对象animatorObject，
 * 主要有三部分动画组成。以Mini条展开动画为例，分为：
 * （1）Mini条歌曲封面缩放和X，Y轴偏移动画
 * （2）Mini条向上平移，高度拉伸，同时透明度降低动画
 * （3）全屏播放页向上平移，同时透明度增加动画
 * 本例中使用@ohos.animator动画模块的AnimatorResult定义动画对象，通过创建AnimatorOptions动画选项，并传入create来创建Animator对象
 * animatorObject。通过play()启动动画，在动画帧回调onframe中通过参数value获取动画进度，然后根据动画进度实时改
 * 变自定义动画相关属性AnimationInfo的值来实现Mini条展开和收起的一镜到底动画。
 * 2.全屏播放页上下拖动的手势动画和松手后的回弹动画。
 * （1）本例中全屏播放页上下拖动的手势动画和Mini条收起动画实现方式类似。Mini条收起动画是在动画帧回调onframe中通过参数value获取动画进度，而拖动
 * 手势动画是在PanGesture拖动手势的onActionUpdate移动回调中，通过滑动偏移量event.offsetY，计算动画进度，然后根据动画进度实时改变自定义动画
 * 相关属性AnimationInfo的值来实现全屏播放页上下拖动的手势动画。
 * （2）本例中全屏播放页拖动松手后的回弹动画使用显示动画animateTo，在PanGesture拖动手势的onActionEnd手指抬起回调中，通过前面拖动手势动画中计
 * 算的动画过程中全屏播放页Y轴位置detailsPagePositionY。判断抬手时，当全屏播放页Y轴位置小于等于1/2屏幕高度，全屏播放页做向上回弹动画。当全屏
 * 播放页Y轴位置大于1/2屏幕高度时，做向下回弹动画。
 */

const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

@AppRouter({ name: "miniplayeranimation/MiniPlayerAnimation" })
@Component
export struct MiniPlayerAnimation {
  // 动画相关参数类
  @Provide @Watch('animationInfoChange') animationData: AnimationInfo = new AnimationInfo();
  // 动画对象
  @State animatorObject: AnimatorResult | undefined = undefined;
  // 依据cases工程Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  private readonly DEVICESIZE: number = 600;
  // 检查设备是否可折叠
  private isFoldable: boolean = false;
  // 折叠设备屏幕显示模式回调
  private callback: Callback<display.FoldDisplayMode> = (mode: display.FoldDisplayMode) => {
    // 可折叠设备的显示模式改变时(如展开或者折叠)，重新获取屏幕宽度
    this.animationData.screenWidth = this.getCurrentScreenWidth();
  };

  /**
   * 动画信息变化，用于自动化用例
   */
  animationInfoChange() {
    // 全屏播放页Y轴位置
    let detailsPageYPosition = this.animationData?.screenHeight - this.animationData?.detailsPageOffsetY -
      this.animationData?.miniDistanceToBottom;
    // Mini条透明度
    let miniPlayerOpacity = this.animationData?.miniPlayerOpacity;
    // 全屏播放页透明度
    let detailsPageOpacity = this.animationData?.detailsPageOpacity;
    // 歌曲封面图偏移量
    let miniImgOffsetSize = this.animationData?.miniImgOffsetSize;
    // 歌曲封面图X轴偏移距离
    let miniImgOffsetX = this.animationData?.miniImgOffsetX;
    // 设备屏幕宽度
    let screenWidth = this.animationData?.screenWidth;
    // 设备屏幕高度
    let screenHeight = this.animationData?.screenHeight;
    // 全屏播放页左上角收起按钮和右上角分享按钮图标透明度
    let detailsPageTopOpacity = this.animationData?.detailsPageTopOpacity;
    emitter.emit({ eventId: 0, priority: 0 }, {
      data: {
        detailsPageYPosition: detailsPageYPosition,
        miniPlayerOpacity: miniPlayerOpacity,
        detailsPageOpacity: detailsPageOpacity,
        miniImgOffsetSize: miniImgOffsetSize,
        miniImgOffsetX: miniImgOffsetX,
        screenWidth: screenWidth,
        screenHeight: screenHeight,
        detailsPageTopOpacity: detailsPageTopOpacity
      }
    });
  }

  /**
   * 获取当前屏幕宽度
   */
  getCurrentScreenWidth(): number {
    let screenW: number = px2vp(display.getDefaultDisplaySync().width);
    // 适配cases中Navigation在不同mode时，计算相对需要使用的屏幕宽度。当屏幕宽度大于600vp时，cases工程Navigation的mode采用Split模式显示，需要重新计算实际页面所需的屏幕宽度。
    if (screenW >= this.DEVICESIZE) {
      return screenW / 2;
    } else {
      return screenW;
    }
  }

  /**
   * 获取屏幕宽高，顶部和底部非安全区域高度
   */
  async aboutToAppear() {
    // 检查设备是否可折叠。false表示不可折叠，true表示可折叠。
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      this.isFoldable = display.isFoldable();
      if (this.isFoldable) {
        // 如果是可折叠设备，注册折叠设备屏幕显示模式变化监听
        display.on('foldDisplayModeChange', this.callback);
      }
    }
    // 获取屏幕宽高
    this.animationData.screenHeight = px2vp(display.getDefaultDisplaySync().height);
    this.animationData.screenWidth = this.getCurrentScreenWidth();
    const windowClass: window.Window = await window.getLastWindow(context);
    windowClass.setWindowSystemBarEnable(["status"]);
    // 获取顶部非安全区域高度（状态栏高度）
    const TOP_UNSAFE_HEIGHT: number =
      px2vp(windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height);
    // 获取底部非安全区域高度（导航栏高度）
    const BOTTOM_UNSAFE_HEIGHT: number =
      px2vp(windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height);
    this.animationData.topUnsafeHeight = TOP_UNSAFE_HEIGHT;
    // 计算全屏播放页歌曲封面Y轴位置。全屏播放页歌曲封面Y轴位置=顶部非安全区域高度（状态栏高度）+全屏播放页左上角收起按钮父容器Row高度+全屏播放页左上角收起按钮父容器Row的底部外边距
    this.animationData.detailsPageImgPositionY =
      this.animationData.topUnsafeHeight + Constants.DOWN_ARROW_ROW_HEIGHT + Constants.ROW_MARGIN_BOTTOM;
    this.animationData.bottomUnsafeHeight = BOTTOM_UNSAFE_HEIGHT;
    // 创建动画
    this.createAnimation();
    //定义事件ID
    let innerEvent: emitter.InnerEvent = { eventId: 1 }
    emitter.on(innerEvent, data => {
      if (data?.data?.backPressed) {
        if (this.animatorObject) {
          // 启动动画。这里为收起动画
          if (this.animationData.isExpand) {
            this.animatorObject.play();
            this.animationData.isAnimating = true;
          } else {
            DynamicsRouter.popAppRouter();
          }
        }
      }
    })
  }

  aboutToDisappear() {
    // TODO 知识点：由于animatorObject在onframe中引用了this, this中保存了animatorObject，在自定义组件消失时应该将保存在组件中的animatorObject置空，避免内存泄漏。
    this.animatorObject = undefined;
    if (this.isFoldable) {
      // 关闭显示设备变化的监听
      display.off('foldDisplayModeChange', this.callback);
    }
  }

  /**
   * 展开收起动画公共部分
   */
  expandCollapseAnimation(progress: number) {
    // Mini条歌曲封面动画过程中尺寸变化量
    this.animationData.miniImgOffsetSize = (Constants.DETAILS_PAGE_IMG_SIZE - Constants.MINI_IMG_SIZE) * progress;
    // Mini条歌曲封面动画过程中X轴偏移量。Mini条歌曲封面X轴偏移=（（屏幕宽度-Mini条歌曲封面尺寸-Mini条歌曲封面动画过程中尺寸变化量）/2-Mini条X轴位置-Mini条歌曲封面距离左侧的外边距）*动画进度
    this.animationData.miniImgOffsetX = ((this.animationData.screenWidth - Constants.MINI_IMG_SIZE -
    this.animationData.miniImgOffsetSize) / 2 - Constants.MINI_POSITION_X - Constants.MINI_IMG_MARGIN_LEFT) * progress;
    if (progress <= Constants.ANIMATION_PROGRESS) {
      // 为了达到更好的动画效果。动画进度0%-30%时，全屏播放页Y轴偏移距离和Mini条，Mini条歌曲封面保持相同的偏移距离
      this.animationData.detailsPageOffsetY = this.animationData.miniImgOffsetY;
      // Mini条透明度。动画进度0%-30%时，Mini条透明度从1降低到0。
      this.animationData.miniPlayerOpacity = 1 - progress / Constants.ANIMATION_PROGRESS;
    } else {
      // 由于动画进度0%-30%时改变了原全屏播放页的偏移距离。所以需要在动画进度30%-100%时重新计算全屏播放页Y轴偏移距离，以达到在动画进度100%时全屏播放页能偏移到屏幕顶部位置。
      this.animationData.detailsPageOffsetY = this.animationData.miniDistanceToTop * progress -
        (this.animationData.miniDistanceToTop - this.animationData.miniImgToDetailsPageImgDistance) *
        Constants.ANIMATION_PROGRESS *
          ((1 - Constants.ANIMATION_PROGRESS) - (progress - Constants.ANIMATION_PROGRESS)) /
          (1 - Constants.ANIMATION_PROGRESS);
      // 动画进度30%-100%时，Mini条透明度为0。
      this.animationData.miniPlayerOpacity = 0;
    }
    // Mini条动画过程中高度拉伸大小
    this.animationData.miniChangeHeight = this.animationData.miniImgOffsetY;
    /**
     * 动画进度0%-30%时，全屏播放页透明度从0上升到1。和前面Mini条透明度变化相反。
     * 为了达到更好的动画效果。在一开始全屏播放页出现时透明度快速变大。这里在动画进度0%-5%时，全屏播放页透明度从0上升到0.5，在动画进度5%-30%时
     * ，全屏播放页透明度从0.5上升到1.
     */
    if (progress <= Constants.PROGRESS_PERCENTAGE_FIVE) {
      this.animationData.detailsPageOpacity =
        progress * (1 - Constants.DETAILS_PAGE_INTERIM_OPACITY) / Constants.PROGRESS_PERCENTAGE_FIVE;
    } else if (progress < Constants.ANIMATION_PROGRESS) {
      this.animationData.detailsPageOpacity = (progress - Constants.PROGRESS_PERCENTAGE_FIVE) *
        (1 - Constants.DETAILS_PAGE_INTERIM_OPACITY) /
        (Constants.ANIMATION_PROGRESS - Constants.PROGRESS_PERCENTAGE_FIVE) +
      Constants.DETAILS_PAGE_INTERIM_OPACITY;
    } else {
      // 动画进度30%-100%时，全屏播放页透明度为1。
      this.animationData.detailsPageOpacity = 1;
    }
    // 动画过程中全屏播放页Y轴位置。全屏播放页Y轴位置=屏幕高度-全屏播放页Y轴偏移距离-Mini条距离屏幕底部的高度（Mini条高度+TabBar高度+底部非安全区域高度（导航栏高度））
    this.animationData.detailsPagePositionY =
      this.animationData.screenHeight - this.animationData.detailsPageOffsetY - this.animationData.miniDistanceToBottom;
    // 动画过程中全屏播放页Y轴位置如果在0-1/2屏幕高度，全屏播放页收起按钮父容器Row的透明度从0上升到1。动画过程中全屏播放页Y轴位置如果大于1/2屏幕高度，则全屏播放页收起按钮父容器Row的透明度为0。
    if (this.animationData.detailsPagePositionY <= this.animationData.screenHeight / 2) {
      this.animationData.detailsPageTopOpacity =
        1 - this.animationData.detailsPagePositionY / (this.animationData.screenHeight / 2);
    } else {
      this.animationData.detailsPageTopOpacity = 0;
    }
  }

  /**
   * 创建动画
   */
  createAnimation() {
    // 计算Mini条距离屏幕顶部的高度（包含顶部非安全区域高度）。Mini条距离屏幕顶部的高度=屏幕高度-Mini条高度-TabBar高度-底部非安全区域高度（导航栏高度）
    this.animationData.miniDistanceToTop = this.animationData.screenHeight - Constants.MINI_HEIGHT -
    Constants.BAR_HEIGHT - this.animationData.bottomUnsafeHeight;
    // 计算Mini条歌曲封面Y轴位置。Mini条距离屏幕顶部的高度（包含顶部状态栏高度）+Mini条歌曲封面距离Mini条顶部距离
    this.animationData.miniImgPositionY = this.animationData.miniDistanceToTop + Constants.MINI_SPACE;
    // 计算Mini条歌曲封面Y轴位置到全屏播放页歌曲封面Y轴位置的距离
    this.animationData.miniImgToDetailsPageImgDistance =
      this.animationData.miniImgPositionY - this.animationData.detailsPageImgPositionY;
    // TODO 知识点：本例中使用@ohos.animator动画模块的AnimatorResult定义动画对象，通过创建AnimatorOptions动画选项，并传入create来创建Animator对象animatorObject。在动画帧回调onframe中通过参数value获取动画进度，然后根据动画进度实时改变自定义动画相关属性AnimationInfo的值来实现Mini条展开和收起的一镜到底动画。
    // 设置动画选项，定义Animator类
    this.animatorObject = animator.create({
      duration: Constants.MINI_ANIMATION_DURATION, // 动画时长
      /**
       * easing动画插值曲线。这里使用三次贝塞尔曲线,通过设置cubicBezierCurve的4个参数控制曲线动画速度，(0.22,0.17,0.07,1)效果为先慢后快
       * 最后再缓慢减速的曲线动画。具体请参考https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-curve-0
       * 000001774121126#ZH-CN_TOPIC_0000001857917121__curvescubicbeziercurve9。
       */
      easing: "cubic-bezier(0.22, 0.17, 0.07, 1)",
      delay: 0, // 动画延时播放时长。0表示不延时。
      fill: "forwards", // forwards表示在动画结束后，目标将保留动画结束时的状态（在最后一个关键帧中定义）。
      direction: "normal", // 动画播放模式。normal表示设置动画正向循环播放。
      iterations: 1, // 动画播放次数
      begin: 0, // 动画插值起点
      /**
       * end动画插值终点。这里设置Mini条歌曲封面Y轴位置到全屏播放页歌曲封面Y轴位置的距离作为动画插值终点。
       */
      end: this.animationData.miniImgToDetailsPageImgDistance
    });
    // onfinish动画完成时回调
    this.animatorObject.onFinish = () => {
      // 重置正在动画标志位
      this.animationData.isAnimating = false;
      if (!this.animationData.isExpand) {
        // 重置Mini条是否展开标志位
        this.animationData.isExpand = true;
      } else {
        this.animationData.isExpand = false;
        // 重置Mini条距离屏幕底部的高度
        this.animationData.miniDistanceToBottom = 0;
        // 重置Mini条实际歌曲封面的透明度
        this.animationData.miniImgOpacity = 1;
        // 重置用于动画的Mini条歌曲封面的透明度
        this.animationData.miniImgAnimateOpacity = 0;
      }
    }
    // onframe接收到动画帧时回调，value返回当前的动画进度。value的取值范围就是前面animatorOption中设定的动画插值起点begin到动画插值终点end。
    this.animatorObject.onFrame = (value: number) => {
      // 展开动画
      if (!this.animationData.isExpand) {
        // 计算当前动画进度占比。
        const progress: number = value / this.animationData.miniImgToDetailsPageImgDistance;
        // Mini条歌曲封面一镜到底动画过程中偏移的距离
        this.animationData.miniImgOffsetY = value;
        // 展开收起动画公共部分
        this.expandCollapseAnimation(progress);
      } else { // 收起动画
        // 展开动画过程和收起动画过程相反，所以这里用1-当前动画进度占比
        const progress: number = 1 - value / this.animationData.miniImgToDetailsPageImgDistance;
        // Mini条歌曲封面一镜到底动画过程中偏移的距离
        this.animationData.miniImgOffsetY = this.animationData.miniImgToDetailsPageImgDistance - value;
        // 展开收起动画公共部分
        this.expandCollapseAnimation(progress);
      }
    }
  }

  build() {
    Stack() {
      // 首页
      HomePage({ animatorObject: this.animatorObject, animationInfo: this.animationData })

      // 全屏播放页
      DetailsPage({ animatorObject: this.animatorObject, animationInfo: this.animationData })

      // Mini条歌曲封面
      Image($r('app.media.miniplayeranimation_music_cover'))
        .borderRadius(Constants.MINI_IMG_RADIUS)
        .margin({ left: Constants.MINI_IMG_MARGIN_LEFT })
        .size({
          width: Constants.MINI_IMG_SIZE + this.animationData.miniImgOffsetSize,
          height: Constants.MINI_IMG_SIZE + this.animationData.miniImgOffsetSize
        })
        .position({
          x: Constants.MINI_POSITION_X + this.animationData.miniImgOffsetX,
          y: this.animationData.miniImgPositionY - this.animationData.miniImgOffsetY
        })
        .opacity(this.animationData.miniImgAnimateOpacity)
        .responseRegion({
          // 设置无点击热区。避免点击图片，没法触发底部的mini条点击事件
          width: $r('app.string.mini_player_animation_response_region'),
          height: $r('app.string.mini_player_animation_response_region')
        })
    }
    .size({
      width: $r('app.string.mini_player_animation_full_size'),
      height: $r('app.string.mini_player_animation_full_size')
    })
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}