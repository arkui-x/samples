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
import TopNavigation from './components/TopNavigation';
import MyDataSource from '../bean/MyDataSource';

@Component
export default struct XcAlbumPage {
  @Link currentPage: string;
  @Link lastPageCount: number;
  @Link isPageLoading: boolean;
  @State typeAlbumArr: MyDataSource = AppStorage.get('typeAlbumArr') as MyDataSource;
  @State smallPhotoArr: MyDataSource = AppStorage.get('smallPhotoArr') as MyDataSource;

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column }) {
        TopNavigation({ title: '相册', currentPage: this.currentPage })
        Stack() {
          Column() {
            ListPage({
              currentPage: this.currentPage,
              photoArr: this.typeAlbumArr,
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
              photoArr: this.typeAlbumArr,
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
    }
  }
}