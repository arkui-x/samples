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

import { AddressPopupCommonConstants } from '../model/CommonConstants';
import { AppRouter } from "routermodule";

/**
 * 地址弹窗组件
 * @param addressDescription 弹框中需要显示的地址文本；设置为null时弹框不显示。
 * @param addressTip 弹框中需要显示的当前地址的一些提示，设置为null弹框左上角提示区域不展示。
 * @param tipBackgroundColor 提示文本的背景色。
 * @param addrImage 弹窗中需要展示的地址实景图，设置为null，弹窗中不展示实景图区域。
 * @param onImageClickCallback 实景图被点击时回调。
 * @param onAddrClickCallback 地址被点击时回调。
 * @param thumbTackWidth 用于设置大头针的宽度。
 * @param animationFinishCallback 大头针跳动动画结束时回调。
 */
@AppRouter({ name: "mapthumbtack/AddressPopUpComponent" })
@Component
export struct AddressPopUpComponent {
  @Link @Watch('onAddrChanged') addressDescription: string | null;
  @Link addressTip: string | null;
  @Link addressTipBackgroundColor: Color;
  @Link addrImage: PixelMap | ResourceStr | DrawableDescriptor | ImageContent | null;
  public onImageClickCallback: () => void = () => {
  };
  public onAddrClickCallback: () => void = () => {
  };
  @State private addrCompWidth: number = 0;
  private pathCmd: string = AddressPopupCommonConstants.TIP_AREA_PATH;

  private calculateTextCompWidth(text: string, fontsize: number): number {
    let addrTextWidth = this.getUIContext().getMeasureUtils().measureText({
      textContent: text,
      fontSize: fontsize
    });

    let textCompWidth = 0;

    if (addrTextWidth < vp2px(AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH * 2)
      && addrTextWidth > vp2px(AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH)) {
      textCompWidth = px2vp(addrTextWidth / AddressPopupCommonConstants.ADDR_TEXT_MAX_LINES);
    } else if (addrTextWidth < vp2px(AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH)
      && addrTextWidth > vp2px(AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH * 0.8)) {
      textCompWidth = AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH * 0.8;
    } else if (addrTextWidth < vp2px(AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH * 0.8)) {
      textCompWidth = px2vp(addrTextWidth);
    } else {
      textCompWidth = AddressPopupCommonConstants.POPUP_COMP_MAX_WIDTH;
    }

    return textCompWidth;
  }

  onAddrChanged(): void {
    this.addrCompWidth =
      this.calculateTextCompWidth(this.addressDescription as string, AddressPopupCommonConstants.ADDR_FONT_SIZE);
  }

  aboutToAppear(): void {
    this.addrCompWidth =
      this.calculateTextCompWidth(this.addressDescription as string, AddressPopupCommonConstants.ADDR_FONT_SIZE);
  }

  build() {
    RelativeContainer() {
      if (this.addressTip !== '' && this.addressTip !== null) {
        Row() {
          Text(this.addressTip)
            .fontSize(AddressPopupCommonConstants.TIP_FONT_SIZE)
            .fontColor(Color.White)
            .maxLines(1)
            .borderRadius({ topLeft: AddressPopupCommonConstants.POPUP_COMP_RADIUS })
            .padding({
              left: AddressPopupCommonConstants.TIP_AREA_LEFT_PADDING,
            })
            .backgroundColor(this.addressTipBackgroundColor)
            .height(AddressPopupCommonConstants.TIP_AREA_HEIGHT)
          Path({
            width: AddressPopupCommonConstants.TIP_AREA_HEIGHT,
            height: AddressPopupCommonConstants.TIP_AREA_HEIGHT,
            commands: this.pathCmd
          })
            .fill(this.addressTipBackgroundColor)
            .strokeOpacity(0)
        }
        .id('tipDescription')
        .zIndex(0)
        .alignRules({
          bottom: { anchor: 'addressDescription', align: VerticalAlign.Top },
          left: { anchor: 'addressDescription', align: HorizontalAlign.Start }
        })
        // 2, 向下偏移距离等于地址组件左上角圆角半径
        .margin({ bottom: -2 })
        .transition(
          TransitionEffect.asymmetric(
            TransitionEffect.translate({ y: AddressPopupCommonConstants.TIP_AREA_HEIGHT })
              .animation({
                // 300, animation duration time 300ms
                duration: 300,
                curve: Curve.Friction,
              }).combine(TransitionEffect.OPACITY),
            null
          )
        )
      }
      Row() {
        if (this.addrImage !== '' && this.addrImage !== null) {
          Image(this.addrImage)
            .height(AddressPopupCommonConstants.ADDR_IMAGE_SIZE)
            .borderRadius(AddressPopupCommonConstants.IMAGE_COMP_RADIUS)
            .margin({ right: AddressPopupCommonConstants.ADDR_IMAGE_MARGIN })
            .onClick(this.onImageClickCallback)
        }
        Text(this.addressDescription)
          .fontSize(AddressPopupCommonConstants.ADDR_FONT_SIZE)
          .maxLines(2)
          .width(this.addrCompWidth)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .onClick(this.onAddrClickCallback)
        Text('>')
          .backgroundColor(Color.Transparent)
          .textAlign(TextAlign.Center)
          .fontSize(AddressPopupCommonConstants.ARROW_SIZE)
          .fontColor(Color.Black)
          .borderColor(Color.Black)
          .borderWidth(1)
          .height(AddressPopupCommonConstants.ARROW_ICON_SIZE)
          .width(AddressPopupCommonConstants.ARROW_ICON_SIZE)
          .borderRadius(AddressPopupCommonConstants.ARROW_ICON_SIZE / 2)
          .margin({ bottom: 1.5 })// 1.5,调整箭头图标位置跟文字平齐
          .onClick(this.onAddrClickCallback)
      }
      .id('addressDescription')
      .zIndex(1)
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .padding(AddressPopupCommonConstants.ADDR_IMAGE_MARGIN)
      .borderRadius({
        topRight: AddressPopupCommonConstants.POPUP_COMP_RADIUS,
        // 2, 有tip时左上角圆角半径2
        topLeft: (this.addressTip !== '' && this.addressTip !== null) ? 2 : AddressPopupCommonConstants.POPUP_COMP_RADIUS,
        bottomRight: AddressPopupCommonConstants.POPUP_COMP_RADIUS,
        bottomLeft: AddressPopupCommonConstants.POPUP_COMP_RADIUS
      })
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Bottom)
    }
    .backgroundColor(Color.Transparent)
    .hitTestBehavior(HitTestMode.Transparent)
    .width('100%')
    .height('100%')
  }
}
