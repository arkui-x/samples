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
import { BreakpointConstants, CommonConstants as Const } from '@ohos/utils';
import { ZonesConstants as ZoneConst } from '../constants/ZonesConstants';
import ZonesViewModel from '../viewmodel/ZonesViewModel';

@Entry
@Component
export struct Zones {
  changedIndex: boolean = true;
  zonesList: ResourceStr[] = ZonesViewModel.getZonesListThumbnail();
  @StorageLink("aheadIndex") aheadIndex: number = ZoneConst.HALF_COUNT;
  @State marginBottom: number = 0;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';

  getImgCoefficients(index: number): number {
    let coefficient = this.aheadIndex - index;
    let tempCoefficient = Math.abs(coefficient);
    if (tempCoefficient <= ZoneConst.HALF_COUNT) {
      return coefficient;
    }
    let dataLength = this.zonesList.length;
    let tempOffset = dataLength - tempCoefficient;
    if (tempOffset <= ZoneConst.HALF_COUNT) {
      if (coefficient > 0) {
        return -tempOffset;
      }
      return tempOffset;
    }
    return 0;
  }

  getOffSetY(index: number): number {
    let offsetIndex = this.getImgCoefficients(index);
    let tempOffset = Math.abs(offsetIndex);
    let offsetY = this.marginBottom / (tempOffset + 1);
    if (tempOffset === 1) {
      offsetY += -offsetIndex * ZoneConst.MAX_OFFSET_Y;
    } else if (tempOffset == ZoneConst.HALF_COUNT) {
      offsetY += -offsetIndex * (ZoneConst.MAX_OFFSET_Y - ZoneConst.OFFSET_COEFFICIENTS);
    }
    return offsetY;
  }

  startAnimation(isUp: boolean): void {
    animateTo({
      duration: Const.SWIPER_DURATION,
    }, () => {
      let dataLength = this.zonesList.length;
      let tempIndex = isUp ? this.aheadIndex + 1 : dataLength + this.aheadIndex - 1;
      this.aheadIndex = tempIndex % dataLength;
      this.marginBottom = 0;
    });
  }

  handlePanGesture(offsetY: number): void {
    if (Math.abs(offsetY) < ZoneConst.MAX_MOVE_OFFSET) {
      this.marginBottom = offsetY;
    } else {
      if (this.changedIndex) {
        return;
      }
      this.changedIndex = true;
      this.startAnimation(offsetY < 0);
    }
  }

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          ForEach(this.zonesList, (item: ResourceStr, index: number) => {
            Row() {
              Image(item)
                .objectFit(ImageFit.Cover)
                .borderRadius($r('app.float.common_border_radius'))
                .margin({ bottom: Const.SHADOW_RADIUS })
                .opacity(1 - Math.min(ZoneConst.HALF_COUNT,
                  Math.abs(this.getImgCoefficients(index))) * ZoneConst.OPACITY_COEFFICIENTS)
            }
            .width(index != this.aheadIndex && this.getImgCoefficients(index) === 0
              ? Const.SWIPER_DEFAULT_WIDTH
              : `${ZoneConst.ITEM_WIDTH - ZoneConst.OFFSET_COEFFICIENTS * Math.abs(this.getImgCoefficients(index))}%`)
            .aspectRatio(Const.SWIPER_ASPECT_RATIO)
            .borderRadius($r('app.float.common_border_radius'))
            .offset({ x: 0, y: this.getOffSetY(index) })
            .zIndex(index != this.aheadIndex && this.getImgCoefficients(index) === 0
              ? 0 : ZoneConst.HALF_COUNT - Math.abs(this.getImgCoefficients(index)))
            .blur(ZoneConst.OFFSET_COEFFICIENTS * Math.abs(this.getImgCoefficients(index)))
          }, (item: ResourceStr) => JSON.stringify(item.toString()))
        }
        .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? Const.FULL_PERCENT : '50%')
        .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? Const.FULL_PERCENT : '33%')
        .margin({ top: Const.SHADOW_RADIUS / Const.DOUBLE_NUM })
        .alignContent(Alignment.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/IntroductionPage',
            params: { id: ZonesViewModel.getZonesListId()[this.aheadIndex] }
          })
          AppStorage.set<number>('imageHeight', Const.FULL_PERCENT_NUMBER);
          AppStorage.set<number>('arrowIconOpacity', Const.OPACITY_MAX);
        })
        .gesture(
          PanGesture({ direction: PanDirection.Vertical })
            .onActionStart((event: GestureEvent) => {
              this.changedIndex = false;
              this.handlePanGesture(event.offsetY);
            })
            .onActionUpdate((event: GestureEvent) => {
              this.handlePanGesture(event.offsetY);
            })
            .onActionEnd(() => {
              this.marginBottom = 0;
            })
        )
      }.width('100%')
    }.height('100%')
  }
}