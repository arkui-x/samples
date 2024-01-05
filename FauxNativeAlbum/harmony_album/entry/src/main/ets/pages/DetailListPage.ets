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
import MyDataSource from '../bean/MyDataSource'

enum scrollTypeEnum {
  STOP = 'onScrollStop',
  SCROLL = 'onScroll'
};

@Component
export default struct DetailListPage {
  @Link @Watch('currentPageChange') currentPage: string;
  @Link photoArr: MyDataSource;
  @Link smallPhotoArr: MyDataSource;
  private swiperController: SwiperController = new SwiperController();
  private smallScroller: Scroller = new Scroller();
  private bigScroller: Scroller = new Scroller();
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  @State smallImgWidth: number = (this.deviceWidth - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) /
  Constants.SHOW_COUNT;
  @State imageWidth: number = this.deviceWidth + this.smallImgWidth;
  @StorageLink('selectedIndex') selectedIndex: number = 0;
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;

  currentPageChange() {
    if (this.currentPage === 'detailListPage') {
      this.smallScroller.scrollToIndex(this.selectedIndex);
      this.bigScroller.scrollToIndex(this.selectedIndex);
    }
  }

  @Builder
  SmallImgItemBuilder(img: Resource, index?: number) {
    if (index && index > (Constants.CACHE_IMG_SIZE - 1) && index < (this.smallPhotoArr.totalCount() - Constants.CACHE_IMG_SIZE)) {
      if (checkIsVideo(String(img))) {
        Video({ src: img })
          .controls(false)
          .onClick(() => this.smallImgClickAction(index))
      } else {
        Image(img)
          .onClick(() => this.smallImgClickAction(index))
      }
    }
  }

  aboutToAppear() {
    let displayClass: display.Display = display.getDefaultDisplaySync();
    let width = displayClass.width / displayClass.densityPixels ?? Constants.DEFAULT_WIDTH;
    this.deviceWidth = width;
    this.smallImgWidth = (width - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
    this.imageWidth = this.deviceWidth + this.smallImgWidth;
  }

  onPageShow() {
    this.smallScroller.scrollToIndex(this.selectedIndex);
    this.bigScroller.scrollToIndex(this.selectedIndex);
  }

  goDetailPage(): void {
    console.log('detailListPage:' + this.photoArr.totalCount());
    this.currentPage = 'detailPage';
    router.pushUrl({
      url: Constants.URL_DETAIL_PAGE,
      params: { photoArr: this.photoArr, currentPage: this.currentPage }
    });
  }

  goVideoDetailPage(item: Resource): void {
    console.log('detailListPage:' + this.photoArr.totalCount());
    this.currentPage = 'videoDetailPage';
    router.pushUrl({
      url: Constants.URL_VIDEO_DETAIL_PAGE,
      params: { uri: item }
    });
  }

  smallImgClickAction(index: number): void {
    this.selectedIndex = index - Constants.CACHE_IMG_SIZE;
    this.smallScroller.scrollToIndex(this.selectedIndex);
    this.bigScroller.scrollToIndex(this.selectedIndex);
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

  bigScrollAction(type: scrollTypeEnum): void {
    let smallWidth = this.smallImgWidth + Constants.LIST_ITEM_SPACE;
    this.selectedIndex = Math.round(((this.bigScroller.currentOffset().xOffset as number) +
      smallWidth / Constants.DOUBLE_NUMBER) / this.imageWidth);
    if (type === scrollTypeEnum.SCROLL) {
      this.smallScroller.scrollTo({ xOffset: this.selectedIndex * smallWidth, yOffset: 0 });
    } else {
      this.bigScroller.scrollTo({ xOffset: this.selectedIndex * this.imageWidth, yOffset: 0 });
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      List({ scroller: this.bigScroller, initialIndex: this.selectedIndex }) {
        LazyForEach(this.photoArr, (item: Resource) => {
          ListItem() {
            if (checkIsVideo(String(item))) {
              Stack() {
                Image($r('app.media.img_bg'))
                  .width(Constants.FULL_PERCENT)
                  .height(Constants.FULL_PERCENT)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.goVideoDetailPage(item);
                  })
                Image($r('app.media.play_btn'))
                  .height(100)
                  .width(100)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.goVideoDetailPage(item);
                  })
              }
            } else {
              Image(item)
                .height(Constants.FULL_PERCENT)
                .width(Constants.FULL_PERCENT)
                .objectFit(ImageFit.Contain)
                .gesture(PinchGesture({ fingers: Constants.DOUBLE_NUMBER })
                  .onActionStart(() => this.goDetailPage()))
                .onClick(() => this.goDetailPage())
            }
          }
          .padding({
            left: this.smallImgWidth / Constants.DOUBLE_NUMBER,
            right: this.smallImgWidth / Constants.DOUBLE_NUMBER
          })
          .width(this.imageWidth)
          .height(Constants.FULL_PERCENT)
        }, (item: Resource) => JSON.stringify(item))
      }
      .cachedCount(15)
      .onScroll((scrollOffset, scrollState) => {
        if (scrollState === ScrollState.Fling) {
          this.bigScrollAction(scrollTypeEnum.SCROLL);
        }
      })
      .onScrollStop(() => this.bigScrollAction(scrollTypeEnum.STOP))
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
      .padding({ bottom: this.smallImgWidth * Constants.DOUBLE_NUMBER })
      .listDirection(Axis.Horizontal)

      List({
        scroller: this.smallScroller,
        space: Constants.LIST_ITEM_SPACE,
        initialIndex: this.selectedIndex
      }) {
        ForEach(this.smallPhotoArr.getAllData(), (img: Resource, index?: number) => {
          ListItem() {
            this.SmallImgItemBuilder(img, index)
          }
          .width(this.smallImgWidth)
          .aspectRatio(1)
        }, (item: Resource) => JSON.stringify(item))
      }
      .cachedCount(15)
      .margin({ top: 10, bottom: 20 })
      .listDirection(Axis.Horizontal)
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