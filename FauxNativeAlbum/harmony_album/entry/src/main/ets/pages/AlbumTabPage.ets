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

import ListPage from './ListPage';
import DetailListPage from './DetailListPage';
import Constants from '../common/constants/Constants';
import { albumResFace } from './Index';
import TopNavigation from './components/TopNavigation';
import MyDataSource from '../bean/MyDataSource';
import emitter from '@ohos.events.emitter';


@Component
export default struct AlbumTabPage {
  @Link currentPage: string;
  @Link lastPageCount: number;
  @Link isPageLoading: boolean;
  @Link barHeight: number;
  @State is3dInitData: boolean = false; //Check whether the tab has loaded data in the last 3 days
  @State is7dInitData: boolean = false; //Check whether the tab has loaded data in the last 7 days
  @State is30dInitData: boolean = false; //Check whether the tab has loaded data in the last 30 days
  @State photoArr: MyDataSource = AppStorage.get('photoArr') as MyDataSource;
  @State photo3dArr: MyDataSource = AppStorage.get('photo3dArr') as MyDataSource;
  @State photo7dArr: MyDataSource = AppStorage.get('photo7dArr') as MyDataSource;
  @State photo30dArr: MyDataSource = AppStorage.get('photo30dArr') as MyDataSource;
  @State smallPhotoArr: MyDataSource = AppStorage.get('smallPhotoArr') as MyDataSource;
  @StorageLink('currentNumber') currentNumber: number = 0; //All images are displayed by default
  @StorageLink('homeTabIndex') homeTabIndex: number = 0; //Gallery tab tab switches index
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0; //tab switch index
  @StorageLink('receivedAlbumRes') receivedAlbumRes: albumResFace[] = [];
  private tabsController: TabsController = new TabsController();

  /**
   * Displays pictures based on time, default is 0
   * @param num 0:All 1:3 days 2:7 days 3: a month
   */
  handleChangeTime(num: number) {
    console.log('handleChangeTime：' + num.toString());
    this.currentNumber = num;
    this.lastPageCount = 30;
    let eventData: emitter.EventData = {
      data: {
        type: ''
      }
    };

    let innerEvent: emitter.InnerEvent = {
      eventId: Constants.RECENT_TIME_TYPE_ID,
      priority: emitter.EventPriority.HIGH
    };

    if (num === 0) {
      if (this.photoArr.totalCount() === 0) {
        emitter.emit(innerEvent, eventData);
      }
      // this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photoArr.getAllData(),Constants.CACHE_IMG_LIST));
    } else if (num === 1) {
      if (!this.is3dInitData) {
        this.is3dInitData = true;
        emitter.emit(innerEvent, eventData);
      }
      // this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo3dArr.getAllData(),Constants.CACHE_IMG_LIST));
    } else if (num === 2) {
      if (!this.is7dInitData) {
        this.is7dInitData = true;
        emitter.emit(innerEvent, eventData);
      }
      // this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo7dArr.getAllData(),Constants.CACHE_IMG_LIST));
    } else if (num === 3) {
      if (!this.is30dInitData) {
        this.is30dInitData = true;
        emitter.emit(innerEvent, eventData);
      }
      // this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photo30dArr.getAllData(),Constants.CACHE_IMG_LIST));
    }
  }

  // All gallery
  @Builder
  AllAlbumBuilder() {
    Stack() {
      Column() {
        ListPage({
          currentPage: this.currentPage,
          photoArr: this.photoArr,
          lastPageCount: this.lastPageCount,
          isPageLoading: this.isPageLoading
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 2 : 1)
      .opacity(this.currentPage === 'listPage' ? 1 : 0)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)

      Column() {
        DetailListPage({
          currentPage: this.currentPage,
          photoArr: this.photoArr,
          smallPhotoArr: this.smallPhotoArr
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 1 : 2)
      .opacity(this.currentPage === 'listPage' ? 0 : 1)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
    }
    .flexBasis(1)
    .flexGrow(1)
  }

  // Last 3 days photo gallery
  @Builder
  ThreeDayAlbumBuilder() {
    Stack() {
      Column() {
        ListPage({
          currentPage: this.currentPage,
          photoArr: this.photo3dArr,
          lastPageCount: this.lastPageCount,
          isPageLoading: this.isPageLoading
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 2 : 1)
      .opacity(this.currentPage === 'listPage' ? 1 : 0)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)

      Column() {
        DetailListPage({
          currentPage: this.currentPage,
          photoArr: this.photo3dArr,
          smallPhotoArr: this.smallPhotoArr
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 1 : 2)
      .opacity(this.currentPage === 'listPage' ? 0 : 1)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
    }
    .flexBasis(1)
    .flexGrow(1)
  }

  // Last 7 days photo gallery
  @Builder
  SevenDayAlbumBuilder() {
    Stack() {
      Column() {
        ListPage({
          currentPage: this.currentPage,
          photoArr: this.photo7dArr,
          lastPageCount: this.lastPageCount,
          isPageLoading: this.isPageLoading
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 2 : 1)
      .opacity(this.currentPage === 'listPage' ? 1 : 0)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)

      Column() {
        DetailListPage({
          currentPage: this.currentPage,
          photoArr: this.photo7dArr,
          smallPhotoArr: this.smallPhotoArr
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 1 : 2)
      .opacity(this.currentPage === 'listPage' ? 0 : 1)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
    }
    .flexBasis(1)
    .flexGrow(1)
  }

  // Last 30 days photo gallery
  @Builder
  ThirtyDayAlbumBuilder() {
    Stack() {
      Column() {
        ListPage({
          currentPage: this.currentPage,
          photoArr: this.photo30dArr,
          lastPageCount: this.lastPageCount,
          isPageLoading: this.isPageLoading
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 2 : 1)
      .opacity(this.currentPage === 'listPage' ? 1 : 0)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)

      Column() {
        DetailListPage({
          currentPage: this.currentPage,
          photoArr: this.photo30dArr,
          smallPhotoArr: this.smallPhotoArr
        })
      }
      .zIndex(this.currentPage === 'listPage' ? 1 : 2)
      .opacity(this.currentPage === 'listPage' ? 0 : 1)
      .width(Constants.FULL_PERCENT)
      .height(Constants.FULL_PERCENT)
    }
    .flexBasis(1)
    .flexGrow(1)
  }

  // Bottom button style
  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.homeTabIndex === targetIndex ? '#1698CE' : '#6B6B6B')
        .lineHeight(40)
    }
    .width(50)
    .height(50)
    .onClick(() => {
      console.log('this.homeTabIndex111' + targetIndex);
      this.homeTabIndex = targetIndex;
      this.tabsController.changeIndex(this.homeTabIndex);
      this.handleChangeTime(targetIndex);
    })

  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        if (this.homeTabBottomIndex === 1 || this.currentPage !== 'listPage') {
          TopNavigation({ title: '相册', currentPage: this.currentPage })
        }
        Tabs({ barPosition: BarPosition.End, controller: this.tabsController, index: this.homeTabIndex }) {
          TabContent() {
            this.AllAlbumBuilder();
          }
          .tabBar(this.TabBuilder('全部', 0))

          TabContent() {
            this.ThreeDayAlbumBuilder();
          }
          .tabBar(this.TabBuilder('3天', 1))

          TabContent() {
            this.SevenDayAlbumBuilder();
          }
          .tabBar(this.TabBuilder('7天', 2))

          TabContent() {
            this.ThirtyDayAlbumBuilder();
          }
          .tabBar(this.TabBuilder('1个月', 3))
        }
        .barHeight(this.barHeight)
        .scrollable(false)
      }
    }
  }
}