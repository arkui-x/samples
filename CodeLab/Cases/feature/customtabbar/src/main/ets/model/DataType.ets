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
 * TabBar data type.
 *
 * @param id: 页签id
 * @param title: 页签名称
 * @param selectedIcon: 被选中图片
 * @param defaultIcon: 默认图片
 * @param selectedFontColor: 被选中页签文本颜色
 * @param defaultFontColor: 默认页签文本颜色
 */
export class TabBarInfo {
  id: number;
  title: ResourceStr;
  selectedIcon: ResourceStr;
  defaultIcon: ResourceStr;
  selectedFontColor: ResourceColor;
  defaultFontColor: ResourceColor;

  constructor(id: number, title: ResourceStr, selectedIcon: ResourceStr, defaultIcon: ResourceStr,
    selectedFontColor: ResourceColor, defaultFontColor: ResourceColor) {
    this.id = id;
    this.title = title;
    this.selectedIcon = selectedIcon;
    this.defaultIcon = defaultIcon;
    this.selectedFontColor = selectedFontColor;
    this.defaultFontColor = defaultFontColor;
  }
}