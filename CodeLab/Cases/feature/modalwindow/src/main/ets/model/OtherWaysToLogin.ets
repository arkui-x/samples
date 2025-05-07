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

import promptAction from '@ohos.promptAction';

const PHONE_NUMBER_LENGTH = 11;
const SPACE_TWENTY = 20;
const SPACE_TEN = 10;
const COUNTDOWN_SECONDS = 30; // 倒计时总秒数
const SEND_AGAIN_IN_SECONDS = "s后可再次发送";

/**
 * 其他账号登录：主要提供短信验证码登录方式，以及其他三方应用登录方式
 */
@Component
export struct OtherWaysToLogin {
  // 发送验证码按钮的颜色
  @State buttonColor: ResourceColor = Color.Grey;
  // 发送验证码按钮的内容
  @State buttonContent: ResourceStr = $r('app.string.modalwindow_verify');
  // 手机号是否可用
  phoneNumberAvailable: boolean = false;
  // 可发送验证码的倒计时秒数
  countdownSeconds: number = 0;
  // 是否勾选阅读并同意服务协议及个人信息处理规则
  isAgree: boolean = false;
  loginIcons: Resource[] = [$r('app.media.app_logo1'), $r('app.media.app_logo2'), $r('app.media.app_logo3')]

  build() {
    Column({ space: SPACE_TWENTY }) {
      Column({ space: SPACE_TEN }) {
        Row({ space: SPACE_TEN }) {
          Image($r('app.media.phone')).width($r('app.integer.modalwindow_user_image_height'))
            .borderRadius($r('app.integer.modalwindow_border_radius_mid'))
          Text($r('app.string.modalwindow_phone_login')).fontSize($r('app.integer.modalwindow_font_size_mid'))
        }
        .width($r('app.string.modalwindow_size_full'))

        Text($r('app.string.modalwindow_new'))
          .width($r('app.string.modalwindow_size_full'))
      }
      .width($r('app.string.modalwindow_size_full'))
      .alignItems(HorizontalAlign.Start)

      Row() {
        Text($r('app.string.modalwindow_86'))
        Image($r('app.media.arrow_right'))
          .size({
            width: $r('app.integer.modalwindow_arrow_right_height'),
            height: $r('app.integer.modalwindow_arrow_right_height')
          })
          .margin($r('app.integer.modalwindow_margin_default'))
        TextInput({ placeholder: $r('app.string.modalwindow_input_phone_number') })
          .inputFilter('[0-9]')// 正则表达式，输入的是数字0-9则允许显示，不是则被过滤
          .backgroundColor(Color.Transparent)
          .caretColor(Color.Grey)
          .width($r('app.string.modalwindow_size_full'))
          .maxLength(PHONE_NUMBER_LENGTH)// 设置最大输入字符数
            // 当输入字符数为11位时，发送验证码按钮变为蓝色，否则置灰
          .onChange((value: string) => {
            if (value.length === PHONE_NUMBER_LENGTH) {
              this.phoneNumberAvailable = true;
              this.buttonColor = Color.Blue;
            } else {
              this.phoneNumberAvailable = false;
              this.buttonColor = Color.Grey;
            }
          })
      }

      Button(this.buttonContent)
        .type(ButtonType.Normal)
        .border({ radius: $r('app.integer.modalwindow_border_radius') })
        .width($r('app.string.modalwindow_size_full'))
        .backgroundColor(this.buttonColor)
        .id('send_button_id')
        .onClick(() => {
          if (this.countdownSeconds > 0) { // 处于可再次发送的读秒倒计时状态下，点击按钮不响应
            return;
          }
          // 输入输入字符数为11位，并同意服务协议及个人信息处理规则，才能发送验证码
          if (!this.phoneNumberAvailable) {
            promptAction.showToast({ message: $r('app.string.modalwindow_message_right_phone_number') });
          } else if (!this.isAgree) {
            promptAction.showToast({ message: $r('app.string.modalwindow_message_read_agreement') });
          } else {
            // 点击发送短信验证码按钮后，按钮置灰，开始读秒倒计时，按钮内容改变
            promptAction.showToast({ message: $r('app.string.modalwindow_message_verify_code_send') });
            this.buttonColor = Color.Grey;
            this.countdownSeconds = COUNTDOWN_SECONDS;
            const timerId = setInterval(() => {
              this.countdownSeconds--;
              if (this.countdownSeconds <= 0) {
                // 计时结束，根据手机号位数是否正确，重置按钮状态
                this.buttonContent = $r('app.string.modalwindow_verify');
                clearInterval(timerId);
                this.buttonColor = this.phoneNumberAvailable ? Color.Blue : Color.Grey;
                return;
              }
              this.buttonContent = this.countdownSeconds + SEND_AGAIN_IN_SECONDS;
            }, 1000)
          }
        })

      Row() {
        Checkbox({ name: 'agreement' })// $$运算符为系统内置组件提供TS变量的引用，使得TS变量和系统内置组件的内部状态保持同步
          .id('other_agreement')
          .select($$this.isAgree)
        ReadAgreement()
      }
      .width($r('app.string.modalwindow_size_full'))
      .justifyContent(FlexAlign.Start)

      Blank() // 在容器主轴方向上自动填充容器空余部分

      // 其他三方应用登录方式
      List({ space: SPACE_TWENTY }) {
        // 性能知识点：此处在List中排列组件，列表项确定、数量较少，且需要一次性加载，因此使用ForEach。在列表项多的情况下，推荐使用LazyForEach
        ForEach(this.loginIcons, (item: Resource) => {
          ListItem() {
            Image(item)
              .width($r('app.integer.modalwindow_other_ways_icon_height'))
              .borderRadius($r('app.integer.modalwindow_other_ways_border_radius'))
              .onClick(() => {
                // 调用Toast显示三方应用授权登录提示
                promptAction.showToast({ message: $r('app.string.modalwindow_message_third_party_authorization') });
              })
          }
        })
      }
      .listDirection(Axis.Horizontal)
    }
    .width($r('app.string.modalwindow_size_full'))
    .height($r('app.string.modalwindow_size_full'))
    .backgroundColor(Color.White)
    .padding({ bottom: $r('app.integer.modalwindow_padding_mid'), top: $r('app.integer.modalwindow_padding_to_top') })
  }
}

@Component
export struct ReadAgreement {
  build() {
    Text() {
      Span($r('app.string.modalwindow_read_and_agree'))
        .fontColor($r('app.color.modalwindow_grey_9'))
      Span($r('app.string.modalwindow_server_proxy_rule_detail'))
        .fontColor(Color.Orange)
        .onClick(() => {
          // 调用Toast显示用户点击服务协议及个人信息处理规则的提示
          promptAction.showToast({ message: $r('app.string.modalwindow_server_proxy_rule_detail') });
        })
    }
    .textAlign(TextAlign.Start)
  }
}