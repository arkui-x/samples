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


@Component
export default struct AlbumPage {
  @Link currentPage:string;
  @Link lastPageCount:number;
  @Link isPageLoading:boolean;
  @State albumRes: MyDataSource = AppStorage.get('albumRes') as MyDataSource;
  @State photoArr: MyDataSource = AppStorage.get('photoArr') as MyDataSource;
  @State smallPhotoArr: MyDataSource = AppStorage.get('smallPhotoArr') as MyDataSource;
  @State currentNumber:number = 0;//默认显示全部图片
  @StorageLink('homeTabBottomIndex') homeTabBottomIndex: number = 0;//tab切换index
  @StorageLink('receivedAlbumRes') receivedAlbumRes: albumResFace[] = [];

  /**
   * 根据时间来显示图片，默认为0
   * @param num 0:全部 1:3天 2:7天 3:一个月
   */
  handleChangeTime(num:number) {
    this.currentNumber = num;
    // 获取当前时间戳（以秒为单位）
    let now:number = Math.floor(Date.now() / 1000);
    if(num === 0) {
      let tempArr:Array<string> = [];
      this.receivedAlbumRes.forEach(item => {
        tempArr.push(item.uri);
      });
      this.photoArr.reloadData(tempArr);
    }else if(num === 1) {
      let threeDaysAgo:number = now - (3 * 24 * 60 * 60); // 3天前的时间戳
      let tempArr:Array<string> = [];
      this.receivedAlbumRes.forEach(item => {
        if(item.createTime >= threeDaysAgo) {
          tempArr.push(item.uri);
          console.log('近3天：' + item.uri);
        }
      });
      this.photoArr.reloadData(tempArr);
    }else if(num === 2) {
      let sevenDaysAgo:number = now - (7 * 24 * 60 * 60); // 7天前的时间戳
      let tempArr:Array<string> = [];
      this.receivedAlbumRes.forEach(item => {
        if(item.createTime >= sevenDaysAgo) {
          tempArr.push(item.uri);
          console.log('近7天：' + item.uri);
        }
      });
      this.photoArr.reloadData(tempArr);
    }else if(num === 3) {
      let oneMonthAgo:number = now - (30 * 24 * 60 * 60); // 1个月前的时间戳（假设每月30天）
      let tempArr:Array<string> = [];
      this.receivedAlbumRes.forEach(item => {
        if(item.createTime >= oneMonthAgo) {
          tempArr.push(item.uri);
          console.log('近一个月：' + item.uri);
        }
      });
      this.photoArr.reloadData(tempArr);
    }
    this.smallPhotoArr.reloadData(new Array<string>().concat(Constants.CACHE_IMG_LIST,this.photoArr.getAllData(),Constants.CACHE_IMG_LIST));
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column,justifyContent:FlexAlign.Start }) {
        if(this.homeTabBottomIndex === 1 || this.currentPage !== 'listPage') {
          TopNavigation({ title:'相册',currentPage:this.currentPage })
        }
        Stack() {
          Column() {
            ListPage({ currentPage: this.currentPage,photoArr:this.photoArr,lastPageCount:this.lastPageCount,isPageLoading:this.isPageLoading })
          }
          .zIndex(this.currentPage === 'listPage' ? 2 : 1)
          .opacity(this.currentPage === 'listPage' ? 1 : 0)
          .width(Constants.FULL_PERCENT)
          .height(Constants.FULL_PERCENT)

          Column() {
            DetailListPage({ currentPage: this.currentPage,photoArr:this.photoArr,smallPhotoArr:this.smallPhotoArr })
          }
          .zIndex(this.currentPage === 'listPage' ? 1 : 2)
          .opacity(this.currentPage === 'listPage' ? 0 : 1)
          .width(Constants.FULL_PERCENT)
          .height(Constants.FULL_PERCENT)

        }
        .flexBasis(1)
        .flexGrow(1)
        if(this.homeTabBottomIndex === 0 && this.currentPage === 'listPage') {
          Row() {
            Button('全部', { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(this.currentNumber === 0 ? 0x317aff : 0xcfcfcf)
              .width('25%')
              .height(40)
              .onClick(() => {
                this.handleChangeTime(0);
              })
            Button('3天', { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(this.currentNumber === 1 ? 0x317aff : 0xcfcfcf)
              .width('25%')
              .height(40)
              .onClick(() => {
                this.handleChangeTime(1);
              })
            Button('7天', { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(this.currentNumber === 2 ? 0x317aff : 0xcfcfcf)
              .width('25%')
              .height(40)
              .onClick(() => {
                this.handleChangeTime(2);
              })
            Button('一个月', { type: ButtonType.Capsule, stateEffect: false })
              .backgroundColor(this.currentNumber === 3 ? 0x317aff : 0xcfcfcf)
              .width('25%')
              .height(40)
              .onClick(() => {
                this.handleChangeTime(3);
              })
          }.height(60).backgroundColor('#cfcfcf')
        }
      }
    }
  }
}