/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
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

import { CommonConstants, CommonUtil } from '@ohos/utils';
import { Constants } from '../common/Constants';

@Component
export struct ArticleCardButtonView {
  @Prop isClicked: boolean = false;
  @Prop count: number = 0;
  @Prop textWidth: Resource = $r('app.float.default_icon_width');
  @Prop normalImage: Resource = $r('app.media.ic_failure');
  @Prop onImage: Resource = $r('app.media.ic_failure');
  onClicked?: () => void;

  build() {
    Row() {
      Stack() {
        if (this.isClicked) {
          Image(this.onImage)
            .margin({ right: $r('app.float.xs_padding_margin') })
            .size({ width: $r('app.float.default_icon_width'), height: $r('app.float.default_icon_width') })
        } else {
          Image(this.normalImage)
            .margin({ right: $r('app.float.xs_padding_margin') })
            .size({ width: $r('app.float.default_icon_width'), height: $r('app.float.default_icon_width') })
        }
      }

      Text(CommonUtil.transNumberOverOneThousand(this.count))
        .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
        .fontSize($r('app.float.small_text_size'))
        .width(this.textWidth)
        .opacity(Constants.SECOND_LEVEL_OPACITY)
    }
    .onClick(() => {
      animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
        this.isClicked = !this.isClicked;
        this.onClicked?.();
      })
    })
    .width($r('app.float.action_button_width'))
    .padding({ top: $r('app.float.sm_padding_margin'), bottom: $r('app.float.sm_padding_margin') })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}