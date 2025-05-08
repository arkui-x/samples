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

import { SubmitInfoWrapper } from '../common/DataModel';
import { CategoryView } from './CategoryView';
import { HeaderView } from './HeaderView';
import { TableView } from './TableView';
import { UserNoticeView } from './UserNoticeView';

/**
 * 功能描述: 在许多场景下，我们都需要引导用户按照步骤完成任务，此功能在HarmonyOS Next中可以使用Stepper来实现，但是Stepper的定制化能力较弱，开发者无法定制上下页切换按钮的样式、位置，因此本例介绍了如何基于Swiper实现Stepper的能力。
 *
 * 推荐场景: 问卷填写以及一些应用的功能指导场景
 *
 * 核心组件:
 * 1. CategoryView
 * 2. UserNoticeView
 *
 * 实现步骤：
 * 1. 页面公共部分置于最外层
 * 2. 使用swiper控制页面前进后退流程，页面主体内容由swiper承载
 * 3. 为了便于做数据较验，将前进/后退的控制按钮置于swiper item中
 * 4. 每个页面的数据校验通过回调验证，只有当验证通过，回调函数返回true时，才能正常进入下一页面，否则提示用户当前页面数据填写不完整
 */
@Component
export struct CustomStepperViewComponent {
  @State currentIndex: number = 0; // 当前页面的索引，用以和HeaderView中的文字部分联动
  pageTitleArray: string[] = // HeaderView中的title字段列表，每个页面都有自己的title
    getContext(this).resourceManager.getStringArrayValueSync($r("app.strarray.stepper_title_array").id);
  lastIndex: number = this.pageTitleArray.length - 1; // 最后一个页面的索引
  submitInfo: SubmitInfoWrapper = new SubmitInfoWrapper(); // 用以承载用户填写的数据
  controller: SwiperController = new SwiperController();

  build() {
    Column() {
      // TODO 知识点：页面上方的返回/更多按钮在各个页面是一样的，因此这里将其与页面Title一起置于Swiper同级
      HeaderView({ titleArray: this.pageTitleArray, currentIndex: this.currentIndex })
      // TODO 知识点：页面主体内容由Swiper承载，通过Swiper的Controller来控制页面的上下页切换
      Swiper(this.controller) {
        UserNoticeView({
          currentIndex: 0,
          lastIndex: this.lastIndex,
          controller: this.controller,
        })
        CategoryView({
          currentIndex: 1,
          lastIndex: this.lastIndex,
          controller: this.controller,
          submitInfo: this.submitInfo
        })
        TableView({
          currentIndex: 2,
          lastIndex: this.lastIndex,
          controller: this.controller,
          submitInfo: this.submitInfo
        })
      }
      // TODO 知识点：通过layoutWeight(1)实现Swiper占满页面剩余空间
      .layoutWeight(1)
      .cachedCount(1)
      // TODO 知识点：禁用Swiper的滑动切换，由Controller来控制页面的前进后退
      .disableSwipe(true)
      .backgroundColor(Color.Transparent)
      .index($$this.currentIndex)
      .width('100%')
      .loop(false)
      .autoPlay(false)
      .indicator(false)
    }.width('100%')
    .height('100%')
    .padding($r("sys.float.ohos_id_card_margin_start"))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}


/**
 * 创建WrappedBuilder对象，动态路由跳转时构建页面
 */
@Builder
export function getCustomStepperView(): void {
  CustomStepperViewComponent();
}
