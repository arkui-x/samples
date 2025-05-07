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

import { LengthMetrics, LengthUnit, promptAction } from "@kit.ArkUI";
import { CommonConstants } from "../common/CommonConstants";
import { Address } from "./Address";
import { autoFillManager } from "@kit.AbilityKit";

@Component
export struct AddressDetail {
  @State isClicked: boolean = false;
  @State name: string = '';
  @State phone: string = '';
  @State address: string = '';
  @State detailAddress: string = '';
  @Link addressDetail: Address;
  @Link showAddressDetail: boolean;

  useAddress(): void {
    if (!this.name || this.name === '') {
      promptAction.showToast({
        message: CommonConstants.NAME_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.phone || this.phone === '') {
      promptAction.showToast({
        message: CommonConstants.PHONE_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.address || this.address === '') {
      promptAction.showToast({
        message: CommonConstants.ADDRESS_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }
    if (!this.detailAddress || this.detailAddress === '') {
      promptAction.showToast({
        message: CommonConstants.DETAIL_ADDRESS_EMPTY,
        duration: CommonConstants.TOAST_DURATION,
        textColor: Color.Red
      });
      return;
    }

    let newAddress: Address = new Address(this.name, this.phone, this.address, this.detailAddress);

    if (!this.isClicked) {
      // 主动触发保存历史表单输入
        autoFillManager.requestAutoSave(this.getUIContext())
      this.isClicked = true;
      // 设置超时时间以防止重复点击按钮保存历史表单输入
      setTimeout(() => {
        this.isClicked = false;
      }, 1000)
    }
    this.addressDetail = newAddress;

    promptAction.showToast({
      message: CommonConstants.USE_SUCCESS,
      duration: CommonConstants.TOAST_DURATION,
      textColor: Color.Green
    });
    this.showAddressDetail = false;
  }

  build() {
    Column() {
      Column({ space: CommonConstants.SPACE_GAP_24 }) {
        //标题行
        Row() {
          Text(CommonConstants.ADD_ADDRESS)
            .width(CommonConstants.WIDTH_FULL)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Medium)
        }
        .width(CommonConstants.WIDTH_FULL)
        .height(75)
        .backgroundColor(Color.White)

        // 地址详情
        Column() {
          Column() {
            UserInfoTextInput({
              componentId: "inputName",
              text: this.name,
              contentType: ContentType.PERSON_FULL_NAME,
              label: CommonConstants.NAME_BAR,
              index: 0
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputPhone",
              text: this.phone,
              contentType: ContentType.PHONE_NUMBER,
              label: CommonConstants.PHONE_BAR,
              index: 1
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputAddress",
              text: this.address,
              contentType: ContentType.FULL_STREET_ADDRESS,
              label: CommonConstants.ADDRESS_BAR,
              index: 2
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }

          Column() {
            UserInfoTextInput({
              componentId: "inputDetailAddress",
              text: this.detailAddress,
              contentType: ContentType.DETAIL_INFO_WITHOUT_STREET,
              label: CommonConstants.DETAIL_ADDRESS_BAR,
              index: 3
            })
            Divider()
              .height(CommonConstants.DIVIDER_HEIGHT)
              .color('#ccc');
          }
        }
        .width(CommonConstants.WIDTH_FULL)
        .borderRadius(10)
        .backgroundColor(Color.White)
      }
      .height('80%')

      Blank()

      // 底部
      Column() {
        // 保存按钮
        Row() {
          Button(CommonConstants.USE_ADDRESS)
            .width(120)
            .backgroundColor(Color.Red)
            .onClick(() => {
              this.useAddress();
            })
        }
        .width(CommonConstants.WIDTH_FULL)
        .height(80)
        .backgroundColor(Color.White)
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Center)
      }
      .justifyContent(FlexAlign.End)
    }
    .padding({
      left: 24,
      right: 24
    })
    .backgroundColor(Color.White)
    .height(CommonConstants.HEIGHT_FULL)
  }
}


@Component
struct UserInfoTextInput {
  componentId: string = '';
  @Link text: string;
  contentType: ContentType | undefined = undefined;
  label: ResourceStr | undefined = undefined;
  index: number = -1;
  @State scaleTimes: number = 1;
  @State currentIndex: number = -1;

  build() {
    Stack({ alignContent: Alignment.Center }) {
      TextInput({ text: this.text })
        .id(this.componentId)
        .width(CommonConstants.WIDTH_FULL)
        .backgroundColor(Color.White)
        .contentType(this.contentType)
        .padding({ left: 12, top: 0, bottom: 0 })
        .selectionMenuHidden(true)
        .onChange((value: string) => {
          this.text = value;
          if (value === '') {
            this.scaleTimes = 1;
          } else {
            this.scaleTimes = 0.75;
          }
        })
        .onFocus(() => {
          this.scaleTimes = 0.75;
          this.currentIndex = this.index;
        })
        .onBlur(() => {
          if (this.text === '') {
            this.scaleTimes = 1;
          }
        })
      Text() {
        Span('*')
          .fontColor('#ff5000')
          .baselineOffset(new LengthMetrics(-2, LengthUnit.VP))
        Span(this.label)
          .baselineOffset(new LengthMetrics(0, LengthUnit.VP))
      }
      .scale(this.index === this.currentIndex || this.text !== '' ? {
        x: this.scaleTimes,
        y: this.scaleTimes,
        centerX: 0,
        centerY: -80
      } : {
        x: 1,
        y: 1,
        centerX: 0,
        centerY: -80
      })
      .animation({ duration: CommonConstants.ANIMATION_DURATION })
      .height(this.index === this.currentIndex ? 24 : undefined)
      .width(CommonConstants.WIDTH_FULL)
      .hitTestBehavior(HitTestMode.Transparent)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .padding({ left: 12 })
    }
    .height(72)
  }
}