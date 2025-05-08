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
import { TabsWaterFlowView } from '../view/TabsWaterFlowView';
import { DesignCattleView } from '../view/DesignCattleView';
import { CONFIGURATION } from '../common/Constants';

/**
 * 功能描述: 本示例使用滑动手势监听，实时调整左右两侧内容显示区域大小和效果。通过绑定gesture事件中的PanGesture平移手势，实时获取拖动距离。当拖动时，实时地调节左右两个Image组件的宽度，从而成功实现左右拖动切换图片效果的功能
 *
 * 推荐场景: 调整左右两侧内容显示区域大小和效果
 *
 * 核心组件:
 * 1. onActionUpdate
 *
 * 实现步骤：
 * 1.创建三个Stack组件，用来展示装修前后对比图，第一个和第三个Stack分别存放装修前的图片和装修后的图片，zIndex设置为1。第二个Stack存放按钮的图片，zIndex设置为2，这样按钮的图片就会覆盖在两张装修图片之上。
 * 2.将Image组件放在Row容器里，将Row容器的宽度设置为状态变量，再利用clip属性对于Row容器进行裁剪。
 * 3.右边的Image组件与左边同样的操作，但是新增了一个direction属性，使元素从右至左进行布局，为的是让Row从左侧开始裁剪。
 * 4.中间的Image组件通过手势事件中的滑动手势对Image组件滑动进行监听，对左右Image组件的宽度进行计算从而重新布局渲染。
 */

@Component
export struct DragToSwitchPicturesComponent {
  build() {
    Scroll() {
      Column() {
        // AI设计视图
        DesignCattleView();
        // 瀑布流视图
        TabsWaterFlowView();
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.dragtoswitchpictures_home_page_backgroundcolor'))
    }
    .width($r('app.string.dragtoswitchpictures_full_size'))
    .height($r('app.string.dragtoswitchpictures_full_size'))
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Vertical)
    .zIndex(CONFIGURATION.ZINDEX1)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}