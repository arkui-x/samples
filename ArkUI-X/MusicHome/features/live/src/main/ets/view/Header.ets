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

import router from '@ohos.router';
import { LiveConstants } from '../constants/LiveConstants';

@Component
export struct Header {
  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .width($r('app.float.back_width'))
        .height($r('app.float.title_height'))
        .margin({ left: $r('app.float.back_left_margin') })
        .onClick(() => {
          router.back()
        })

      Text($r('app.string.live_title'))
        .fontColor($r('app.color.live_title_color'))
        .fontFamily(LiveConstants.LIVE_TITLE_FONT_FAMILY)
        .fontWeight(LiveConstants.TITLE_FONT_WEIGHT)
        .fontSize($r('app.float.title_font_size'))
        .margin({ left: $r('app.float.title_left_margin') })
    }
    .height($r('app.float.title_row_height'))
    .width(LiveConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.Start)
  }
}