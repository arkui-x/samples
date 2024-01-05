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
import Constants from '../common/constants/Constants';
import { checkIsVideo } from '../common/utils/util.js';
import MyDataSource from '../bean/MyDataSource'
import emitter from '@ohos.events.emitter';

@Component
export default struct ListPage {
  @Link currentPage: string;
  @Link photoArr: MyDataSource;
  @Link lastPageCount: number;
  @Link isPageLoading: boolean;
  @State currentNumber: number = 0; //All images are displayed by default
  @StorageLink('selectedIndex') selectedIndex: number = 0;
  @StorageLink('currentListName') currentListName: string = 'home';
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;
  private scroller: Scroller = new Scroller();

  handleClick() {
    console.log('点击了图片');
    this.currentPage = 'detailListPage';
    if (this.homeTabBottomIndex === 0) {
      AppStorage.setOrCreate('currentPage', this.currentPage);
    } else {
      AppStorage.setOrCreate('currentInnerPage', this.currentPage);
    }
  }

  getPageData(type: string) {
    if (type === 'bottom') {
      let eventData: emitter.EventData = {
        data: {
          type: this.currentListName
        }
      };

      let innerEvent: emitter.InnerEvent = {
        eventId: Constants.ALBUM_EVENT_ID,
        priority: emitter.EventPriority.HIGH
      };

      emitter.emit(innerEvent, eventData);
    }
  }

  build() {
    if (this.photoArr.totalCount() === 0) {
      Image($r('app.media.default_img'))
        .width(200)
        .height(200)
        .position({ x: '50%', y: '50%' })
        .translate({ x: '-50%', y: '-50%' })
    } else {
      Grid(this.scroller) {
        LazyForEach(this.photoArr, (img: Resource, index?: number) => {
          GridItem() {
            if (checkIsVideo(String(img))) {
              Stack() {
                Image($r('app.media.img_bg'))
                  .height(Constants.FULL_PERCENT)
                  .width(Constants.FULL_PERCENT)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.selectedIndex = index as number;
                    this.handleClick();
                  })
                Image($r('app.media.play_btn'))
                  .height(50)
                  .width(50)
                  .objectFit(ImageFit.Contain)
                  .onClick(() => {
                    this.selectedIndex = index as number;
                    this.handleClick();
                  })
              }
            } else {
              Image(img)
                .height(Constants.FULL_PERCENT)
                .width(Constants.FULL_PERCENT)
                .objectFit(ImageFit.Cover)
                .onClick(() => {
                  this.selectedIndex = index as number;
                  this.handleClick();
                })
            }
          }
          .width(Constants.FULL_PERCENT)
          .aspectRatio(1)
        }, (item: Resource) => JSON.stringify(item))
      }
      .cachedCount(15)
      .columnsTemplate(Constants.GRID_COLUMNS_TEMPLATE)
      .rowsGap(Constants.LIST_ITEM_SPACE)
      .columnsGap(Constants.LIST_ITEM_SPACE)
      .layoutWeight(1)
      .onScrollIndex((first, last) => {
        if (this.lastPageCount === 0) return;
        if (this.isPageLoading) return;
        let lastGetDataIndex = this.photoArr.totalCount() - 3 - 1;
        console.log('first：' + first);
        console.log('last：' + last);
        if (last >= lastGetDataIndex && this.photoArr.totalCount() >= 30) {
          this.isPageLoading = true;
          this.getPageData('bottom');
        }
      })
    }
  }
}