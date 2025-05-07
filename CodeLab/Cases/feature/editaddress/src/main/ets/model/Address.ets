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
 * 表单验证的数据结构
 * @param {string} name 收件人
 * @param {string} areaName 省市区
 * @param {number | number []} provinceArr 处理后的省市区数组
 * @param {string} area 详细地址
 * @param {string} phone 手机号
 * @param {string} tag 地址标签
 */
export class Address {
  name: string = '';
  areaName: string = '';
  provinceArr: number | number [] = [0, 0, 0];
  area: string = '';
  phone: string = '';
  tag: string = '';

  constructor(name: string, areaName: string, provinceArr: number | number [], area: string, phone: string,
    tag: string) {
    this.name = name;
    this.provinceArr = provinceArr;
    this.areaName = areaName;
    this.area = area;
    this.phone = phone;
    this.tag = tag;
  }
}

// 输入框标签数据结构
export class Label {
  labelName: ResourceStr = '';
}