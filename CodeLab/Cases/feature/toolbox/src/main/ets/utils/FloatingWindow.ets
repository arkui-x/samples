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

import { componentUtils, display, promptAction, window } from '@kit.ArkUI';
import { ToolTouchInterface } from '../model/ToolTouchInterface';
import { CustomTool } from '../model/CustomTool';
import { LongClickListener } from '../model/LongClickListener';
import { ClickListener } from '../model/ClickListener';
import { ChildTool } from '../model/ChildTool';
import { DragListener } from '../model/DragListener';
import { ToolInterface } from '../model/ToolInterface';
import { Offset } from '../model/Offset';
import { CommonConstants } from '../common/CommonConstants';

const TOOLBOX_SIZE: number = 250; //悬浮工具箱大小

/**
 * 工具栏水平展开方向
 *
 */
enum Direction {
  LEFT,
  RIGHT
}

/**
 * 工具栏垂直对齐方式
 */
enum VerticalAlignment {
  TOP,
  BOTTOM,
  DEFAULT
}

/**
 * 功能描述：
 * 1.点击悬浮球，工具栏动效展开
 * 2.拖拽悬浮球，悬浮球跟随手势滑动
 * 3.长按悬浮球，禁用/启用悬浮球，不再响应/再次响应悬浮球本身的点击事件
 * 4.点击屏幕，切换横竖屏，悬浮球根据位置等效切换
 *
 * 实现原理：
 * 1.构建一个悬浮球页面作为工具栏的入口，并通过gesture接口聚合点击、长按以及拖拽手势，并在内部实现其逻辑
 * 2.构建一个工具栏界面，通过显隐参数来保证本身展开/收回功能
 * 3.通过zIndex将悬浮球以及工具栏放置在基本的页面之上
 *
 * @param {CustomTool[]} [toolList] - 工具栏UI
 * @param {($$: ToolTouchInterface) => void} [floatBall] - 悬浮球UI
 * @param {number | string} [threshold] - 悬浮球吸附至边缘的距离阈值
 * @param {number} [toolItemHeight] - 工具项高度
 * @param {number} [maximumDistance] - 工具项至悬浮球中心的最远距离
 * @param {number} [level] - 悬浮球堆叠优先级
 * @param {ClickListener} [clickListener] - 悬浮球点击事件监听器
 * @param {LongClickListener} [longClickListener] - 悬浮球长按事件监听器
 * @param {DragListener} [dragListener] - 悬浮球拖拽事件监听器
 */
@Component
export struct FloatingWindow {
  // 工具栏UI
  toolList: CustomTool[] = [
    new CustomTool(wrapBuilder(tool), { x: 60, y: CommonConstants.MAXIMUM_DISTANCE / 2 },
      { x: CommonConstants.MAXIMUM_DISTANCE / 2, y: CommonConstants.MAXIMUM_DISTANCE * Math.cos(30 / 180 * Math.PI) }),
    new CustomTool(wrapBuilder(tool), { x: 0, y: CommonConstants.MAXIMUM_DISTANCE },
      { x: 0, y: CommonConstants.MAXIMUM_DISTANCE }),
    new CustomTool(wrapBuilder(tool), { x: 60, y: -CommonConstants.MAXIMUM_DISTANCE / 2 },
      { x: CommonConstants.MAXIMUM_DISTANCE * Math.cos(30 / 180 * Math.PI), y: CommonConstants.MAXIMUM_DISTANCE / 2 }),
    new CustomTool(wrapBuilder(tool), { x: 0, y: -CommonConstants.MAXIMUM_DISTANCE },
      { x: CommonConstants.MAXIMUM_DISTANCE, y: 0 })
  ];
  // 悬浮球UI
  @BuilderParam floatBall: ($$: ToolTouchInterface) => void = this.toolTouch;
  // 单位: vp，仅可传入百分比以及数字
  threshold: number | string = CommonConstants.ADSORPTION_THRESHOLD;
  // 工具项高度
  toolItemHeight: number = CommonConstants.TOOL_ITEM_HEIGHT;
  // 工具项至悬浮球中心的最远距离
  maximumDistance: number = CommonConstants.MAXIMUM_DISTANCE;
  // 悬浮球堆叠优先级
  level: number = Number.MAX_VALUE;
  // 自定义点击逻辑
  clickListener: ClickListener = {
    onAction: (event: GestureEvent) => {
    }
  };
  // 自定义长按逻辑
  longClickListener: LongClickListener = {
    onAction: (event: GestureEvent, isDisable: boolean) => {
    },
    onActionEnd: (event: GestureEvent, isDisable: boolean) => {
    },
    onActionCancel: (isDisable: boolean) => {
    }
  };
  // 自定义拖拽逻辑
  dragListener: DragListener = {
    onActionStart: (event: GestureEvent) => {
    },
    onActionUpdate: (event: GestureEvent) => {
    },
    onActionEnd: (event: GestureEvent) => {
    }
  };
  @State offsetX: number | undefined = undefined;
  @State offsetY: number | undefined = undefined;
  // 工具栏水平展开方向
  @State unfoldDirection: Direction = Direction.LEFT;
  // 工具栏垂直对齐方式
  @State verticalAlignment: VerticalAlignment = VerticalAlignment.TOP;
  @State cW: number = 0;
  @State cH: number = 0;
  @State toolBoxWidth: number = 0;
  // 悬浮窗禁用标志
  @State isDisable: boolean = false;
  private initialH: number = 0;
  private initialW: number = 0;
  private screenH: number = 0;
  private screenW: number = 0;
  private offsetX_: number = 0;
  private offsetY_: number = 0;
  private screenOrientation: number = 0; // 0: 竖屏, 1: 横屏
  // 系统非安全区域
  @State avoidSysHeight: number = 0;
  private avoidNavHeight: number = 0;
  // 悬浮球吸边的阈值距离
  private realThreshold: number = 0;
  private leftMargin: number = 0;
  private topMargin: number = 0;
  private initialX: number = 0;
  private initialY: number = 0;

  // 横竖屏切换通知
  notifyOrientationChange() {
    if (this.offsetX !== undefined && this.offsetY !== undefined) {
      this.screenOrientation = 1 & display.getDefaultDisplaySync().orientation;
      let left: number = this.offsetX;
      let right: number = this.screenW - left - this.cW;
      let top: number = this.offsetY;
      let bottom: number = this.screenH - top - this.cH;
      this.unfoldDirection = left <= right ? Direction.RIGHT : Direction.LEFT;
      let newScreenW = this.screenOrientation === 0 ? this.initialW : this.initialH;
      let newScreenH = this.screenOrientation === 0 ? this.initialH : this.initialW;

      // TODO: 知识点: 通过悬浮球与左右屏之间的大小比例，来判断是使用左边距百分比还是右边距百分比实现等效转换
      this.offsetX = left <= right ?
                     (left / this.screenW * newScreenW) :
                     (newScreenW - (right / this.screenW) * newScreenW - this.cW);
      // TODO: 知识点: 通过悬浮球与上下屏之间的大小比例，来判断是使用上边距百分比还是下边距百分比实现等效转换
      this.offsetY = top <= bottom ?
                     (top / this.screenH * newScreenH) :
                     (newScreenH - (bottom / this.screenH) * newScreenH - this.cH);
      this.screenH = newScreenH;
      this.screenW = newScreenW;

      // 横竖屏切换后更新状态栏和导航条高度
      let mainWindow = window.getLastWindow(this.getUIContext().getHostContext());
      mainWindow.then((mainWindow) => {
        let avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        this.avoidNavHeight = px2vp(avoidArea.bottomRect.height);
        avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        this.avoidSysHeight = px2vp(avoidArea.topRect.height);
      })
    }
  }

  aboutToAppear() {
    let displayClass: display.Display = display.getDefaultDisplaySync();
    this.initialW = this.screenW = px2vp(displayClass.width);
    this.initialH = this.screenH = px2vp(displayClass.height);
    window.getLastWindow(this.getUIContext().getHostContext()).then((mainWindow) => {
      let avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      this.avoidNavHeight = px2vp(avoidArea.bottomRect.height);
      avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.avoidSysHeight = px2vp(avoidArea.topRect.height);
    })
    console.log(`orientation: ${display.getDefaultDisplaySync().orientation}`)
  }

  /**
   * 计算给定工具项在指定方向和垂直对齐方式下的位置偏移量。
   *
   * @param item - 自定义工具项。
   * @param direction - 水平展开方向。
   * @param verticalAlignment - 垂直对齐方式。
   * @returns 返回一个 Offset 对象，表示相对于原位置的偏移量。
   */
  getFloatingWindowOffset(item: CustomTool, direction: Direction, verticalAlignment: VerticalAlignment): Offset {
    let offsetX = 0;
    let offsetY = 0;
    switch (verticalAlignment) {
      case VerticalAlignment.TOP:
        offsetX = item.cornerOffset.x;
        offsetY = item.cornerOffset.y;
        break;
      case VerticalAlignment.BOTTOM:
        // 逆时针旋转90度
        offsetX = item.cornerOffset.y;
        offsetY = -item.cornerOffset.x;
        break;
      default:
        offsetX = item.offset.x;
        offsetY = item.offset.y;
    }
    return direction === Direction.RIGHT ?
           {
             x: offsetX,
             y: offsetY
           } :
           {
             x: -offsetX,
             y: offsetY
           };
  }

  closeToBorder(left: number, right: number, parentLeft: number, parentRight: number, threshold: number): void {
    let distance: number = 0;
    if ((distance = left - parentLeft) < threshold || (distance = right - parentRight) > -threshold) {
      animateTo({
        duration: CommonConstants.ANIMATION_DURATION,
        iterations: 1,
        playMode: PlayMode.Normal
      }, () => {
        this.offsetX! -= distance;
        let regionalConstraintsInfo = componentUtils.getRectangleById('loadingHUD');
        if (this.screenOrientation === 1) {
          if (this.offsetX! > px2vp(regionalConstraintsInfo.size.width - TOOLBOX_SIZE)) {
            this.offsetX! = this.offsetX! - px2vp(TOOLBOX_SIZE) / 2;
          }
        }
      })
    }
  }

  build() {
    RelativeContainer() {
      Stack({ alignContent: Alignment.Center }) {

        ForEach(this.toolList, (item: CustomTool, index: number) => {
          ChildTool({
            builder: item.builder,
            params: item.attributeSet?.params,
            animationAttribute: item.attributeSet?.animation
          })
            .offset(this.getFloatingWindowOffset(item, this.unfoldDirection, this.verticalAlignment))
            .animation({
              duration: 200,
              curve: Curve.EaseOut,
              playMode: PlayMode.Normal
            })
        })

        Column() {
          this.floatBall({ isDisable: this.isDisable });
        }
        .id("button")
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .backgroundColor(Color.Transparent)
        .gesture(
          GestureGroup(GestureMode.Exclusive,
            PanGesture()
              .onActionStart((event: GestureEvent) => {
                this.offsetX_ = 0;
                this.offsetY_ = 0;
              })
              .onActionUpdate((event: GestureEvent) => {
                // 保证悬浮球保持在屏幕内
                let curX = Math.max(this.offsetX! + event.offsetX - this.offsetX_, -this.leftMargin);
                let curY = Math.max(this.offsetY! + event.offsetY - this.offsetY_, this.topMargin);
                curX = Math.min(curX, this.screenW - this.cW - this.leftMargin - this.initialX);
                curY =
                  Math.min(curY, this.screenH - this.cH - this.avoidSysHeight - this.avoidNavHeight - this.initialY);
                this.offsetX_ += curX - this.offsetX!;
                this.offsetY_ += curY - this.offsetY!;
                this.offsetX = curX;
                this.offsetY = curY;
                // 更新工具栏水平展开方向和垂直方向位置，用于动态调整工具项偏移量
                let left: number = this.offsetX!;
                let leftMargin: number = left;
                let rightMargin: number = this.screenW - leftMargin - this.cW;
                this.unfoldDirection = leftMargin <= rightMargin ? Direction.RIGHT : Direction.LEFT;
                // 当悬浮球工具项超过上下边界时重排工具项
                if (this.offsetX !== undefined && this.offsetY !== undefined) {
                  if (this.offsetY + this.cH / 2 - this.toolItemHeight / 2 - this.maximumDistance <= this.topMargin) {
                    this.verticalAlignment = VerticalAlignment.TOP;
                  } else if (this.offsetY - this.cH / 2 + this.toolItemHeight / 2 + this.maximumDistance >=
                    this.screenH - this.cH - this.avoidSysHeight - this.avoidNavHeight - this.initialY) {
                    this.verticalAlignment = VerticalAlignment.BOTTOM;
                  } else {
                    this.verticalAlignment = VerticalAlignment.DEFAULT;
                  }
                }
              })
              .onActionEnd((event: GestureEvent) => {
                let left: number = this.offsetX!;
                // 吸附效果实现
                this.closeToBorder(left, left + this.cW, 0, this.screenW, this.realThreshold);
              }),
            LongPressGesture()
              .onAction((event: GestureEvent) => {
                console.log(`LongPressGesture Start`)
                // TODO: 工具箱禁用逻辑
                this.isDisable = !this.isDisable;
                this.longClickListener.onAction(event, this.isDisable);
              })
              .onActionEnd((event: GestureEvent) => {
                console.log(`LongPressGesture End`);
                this.longClickListener.onActionEnd(event, this.isDisable);
              })
              .onActionCancel(() => {
                console.log(`LongPressGesture Cancel`)
                this.longClickListener.onActionCancel(this.isDisable);
              }),
            TapGesture()
              .onAction((event: GestureEvent) => {
                console.log(`TapGesture`)
                this.clickListener.onAction(event);
              })
          ))
        // TODO: 知识点: 通过拒绝点击手势保证点击手势顺利向上传递
        .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
          if (gestureInfo.type === GestureControl.GestureType.TAP_GESTURE) {
            return this.isDisable ? GestureJudgeResult.REJECT : GestureJudgeResult.CONTINUE;
          }
          return GestureJudgeResult.CONTINUE;
        })
      }
    }
    .offset({
      x: this.offsetX + "vp",
      y: this.offsetY + "vp"
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.cW = Number.parseFloat(newValue.width.toString());
      this.cH = Number.parseFloat(newValue.height.toString());
      let left: number = 0;
      let right: number = 0;
      if (this.offsetX === undefined || this.offsetY === undefined) {
        this.offsetX = this.initialX =
          newValue.position.x === undefined ? 0 : Number.parseFloat(newValue.position.x.toString());
        this.offsetY = this.initialY =
          newValue.position.y === undefined ? 0 : Number.parseFloat(newValue.position.y.toString());
        left = this.offsetX;
        right = this.screenW - left - this.cW;
      }
      this.unfoldDirection = left <= right ? Direction.RIGHT : Direction.LEFT;

      this.notifyOrientationChange();
      // TODO: 百分比转换
      let threshold = this.threshold.toString();
      if (threshold.includes("%")) {
        this.realThreshold = Number.parseFloat(threshold.replace("%", "")) / 100 * this.screenW;
        return;
      }
      this.realThreshold = Number.parseFloat(threshold);
    })
    .zIndex(this.level)
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }

  @Builder
  toolTouch() {
    Button() {
      Button()
        .height(CommonConstants.EIGHTY_PERCENT)
        .width(CommonConstants.EIGHTY_PERCENT)
        .backgroundColor(!this.isDisable ? Color.Gray : Color.Red)
        .opacity(0.5)
    }
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor(!this.isDisable ? 0xD3D3D3 : 0xFFA28F)
    .opacity(0.5)
  }
}

/**
 * 工具项UI
 * @param {ToolInterface} $$ - 输入参数
 */
@Builder
function tool($$: ToolInterface) {
  Image($r("app.media.AI_circle_viewfinder"))
    .height(CommonConstants.TOOL_ITEM_HEIGHT)
    .width(40)
    .objectFit(ImageFit.Fill)
    .onClick(() => {
      promptAction.showToast({
        message: '点击逻辑自行实现',
        duration: 2000
      })
    })
}