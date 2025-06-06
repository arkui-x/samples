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
import { DynamicsRouter } from 'routermodule';
import { AccountLogin } from './AccountLogin';

const PHONE_NUMBER_LENGTH = 11; // 最大输入字符数
const EFFECT_DURATION = 300; // 动画时长为300ms
const SPACE＿FIFTEEN = 15; // 子元素的间距

@Component
export struct CaptchaLogin {
  /**
   * isPresentInLoginView控制登录页面是否显示，通过isDefaultLogin控制两种登录组件的条件渲染：true(手机验证码登录),false(二维码登录)
   * 子组件中被@Link装饰的变量与其父组件中@State装饰的对应数据源建立双向数据绑定，详见：
   * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-link-0000001820999565
   */
  // 控制半模态的展示
  @Link isPresent: boolean;
  // 控制全模态的展示
  @Link isPresentInLoginView: boolean;
  // 控制验证码登录的展示
  @State isDefaultLogin: boolean = true;
  // 登录按钮的透明度
  @State op: number = 0.5;
  // 判断是否同意协议
  isConfirmed: boolean = false;
  // 用于标识转场类型，从半模态跳转至手机验证码组件时为false，从账号密码组件跳转至手机验证码组件时为true
  @Link isShowTransition: boolean;
  // 1.1、定义验证码登录页的转场效果1：用于定义半模态转场到此组件的进场动效，与组件间后续切换的转场动效，进场时无动效，转场时从左边推出，
  private effect1: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.IDENTITY,
      TransitionEffect.move(TransitionEdge.START).animation({ duration: EFFECT_DURATION, curve: Curve.Linear }))
  // 2、定义账号登录页的转场效果，从右边推出
  private effect2: TransitionEffect =
    TransitionEffect
      .move(TransitionEdge.END).animation({ duration: EFFECT_DURATION, curve: Curve.Linear })
  // 1.2、定义验证码登录页的转场效果2：用于后面组件切换到此组件时转场的动效，从左边推出。
  private effect3: TransitionEffect =
    TransitionEffect
      .move(TransitionEdge.START).animation({ duration: EFFECT_DURATION, curve: Curve.Linear })

  aboutToAppear(): void {
    this.isPresent = false;
  }

  aboutToDisappear(): void {
    DynamicsRouter.popAppRouter();
  }

  build() {
    /* 性能知识点：由于需要针对反复切换条件渲染的控制分支，但切换项仅涉及页面中少部分组件的场景，因此推荐容器限制条件渲染组件的刷新范围。
     * 参考合理选择条件渲染和显隐控制文章：
     * https://gitee.com/harmonyos-cases/cases/blob/master/docs/performance/proper-choice-between-if-and-visibility.md
     */
    Stack({ alignContent: Alignment.TopStart }) {
      // 登录方式有两种，验证码登录和账户，需要在一个模态窗口中切换，使用if进行条件渲染
      // 3、这里默认是验证码登录（手机验证码登录）
      if (this.isDefaultLogin) {
        Column({ space: SPACE＿FIFTEEN }) {
          Row({ space: SPACE＿FIFTEEN }) {
            Column({ space: SPACE＿FIFTEEN }) {
              Text($r('app.string.multimodaltransion_phone_back'))
                .fontSize($r('app.integer.multimodaltransion_font_size_middle'))
                .fontWeight(70)
                .fontColor(Color.Black)
              Text($r('app.string.multimodaltransion_auto_after_login'))
                .fontColor($r('app.color.multimodaltransion_grey_3'))
                .fontWeight(20)
                .opacity(0.5)
                .id('phoneLoginPage')
            }
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Top)
          .width($r('app.string.multimodaltransion_size_eighty_percent'))
          .padding({ bottom: 15 })

          Row() {
            Text($r('app.string.multimodaltransion_86'))
            Image($r("app.media.multimodaltransion_arrow_right"))
              .size({ width: $r('app.integer.multimodaltransion_arrow_right_height'), height: $r('app.integer.multimodaltransion_arrow_right_height') })
              .margin({
                top: $r('app.integer.multimodaltransion_margin_default'),
                left: $r('app.integer.multimodaltransion_margin_default'),
                bottom: $r('app.integer.multimodaltransion_margin_default')
              })
              .onClick(() => {
                // 调用Toast显示提示:此样式仅为案例展示
                promptAction.showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
              })
            TextInput({ placeholder: $r('app.string.multimodaltransion_input_phone_number') })
              .type(InputType.PhoneNumber) // 电话号码输入模式
              .backgroundColor(Color.Transparent)
              .caretColor(Color.Grey)
              .width($r('app.string.multimodaltransion_size_full'))
              .maxLength(PHONE_NUMBER_LENGTH) // 设置最大输入字符数
              .onChange((value: string) => {
                // 4、通过判断是否满足号码要求来控制按钮的透明度
                if (value.length === PHONE_NUMBER_LENGTH) {
                  this.op = 1;
                } else {
                  this.op = 0.5;
                }
              })
          }
          .height($r('app.integer.multimodaltransion_user_image_height'))
          .width($r('app.string.multimodaltransion_size_eighty_percent'))

          Text($r('app.string.multimodaltransion_captcha_change_title_text'))
            .fontColor($r('app.color.multimodaltransion_note_color'))
            .fontSize(15)
            .backgroundColor($r('app.color.multimodaltransion_transparent_7'))
            .width($r('app.string.multimodaltransion_size_eighty_percent'))
            .padding({ bottom: 10 })
            .onClick(() => {
              // 5、切换到账号登录
              this.isDefaultLogin = false;
            })
            .id('switchAccountLogin')

          Button($r('app.string.multimodaltransion_captcha_get'))
            .fontColor(Color.White)
            .fontWeight(FontWeight.Normal)
            .borderRadius($r('app.integer.multimodaltransion_border_radius'))
            .type(ButtonType.Normal)
            .backgroundColor($r('app.color.multimodaltransion_red'))
            .opacity(this.op)
            .onClick(() => {
              if (this.isConfirmed) {
                // 调用Toast显示登录成功提示
                promptAction.showToast({ message: $r('app.string.multimodaltransion_captcha_sent') });
              } else {
                // 调用Toast显示请先阅读并同意协议提示
                promptAction.showToast({ message: $r('app.string.multimodaltransion_please_read_and_agree') });
              }
            })
            .width($r('app.string.multimodaltransion_size_eighty_percent'))
          Row() {
            Checkbox({ name: 'checkbox' })
              .select(this.isConfirmed)
              .size({ width: $r('app.integer.multimodaltransion_check_box_size'), height: $r('app.integer.multimodaltransion_check_box_size') })
              .onChange((value: boolean) => {
                this.isConfirmed = value;
              })
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
            .flexShrink(1) // flexShrink设置后，如果超出父组件，会被压缩
          }
          .alignItems(VerticalAlign.Center)
          .padding({ bottom: 10 })
          .width($r('app.string.multimodaltransion_size_eighty_two_percent'))

          Blank() // 在容器主轴方向上自动填充容器空余部分
          Row({ space: 20 }) {
            Image($r("app.media.multimodaltransion_app_logo1"))
              .width($r('app.integer.multimodaltransion_other_ways_icon_height'))
              .borderRadius($r('app.integer.multimodaltransion_other_ways_border_radius'))
              .onClick(() => {
                // 调用Toast显示提示:此样式仅为案例展示
                promptAction.showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
              })

            Image($r("app.media.multimodaltransion_app_logo2"))
              .width($r('app.integer.multimodaltransion_other_ways_icon_height'))
              .borderRadius($r('app.integer.multimodaltransion_other_ways_border_radius'))
              .onClick(() => {
                // 调用Toast显示提示:此样式仅为案例展示
                promptAction.showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
              })

            Image($r("app.media.multimodaltransion_app_logo3"))
              .width($r('app.integer.multimodaltransion_other_ways_icon_height'))
              .borderRadius($r('app.integer.multimodaltransion_other_ways_border_radius'))
              .onClick(() => {
                // 调用Toast显示提示:此样式仅为案例展示
                promptAction.showToast({ message: $r('app.string.multimodaltransion_only_show_ui') });
              })
          }.margin({ bottom: 20 })
        }
        /* 验证码登录组件绑定转场
         * TODO: 知识点: 当isShowTransition为false，此时从半模态进入手机验证码组件：此时关闭组件进场动效，开启全模态进场动效，
         * 当isShowTransition为true，此时从账号密码组件返回此组件：打开组件进场动效，此时左滑进入手机验证码组件。
         */
        .transition(this.isShowTransition ? this.effect3 : this.effect1)
        .width($r('app.string.multimodaltransion_size_full'))
        .height($r('app.string.multimodaltransion_size_full'))
        .backgroundColor(Color.White)
        .padding({ top: $r('app.integer.multimodaltransion_padding_top') })
        .justifyContent(FlexAlign.Center)
      } else {
        AccountLogin({ isDefaultLogin: $isDefaultLogin, isShowTransition: $isShowTransition }) // 账户登录方式
          // 6、账户登录组件绑定转场
          .transition(this.effect2) // 此处涉及到组件的显示和消失，所以使用transition属性设置出现/消失转场
      }
      Image($r("app.media.multimodaltransion_close")) // 通过Stack组件，两个页面只实现一个back
        .width($r('app.integer.multimodaltransion_height_fifty_five'))
        .height($r('app.integer.multimodaltransion_height_fifty_five'))
        .margin({ top: $r('app.integer.multimodaltransion_margin_close_top'), left: $r('app.integer.multimodaltransion_margin_close_left') })
        .onClick(() => {
          // 7、点击关闭按钮，回到主页面
          this.isPresentInLoginView = false;
        })
    }
    .size({ width: $r('app.string.multimodaltransion_size_full'), height: $r('app.string.multimodaltransion_page_size_full') })
  }
}