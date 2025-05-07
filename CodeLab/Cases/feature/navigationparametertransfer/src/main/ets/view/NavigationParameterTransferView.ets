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

/** 实现步骤
 1.在oh-package.json5中添加第三方插件class-transformer的依赖
 2.在使用第三方插件class-transformer的页面导入class-transformer库。
 3.定义要传递的类UserBookingInfo。
 4.在获取到其他页面传过来的参数后通过class-transformer的plainToClass方法转换成类对象
 5.调用类对象的方法generateRandSeatNo()
 */

import { promptAction } from '@kit.ArkUI';
// TODO: 导入第三方插件class-transformer
import { plainToClass } from 'class-transformer';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { logger } from '../utils/Logger';
import { UserBookingInfo } from '../components/UserBookingInfo';

@AppRouter({ name: "navigationparametertransfer/NavigationParameterTransferView", hasParam: true })
@Component
export struct NavigationParameterTransferView {
  @State userName: string = '';
  @State userID: string = '';
  @State seatNo: string = "";
  private userBooking: UserBookingInfo = new UserBookingInfo('', '', '');
  private toastDuration: number = 3000; // toast弹窗时长
  pageStack: NavPathStack = DynamicsRouter.navPathStack;

  getParams() {
    const bookingString: string =
      this.pageStack.getParamByName("navigationparametertransfer/NavigationParameterTransferView")[0] as string;
    try {
      // 转化成普通对象
      const userBookingTmp: UserBookingInfo = JSON.parse(bookingString);
      // TODO：知识点：通过调用第三方插件class-transformer的plainToClass方法转换成类对象, 不进行转换直接使用userBookingTmp调用getUserInfo方法会造成crash
      this.userBooking = plainToClass(UserBookingInfo, userBookingTmp);
      this.userName = this.userBooking.userName;
      this.userID = this.userBooking.userID;
      // TODO：知识点：调用转换后的类对象的方法
      this.seatNo = this.userBooking.generateRandSeatNo().toString();
    } catch (err) {
      logger.error(`get navigationparametertransfer param fail, err = ${err}`);
    }
  }

  aboutToAppear(): void {
    this.getParams();
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.navigation_parametertransfer_bookingInfo'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_txt'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Normal)
            .margin($r('app.string.navigation_parametertransfer_title_margin'))
            .align(Alignment.Start)
        }

        Row() {
          Text($r('app.string.navigation_parametertransfer_date'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_txt'))
            .width($r('app.string.navigation_parametertransfer_width_left'))
            .textAlign(TextAlign.End)
            .fontWeight(FontWeight.Normal)
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .align(Alignment.End)
          Text(this.userBooking.date)
            .id('departure_time')
            .width($r('app.string.navigation_parametertransfer_width_right'))
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_14'))
        }

        Row() {
          Text($r('app.string.navigation_parametertransfer_user_seatNo'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_txt'))
            .width($r('app.string.navigation_parametertransfer_width_left'))
            .fontWeight(FontWeight.Normal)
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .textAlign(TextAlign.End)
            .align(Alignment.End)
          Text(this.seatNo)
            .width($r('app.string.navigation_parametertransfer_width_mid'))
            .id('seatNo')
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .textAlign(TextAlign.JUSTIFY)
            .fontSize($r('app.string.navigation_parametertransfer_font_size_14'))
          Text($r('app.string.navigation_parametertransfer_btn_select'))
            .width($r('app.string.navigation_parametertransfer_width_left'))
            .id('btn_ChangeSeatNo')
            .fontColor($r('app.color.ohos_id_color_palette8'))
            .fontSize($r('app.string.ohos_id_text_size_body2'))
            .backgroundColor($r('app.color.ohos_id_color_background'))
            .onClick(() => {
              // 调用主页传过来的类对象的generateRandSeatNo方法
              this.seatNo = this.userBooking.generateRandSeatNo().toString();
            });
        }

        Row() {
          Text($r('app.string.navigation_parametertransfer_price'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_txt'))
            .width($r('app.string.navigation_parametertransfer_width_left'))
            .fontWeight(FontWeight.Normal)
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .textAlign(TextAlign.End)
            .align(Alignment.End)
          Text(this.userBooking.price.toString())
            .width($r('app.string.navigation_parametertransfer_width_right'))
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_14'))
        }

        Row() {
          Text($r('app.string.navigation_parametertransfer_user_name'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_txt'))
            .width($r('app.string.navigation_parametertransfer_width_left'))
            .textAlign(TextAlign.End)
            .fontWeight(FontWeight.Normal)
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .align(Alignment.End)
          Text(this.userName)
            .id('user_name')
            .width($r('app.string.navigation_parametertransfer_width_right'))
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_14'))
        }

        Row() {
          Text($r('app.string.navigation_parametertransfer_user_id'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_txt'))
            .width($r('app.string.navigation_parametertransfer_width_left'))
            .fontWeight(FontWeight.Normal)
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .textAlign(TextAlign.End)
            .align(Alignment.End)
          Text(this.userID)
            .id('user_id')
            .width($r('app.string.navigation_parametertransfer_width_right'))
            .margin($r('app.string.navigation_parametertransfer_margin'))
            .fontSize($r('app.string.navigation_parametertransfer_font_size_14'))
        }

        Row() {
          Button($r('app.string.navigation_parametertransfer_btn_submit'))
            .id('btn_submit')
            .onClick(() => {
              promptAction.showToast({
                message: $r('app.string.navigation_parametertransfer_todo'),
                duration: this.toastDuration
              })
            }).margin($r('app.string.navigation_parametertransfer_margin'))
        }
      }
      .backgroundColor($r('app.color.navigation_parametertransfer_background_color'))
      .border({
        width: 1,
        color: $r('app.color.navigation_parametertransfer_border_color'),
        radius: $r('app.string.navigation_parametertransfer_radius'),
        style: BorderStyle.Solid
      })
      .width('100%')
      .margin($r('app.string.ohos_id_card_margin_start'))
    }
    .padding($r('app.string.ohos_id_card_padding_start'))
  }
}
