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
 * 地址类
 */
@Observed
export class Address {
  name?: string;
  phone?: string;
  address?: string;
  tag?: string;
  defaultFlag: boolean = false;

  constructor(name: string, phone: string, address: string, tag: string, defaultFlag: boolean) {
    this.name = name;
    this.phone = phone;
    this.address = address;
    this.tag = tag;
    this.defaultFlag = defaultFlag;
  }

  isNull(): boolean {
    if(this.name === "" && this.phone === "" && this.address === ""){
      return true;
    }
    return false;
  }

}

/**
 * 标签类
 */
@Observed
export class Tag {

  label: string = "";
  bgColor: Resource | string = "";
  fontColor: Resource | string = "";

  constructor(label: string, bgColor: Resource | string, fontColor: Resource | string) {
    this.label = label;
    this.bgColor = bgColor;
    this.fontColor = fontColor;
  }

}

/**
 * 地址列表
 */
export const MOCK_ADDRESS_DATA: Array<Address> = [
  new Address("张三", "18888888888", "浙江省杭州市滨江区xx路xx号", "公司", false),
  new Address("李四", "18888888888", "福建省厦门市思明区xx路xx号", "家", false),
  new Address("王五", "18888888888", "江苏省南京市江宁区xx路xx号", "朋友", false)
]

/**
 * tag列表
 */
export const MOCK_TAG_DATA: Array<Tag> = [
  new Tag("家", "#f1f3f5", "#000000"),
  new Tag("公司", "#f1f3f5", "#000000"),
  new Tag("朋友", "#f1f3f5", "#000000")
]