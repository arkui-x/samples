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

import { PlatformTypeEnum, ThirdLevelCategory } from '../model/CategoricalDataType'

export const DEMOS: ThirdLevelCategory[] = [
  {
    image: $r('app.media.platform_bridge'),
    title: $r('app.string.platform_bridge'),
    want: {
      bundleName: 'com.example.enjoyarkuix',
      moduleName: 'PlatformBridge',
      abilityName: 'PlatformBridgeAbility',
    },
    platform: PlatformTypeEnum.SUPPORT_BOTH
  },
  {
    image: $r('app.media.platform_view'),
    title: $r('app.string.platform_view'),
    want: {
      bundleName: 'com.example.enjoyarkuix',
      moduleName: 'PlatformView',
      abilityName: 'PlatformViewAbility',
    },
    platform: PlatformTypeEnum.SUPPORT_BOTH
  },
  {
    image: $r('app.media.fragment'),
    title: $r('app.string.fragment'),
    want: {
      bundleName: 'com.example.enjoyarkuix',
      abilityName: 'FragmentEntry',
    },
    platform: PlatformTypeEnum.SUPPORT_ANDROID
  },
  {
    image: $r('app.media.dynamization'),
    title: $r('app.string.dynamization'),
    want: {
      bundleName: 'com.example.enjoyarkuix',
      moduleName: 'Dynamization',
      abilityName: 'Jump',
    },
    platform: PlatformTypeEnum.SUPPORT_BOTH
  }
]