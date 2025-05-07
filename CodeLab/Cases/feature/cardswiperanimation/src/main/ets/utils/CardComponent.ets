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
import { PlatformInfo, PlatformTypeEnum } from 'utils'
import { CardInfo } from '../model/CardModel';
import Constants from '../common/Constants';

/**
 * 功能描述：
 * 1. 展示当前图片缩略图和大图，通过 isPhotoShow 标志位判断展示大图或缩略图
 * 2. 单击卡片图片，进入全屏模态页面，展示为大图; 再次单击图片，展示为缩略图
 * 3. 按压卡片图片，图片卡片缩小为原始缩略图的90%，按压抬起后恢复
 *
 * 实现原理：
 * 1. 通过Image组件展示当前卡片缩略图，并通过geometryTransition使用id参数绑定两个组件转场关系，实现一镜到底动画
 * 2. 自定义photoShowBuilder组件实现图片全屏模态展示
 * 2. 通过给Image组件bindContentCover绑定全屏模态页面，点击图片实现转场
 *
 * @param {CardInfo[]} [cardInfo] - 卡片数据集
 * @param {number} [cardOffset] - 卡片偏移量
 * @param {number} [cardIndex] - 当前卡片序号
 * @param {number} [showingCard] - Swiper当前显示的卡片序号
 * @param {number[]} [scaleList] - 数据源对应的缩放数组
 */
@Component
export default struct CardComponent {
  // 卡片数据，默认初始化
  cardInfo: CardInfo = {
    src: $r('app.media.panda'),
    width: Constants.CARD_UNIT_LENGTH,
    height: Constants.CARD_UNIT_LENGTH
  };
  // 卡片偏移量
  @Prop cardOffset: number = 0;
  // 当前卡片的序号
  cardIndex: number = 0;
  // Swiper 当前显示的卡片序号
  @Prop showingCard: number = 0;
  // 数据源对应的缩放数组
  @Prop scaleList: number[] = [];
  // 是否支持大图预览展示
  isShowPreviewImage: boolean = true;
  // 私有属性
  // 图片预览窗口是否出现的标志位
  @State private isPhotoShow: boolean = false;
  // 卡片宽度
  @State cardWith: number = this.cardInfo.width;
  // 卡片高度
  @State cardHeight: number = this.cardInfo.height;
  // 显示设备是否为平板的标志位
  @State isTablet: boolean = false;
  // 屏幕宽度
  @State screenW: number = px2vp(display.getDefaultDisplaySync().width);

  aboutToAppear(): void {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      if ((display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) ||
        this.screenW >= Constants.DEVICESIZE) {
        this.isTablet = true;
      } else {
        this.isTablet = false;
      }
    }
    this.cardWith = this.cardInfo.width;
    this.cardHeight = this.cardInfo.height;
  }

  build() {
    Row() {
      Image(this.cardInfo.src)
        .width(this.cardWith)
        .height(this.cardHeight)
        .objectFit(ImageFit.Cover)
        .borderRadius($r('app.integer.card_swiper_photo_radius'))
        .shadow({
          radius: $r('app.integer.card_swiper_card_shadow_radius'),
          type: ShadowType.COLOR,
          color: $r('app.color.card_shadow_color'),
          offsetX: $r('app.integer.card_swiper_card_shadow_offsetx'),
          offsetY: $r('app.integer.card_swiper_card_shadow_offsety')
        })// TODO 知识点：geometryTransition通过id参数绑定两个组件转场关系，实现一镜到底动画
        .geometryTransition(this.cardIndex.toString(), { follow: true })
        .margin({ left: this.cardOffset })
        .animation({
          curve: Constants.DEFAULT_ANIMATION_CURVE,
          duration: Constants.DURATION
        })
        .scale({ x: this.scaleList[this.cardIndex], y: this.scaleList[this.cardIndex] })
        .onClick(() => {
          // 使点击Swiper两侧的图片无效
          if (this.cardIndex !== this.showingCard) {
            return;
          } else if (!this.isShowPreviewImage) {
            return;
          }
          // 动画及显示预览窗口
          this.animateFunc();
        })
        .bindContentCover(
          this.isPhotoShow,
          this.photoShowBuilder(this.cardInfo.src, this.cardIndex.toString()),
          {
            backgroundColor: $r('app.color.photo_preview_build_background'),
            modalTransition: ModalTransition.ALPHA,
            transition: TransitionEffect.OPACITY.animation({
              duration: Constants.DURATION, curve: Constants.DEFAULT_ANIMATION_CURVE
            })
          }
        )
        .onTouch((event) => {
          if (event) {
            if (event.type === TouchType.Down) {
              // 按下略微缩小
              this.cardWith = this.cardInfo.width * 0.9;
              this.cardHeight = this.cardInfo.height * 0.9;
            } else if (event.type === TouchType.Up) {
              // 抬起恢复大小
              this.cardWith = this.cardInfo.width;
              this.cardHeight = this.cardInfo.height;
            }
          }
        })
    }
    .alignItems(VerticalAlign.Center)
  }

  /**
   * 全屏模态展示图片组件
   */
  @Builder
  photoShowBuilder(img: ResourceStr, id: string) {
    Column() {
      Image(img)
        .borderRadius($r('app.integer.card_swiper_photo_radius'))
        .geometryTransition(id, { follow: true })
        .width(this.isTablet ? $r('app.string.card_swiper_tablet_preview_width') :
        $r('app.string.card_swiper_photo_preview_width'))
        .transition(TransitionEffect.opacity(Constants.OPACITY))
    }
    .width($r('app.string.card_swiper_full_size'))
    .height($r('app.string.card_swiper_full_size'))
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.animateFunc();
    })
    .transition(TransitionEffect.OPACITY.animation({
      duration: Constants.DURATION, curve: Constants.DEFAULT_ANIMATION_CURVE
    }))
  }

  /**
   * 设置卡片组件点击图片后的动画
   *
   * duration: 动画时长
   * curve: 动画曲线，默认Friction(阻尼曲线)
   */
  animateFunc() {
    animateTo({
      duration: Constants.DURATION,
      curve: Constants.DEFAULT_ANIMATION_CURVE
    }, () => {
      this.isPhotoShow = !this.isPhotoShow;
    })
  }
}