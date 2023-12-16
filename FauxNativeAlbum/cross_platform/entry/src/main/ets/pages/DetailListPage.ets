/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import display from '@ohos.display';
import router from '@ohos.router';
import Constants from '../common/constants/Constants';
import { checkIsVideo } from '../common/utils/util.js';
import MyDataSource from '../bean/MyDataSource';

enum scrollTypeEnum {
  STOP = 'onScrollStop',
  SCROLL = 'onScroll'
};

@Component
export default struct DetailListPage {
  @Link @Watch('currentPageChange') currentPage:string;
  @Link photoArr:MyDataSource;
  @Link smallPhotoArr:MyDataSource;
  private swiperController: SwiperController = new SwiperController();
  private smallScroller: Scroller = new Scroller();
  private bigScroller: Scroller = new Scroller();
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  @State smallImgWidth: number = (this.deviceWidth - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) /
    Constants.SHOW_COUNT;
  @State imageWidth: number = this.deviceWidth + this.smallImgWidth;
  @State isIOS:boolean = AppStorage.get('isIOS') as boolean;
  @StorageLink('selectedIndex') selectedIndex: number = 0;
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;

  currentPageChange() {
    if(this.currentPage === 'detailListPage') {
      this.smallScroller.scrollToIndex(this.selectedIndex);
      this.bigScroller.scrollToIndex(this.selectedIndex);
    }
  }

  @Builder
  SmallImgItemBuilder(img: string, index?: number) {
    if (index && index > (Constants.CACHE_IMG_SIZE - 1) && index < (this.smallPhotoArr.totalCount() - Constants.CACHE_IMG_SIZE)) {
      if(checkIsVideo(img)) {
        Video({src:img})
          .controls(false)
          .onClick(() => this.smallImgClickAction(index))
      }else {
        Image(img)
          .onClick(() => this.smallImgClickAction(index))
      }
    }
  }

  aboutToAppear() {
    let density:number =  AppStorage.get('density') || 2.5;
    console.log('detail aboutToAppear' + density);
    let displayClass: display.Display = display.getDefaultDisplaySync();
    let width = displayClass.width / density ?? Constants.DEFAULT_WIDTH;
    this.deviceWidth = width;
    this.smallImgWidth = (width - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
    this.imageWidth = this.deviceWidth + this.smallImgWidth;
  }

  onPageShow() {
    this.smallScroller.scrollToIndex(this.selectedIndex);
    this.bigScroller.scrollToIndex(this.selectedIndex);
  }

  goDetailPage(): void {
    this.currentPage = 'detailPage';
    router.pushUrl({
      url: Constants.URL_DETAIL_PAGE,
      params: { photoArr: this.photoArr,currentPage:this.currentPage }
    });
  }

  smallImgClickAction(index: number): void {
    this.selectedIndex = index - Constants.CACHE_IMG_SIZE;
    this.smallScroller.scrollToIndex(this.selectedIndex);
  }

  smallScrollAction(type: scrollTypeEnum): void {
    this.selectedIndex = Math.round(((this.smallScroller.currentOffset().xOffset as number) +
      this.smallImgWidth / Constants.DOUBLE_NUMBER) / (this.smallImgWidth + Constants.LIST_ITEM_SPACE));
    if (type === scrollTypeEnum.SCROLL) {
      this.bigScroller.scrollTo({ xOffset: this.selectedIndex * this.imageWidth, yOffset: 0 });
    } else {
      this.smallScroller.scrollTo({ xOffset: this.selectedIndex * this.smallImgWidth, yOffset: 0 });
    }
  }

  build() {
    Flex({direction: FlexDirection.Column}) {
      Swiper(this.swiperController) {
        LazyForEach(this.photoArr, (item: string,index:number) => {
          if(checkIsVideo(String(item))) {
            Stack() {
              if(this.isIOS) {
                Video({ src:item })
                  .controls(false)
                  .width(Constants.FULL_PERCENT)
                  .height(Constants.FULL_PERCENT)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.currentPage = 'videoDetailPage';
                    router.pushUrl({
                      url: Constants.URL_VIDEO_DETAIL_PAGE,
                      params: { uri: item }
                    });
                  })
              }else {
                Image($r('app.media.img_bg'))
                  .width(Constants.FULL_PERCENT)
                  .height(Constants.FULL_PERCENT)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.currentPage = 'videoDetailPage';
                    router.pushUrl({
                      url: Constants.URL_VIDEO_DETAIL_PAGE,
                      params: { uri: item }
                    });
                  })
              }
              Image($r('app.media.play_btn'))
                .height(100)
                .width(100)
                .objectFit(ImageFit.Contain)
                .onClick(() => {
                  this.currentPage = 'videoDetailPage';
                  router.pushUrl({
                    url: Constants.URL_VIDEO_DETAIL_PAGE,
                    params: { uri: item }
                  });
                })
            }
          }else {
            Image(item)
              .width(Constants.FULL_PERCENT)
              .height(Constants.FULL_PERCENT)
              .objectFit(ImageFit.Contain)
              // .gesture(PinchGesture({ fingers: Constants.DOUBLE_NUMBER })
              // .onActionStart(() => this.goDetailPage()))
              .onClick(() => {
                this.goDetailPage()
              })
          }
        }, (item: string, index?: number) => JSON.stringify(item) + index)
      }
      .cachedCount(15)
      .index(this.selectedIndex | 0)
      .loop(false)
      .duration(Constants.BANNER_ANIMATE_DURATION)
      .indicator(false)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
      .onChange((index:number) => {
        this.selectedIndex = index;
        let smallWidth = this.smallImgWidth + Constants.LIST_ITEM_SPACE;
        this.smallScroller.scrollTo({ xOffset: this.selectedIndex * smallWidth, yOffset: 0 });
      })

      List({
        scroller: this.smallScroller,
        space: Constants.LIST_ITEM_SPACE,
        initialIndex: this.selectedIndex
      }) {
        ForEach(this.smallPhotoArr.getAllData(), (img: string, index?: number) => {
          ListItem() {
            this.SmallImgItemBuilder(img, index)
          }
          .width(this.smallImgWidth)
          .aspectRatio(1)
        }, (item: string) => JSON.stringify(item))
      }
      .cachedCount(15)
      .margin({top:10,bottom:20})
      .listDirection(Axis.Horizontal)
      .onScroll((scrollOffset, scrollState) => {
        if (scrollState === ScrollState.Fling) {
          this.smallScrollAction(scrollTypeEnum.SCROLL);
        }
      })
      .onScrollStop(() => this.smallScrollAction(scrollTypeEnum.STOP))
      .height(this.smallImgWidth)
      .width(Constants.FULL_PERCENT)
      .scrollBar(BarState.Off)
    }
    .width(this.imageWidth)
    .height(Constants.FULL_PERCENT)
  }
}