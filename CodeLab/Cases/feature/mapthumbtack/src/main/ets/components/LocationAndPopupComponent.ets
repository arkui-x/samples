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

import { ThumbTackComponent } from '../components/ThumbTackComponent';
import { ThumbTackCommonConstants, ThumbTackState } from '../model/CommonConstants';
import { AddressPopUpComponent } from '../components/AddressPopUpComponent';

/**
 * 定位地址弹窗组件
 * @param thumbTackState 用于设置大头针状态，ThumbTackState.EMPTY、ThumbTackState.LOADING、ThumbTackState.SHOWING。
 * @param address 组件处于ThumbTackState.SHOWING状态时，需要显示的地址文本；组件处于其他状态时，需设置为null。
 * @param tip 组件处于ThumbTackState.SHOWING状态时，需要显示的当前地址的一些提示，组件处于其他状态或无提示文本时，需设置为null。
 * @param tipBackgroundColor 组件处于ThumbTackState.SHOWING状态时，提示文本的背景色。
 * @param addrImage 组件处于ThumbTackState.SHOWING状态时，要展示的地址实景图，组件处于其他状态或无实景图时，需设置为null。
 * @param onImageClickCallback 实景图被点击时回调。
 * @param onAddrClickCallback 地址被点击时回调。
 * @param thumbTackWidth 用于设置大头针的宽度。
 * @param animationFinishCallback 大头针跳动动画结束时回调。
 */
@Component
export struct LocationAndPopUpComponent {
  @Link @Watch('onAddrStateChanged') thumbTackState: ThumbTackState;
  @Link address: string | null;
  @Link tip: string | null;
  @Link tipBackgroundColor: Color;
  @Link addrImage: PixelMap | ResourceStr | DrawableDescriptor | ImageContent | null;
  public onImageClickCallback: () => void = () => {
  };
  public onAddrClickCallback: () => void = () => {
  };
  // 20, 大头针默认宽度20vp
  public thumbTackWidth: number = 20;
  // 大头帧跳动动画结束回调函数，使用者根据需求设置该回调，默认空
  public animationFinishCallback: () => void = () => {
  };
  @State private isPopUpShow: boolean = false;

  onAddrStateChanged(): void {
    if (this.address === '' || this.thumbTackState !== ThumbTackState.SHOWING) {
      this.isPopUpShow = false;
    }
  }

  build() {
    RelativeContainer() {
      if (this.isPopUpShow) {
        AddressPopUpComponent({
          addressDescription: this.address,
          addressTip: this.tip,
          addressTipBackgroundColor: this.tipBackgroundColor,
          addrImage: this.addrImage,
          onImageClickCallback: this.onImageClickCallback,
          onAddrClickCallback: this.onAddrClickCallback
        })
          .id('AddressPopUpComponent')
          .zIndex(2)
          .margin({
            bottom: this.thumbTackWidth *
              (ThumbTackCommonConstants.TACK_POST_HEIGHT_RATIO - ThumbTackCommonConstants.TACK_HAT_BRIM_WIDTH_RATIO)
          })
          .alignRules({
            bottom: { anchor: 'ThumbTackComponent', align: VerticalAlign.Bottom },
            middle: { anchor: 'ThumbTackComponent', align: HorizontalAlign.Center }
          })
          .transition(
            TransitionEffect
              .scale({
                x: 0,
                y: 0,
                centerX: '50%',
                centerY: '100%'
              })
              .animation({
                // 动画持续300ms
                duration: 300,
                curve: Curve.Friction,
                onFinish: () => {
                  this.animationFinishCallback();
                }
              })
          )
      }
      ThumbTackComponent({
        thumbTackState: this.thumbTackState,
        thumbTackWidth: this.thumbTackWidth,
        animationFinishCallback: () => {
          if (this.address !== '' && this.thumbTackState === ThumbTackState.SHOWING) {
            this.isPopUpShow = true;
          }
        }
      })
        .id('ThumbTackComponent')
    }
    .backgroundColor(Color.Transparent)
    .hitTestBehavior(HitTestMode.Transparent)
    .height('100%')
    .width('100%')
  }
}