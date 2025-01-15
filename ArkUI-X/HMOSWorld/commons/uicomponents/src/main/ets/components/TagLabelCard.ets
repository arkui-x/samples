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

import { CommonConstants } from '@ohos/utils';

@Builder
export function TagLabelCard(text: string, color: string) {
  Text(text)
    .fontSize($r('app.float.xs_font_size'))
    .fontColor('#' + color)
    .textAlign(TextAlign.Center)
    .fontWeight(FontWeight.Medium)
    .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
    .borderRadius($r('app.float.xs_border_radius'))
    .backgroundColor('#1A' + color)
    .padding({
      left: $r('app.float.sm_padding_margin'),
      right: $r('app.float.sm_padding_margin'),
      top: $r('app.float.xxs_padding_margin'),
      bottom: $r('app.float.xxs_padding_margin')
    })
}