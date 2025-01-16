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
import { BreakpointType, MediaService } from '@ohos/mediaCommon';
import { PlayerConstants } from '../constants/PlayerConstants';

@Preview
@Component
export struct ControlAreaComponent {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @StorageLink('isPlay') isPlay: boolean = false;
  @StorageLink('currentTime') currentTime: string = '00:00';
  @StorageLink('totalTime') totalTime: string = '00:00';
  @StorageLink('progress') value: number = 0;
  @StorageLink('progressMax') max: number = 0;
  @State playModeIndex: number = 0;
  @StorageLink('imageColor') imageColor: string = '';
  @StorageLink('pageShowTime') pageShowTime: number = 0;

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_list_cycled'))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
        Image($r('app.media.ic_sequence'))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
        Image($r('app.media.ic_ring'))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
        Image($r("app.media.ic_more_white"))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.twenty_four'),
            md: $r('app.float.twenty_four'),
            lg: $r('app.float.control_image_lg')
          }).getValue(this.currentBreakpoint))
      }
      .width(StyleConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)

      Column() {
        Slider({
          min: 0,
          max: this.max,
          step: 1,
          value: this.value
        })
          .blockColor($r('app.color.slider_block'))
          .selectedColor($r('app.color.slider_select'))
          .trackColor($r('app.color.slider_track'))
          .blockSize({
            width: $r('app.float.slider_block'),
            height: $r('app.float.slider_block')
          })
          .onChange((value: number, mode: SliderChangeMode) => {
            if (value != this.max) {
              if (mode === SliderChangeMode.End || mode === SliderChangeMode.Begin) {
                MediaService.getInstance().seek(value);
              }
              this.pageShowTime = 0;
            }
          })
          .height($r('app.float.slider_height'))
          .margin({
            left: new BreakpointType({
              sm: $r('app.float.slider_margin_sm'),
              md: $r('app.float.slider_margin_md'),
              lg: $r('app.float.slider_margin_lg')
            }).getValue(this.currentBreakpoint),
            right: new BreakpointType({
              sm: $r('app.float.slider_margin_sm'),
              md: $r('app.float.slider_margin_md'),
              lg: $r('app.float.slider_margin_lg')
            }).getValue(this.currentBreakpoint)
          })
          .hitTestBehavior(HitTestMode.Block)
        Row() {
          Text(this.currentTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily(PlayerConstants.FONT_FAMILY_BLACK)
            .lineHeight('14vp')
          Text(this.totalTime)
            .fontColor($r('app.color.play_text_color'))
            .fontSize($r('app.float.singer_title_sm'))
            .fontFamily(PlayerConstants.FONT_FAMILY_BLACK)
            .lineHeight('14vp')
        }
        .width(StyleConstants.FULL_PERCENT)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .margin({
        top: $r('app.float.slider_margin_top'),
        bottom: this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
        $r('app.float.slider_margin_bottom_lg') : $r('app.float.slider_margin_bottom')
      })

      Row() {
        Image($r('app.media.ic_public_forward'))
          .controlImageBuilder()
          .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
          $r('app.float.control_width_lg') : $r('app.float.control_width'))
          .onClick(() => {
            MediaService.getInstance().playPrevious();
            this.pageShowTime = 0;
          })
        Image(this.isPlay ? $r('app.media.ic_public_play') : $r('app.media.ic_public_pause'))
          .controlImageBuilder()
          .width(new BreakpointType({
            sm: $r('app.float.image_play_width'),
            md: $r('app.float.image_play_width'),
            lg: $r('app.float.image_play_width_lg')
          }).getValue(this.currentBreakpoint))
          .onClick(() => {
            if (this.isPlay) {
              MediaService.getInstance().pause();
            } else {
              if (MediaService.getInstance().getFirst()) {
                MediaService.getInstance().loadAssent(0);
              } else {
                MediaService.getInstance().play();
              }
            }
            this.pageShowTime = 0;
          })
        Image($r('app.media.ic_public_next'))
          .controlImageBuilder()
          .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
          $r('app.float.control_width_lg') : $r('app.float.control_width'))
          .onClick(() => {
            MediaService.getInstance().playNextAuto(true);
            this.pageShowTime = 0;
          })
      }
      .width(StyleConstants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.float.control_padding'),
        right: $r('app.float.control_padding')
      })
    }
  }
}

@Extend(Image)
function controlImageBuilder() {
  .aspectRatio(1)
  .opacity(0.86)
  .objectFit(ImageFit.Contain)
}
