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
 * 省、市、区共用的地址列表类
 */
export class CommonAddressList {
  code: string; // 存放省、市、区id
  name: string; // 存放省、市、区名

  constructor(code: string = '', name: string = '') {
    this.code = code;
    this.name = name;
  }
}

/**
 * 省信息类
 */
export class Province {
  code: string; // 省id
  name: string; // 省名
  children: City[]; // 存放市、区信息

  constructor(code: string = '', name: string = '', children: City[]) {
    this.code = code;
    this.name = name;
    this.children = children;
  }
}

/**
 * 市信息类
 */
class City {
  code: string = ''; // 市id
  name: string = ''; // 市名
  children: Region[]; // 存放区信息

  constructor(code: string = '', name: string = '', children: Region[]) {
    this.code = code;
    this.name = name;
    this.children = children;
  }
}

/**
 * 区信息类
 */
class Region {
  code: string = ''; // 区id
  name: string = ''; // 区名

  constructor(code: string = '', name: string = '') {
    this.code = code;
    this.name = name;
  }
}

/**
 * 省市区类型枚举
 */
export enum AddressType {
  Province = 0,
  City = 1,
  Region = 2
}

/**
 * 地点类
 */
export class Location {
  index: number = 0; // 省、市、区index。0表示省，1表示市，2表示区
  name: string = ''; // 用于显示省、市、区名
}