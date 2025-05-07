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


/**
 * 功能描述：
 * 1. 默认布局情况下，传入图片资源imageSource（类型为Resource[]），图片会按照个数进行相应的布局。
 * 2. 自定义布局情况下，传入图片资源imageSource（类型为Resource[]）和自定义列数col（类型为number）。
 * 3. 通过指定flexWidth（类型为string）参数，可调整整个图片布局的宽度。
 * 4. 通过指定modifier（类型需继承AttributeModifier<ImageAttribute>）参数，可以指定image的相关参数。
 *
 * 实现原理:
 * 1. 在自定义组件创建的回调里根据传入的col值决定布局方式，若参数col<=0为默认布局，若参数col>0为自定义布局（图片布局的列数=col），此部分逻辑会根据传入参数的不同走不同的逻辑。
 * 2. 布局主要是利用Flex的自适应能力及控制参数的变化来达到想要的布局效果。
 * 3. 为image组件指定特定的参数可实现AttributeModifier<ImageAttribute>的继承类，声明想要的属性并实现对应的方法。
 *
 * @param {AttributeModifier<ImageAttribute> | null} modifier - 图片扩展属性
 * @param {ResourceStr} imageSource - 图片数据资源
 * @param {()=>void} clickImageHandle - 图片点击处理逻辑
 * @param {number} col - 图片排列列数
 */

// 常量定义
const COLUMNS_0 = 0;
const COLUMNS_1 = 1;
const COLUMNS_2 = 2;
const COLUMNS_3 = 3;
const IMAGE_SET_SIZE_1 = 1;
const IMAGE_SET_SIZE_4 = 4;
const IMAGE_SET_SIZE_9 = 9;
const IMAGE_ASPECT_RATIO_0 = 0;


// 九宫格图片布局实现
@Component
export struct MultiImageGrid {
  // -------------------对外暴露变量-----------------------
  // 图片扩展属性（图片公用属性）
  @Prop modifier: AttributeModifier<ImageAttribute>;
  // 图片数据资源
  imageSource: ResourceStr[] = [];
  // 图片排列列数
  col: number = 0;
  // 图片点击处理逻辑
  clickImageHandle: (image: ResourceStr, imageIndex: number) => void = (image: ResourceStr, imageIndex: number) => {
  };
  // --------------------私有属性----------------------------
  // 图片排列视图宽度
  private flexWidth: string = '75%';
  // 布局行数
  private row: number = 0;
  // 图片间隔
  private imageSpacing: number = 3;
  // 图片宽度
  private imageWidth: string = '';
  // 指定图片的宽高比例
  private imageAspectRatio: number = 1;
  // 图片填充属性
  private imageFit: ImageFit = ImageFit.Fill;
  // 图片数量
  private arraySize: number = 0;

  aboutToAppear() {
    this.arraySize = this.imageSource.length;
    // 此时图片按默认方式布局，未传入col值时或当col值小于图片数量的时候走此逻辑
    if (this.col <= COLUMNS_0 || this.col < this.arraySize) {
      this.arraySize = Math.min(this.imageSource.length, IMAGE_SET_SIZE_9);
      this.row = Math.ceil(this.arraySize / COLUMNS_3);

      // 不同数量的图片对应不同的参数、布局
      if (this.arraySize === IMAGE_SET_SIZE_1) {
        this.col = COLUMNS_1;
        this.imageAspectRatio = IMAGE_ASPECT_RATIO_0;
        this.imageFit = ImageFit.Contain;
        this.imageWidth = '60%';
      } else if (this.arraySize === IMAGE_SET_SIZE_4) {
        this.col = COLUMNS_2;
        this.flexWidth = '50%';
        this.imageWidth = `calc((100% - ${this.imageSpacing}vp ) / 2)`;
      } else {
        this.col = COLUMNS_3;
        this.imageWidth = `calc((100% - ${this.imageSpacing * COLUMNS_2}vp ) / 3)`;
      }
    }
    // 传入col值时所走的逻辑，此时图片传入的col值进行布局
    else {
      this.row = Math.ceil(this.arraySize / this.col);
      this.imageWidth = `calc((100% - ${this.imageSpacing * (this.col - 1)}vp ) / ${this.col})`;
    }
  }

  build() {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
      // TODO：性能知识点：List、Grid、Swiper、以及WaterFlow组件，在超过2屏滚动的场景中，建议使用LazyForeach+组件复用提升滚动性能
      ForEach(this.imageSource.slice(0, this.arraySize), (item: ResourceStr, idx: number) => {
        Image(item)
          .autoResize(true)
          .objectFit(this.imageFit)
          .aspectRatio(this.imageAspectRatio)
          .width(this.imageWidth)
          .margin(
            {
              bottom: (idx + 1) > ((this.row - 1) * this.col) ? 0 : this.imageSpacing,
              right: (idx + 1) % this.col === 0 ? 0 : this.imageSpacing
            }
          )
          .attributeModifier(this.modifier)
          .onClick(() => {
            this.clickImageHandle(item, idx);
          })
      })
    }
    .width(this.flexWidth)
  }
}