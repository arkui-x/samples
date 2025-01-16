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

import { AudioPlayerAspect } from './AudioPlayerAspect';
import { DiscoverAspect } from './DiscoverAspect';
import { LearningAspect } from './LearningAspect';
import { LoginAspect } from './LoginAspect';
import { MineAspect } from './MineAspect';
import { TopicAspect } from './TopicAspect';
import { WebAspect } from './WebAspect';
import { PlatformInfo, PlatformTypeEnum } from '@ohos/utils';

export class IndexAspect {
  static initAspect() {
    let platform: PlatformTypeEnum = PlatformInfo.getPlatform();
    DiscoverAspect.createAspect();
    LearningAspect.createAspect();
    TopicAspect.createAspect();
    WebAspect.createAspect();
    LoginAspect.createAspect();
    MineAspect.createAspect();
    if (platform == PlatformTypeEnum.HARMONYOS) {
      AudioPlayerAspect.createAspect();
    }
  }
}