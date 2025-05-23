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

import { Header } from './Header';
import { LiveList } from './LiveList';
import { LiveConstants } from '../constants/LiveConstants';
import { PlatformInfo, PlatformTypeEnum } from '@ohos/mediaCommon';

@Entry({ routeName: 'LivePage' })
@Component
export struct LivePage {
  build() {
    Column() {
      Header().margin({ top: 10 })
      LiveList()
    }
    .width(LiveConstants.FULL_WIDTH_PERCENT)
    .height(LiveConstants.FULL_HEIGHT_PERCENT)
    .padding({
      top: PlatformInfo.getPlatform() == PlatformTypeEnum.IOS ? AppStorage.get<number>('statusBarHeight') : 0
    })
  }
}