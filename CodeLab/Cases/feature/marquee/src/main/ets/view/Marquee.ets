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

import { display } from '@kit.ArkUI';
import { PlatformTypeEnum, PlatformInfo } from 'utils';
import Constants from '../model/Constants';
import { MarqueeAnimationModifier, MarqueeScrollModifier, TripDataType } from '../model/DataType';
import { TripDataSource } from '../model/DataSource';
import { MarqueeSection } from '../utils/MarqueeSection';

/**
 * 功能描述: 本示例介绍了文本宽度过宽时，如何实现文本首尾相接循环滚动并显示在可视区，以及每循环滚动一次之后会停滞一段时间后再滚动。
 *
 * 推荐场景: 消息通知展示
 *
 * 核心组件:
 * 1. MarqueeSection - 跑马灯组件
 *
 * 实现步骤:
 *
 * 1. 跑马灯内容视图。开发者可以根据自身业务场景设置文本的属性（字体大小、字体颜色、字体粗细等属性）
 * @example
 * @Builder
   marqueeTextBuilder(marqueeText: ResourceStr) {
     Text(marqueeText)
   }

 * 2. 构建跑马灯视图。在代码合适的位置使用MarqueeSection组件并传入对应的参数。
 * @example
   MarqueeSection({
     marqueeTextBuilder: () => {
       this.marqueeTextBuilder(this.tripDataItem.ticketEntrance)
     },
     marqueeAnimationModifier: new MarqueeAnimationModifier(),
     marqueeScrollModifier: new MarqueeScrollModifier(display.isFoldable() ?
     $r('app.string.marquee_scroll_phone_width') : $r('app.string.marquee_scroll_tablet_width'),
       Constants.BLANK_SPACE)
   })
   * 跑马灯滚动动画属性
   * @param iterations - 动画播放次数。默认播放一次，设置为-1时表示无限次播放。设置为0时表示无动画效果
   * @param duration - 动画持续时间，单位为毫秒
   * @param tempo - 动画播放速度，值越大动画播放越快，值越小播放越慢，为0时无动画效果
   * @param playMode - 控制跑马灯向左还是向右滚动
   * @param delayTime - 动画延迟播放时间，单位为ms(毫秒)，默认延时1s播放

   export class MarqueeAnimationModifier {
     iterations: number;
     duration: number;
     tempo: number;
     playMode: PlayMode;
     delayTime: number;

     constructor(iterations: number = -1, duration: number = Constants.ANIMATION_DURATION, tempo: number = 1,
       playMode: PlayMode = PlayMode.Reverse, delayTime: number = Constants.DELAY_TIME) {
       this.iterations = iterations;
       this.duration = duration;
       this.tempo = tempo;
       this.playMode = playMode;
       this.delayTime = delayTime;
     }
   }
   * 跑马灯滚动属性
   * @param scrollWidth - 滚动轴宽度
   * @param space - 文本间隔
   export class MarqueeScrollModifier {
     scrollWidth: Length;
     space: number;

     constructor(scrollWidth: Length = Constants.DEFAULT_SCROLL_WIDTH, space: number = Constants.BLANK_SPACE) {
       this.scrollWidth = scrollWidth;
       this.space = space;
     }
   }
*/
@Component
export struct MarqueeViewComponent {
  build() {
    Column() {
      // 场景介绍组件
      FunctionDescription({
        title: $r('app.string.marquee_title'),
        content: $r('app.string.marquee_content')
      })
      // 行程信息组件
      TripView()
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .width('100%')
    .height('100%')
    .padding($r('app.string.ohos_id_card_padding_start'))
    .linearGradient({
      angle: Constants.ANGLE,
      colors: [[$r('app.color.marquee_bg_color1'), 0], [$r('app.color.marquee_bg_color2'), 1]]
    })
  }
}

@Component
struct TripView {
  @State tripData: TripDataSource = new TripDataSource();

  build() {
    Column() {
      Text($r('app.string.marquee_my_trip'))
        .width('100%')
        .fontSize($r('app.string.ohos_id_text_size_headline'))
        .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_l') })
      // 性能：动态加载数据场景可以使用LazyForEach遍历数据。https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
      LazyForEach(this.tripData, (item: TripDataType) => {
        // 单个行程信息组件
        TripMessage({
          tripDataItem: item
        })
      }, (item: TripDataType) => JSON.stringify(item))
    }
  }
}

/**
 * 本示例介绍了文本宽度过宽时，则实现跑马灯效果(文本首尾相连循环滚动并且显示在同一可视区，以及每循环一次之后会停滞一段时间后再滚动)。
 * 由于ArkUI中的Marquee组件无法实现文本接替并显示在同一可视区的效果，它只能等文本完全消失在可视区之后，才会再次显示在可视区，因此需要使用以下
 * 方案：首先将Text组件外层包裹一层Scroll组件，Scroll组件设置一定的宽度值。页面进来执行scrollAnimation函数。文本宽度超过Scroll组件
 * 宽度的时候，将Text文本向左偏移，偏移一段距离之后，可视区显示下一段文本。其中偏移过程使用animateTo来实现。每循环滚动一次停滞操作
 * 通过使用计时器setTimeout来实现，1s之后，初始化偏移量，再次执行动画。
 */
@Component
struct TripMessage {
  // 行程信息数据
  private tripDataItem: TripDataType = {} as TripDataType;
  // 跑马灯动画属性类
  private marqueeAnimationModifier: MarqueeAnimationModifier = new MarqueeAnimationModifier();
  // 跑马灯滚动文本属性类
  private marqueeScrollModifier: MarqueeScrollModifier = new MarqueeScrollModifier($r('app.string.marquee_scroll_tablet_width'), Constants.BLANK_SPACE);

  // 通用样式函数
  @Styles
  commonStyles(){
    .width('100%')
    .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_m') })
  }

  aboutToAppear(): void {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      if (display.isFoldable()) {
        this.marqueeScrollModifier = new MarqueeScrollModifier($r('app.string.marquee_scroll_phone_width'), Constants.BLANK_SPACE);
      }
    }
  }

  build() {
    Column() {
      Row() {
        Text(this.tripDataItem.trainNumber)
        Text(this.tripDataItem.wholeCourse)
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.tripDataItem.startingTime)
          .fontSize($r('sys.float.ohos_id_text_size_headline6'))
          .width(100)
          .textAlign(TextAlign.Start)
        Text($r('app.string.marquee_plan_text'))
          .fontColor($r('app.color.ohos_id_color_emphasize'))
          .width(80)
          .height(24)
          .textAlign(TextAlign.Center)
          .border({
            width: 1,
            radius: $r('app.string.ohos_id_corner_radius_default_m'),
            color: $r('app.color.ohos_id_color_emphasize')
          })
        Text(this.tripDataItem.endingTime)
          .fontSize($r('sys.float.ohos_id_text_size_headline6'))
          .width(100)
          .textAlign(TextAlign.End)

      }.commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(this.tripDataItem.origin)
        Text(this.tripDataItem.timeDifference)
        Text(this.tripDataItem.destination)
      }.commonStyles()
      .justifyContent(FlexAlign.SpaceBetween)

      RelativeContainer() {
        Text($r('app.string.marquee_ticket_entrance'))
          .padding({
            right: 4
          })
          .id('ticketEntrance')
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
        /**
         * 跑马灯组件
         * @param {()=>void} marqueeTextBuilder - 内容组件
         * @param {MarqueeAnimationModifier} marqueeAnimationModifier - 跑马灯动画属性类
         * @param {MarqueeScrollModifier} marqueeScrollModifier -  跑马灯滚动文本属性类
         */
        MarqueeSection({
          marqueeTextBuilder: () => {
            this.marqueeTextBuilder(this.tripDataItem.ticketEntrance)
          },
          marqueeAnimationModifier: this.marqueeAnimationModifier,
          marqueeScrollModifier: this.marqueeScrollModifier
        })

        Row() {
          Text($r('app.string.marquee_vehicle_model'))
          Text(this.tripDataItem.vehicleModel)
        }
        .id('vehicleModel')
        .justifyContent(FlexAlign.End)
        .backgroundColor(Color.White)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
      }
    }
    .width('100%')
    .height($r('app.integer.marquee_trip_message_height'))
    .padding($r('app.string.ohos_id_card_padding_start'))
    .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_l') })
    .backgroundColor(Color.White)
  }

  /**
   * 跑马灯文本Builder，开发者可以自定义文本属性如（字体大小、字体粗细、字体样式等文本属性）
   * @param marqueeText - 文本内容
   */
  @Builder
  marqueeTextBuilder(marqueeText: ResourceStr) {
    Text(marqueeText)
  }
}

/**
 * 模块功能描述组件
 * @param title 标题
 * @param context 内容
 */
@Component
export struct FunctionDescription {
  private title: ResourceStr = '';
  private content: ResourceStr = '';

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize($r('app.string.ohos_id_text_size_headline'))
          .fontWeight(FontWeight.Medium)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
      }
      .margin({ bottom: $r('app.string.ohos_id_elements_margin_vertical_m') })

      Row() {
        Text(this.content)
          .wordBreak(WordBreak.BREAK_ALL)
      }
      .width('100%')
    }
    .width('100%')
    .backgroundColor($r('app.color.ohos_id_color_sub_background'))
    .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
    .padding($r('app.string.ohos_id_card_padding_start'))
  }
}