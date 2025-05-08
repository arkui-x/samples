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

import { display, window } from '@kit.ArkUI';
import { SceneModuleInfo } from 'functionalscenes';
import { DynamicsRouter, FoldableRouter } from 'routermodule';
import { getwaterFlowData } from '../data/WaterFlowData';

@Component
export struct HomePageSwiper {
  @Consume('pageStack') pageStack: NavPathStack;
  @Consume('swiperDisplayCount') swiperDisplayCount: number;
  @State currentIndex: number = 0;
  @State swiperData: SceneModuleInfo[] = [];
  @StorageProp('windowSize') windowSize: window.Size = {
    width: display.getDefaultDisplaySync().width,
    height: display.getDefaultDisplaySync().height
  };
  isFoldable: boolean | undefined = AppStorage.get('isFoldable');

  aboutToAppear(): void {
    for (let index = 0; index < 5; index++) {
      this.swiperData.push(getwaterFlowData()[index])
    }
  }

  build() {
    Swiper() {
      ForEach(this.swiperData, (dataItem: SceneModuleInfo) => {
        Stack() {
          Image(dataItem.swiperImage === '' ? dataItem.imageSrc : dataItem.swiperImage)
            .width(this.isFoldable ? px2vp(this.windowSize.width / 2) : $r('app.integer.swiper_width'))
            .height($r('app.integer.swiper_height'))
            .objectFit(ImageFit.Auto)
            .borderRadius($r('app.integer.swiper_border_radius'))
            .onClick(() => {
              // 判断当前路由栈最后一个路由是否与当前跳转路由相同,相同则不跳转
              if (DynamicsRouter.navPathStack.getIndexByName(dataItem.appUri)[0] === 0) {
                return;
              }
              // 点击轮播图Item时，根据点击的模块信息，将页面放入路由栈
              FoldableRouter.pushUri(dataItem.appUri, dataItem.param);
            })
            .padding(this.isFoldable ? {
              left: $r('app.integer.swiper_image_foldable_padding1'),
              right: $r('app.integer.swiper_image_foldable_padding1')
            } :
              {
                left: $r('app.integer.swiper_image_foldable_padding2'),
                right: $r('app.integer.swiper_image_foldable_padding2')
              })

          Stack() {
            Column()
              .width('100%')
              .height(24)
              .backgroundColor(Color.Black)
              .opacity(0.6)
              .borderRadius({
                bottomLeft: $r('app.integer.swiper_border_radius'),
                bottomRight: $r('app.integer.swiper_border_radius')
              })
            Text(dataItem.name)
              .width('100%')
              .fontSize(14)
              .fontColor(Color.White)
              .padding({
                left: $r('app.string.swipercomponent_main_page_padding5')
              })
              .id('case_title')
          }
        }
        .alignContent(Alignment.Bottom)
      })
    }
    .id("MainSwiper")
    .autoPlay(true)
    .displayCount(this.swiperDisplayCount)
    .margin({ top: $r('app.integer.swiper_margin_top'), bottom: $r('app.integer.swiper_margin_bottom') })
    .width(this.swiperDisplayCount === 2 ? px2vp(this.windowSize.width) : $r('app.integer.swiper_width'))
  }
}
