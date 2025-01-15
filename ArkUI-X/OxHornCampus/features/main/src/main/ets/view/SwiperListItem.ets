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

import { CommonConstants as Const } from '@ohos/utils';
import { SwiperDataSource, ZonesItem, zonesViewModel } from '@ohos/zones';

@Component
export default struct SwiperListItem {
  private swiperController: SwiperController = new SwiperController();
  @Prop imageHeight: number;
  @Prop arrowIconOpacity: number;
  @Consume('introductionData') introductionData: ZonesItem;
  @StorageLink("currentZoneId") currentZoneId: number = 0;
  zoneListSwiper: SwiperDataSource = new SwiperDataSource([])

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Swiper(this.swiperController) {
        LazyForEach(this.zoneListSwiper, (item: ZonesItem) => {
          Image(item.swiperPic)
            .width(Const.FULL_SIZE)
            .height(this.imageHeight + '%')
            .objectFit(ImageFit.Cover)
        }, (item: ZonesItem) => JSON.stringify(item.id))
      }
      .index(this.currentZoneId)
      .indicator(this.imageHeight < Const.FULL_PERCENT_NUMBER ?
        false : new DotIndicator().bottom($r('app.float.swiper_indicator_margin_bottom')))
      .loop(true)
      .cachedCount(Const.IMAGE_SWIPER_CACHE_COUNT)
      .curve(Curve.EaseOut)
      .disableSwipe(this.imageHeight < Const.FULL_PERCENT_NUMBER ? true : false)
      .onChange((index) => {
        this.currentZoneId = index;
        this.getIntroductionData();
      })

      Text(this.introductionData.title)
        .fontSize($r('app.float.font_size_largest'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.font_color_white'))
        .opacity(this.arrowIconOpacity)
        .width(Const.FULL_SIZE)
        .textAlign(TextAlign.Center)
        .height($r('app.float.zone_name_container_height'))
        .margin({ bottom: $r('app.float.zone_name_margin_bottom') })
        .animation({
          duration: Const.ANIMATION_DURATION_NORMAL,
          curve: Curve.EaseOut,
        })
      Image($r('app.media.ic_arrow_down'))
        .height($r('app.float.arrow_down_height'))
        .width($r('app.float.arrow_down_width'))
        .margin({ bottom: $r('app.float.arrow_down_margin_bottom') })
        .opacity(this.arrowIconOpacity)
        .animation({
          duration: Const.ANIMATION_DURATION_NORMAL,
          curve: Curve.EaseOut,
        })
    }
  }

  // Get the introduction by currentZoneId.
  getIntroductionData() {
    let zonesListId = zonesViewModel.getZonesListId();
    let index = zonesListId.indexOf(this.currentZoneId);
    this.introductionData = zonesViewModel.getZonesByIndex(index);
  }
}