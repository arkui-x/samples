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
 * 实现步骤：

 */

/**
 * 功能描述: 本示例介绍通过分割swiper区域，实现指示器导航点位于swiper下方的效果。
 *
 * 推荐场景: 指示器导航点位于swiper下方的场景
 *
 * 核心组件:
 * 1.indicator属性
 *
 * 实现步骤：
 * 1. 将swiper区域分割为两块区域，上方为内容区域，下方为空白区域
 * 2. 通过indicator属性调整指示器位置，使其位于空白区域
 */

@Component
export struct IndicatorBelowSwiperComponent {
  // 创建swiper组件控制器
  private swiperController: SwiperController = new SwiperController();
  // swiper显示数据
  private swiperData: Resource[] = [
    $r('app.media.page1'),
    $r('app.media.page2'),
    $r('app.media.page3'),
  ];

  build() {
    Column() {
      Swiper(this.swiperController) {
        // TODO 高性能知识点：此处为了演示场景，列表数量只有3个，使用ForEach，列表数量较多的场景，推荐使用LazyForEach+组件复用+缓存列表项实现
        ForEach(this.swiperData, (item: Resource, index: number) => {
          Column() {
            // TODO 知识点：将swiper区域分割成内容区和空白区
            Image(item)
              .width($r('app.string.indicatorbelowswiper_one_hundred_percent'))
              .height($r('app.string.indicatorbelowswiper_thirty_percent'))
              .borderRadius($r('app.integer.indicatorbelowswiper_borderRadius_value'))

            Column()
              .width($r('app.string.indicatorbelowswiper_one_hundred_percent'))
              .height($r('app.integer.indicatorbelowswiper_blank_space_height'))
          }
          .id('indicator_below_swiper_image_' + index)
        })
      }
      .id('indicator_below_swiper_component')
      .width($r('app.string.indicatorbelowswiper_ninety_five_percent'))
      .loop(true)
      .autoPlay(true)
      // TODO 知识点：通过indicator属性，将导航点放置到空白区域，实现指示器导航点位于swiper下方的效果
      .indicator(new DotIndicator().bottom($r('app.integer.indicatorbelowswiper_offset_value')))
    }
    .width($r('app.string.indicatorbelowswiper_one_hundred_percent'))
    .height($r('app.string.indicatorbelowswiper_one_hundred_percent'))
    .justifyContent(FlexAlign.Center)
  }
}