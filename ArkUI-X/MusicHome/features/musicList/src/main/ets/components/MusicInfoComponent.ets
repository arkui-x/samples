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
import { SongItem } from '@ohos/mediaCommon';
import { PlayerConstants } from '../constants/PlayerConstants';
import { ControlAreaComponent } from './ControlAreaComponent';

@Preview
@Component
export struct MusicInfoComponent {
  @State currentTabIndex: number = 0;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') selectIndex: number = 0;
  @State isShowControl: boolean = false;

  build() {
    GridRow({
      columns: {
        xs: BreakpointConstants.COLUMN_SM,
        sm: BreakpointConstants.COLUMN_SM,
        md: BreakpointConstants.COLUMN_MD
      },
      gutter: BreakpointConstants.GUTTER_MUSIC_X,
      breakpoints: { reference: BreakpointsReference.ComponentSize }
    }) {
      GridCol({
        span: {
          xs: BreakpointConstants.SPAN_SM,
          sm: BreakpointConstants.SPAN_SM,
          md: BreakpointConstants.SPAN_MD
        },
        offset: { md: BreakpointConstants.OFFSET_MD }
      }) {
        Scroll() {
          Column() {
            this.CoverInfo()
            this.MusicInfo()
            Blank()
            ControlAreaComponent()
            Row().size({ width: StyleConstants.FULL_PERCENT, height: 50 })
          }
          .width(StyleConstants.FULL_PERCENT)
          .clip(false)
        }.scrollBar(BarState.Off)
      }
    }
  }

  @Builder
  CoverInfo() {
    Row() {
      Image(this.songList[this.selectIndex].label)
        .width(StyleConstants.FULL_PERCENT)
        .aspectRatio(1)
        .borderRadius($r('app.float.cover_radius_label'))
        .shadow({
          radius: $r('app.float.shadow_radius'),
          color: $r('app.color.shadow_color'),
          offsetX: 0,
          offsetY: 8
        })
        .margin($r('app.float.lyric_margin_right_sm'))
    }
  }

  @Builder
  MusicInfo() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text(this.songList[this.selectIndex].title)
          .fontSize(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.isFoldFull ?
          $r('app.float.title_font_play_md') : $r('app.float.title_font_play'))
          .fontColor(Color.White)
          .opacity(0.86)
          .fontWeight(FontWeight.Bold)
          .fontFamily(PlayerConstants.FONT_FAMILY_BOLD)
        Image($r('app.media.ic_public_likes'))
          .width($r('app.float.likes_image'))
          .height($r('app.float.likes_image'))
          .objectFit(ImageFit.Contain)
          .fillColor(Color.White)
          .opacity(0.86)
      }

      Text(this.songList[this.selectIndex].singer)
        .textAlign(TextAlign.Start)
        .fontSize(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_MD && !this.isFoldFull ?
        $r('app.float.title_font_play') : $r('app.float.font_fourteen'))
        .fontColor($r('app.color.play_text_color'))
        .fontFamily(PlayerConstants.FONT_FAMILY_BLACK)
        .margin({ top: $r('app.float.music_text_margin_top') })
        .width(StyleConstants.FULL_PERCENT)
        .fontWeight(FontWeight.Regular)
    }
    .margin({ top: $r('app.float.music_info_margin_top') })
  }
}