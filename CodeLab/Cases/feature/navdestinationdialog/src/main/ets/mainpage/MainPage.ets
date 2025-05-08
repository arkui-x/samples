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

import { DynamicsRouter, AppRouter } from 'routermodule';
import { showCaseOnly } from '../common/Utils';
import Consts from '../common/Constants';
import { logger } from 'utils';

/**
 * 实现思路：
 * 1. 常见商品内容Navigation主页面。
 * 2. 添加评论区NavDestination的Dialog类型页面，并添加进页面路由栈中。
 * 3. 关联主页面和弹窗页面的尺寸关联，并添加相应的手势。
 */

const TAG: string = Consts.MAIN_PAGE_TAG;

@AppRouter({ name: "navdestinationdialog/NavDestinationDialog" })
@Component
export struct NavDestinationDialog {
  @LocalStorageLink('ndDialogHeight') ndDialogHeight: number = 0;
  @LocalStorageLink('ndPageHeight') ndPageHeight: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageProp('statusHeight') statusHeight: number = 0;
  @StorageProp('bottomHeight') bottomHeight: number = 0;

  aboutToAppear() {
    // 计算窗口高度
    this.ndPageHeight = px2vp(this.screenHeight - this.statusHeight) - Consts.TOP_TITLE_HEIGHT;
    logger.debug(TAG, `window's height: ${this.ndPageHeight}vp`);
  }

  build() {
    Column() {
      this.goodsItem()
    }
    .width($r('app.string.navdialog_full_size'))
    .height($r('app.string.navdialog_full_size'))
    .backgroundColor(Color.Gray)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  goodsItem() {
    Column() {
      Image($rawfile('ad.jpg'))
        .width($r('app.string.navdialog_full_size'))
        .height($r('app.string.navdialog_comment_ad_image_height'))
        .objectFit(ImageFit.Contain)

      // 底部栏
      this.shopBar(() => {
        animateTo({ duration: Consts.COMMENT_DIALOG_TRANS_DURATION, curve: Curve.Ease }, () => {
          this.ndDialogHeight = this.ndPageHeight * Consts.COMMENT_DIALOG_SCALE;
        })

        DynamicsRouter.pushUri("navdestinationdialog/CommentDialog") // TODO: 新路由没有push方法
        logger.info(TAG, `open dialog`);
      })
    }
    .width($r('app.string.navdialog_full_size'))
    .height(this.ndPageHeight - Consts.SHOP_BAR_HEIGHT)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  shopBar(callback: () => void) {
    Row({ space: Consts.SHOP_BAR_SPACE }) {
      Image($r("app.media.nd_shop_icon"))
        .width(Consts.SHOP_ICON_SIZE)
        .height(Consts.SHOP_ICON_SIZE)
        .borderRadius(Consts.SHOP_ICON_SIZE)
        .backgroundColor(Color.White)
        .objectFit(ImageFit.Cover)

      Column() {
        Text($r('app.string.navdialog_example_shop_name'))
          .fontColor(Color.White)
          .fontSize($r('app.integer.navdialog_shopbar_shop_name_size'))
        Text($r('app.string.navdialog_shopbar_welcome_prompt'))
          .fontSize($r('app.integer.navdialog_shopbar_welcome_prompt_font_size'))
          .fontColor($r('app.color.navdialog_shop_bar_welcome_prompt'))
      }
      .alignItems(HorizontalAlign.Start)
      .width($r('app.string.navdialog_shopbar_shop_desc_width'))
      .onClick(() => {
        showCaseOnly();
      })

      Image($r("app.media.nd_star"))
        .width(Consts.SHOP_BAR_ICON_SIZE)
        .height(Consts.SHOP_BAR_ICON_SIZE)
        .onClick(() => {
          showCaseOnly();
        })
      Image($r("app.media.nd_comment"))
        .width(Consts.SHOP_BAR_ICON_SIZE)
        .height(Consts.SHOP_BAR_ICON_SIZE)
        .onClick(callback)

      // 购物车和购买按钮
      Row() {
        Row() {
          Image($r("app.media.nd_shopping_cart"))
            .width($r('app.integer.navdialog_shopbar_cart_img_size'))
            .height($r('app.integer.navdialog_shopbar_cart_img_size'))
        }
        .backgroundColor($r('app.color.navdialog_shop_bar_cart_bg'))
        .borderRadius({
          topLeft: $r('app.integer.navdialog_shopbar_cart_img_radius'),
          bottomLeft: $r('app.integer.navdialog_shopbar_cart_img_radius')
        })
        .height($r('app.string.navdialog_full_size'))
        .padding({
          left: $r('app.integer.navdialog_comment_padding'),
          right: $r('app.integer.navdialog_comment_padding')
        })

        Row() {
          Text($r('app.string.navdialog_shopbar_shop_purchase_label'))
            .fontSize($r('app.integer.navdialog_shopbar_purchase_font_size'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
        .padding({
          left: $r('app.integer.navdialog_comment_padding'),
          right: $r('app.integer.navdialog_comment_padding')
        })
        .backgroundColor($r('app.color.navdialog_shop_bar_purchase_bg'))
        .borderRadius({
          topRight: $r('app.integer.navdialog_shopbar_purchase_radius'),
          bottomRight: $r('app.integer.navdialog_shopbar_purchase_radius')
        })
        .height($r('app.string.navdialog_full_size'))
      }
      .width($r('app.integer.navdialog_shopbar_buy_button_width'))
      .height($r('app.integer.navdialog_shopbar_buy_button_height'))
      .onClick(() => {
        showCaseOnly();
      })
    }
    .height(Consts.SHOP_BAR_HEIGHT)
    .width($r('app.string.navdialog_full_size'))
    .backgroundColor($r('app.color.navdialog_shop_bar_bg'))
    .padding({
      left: $r('app.integer.navdialog_comment_padding'),
      right: $r('app.integer.navdialog_comment_padding')
    })
    .alignItems(VerticalAlign.Center)
    .margin({ bottom: this.bottomHeight + 'px' })
  }
}
