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

import common from '@ohos.app.ability.common';
import { PendantData } from '../model/MockData';
import { PendantType } from '../model/DataType';
import { PendantDataSource } from '../model/DataSource';

/**
 * 功能描述: 本实例主要通过BlendMode属性来实现挂件和图片的混合，通过更改不同的混合参数，能够展示不同的混合效果。
 *
 * 推荐场景: 头像编辑场景
 *
 * 核心组件:
 * 1. Image组件
 *
 * 实现步骤:
 * 1. 挂件Image组件绑定BlendMode属性，属性值初始化为BlendMode.NONE。
 * 2. 点击挂件区域，通过currentBlendMode变量来改变混合模式。
 */
@Component
export struct BlendModeViewComponent {
  @Builder
  titleBar() {
    Text($r('app.string.blend_mode_avatar_pendant'))
      .fontSize($r('app.integer.blend_mode_title_font_size'))
      .width($r('app.string.blend_mode_container_size'))
      .textAlign(TextAlign.Center)
  }

  build() {
    Column() {
      // 标题
      this.titleBar()
      PendantDisplay()
    }.width($r('app.string.blend_mode_container_size'))
    .height($r('app.string.blend_mode_container_size'))
    .backgroundColor(Color.White)
    .padding($r('app.string.ohos_id_card_padding_start'))
  }
}


@Component
struct PendantDisplay {
  @State pendantData: PendantDataSource = new PendantDataSource();
  @State currentUserPendant: ResourceStr = '';
  @State currentBlendMode: BlendMode = BlendMode.NONE;
  @State currentIndex: number = 0;
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    this.pendantData.pushData(PendantData);
  }

  /**
   * Resource转化为string函数
   * @param resource
   * @returns string
   */
  getResourceString(resourceMsg: Resource): string {
    return this.context.resourceManager.getStringSync(resourceMsg.id);
  }

  /**
   * 自定义组件
   * @param item 挂件数据
   * @param index 下标
   */
  @Builder
  pendantBuilder(item: PendantType, index: number) {
    Column() {
      Column() {
        Image(item.pendantImage)
          .width($r('app.integer.blend_mode_image_size'))
          .height($r('app.integer.blend_mode_image_size'))
          .borderRadius($r('app.integer.blend_mode_image_border_radius'))
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.currentIndex === index ? $r('app.color.blend_mode_pendant_area_selected_color')
        : $r('app.color.blend_mode_pendant_area_default_color'))
      .height($r('app.integer.blend_mode_pendant_area_height_size'))
      .width($r('app.string.blend_mode_container_size'))

      Text(`${this.getResourceString($r('app.string.blend_mode_pendant'))}${index}`)
        .width($r('app.string.blend_mode_container_size'))
        .fontSize($r('app.integer.blend_mode_pendant_name_font_size'))
        .textAlign(TextAlign.Center)
        .margin({ top: $r('app.string.ohos_id_elements_margin_vertical_m') })

    }
  }

  build() {
    Column() {
      Column() {
        Image(this.currentUserPendant)
          .width($r('app.integer.blend_mode_avatar_image_size'))
          .height($r('app.integer.blend_mode_avatar_image_size'))
          .borderRadius($r('app.integer.blend_mode_avatar_image_border_radius'))
          .id('pendant_' + this.currentIndex)
          .blendMode(this.currentBlendMode, BlendApplyType.OFFSCREEN) // TODO:知识点:将当前控件的内容（包含子节点内容）与下方画布（可能为离屏画布）已有内容进行混合
      }
      .width($r('app.integer.blend_mode_avatar_image_size'))
      .height($r('app.integer.blend_mode_avatar_image_size'))
      .borderRadius($r('app.integer.blend_mode_avatar_image_border_radius'))
      .margin($r('app.integer.blend_mode_avatar_area_margin_size'))
      .backgroundImage($r("app.media.blend_mode_image_6"))
      .backgroundImageSize({
        width: $r('app.integer.blend_mode_avatar_image_size'),
        height: $r('app.integer.blend_mode_avatar_image_size')
      })
      .justifyContent(FlexAlign.Center)

      GridRow({
        columns: 9, // 将GridRow所占区域宽度平分为9份
        gutter: { x: $r('app.integer.blend_mode_grid_space'), y: $r('app.integer.blend_mode_grid_space') }
      }) {
        // 性能知识点:动态加载数据或者数据量比较多的情况下，建议使用LazyForEach，参考链接https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V1/arkts-rendering-control-lazyforeach-0000001580345086-V1
        LazyForEach(this.pendantData, (item: PendantType, index: number) => {
          // columns/span计算列数
          GridCol({ span: { xs: 3, sm: 3, md: 2, lg: 2 } }) {
            this.pendantBuilder(item, index)
          }
          .onClick(() => {
            this.currentIndex = index;
            if (this.currentIndex === 0) {
              this.currentBlendMode = BlendMode.DST;
              this.currentUserPendant = '';
              return;
            }
            // TODO:知识点:点击切换混合模式
            this.currentUserPendant = item.pendantImage;
            this.currentBlendMode = item.blendMode;
          })
        }, (item: PendantType) => JSON.stringify(item))
      }
    }
  }
}