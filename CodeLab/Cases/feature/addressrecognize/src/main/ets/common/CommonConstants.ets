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

export class CommonConstants {
  //toast停留时间
  static readonly TOAST_DURATION: number = 2000;
  static readonly FONT_WEIGHT: number = 500;
  //分割线高度
  static readonly DIVIDER_HEIGHT: number = 2;
  static readonly MIN_BORDER_WIDTH: number = 1;
  //输入地址最大字数
  static readonly ADDRESS_MAX_LENGTH: number = 200;
  static readonly BOTTOM_MARGIN: number = 10;
  //组件间距
  static readonly SPACE_GAP_24 = 24;
  static readonly SPACE_GAP_12 = 12;
  static readonly SPACE_GAP_10 = 10;
  static readonly SPACE_GAP_8 = 8;
  static readonly SPACE_GAP_4 = 4;
  static readonly SPACE_GAP_2 = 2;
  //动画过渡时长
  static readonly ANIMATION_DURATION = 200;

  static readonly DEFAULT_TEXT: string = '粘贴文本到此处，将自动识别收货信息 例：涛涛，18888888888，浙江省杭州市西湖区某小区';
  // 相机选择器处理成功
  static readonly CAMERA_PICKER_RESULT_CODE_SUCCESS: number = 0;
  // 相机选择器处理失败
  static readonly CAMERA_PICKER_RESULT_CODE_FAILURE: number = -1;
}