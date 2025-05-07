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

import { display } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { logger, PlatformInfo, PlatformTypeEnum } from 'utils';
import Constants from '../common/Constants';
import CardComponent from './CardComponent';
import { CardInfo, CardsSource } from '../model/CardModel';

const TAG: string = '[CardSwiper]:';

/**
 * 功能描述：
 * 1. 卡片组件滚动切换，展示缩略图缩略图，两侧展示偏移量为 swiperMargin 的上一页和下一页的缩略图(缩放为原始缩略图的80%)
 * 2. 卡片滑动时组件跟手对应的图片缩放，滑入的图片放大至缩略图的原始大小，滑出的图片缩小至原始大小的80%
 * 3. 卡片滑动手指释放时根据 index 变化，展示对应 index 的子组件(图片)
 * 4. 边缘渐变开启时，滑动边缘为渐变白色
 * 5. 背景渐变开启时，背景色为图片主题渐变色
 *
 * 实现原理：
 * 1. 卡片基于Swiper组件实现容器视图居中完全展示，两边等长露出，并且跟手滑动缩放效果
 * 2. 通过onGestureSwiper、onAnimationStart、onChange回调实现滑动跟手缩放实现
 * 3. 共享元素转场结合全屏模态实现图片的查看
 * 4. 在Swiper组件上通过overlay加一层渐变遮罩，回调onChange在Swiper组件index变化时更新遮罩色，实现边缘渐变效果
 * 5. 在Swiper组件的同Stack下做一层底层的叠底，回调onAnimationStart时更新背景色，实现主题渐变效果
 *
 * @param {CardInfo[]} initCardsList - 传入初始化数据列表
 * 数据格式为: { src: ${图片路径}, width: ${展示宽度}, height: ${展示高度} }
 * 示例: { src: $r('app.media.panda'), width: this.CARD_UNIT_LENGTH, height: this.CARD_UNIT_LENGTH }
 * @param {boolean} [isEdgeFading] - 边缘渐变开关
 * @param {boolean} [isBackgroundColorChange] - 背景色跟随主题色渐变开关
 */
@Component
export struct CardSwiperComponent {
  // 初始化数据列表 (可以传入本地图片资源或者网络图片地址)
  initCardsList: CardInfo[] = [];
  // 是否开启边缘渐变
  isEdgeFading: boolean = true;
  // 是否开启背景跟随主题色转换
  isBackgroundColorChange: boolean = true;
  // 是否开启预览大图
  isShowPreviewImage: boolean = true;
  // 边缘渐变起始和终止颜色
  @State private linearGradientBeginColor: string = Constants.BEGIN_COLOR;
  @State private linearGradientEndColor: string = Constants.END_COLOR;
  // 初始背景色
  @State private bgColor: string = Constants.BACKGROUND_END_COLOR;
  // 背景叠底位置
  private backgroundMaskZIndex: number = -1;
  // 卡片数据源
  private data: CardsSource = new CardsSource([]);
  // 卡片数据列表
  @State private cardsList: CardInfo[] = [];
  // 卡片偏移度列表
  @State private cardsOffset: number[] = [];
  // 屏幕宽度
  private displayWidth: number = 0;
  // Swiper 两侧的偏移量
  private swiperMargin: number = Constants.SWIPER_MARGIN;
  // Swiper 当前索引值
  @State private currentSwiperIndex: number = 0;
  // 数据源对应的缩放数组
  @State scaleList: number[] = [];
  // 最大缩放
  private MAX_SCALE: number = 1;
  // 最小缩放
  private MIN_SCALE: number = 0.8;
  // 手势触发时的offset
  @State startSwiperOffset: number = 0;
  // 图片缩放的比例
  @State proportion: number = 0;

  aboutToAppear(): void {
    // 获取屏幕大小，初始化displayWidth，用于后续计算卡片的偏移量
    const displayData: display.Display = display.getDefaultDisplaySync();
    this.displayWidth = px2vp(displayData.width);
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      if ((display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) ||
        this.displayWidth >= Constants.DEVICESIZE) {
        this.displayWidth = px2vp(displayData.width) / 2;
      }
    }
    logger.info(TAG, `Display width ${this.displayWidth}`);
    // 传入数据添加至卡片数据，并初始化偏移量列表，初始化缩放系数数组
    this.initCardsListAndOffset(this.initCardsList);
    // 初始化懒加载列表
    this.data = new CardsSource(this.cardsList);
    // 计算当前卡片及关联卡片的偏移量
    this.calculateOffset(0);
  }

  /**
   * 初始化 cardsList, cardsOffset 及 scaleList。读取传入的case，并添加卡片数据，初始化偏移量列表和缩放系数数组。
   * @param {CardInfo[]} initCardsList - 初始化数据列表
   */
  private initCardsListAndOffset(initCardsList: CardInfo[]) {
    // 传入case为空时，使用预置用例
    if (initCardsList === undefined || initCardsList.length === 0) {
      initCardsList = Constants.CARD_TEST_CASE
    }
    // 将初始化list传入卡片数据列表、卡片偏移度列表
    initCardsList.forEach((item, index) => {
      this.cardsList.push(item);
      this.cardsOffset.push(0);
      // 初始化数据源对应的缩放系数存入数组
      this.scaleList.push(index === 0 ? this.MAX_SCALE : this.MIN_SCALE);
    })
    // 初始化背景色
    this.initBackground();
  }

  /**
   * 初始化背景。
   */
  private async initBackground() {
    // TODO 知识点：初始化页面获取第一张图片的颜色
    const context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    const fileData: Uint8Array = await resourceMgr.getMediaContent(this.cardsList[0].src as Resource);
    const buffer = fileData.buffer as ArrayBuffer;
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();

    // TODO 知识点：智能取色器接口使用，初始化背景色
    effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
      let color = colorPicker.getMainColorSync();
      // 将取色器选取的color示例转换为十六进制颜色代码
      this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16)
    })
  }

  build() {
    Column() {
      Stack() {
        // 渐变背景叠底
        Column() {
        }
        .width($r('app.string.card_swiper_full_size'))
        .height($r('app.integer.card_swiper_swiper_height'))
        .zIndex(this.backgroundMaskZIndex)
        .visibility(this.isBackgroundColorChange ? Visibility.Visible : Visibility.Hidden)
        .linearGradient({
          // 渐变方向，从上至下
          angle: Constants.LINEAR_GRADIENT_ANGLE,
          // 数组末尾元素占比小于1时，满足重复着色的效果
          colors: [
            [this.bgColor, Constants.BACKGROUND_LINEAR_GRADIENT_COLOR_POS[0]],
            [Constants.BACKGROUND_END_COLOR, Constants.BACKGROUND_LINEAR_GRADIENT_COLOR_POS[1]],
            [Constants.BACKGROUND_END_COLOR, Constants.BACKGROUND_LINEAR_GRADIENT_COLOR_POS[2]],
            [this.bgColor, Constants.BACKGROUND_LINEAR_GRADIENT_COLOR_POS[3]]
          ]
        })

        // 卡片
        Swiper() {
          LazyForEach(this.data, (item: CardInfo, index: number) => {
            /**
             * 卡片子组件
             * cardInfo: 卡片数据源/集
             * cardOffset: 卡片偏移量
             * cardIndex: 当前卡片序号
             * showingCard: Swiper当前显示的卡片序号
             * scaleList: 数据源对应的缩放数组
             * isShowPreviewImage: 是否开启预览
             */
            CardComponent({
              cardInfo: item,
              cardOffset: this.cardsOffset[index],
              cardIndex: index,
              showingCard: this.currentSwiperIndex,
              scaleList: this.scaleList,
              isShowPreviewImage: this.isShowPreviewImage,
            })
          })
        }
        .index($$this.currentSwiperIndex)
        .loop(false)
        .prevMargin(this.swiperMargin)
        .nextMargin(this.swiperMargin)
        .duration(Constants.DURATION)
        .curve(Constants.DEFAULT_ANIMATION_CURVE)
        .cachedCount(Constants.SWIPER_CACHE_COUNT)
        .overlay(this.fadingOverlay(), { align: Alignment.Center })
        .onChange((index) => {
          this.calculateOffset(index);
          // index发生变化时，修改数组中对应的缩放系数
          this.currentSwiperIndex = index;
          this.scaleList[this.currentSwiperIndex] = this.MAX_SCALE;
          // 若index为第一张图时，最后一张图片缩放系数为MIN_SCALE，否则index-1缩放系数为MIN_SCALE
          if (this.currentSwiperIndex === 0) {
            this.scaleList[this.scaleList.length - 1] = this.MIN_SCALE;
            // 第一张时的渐变遮罩色
            this.linearGradientBeginColor = Constants.BEGIN_COLOR;
            this.linearGradientEndColor = Constants.END_COLOR;
          } else {
            this.scaleList[this.currentSwiperIndex - 1] = this.MIN_SCALE;
          }
          // 若index为最后一张图时，第一张图缩放系数为MIN_SCALE，否则index+1缩放系数为MIN_SCALE
          if (this.currentSwiperIndex === this.scaleList.length - 1) {
            this.scaleList[0] = this.MIN_SCALE;
            // 最后一张时的渐变遮罩色
            this.linearGradientBeginColor = Constants.END_COLOR;
            this.linearGradientEndColor = Constants.BEGIN_COLOR;
          } else {
            this.scaleList[this.currentSwiperIndex + 1] = this.MIN_SCALE;
          }
          // 若index为中间的图片时，展示边缘渐变
          if (this.currentSwiperIndex != 0 && this.currentSwiperIndex != this.scaleList.length - 1) {
            this.linearGradientBeginColor = Constants.END_COLOR;
            this.linearGradientEndColor = Constants.END_COLOR;
          }
        })
        .onGestureSwipe((index, event) => {
          const currentOffset = event.currentOffset;
          // 获取当前卡片（居中）的原始偏移量
          const maxOffset = this.getMaxOffset(index) * this.proportion / 2;
          // 实时维护卡片的偏移量列表，做到跟手效果
          if (currentOffset < 0) {
            // 向左偏移
            /*
             * 此处计算原理为：按照比例设置卡片的偏移量。
             * 当前卡片居中，向左滑动后将在左边，此时卡片偏移量即为 maxOffset * 2（因为向右对齐）。
             * 所以手指能够滑动的最大距离（this.displayWidth）所带来的偏移量即为 maxOffset。
             * 易得公式：卡片实时偏移量 = （手指滑动长度 / 屏幕宽度） * 卡片最大可偏移量 + 当前偏移量。
             * 之后的计算原理相同，将不再赘述。
             */
            this.cardsOffset[index] = (-currentOffset / this.displayWidth) * maxOffset + maxOffset;
            if (this.isIndexValid(index + 1)) {
              // 下一个卡片的偏移量
              const maxOffset = this.getMaxOffset(index + 1) / 2 * this.proportion;
              this.cardsOffset[index + 1] = (-currentOffset / this.displayWidth) * maxOffset;
            }
            if (this.isIndexValid(index - 1)) {
              // 上一个卡片的偏移量
              const maxOffset = this.getMaxOffset(index - 1) / 2 * this.proportion;
              this.cardsOffset[index - 1] = (currentOffset / this.displayWidth) * maxOffset + 2 * maxOffset;
            }
          } else if (currentOffset > 0) {
            // 向右滑动
            this.cardsOffset[index] = maxOffset - (currentOffset / this.displayWidth) * maxOffset;
            if (this.isIndexValid(index + 1)) {
              const maxOffset = this.getMaxOffset(index + 1) / 2 * this.proportion;
              this.cardsOffset[index + 1] = (currentOffset / this.displayWidth) * maxOffset;
            }
            if (this.isIndexValid(index - 1)) {
              const maxOffset = this.getMaxOffset(index - 1) / 2 * this.proportion;
              this.cardsOffset[index - 1] = 2 * maxOffset - (currentOffset / this.displayWidth) * maxOffset;
            }
          }
          // 页面跟手滑动过程中触发回调，动态计算卡片滑动距离实时计算缩放系数。
          this.calculateScaling(index, currentOffset);
        })
        .onAnimationStart((index, targetIndex) => {
          this.calculateOffset(targetIndex);
          // 计算手指离开屏幕时卡片的缩放系数
          if (index === targetIndex) {
            let nextIndex: number = (index === this.scaleList.length - 1 ? 0 : index + 1);
            let preIndex: number = (index === 0 ? this.scaleList.length - 1 : index - 1);
            this.scaleList[index] = this.MAX_SCALE;
            this.scaleList[nextIndex] = this.MIN_SCALE;
            this.scaleList[preIndex] = this.MIN_SCALE;
          } else {
            let nextIndex: number = (targetIndex === this.scaleList.length - 1 ? 0 : targetIndex + 1);
            let preIndex: number = (targetIndex === 0 ? this.scaleList.length - 1 : targetIndex - 1);
            this.scaleList[targetIndex] = this.MAX_SCALE;
            this.scaleList[nextIndex] = this.MIN_SCALE;
            this.scaleList[preIndex] = this.MIN_SCALE;
          }
          // 滚动中获取当前颜色均值
          this.getAverageColor(this.cardsList[targetIndex].src)
        })
        .onAnimationEnd(() => {
          this.startSwiperOffset = 0;
        })
        .height($r('app.integer.card_swiper_swiper_height'))
        .width($r('app.string.card_swiper_full_size'))
      }
    }
    .width(Constants.CARD_SWIPER_FULL_SIZE)
    .height(Constants.CARD_SWIPER_FULL_SIZE)
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 计算卡片偏移量，并维护偏移量列表。
   * @param { number } targetIndex - swiper target card's index.
   */
  private calculateOffset(target: number) {
    let left = target - 1;
    let right = target + 1;

    // 计算上一张卡片的偏移值
    if (this.isIndexValid(left)) {
      this.cardsOffset[left] = this.getMaxOffset(left) - this.cardsList[left].width * (1 - this.MIN_SCALE) / 2;
    }
    // 计算当前卡片的偏移值
    if (this.isIndexValid(target)) {
      this.cardsOffset[target] = this.getMaxOffset(target) * this.proportion / 2;
    }
    // 下一张片的偏移值
    if (this.isIndexValid(right)) {
      this.cardsOffset[right] = -this.cardsList[right].width * (1 - this.MIN_SCALE) / 2;
    }
  }

  /**
   * 检查卡片索引值的合法性。
   * @param {number} index - input card's index.
   * @returns {boolean} true or false.
   */
  private isIndexValid(index: number): boolean {
    return index >= 0 && index < this.cardsList.length;
  }

  /**
   * 计算指定卡片的最大偏移量。
   * @param {number} index - target card's index.
   * @returns {number} offset value.
   */
  private getMaxOffset(index: number): number {
    /*
     * 这里的偏移量指相对容器左侧的值。
     * 计算公式为：屏幕宽度 - Swiper两侧突出的偏移量 - 卡片自身的宽度。
     * 此值即为卡片可偏移的最大值，也就是卡片右对齐的状态值。
     * 如果居中，则将最大偏移量 / 2。
     */
    // 原图时最大偏移量
    let maxOffset: number = this.displayWidth - this.cardsList[index].width - 2 * this.swiperMargin;
    // 缩放时最大偏移量
    let maxOffsetScale: number =
      this.displayWidth - this.cardsList[index].width * this.MIN_SCALE - 2 * this.swiperMargin;
    this.proportion = maxOffset / maxOffsetScale;
    return maxOffsetScale;
  }

  /**
   * 根据卡片滑动距离实时计算卡片缩放系数。
   * @param {number} index - target card's index.
   * @param {number} offset - current Offset distance.
   */
  private calculateScaling(index: number, offset: number) {
    let currentScale: number = this.scaleList[index];
    let nextIndex: number = (index === this.scaleList.length - 1 ? 0 : index + 1);
    let preIndex: number = (index === 0 ? this.scaleList.length - 1 : index - 1);
    let nextScale: number = this.scaleList[nextIndex];
    let preScale: number = this.scaleList[preIndex];
    if (this.startSwiperOffset === 0) {
      this.startSwiperOffset = offset;
    }
    // 滑动距离
    let distance: number = Math.abs(this.startSwiperOffset - offset);
    currentScale = this.MAX_SCALE - Math.min(distance / this.displayWidth, this.MAX_SCALE - this.MIN_SCALE);
    // 滑动时实时缩放的比例
    if (this.startSwiperOffset > offset) {
      nextScale = this.MIN_SCALE + Math.min(distance / this.displayWidth, this.MAX_SCALE - this.MIN_SCALE);
      preScale = this.MIN_SCALE;
    } else {
      preScale = this.MIN_SCALE + Math.min(distance / this.displayWidth, this.MAX_SCALE - this.MIN_SCALE);
      nextScale = this.MIN_SCALE;
    }
    this.scaleList[this.currentSwiperIndex] = currentScale;
    this.scaleList[nextIndex] = nextScale;
    this.scaleList[preIndex] = preScale;
  }

  /**
   * 切换动画过程中获取当前图片的平均颜色
   */
  async getAverageColor(picSrc: ResourceStr) {
    const context = getContext(this);
    // 获取resourceManager资源管理器
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    const fileData: Uint8Array = await resourceMgr.getMediaContent(picSrc as Resource);
    // 获取图片的ArrayBuffer
    const buffer = fileData.buffer as ArrayBuffer;
    // 创建imageSource
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    // 创建pixelMap
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();

    effectKit.createColorPicker(pixelMap, (err, colorPicker) => {
      // 读取图像主色的颜色值，结果写入Color
      let color = colorPicker.getMainColorSync();
      // 开启背景颜色渲染的属性动画
      animateTo({ duration: 500, curve: Curve.Linear, iterations: 1 }, () => {
        // 将取色器选取的color示例转换为十六进制颜色代码
        this.bgColor = "#" + color.alpha.toString(16) + color.red.toString(16) + color.green.toString(16) + color.blue.toString(16);
      })
    })
  }

  /**
   * 浮层组件，实现边缘渐变效果，根据isEdgeFading判断是否开启
   */
  @Builder
  fadingOverlay() {
    Column()
      .width(Constants.CARD_SWIPER_FULL_SIZE)
      .height(Constants.FADING_OVERLAY_LENGTH)// TODO: 知识点: linearGradient 可以设置指定范围内的颜色渐变效果
      .linearGradient({
        angle: Constants.OVERLAY_LINEAR_GRADIENT_ANGLE,
        colors: [
          [this.linearGradientBeginColor, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[0]],
          [Constants.BEGIN_COLOR, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[1]],
          [Constants.BEGIN_COLOR, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[2]],
          [this.linearGradientEndColor, Constants.OVERLAY_LINEAR_GRADIENT_COLOR_POS[3]],
        ]
      })
      .animation({
        curve: Constants.OVERLAY_ANIMATION_CURVE,
        duration: Constants.OVERLAY_DURATION
      })
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility(this.isEdgeFading ? Visibility.Visible : Visibility.Hidden)
  }
}