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

import { CommonConstants } from '../common/CommonConstants';

/**
 * 功能描述:
 * 父容器Scroll组件统一派发子组件的偏移量
 *
 * 实现原理：
 * 1、MyScroll对子组件进行偏移量派发: MyScroll使用Scroll.onScrollFrameBegin()中返回的offset滑动量判断页面上划/下划，
 * 进而通过this.scrollWeb(offset)派发给web偏移量，通过this.scrollList(offset)派发给List偏移量，从而实现web的滚动和list组件滚动能无缝衔接，像同一个滚动组件滚动效果。
 *
 * @param {() => void} webBuilder - web组件(新闻内容)(必需)
 * @param {() => void} listBuilder - List组件(评论内容)(必需)
 * @param {() => void} titleBuilder - 评论总数标题(必需)
 * @param {boolean} isWebAtEnd - 传递Web组件是否滚动到下边界(必需)
 * @param {()=> void} [getWebScrollEnd] - 刷新web组件偏移量
 * @param {(offset:number)=> void} [scrollWeb] - 刷新web组件偏移量
 * @param {(offset:number)=> void} [scrollList] - MyScroller组件滑动list
 * @param {()=> number} [getListOffset] - MyScroller刷新list组件的yOffset
 */

@Component
export struct MyScroller {
  private scroller: Scroller = new Scroller(); // 创建Scroller对象
  scrollWeb?: (offset: number) => void; // 滚动偏移派发给Web
  scrollList?: (offset: number) => void; // 滚动偏移派发给List
  getListOffset?: () => number; // 检测List是否到上边界
  getWebScrollEnd?: () => void; // 检测Web组件是否滚动到边界

  @Builder
  customBuilder1() {
  }; // 定义Web的builder方法

  @Builder
  customBuilder2() {
  }; // 定义List的builder方法

  @Builder
  customBuilder3() {
  }; // 定义评论标题的builder方法

  @BuilderParam webBuilder: () => void = this.customBuilder1; // 使用父组件@Builder装饰的方法初始化子组件@BuilderParam
  @BuilderParam listBuilder: () => void = this.customBuilder2; // 使用父组件@Builder装饰的方法初始化子组件@BuilderParam
  @BuilderParam titleBuilder: () => void = this.customBuilder3; // 使用父组件@Builder装饰的方法初始化子组件@BuilderParam
  @Link isWebAtEnd: boolean; // 是否接触到Web底部

  build() {
    Scroll(this.scroller) {
      Column() {
        this.webBuilder()
        this.titleBuilder()
        this.listBuilder()
      }
      .width(CommonConstants.FULL_PERCENT)
    }
    // TODO：知识点：通过调用Scroll.onScrollFrameBegin()，在每帧开始滚动时触发时将Scroll返回的实际滚动量的offset，通过scrollBy(0, offset)方法，将Scroll的竖直方向偏移量派发给Web、List。
    .onScrollFrameBegin((offset: number, state: ScrollState) => {
      this.getWebScrollEnd && this.getWebScrollEnd(); // 检测Web组件是否滚动到边界
      /*
       * offset > 0 : 页面下滑
       * offset < 0 : 页面上滑
       * */
      if (offset > 0) {
        if (!this.isWebAtEnd) { // 还没触到Web底部
          // 通过调用Web的WebController.scrollBy接口，滚动偏移派发给Web（水平方向滚动距离为0，竖直方向滚动距离为offset）
          this.scrollWeb && this.scrollWeb(offset);
          return { offsetRemain: 0 };
        } else if (this.scroller && this.scroller.isAtEnd()) { // 检测scroll组件滚动到了下边界
          // 通过调用List滚动控制器的scrollBy接口，滚动偏移量派发给List
          this.scrollList && this.scrollList(offset);
          return { offsetRemain: 0 };
        }
      } else if (offset < 0) {
        if (this.getListOffset && this.getListOffset() > 0) { // 检测List还没到上边界
          // 通过调用List滚动控制器的scrollBy接口，滚动偏移派发给List
          this.scrollList && this.scrollList(offset);
          return { offsetRemain: 0 };
        } else if (this.scroller && this.scroller.currentOffset().yOffset <= 0) { // 检测scroll组件滚动到了上边界
          // 通过调用Web的WebController.scrollBy接口，滚动偏移量派发给web
          this.scrollWeb && this.scrollWeb(offset);
          return { offsetRemain: 0 };
        }
      }
      return { offsetRemain: offset } // 否则，scroll自身滚动
    })
    .scrollable(ScrollDirection.Vertical)
    .width('100%')
    .scrollBar(BarState.Off)
    .id('scroll_content')
    .alignRules({
      top: { anchor: "row_title", align: VerticalAlign.Bottom },
      bottom: { anchor: "relative_publish", align: VerticalAlign.Top },
      middle: { anchor: "__container__", align: HorizontalAlign.Center },
    })
    .id('scrollContainer')
  }
}