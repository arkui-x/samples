/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { MapCommonConstants } from '../model/CommonConstants';
import { LocationAndPopUpComponent, ThumbTackState } from 'mapthumbtack';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

// 使用image组件模拟地图组件
@Component
export struct MapComponent {
  // Image组件模拟地图，拖拽时修改这些状态变量，调整地图图片位置。地图图片宽高是页面的3倍，初始化xy偏移适当距离使地图显示在合适的位置
  @State mapOffsetX: number = MapCommonConstants.mapInitOffsetX;
  @State mapOffsetY: number = MapCommonConstants.mapInitOffsetY;
  // 保存拖拽前xy的偏移位置
  private mapPoxX: number = 0;
  private mapPoxY: number = 0;
  // 设置地图组件的响应手势的区域
  @Consume mapResponseRegionHeight: number;

  @State thumbTackState: ThumbTackState = ThumbTackState.EMPTY;
  @State address: string | null = null;
  @State tip: string | null = null;
  @State tipBgColor: Color = Color.Green;
  @State addrImage: PixelMap | ResourceStr | DrawableDescriptor | ImageContent | null = null;
  onImageClickCallback: () => void = () => {
    try {
      promptAction.showToast({
        message: $r('app.string.image_click_tip_for_test'),
        duration: 1000
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      console.error(`showToast args error code is ${code}, message is ${message}`);
    }
    ;
  };
  onAddrClickCallback: () => void = () => {
    try {
      promptAction.showToast({
        message: $r('app.string.addr_click_tip_for_test'),
        duration: 1000
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      console.error(`showToast args error code is ${code}, message is ${message}`);
    }
    ;
  };

  aboutToAppear(): void {
    this.thumbTackState = ThumbTackState.LOADING;
    setTimeout(() => {
      let context = getContext(this);
      this.address = context.resourceManager.getStringByNameSync('location_popup_address_for_test');
      this.tip = context.resourceManager.getStringByNameSync('location_tip_for_test');
      this.addrImage = $r('app.media.componentinstancesharedinpages_orange_hotel');
      this.thumbTackState = ThumbTackState.SHOWING;
    }, 1000)
  }

  build() {
    RelativeContainer() {
      Image($r("app.media.componentinstancesharedinpages_map_picture"))
        // 地图图片设置为页面3倍，减少拖拽后显示空白
        .width(MapCommonConstants.mapImageWidth)
        .height(MapCommonConstants.mapImageHeight)
        .offset({x:this.mapOffsetX, y:this.mapOffsetY})
        .id('map')
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Top }
        })
      LocationAndPopUpComponent({
        address: this.address,
        tip: this.tip,
        addrImage: this.addrImage,
        thumbTackState: this.thumbTackState,
        // 25， 设置大头针宽度为25vp
        thumbTackWidth: 25,
        tipBackgroundColor: this.tipBgColor,
        onImageClickCallback: this.onImageClickCallback,
        onAddrClickCallback: this.onAddrClickCallback
      })
        .id('thumbtack')
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Top }
        })
        .height('20%')
        .width('100%')
    }

    .clip(true) // 地图图片超出页面区域时裁剪掉
    .width('100%')
    .height('100%')
    /** TODO: 知识点: responseRegion属性用于设置手势响应区域，
     *  由于地图组件只需要在上层页面显示的区域响应手势事件，其他区域不响应，可通过responseRegion属性设置手势响应区域
     */
    .responseRegion({
      x: 0,
      y: 0,
      width: '100%',
      height: this.mapResponseRegionHeight
    })
    .gesture(
      PanGesture()
        .onActionStart(() => {
          // 拖拽开始先保存拖拽前的偏移
          this.mapPoxX = this.mapOffsetX;
          this.mapPoxY = this.mapOffsetY;

          // 地图移动时收起弹窗，仅显示大头针
          this.thumbTackState = ThumbTackState.EMPTY;
          this.tip = null;
          this.addrImage = null;
        })
        /** 性能知识点: onActionUpdate是系统高频回调函数，
         *  避免在函数中进行冗余或耗时操作。例如应该减少或避免在函数打印日志，会有较大的性能损耗。
         */
        .onActionUpdate((event)=>{
          // 更新地图图片偏移 = 拖拽前偏移 + 拖拽偏移量
          this.mapOffsetX = this.mapPoxX + event.offsetX;
          this.mapOffsetY = this.mapPoxY + event.offsetY;
        })
        .onActionEnd(()=>{
          // 播放大头针加载动画
          this.thumbTackState = ThumbTackState.LOADING;
          this.tip = null;
          this.addrImage = null;
          // 延时1s，模拟获取到地址信息后这个给地址弹窗
          setTimeout(() => {
            let context = getContext(this);
            this.address = context.resourceManager.getStringByNameSync('location_popup_address_for_test');
            this.tip = context.resourceManager.getStringByNameSync('location_tip_for_test');
            this.tipBgColor = Color.Green;
            this.addrImage = $r('app.media.componentinstancesharedinpages_orange_hotel');
            this.thumbTackState = ThumbTackState.SHOWING;
          }, 1000)
        })

    )
  }
}
