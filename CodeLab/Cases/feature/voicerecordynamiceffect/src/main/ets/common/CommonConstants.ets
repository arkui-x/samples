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

import { PlatformInfo, PlatformTypeEnum } from 'utils'

export class CommonConstants {
  static readonly MAX_AMPLITUDE: number = 15000;
  static readonly MIN_AMPLITUDE: number = 2000;
  static readonly COLUMN_HEIGHT: number = 100;
  static readonly SET_INTERVAL_TIME: number = 100;
  static readonly OPACITY_FALSE: number = 0;
  static readonly OPACITY_TRUE: number = 1;
  static readonly COLUMN_WIDTH: number = 5;
  static readonly HEIGHT_MIN: number = 60;
  static readonly HEIGHT_ROW: number = 60;
  static readonly ANIMATION_DURATION: number = 500;
  static readonly AUDIO_BITRATE: number = 100000;
  static readonly AUDIO_CHANNELS: number = 2;
  static readonly AUDIO_SAMPLE_RATE: number = 48000;
  static readonly BLANK_COLUMN: number = 20;
  static readonly BLANK_row: number = 10;
  static readonly HEIGHT_ST: number = 70;
  static readonly GESTURE_DISTANCE: number = -20;
  static readonly BOTTOM_AVOID_HEIGHT: number = 28;
  static readonly VERIFY_TEXT: string = "这是模拟识别的文字";
  static readonly SENDER: string = "me";
  static readonly FILE_NAME: string = PlatformInfo.getPlatform() === PlatformTypeEnum.IOS ? '01.m4a' : '01.mp3';
}