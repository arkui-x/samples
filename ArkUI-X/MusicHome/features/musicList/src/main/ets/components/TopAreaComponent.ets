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

import { BreakpointConstants, StyleConstants } from '@ohos/constantsCommon';
import { BreakpointType } from '@ohos/mediaCommon';

@Component
export struct TopAreaComponent {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = 'sm';
  @Link isShowPlay: boolean;

  build() {
    Row() {
      Image($r('app.media.ic_back_down'))
        .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
        $r('app.float.back_width_lg') : $r('app.float.common_iamge'))
        .height(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
        $r('app.float.back_width_lg') : $r('app.float.common_iamge'))
        .onClick(() => {
          this.isShowPlay = false;
        })
      Image($r('app.media.ic_music_share'))
        .width(new BreakpointType({
          sm: $r('app.float.common_iamge'),
          md: $r('app.float.common_iamge'),
          lg: $r('app.float.control_image_lg')
        }).getValue(this.currentBreakpoint))
        .height(new BreakpointType({
          sm: $r('app.float.common_iamge'),
          md: $r('app.float.common_iamge'),
          lg: $r('app.float.control_image_lg')
        }).getValue(this.currentBreakpoint))
        .objectFit(ImageFit.Contain)
    }
    .height($r('app.float.info_margin_top_sm'))
    .width(StyleConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}