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

import { ColSpanEnum, ColumnEnum, CommonConstants, OffsetEnum } from '@ohos/utils';
import { Constants } from '../common/Constants';

@Component
export struct InteractiveAreaView {
  @Prop isLiked: boolean = false;
  @Prop isCollected: boolean = false;
  onCollected?: () => void;
  onLiked?: () => void;

  build() {
    Column() {
      GridRow({
        columns: {
          xs: ColumnEnum.SM,
          sm: ColumnEnum.SM,
          md: ColumnEnum.MD,
          lg: ColumnEnum.LG
        },
        gutter: {
          x: {
            xs: $r('app.float.xxl_padding_margin'),
            sm: $r('app.float.xxl_padding_margin'),
            md: $r('app.float.md_padding_margin'),
            lg: $r('app.float.md_padding_margin')
          }
        },
        breakpoints: { reference: BreakpointsReference.ComponentSize }
      }) {
        GridCol({
          span: {
            xs: ColSpanEnum.SM,
            sm: ColSpanEnum.SM,
            md: ColSpanEnum.MD,
            lg: ColSpanEnum.LG
          },
          offset: {
            xs: OffsetEnum.SM,
            sm: OffsetEnum.SM,
            md: OffsetEnum.MD,
            lg: OffsetEnum.LG
          }
        }) {
          InteractiveButton({
            img: this.isLiked ? $r('app.media.ic_good_on') : $r('app.media.ic_good_off'),
            text: $r('app.string.like'),
            color: this.isLiked ? $r('app.color.main_red_color') : $r('sys.color.ohos_id_color_focused_content_second'),
            bgColor: this.isLiked ? $r('app.color.liked_bg_color') : $r('app.color.action_button_bg_color')
          })
            .onClick(() => {
              this.onLiked?.();
            })
        }

        GridCol({
          span: {
            xs: ColSpanEnum.SM,
            sm: ColSpanEnum.SM,
            md: ColSpanEnum.MD,
            lg: ColSpanEnum.LG
          },
        }) {
          InteractiveButton({
            img: this.isCollected ? $r('app.media.ic_collect_on') : $r('app.media.ic_collect_off'),
            text: $r('app.string.collect'),
            color: this.isCollected ? $r('app.color.theme_yellow_color') :
            $r('sys.color.ohos_id_color_focused_content_second'),
            bgColor: this.isCollected ? $r('app.color.collected_bg_color') : $r('app.color.action_button_bg_color')
          })
            .onClick(() => {
              this.onCollected?.();
            })
        }
      }
    }
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.float.interactive_area_height'))
    .justifyContent(FlexAlign.Center)
    .padding({ left: $r('app.float.xxl_padding_margin'), right: $r('app.float.xxl_padding_margin') })
    .linearGradient({
      colors: [[$r('app.color.interactive_linearGradient_color_1'), 0],
        [$r('app.color.interactive_linearGradient_color_2'), 1]]
    })
  }
}

@Component
struct InteractiveButton {
  @Prop img: Resource = $r('app.media.ic_failure');
  @Prop text: Resource = $r('app.string.like');
  @Prop color: Resource = $r('app.color.skeleton_color');
  @Prop bgColor: Resource = $r('app.color.white');

  build() {
    Button({ type: ButtonType.Capsule }) {
      Row() {
        Image(this.img)
          .interpolation(ImageInterpolation.High)
          .width($r('app.float.interactive_bar_icon_size'))
          .height($r('app.float.interactive_bar_icon_size'))
          .margin({ right: $r('app.float.sm_padding_margin') })
        Text(this.text)
          .fontSize($r('app.float.icon_size'))
          .fontColor(this.color)
          .fontWeight(FontWeight.Medium)
          .fontFamily(CommonConstants.HARMONY_HEITI_MEDIUM_FONT_FAMILY)
      }
    }
    .backgroundBlurStyle(BlurStyle.Regular, {
      colorMode: ThemeColorMode.SYSTEM,
      adaptiveColor: AdaptiveColor.DEFAULT,
      scale: Constants.BLUR_SCALE
    })
    .backgroundColor(this.bgColor)
    .height($r('app.float.interactive_button_height'))
    .width(CommonConstants.FULL_PERCENT)
  }
}