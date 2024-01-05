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
import TopNavigation from './components/TopNavigation';
import MyDataSource from '../bean/MyDataSource';


@Entry
@Component
struct DetailPage {
  scroller: Scroller = new Scroller();
  photoArr: MyDataSource = AppStorage.get('photoArr') as MyDataSource;
  preOffsetX: number = 0;
  preOffsetY: number = 0;
  currentScale: number = 1;
  @State deviceWidth: number = Constants.DEFAULT_WIDTH;
  @State smallImgWidth: number = (Constants.DEFAULT_WIDTH - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) /
  Constants.SHOW_COUNT;
  @State imageWidth: number = this.deviceWidth + this.smallImgWidth;
  @StorageLink('selectedIndex') selectedIndex: number = 0;
  @StorageLink('currentPage') currentPage: string = (router.getParams() as Record<string, string>)[`currentPage`];
  @State isScaling: boolean = true;
  @State imgScale: number = 1;
  @State imgOffSetX: number = 0;
  @State imgOffSetY: number = 0;
  @State bgOpacity: number = 0;

  aboutToAppear() {
    console.log('selectedIndex:' + this.selectedIndex);
    console.log(this.photoArr.getData(this.selectedIndex));
    let density: number = AppStorage.get('density') || 2.5;
    let displayClass: display.Display = display.getDefaultDisplaySync();
    let width = displayClass?.width / density ?? Constants.DEFAULT_WIDTH;
    this.deviceWidth = width;
    this.smallImgWidth = (width - Constants.LIST_ITEM_SPACE * (Constants.SHOW_COUNT - 1)) / Constants.SHOW_COUNT;
    this.imageWidth = this.deviceWidth + this.smallImgWidth;
  }

  resetImg(): void {
    this.imgScale = 1;
    this.currentScale = 1;
    this.preOffsetX = 0;
    this.preOffsetY = 0;
  }

  handlePanEnd(): void {
    let initOffsetX = (this.imgScale - 1) * this.imageWidth + this.smallImgWidth;
    if (Math.abs(this.imgOffSetX) > initOffsetX) {
      if (this.imgOffSetX > initOffsetX && this.selectedIndex > 0) {
        this.selectedIndex -= 1;
      } else if (this.imgOffSetX < -initOffsetX && this.selectedIndex < (this.photoArr.totalCount() - 1)) {
        this.selectedIndex += 1;
      }
      this.isScaling = false;
      this.resetImg();
      this.scroller.scrollTo({ xOffset: this.selectedIndex * this.imageWidth, yOffset: 0 });
    }
  }

  build() {
    Column() {
      TopNavigation({ title: '相册', currentPage: this.currentPage })
      Stack() {
        List({ scroller: this.scroller, initialIndex: this.selectedIndex }) {
          LazyForEach(this.photoArr, (img: Resource) => {
            ListItem() {
              Image(img)
                .objectFit(ImageFit.Contain)
                .onClick(() => router.back())
            }
            .gesture(GestureGroup(GestureMode.Exclusive,
              PinchGesture({ fingers: Constants.DOUBLE_NUMBER })
                .onActionStart(() => {
                  this.resetImg();
                  this.isScaling = true;
                  this.imgOffSetX = 0;
                  this.imgOffSetY = 0;
                })
                .onActionUpdate((event?: GestureEvent) => {
                  if (event) {
                    this.imgScale = this.currentScale * event.scale;
                  }
                })
                .onActionEnd(() => {
                  if (this.imgScale < 1) {
                    this.resetImg();
                    this.imgOffSetX = 0;
                    this.imgOffSetY = 0;
                  } else {
                    this.currentScale = this.imgScale;
                  }
                }), PanGesture()
                .onActionStart(() => {
                  this.resetImg();
                  this.isScaling = true;
                })
                .onActionUpdate((event?: GestureEvent) => {
                  if (event) {
                    this.imgOffSetX = this.preOffsetX + event.offsetX;
                    this.imgOffSetY = this.preOffsetY + event.offsetY;
                  }
                })
            ))
            .padding({
              left: this.smallImgWidth / Constants.DOUBLE_NUMBER,
              right: this.smallImgWidth / Constants.DOUBLE_NUMBER
            })
            .width(this.imageWidth)
          }, (item: Resource) => JSON.stringify(item))
        }
        .cachedCount(15)
        .onScrollStop(() => {
          let currentIndex = Math.round(((this.scroller.currentOffset().xOffset as number) +
            (this.imageWidth / Constants.DOUBLE_NUMBER)) / this.imageWidth);
          this.selectedIndex = currentIndex;
          this.scroller.scrollTo({ xOffset: currentIndex * this.imageWidth, yOffset: 0 });
        })
        .width(Constants.FULL_PERCENT)
        .height(Constants.FULL_PERCENT)
        .listDirection(Axis.Horizontal)
        .visibility(this.isScaling ? Visibility.Hidden : Visibility.Visible)

        Row() {
          Image(this.photoArr.getData(this.selectedIndex) as string)
            .position({ x: this.imgOffSetX, y: this.imgOffSetY })
            .scale({ x: this.imgScale, y: this.imgScale })
            .objectFit(ImageFit.Contain)
            .onClick(() => router.back())
        }
        .gesture(GestureGroup(GestureMode.Exclusive,
          PinchGesture({ fingers: Constants.DOUBLE_NUMBER })
            .onActionUpdate((event?: GestureEvent) => {
              if (event) {
                this.imgScale = this.currentScale * event.scale;
              }
            })
            .onActionEnd(() => {
              if (this.imgScale < 1) {
                this.resetImg();
                this.imgOffSetX = 0;
                this.imgOffSetY = 0;
              } else {
                this.currentScale = this.imgScale;
              }
            }),
          PanGesture()
            .onActionStart(() => {
              this.preOffsetX = this.imgOffSetX;
              this.preOffsetY = this.imgOffSetY;
            })
            .onActionUpdate((event?: GestureEvent) => {
              if (event) {
                this.imgOffSetX = this.preOffsetX + event.offsetX;
                this.imgOffSetY = this.preOffsetY + event.offsetY;
              }
            })
            .onActionEnd(() => this.handlePanEnd())
        ))
        .padding({
          left: this.smallImgWidth / Constants.DOUBLE_NUMBER,
          right: this.smallImgWidth / Constants.DOUBLE_NUMBER
        })
        .width(Constants.FULL_PERCENT)
        .height(Constants.FULL_PERCENT)
        .visibility(this.isScaling ? Visibility.Visible : Visibility.Hidden)
      }
      .width(this.imageWidth)
      .height(Constants.FULL_PERCENT)
      .backgroundColor($r('app.color.detail_background'))
    }
  }
}




