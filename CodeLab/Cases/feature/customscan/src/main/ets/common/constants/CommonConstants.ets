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

/**
 * 通用常量
 */
export default class CommonConstants {
  /**
   * 相机权限名称
   */
  static readonly PERMISSION_CAMERA = 'ohos.permission.CAMERA';

  /**
   * 相机流展示组件（XComponent）唯一标识
   */
  static readonly CAMERA_XCOMPONENT_ID = 'camera_xcomponent_id';
  /**
   * 相机流展示组件（XComponent）类型
   */
  static readonly CAMERA_XCOMPONENT_TYPE = 'surface';

  /**
   * 相机权限未授权提示持续时间
   */
  static readonly TOAST_PERMISSIONS_DENIED = 2000;
  /**
   * 关闭扫描按钮尺寸
   */
  static readonly SCAN_CTRL_BTN_CLOSE_SIZE = 30;
  /**
   * 闪光灯按钮尺寸
   */
  static readonly SCAN_CTRL_BTN_LIGHT_SIZE = 40;
  /**
   * 扫描动画组件终点透明度
   */
  static readonly SCAN_DIVIDER_OPACITY_END = 0;

  static readonly SCAN_DURATION = 400;
  /**
   * 设备类型
   */
  static readonly DEVICE_TYPES: string[] = ['phone', 'tablet'];
  /**
   * 未展开态屏幕比例
   */
  static readonly NOT_FOLD_DEVICE_EXPAND_RATIO: number = 9 / 16;
  /**
   * 展开态屏幕比例
   */
  static readonly FOLD_DEVICE_EXPAND_RATIO: number = 1;
  static readonly TITLE_MARGIN_TOP: number = 8;
  static readonly TITLE_MAIN_LINE_HEIGHT: number = 24;
  static readonly TOP_BUTTON_HEIGHT: number = 56;
  /**
   *  Scanning line margin
   */
  static readonly SCAN_LINE_MARGIN: number = 24;
  /**
   * 可折叠设备的导航栏高度
   */
  static readonly FOLD_DEVICE_NAV_HEIGHT: number = 38.72;
  /**
   * 不可折叠设备的导航栏高度
   */
  static readonly PHONE_NAV_HEIGHT: number = 38.86;
  /**
   *  TABLET_设备的导航栏高度
   */
  static readonly TABLET_NAV_HEIGHT: number = 39;
  /**
   * 扫描动画配置
   */
  static readonly SCAN_ANI_CONFIG: AnimateParam = {
    duration: 1000, // 动画时间
    tempo: 0.5, // 动画速率
    curve: Curve.EaseInOut,
    iterations: -1, // 动画是否重复播放
    playMode: PlayMode.Normal,
  }
  static readonly SCAN_FONT_SIZE_SCALE_LIMIT_SYMBOL_TEXT: number = 1.45;
  static readonly SCAN_FONT_SIZE_SCALE_LIMIT_TITLE_TEXT: number = 1.75;
  static readonly SCAN_FONT_SIZE_SCALE_LIMIT_2: number = 2;
  static readonly SCAN_FONT_SIZE_SCALE_LIMIT_DIALOG_TEXT: number = 3.2;

  static readonly GLOBAL_SCAN_DEVICE_IS_FOLDING: string = 'hmsCore_scan_isFoldable';
  static readonly GLOBAL_SCAN_DEVICE_TYPE: string = 'hmsCore_scan_device_type';
  static readonly GLOBAL_SCAN_TOP_RECT_HEIGHT: string = 'scan_topRect_height';
  static readonly GLOBAL_SCAN_IS_DECODING_GALLERY: string = 'scan_is_decoding_gallery';
  static readonly GLOBAL_SCAN_SELECT_A_PICTURE: string = 'scan_select_a_picture';
  static readonly EVENT_SCREEN_OFF: boolean = false;
  static readonly EVENT_SCREEN_ON: boolean = true;

  /**
   * 图像识别结果页面
   */
  static readonly SUB_PAGE_DETECT_BARCODE: string = 'detectBarcodePage';
  /**
   * 提示文案：图像识别无二维码信息
   */
  static readonly DETECT_NO_RESULT: string = '未识别到有效的二维码';
}

