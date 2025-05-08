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

import { CommonConstants } from '../constants/CommonConstants';

/**
 * 列表视图阶段高度
 * @param {number} minHeight - 最小高度
 * @param {number} middleHeight - 第二阶段高度
 * @param {number} maxHeight - 最大高度
 */
export class BottomDrawerHeight {
  minHeight: number;
  middleHeight: number;
  maxHeight: number;

  constructor(minHeight: number = CommonConstants.BOTTOM_DRAWER_MIN_HEIGHT,
    middleHeight: number = CommonConstants.BOTTOM_DRAWER_MIDDLE_HEIGHT, maxHeight: number = 0) {
    this.minHeight = minHeight;
    this.middleHeight = middleHeight;
    this.maxHeight = maxHeight;
  }
}