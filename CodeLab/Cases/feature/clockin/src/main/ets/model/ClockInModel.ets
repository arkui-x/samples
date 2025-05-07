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
 * ClockInController 类用于处理打卡相关的逻辑。
 * 该控制器负责获取当前位置地址等功能。
 */
export class ClockInController {
  /**
   * 获取当前位置地址的方法。
   * @returns {string} 当前位置的地址字符串。
   */
  getAddress: () => string = () => '';
}

/**
 * 定义了打卡信息的数据结构。
 * 包含打卡的时间和地址。
 */
export interface ClockInInfo {
  time: string
  address: string
}