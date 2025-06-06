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
import lottie from '@ohos/lottie';

/**
 * HUD全称Heads-Up Display（抬头显示）
 */

@Component
export struct LoadingHUD {
  @Link nowProgress: number;
  private politeChickyController: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  private politeChicky: string = 'pageLoading'; // 动画名称
  private politeChickyPath: string = 'data/lottie/pageLoading.json'; // hap包内动画资源文件路径，仅支持json格式
  private gradientColor: LinearGradient = new LinearGradient([{ color: Color.Yellow, offset: 0.5 },
    { color: Color.Orange, offset: 1.0 }])

  /**
   * 加载动画
   * @param autoplay 控制动画是否自动播放参数
   */
  initAnimation() {
    // TODO:知识点:lottie.loadAnimation将json数据生成动画
    lottie.loadAnimation({
      container: this.politeChickyController,
      renderer: 'canvas',
      loop: true,
      autoplay: true,
      name: this.politeChicky,
      path: this.politeChickyPath,
    })
  }

  build() {
    Column() {
      Stack() {
        Canvas(this.politeChickyController)
          .width(150)
          .height(150)
          .borderRadius(12)
          .onReady(() => {
            // TODO:知识点:必须要Canvas组件初始化之后才能执行lottie.loadAnimation方法去加载动画。
            this.initAnimation();
          })
        Row() {
          Progress({ value: this.nowProgress, total: 100, type: ProgressType.Linear })
            .style({ strokeWidth: 10, enableSmoothEffect: true })
            .color(this.gradientColor)
        }
        .width('60%')
        .margin({ top: 140 })
        .height(10)
      }.height(150)

      Text(`当前已加载${this.nowProgress}%`)
        .fontSize(16)
        .fontColor(Color.Black)
    }
    .id('loadingHUD')
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
  }
}