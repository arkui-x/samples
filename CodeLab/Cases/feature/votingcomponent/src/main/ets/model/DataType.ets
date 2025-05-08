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

import Constants from '../constants/Constants';

/**
 * 投票属性
 *
 * @param {number} leftOptionChoose - 左边选项投票人数
 * @param {number} rightOptionChoose - 右边选项投票人数
 * @param {string} leftOption - 左边选项文本
 * @param {string} right - 右边选项文本
 */
export class VotingType {
  leftOptionChoose: number;
  rightOptionChoose: number;
  leftOption: string;
  rightOption: string;

  constructor(leftOptionChoose: number = 0, rightOptionChoose: number = 0, leftOption: string = Constants.LEFT_OPTION,
    rightOption: string = Constants.RIGHT_OPTION) {
    this.leftOptionChoose = leftOptionChoose;
    this.rightOptionChoose = rightOptionChoose;
    this.leftOption = leftOption;
    this.rightOption = rightOption;
  }
}