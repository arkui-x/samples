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

import { PRODUCT_DATA } from '../mock/IconMock';
import { ProductDataModel } from '../model/IconModel';
import { ProductDataSource } from '../model/DataSource';
import { promptAction } from '@kit.ArkUI';
import { displaySync } from '@kit.ArkGraphics2D';
import { Animator, AnimatorResult } from '@kit.ArkUI';
import { PlatformTypeEnum, PlatformInfo } from 'utils'

const COLUMNSPACE: number = 5; // column各子组件间距
const ASPECT_RATIO: number = 1; // 图片的宽高比
const OFFSET: number = -4; // 价格控件偏移量
const COLUMNSGAP: number = 12; // WaterFlow组件纵向间距
const ROWSGAP: number = 12; // WaterFlow组件横向间距

@Component
export struct ProductList {
  private productData: ProductDataSource = new ProductDataSource();
  private displaySync: displaySync.DisplaySync | undefined = undefined;
  private animatorResult: AnimatorResult | undefined = undefined;
  private frame: number = 1;

  aboutToAppear() {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      // 创建DisplaySync对象
      this.displaySync = displaySync.create();
      // 设置期望帧率
      const range: ExpectedFrameRateRange = {
        expected: 120,
        min: 60,
        max: 120
      };
      this.displaySync.setExpectedFrameRateRange(range);
      // 添加帧回调
      this.displaySync.on("frame", () => {
        if (this.frame === 1) {
          this.productData.pushData(PRODUCT_DATA.slice(0, 4))
          this.frame += 1;
        } else if (this.frame === 2) {
          this.productData.pushData(PRODUCT_DATA.slice(4, PRODUCT_DATA.length));
          this.frame += 1;
          this.displaySync?.stop();
        }
      });
      // 开启帧回调监听
      this.displaySync.start();
    } else if (PlatformInfo.isArkUIX()) {
      this.animatorResult = Animator.create({
        duration: 200,
        easing: "ease",
        delay: 0,
        fill: "forwards",
        direction: "normal",
        iterations: 1,
        begin: 100,
        end: 200
      })
      this.animatorResult.setExpectedFrameRateRange({
        expected: 120,
        min: 60,
        max: 120
      })
      this.animatorResult.onFrame = (value: number) => {
        if (this.frame === 1) {
          this.productData.pushData(PRODUCT_DATA.slice(0, 4))
          this.frame += 1;
        } else if (this.frame === 2) {
          this.productData.pushData(PRODUCT_DATA.slice(4, PRODUCT_DATA.length));
          this.frame += 1;
          this.animatorResult?.cancel()
        }
      }
      // 开启帧回调监听
      this.animatorResult.play()
    }
  }

  aboutToDisappear(): void {
    // 页面销毁时需要停止帧回调
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      this.displaySync?.stop();
    } else if (PlatformInfo.isArkUIX()) {
      this.animatorResult?.cancel()
    }
  }

  build() {
    // TODO: 知识点：瀑布流容器，由“行”和“列”分割的单元格所组成，通过容器自身的排列规则，将不同大小的“项目”自上而下，如瀑布般紧密布局。
    WaterFlow() {
      LazyForEach(this.productData, (item: ProductDataModel) => {
        FlowItem() {
          ItemView({ item: item })
        }
      }, (item: ProductDataModel) => item.id.toString())
    }
    .id('water_flow_id')
    .nestedScroll({
      scrollForward: NestedScrollMode.PARENT_FIRST,
      scrollBackward: NestedScrollMode.SELF_FIRST
    })
    .columnsTemplate("1fr 1fr")
    .columnsGap(COLUMNSGAP)
    .rowsGap(ROWSGAP)
    .clip(false)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

@Reusable
@Component
struct ItemView {
  @Require item: ProductDataModel = new ProductDataModel(0, "", "", "", "");

  build() {
    Column({ space: COLUMNSPACE }) {
      Image(this.item.uri)
        .width($r("app.integer.component_stack_icon_view_image_width"))
        .aspectRatio(ASPECT_RATIO)
        .objectFit(ImageFit.Contain)
        .margin({ top: $r("app.integer.component_stack_water_flow_image_margin_top") })
        .alignSelf(ItemAlign.Center)
        .padding({ right: $r("app.integer.component_stack_icon_view_padding_right") })

      Text(this.item.title)
        .width('100%')
        .fontSize($r("app.integer.component_stack_water_flow_title_font_size"))
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)

      Text(this.item.price)
        .width('100%')
        .fontSize($r("app.integer.component_stack_water_flow_price_font_size"))
        .offset({ x: OFFSET })// 因为￥是中文字符，上面的是中文字符，占的宽度不一样，所以需要对齐，添加offset
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.component_stack_product_warning'))

      Text(this.item.insurance)
        .fontSize($r("app.integer.component_stack_water_flow_insurance_font_size"))
        .fontColor($r('app.color.component_stack_product_alert'))
        .borderColor($r('app.color.component_stack_product_alert'))
        .borderWidth($r("app.integer.component_stack_water_flow_insurance_border_width"))
        .borderRadius($r("app.integer.component_stack_water_flow_insurance_border_radius"))
        .padding({
          left: $r("app.integer.component_stack_water_flow_insurance_padding_horizontal"),
          right: $r("app.integer.component_stack_water_flow_insurance_padding_horizontal"),
          top: $r("app.integer.component_stack_water_flow_insurance_padding_vertical"),
          bottom: $r("app.integer.component_stack_water_flow_insurance_padding_vertical")
        })
        .margin({ top: $r("app.integer.component_stack_water_flow_insurance_margin_top") })
    }
    .alignItems(HorizontalAlign.Start)
    .padding({ left: $r("app.integer.component_stack_water_flow_column_padding_left") })
    .width('100%')
    .height($r("app.integer.component_stack_water_flow_column_height"))
    .backgroundColor(Color.White)
    .borderRadius($r("app.integer.component_stack_water_flow_column_border_radius"))
    .onClick(() => {
      promptAction.showToast({ message: $r('app.string.component_stack_other_function') });
    });
  }
}