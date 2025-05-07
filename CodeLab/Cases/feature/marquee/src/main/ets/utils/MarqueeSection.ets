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

import { logger } from './Logger';
import { MarqueeAnimationModifier, MarqueeScrollModifier } from '../model/DataType';
import { componentUtils } from '@kit.ArkUI';

/**
 * 功能描述：
 * 1. 进入页面，跑马灯文本超过Scroll本身的长度，文本滚动。
 *
 * 实现原理：
 * 1. Text组件外层包裹一层Scroll组件，Scroll组件设置一定的百分比宽度值，并获取当前文本内容宽度和Scroll组件宽度，文本宽度大于Scroll组件宽度时，通过添加判断显示同样的文本，在偏移过程中可实现文本接替并显示在同一显示区的效果。
 * 2. 页面进来执行文本滚动函数scrollAnimation()，在指定的时间内完成文本的偏移，当循环一次之后，通过定时器setTimeout来实现停滞操作。
 *
 * @param {()=>void} marqueeTextBuilder - 跑马灯文本内容视图
 * @param {MarqueeAnimationModifier} marqueeAnimationModifier - 跑马灯滚动动画属性
 * @param {MarqueeScrollModifier} marqueeScrollModifier - 跑马灯文本滚动属性
 */

@Component
export struct MarqueeSection {
  // -------------------对外暴露变量-----------------------
  // 跑马灯文本视图
  @BuilderParam marqueeTextBuilder: () => void;
  // 跑马灯动画属性
  marqueeAnimationModifier: MarqueeAnimationModifier = new MarqueeAnimationModifier();
  // 跑马灯文本滚动属性
  marqueeScrollModifier: MarqueeScrollModifier = new MarqueeScrollModifier();
  // --------------------私有属性----------------------------
  // 初始化文本偏移量
  @State ticketCheckTextOffset: number = 0;
  // 初始化文本组件所占的宽度
  @State ticketCheckTextWidth: number = 0;
  // 初始化Scroll组件所占的宽度
  @State ticketCheckScrollWidth: number = 0;
  // 记滚动次数
  count: number = 1;
  // 定时器句柄
  timer: number = -1;

  // 文本滚动函数
  scrollAnimation() {
    // 文本宽度小于Scroll组件宽度，不执行滚动操作
    if (this.ticketCheckTextWidth < this.ticketCheckScrollWidth) {
      return;
    }
    /**
     * 文本跑马灯动画。可以控制文本向左或者向右滚动，每隔1s再次滚动。
     *
     * 性能：播放动画时，系统需要在一个刷新周期内完成动画变化曲线的计算，完成组件布局绘制等操作。建议使用系统提供的动画接口，
     * 只需设置曲线类型、终点位置、时长等信息，就能够满足常用的动画功能，减少UI主线程的负载。
     * 参考资料：https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-explicit-animation-V5
     */
    animateTo({
      duration: this.marqueeAnimationModifier.duration,
      tempo: this.marqueeAnimationModifier.tempo,
      curve: Curve.Linear,
      onFinish: () => {
        // TODO：知识点：动画完成时，添加定时器，1s之后重新执行动画函数，达到停滞操作。
        this.ticketCheckTextOffset =
          this.marqueeAnimationModifier.playMode === PlayMode.Normal ? 0 :
            -(2 * this.ticketCheckTextWidth + this.marqueeScrollModifier.space - this.ticketCheckScrollWidth);
        if (this.marqueeAnimationModifier.iterations > 1) {
          if (this.count === this.marqueeAnimationModifier.iterations) {
            this.count = 1;
            return;
          }
          this.count++;
          // 次数为0或者1不重复执行
        } else if (this.marqueeAnimationModifier.iterations === 0 || this.marqueeAnimationModifier.iterations === 1) {
          return;
        }
        this.timer = setTimeout(() => {
          this.scrollAnimation();
        }, this.marqueeAnimationModifier.delayTime)
      }
    }, () => {
      // 文本偏离量
      this.ticketCheckTextOffset = this.marqueeAnimationModifier.playMode === PlayMode.Normal ?
        -(this.ticketCheckTextWidth + this.marqueeScrollModifier.space) :
        -(this.ticketCheckTextWidth - this.ticketCheckScrollWidth)
    })
  }

  aboutToAppear(): void {
    // 清楚定时器
    clearTimeout(this.timer);
  }

  build() {
    // TODO：知识点：使用Scroll组件和文本内容组件结合来判断文本宽度过宽时执行文本滚动，否则不执行
    Scroll() {
      Row() {
        Column() {
          this.marqueeTextBuilder()
        }
        .onAreaChange((oldValue, newValue) => {
          logger.info(`TextArea oldValue:${JSON.stringify(oldValue)},newValue:${JSON.stringify(newValue)}`);
          // 获取当前文本内容宽度
          let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById('marquee');
          this.ticketCheckScrollWidth = Number(px2vp(modePosition.size.width));
          this.ticketCheckTextWidth = Number(newValue.width);
          if (this.ticketCheckTextWidth < this.ticketCheckScrollWidth) {
            return;
          }
          this.ticketCheckTextOffset =
            this.marqueeAnimationModifier.playMode === PlayMode.Normal ? 0 :
              -(2 * this.ticketCheckTextWidth + this.marqueeScrollModifier.space - this.ticketCheckScrollWidth);
        })

        // TODO：知识点：文本宽度大于Scroll组件宽度时显示。在偏移过程中可实现文本接替并显示在同一显示区的效果
        if (this.ticketCheckTextWidth >= this.ticketCheckScrollWidth) {
          Blank()
            .width(this.marqueeScrollModifier.space)
          this.marqueeTextBuilder()
        }
      }.offset({ x: this.ticketCheckTextOffset })
      .onAppear(() => {
        // 执行动画函数
        this.scrollAnimation();
      })
    }
    .width(this.marqueeScrollModifier.scrollWidth)
    .id('marquee')
    .alignRules({
      top: { anchor: '__container__', align: VerticalAlign.Top },
      left: { anchor: 'ticketEntrance', align: HorizontalAlign.End }
    })
    .align(Alignment.Start)
    .enableScrollInteraction(false)
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}