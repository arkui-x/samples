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

import { FistGoodsModel, SecondGoodsItemList, ThirdGoodsItem } from '../model/GoodsModel'
import { loadSource, targetItemList, originItemList } from '../model/GoodsModel'
import GoodViewStruct from './ProductView';

const OHOS_CARD_MARGIN = 16 // 各组件上下间距

/**
 * 功能描述：本示例介绍使用@Observed装饰器和@ObjectLink装饰器来实现多层嵌套类对象属性变化的监听。
 *
 * 推荐场景：内容需要刷新的页面，如购物商城，新闻咨询页
 *
 * 核心组件：
 * 1.GoodViewStruct
 * 2.SecondViews
 * 3.ThirdView
 *
 * 实现步骤：
 * 1. 用@state装饰第一层嵌套的类，子组件中用@Link装饰对应的变量建立双向数据绑定
 * 2. 用@Observed装饰嵌套的第二层类SecondGoodsItemList和第三层类ThirdGoodsItem
 * 3. 嵌套自定义组件，SecondViews、ThirdView中用@ObjectLink分别装饰SecondGoodsItemList、ThirdGoodsItem变量
 * 4. 触发点击更新第三层嵌套class ThirdGoodsItem的数据，UI刷新
 */

@Component
export struct VariableWatchViewComponent {
  @State itemList: Array<ThirdGoodsItem> = loadSource(); // 初始化第三层嵌套数组
  @State imgItemList: SecondGoodsItemList = new SecondGoodsItemList(this.itemList); // 初始化第二层嵌套数组列表
  @State model: FistGoodsModel = new FistGoodsModel(this.imgItemList); // 初始化首层Model类
  @State isGoodsChanged: Boolean = false; // 数据刷新标志

  build() {
    Column({ space: OHOS_CARD_MARGIN }) {
      Column({ space: OHOS_CARD_MARGIN }) {
        Text($r('app.string.variablewatch_headline')).fontSize($r('app.string.variablewatch_text_size_headline'))
        Text($r('app.string.variablewatch_function_introduction')).fontSize($r('app.string.variablewatch_text_size_body1'))
      }
      .backgroundColor($r('app.color.variablewatch_color_background'))
      .width($r('app.string.variablewatch_full_size'))
      .padding($r('app.string.variablewatch_card_margin_start'))
      .borderRadius($r('app.string.variablewatch_corner_radius_default_m'))

      Column() {
        Text($r('app.string.variablewatch_mall')).fontSize($r('app.string.variablewatch_text_size_headline'))
      }

      Row() {
        Text($r('app.string.variablewatch_top_recommend'))
      }.justifyContent(FlexAlign.Start).width($r('app.string.variablewatch_full_size'))

      Column() {
        // 显示自定义组件
        GoodViewStruct({model: $model})
      }
      .width($r('app.string.variablewatch_full_size'))

      Column() {
        Button($r('app.string.variablewatch_refresh_data')).fontSize($r('app.string.variablewatch_text_size_body1')).width($r('app.string.variablewatch_full_size'))
          // 点击后更新第三层嵌套class ThirdGoodsItem的数据，UI刷新
          .onClick(() => {
            this.isGoodsChanged = !this.isGoodsChanged
            // 能循环更新ThirdGoodsItem的数据
            if (this.isGoodsChanged) {
              this.itemList.forEach((item, index) => {
                item.imgSrc = targetItemList[index].imgSrc;
                item.price = targetItemList[index].price;
              })
            }
            // 能循环更新ThirdGoodsItem的数据
            else {
              this.itemList.forEach((item, index) => {
                item.imgSrc = originItemList[index].imgSrc;
                item.price = originItemList[index].price;
              })
            }
          })
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .height($r('app.string.variablewatch_full_size'))
    .width($r('app.string.variablewatch_full_size'))
    .backgroundColor($r('app.color.variablewatch_color_sub_background'))
    .padding($r('app.string.variablewatch_card_margin_start'))
  }
}