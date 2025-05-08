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

export class Constants {
  static readonly HUNDRED_PERCENT: number = 100; // 百分比最大值
  static readonly MAX_BRIGHTNESS: number = 255; // 最大亮度
  static readonly DEFAULT_BRIGHTNESS: number = 10; // 默认亮度
  static readonly DANMU_RESIZE_TIME: number = 300; // 默认亮度
  static readonly COUNT_DOWN_TIME: number = 3; // UI自动隐藏倒计时时间
  static readonly MS_IN_SECOND: number = 1000; // 1s对应毫秒数
  static readonly SECOND_IN_MINUTE: number = 60; // 1min对应秒数
  static readonly MINUTE_IN_HOUR: number = 60; // 1h对应分钟数
  static readonly SECOND_IN_HOUR: number = 3600; // 1h对应秒数
  static readonly MAX_DANMAKU_LINES: number = 5; // 滚动弹幕最大显示行数
  static readonly DANMAKU_STYLE: number = 3; // 滚动弹幕最大显示行数
  static readonly DANMAKU_SCROLL_SPEED: number = 1.2; // 弹幕滚动速率
  static readonly DANMAKU_SCALE_TEXT_SIZE: number = 1.2; // 缩放字体大小
  static readonly DANMAKU_MARGIN: number = 40; // 弹幕显示外边距
}