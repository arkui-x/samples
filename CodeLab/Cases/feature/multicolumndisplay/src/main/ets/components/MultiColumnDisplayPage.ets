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

import { waterFlowData } from '../data/ProductData';
import { ProductInfo } from '../data/ProductDataFormat';
import { WaterFlowDataSource } from './WaterFlowDataSource';

/**
 * 功能描述：本示例中，多段不同列数混合布局的数据在瀑布流容器中可以正常显示
 *
 * 推荐场景：购物APP展示商品时使用
 *
 * 核心组件：
 * 1.WaterFlow
 * 2.LazyForEach
 *
 * 实现步骤：
 * 1.构造瀑布流中展示的所有数据
 * 2.配置瀑布流组件sections属性，设置数据在一列或者两列时的列数，列间距等属性
 * 3.使用WaterFlow组件展示数据
 */
@Component
export struct MultiColumnDisplayComponent {
  @State dataSource: WaterFlowDataSource = new WaterFlowDataSource(waterFlowData);
  // 瀑布流分组信息
  @State sections: WaterFlowSections = new WaterFlowSections();
  // 瀑布流数据个数
  dataCount: number = waterFlowData.length;
  // 双列时，图片较小的瀑布流子组件高度
  private shortDisplayHeight: number = 155;
  // 双列时，图片较大的瀑布流子组件高度
  private highDisplayHeight: number = 256;
  // 瀑布流滚动控制器
  private scroller: Scroller = new Scroller();
  // 瀑布流容器里的图片元素组件的复用id和type
  private imageFlowItemReuseId: string = 'onlyImage';
  // 瀑布流容器里的图片混合文字元素组件的复用id和type
  private reusableFlowItemReuseId: string = 'imageMixText';
  // 瀑布流容器里底部最后一个元素的type
  private bottomFlowItem: string = 'bottomImageMixText';
  // 分组的margin信息
  private sectionMargin: Margin = {
    left: 4,
    bottom: 15,
    right: 4
  }
  // 瀑布流是一列的时候，分组配置信息
  private oneColumnSection: SectionOptions = {
    // 分组中FlowItem数量
    itemsCount: 1,
    // 列数
    crossCount: 1,
    // 分组的列间距
    columnsGap: 5,
    // 分组的行间距
    rowsGap: 0,
    // 分组的margin
    margin: this.sectionMargin,
    // FlowItem的高度
    onGetItemMainSizeByIndex: (index: number) => {
      // 如果是最后一个item，高度赋值200
      if (index === this.dataCount - 1) {
        return 200;
      }
      return 160;
    }
  };
  // 瀑布流是两列的时候，分组配置信息
  private twoColumnSection: SectionOptions = {
    itemsCount: 8,
    crossCount: 2,
    columnsGap: 8,
    rowsGap: 0,
    onGetItemMainSizeByIndex: (index: number) => {
      // 瀑布流数据中最大的index是9的倍数，通过index除9的余数可以确定哪些item的高度较矮
      const newIndex = index % 9;
      // index除9的余数在以下数组中的的，高度较矮
      const longIndexArr = [1, 4, 5, 8];
      return longIndexArr.includes(newIndex) ? this.shortDisplayHeight : this.highDisplayHeight;
    }
  }

  aboutToAppear() {
    let sectionOptions: SectionOptions[] = [];
    // 通过商品数据类型初始化瀑布流分组信息
    for (let index = 0; index < waterFlowData.length; index++) {
      const productInfo: ProductInfo = waterFlowData[index];
      if (productInfo.type === this.imageFlowItemReuseId) {
        // 仅展示图片时瀑布流是一列
        sectionOptions.push(this.oneColumnSection);
      } else if(productInfo.type === this.bottomFlowItem){
        // 瀑布流最后一个元素是一列
        sectionOptions.push(this.oneColumnSection);
      } else if (productInfo.type === this.reusableFlowItemReuseId) {
        // 图片文字混合时瀑布流是两列
        sectionOptions.push(this.twoColumnSection);
        index += (this.twoColumnSection.itemsCount - 1);
      }
    }
    this.sections.splice(0, 0, sectionOptions);
  }

  /**
   * 瀑布流中底部的最后一个元素
   * @param listData 图片信息
   */
  @Builder
  bottomItemInWaterFlow(listData: ProductInfo) {
    Column() {
      Image(listData.imageSrc)
        .id(listData.id.toString())
        .width($r('app.string.water_flow_item_image_width'))
      Text($r('app.string.water_flow_bottom_title_text'))
        .height($r('app.string.water_flow_bottom_item_title_height'))
        .textAlign(TextAlign.Center)
        .fontSize($r('app.string.water_flow_bottom_item_title_font_size'))
        .margin({ top: $r('app.string.water_flow_bottom_item_text_margin_size') })
      Text($r('app.string.water_flow_bottom_describe_text'))
        .height($r('app.string.water_flow_bottom_item_describe_text_height'))
        .fontColor($r('app.color.water_flow_bottom_item_describe_text_font_color'))
        .fontSize($r('app.string.water_flow_bottom_item_describe_text_font_size'))
        .margin({ bottom: $r('app.string.water_flow_bottom_item_text_margin_size') })
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .borderRadius($r('app.string.water_flow_item_container_radius_size'))
  }

  build() {
    Column() {
      WaterFlow({ scroller: this.scroller, sections: this.sections }) {
        LazyForEach(this.dataSource, (item: ProductInfo) => {
          FlowItem() {
            // 通过type字段区分需要展示的ux
            if (item.type === this.reusableFlowItemReuseId) {
              ReusableFlowItem({ listData: item })
                .reuseId(this.reusableFlowItemReuseId)
            } else if (item.type === this.imageFlowItemReuseId) {
              ReusableImageItem({ listData: item })
                .reuseId(this.imageFlowItemReuseId)
            } else {
              this.bottomItemInWaterFlow(item);
            }
          }
          .width($r('app.string.water_flow_item_width'))
        }, (item: ProductInfo) => JSON.stringify(item))
      }
      .cachedCount(5)
      .width($r('app.string.water_flow_section_width'))
      .height($r('app.string.water_flow_section_height'))
      .padding({
        left: $r('app.string.water_flow_section_padding'),
        right: $r('app.string.water_flow_section_padding')
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .clip(false)
    }
    .width($r('app.string.water_flow_section_width'))
    .height($r('app.string.water_flow_section_height'))
    .clip(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

/**
 * 瀑布流容器里的图片元素
 * TODO:知识点：@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
 */
@Reusable
@Component
struct ReusableImageItem {
  @State listData: ProductInfo =
    new ProductInfo(1, '', '', '');

  // 从复用缓存中加入到组件树之前调用，可在此处更新组件的状态变量以展示正确的内容
  aboutToReuse(params: Record<string, ProductInfo>) {
    this.listData = params.listData as ProductInfo;
  }

  build() {
    Column() {
      Image(this.listData.imageSrc)
        .id(this.listData.id.toString())
        .width($r('app.string.water_flow_item_image_width'))
        .borderRadius($r('app.string.water_flow_item_container_radius_size'))
    }
  }
}

/**
 * 瀑布流容器里的图片+文字混合元素
 * TODO:知识点：@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
 */
@Reusable
@Component
struct ReusableFlowItem {
  @State listData: ProductInfo =
    new ProductInfo(1, '', '', '');

  // 从复用缓存中加入到组件树之前调用，可在此处更新组件的状态变量以展示正确的内容
  aboutToReuse(params: Record<string, ProductInfo>) {
    this.listData = params.listData as ProductInfo;
  }

  build() {
    Column() {
      Image(this.listData.imageSrc)
        .objectFit(ImageFit.Contain)
        .width($r('app.string.water_flow_item_image_width'))

      Text(this.listData.name)
        .height($r('app.string.water_flow_item_text_height'))
        .fontSize($r('app.string.water_flow_item_text_font_size'))
        .fontColor($r('app.color.water_flow_section_item_name_font_color'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.None })
        .margin({
          left: $r('app.string.water_flow_section_item_margin_left'),
          top: $r('app.string.water_flow_item_text_margin_size'),
          bottom: $r('app.string.water_flow_item_text_margin_size')
        })

      Text(this.listData.description)
        .height($r('app.string.water_flow_item_describe_text_height'))
        .fontSize($r('app.string.water_flow_item_describe_text_font_size'))
        .fontColor($r('app.color.water_flow_section_item_description_font_color'))
        .lineHeight($r('app.string.water_flow_item_describe_text_line_height'))
        .margin({
          left: $r('app.string.water_flow_section_item_margin_left'),
          bottom: $r('app.string.water_flow_item_text_margin_size')
        })
    }
    .width($r('app.string.water_flow_item_container_width'))
    .borderRadius($r('app.string.water_flow_item_container_radius_size'))
    .shadow(ShadowStyle.OUTER_DEFAULT_SM)
    .id(this.listData.id.toString())
    .alignItems(HorizontalAlign.Start)
    .margin({
      bottom: $r('app.string.water_flow_section_item_margin_bottom')
    })
  }
}



