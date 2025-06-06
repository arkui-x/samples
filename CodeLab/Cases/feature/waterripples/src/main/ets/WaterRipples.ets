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


/**
 * 功能描述: 本示例主要介绍在很多应用中，会出现点击按钮出现水波纹的特效。
 *
 * 推荐场景: 水波纹的特效
 *
 * 核心组件:
 * 1. ButtonWithWaterRipples
 *
 * 实现步骤：
 * 1. 要实现存在两个连续的涟漪，需要两个层叠的Stack分别以一定延迟进行相同的动画。
 * 2. 通过点击按钮来判断isListening变量，如果为true则添加动画。涟漪动画实际上的效果为透明度0.8->0，半径扩大到6倍的动画，持续时间无限。
 * 3. 如果isListening为false，则用持续时间为0的动画来打断持续时间无限的动画。
 */

@Component
export struct WaterRipplesComponent {
  @State isListening: boolean = false; // 控制组件状态 true：开启水波纹 false：停止水波纹

  /**
   * 创建一个Column组件，内部的ButtonWithWaterRipples为水波纹按钮，用来切换水波纹动画。
   * 当点击按钮时，开始触发水波纹动画，下方的文字从点击开始识曲改为正在聆听
   */
  build() {
    Column() {
      Text($r('app.string.water_ripples_sound_hound'))
        .fontColor(Color.White)
        .fontSize(18)
        .margin({ top: $r('app.integer.water_ripples_margin_large') })

      ButtonWithWaterRipples({ isListening: this.isListening })

      Text(this.isListening ? $r('app.string.water_ripples_is_listening') : $r('app.string.water_ripples_click_to_listen'))
        .fontColor(Color.White)
        .margin({ bottom: $r('app.integer.water_ripples_margin_large') })
    }
    .backgroundColor(Color.Black)
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .height("100%")
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

interface Scale {
  x: number;
  y: number;
}

@Component
struct ButtonWithWaterRipples {
  @Link isListening: boolean; // 控制组件状态 true：开启水波纹 false：停止水波纹
  @State immediatelyOpacity: number = 0.8; // 立刻触发动画的Stack初始透明度
  @State immediatelyScale: Scale = { x: 1, y: 1 }; // 立刻触发动画的Stack初始缩放度
  @State delayOpacity: number = 0.8; // 延迟200ms触发动画的Stack初始透明度
  @State delayScale: Scale = { x: 1, y: 1 }; // 延迟200ms触发动画的Stack初始缩放度
  private readonly BUTTON_SIZE: number = 120; // 按钮大小
  private readonly BUTTON_CLICK_SCALE: number = 0.8; // 按钮点击时缩放比例
  private readonly ANIMATION_DURATION: number = 1300; // 动画持续时间

  @Styles
  ripplesStyle() {
    .width(this.BUTTON_SIZE * this.BUTTON_CLICK_SCALE)
    .height(this.BUTTON_SIZE * this.BUTTON_CLICK_SCALE)
    .borderRadius(this.BUTTON_SIZE * this.BUTTON_CLICK_SCALE / 2)
    .backgroundColor(Color.White)
  }

  build() {
    /**
     * 创建两个Stack组件，用来展示扩大的水波纹动画，然后在下面创建一个Button组件，作为按钮，修改isListening的值。
     * 当isListening为true时，两个Stack分别以200延迟，生成透明度0.8->0和扩大1->6倍半径的动画。
     * 当isListening为false时，设置duration为0动画打断扩散的特效。
     * 在Button按钮
     */
    Stack() {
      Stack()
        .ripplesStyle()
        .opacity(this.immediatelyOpacity)
        .scale(this.immediatelyScale)
      Stack()
        .ripplesStyle()
        .opacity(this.delayOpacity)
        .scale(this.delayScale)
      Button() {
        Image($r("app.media.water_ripples_music_filled"))
          .width(50)
          .fillColor(Color.White)
      }
      .id('ripplesButton')
      .clickEffect({ level: ClickEffectLevel.HEAVY, scale: this.BUTTON_CLICK_SCALE })
      .backgroundColor($r("app.color.water_ripples_music_icon"))
      .type(ButtonType.Circle)
      .width(this.BUTTON_SIZE)
      .height(this.BUTTON_SIZE)
      .zIndex(1)
      .onClick(() => {
        this.isListening = !this.isListening;
        if (this.isListening) {
          /** TODO: 知识点：新建两个动画，分别修改两个Stack的属性，设置延迟200ms，展示为两个连续的涟漪，iterations设置为-1表示无限重复
           * 高性能知识点：建议使用系统提供的动画接口，如果使用自定义动画，在动画曲线计算过程很容易引起UI线程高负载。
           * 参考《减少动画丢帧》文章
           * https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/performance/reduce-animation-frame-loss.md/
           **/
          animateTo({ duration: this.ANIMATION_DURATION, iterations: -1, curve: Curve.EaseInOut }, () => {
            this.immediatelyOpacity = 0;
            this.immediatelyScale = { x: 6, y: 6 };
          })
          animateTo({ duration: this.ANIMATION_DURATION, iterations: -1, curve: Curve.EaseInOut, delay: 200 }, () => {
            this.delayOpacity = 0;
            this.delayScale = { x: 6, y: 6 };
          })
        } else {
          // TODO: 知识点：用一个持续时间为0的闭包函数修改变量去打断动画
          animateTo({ duration: 0 }, () => {
            this.immediatelyOpacity = 0.8;
            this.delayOpacity = 0.8;
            this.immediatelyScale = { x: 1, y: 1 };
            this.delayScale = { x: 1, y: 1 };
          })
        }
      })
    }
  }
}
