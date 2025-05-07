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

import { LengthUnit, promptAction } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { vibrator } from "@kit.SensorServiceKit";
import { PlatformInfo, PlatformTypeEnum } from 'utils';

@Component
export struct PatternLockComponent {
  patternLockController: PatternLockController | undefined = undefined;
  // TODO:知识点 使用@Link装饰器，与组件调用页面进行图案锁屏组件状态信息交互
  @Link message: ResourceStr;
  @Link initalPasswords: number[];
  @Link passwords: number[];

  aboutToAppear(): void {
    // 当未传入PatternLockController时，设置图案锁状态与重置图案锁功能无法使用
    if (!this.patternLockController) {
      promptAction.showToast({
        message: $r('app.string.pattern_lock_message_without_controller'),
        duration: 1000
      })
    }
  }

  // 触发设备振动
  startVibrator(vibratorCount?: number) {
    if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
      try {
        vibrator.startVibration({
          // 设置为'preset'，可使用系统预置振动效果
          type: 'preset',
          // 当前仅支持一种预置振动效果
          effectId: 'haptic.clock.timer',
          // 振动次数，默认振动1次
          count: vibratorCount && vibratorCount > 1 ? vibratorCount : 1
        }, {
          // 马达振动的使用场景
          usage: 'unknown'
        }, (error: BusinessError) => {
          if (error) {
            console.error(`Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          } else {
            console.info(`Success to start vibration.`);
          }
        })
      } catch (err) {
        const error: BusinessError = err as BusinessError;
        console.error(`An unexpected error occurred. Code: ${error.code}, message: ${error.message}`);
      }
    }
  }

  build() {
    PatternLock(this.patternLockController)
      .border({
        radius: $r('app.integer.pattern_lock_border_radius')
      })// 设置组件的宽度和高度（宽高相同）
      .sideLength($r('app.integer.pattern_lock_side_length'))// 设置宫格中圆点的半径
      .circleRadius($r('app.integer.pattern_lock_circle_radius'))// 设置连线的宽度
      .pathStrokeWidth(14)// 设置连线的颜色
      .pathColor($r('app.color.pattern_lock_path_color'))// 设置宫格圆点在“激活”状态的填充颜色，“激活”状态为手指经过圆点但还未选中的状态
      .activeColor($r('app.color.pattern_lock_active_color'))// 设置宫格圆点在“选中“状态的填充颜色
      .selectedColor($r('app.color.pattern_lock_selected_color'))// 设置在完成密码输入后再次在组件区域按下时是否重置组件状态，默认为true
      .autoReset(true)// 设置宫格圆点在“激活”状态的背景圆环样式
      .activateCircleStyle({
        color: $r('app.color.pattern_lock_active_circle_color'),
        radius: {
          value: 18,
          unit: LengthUnit.VP
        },
        enableWaveEffect: true
      })// TODO:知识点 密码输入选中宫格原点时触发该回调，在此时机调用振动接口
      .onDotConnect(() => {
        if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
          // 触发振动效果
          this.startVibrator();
        }
      })// TODO:知识点 密码输入结束时触发该回调，用于密码校验与设置
      .onPatternComplete((input: number[]) => {
        // 输入密码长度小于5位时，提示错误
        if (!input || input.length < 5) {
          this.message = $r('app.string.pattern_lock_message_2');
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
            this.startVibrator(2);
          }
          // 设置图案密码错误
          this.patternLockController?.setChallengeResult(PatternLockChallengeResult.WRONG);
          setTimeout(() => {
            this.patternLockController?.reset();
          }, 1000);
          return;
        }

        if (this.initalPasswords.length > 0) {
          if (this.initalPasswords.toString() === input.toString()) {
            this.message = $r('app.string.pattern_lock_message_3');
            if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
              this.startVibrator();
            }
            setTimeout(() => {
              this.patternLockController?.reset();
              this.message = $r('app.string.pattern_lock_message_1');
              promptAction.showToast({
                message: $r('app.string.pattern_lock_message_3'),
                duration: 1000
              })
            }, 1000);
          } else {
            this.message = $r('app.string.pattern_lock_message_4');
            if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
              this.startVibrator(2);
            }
            this.patternLockController?.setChallengeResult(PatternLockChallengeResult.WRONG);
            setTimeout(() => {
              this.patternLockController?.reset();
            }, 500);
          }
        } else {
          // 判断密码长度是否大于0，当前处于第二次输入密码状态
          if (this.passwords.length > 0) {
            if (this.passwords.toString() === input.toString()) {
              this.initalPasswords = input;
              this.passwords = [];
              this.message = $r('app.string.pattern_lock_message_5');
              this.patternLockController?.setChallengeResult(PatternLockChallengeResult.CORRECT);
              if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                this.startVibrator();
              }
              setTimeout(() => {
                this.patternLockController?.reset();
              }, 1000);
            } else {
              this.message = $r('app.string.pattern_lock_message_6');
              if (PlatformInfo.getPlatform() === PlatformTypeEnum.HARMONYOS) {
                this.startVibrator(2);
              }
              this.patternLockController?.setChallengeResult(PatternLockChallengeResult.WRONG);
              setTimeout(() => {
                this.patternLockController?.reset();
              }, 1000);
            }
          } else {
            this.passwords = input;
            this.message = $r('app.string.pattern_lock_message_7');
            setTimeout(() => {
              this.patternLockController?.reset();
            }, 1000);
          }
        }
      })
  }
}