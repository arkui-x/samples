/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import { CommonConstants as Const, DeviceScreen } from '@ohos/utils';
import { SwiperDataSource, ZonesItem, zonesViewModel } from '@ohos/zones';
import { BuildListItem, StyleListItem, SubTitleItem, SwiperListItem } from '@ohos/main';

interface TitleIconInterface {
  src: Resource,
  scale: number
}

interface RouterParmaInterface {
  id: number
}

@Entry
@Component
struct IntroductionPage {
  @Provide('introductionData') introductionData: ZonesItem = zonesViewModel.getZonesList()[0];
  @StorageLink("imageHeight") imageHeight: number = Const.FULL_PERCENT_NUMBER;
  @StorageLink("arrowIconOpacity") arrowIconOpacity: number = Const.OPACITY_MAX;
  @StorageLink("currentZoneId") currentZoneId: number = 0;
  @StorageLink("offsetSum") offsetSum: number = 0;
  @StorageLink('isContinuation') isContinuation: string = Const.NO_CONTINUATION;
  @StorageLink('cardID') cardID: number = -1;
  @State zoneListSwiper: SwiperDataSource = new SwiperDataSource([]);
  @State screenHeight: number = 0;
  @State listPosition: number = Const.LIST_POSITION_BEGIN;
  @State isShowReplay: Array<boolean> = [];
  @State currentListIndex: number = Const.LIST_POSITION_BEGIN;
  private scrollerForList: Scroller = new Scroller();
  @State scaleIcon: Array<number> = [Const.OPACITY_MAX, Const.OPACITY_MIN, Const.OPACITY_MIN];
  @State iconTitle: string = Const.ICON_SUBTITLE_ARRAY[0];
  @State isReachStart: boolean = false;
  @State screenDensityDPI: number = 0;
  @State geographicPicType: string = Const.GEOGRAPHY_LIGHT;
  @State buildingType: string = Const.BUILDING_TEXT;

  @Builder
  TitleIcon($$: TitleIconInterface) {
    Column() {
      Image($$.src)
        .width($r('app.float.title_icon_width'))
        .height($r('app.float.title_icon_height'))
        .scale({ x: $$.scale })
        .opacity($$.scale)
        .animation({
          duration: Const.TITLE_ICON_ANIMATION_DURATION,
          curve: Curve.EaseOut
        })
    }
  }

  @Builder
  StickyHeader() {
    Column() {
      Image(this.introductionData.subPicBottom)
        .height($r('app.float.picture_bottom_height'))
        .objectFit(ImageFit.Fill)
        .width(Const.FULL_SIZE)
        .backgroundColor(this.introductionData.backgroundColor)
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.introductionData.titleIcon)
          .height($r('app.float.introduction_title_icon_height'))
          .width($r('app.float.introduction_title_icon_width'))
          .margin({ bottom: $r('app.float.title_icon_margin_bottom') })

        this.TitleIcon({ src: $r('app.media.ic_design_style'), scale: this.scaleIcon[0] })
        this.TitleIcon({ src: $r('app.media.ic_building'), scale: this.scaleIcon[1] })
        this.TitleIcon({ src: $r("app.media.ic_geography_icon"), scale: this.scaleIcon[2] })
      }
      .width(Const.FULL_SIZE)
      .height($r('app.float.stack_container_height'))

      Text(this.iconTitle)
        .fontSize($r('app.float.font_size_smaller'))
        .height($r('app.float.font_height_smaller'))
        .fontColor($r('app.color.font_color_black'))
        .opacity(Const.FONT_COLOR_OPACITY_NORMAL)
        .margin({ bottom: $r('app.float.icon_title_margin_bottom') })
        .fontWeight(FontWeight.Bold)
    }
    .width(Const.FULL_SIZE)
    .backgroundColor($r('app.color.introduction_page_color'))
    .height(Const.STICKY_HEIGHT)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  StickyFooter() {
    Column()
      .height($r('app.float.introduction_page_padding_bottom'))
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          List({ scroller: this.scrollerForList }) {
            ListItem() {
              SwiperListItem({
                imageHeight: this.imageHeight,
                arrowIconOpacity: this.arrowIconOpacity,
                zoneListSwiper: this.zoneListSwiper
              })
            }

            ListItem() {
              SubTitleItem()
            }

            ListItemGroup({ header: this.StickyHeader(), footer: this.StickyFooter() }) {
              ListItem() {
                StyleListItem()
              }

              ListItem() {
                BuildListItem({ type: this.buildingType })
              }

              ListItem() {
                BuildListItem({ type: this.geographicPicType })
              }
            }
          }
          .width(Const.FULL_SIZE)
          .height(Const.FULL_SIZE)
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
          .sticky(StickyStyle.Header)
          .onReachStart(() => {
            this.resetParameters();
          })
          .onScrollIndex((start) => {
            this.currentListIndex = start;
          })
          .onReachEnd(() => {
            this.listPosition = Const.LIST_POSITION_END;
          })
          .onScroll(() => {
            this.changeTitleIcon();
          })
          .onScrollFrameBegin((offset: number, state: ScrollState) => {
            let realOffset = this.controlImageScale(offset, state);
            return { offsetRemain: realOffset };
          })
        }
        .height(Const.FULL_SIZE)

        Image($r('app.media.ic_home_back'))
          .height($r('app.float.page_icon_size'))
          .width($r('app.float.page_icon_size'))
          .margin({ bottom: $r('app.float.up_icon_margin_bottom'), left: '220vp' })
          .onClick(() => {
            router.back();
          })

        Image($r('app.media.ic_up_icon'))
          .height($r('app.float.page_icon_size'))
          .width($r('app.float.page_icon_size'))
          .margin({ bottom: $r('app.float.up_icon_margin_bottom'), left: $r('app.float.page_icon_margin_vertical') })
          .onClick(() => {
            this.scrollToTop();
          })
      }
      .backgroundColor($r('app.color.introduction_page_color'))
      .height(Const.FULL_SIZE)
    }
    .height(Const.FULL_SIZE)
  }

  onPageShow() {
    if (this.isContinuation === 'true') {
      this.scrollerForList.scrollBy(0, this.offsetSum);
      this.changeTitleIcon();
    }
  }

  aboutToAppear() {
    this.initializeZoneId();
    this.getIntroductionData();
    this.getLazySwiperData();
    this.screenHeight = DeviceScreen.getDeviceHeight();
  }

  onPageHide() {
    AppStorage.set<string>('isContinuation', 'false');
  }

  /**
   * Get the swiper data for lazy load.
   */
  getLazySwiperData() {
    let list: ZonesItem[] = [];
    zonesViewModel.getZonesList().forEach((item) => {
      list.push(item);
    })
    this.zoneListSwiper = new SwiperDataSource(list);
  }

  /**
   * Initialize the zone id accord to the type of jumping to this page.
   */
  initializeZoneId() {
    if (this.cardID !== -1) {
      this.currentZoneId = this.cardID;
    } else if (this.isContinuation === 'false' || router.getParams() !== undefined) {
      this.currentZoneId = (router.getParams() as RouterParmaInterface).id;
    }
  }

  /**
   * Get the introduction by currentZoneId.
   */
  getIntroductionData() {
    let zonesListId = zonesViewModel.getZonesListId();
    let index = zonesListId.indexOf(this.currentZoneId);
    this.introductionData = zonesViewModel.getZonesByIndex(index);
  }

  /**
   * Reset all parameters if the list arrive begin by animation.
   */
  resetParameters() {
    this.listPosition = Const.LIST_POSITION_BEGIN;
    if (this.listPosition === Const.LIST_POSITION_BEGIN && this.isReachStart) {
      this.imageHeight = Const.FULL_PERCENT_NUMBER;
      this.arrowIconOpacity = Const.OPACITY_MAX;
    }
    this.isReachStart = false;
  }

  /**
   * Click the up arrow scroll to the beginning.
   */
  scrollToTop() {
    if (this.listPosition !== Const.LIST_POSITION_BEGIN) {
      this.scrollerForList.scrollTo({
        xOffset: 0,
        yOffset: Const.SCROLL_UP_TOP_THRESHOLD,
        animation: {
          duration: this.offsetSum / Const.OFFSET_DIVIDE_RATIO,
          curve: Curve.Linear,
        }
      })
      this.isReachStart = true;
    } else {
      this.imageHeight = Const.FULL_PERCENT_NUMBER;
      this.arrowIconOpacity = Const.OPACITY_MAX;
    }
  }

  changeTitleIcon() {
    let imageHeightVP = (this.screenHeight * this.imageHeight) / Const.FULL_PERCENT_NUMBER;
    let firstStarLine = imageHeightVP + Const.SECOND_LIST_ITEM_HEIGHT +
    Const.FIXED_ITEM_HEIGHT - Const.STAR_ICON_MARGIN;
    let secondStarLine = firstStarLine + Const.FIXED_ITEM_HEIGHT;
    let thirdStarLine = secondStarLine + Const.FIXED_ITEM_HEIGHT;
    this.offsetSum = this.scrollerForList.currentOffset().yOffset;

    // Set the listPosition.
    if (this.offsetSum > Const.OFFSET_SUM_THRESHOLD) {
      this.listPosition = Const.LIST_POSITION_MIDDLE;
    }

    if (this.offsetSum > firstStarLine + Const.FIXED_ITEM_HEIGHT / 2) {
      this.geographicPicType = Const.GEOGRAPHY_LIGHT;
    }

    if (this.offsetSum <= firstStarLine + Const.FIXED_ITEM_HEIGHT / 2) {
      this.geographicPicType = Const.GEOGRAPHY_DARK;
    }
    // Change icons opacity by the sum of offset.
    if (this.offsetSum <= firstStarLine) {
      this.iconTitle = Const.ICON_SUBTITLE_ARRAY[0];
      this.scaleIcon = [Const.OPACITY_MAX, Const.OPACITY_MIN, Const.OPACITY_MIN];
    }
    if (this.offsetSum > firstStarLine && this.offsetSum < secondStarLine) {
      this.iconTitle = Const.ICON_SUBTITLE_ARRAY[1];
      this.scaleIcon = [Const.OPACITY_MIN, Const.OPACITY_MAX, Const.OPACITY_MIN];
    }
    if (this.offsetSum >= secondStarLine && this.offsetSum < thirdStarLine) {
      this.iconTitle = Const.ICON_SUBTITLE_ARRAY[2];
      this.scaleIcon = [Const.OPACITY_MIN, Const.OPACITY_MIN, Const.OPACITY_MAX];
    }
  }

  /**
   * Control the image scale.
   *
   * @param this
   * @param offset
   * @param state
   * @returns real list offset.
   */
  controlImageScale(offset: number, state: ScrollState): number {
    if (offset > 0 && this.imageHeight > Const.MIN_IMAGE_HEIGHT) {
      // Scale down the image by offset.
      let offsetHeight = (Math.abs(offset) * Const.FULL_PERCENT_NUMBER) / Number(this.screenHeight);
      let heightOffset = this.imageHeight - Const.MIN_IMAGE_HEIGHT > offsetHeight ?
        offsetHeight : this.imageHeight - Const.MIN_IMAGE_HEIGHT;
      this.imageHeight = this.imageHeight - heightOffset;
      this.arrowIconOpacity = this.arrowIconOpacity -
        heightOffset / (Const.FULL_PERCENT_NUMBER - Const.MIN_IMAGE_HEIGHT);
      return 0;
    }
    if (this.listPosition == Const.LIST_POSITION_BEGIN && offset < 0
      && this.imageHeight < Const.FULL_PERCENT_NUMBER) {
      // Scale up the image by offset.
      let offsetHeight = (Math.abs(offset) * Const.FULL_PERCENT_NUMBER) / Number(this.screenHeight);
      let heightOffset = Const.FULL_PERCENT_NUMBER - this.imageHeight > offsetHeight ?
        offsetHeight : Const.FULL_PERCENT_NUMBER - this.imageHeight;
      this.imageHeight = this.imageHeight + heightOffset;
      this.arrowIconOpacity = this.arrowIconOpacity +
        heightOffset / (Const.FULL_PERCENT_NUMBER - Const.MIN_IMAGE_HEIGHT);
      return 0;
    }
    if (state === ScrollState.Scroll && offset < Const.LIST_SCROLL_DOWN_THRESHOLD
      && this.imageHeight === Const.FULL_PERCENT_NUMBER) {
      return 0;
    }
    return offset;
  }
}