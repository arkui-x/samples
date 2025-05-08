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

import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { GoodsList } from './GoodsList';
import { DynamicsRouter } from 'routermodule';
import { PlatformInfo, PlatformTypeEnum } from 'utils';

/**
 * 实现步骤：
 * 1.首先构建一个类似商城界面，设计并实现包括Column、Flex、Row、Image、Text等常见组件集合。
 * 2.对于深色和浅色模式的适配方案，我们采取了多种策略：
 *     固定属性适配：对于部分组件的颜色属性，如背景色或字体颜色，直接设定固定色值或引用固定的资源文件。
 *     双资源目录适配：在resources目录下新增dark子目录，用于存放深色模式下的特定颜色配置（color.json文件）
 *                 和图片资源（media文件）。在深色模式下，系统会自动加载此目录中的颜色及图片资源，确保与浅色模式下的UI元素色彩差异性。
 *     利用系统分层参数：对于支持深浅模式切换的系统层级颜色资源，我们可以直接引用这些具有分层特性的参数，使得当用户切换设备主题时，相关组
 *                  件的颜色能根据系统当前颜色模式自动更新。
 *     监听当前颜色模式变化：通过注册AbilityStage.onConfigurationUpdate事件监听器，实时捕捉到设备深浅颜色模式的变化，并据此动态调整
 *                  UI布局结构或逻辑处理，以适应不同模式下的最佳视觉体验。
 */

const COLUM_SPACE: number = 10; // 各组件间的间隔
const IMAGE_ASPECT_RATIO: number = 1; // 图片的宽高比
const LAYOUT_WEIGHT: number = 1; // 自适应占满父容器Column剩余空间
const OPACITY: number = 0.6; // 字体设置透明度

/**
 * 根据不同的颜色模式来设置banner图
 */
function setBanner(currentMode: number): ResourceStr {
  if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
    return $r("app.media.fit_for_dark_mode_dark_mode_banner");
  } else {
    return $r("app.media.fit_for_dark_mode_light_mode_banner");
  }
}

@Preview
@Component
export struct FitForDarkModeComponent {
  @State banner: ResourceStr = '';
  // @StorageProp + @Watch 获取并监听当前颜色模式
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: number = 0;

  // @Watch回调函数，监听颜色模式刷新状态变量
  onColorModeChange(): void {
    this.banner = setBanner(this.currentMode);
  }

  // 在自定义组件生命周期aboutToAppear中，根据当前颜色模式刷新banner状态变量，切换不同的图片。
  aboutToAppear(): void {
    const applicationContext = getContext(this).getApplicationContext();
    applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    this.banner = setBanner(this.currentMode);
  }

  aboutToDisappear(): void {
    const applicationContext = getContext(this).getApplicationContext();
    applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
  }

  build() {
    Column() {
      Column({ space: COLUM_SPACE }) {

        Flex({ justifyContent: FlexAlign.SpaceBetween }) {
          Image($r("app.media.fit_for_dark_mode_logo"))
            .width($r("app.integer.fit_for_dark_mode_image_width"))
            .aspectRatio(IMAGE_ASPECT_RATIO)

          Image($r("app.media.fit_for_dark_mode_scan"))
            .width($r("app.integer.fit_for_dark_mode_image_width"))
            .aspectRatio(IMAGE_ASPECT_RATIO)
        }
        .width('100%')
        .height($r("app.integer.fit_for_dark_mode_flex_height"))
        .margin({ top: $r("app.integer.fit_for_dark_mode_flex_margin_top") })

        Row() {
          Image($r("app.media.fit_for_dark_mode_search"))
            .width($r("app.integer.fit_for_dark_mode_search_image_width"))
            .aspectRatio(IMAGE_ASPECT_RATIO)
            .margin({ left: $r("app.integer.fit_for_dark_mode_search_image_margin_left") })
          // TODO: 知识点：UI组件颜色属性是固定颜色值，深浅模式颜色不变。
          // 将Text直接设置成'#000000'固定色值
          Text($r("app.string.fit_for_dark_mode_search_text"))
            .opacity(OPACITY)
            .fontColor($r("app.color.fit_for_dark_mode_black_font_color"))
            .margin({ left: $r("app.integer.fit_for_dark_mode_text_margin_left") })
        }
        .width('100%')
        .height($r("app.integer.fit_for_dark_mode_row_height"))
        .backgroundColor($r("app.color.fit_for_dark_mode_search_bg_color"))
        .borderRadius($r("app.integer.fit_for_dark_mode_row_border_radius"))
      }
      .padding({
        left: $r("app.integer.fit_for_dark_mode_column_padding"),
        right: $r("app.integer.fit_for_dark_mode_column_padding")
      })
      // TODO: 知识点：在resources目录下新增dark/element目录，创建深色模式color.json文件，设置深色模式UI组件颜色。（注意事项:颜色name必须相同）
      // 用资源ID方式设置Column背景色。（浅色模式色值为'#FA5A3C'、深色模式色值为'#000000'）
      .backgroundColor($r("app.color.fit_for_dark_mode_column_bg_color"))
      .width('100%')
      .height($r("app.integer.fit_for_dark_mode_column_height"))

      Scroll() {
        Column() {
          Column() {
            // TODO: 知识点：在深浅模式下，UI布局或逻辑存在差异，采用AbilityStage.onConfigurationUpdate监听实现
            Image(this.banner)
              .width("100%")
              .height($r("app.integer.fit_for_dark_mode_banner_height"))
              .borderRadius($r("app.integer.fit_for_dark_mode_banner_border_radius"))

            Text($r("app.string.fit_for_dark_mode_new_product_text"))
              .fontColor($r("app.color.fit_for_dark_mode_white_font_color"))
              .fontSize($r("app.integer.fit_for_dark_mode_new_goods_font"))
              .fontWeight(FontWeight.Bold)
              .height($r("app.integer.fit_for_dark_mode_new_goods_height"))
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: $r("app.integer.fit_for_dark_mode_ew_goods_padding_top") })
          }
          .backgroundColor($r("app.color.fit_for_dark_mode_column_bg_color"))
          .padding({
            left: $r("app.integer.fit_for_dark_mode_column_padding"),
            right: $r("app.integer.fit_for_dark_mode_column_padding")
          })
          .borderRadius({
            bottomLeft: $r("app.integer.fit_for_dark_mode_column_border_radius"),
            bottomRight: $r("app.integer.fit_for_dark_mode_column_border_radius")
          })

          // 引用产品列表组件
          GoodsList()
        }
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .backgroundColor($r("app.color.fit_for_dark_mode_list_bg_color"))
      .width('100%')
      .height('100%')
      .layoutWeight(LAYOUT_WEIGHT)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .backgroundColor($r("app.color.fit_for_dark_mode_page_bg_color"))
    .width('100%')
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
