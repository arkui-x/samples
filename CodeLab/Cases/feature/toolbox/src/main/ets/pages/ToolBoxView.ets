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

import { FloatingWindow } from '../utils/FloatingWindow';
import { promptAction, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { DynamicsRouter } from 'routermodule';
import { CommonConstants } from '../common/CommonConstants';
import { ToolTouchInterface } from '../model/ToolTouchInterface';
import { LoadingHUD } from './LoadingHUD';
import { CustomTool } from '../model/CustomTool';
import { VisibleAnimation } from './VisiableAnimation';
import { AttributeSet } from '../model/AttributeSet';
import { ImgParams } from './ImgParams';
import { ToolInterface } from '../model/ToolInterface';

/**
 * 功能说明: 本示例介绍使用zIndex、gesture等接口实现悬浮工具箱效果。
 *
 * 推荐场景: 用于悬浮工具箱场景
 *
 * 核心组件:
 * 1. FloatingWindow: 悬浮工具箱组件
 *
 * 实现步骤:
 * 1. 悬浮球UI准备：构建一个悬浮球的UI效果
 * @example
 * @Builder
toolTouch($$: ToolTouchInterface) {
 Button(){
 Button()
 .height(CommonConstants.EIGHTY_PERCENT)
 .width(CommonConstants.EIGHTY_PERCENT)
 .backgroundColor($$.isDisable ? Color.Red : Color.Gray)
 .opacity(0.5)
 }
 .height(CommonConstants.FULL_PERCENT)
 .width(CommonConstants.FULL_PERCENT)
 .backgroundColor($$.isDisable ? 0xFFA28F : 0xD3D3D3)
 .opacity(0.5)
 }
 * 2. 工具项UI准备：构建一个工具项的UI效果
 * @example
 * @Builder
function tool($$: ToolInterface) {
 Image(($$.params as ImgParams).imgRes)
 .height(CommonConstants.TOOL_ITEM_HEIGHT)
 .width(40)
 .objectFit(ImageFit.Fill)
 .visibility(($$.animation as VisibleAnimation).visible)
 .onClick(() => {
 promptAction.showToast({
 message: '点击逻辑自行实现',
 duration: 2000
 })
 })
 }
 * 3. 动效属性设置
 * @State animationAttribute: VisibleAnimation = new VisibleAnimation();
 *
 * 4. 构建每一个工具项
 * this.toolList[0] =
 *    new CustomTool(wrapBuilder(tool), { x: 60, y: CommonConstants.MAXIMUM_DISTANCE / 2 },
 *      { x: CommonConstants.MAXIMUM_DISTANCE / 2, y: CommonConstants.MAXIMUM_DISTANCE * Math.cos(30 / 180 * Math.PI) },
 *    new AttributeSet(this.animationAttribute, new ImgParams($r('app.media.AI_circle_viewfinder'))));
 *
 * 5. 构建悬浮工具箱
 * @example
 * FloatingWindow({
 toolList: this.toolList,
 floatBall: this.toolTouch,
 toolItemHeight: CommonConstants.TOOL_ITEM_HEIGHT,
 maximumDistance: CommonConstants.MAXIMUM_DISTANCE,
 clickListener: {
 onAction: (event: GestureEvent) => {
 animateTo({
 duration: 200
 }, () => {
 this.animationAttribute.visible = this.animationAttribute.visible === Visibility.Visible ? Visibility.Hidden : Visibility.Visible;
 })
 }
 },
 longClickListener: {
 onAction: (event: GestureEvent, isDisable: boolean) => {
 this.animationAttribute.visible = Visibility.Hidden;
 },
 onActionEnd: (event: GestureEvent, isDisable: boolean) => {},
 onActionCancel: (isDisable: boolean) => {}
 }
 })
 */
@Entry
@Component
export struct ToolBoxView {
  @State progress: number = 49;
  @State animationAttribute: VisibleAnimation = new VisibleAnimation();
  @State isLandscape: boolean = false;
  @State toolBoxSize: string = "250px";
  toolList: CustomTool[] = [];

  private arkuiXToolBoxSize(): void {
    if (PlatformInfo.isArkUIX()) {
      let dpi: number | undefined = AppStorage.get('currentScreenDensity');
      if (dpi != undefined) {
        this.toolBoxSize = JSON.stringify((dpi / 460) * 250) + "px"
      }
    }
  }

  aboutToAppear(): void {
    this.toolList[0] =
      new CustomTool(wrapBuilder(tool), { x: 60, y: CommonConstants.MAXIMUM_DISTANCE / 2 },
        { x: CommonConstants.MAXIMUM_DISTANCE / 2, y: CommonConstants.MAXIMUM_DISTANCE * Math.cos(30 / 180 * Math.PI) },
        new AttributeSet(this.animationAttribute, new ImgParams($r('app.media.AI_circle_viewfinder'))));
    this.toolList[1] =
      new CustomTool(wrapBuilder(tool), { x: 0, y: CommonConstants.MAXIMUM_DISTANCE },
        { x: 0, y: CommonConstants.MAXIMUM_DISTANCE },
        new AttributeSet(this.animationAttribute, new ImgParams($r('app.media.AI_form'))));
    this.toolList[2] =
      new CustomTool(wrapBuilder(tool), { x: 60, y: -CommonConstants.MAXIMUM_DISTANCE / 2 },
        { x: CommonConstants.MAXIMUM_DISTANCE * Math.cos(30 / 180 * Math.PI), y: CommonConstants.MAXIMUM_DISTANCE / 2 },
        new AttributeSet(this.animationAttribute, new ImgParams($r('app.media.AI_keyboard'))));
    this.toolList[3] =
      new CustomTool(wrapBuilder(tool), { x: 0, y: -CommonConstants.MAXIMUM_DISTANCE },
        { x: CommonConstants.MAXIMUM_DISTANCE, y: 0 },
        new AttributeSet(this.animationAttribute, new ImgParams($r('app.media.AI_lightbulb_max'))));
    this.arkuiXToolBoxSize();
  }

  build() {
    RelativeContainer() {
      LoadingHUD({
        nowProgress: this.progress
      })
        .alignRules({
          center: { anchor: "__container__", align: VerticalAlign.Center },
          middle: { anchor: "__container__", align: HorizontalAlign.Center }
        })
      /**
       * 构建悬浮工具箱
       *
       * toolList: 工具箱内容
       * floatBall: 悬浮球样式
       * toolItemHeight: 工具项高度
       * maximumDistance: 工具项至悬浮球中心的最远距离
       */
      FloatingWindow({
        toolList: this.toolList,
        floatBall: this.toolTouch,
        toolItemHeight: CommonConstants.TOOL_ITEM_HEIGHT,
        maximumDistance: CommonConstants.MAXIMUM_DISTANCE,
        clickListener: {
          onAction: (event: GestureEvent) => {
            animateTo({
              duration: 200
            }, () => {
              this.animationAttribute.visible =
                this.animationAttribute.visible === Visibility.Visible ? Visibility.Hidden : Visibility.Visible;
            })
          }
        },
        longClickListener: {
          onAction: (event: GestureEvent, isDisable: boolean) => {
            this.animationAttribute.visible = Visibility.Hidden;
          },
          onActionEnd: (event: GestureEvent, isDisable: boolean) => {
          },
          onActionCancel: (isDisable: boolean) => {
          }
        }
      })
        .height(PlatformInfo.isArkUIX() ? this.toolBoxSize : "250px")
        .width(PlatformInfo.isArkUIX() ? this.toolBoxSize : "250px")
    }
    .height('100%')
    .width('100%')
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

  /**
   * 悬浮球样式
   * @param {ToolTouchInterface} $$ - 悬浮球入参
   */
  @Builder
  toolTouch($$: ToolTouchInterface) {
    Button() {
      Button()
        .height(CommonConstants.EIGHTY_PERCENT)
        .width(CommonConstants.EIGHTY_PERCENT)
        .backgroundColor($$.isDisable ? Color.Red : Color.Gray)
        .opacity(0.5)
    }
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor($$.isDisable ? 0xFFA28F : 0xD3D3D3)
    .opacity(0.5)
  }
}

/**
 * 工具项样式
 *
 * @param {ToolInterface} $$ - 工具项入参
 */
@Builder
function tool($$: ToolInterface) {
  Image(($$.params as ImgParams).imgRes)
    .id("1")
    .height(CommonConstants.TOOL_ITEM_HEIGHT)
    .width(40)
    .objectFit(ImageFit.Fill)
    .visibility(($$.animation as VisibleAnimation).visible)
    .onClick(() => {
      promptAction.showToast({
        message: '点击逻辑自行实现',
        duration: 2000
      })
    })
}