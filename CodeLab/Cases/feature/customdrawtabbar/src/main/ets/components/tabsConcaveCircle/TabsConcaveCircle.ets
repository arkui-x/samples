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

import animator, { AnimatorResult } from '@ohos.animator';
import componentUtils from '@ohos.arkui.componentUtils';
import inspector from '@ohos.arkui.inspector';
import { CanvasClipGroove, CanvasCreateRectangle, getImageUrl } from '../../utils/Functions';
import { TabMenusInterfaceIRequired } from '../../types/TabMenusInterface';
import { ConcaveCircle } from '../../utils/CircleClass';

@Component
export struct TabsConcaveCircle {
  // 当前选中项
  @Link @Watch("getAnimateSelectIndex") selectIndex: number;
  // 用于指控动画的当前选中项
  @State animateSelectIndex: number = 0;
  // Tabs 高度
  @Prop tabHeight: number = 60;
  // 选项数据集合
  @Link tabsMenu: TabMenusInterfaceIRequired[];
  // 背景色
  @Prop tabsBgColor: string = "rgb(255, 255, 255)";
  // 选中球填充色
  @Prop tabsSelectBgColor: Color | number | string | Resource = "rgba(92, 187, 183,1)";
  // 字体颜色
  @Prop tabsFontColor: Color = Color.Black;
  // 选中时字体颜色
  @Prop tabsSelectFontColor: Color = Color.Black;
  // canvas 数据
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  // 凹陷出凸起的悬浮球信息
  @State circleInfo: ConcaveCircle | undefined = undefined;
  // 动画
  private canvasAnimator: AnimatorResult | undefined = undefined;
  // 当前凹槽位置
  @State animationPositionX: number = 0;
  // 图片选中偏移量
  @State imageOffsetY: number = 0;
  // 图片宽高
  @State imageWH: number = 0;
  // 获取第一份
  listener: inspector.ComponentObserver | undefined = undefined;
  @State concaveCircleId: string = `nu_concaveCircle_image_${new Date().getTime()}_`;
  // 动画执行时长
  @State animateTime: number = 1000;

  /**
   * 获取动画控制的下标
   * 用于切换选项时，先让标签回到底部，然后让当前选项在上移
   */
  getAnimateSelectIndex() {
    // 动画等待时间 - 用于等待上一个选项动画结束
    let animateDelay = 500;
    animateTo({
      duration: this.animateTime,
      delay: animateDelay
    }, () => {
      this.animateSelectIndex = this.selectIndex
    })
    // 绘制canvas 用于兼容点击 凸起时，canvas 同时移动
    this.createAnimation()

  }

  /**
   * 创建移动动画
   *  用于移动圆球和重绘canvas中凹陷部分
   */
  createAnimation() {
    if (!this.circleInfo) {
      return;
    }
    // 动画等待时长
    let animateDelay = 0;
    // 动画执行次数
    let animateIterations = 1;
    this.canvasAnimator = animator.create({
      duration: this.animateTime,
      easing: "ease",
      delay: animateDelay,
      fill: "forwards",
      direction: "normal",
      iterations: animateIterations,
      begin: this.animationPositionX,
      end: this.circleInfo?.getMenuCenterX(this.selectIndex)
    })
    this.canvasAnimator.onFrame = (value: number) => {
      this.animationPositionX = value;
      this.circleInfo?.setPositionXY({ x: value - this.circleInfo.circleRadius })
      this.createCanvas()
    }
    this.canvasAnimator.play()
  }

  /**
   * 创建canvas 背景 和 凹槽
   */
  createCanvas() {
    if (this.circleInfo) {
      this.context.reset()
      CanvasCreateRectangle({
        context: this.context,
        tabsBgColor: this.tabsBgColor
      })
      CanvasClipGroove({
        context: this.context,
        menuLength: this.tabsMenu.length,
        center: this.animationPositionX,
      })
    }
  }

  /***
   * 初始化 canvas 数据
   */
  initCanvas() {
    this.circleInfo = new ConcaveCircle(this.context, this.tabsMenu.length);
    // 图片宽度比凹槽小取圆直径的 70%
    let ratio = 0.7;
    this.imageWH = this.circleInfo.circleDiameter * ratio;
    this.createAnimation()
  }

  /**
   * 初始化获取 选中图片偏移量
   */
  getImageOffsetY() {
    let onLayoutComplete: () => void = (): void => {
      let modePosition = componentUtils.getRectangleById(`${this.concaveCircleId}0`)
      if (modePosition.localOffset) {
        // 获取高度的一半
        let halfHeight = px2vp(modePosition.size.height) / 2;
        this.imageOffsetY = px2vp(modePosition.localOffset.y) + halfHeight;
        this.listener?.off('draw')
      }
    }
    let FuncDraw = onLayoutComplete;
    this.listener?.on('draw', FuncDraw)
  }

  aboutToAppear(): void {
    this.listener = inspector.createComponentObserver(`${this.concaveCircleId}0`)
    this.getImageOffsetY()
    this.animateSelectIndex = this.selectIndex;
  }

  @Builder
  TabItem(item: TabMenusInterfaceIRequired, index: number) {
    Column() {
      // 当具有图片时才显示图片
      if (item.image) {
        Image(getImageUrl(item as TabMenusInterfaceIRequired, index, this.selectIndex))
          .size({
            width: this.imageWH,
            height: this.imageWH,
          })
          .interpolation(ImageInterpolation.High)
          .offset({ y: this.selectIndex === index && this.animateSelectIndex === index ? -this.imageOffsetY : 0 })
          .id(`${this.concaveCircleId}${index}`)
      }
      // 菜单文字
      Text(item.text)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width("100%")
        .fontColor(this.selectIndex === index ? (item.tabsFontColor || this.tabsFontColor) :
          (item.tabsSelectFontColor || this.tabsSelectFontColor))
    }
    .onClick(() => {
      animateTo({
        duration: this.animateTime,
      }, () => {
        this.selectIndex = index;
      })
      this.createAnimation()
    })
    .layoutWeight(1)
    .height("100%")
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Stack() {
      // TODO: 背景 - 实现 凹槽 部分
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => this.initCanvas())
      // 凹槽 上方球体部分
      if (this.circleInfo) {
        Column()
          .width(this.circleInfo.circleDiameter)
          .height(this.circleInfo.circleDiameter)
          .borderRadius(this.circleInfo.circleRadius)
          .backgroundColor(this.tabsSelectBgColor)
          .position({
            x: this.circleInfo.positionX,
            y: this.circleInfo.positionY
          })
          .id('ball')
      }
      // 菜单选项
      Row() {
        ForEach(this.tabsMenu, (item: TabMenusInterfaceIRequired, index: number) => {
          this.TabItem(item, index)
        }, (item: TabMenusInterfaceIRequired, index: number) => JSON.stringify(item.text))
      }
      .width("100%")
      .height("100%")
    }
    .width("100%")
    .height(this.tabHeight)
    .id('concavity_tabBar')
  }
}
