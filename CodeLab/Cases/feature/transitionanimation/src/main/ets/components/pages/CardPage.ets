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

import { CardData } from '../../model/CardData';
import { router } from '@kit.ArkUI';

import('./SubDetailPage');

@Component
export struct CardPage {
  @Prop cardData: CardData;
  onCardReadyExpand?: Function;
  onBack?: Function;
  onBackAnimationFinish?: () => void;
  @Prop @Watch('onExpandCardIdChange') expandCardId?: number = -1;
  @State isCardExpand: boolean = false;
  @Consume pageInfos: NavPathStack;
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部导航栏高度

  onExpandCardIdChange() {
    // expandCardId 发生变化时，意味着展开状态发生变化，从而改变this.isCardExpand值
    animateTo({ duration: 200, onFinish: this.onBackAnimationFinish }, () => {
      this.isCardExpand = this.expandCardId === this.cardData.id;
    })
  }

  @Builder
  topBar() {
    Row() {
      Column() {
        Image($r("app.media.transitionanimation_left"))
          .width('100%')
      }
      .width(20)
      .clip(true)
      .margin({ left: 10 })
      .onClick(() => {
        if (this.onBack) {
          this.onBack();
        }
      })

      Column() {
        Image(this.cardData.avatorSrc)
          .width('100%')
      }
      .margin({ left: 10 })
      .width(26)
      .clip(true)

      Text(this.cardData.authorName)
        .padding({ left: 10 })
    }
    .padding({
      top: 0,
      bottom: this.isCardExpand ? 10 : 0
    })
    .height(this.isCardExpand ? 40 : 0)
    .alignSelf(ItemAlign.Start)
  }

  @Builder
  contentImage() {
    Image(this.cardData.imageSrc)
      .width('100%')
      .onComplete(() => {
        if (this.onCardReadyExpand) {
          // Image onComplete在图片渲染后调用，触发外部nCardReadyExpand回调，解决Image还未加载好，就开始动画的闪屏问题
          this.onCardReadyExpand();
        }
      })
  }

  @Builder
  title() {
    Text(this.cardData.title).textAlign(TextAlign.Start)
      .fontWeight(this.isCardExpand ? FontWeight.Bold : FontWeight.Normal)
      .margin({
        left: 10,
        top: 10,
        bottom: 10
      })
  }

  @Builder
  bottomContent() {
    Column() {
      if (!this.isCardExpand) {
        Row() {
          Row() {
            Image(this.cardData.avatorSrc)
          }
          .width(26)
          .height(26)
          .clip(true)

          Text(this.cardData.authorName)
            .align(Alignment.Start)
            .fontColor(Color.Grey)
            .fontSize(12)
            .lineHeight(26)
            .padding({ left: 8 })
        }
        .margin({
          left: 10,
          top: 0,
          bottom: 10
        })
      } else {
        Column() {
          Text(this.cardData.content)
            .textAlign(TextAlign.Start)
            .width('100%')
        }
        .padding({ left: 7, right: 7 })
        .width('100%')

        Button($r("app.string.transition_animation_page_description"))
          .onClick(() => {
            // 进入子页面逻辑
            router.pushNamedRoute({ name: 'SubDetailPage' })
          })
          .width("60%")
          .margin({ top: 10, bottom: 40 })
      }
    }
  }

  build() {
    Scroll() {
      Column() {
        this.topBar();
        this.contentImage();
        this.title();
        this.bottomContent();
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
      .padding({ bottom: '60px' })
    }
    .align(Alignment.TopStart)
    .scrollable(this.isCardExpand ? ScrollDirection.Vertical : ScrollDirection.None)
    .scrollBar(BarState.Off)
    .backgroundColor(Color.White)
    .width('100%')
    .height(this.isCardExpand ? '90%' : undefined)
  }
}