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
import { Product } from '../model/ProductModel';
import { promptAction } from '@kit.ArkUI';

/**
 * 商品信息组件
 * 实现步骤：
 * 1.商品促销标签使用Image图片的resizable设计，使用同一张资源图片，通过监听内容文本宽高变化，动态且安全地拉伸宽高
 * 2.其他商品信息内容尽量采用扁平布局，同时使用@Builder替代自定义组件，实现高性能
 */
@Reusable
@Component
export struct ProductItemComp {
  // 商品对象
  @ObjectLink product: Product;
  // 促销标签背景图片宽度状态变量
  @State discountTextWidth: Length = 0;
  // 促销标签背景图片高度状态变量
  @State discountTextHeight: Length = 0;

  // 促销标签展示，采用resizable属性实现安全拉伸
  @Builder discountCoupon(discount: string) {
    Stack() {
      Image($r('app.media.imageresizable_border'))
        .width(this.discountTextWidth)
        .height(this.discountTextHeight)
        // TODO: 知识点：通过设置图片组件的resizable属性，设置顶部、右侧、底部、左侧的距离，使其边缘部分在图片拉伸时不会发生变化，仅图片中央区域被拉伸
        .resizable({
          slice: {
            top: $r('app.integer.imageresizable_product_discount_image_resizable_top'),
            right: $r('app.integer.imageresizable_product_discount_image_resizable_right'),
            bottom: $r('app.integer.imageresizable_product_discount_image_resizable_bottom'),
            left: $r('app.integer.imageresizable_product_discount_image_resizable_left')
          }
        })
      Text(discount)
        .fontSize($r('app.integer.imageresizable_product_discount_font_size'))
        .fontColor(Color.Red)
        // TODO: 知识点：通过监听文本组件的宽高，以及状态变量，动态设置背景图片的宽高
        // TODO: 性能知识点：onAreaChange为系统高频回调，每一帧都会执行，应避免在其中进行冗余和耗时的操作
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.discountTextWidth = newValue.width;
          this.discountTextHeight = newValue.height;
        })
        .padding({
          left: $r('app.integer.imageresizable_product_discount_padding'),
          right: $r('app.integer.imageresizable_product_discount_padding')
        })
    }
  }

  // 售价和销量展示，通过Text中内嵌2个Span实现富文本效果
  @Builder sale(price: number, sales: string) {
    Text() {
      Span(`¥${price}`)
        .fontColor(Color.Red)
      Span(`  ${CommonConstants.PRODUCT_SALE_TEXT}${sales}`)
        .fontSize($r('app.integer.imageresizable_product_sale_font_size'))
        .fontColor(Color.Gray)
    }
    .margin({ top: $r('app.integer.imageresizable_product_sale_margin_top') })
    .textOverflow({
      overflow: TextOverflow.Ellipsis
    })
    .maxLines(CommonConstants.PRODUCT_SALE_MAX_LINES)
    .ellipsisMode(EllipsisMode.END)
  }

  build() {
    Column() {
      Image($r(this.product.logo))
        .objectFit(ImageFit.Contain)
      Column() {
        Text(this.product.title)
          .margin({ bottom: $r('app.integer.imageresizable_product_title_margin_bottom') })
        this.discountCoupon(this.product.discount)
        this.sale(this.product.price, this.product.sales)
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width($r('app.string.imageresizable_product_width'))
    .border({
      radius: $r('app.integer.imageresizable_product_border_radius'),
    })
    .padding($r('app.integer.imageresizable_product_padding'))
    .margin($r('app.integer.imageresizable_product_margin'))
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .onClick(() => {
      promptAction.showToast({
        message: $r('app.string.imageresizable_product_click_toast')
      })
    })
  }
}