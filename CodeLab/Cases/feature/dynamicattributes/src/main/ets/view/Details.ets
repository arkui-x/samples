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
import { BarModifier, ButtonModifier, CommodityText, ImageModifier, TextType } from '../common/AttributeModifier';
import { BarType, BottomBar, CommonText } from '../common/CommonText';
import { promptAction } from '@kit.ArkUI';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

const COLUMN_SPACE = 20; // column间隙
const TEXT_SIZE = 15; // 自定义组件中text大小

@AppRouter({ name: "dynamicattributes/Details" })
@Component
export struct Details {
  // TODO：知识点：实例化自定义的样式类
  @State rowModifier: BarModifier = new BarModifier();
  @State imageModifier: ImageModifier = new ImageModifier($r('app.string.dynamicattributes_max_size'), $r('app.string.dynamicattributes_image_proportion'));

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        // 商品图片
        Image($r('app.media.icon'))
          .attributeModifier(this.imageModifier)
        // 商品详情区
        ProductInfo()
      }
      .width($r('app.string.dynamicattributes_max_size'))
      .height($r('app.string.dynamicattributes_max_size'))

      // 底部购买区
      BottomBar({
        buttonModifier: new ButtonModifier(),
        barModifier: new BarModifier(),
        buttonName: $r('app.string.dynamicattributes_settlement'),
        barType: BarType.DETAILS
      })
    }
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}

@Component
struct ProductInfo {
  @State textOne: CommodityText = new CommodityText(TextType.TYPE_ONE, 30);
  @State textTwo: CommodityText = new CommodityText(TextType.TYPE_TWO, 20);
  @State textThree: CommodityText = new CommodityText(TextType.TYPE_Three, 20);
  @State textFour: CommodityText = new CommodityText(TextType.TYPE_FOUR, 15);

  build() {
    Row() {
      Column({ space: COLUMN_SPACE }) {
        Row() {
          Text($r('app.string.dynamicattributes_commodity_price'))// 动态设置组件样式
            .attributeModifier(this.textOne)
            .width($r('app.float.dynamicattributes_float_100'))
          Text($r('app.string.dynamicattributes_sold'))
            .attributeModifier(this.textThree)
            .fontSize($r('app.float.dynamicattributes_float_15'))
            .width($r('app.float.dynamicattributes_float_60'))
        }
        .width($r('app.string.dynamicattributes_max_size'))
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text($r('app.string.dynamicattributes_full_reduction'))
            .attributeModifier(this.textFour)
            .fontColor($r('app.color.dynamicattributes_red'))

          Button($r('app.string.dynamicattributes_coupon_collection'))
            .height($r('app.float.dynamicattributes_float_15'))
            .backgroundColor($r('app.color.dynamicattributes_red'))
            .onClick(() => {
              promptAction.showToast({ message: $r('app.string.dynamicattributes_only_show') });
            })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width($r('app.string.dynamicattributes_max_size'))

        Text($r('app.string.dynamicattributes_commodity_name'))
          .attributeModifier(this.textTwo)

        Text($r('app.string.dynamicattributes_commodity_model'))
          .attributeModifier(this.textThree)

        CommonText({ textFour: new CommodityText(TextType.TYPE_FOUR, TEXT_SIZE) })
      }
      .backgroundColor($r('app.color.dynamicattributes_white'))
      .padding($r('app.float.dynamicattributes_float_10'))
      .borderRadius($r('app.float.dynamicattributes_float_10'))
      .height($r('app.string.dynamicattributes_max_size'))
    }
    .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
    .padding($r('app.float.dynamicattributes_float_10'))
    .height($r('app.string.dynamicattributes_text_proportion'))
    .width($r('app.string.dynamicattributes_max_size'))
  }
}
