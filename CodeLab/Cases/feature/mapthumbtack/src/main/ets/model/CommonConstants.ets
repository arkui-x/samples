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

export class ThumbTackCommonConstants {
  static readonly ICON_WIDTH_HEIGHT_RATIO: number = 0.625;
  static readonly TACK_HAT_HEIGHT_RATIO: number = 1;
  static readonly TACK_HAT_ANIMATION_HEIGHT_RATIO: number = 0.3;
  static readonly TACK_HAT_BRIM_WIDTH_RATIO: number = 0.35;
  static readonly ICON_UP_LAYER_RING_Z_IDX: number = 3;
  static readonly ICON_DOWN_LAYER_RING_Z_IDX: number = 2;
  static readonly TACK_POST_HEIGHT_RATIO: number = 1.1;
  static readonly TACK_POST_WIDTH_RATIO: number = 0.15;
  static readonly TACK_POST_RADIUS_RATIO: number = 0.075;
  static readonly TACK_POST_ANIMATION_HEIGHT_RATIO: number = 1.5;
  static readonly TACK_POST_ANIMATION_OFFSET_RATIO: number = 0.5;
  static readonly ICON_COMMON_ANIMATION_DURATION: number = 300;
  static readonly TACK_POST_ANIMATION_OFFSET_DURATION: number = 150;
  static readonly ICON_START_ANIMATION_DELAY: number = 10;
}

export class AddressPopupCommonConstants {
  static readonly POPUP_COMP_RADIUS: number = 8;
  static readonly POPUP_COMP_MAX_WIDTH: number = 110;
  static readonly TIP_AREA_PATH: string =
    'M0 0 C' + vp2px(2.5) + ' ' + vp2px(0) + ' ' + vp2px(5.6) + ' ' + vp2px(2.4) + ' '
      + vp2px(6.2) + ' ' + vp2px(4.9) + ' L' + vp2px(10) + ' ' + vp2px(20) + ' L0 ' + vp2px(20) + 'Z';
  static readonly TIP_AREA_HEIGHT: number = 20;
  static readonly TIP_AREA_LEFT_PADDING: number = 5;
  static readonly TIP_FONT_SIZE: number = 12;
  static readonly ADDR_TEXT_MAX_LINES: number = 2;
  static readonly ADDR_FONT_SIZE: number = 12;
  static readonly ADDR_IMAGE_SIZE: number = 30;
  static readonly ADDR_IMAGE_MARGIN: number = 5;
  static readonly IMAGE_COMP_RADIUS: number = 4;
  static readonly ARROW_ICON_SIZE: number = 12;
  static readonly ARROW_SIZE: number = 10;
}

export enum ThumbTackState {
  EMPTY,
  LOADING,
  SHOWING
}
