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

import {BasicDataSource} from './DataSource'

// 页面展示数据类型
export class ShowData {
  // 车型的不同部件
  sticky: string = '';
  // 不同部件对应的详细参数
  sub: BasicDataSource<PartInfo> = new BasicDataSource();
  // 每一个部件对应的控制器数组，与详细参数一一对应
  scrollerArray: Scroller[] = [];
}

// car.json文件读取后内容的数据类型
export class CarTypeData {
  // 车型的不同部件
  sticky: string = '';
  // 不同部件对应的详细参数
  sub: PartInfo[] = [];
  // 每一个部件对应的控制器数组，与详细参数一一对应
  scrollerArray: Scroller[] = [];
}

// 所有车型部件对应的详细参数信息
export class PartInfo {
  // 车型部件
  part: string = '';
  // 详细参数信息
  info: string[] = [];
}