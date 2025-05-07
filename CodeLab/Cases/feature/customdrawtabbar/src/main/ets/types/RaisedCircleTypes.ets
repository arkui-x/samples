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

import { ChamferInfo } from '../utils/CircleClass';

/**
 * 修改 定位的x和y
 */
export interface RaisedCircleSetPostionXYType {
  x?: number,
  y?: number
}

/**
 * 凸圆的类型
 */
export interface TabItemSelectType {
  // tabBar 高度
  tabHeight: number,

  // 选中的下标
  selectIndex: number,

  // 圆和倒角信息
  chamfer: ChamferInfo,

  // 选中的id
  selectBodyId: string,

  // 每个tabBar 的id前缀
  tabItemId: string,

  // tab背景色
  tabsBgColor: Color | number | string | Resource,

  // 选中背景色
  tabsSelectBgColor: Color | number | string | Resource
}