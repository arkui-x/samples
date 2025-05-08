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

import { CommonConstants } from '../common/CommonConstants';

@Component
export struct LoadingFailedView {
  handleReload?: () => void

  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_failure'))
          .width($r("app.float.ske_failure_img_size"))
          .height($r("app.float.ske_failure_img_size"))
        Text($r("app.string.ske_load_failed"))
          .fontColor($r("app.color.ske_reload_title_color"))
          .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
          .fontSize($r("app.float.ske_normal_text_size"))
          .margin({ top: $r("app.float.ske_sm_padding_margin") })
        Row() {
          Text($r("app.string.ske_reload"))
            .fontColor($r("app.color.ske_main_red_color"))
            .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
            .fontSize($r("app.float.ske_normal_text_size"))
            .width(CommonConstants.FULL_PERCENT)
            .textAlign(TextAlign.Center)
        }
        .height($r("app.float.ske_reload_btn_height"))
        .width($r("app.float.ske_reload_btn_width"))
        .margin({ top: $r("app.float.ske_sm_padding_margin") })
        .borderWidth(CommonConstants.BORDER_WIDTH)
        .borderColor($r("app.color.ske_main_red_color"))
        .borderRadius($r("app.float.ske_large_border_radius"))
        .onClick(this.handleReload)
      }
    }
    .justifyContent(FlexAlign.Center)
    .layoutWeight(CommonConstants.LAYOUT_WEIGHT)
  }
}