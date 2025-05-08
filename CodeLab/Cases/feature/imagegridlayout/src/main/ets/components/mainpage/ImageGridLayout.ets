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

import { MultiImageGrid } from '../../utils/MultiGrid';
import { promptAction } from '@kit.ArkUI';
import { ImageModifier } from '../../model/ImageModifier';

/**
 * 功能描述: 本示例介绍使用Flex组件实现图片在不同个数情况下的布局效果(默认布局和自定义布局)。
 *
 * 推荐场景: 社交类应用
 *
 * 核心组件:
 * 1. MultiGrid - 图片布局视图
 *
 * 实现步骤：
 * 1. 初始化数据。
 * private imageArray1: Resource[] = [$r("app.media.b")];
   private imageArray3: Resource[] = [$r("app.media.a"), $r("app.media.b"), $r("app.media.c")];
   private imageArray4: Resource[] = [$r("app.media.a"), $r("app.media.b"), $r("app.media.c"), $r("app.media.d")];
   private imageArray8: Resource[] = [$r("app.media.a"), $r("app.media.b"), $r("app.media.c"),
   $r("app.media.d"), $r("app.media.e"), $r("app.media.f"),$r("app.media.g"), $r("app.media.h")];
   private imageArray9: Resource[] =[$r("app.media.a"), $r("app.media.b"), $r("app.media.c"), $r("app.media.d"),
   $r("app.media.e"), $r("app.media.f"),$r("app.media.g"), $r("app.media.h"), $r("app.media.i")];
   private imageSet: Resource[][] =[this.imageArray1, this.imageArray3, this.imageArray4, this.imageArray8, this.imageArray9];
   2. 构建图片布局视图。开发者可以自定义图片的公用属性，也可以通过传递col值，来自定义图片排列的列数和行数（col值是可选参数）。
   MultiGrid({
     modifier: this.imageModifier,
     imageSource: item,
     clickImageHandle: (image: ResourceStr) => {
     this.clickImageHandle(image)
     }
   })
 */
@Component
export struct ImageGridLayoutComponent {
  // 不同图片数量的图片集合
  private imageArray1: Resource[] = [$r("app.media.b")];
  private imageArray3: Resource[] = [$r("app.media.a"), $r("app.media.b"), $r("app.media.c")];
  private imageArray4: Resource[] = [$r("app.media.a"), $r("app.media.b"), $r("app.media.c"), $r("app.media.d")];
  private imageArray8: Resource[] =
    [$r("app.media.a"), $r("app.media.b"), $r("app.media.c"), $r("app.media.d"), $r("app.media.e"), $r("app.media.f"),
      $r("app.media.g"), $r("app.media.h")];
  private imageArray9: Resource[] =
    [$r("app.media.a"), $r("app.media.b"), $r("app.media.c"), $r("app.media.d"), $r("app.media.e"), $r("app.media.f"),
      $r("app.media.g"), $r("app.media.h"), $r("app.media.i")];
  private imageSet: Resource[][] =
    [this.imageArray1, this.imageArray3, this.imageArray4, this.imageArray8, this.imageArray9];
  private textArray: string[] = ['一张图片场景:', '三张图片场景:', '四张图片场景:', '八张图片场景:', '九张图片场景:'];
  // TODO：知识点：自定义组件中实现属性扩展
  private imageModifier: ImageModifier = new ImageModifier().objectFit(ImageFit.Fill)
    .renderMode(ImageRenderMode.Original)

  clickImageHandle(image: ResourceStr) {
    promptAction.showToast({ message: $r('app.string.imagegridlayout_image_toast') });
  }

  build() {
    Scroll() {
      Column() {
        // TODO：性能知识点：List、Grid、Swiper、以及WaterFlow组件，在超过2屏滚动的场景中，建议使用LazyForeach+组件复用提升滚动性能
        ForEach(this.imageSet, (itemArr: ResourceStr[], index: number) => {
          Text(this.textArray[index])
            .margin({
              top: $r('app.float.imagegridlayout_text_margin'),
              bottom: $r('app.float.imagegridlayout_text_margin')
            })
          /**
           * 图片布局视图
           * @param {ImageModifier} modifier - 图片扩展属性（图片公用属性）
           * @param {ResourceStr[]} imageSource - 图片数据
           * @param {void} clickImageHandle - 点击图片处理逻辑
           * @param {number} [col] - 布局列数
           */
          MultiImageGrid({
            modifier: this.imageModifier,
            imageSource: itemArr,
            clickImageHandle: (image: ResourceStr, imageIndex: number) => {
              this.clickImageHandle(image)
            }
          })
          Divider().margin({ top: $r('app.float.imagegridlayout_divider_margin') })
        })
      }.alignItems(HorizontalAlign.Start)
    }
    .padding($r('app.float.imagegridlayout_padding_20'))
    .width($r('app.string.imagegridlayout_width_100'))
    .height($r('app.string.imagegridlayout_height_100'))
  }
}