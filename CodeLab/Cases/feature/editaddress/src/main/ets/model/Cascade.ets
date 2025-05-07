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
 * @param {string} text 一级联动名称
 * @param {Array<Cascade>} children 下级联动数组
 */
export class Cascade {
  text: string = '';
  children?: Array<Cascade> = [];

  constructor(text: string, children?: Array<Cascade>) {
    this.text = text;
    this.children = children;
  }
}
