/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SiteItem, TimeList } from "../model/SiteItemModel";
import { SiteListDataSource } from "../model/SiteListDataSource";
import { promptAction } from "@kit.ArkUI";

const CACHED_COUNT = 3; // 数据缓存
const FRICTION = 0.6; // 摩擦系数
const MAX_LINES = 1; // 最大行数

/**
 * 功能描述：
 * 1.对列表数据进行渲染。
 *
 * 实现原理：
 * 1.使用LazyForEach渲染卡片信息，使用ForEach渲染每个卡片里面小列表。
 *
 * @param {SiteListDataSource} siteList - 场地信息集合（必需）
 * @param {Array<string>} changData - 选择的数据的数组（必需）
 */
@Component
export struct InfoCard {
  @Link siteList: SiteListDataSource; // 场地信息集合
  @Link changData: Array<string>; // 选择的数据的数组

  build() {
    Column() {
      List() {
        LazyForEach(this.siteList, (site: SiteItem) => {
          ListItem() {
            Column() {
              this.productDetails(site)
              this.productList(site.siteBale)
            }
            .padding({ bottom: $r('app.integer.multiple_screening_info_card_list_padding') })
            .borderRadius($r('app.integer.multiple_screening_info_card_list_border_radius'))
            .width($r('app.string.multiple_screening_info_card_list_width'))
            .backgroundColor(Color.White)
            .margin($r('app.integer.multiple_screening_info_card_list_margin'))
            .onClick(() => {
              // 调用Toast显示提示:此样式仅为案例展示
              promptAction.showToast({ message: $r("app.string.multiple_screening_toast_tips") });
            })
          }
        }, (item: SiteItem, index: number) => {
          return index + '__' + JSON.stringify(item);
        })
      }
      .cachedCount(CACHED_COUNT) // TODO：知识点：LazyForEach懒加载可以通过设置cachedCount来指定缓存数量，在设置cachedCount后，除屏幕内显示的ListItem组件外，还会预先将屏幕可视区外指定数量的列表项数据缓存。
      .listDirection(Axis.Vertical) // 排列方向
      .scrollBar(BarState.Off)
      .friction(FRICTION)
      .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
      .width($r('app.string.multiple_screening_all_percentage'))
      .id('infoCard')
    }
  }

  @Builder
  productDetails(site: SiteItem) {
    Row() {
      Column() {
        Row() {
          Image(site.siteImage)
            .width($r('app.integer.multiple_screening_info_card_site_image_width'))
            .height($r('app.integer.multiple_screening_info_card_site_image_width'))
            .margin({ right: $r('app.integer.multiple_screening_info_card_site_image_margin') })
          Column() {
            Text(site.siteName)
              .fontSize($r('app.integer.multiple_screening_info_card_site_name_text'))
              .fontWeight(FontWeight.Bold)
            Text(site.siteAddress)
              .fontSize($r('app.integer.multiple_screening_info_card_site_address_text'))
              .margin({
                top: $r('app.integer.multiple_screening_info_card_site_address_margin'),
                bottom: $r('app.integer.multiple_screening_info_card_site_address_margin')
              })
              .fontColor($r('app.color.multiple_screening_info_card_site_address_font'))
              .width($r('app.string.multiple_screening_info_card_site_address_width'))
              .maxLines(MAX_LINES)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Text(site.siteDiscount)
              .fontSize($r('app.integer.multiple_screening_info_card_site_discount_font'))
              .padding($r('app.integer.multiple_screening_info_card_site_discount_padding'))
              .fontColor($r('app.color.multiple_screening_info_card_site_discount_color'))
              .border({
                color: $r('app.color.multiple_screening_info_card_site_discount_color'),
                width: $r('app.integer.multiple_screening_info_card_site_discount_border_width'),
                radius: $r('app.integer.multiple_screening_info_card_site_discount_border_radius')
              })
          }
          .width($r('app.string.multiple_screening_info_card_product_details_row'))
          .alignItems(HorizontalAlign.Start)
        }
        .width($r('app.string.multiple_screening_info_card_product_details_row'))
      }

      Image($r('app.media.multiple_screening_ic_public_gps'))
        .width($r('app.integer.multiple_screening_info_card_product_details_image_width'))
        .height($r('app.integer.multiple_screening_info_card_product_details_image_width'))
    }
    .justifyContent(FlexAlign.SpaceAround)

    .border({
      width: { bottom: $r('app.integer.multiple_screening_info_card_product_details_border_width') },
      color: $r('app.color.multiple_screening_info_card_site_address_font')
    })
    .padding({
      top: $r('app.integer.multiple_screening_info_card_product_details_padding_top'),
      bottom: $r('app.integer.multiple_screening_info_card_product_details_padding_bottom')
    })
  }

  @Builder
  productList(item: Array<TimeList>) {
    ForEach(item, (is: TimeList) => {
      Row() {
        Row() {
          Text(is.time)
            .fontSize($r('app.integer.multiple_screening_info_card_site_discount_font'))
            .padding($r('app.integer.multiple_screening_info_card_site_discount_padding'))
            .fontColor($r('app.color.multiple_screening_info_card_site_discount_color'))
            .border({
              color: $r('app.color.multiple_screening_info_card_site_discount_color'),
              width: $r('app.integer.multiple_screening_info_card_site_discount_border_width'),
              radius: $r('app.integer.multiple_screening_info_card_site_discount_border_radius')
            })
          Text(is.name)
            .fontSize($r('app.integer.multiple_screening_info_card_site_discount_font'))
            .fontColor($r('app.color.multiple_screening_info_card_product_list_text'))
            .margin({ left: $r('app.integer.multiple_screening_info_card_product_list_margin_left') })
        }
        .width($r('app.string.multiple_screening_info_card_product_list_row_width'))

        Text(is.price)
          .fontSize($r('app.integer.multiple_screening_info_card_site_discount_font'))
          .fontColor($r('app.color.multiple_screening_info_card_site_discount_color'))
          .width($r('app.string.multiple_screening_info_card_product_list_price_width'))
      }
      .padding({ top: $r('app.integer.multiple_screening_info_card_product_list_margin_left') })
      .justifyContent(FlexAlign.SpaceBetween)
    })
  }
}