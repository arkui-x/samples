/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import { FirstLevelCategory } from '../model/CategoricalDataType'
import { DEMOS } from './DemosData'
import { SELF_TEST } from './SelfTestData'
import { VERSIONS } from './VersionsData'

export const HOME_TAB_DATA: FirstLevelCategory[] = [
  {
    childNodes: SELF_TEST,
    selectedImage: $r('app.media.ic_select_component'),
    unselectedImage: $r('app.media.ic_unselect_component'),
    tabBarName: $r('app.string.self_test')
  },
  {
    childNodes: DEMOS,
    selectedImage: $r('app.media.ic_select_universal'),
    unselectedImage: $r('app.media.ic_unselect_universal'),
    tabBarName: $r('app.string.demos')
  },
  {
    childNodes: VERSIONS,
    selectedImage: $r('app.media.ic_select_animation'),
    unselectedImage: $r('app.media.ic_unselect_animation'),
    tabBarName: $r('app.string.versions')
  },
]