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

import Want from '@ohos.app.ability.Want'

export enum PlatformTypeEnum {
  BOTH = 'Android And iOS Platform',
  ANDROID = 'Android Platform',
  IOS = 'iOS Platform',
}

export interface FirstLevelCategory {
  childNodes: SecondLevelCategory[] | ThirdLevelCategory[],
  selectedImage: Resource,
  unselectedImage: Resource,
  tabBarName: Resource
}

export interface SecondLevelCategory {
  title: Resource,
  childNodes: ThirdLevelCategory[],
  image?: Resource
}

export interface ThirdLevelCategory {
  image: Resource,
  title: Resource,
  childNodes?: FourthLevelCategory[],
  want?: Want,
  platform?: PlatformTypeEnum
}

export interface FourthLevelCategory {
  title: Resource,
  want?: Want,
  platform?: PlatformTypeEnum
}