/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
   * 首页图片宽度
   */
  static readonly firstImageWidth = 762;
  /**
   * 首页图片高度
   */
  static readonly firstImageHeight = 431;
  /**
   * 首页图片从视频中截取的开始时间
   */
  static readonly FIRST_IMAGE_START_TIME = 1000;
  /**
   * 首页图片从视频中截取的结束时间
   */
  static readonly FIRST_IMAGE_END_TIME = 12000;
  /**
   *  进度最大值
   */
  static readonly PROGRESS_MAX = 100;
  /**
   *  重试间隔
   */
  static readonly UPLOAD_INTERVAL_TIME = 1000;
  /**
   * 一秒钟毫秒数
   */
  static readonly MS_ONE_SECOND = 1000;
  /**
   * 一秒钟微秒数
   */
  static readonly US_ONE_SECOND = 1000000;
  /**
   * 压缩分辨率
   */
  static readonly SCALE_NUM = 100;
}