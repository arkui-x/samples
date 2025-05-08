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

const PHONE_NUMBER_LENGTH = 15; // 最大输入字符数
const SPACE_TEN = 10; // 子元素的间距

/**
 *  账号密码登录
 */
@Component
export struct AccountLogin {
  // 是否勾选阅读并同意服务协议及个人信息处理规则
  @State isAgree: boolean = false;
  // 登录按钮透明度
  @State op: number = 0.5;
  // 用户输入校验
  @State userIsblank: boolean = true;
  // 密码输入校验
  @State pwdIsblank: boolean = true;
  // 密码
  @State passwordText: string = "";
  // 账号
  @State accountText: string = "";
  // 通过控制此变量来展示验证码登录或者账户登录，通过link和父组件双向绑定
  @Link isDefaultLogin: boolean;
  // 用于标识转场类型，从半模态跳转至手机验证码组件时为false，从账号密码组件跳转至手机验证码组件时为true
  @Link isShowTransition: boolean;
 
  build() {
    Column({ space: SPACE_TEN }) {
      Text($r('app.string.multimodaltransion_account_login_text'))
        .fontSize($r('app.integer.multimodaltransion_font_size_middle'))
        .fontWeight(70)
        .width($r('app.string.multimodaltransion_size_eighty_percent'))
        .id('AccountLoginPage')
      TextInput({ text: this.accountText, placeholder: $r('app.string.multimodaltransion_place_holder') })
        .showUnderline(true)
        .type(InputType.Normal)
        .backgroundColor(Color.Transparent)
        .caretColor(Color.Grey)
        .width($r('app.string.multimodaltransion_size_account_width'))
        .margin({ top: 12 })
        .onChange((value: string) => {
          // 当用户有输入时，userIsblank为false
          this.userIsblank = value.length === 0;
          this.accountText = value;
          // 设置最大输入字符数,当超过最大输入，弹窗提示
          if (value.length > PHONE_NUMBER_LENGTH) {
            this.accountText = value.substring(0, PHONE_NUMBER_LENGTH)
            promptAction.showToast({ message: $r('app.string.multimodaltransion_show_id_already_max') })
          }
        })
      TextInput({ text: this.passwordText, placeholder: $r('app.string.multimodaltransion_text_input_place_holder') })
        .showUnderline(true) // 显示下划线
        .type(InputType.Password)
        .backgroundColor(Color.Transparent)
        .caretColor(Color.Grey)
        .width("87%")
        .margin({ top: 12 }) 
        .onChange((value: string) => {
          // 当用户有输入时，pwdIsblank为false
          this.pwdIsblank = value.length === 0;
          this.passwordText = value;
          // 设置最大输入字符数,当超过最大输入，弹窗提示
          if (value.length > PHONE_NUMBER_LENGTH) {
            this.passwordText = value.substring(0, PHONE_NUMBER_LENGTH)
            promptAction.showToast({ message: $r('app.string.multimodaltransion_show_password_already_max') })
          }
        })

      Row() {
        Text($r('app.string.multimodaltransion_row_text'))
          .fontSize($r('app.integer.multimodaltransion_row_text_font_size'))
          .fontColor($r('app.color.multimodaltransion_note_color'))
          .backgroundColor($r('app.color.multimodaltransion_transparent_7'))
          .onClick(() => {
            // 切换到验证码登录
            this.isDefaultLogin = true;
            this.isShowTransition = true;
          })
          .id('switchPhoneNumberLogin')
      }
      .width($r('app.string.multimodaltransion_size_eighty_percent'))
      .padding({ bottom: $r('app.integer.multimodaltransion_row_padding_bottom'), top: $r('app.integer.multimodaltransion_row_padding_top') })

      Button($r('app.string.multimodaltransion_account_btn_text'))
        .type(ButtonType.Normal)
        .border({ radius: $r('app.integer.multimodaltransion_border_radius') })
        .width($r('app.string.multimodaltransion_size_eighty_percent'))
        .backgroundColor($r('app.color.multimodaltransion_red'))
        .opacity(this.userIsblank || this.pwdIsblank ? 0.5 : 1)
        .onClick(() => {
          // 判断用户和账户输入后才能点击登录按钮
          if (this.userIsblank || this.pwdIsblank) {
            promptAction.showToast({ message: $r('app.string.multimodaltransion_please_input_account_and_pwd') })
          } else if (!this.isAgree) {
            promptAction.showToast({ message: $r('app.string.multimodaltransion_please_read_and_agree') })
          } else {
            promptAction.showToast({ message: $r('app.string.multimodaltransion_login_success') })
          }
        })
      Row() {
        Checkbox({ name: 'agreement' })
          .select($$this.isAgree) // $$运算符为系统内置组件提供TS变量的引用，使得TS变量和系统内置组件的内部状态保持同步
          .size({ width: $r('app.integer.multimodaltransion_check_box_size'), height: $r('app.integer.multimodaltransion_check_box_size') })
        Text() {
          Span($r('app.string.multimodaltransion_read_and_agree'))
            .fontColor($r('app.color.multimodaltransion_grey_9'))
          Span($r('app.string.multimodaltransion_server_proxy_rule_detail'))
            .fontColor($r('app.color.multimodaltransion_note_color'))
            .onClick(() => {
              // 调用Toast显示提示:此样式仅为案例展示
              promptAction.showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
            })
        }
        .fontSize(13)
        .textAlign(TextAlign.Start)
      }
      .alignItems(VerticalAlign.Center)
      .width("83%")
    }
    .width($r('app.string.multimodaltransion_size_full'))
    .height($r('app.string.multimodaltransion_size_full'))
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Start)
    .padding({ top: $r('app.integer.multimodaltransion_padding_top_size') })
  }
}