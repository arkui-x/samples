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

import { MyDataSource } from '../common/LazyForEach';
import {
  BarModifier,
  ButtonModifier,
  CheckboxModifier,
  CommodityText,
  ImageModifier,
  TextType
} from '../common/AttributeModifier';
import { BottomBar, ImageText } from '../common/CommonText';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

/*
 * 实现步骤：
 * 一、跨文件样式复用
 * 1.提供方创建AttributeModifier接口的实现类。
 * 2.使用方创建提供方的AttributeModifier实现类实例，并作为系统组件attributeModifier属性方法的参数传入
 * 二、跨文件组件复用
 * 1.提供方在公共组件库中创建公用的自定义组件，该组件支持外部传入attributeModifier属性。
 * 2.使用方分别实现Image组件和Text组件的AttributeModifier接口实现类。
 * 3.使用方创建Image组件和Text组件的AttributeModifier接口实现类实例，并作为提供方自定义组件CustomImageText的入参传入。
 * */
@AppRouter({ name: "dynamicattributes/ShoppingCart" })
@Component
export struct ShoppingCart {
  private data: MyDataSource = new MyDataSource();

  aboutToAppear() {
    for (let i = 1; i <= 20; i++) {
      this.data.pushData(`商品 ${i}`);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Text($r('app.string.dynamicattributes_shopping_cart'))
          .fontSize($r('app.float.dynamicattributes_float_20'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_counter_title_font_color'))
          .width($r('app.string.dynamicattributes_max_size'))
          .height($r('app.float.dynamicattributes_float_50'))
          .padding({ left: $r('app.float.dynamicattributes_float_20') })
          .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
          .align(Alignment.Bottom)
          .border({
            width: { top: $r('app.float.dynamicattributes_float_1') },
            color: { top: $r('sys.color.ohos_id_color_component_normal') },
          })

        List() {
          // TODO：知识点：数据懒加载
          LazyForEach(this.data, (item: string) => {
            ListItem() {
              ShoppingInfo({ item: item })
            }
          }, (item: string) => item)
        }
        .backgroundColor($r('sys.color.ohos_id_color_component_normal'))
        .height($r('app.string.dynamicattributes_list_height'))
        .padding({ bottom: $r('app.float.dynamicattributes_float_60') })
      }

      BottomBar({
        buttonModifier: new ButtonModifier(),
        barModifier: new BarModifier(),
        buttonName: $r('app.string.dynamicattributes_settlement')
      })
    }
    .height('100%')
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
struct ShoppingInfo {
  // TODO：知识点：使用方创建提供方的AttributeModifier实现类实例
  @Prop item: string
  @State textOne: CommodityText = new CommodityText(TextType.TYPE_ONE, 15);
  @State textTwo: CommodityText = new CommodityText(TextType.TYPE_TWO, 17);
  @State textThree: CommodityText = new CommodityText(TextType.TYPE_Three, 15);
  @State imageModifier: ImageModifier = new ImageModifier(100, 100);
  @State checkboxModifier: CheckboxModifier = new CheckboxModifier();

  build() {
    Column() {
      // 店铺信息
      Row() {
        Checkbox()
          .attributeModifier(this.checkboxModifier)

        Row()
          .borderRadius($r('app.float.dynamicattributes_float_5'))
          .width($r('app.float.dynamicattributes_float_20'))
          .height($r('app.float.dynamicattributes_float_20'))
          .backgroundColor($r('app.color.dynamicattributes_iconColor'))
          .margin({ right: $r('app.float.dynamicattributes_float_5') })
        Text($r('app.string.dynamicattributes_store_name'))
          .attributeModifier(this.textOne)
          .fontColor($r('sys.color.ohos_id_counter_title_font_color'))
      }
      .width(($r('app.string.dynamicattributes_max_size')))
      .height($r('app.float.dynamicattributes_float_20'))

      // 商品信息
      // TODO：知识点 AttributeModifier实例作为提供方自定义组件ImageText的入参传入。
      ImageText({
        item: this.item,
        textOne: this.textOne,
        textTwo: this.textTwo,
        textThree: this.textThree,
        imageModifier: this.imageModifier,
        imageSrc: $r('app.media.icon'),
        checkboxModifier: this.checkboxModifier,
        textOneContent: $r('app.string.dynamicattributes_commodity_price'),
        textTwoContent: $r('app.string.dynamicattributes_commodity_name'),
        textThreeContent: $r('app.string.dynamicattributes_commodity_model')
      })
        .onClick(() => {
          // 动态路由跳转
          DynamicsRouter.pushUri("dynamicattributes/Details");
        })
    }
    .padding($r('app.float.dynamicattributes_float_15'))
    .margin({
      top: $r('app.float.dynamicattributes_float_5'),
      bottom: $r('app.float.dynamicattributes_float_5'),
      right: $r('app.float.dynamicattributes_float_10'),
      left: $r('app.float.dynamicattributes_float_10')
    })
    .height($r('app.float.dynamicattributes_float_160'))
    .backgroundColor($r('app.color.dynamicattributes_white'))
    .borderRadius($r('app.float.dynamicattributes_float_20'))
  }
}

