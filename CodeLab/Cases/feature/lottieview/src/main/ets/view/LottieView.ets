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

import lottie, { AnimationItem } from '@ohos/lottie';

const FRAME_START: number = 60; // 动画播放的起始帧
const FRAME_END: number = 120; // 动画播放的终止帧
const TEXT_DATA_LENGTH: number = 3; // 可变文本数据的长度

/**
 * 功能描述: Lottie是一个适用于OpenHarmony的动画库，它可以解析Adobe After Effects软件通过Bodymovin插件导出的json格式的动画，
 * 并在移动设备上进行本地渲染， 可以在各种屏幕尺寸和分辨率上呈现，并且支持动画的交互性，通过添加触摸事件或其他用户交互操作，使动画更加生
 * 动和具有响应性
 *
 * 推荐场景: 使用lottie组件的场景
 *
 * 核心组件:
 * 1. lottie
 *
 * 实现步骤:
 * 1. 加载lottie模块，通过Canvas的onReady函数加载动画
 */
@Preview
@Component
export struct LottieView {
  build() {
    Column() {
      // Lottie动画
      LottieAnimation()
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundImage($r("app.media.lottie_view_bg"))
    // 扩展至所有非安全区域
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .backgroundImageSize(ImageSize.Cover)
    .padding($r('app.string.lottie_view_card_padding_start'))
  }
}

@Component
struct LottieAnimation {
  private politeChickyController: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(); // CanvasRenderingContext2D对象
  private politeChicky: string = 'politeChicky'; // 动画名称
  private politeChickyPath: string = 'data/lottie/politeChicky.json'; // hap包内动画资源文件路径，仅支持json格式
  private textArray: Array<string> = ['戳我呀', '幸福鸡', '坏了呀']; // 文本数据，用来点击更新文本
  private animateItem: AnimationItem | undefined = undefined; // 初始化loadAnimation接口的返回对象
  @State times: number = 0; // 初始化点击次数

  // 页面隐藏销毁动画
  aboutToDisappear(): void {
    // TODO:知识点:页面销毁时需要调用lottie的资源回收
    if (this.animateItem !== undefined) {
      this.animateItem.destroy();
    }
  }

  /**
   * 加载动画
   * @param autoplay 控制动画是否自动播放参数
   */
  initAnimation() {
    // TODO:知识点:lottie.loadAnimation将json数据生成动画
    this.animateItem = lottie.loadAnimation({
      container: this.politeChickyController,
      renderer: 'canvas',
      loop: false,
      autoplay: false,
      name: this.politeChicky,
      path: this.politeChickyPath,
      initialSegment: [FRAME_START, FRAME_END]
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 动画
      Canvas(this.politeChickyController)
        .width($r('app.integer.lottie_view_canvas_size'))
        .height($r('app.integer.lottie_view_canvas_size'))
        .backgroundColor($r('app.color.lottie_view_color_palette2'))
        .borderRadius($r('app.string.lottie_view_corner_radius_default_m'))
        .onReady(() => {
          // TODO:知识点:必须要Canvas组件初始化之后才能执行lottie.loadAnimation方法去加载动画。
          this.initAnimation();
        })
        .onClick(() => {
          this.animateItem?.goToAndPlay(0);
          this.times++;
        })
      // 响应动画的文本
      Text(this.textArray[this.times % TEXT_DATA_LENGTH])
        .fontSize($r('app.string.lottie_view_text_size_headline'))
        .margin($r('app.string.lottie_view_elements_margin_vertical_m'))
        .fontColor(Color.White)
    }.margin({ top: $r('app.string.lottie_view_elements_margin_vertical_l') })
  }
}