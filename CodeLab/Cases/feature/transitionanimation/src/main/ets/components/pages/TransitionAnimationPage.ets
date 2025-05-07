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
import { CardPage } from './CardPage';
import { display } from '@kit.ArkUI';
import { WaterFlowDataSource } from '../../model/WaterFlowDataSource';
import { emitter } from '@kit.BasicServicesKit';

/**
 * 场景描述: 本方案做的是页面点击卡片跳转到详情预览的转场动画效果
 *
 * 推荐场景: 点击卡片使用动效跳转详情页的场景，如：点击图文卡片进入详情页等
 *
 * 核心组件:
 * 1. CardPage
 *
 * 实现步骤:
 * 1. 点击卡片后，记录当前被点击卡片在数组中的索引，DetailPage渲染被点击卡片组件，使用onAreaChange存储每个Card被点击时的位置、
 *    宽高信息，用于设置返回动画卡片组件的结束状态位置尺寸信息
 * 2. onCardReadyExpand回调在DetailPage内部Image渲染结束时触发，使用Stack布局，动态设置DetailPage zIndex值大于CardList，
 *    使DetailPage覆盖到CardList上；设置expandCardId为被点击的卡片Id，触发DetailPage卡片组件-> DetailPage详情页的属性动画
 * 3. CardPage内部监听expandCardId值变化，触发expandCardId相关的显式动画，透明度动画控制卡片组件和卡片详情页不共用组件的显隐
 * 4. 点击返回按钮，触发重置为this.expandCardId = -1，触发卡片组件宽高动画、卡片组件和卡片详情页不共用组件的显隐动画
 */
@Component
export struct TransitionAnimationPage {
  @Provide pageInfos: NavPathStack = new NavPathStack();
  // 存储当前设备高度，用于计算详情页展开后高度
  @State currentDisplayWidth: Length = 0;
  @State currentDisplayHeight: Length = 0;
  // 详情页是否显示标识
  @State isCardListPageShow: boolean = true;
  @State shouldDetailPageShow: boolean = false;
  @State myOpacity: number = 1;
  @State myZIndex: number = 1;
  // 记录被点击的Card索引
  @State clickedCardIndex: number = -1;
  // 记录被点击的CardId
  @State expandCardId: number = -1;
  dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  // 注册路由返回函数，案例插件不触发
  popRouter: () => void = () => {
  };

  listenBackPress() {
    let innerEvent: emitter.InnerEvent = {
      eventId: 7
    };
    // 收到eventId为7的事件后执行回调函数
    emitter.on(innerEvent, () => {
      // DetailPage渲染被点击卡片组件时，不触发路由返回
      if (this.clickedCardIndex > -1) {
        this.onBack();
      } else {
        this.popRouter();
      }
    });

  }

  aboutToAppear() {
    this.currentDisplayWidth = display.getDefaultDisplaySync().width;
    this.currentDisplayHeight = display.getDefaultDisplaySync().height;
    // 注册事件监听
    this.listenBackPress();
  }

  aboutToDisappear(): void {
    // 销毁事件监听
    emitter.off(7);
  }

  @Builder
  cardList() {
    Column({ space: 2 }) {
      WaterFlow() {
        LazyForEach(this.dataSource, (item: CardData, index) => {
          FlowItem() {
            CardPage({ cardData: item })
              .onClick(() => {
                this.clickedCardIndex = index;
              })
          }
          .onAreaChange((oldValue, newValue) => {
            // 记录每个卡片点击时的位置尺寸数据，用于设置动画前后的数据
            this.dataSource.getData(index).cardArea = newValue;
          })
          .width('100%')
        })
      }
      .onReachEnd(() => {
        // 即将触底时提前增加数据
        let cardData: CardData =
          JSON.parse(JSON.stringify(this.dataSource.getData(Math.floor(Math.random() * 6)))) as CardData;
        cardData.id = Date.now();
        this.dataSource.addLastItem(cardData);
      })
      .columnsTemplate(getContext().resourceManager.getStringSync($r("app.string.transition_animation_two_fr").id))
      .columnsGap(8)
      .rowsGap(8)
      .backgroundColor($r("app.color.transition_animation_water_flow_background_color"))
      .width('100%')
      .height('100%')
      .padding(8)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .edgeEffect(EdgeEffect.Fade)
      .clip(false)
    }
    .clip(true)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .zIndex(1)
  }

  @Builder
  detailPage() {
    Column() {
      if (this.clickedCardIndex > -1) {
        CardPage({
          cardData: this.dataSource.getData(this.clickedCardIndex),
          expandCardId: this.expandCardId,
          onCardReadyExpand: () => {
            this.shouldDetailPageShow = true;
            // Card中Image加载渲染完成时触发
            if (this.isCardListPageShow) {
              // cardPage
              animateTo({
                duration: 200,
                onFinish: () => {
                  this.isCardListPageShow = false
                }
              }, () => {
                this.expandCardId = this.dataSource.getData(this.clickedCardIndex).id;
              })
            }
          },
          onBack: () => {
            this.onBack();
          },
          onBackAnimationFinish: () => {
          }
        })
          .width(this.expandCardId > -1 ? px2vp(this.currentDisplayWidth as number) :
          this.dataSource.getData(this.clickedCardIndex).cardArea.width)
          .height(this.expandCardId > -1 ? px2vp(this.currentDisplayHeight as number) :
          this.dataSource.getData(this.clickedCardIndex)
            .cardArea
            .height)
          .position({
            x: this.expandCardId > -1 ? 0 : this.dataSource.getData(this.clickedCardIndex)
              .cardArea
              .position
              .x,
            y: this.expandCardId > -1 ? 0 : this.dataSource.getData(this.clickedCardIndex)
              .cardArea
              .position
              .y
          })
          .backgroundColor(Color.White)
      }
    }
    .width('100%')
    .height('100%')
    .zIndex(this.shouldDetailPageShow ? 2 : 0)
    .backgroundColor(Color.Transparent)
  }

  @Builder
  stuckComponent() {
    // 性能知识点: 功能是以har的形式集成在主工程中，没有@Entry修饰的组件，无法使用@Entry组件的onBackPress生命周期函数。
    Navigation(this.pageInfos) {
      Stack() {
        this.cardList();
        this.detailPage();
      }
    }
    .hideTitleBar(true)

  }

  build() {
    this.stuckComponent();
  }

  onBack() {
    animateTo({
      duration: 200,
      onFinish: () => {
        this.clickedCardIndex = -1;
        this.isCardListPageShow = true;
        this.shouldDetailPageShow = false;
      }
    }, () => {
      this.expandCardId = -1;
    })

  }
}
