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

import CommonConstants from '../common/constants/CommonConstants';
import { ProductItemComp } from '../components/ProductItemComp';
import { Product, ProductsDataSource } from '../model/ProductModel';

/**
 * 功能描述：HarmonyOS上不支持.9资源文件进行安全拉伸。 作为替代方案，本案例中商城页面的促销标签边框使用同一张图片资源，通过设置图片的resizable属性，展示不同长度的促销标签效果。
 *
 * 推荐场景：商城页面
 *
 * 核心组件：
 * 1.ProductItemComp,
 *
 * 实现步骤：
 * 1.使用WaterFlow+LazyForEach+组件复用实现高性能瀑布流
 */

@Component
export struct ProductWaterFlowPageComponent {
  @State productsDataSource: ProductsDataSource = new ProductsDataSource();

  build() {
    Column(){
      WaterFlow() {
        LazyForEach(this.productsDataSource, (item: Product) => {
          FlowItem() {
            // TODO: 性能知识点：使用@Reusable修饰可复用的组件，并通过设置reuseId提供瀑布流滑动场景中的组件复用能力
            ProductItemComp({
              product: item
            })
              .reuseId(item.type)
          }
          .width('100%')
        })
      }
      .columnsTemplate(CommonConstants.MAIN_PAGE_WATERFLOW_COLUMNS_TEMPLATE)
      .width('100%')
      .height('100%')
      .edgeEffect(EdgeEffect.Fade)
      .clip(false)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .clip(true)
  }
}