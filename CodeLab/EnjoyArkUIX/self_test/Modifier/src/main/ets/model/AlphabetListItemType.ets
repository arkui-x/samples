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
 * 首页组件列表数据
 * name:      数据名称的首字母
 * dataList:  该首字母对应的组件集合
 * urlList:   组件所在二级界面路径
 */
export class AlphabetListItemType {
  name: string
  dataList: string[]
  urlList: string[]

  constructor(name: string, dataList: string[], urlList: string[]) {
    this.name = name
    this.dataList = dataList
    this.urlList = urlList
  }
}