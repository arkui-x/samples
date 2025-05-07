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
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PatternLockComponent } from './PatternLockComponent';

/**
 * 功能说明: 本示例介绍使用图案密码锁组件与振动接口实现图形锁屏场景
 *
 * 推荐场景: 需要手势密码的场景，如：手机开锁、隐私应用开启等场景
 *
 * 核心组件:
 * 1. PatternLockComponent
 *
 * 实现步骤:
 *  1.使用PatternLock组件展示图形密码锁界面
 *  2.在onPatternComplete事件中进行图形密码设置与验证
 *  3.使用startVibration接口实现振动效果
 */
@Component
export struct PatternLockMainPage {
  // 初始密码：解锁图案为大写字母Z
  @State initalPasswords: number[] = [0, 1, 2, 4, 6, 7, 8];
  @State passwords: number[] = [];
  // 主页上方提示信息
  @State message: ResourceStr = $r('app.string.pattern_lock_message_1');
  // PatternLock组件控制器，可用于控制组件状态重置
  private patternLockController: PatternLockController = new PatternLockController();

  onPageHide(): void {
    // 重置密码锁状态
    this.patternLockController.reset();
    this.message = $r('app.string.pattern_lock_message_1');
  }

  startVibrator(vibratorCount?: number) {
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

  build() {
    Column() {
      Column() {
        Text(this.message)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.integer.pattern_lock_message_fontsize'))
      }
      .justifyContent(FlexAlign.Center)
      .height($r('app.string.pattern_lock_size_twenty'))
      .width($r('app.string.pattern_lock_size_full'))

      Column() {
        /**
         * 图形锁屏封装组件
         *    1.使用PatternLock组件实现图形锁屏模块布局及图形密码处理逻辑及输入动效，参考文档https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-basic-components-patternlock-V5
         *    2.使用@ohos.vibrator接口实现设备振动效果，操作完成或失败时触发振动效果，参考文档https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-vibrator-V5
         *    3.自定义组件参数说明
         *        patternLockController: PatternLock组件控制器，可用于控制组件状态
         *        message: 组件状态信息，使用@Link装饰器修饰，用于组件状态信息的展示
         *        initalPasswords: 初始密码为大写字母Z，九宫格分别代表数字0-8，使用@Link装饰器，用于控制组件的图形密码校验
         *        passwords: 图形密码临时数据，使用@Link装饰器修饰，用于进行图形密码设置
         *    4.扩展说明
         *        锁屏组件: 可通过PatternLock组件属性修改组件样式
         *        振动效果: 可通过vibrator.startVibration接口设置振动效果，当前使用系统预置振动效果haptic.clock.timer
         */
        PatternLockComponent({
          patternLockController: this.patternLockController,
          message: this.message,
          initalPasswords: this.initalPasswords,
          passwords: this.passwords
        })
        Row({ space: 20 }) {
          Button($r('app.string.pattern_lock_button_1'))
            .onClick(() => {
              // 重置PatternLock状态
              this.patternLockController.reset();
              this.initalPasswords = [];
              this.passwords = [];
              this.message = $r('app.string.pattern_lock_message_8');
            })

          Button($r('app.string.pattern_lock_button_2'))
            .onClick(() => {
              // 重置PatternLock状态
              this.patternLockController.reset();
              this.initalPasswords = [0, 1, 2, 4, 6, 7, 8];
              this.passwords = [];
              this.message = $r('app.string.pattern_lock_message_9');
            })
        }
        .margin({ bottom: $r('app.integer.pattern_lock_row_margin') })
      }
      .justifyContent(FlexAlign.End)
      .width($r('app.string.pattern_lock_size_full'))
      .height($r('app.string.pattern_lock_size_seventy_five'))
    }
    .height($r('app.string.pattern_lock_size_full'))
    .width($r('app.string.pattern_lock_size_full'))
  }
}