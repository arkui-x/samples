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

import { window } from "@kit.ArkUI";
import { common } from "@kit.AbilityKit";
import { logger } from '../utils/Logger';
import WindowModel from './WindowModel';
import { CommonConstants } from '../constants/CommonConstants';
import { BottomDrawerHeight } from "../model/DataType";
import { PlatformInfo } from 'utils'

/**
 * 功能描述：
 * 1.本示例主要介绍了利用List实现底部抽屉滑动效果场景，并将界面沉浸式（全屏）显示，及背景地图可拖动。
 *
 * 实现原理：
 *
 * 1.通过listHeight记录底部列表高度变化
 * 2.通过onTouch属性实现根据手指滑动距离，底部列表高度进行变化
 * 3.手指移开屏幕后，通过判断列表高度实现抽屉式滑动效果
 *
 * @param {()=>void} searchAddress - 搜索视图
 * @param {()=>void} listBuilder - 列表视图
 * @param {boolean} isShow - 顶部遮蔽导航栏区域是否显示
 * @param {BottomDrawerHeight} bottomDrawerHeight - 列表阶段高度属性
 */

@Component
export struct BottomDrawer {
  // -------------------对外暴露变量-----------------------
  @BuilderParam searchAddress: () => void; // 搜索视图组件
  @BuilderParam listBuilder: () => void; // 列表视图组件
  @Link isShow: boolean; // 顶部遮蔽导航栏区域是否显示
  bottomDrawerHeight: BottomDrawerHeight = new BottomDrawerHeight(); // 列表阶段高度属性
  // --------------------私有属性-------------------------
  @State isUp: boolean = true; // list是否向上滑动
  @State bottomAvoidHeight: number = 0; //底部导航条高度
  @State isScroll: boolean = false; // list是否可以滚动
  @State listHeight: number = this.bottomDrawerHeight.middleHeight; // list高度
  private windowModel: WindowModel = WindowModel.getInstance(); // 窗口管理model
  private itemNumber: number = 0; // 列表项下标
  private yStart: number = 0; // list触摸事件起始纵坐标
  listScroller = new ListScroller(); // list滚动控制器

  build() {
    List({ scroller: this.listScroller, space: 16 }) {
      ListItem() {
        this.searchAddress()
      }
      .borderRadius({
        topLeft: $r('app.integer.bottom_drawer_slide_border_radius_top_left_15'),
        topRight: $r('app.integer.bottom_drawer_slide_border_radius_top_right_15')
      })
      .width(CommonConstants.FULL_SIZE)
      .backgroundColor(Color.White)

      /* 性能知识点：此处列表，列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
      *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-rendering-control-lazyforeach-V5
      */
      this.listBuilder()
    }
    .borderRadius($r("app.integer.bottomdrawerslidecase_number_10"))
    .scrollBar(BarState.Off) // 滚动条不显示
    .width(CommonConstants.FULL_SIZE)
    .height(this.listHeight)
    .onReachStart(() => {
      this.itemNumber = 0;
    })
    .onScrollIndex((start: number) => {
      this.itemNumber = start;
    })
    .backgroundColor(Color.White)
    .margin({
      left: $r("app.integer.bottomdrawerslidecase_height_10"),
      right: $r("app.integer.bottomdrawerslidecase_height_10")
    })
    .sticky(StickyStyle.None) // 列表吸顶效果
    // TODO:知识点:设置是否支持滚动手势，当设置为false时，无法通过手指或者鼠标滚动，但不影响控制器的滚动接口
    .enableScrollInteraction(this.isScroll)
    .animation({
      duration: 500, // 动画持续时间，单位毫秒
      curve: Curve.Friction, // 动画曲线
      iterations: 1, // 动画播放次数
      playMode: PlayMode.Normal// 动画播放模式
    })
    .onReachStart(() => {
      this.isScroll = false;
    })
    .edgeEffect(EdgeEffect.Spring)
    .id('scrollPart')
    .alignRules({
      'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
      'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start },
      'right': { 'anchor': '__container__', 'align': HorizontalAlign.End },
    })
    .gesture(
      // 以下组合手势为顺序识别，当长按手势事件未正常触发时则不会触发拖动手势事件
      GestureGroup(GestureMode.Sequence,
        PanGesture()
          .onActionStart((event: GestureEvent) => {
            this.yStart = event.offsetY;
          })
          .onActionUpdate((event: GestureEvent) => {
            const yEnd = event.offsetY; // 手指离开屏幕的纵坐标
            const height = Math.abs(Math.abs(yEnd) - Math.abs(this.yStart)); // 手指在屏幕上的滑动距离
            if (yEnd < this.yStart) {
              this.isUp = true;
              const temHeight = this.listHeight + height;
              if (temHeight >= this.bottomDrawerHeight.maxHeight) {
                this.isScroll = true;
                this.isShow = true;
                this.listHeight = this.bottomDrawerHeight.maxHeight;
              } else {
                this.isScroll = false;
                this.listHeight = temHeight;
              }
            }
            // 判断下滑，且list跟随手势滑动
            else {
              this.isUp = false;
              const temHeight = this.listHeight - height;
              if (this.itemNumber === 0) {
                // 列表高度随滑动高度变化
                this.listHeight = temHeight;
              } else {
                this.listHeight = this.bottomDrawerHeight.maxHeight;
              }
            }
            this.yStart = event?.offsetY;
          })
          .onActionEnd(() => {
            if (this.isUp) {
              // 分阶段滑动，当list高度位于第一个item和第二个item之间时，滑动到第二个item
              if (this.listHeight > this.bottomDrawerHeight.minHeight &&
                this.listHeight <= this.bottomDrawerHeight.middleHeight + this.bottomAvoidHeight) {
                this.listHeight = this.bottomDrawerHeight.middleHeight;
                this.isScroll = false;
                this.isShow = false;
                return;
              }
              // 分阶段滑动，当list高度位于顶部和第二个item之间时，滑动到页面顶部
              else if (this.bottomDrawerHeight.middleHeight + this.bottomAvoidHeight < this.listHeight &&
                this.listHeight <= this.bottomDrawerHeight.maxHeight) {
                this.listHeight = this.bottomDrawerHeight.maxHeight;
                this.isShow = true;
                return;
              }
            }
            // 列表下滑时，分阶段滑动
            else {
              if (this.listHeight === this.bottomDrawerHeight.maxHeight) {
                this.isShow = true;
                this.isScroll = true;
                this.listHeight = this.bottomDrawerHeight.maxHeight;
              }
              // 分阶段滑动，当list高度位于顶部和第二个item之间时,滑动到第二个item
              else if (this.listHeight >=
              this.bottomDrawerHeight.middleHeight &&
                this.listHeight <= this.bottomDrawerHeight.maxHeight) {
                this.listHeight =
                  this.bottomDrawerHeight.middleHeight;
                this.isShow = false;
                this.isScroll = false;
                return;
              }
              // 分阶段滑动，当list高度位于第一个item和第二个item之间时，滑动到第一个item
              else if (this.listHeight <=
                this.bottomDrawerHeight.middleHeight + this.bottomAvoidHeight ||
                this.listHeight <= this.bottomDrawerHeight.minHeight) {
                this.listHeight = this.bottomDrawerHeight.minHeight;
                this.isShow = false;
                this.isScroll = false;
                return;
              }
            }
          })
      )
    )

  }

  aboutToAppear(): void {
    // 初始化窗口管理model
    let context = getContext() as common.UIAbilityContext;
    const windowStage: window.WindowStage | undefined =
      PlatformInfo.isArkUIX() ? AppStorage.get('windowStage') : context.windowStage;
    // 没有windowStage将无法执行下列逻辑
    if (!windowStage) {
      logger.warn('windowStage init error!');
      return;
    }
    this.windowModel.setWindowStage(windowStage);

    // 设置沉浸模式
    this.windowModel.setMainWindowImmersive(true);

    // 获取底部导航条高度
    this.windowModel.getBottomAvoidHeight((bottomAvoidHeight) => {
      this.bottomAvoidHeight = px2vp(bottomAvoidHeight) / 2;
    })
  }
}