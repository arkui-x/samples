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

import vibrator from '@ohos.vibrator';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import { UIContext } from '@ohos.arkui.UIContext';
import { PlatformInfo, PlatformTypeEnum } from 'utils';
import { CONFIGURATION } from './components/constantsData';
import { logger } from './utils/Logger';

/**
 * 功能描述: 本示例介绍使用vibrator.startVibration方法实现手机振动效果，用keyframeAnimateTo关键帧动画实现点击后的抖动动画。
 *
 * 推荐场景: 未勾选服务协议和隐私政策时点击登录
 *
 * 核心组件:
 * 1. startVibrate()
 * 2. startAnimation()
 *
 * 实现步骤：
 * 1. 创建一个函数startVibrate()调用vibrator.startVibration方法实现手机振动效果（需要权限：ohos.permission.VIBRATE）。
 * 2. 创建一个函数startAnimation()使用keyframeAnimateTo关键帧动画实现提示文本的抖动动画。
 */

@Component
export struct VibrateEffectViewComponent {
  @State translateX: number = 0; // 初始化提示文本的偏移量
  @State confirm: boolean = false; // 是否勾选协议
  uiContext: UIContext | undefined = undefined; // UIContext实例对象

  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
  }

  // 触发手机振动效果
  startVibrate() {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      try {
        // TODO: 知识点：vibrator.startVibration 根据指定振动效果和振动属性触发马达振动
        vibrator.startVibration({
          type: 'time',
          // 持续触发马达振动时间600ms
          duration: CONFIGURATION.VIBRATION_TIME,
        }, {
          id: 0,
          usage: 'alarm',
        }, (error: BusinessError) => {
          if (error) {
            logger.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
            return;
          }
        });
      } catch (err) {
        logger.error(`An unexpected error occurred. Code: ${err.code}, message: ${err.message}`);
      }
    }
  }

  // 触发提示文本抖动动画效果
  startAnimation() {
    if (!this.uiContext) {
      return;
    }
    this.translateX = CONFIGURATION.POSITION_ZERO;
    // TODO: 知识点：通过keyframeAnimateTo关键帧动画指定状态变化过渡动效
    this.uiContext.keyframeAnimateTo({ iterations: CONFIGURATION.PLAYBACK_COUNT }, [
      {
        // 第一段动画时长为100ms，translateX属性从0到5
        duration: CONFIGURATION.ANIMATION_TIME,
        event: () => {
          this.translateX = CONFIGURATION.TRANSLATE_OFFSET_X;
        }
      },
      {
        // 第二段动画时长为100ms，translateX属性从5到0
        duration: CONFIGURATION.ANIMATION_TIME,
        event: () => {
          this.translateX = CONFIGURATION.POSITION_ZERO;
        }
      }
    ]);
  }

  build() {
    Column() {
      Row()
        .width($r('app.string.vibrateeffect_full_size'))
        .height($r('app.integer.vibrateeffect_elements_height'))

      Scroll() {
        // 应用图标
        Column({ space: CONFIGURATION.MARGIN_VERTICAL }) {
          Image($r("app.media.vibrateeffect_speed_train"))
            .width($r('app.integer.vibrateeffect_image_size'))
            .height($r('app.integer.vibrateeffect_image_size'))
            .backgroundColor($r('app.color.ohos_id_color_palette8'))
            .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))

          // 手机号
          Text($r('app.string.vibrateeffect_phone_number'))
            .fontSize($r('app.string.ohos_id_text_size_headline'))
            .fontWeight(FontWeight.Bold)

          // 协议阅读与勾选
          Column() {
            Row() {
              Image(this.confirm ? $r("app.media.vibrateeffect_ic_ok") : $r("app.media.vibrateeffect_ic_default"))
                .height($r('app.integer.vibrateeffect_circle_icon_size'))
                .width($r('app.integer.vibrateeffect_circle_icon_size'))
                .margin({ right: $r('app.integer.vibrateeffect_flex_margin') })
                .onClick(() => {
                  this.confirm = !this.confirm;
                })

              Text() {
                Span($r('app.string.vibrateeffect_read_and_agreed'))
                  .fontColor($r('app.color.ohos_id_color_text_secondary'))
                  .fontSize($r('app.string.ohos_id_text_size_body3'))
                Span($r('app.string.vibrateeffect_services_and_policies'))
                  .fontColor($r('app.color.ohos_id_color_palette8'))
                  .fontSize($r('app.string.ohos_id_text_size_body3'))
                  .onClick(() => {
                    promptAction.showToast({
                      message: $r('app.string.vibrateeffect_prompt_text')
                    });
                  })
                Span($r('app.string.vibrateeffect_and'))
                  .fontColor($r('app.color.ohos_id_color_text_secondary'))
                  .fontSize($r('app.string.ohos_id_text_size_body3'))
                Span($r('app.string.vibrateeffect_service_agreement'))
                  .fontColor($r('app.color.ohos_id_color_palette8'))
                  .fontSize($r('app.string.ohos_id_text_size_body3'))
                  .onClick(() => {
                    promptAction.showToast({
                      message: $r('app.string.vibrateeffect_prompt_text')
                    });
                  })
                Span($r('app.string.vibrateeffect_privacy_policy'))
                  .fontColor($r('app.color.ohos_id_color_palette8'))
                  .fontSize($r('app.string.ohos_id_text_size_body3'))
                  .onClick(() => {
                    promptAction.showToast({
                      message: $r('app.string.vibrateeffect_prompt_text')
                    });
                  })
              }
              .flexShrink(CONFIGURATION.FLEX_SHRINK)
            }
            .width($r('app.string.vibrateeffect_full_size'))
            .alignItems(VerticalAlign.Top)

            // 若没有勾选协议，则会出现提示文本：“请阅读并勾选协议”
            Stack() {
              if (!this.confirm) {
                Column() {
                  Image($r("app.media.vibrateeffect_login_popup"))
                    .width($r('app.integer.vibrateeffect_image_size2'))
                    .height($r('app.integer.vibrateeffect_image_size2'))
                    .position({
                      x: CONFIGURATION.POPUP_POSITION_X,
                      y: CONFIGURATION.POPUP_POSITION_Y
                    })
                    .opacity(CONFIGURATION.OPACITY_VALUE)

                  Text($r('app.string.vibrateeffect_read_and_check'))
                    .fontColor($r('app.color.ohos_id_color_background'))
                    .fontSize($r('app.string.ohos_id_text_size_caption'))
                    .textAlign(TextAlign.Center)
                    .backgroundColor($r('app.color.ohos_id_color_foreground'))
                    .width($r('app.integer.vibrateeffect_text_width'))
                    .height($r('app.integer.vibrateeffect_mark_height'))
                    .position({
                      x: CONFIGURATION.MARK_POSITION_X,
                      y: CONFIGURATION.MARK_POSITION_Y
                    })
                    .borderRadius($r('app.string.ohos_id_corner_radius_subtab'))
                    .opacity(CONFIGURATION.OPACITY_VALUE)
                }
                .width($r('app.integer.vibrateeffect_elements_height'))
                .height($r('app.integer.vibrateeffect_total_mark_height'))
                .position({
                  x: this.translateX,
                  y: CONFIGURATION.POSITION_ZERO
                })
              }
            }
            .alignContent(Alignment.Start)
            .height($r('app.integer.vibrateeffect_total_mark_height'))
            .width($r('app.string.vibrateeffect_full_size'))
          }

          // 登录按钮
          Button($r('app.string.vibrateeffect_login_in'))
            .type(ButtonType.Normal)
            .borderRadius($r('app.string.ohos_id_corner_radius_default_m'))
            .fontColor($r('app.color.ohos_id_color_background'))
            .fontSize($r('app.string.ohos_id_text_size_body1'))
            .width($r('app.string.vibrateeffect_full_size'))
            .onClick(() => {
              // 点击登录按钮，若没有勾选协议则触发手机振动效果和抖动动画
              if (!this.confirm) {
                if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                  this.startVibrate();
                }
                this.startAnimation();
              } else {
                promptAction.showToast({
                  message: $r('app.string.vibrateeffect_login_text')
                });
              }
            })

          Text($r('app.string.vibrateeffect_other_login_methods'))
            .fontColor($r('app.color.ohos_id_color_palette8'))
            .fontSize($r('app.string.ohos_id_text_size_body2'))
            .onClick(() => {
              promptAction.showToast({
                message: $r('app.string.vibrateeffect_prompt_text')
              });
            })
        }
        .width($r('app.string.vibrateeffect_full_size'))
      }
      .scrollBar(BarState.Off)
    }
    .width($r('app.string.vibrateeffect_full_size'))
    .height($r('app.string.vibrateeffect_full_size'))
    .padding(12)
  }
}
