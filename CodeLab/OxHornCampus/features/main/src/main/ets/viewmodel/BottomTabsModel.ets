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

import { BottomTabsItem } from './BottomTabsItem';

export const BottomTabsList: Array<BottomTabsItem> = [
  {
    icon: $r('app.media.ic_home'),
    iconSelected: $r('app.media.ic_home_selected'),
    text: $r('app.string.bottom_text_map')
  },
  {
    icon: $r('app.media.ic_find'),
    iconSelected: $r('app.media.ic_find_selected'),
    text: $r('app.string.bottom_text_zones')
  },
  {
    icon: $r('app.media.ic_drive'),
    iconSelected: $r('app.media.ic_drive_selected'),
    text: $r('app.string.bottom_text_trains')
  }
]