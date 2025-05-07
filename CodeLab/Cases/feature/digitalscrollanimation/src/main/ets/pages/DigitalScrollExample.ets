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

import { STYLE_CONFIG } from '../model/ConstData';
import { DigitalScrollDetail } from './DigitalScrollDetail';

/**
 * 功能描述: 本示例主要介绍了数字滚动动效的实现方案。 该方案多用于数字刷新，例如页面刷新抢票数量等场景。
 *
 * 推荐场景: 用于数字刷新，例如页面刷新抢票数量等场景
 *
 * 核心组件:
 * 1. DigitalScrollDetail
 *
 * 实现步骤：
 * 1. 通过双重ForEach循环分别横向、纵向渲染数字。
 * 2. 通过Math.random()生成随机数，并更新到currentData数组中。
 * 3. 使用显示动画animateTo，对currentData数组中的每个数字执行不同的滚动动效。
 * 4. 设置数字所在容器属性.clip(true)，将多余的数字裁剪。
 */

@Component
export struct DigitalScrollExampleComponent {
  private scroller: Scroller = new Scroller(); // Scroller对象
  @State data: number[] = [1, 2, 3, 4, 5, 6]; // 数据项
  @State isRefresh: boolean = false;

  build() {
    Column({ space: STYLE_CONFIG.ITEM_GUTTER }) {
      // 下拉刷新组件
      Refresh({ refreshing: $$this.isRefresh }) {
        this.scrollArea()
      }
      .onRefreshing(() => {
        setTimeout(() => {
          this.isRefresh = false; // 刷新完成
        }, 1000)
      })
    }
    .padding({
      top: STYLE_CONFIG.PADDING_TOP
    })
    .width($r('app.string.digital_scroll_animation_max_size'))
    .height($r('app.string.digital_scroll_animation_max_size'))
    .linearGradient({
      colors: [[$r('app.color.digital_scroll_animation_background_color'), 0.0], [$r('sys.color.ohos_id_color_background'), 0.3]]
    })
  }

  @Builder
  scrollArea() {
    List({ space: STYLE_CONFIG.ITEM_GUTTER, scroller: this.scroller }) {
      ListItem() {
        Text($r('app.string.digital_scroll_animation_ticket'))
          .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          .width($r('app.string.digital_scroll_animation_max_size'))
          .textAlign(TextAlign.Center)
      }

      ListItem() {
        Row({ space: STYLE_CONFIG.TEXT_MARGIN }) {
          Text($r('app.string.digital_scroll_animation_today'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontWeight(FontWeight.Bold)

          // 数字滚动组件
          DigitalScrollDetail({ isRefresh: this.isRefresh })

          Text($r('app.string.digital_scroll_animation_get_ticket'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontWeight(FontWeight.Bold)
        }
        .width($r('app.string.digital_scroll_animation_max_size'))
        .justifyContent(FlexAlign.Center)
      }
    }
    .scrollBar(BarState.Off) // 设置滚动调状态不可见
    .height($r('app.string.digital_scroll_animation_max_size'))
  }
}
