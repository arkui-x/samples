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

export interface IndicatorAnimationInfo {
  // 背景条左边距
  left: number;
  // 页签条便宜
  offset: number;
  // 背景条高度
  height: number;
  // 背景条宽度
  width: number;
  // 是否初始化(true: 已初始化, false: 未初始化)
  flag: boolean;
}