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

import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';
import { BreakpointType, PlatformInfo, PlatformTypeEnum, SongItem } from '@ohos/mediaCommon';
import { BreakpointConstants, StyleConstants } from '@ohos/constantsCommon';
import { LrcEntry } from '../lyric/LrcEntry';
import { parseKrcLyric, parseLrcLyric } from '../lyric/LrcUtils';
import LrcView from '../lyric/LrcView';
import { LyricFile, LyricScrollEffect, LyricTopPosition } from '../lyric/LyricConst';
import { ControlAreaComponent } from './ControlAreaComponent';
import { PlayerConstants } from '../constants/PlayerConstants';

@Component
export struct LyricsComponent {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @StorageLink('progress') time: number = 0;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  @State progress: number = 0.01;
  @State progressText: string = '';
  @State lyricScrollEffect: LyricScrollEffect = LyricScrollEffect.Line;
  @State mLrcEntryList: Array<LrcEntry> = [];
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') @Watch('getLrcEntryList') selectIndex: number = 0;
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  @StorageLink('isPlay') isPlay: boolean = false;
  @Link isShowControl: boolean;
  @Link isTablet: boolean;
  @State intervalID: number = 0;
  @State pageShowTime: number = 0;

  aboutToAppear() {
    this.getLrcEntryList();
  }

  getLrcEntryList() {
    this.mLrcEntryList = [];
    if (!this.context) {
      return;
    }
    this.context.resourceManager.getRawFileContent(this.songList[this.selectIndex].lyric)
      .then((value: Uint8Array) => {
        let textDecoder = util.TextDecoder.create(PlayerConstants.ENCODING, { ignoreBOM: true });
        let stringData = textDecoder.decodeWithStream(value, { stream: false });
        if (this.songList[this.selectIndex].lyric.endsWith(LyricFile.KRC)) {
          this.mLrcEntryList = parseKrcLyric(stringData);
        } else if (this.songList[this.selectIndex].lyric.endsWith(LyricFile.LRC)) {
          this.mLrcEntryList = parseLrcLyric(stringData);
        }
      })
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
            Row() {
              GridRow({
                columns: { lg: BreakpointConstants.COLUMN_LYRIC_LG }
              }) {
                GridCol({
                  span: { lg: BreakpointConstants.SPAN_LYRIC_LG },
                  offset: BreakpointConstants.OFFSET_MD
                }) {
                  Column() {
                    Row() {
                      Column() {
                        Text(this.songList[this.selectIndex].title)
                          .fontSize(new BreakpointType({
                            sm: $r('app.float.title_font_sm'),
                            md: $r('app.float.title_font_md'),
                            lg: $r('app.float.title_font_lg')
                          }).getValue(this.currentBreakpoint))
                          .fontColor(Color.White)
                          .fontWeight(PlayerConstants.FONT_WEIGHT_700)
                          .fontFamily(PlayerConstants.FONT_FAMILY_BOLD)
                        Text(this.songList[this.selectIndex].singer)
                          .fontSize(new BreakpointType({
                            sm: $r('app.float.singer_font_sm'),
                            md: $r('app.float.singer_font_md'),
                            lg: $r('app.float.singer_font_lg')
                          }).getValue(this.currentBreakpoint))
                          .fontColor($r('sys.color.ohos_id_color_text_hint_contrary'))
                          .fontFamily(PlayerConstants.FONT_FAMILY_MEDIUM)
                          .margin({
                            top: $r('app.float.singer_margin_top')
                          })
                      }
                      .alignItems(HorizontalAlign.Start)
                    }
                    .width(StyleConstants.FULL_PERCENT)
                    .justifyContent(FlexAlign.Start)
                    .margin({
                      top: new BreakpointType({
                        sm: $r('app.float.info_margin_top_sm'),
                        md: $r('app.float.zero_margin'),
                        lg: $r('app.float.zero_margin')
                      }).getValue(this.currentBreakpoint),
                      bottom: $r('app.float.info_margin_bottom')
                    })

                    LrcView({
                      lyricMilliSecondsTime: this.time,
                      mLrcEntryList: this.mLrcEntryList,
                      lyricScrollEffect: this.lyricScrollEffect,
                      lyricTopPosition: LyricTopPosition.Middle
                    })
                      .layoutWeight(1)
                  }
                }
              }
            }
            .layoutWeight(1)
          } else {
            Row() {
              if (!this.isTablet) {
                Image(this.songList[this.selectIndex].label)
                  .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
                  $r('app.float.label_width_sm') : $r('app.float.label_width'))
                  .borderRadius($r('app.float.label_border'))
                  .margin({
                    right: $r('app.float.label_margin_right')
                  })
              }
              Column() {
                Text(this.songList[this.selectIndex].title)
                  .fontSize(new BreakpointType({
                    sm: $r('app.float.title_font_sm'),
                    md: $r('app.float.title_font_md'),
                    lg: $r('app.float.title_font_lg')
                  }).getValue(this.currentBreakpoint))
                  .fontColor(Color.White)
                  .fontWeight(PlayerConstants.FONT_WEIGHT_700)
                  .fontFamily(PlayerConstants.FONT_FAMILY_BOLD)
                Text(this.songList[this.selectIndex].singer)
                  .fontSize(new BreakpointType({
                    sm: $r('app.float.singer_font_sm'),
                    md: $r('app.float.singer_font_md'),
                    lg: $r('app.float.singer_font_lg')
                  }).getValue(this.currentBreakpoint))
                  .fontColor(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
                  $r('app.color.singer_text') : $r('sys.color.ohos_id_color_text_hint_contrary'))
                  .fontWeight(PlayerConstants.FONT_WEIGHT_500)
                  .fontFamily(PlayerConstants.FONT_FAMILY_MEDIUM)
                  .margin({
                    top: $r('app.float.singer_margin_top')
                  })
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width(StyleConstants.FULL_PERCENT)
            .justifyContent(FlexAlign.Start)
            .margin({
              top: new BreakpointType({
                sm: $r('app.float.info_margin_top_sm'),
                md: $r('app.float.zero_margin'),
                lg: $r('app.float.zero_margin')
              }).getValue(this.currentBreakpoint),
              bottom: $r('app.float.info_margin_bottom')
            })

            LrcView({
              lyricMilliSecondsTime: this.time,
              mLrcEntryList: this.mLrcEntryList,
              lyricScrollEffect: this.lyricScrollEffect,
              lyricTopPosition: LyricTopPosition.Middle
            })
              .height(PlayerConstants.LRCVIEW_HEIGHT)
          }

          Row() {
            if (this.isTablet) {
              Image($r('app.media.ic_public_likes'))
                .width($r('app.float.likes_image_lg'))
                .height($r('app.float.likes_image_lg'))
                .objectFit(ImageFit.Contain)
                .margin({
                  right: $r('app.float.likes_margin')
                })
            }
            if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
              Image(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
              $r('app.media.ic_lyrics_button_lg') : $r('app.media.ic_lyrics_button'))
                .width(new BreakpointType({
                  sm: $r('app.float.lyrics_width_sm'),
                  md: $r('app.float.lyrics_width_md'),
                  lg: $r('app.float.lyrics_width_lg')
                }).getValue(this.currentBreakpoint))
                .aspectRatio(1)
                .opacity(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? 1 : 0.86)
            } else if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID ||
              PlatformInfo.getPlatform() == PlatformTypeEnum.IOS) {
              Image(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ?
              $r('app.media.ic_lyrics_button_lg') : $r('app.media.ic_lyrics_button'))
                .width(new BreakpointType({
                  sm: $r('app.float.lyrics_width_sm'),
                  md: $r('app.float.lyrics_width_md'),
                  lg: $r('app.float.lyrics_width_lg')
                }).getValue(this.currentBreakpoint))
                .aspectRatio(1)
                .opacity(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG ? 1 : 0.86)
                .onClick(() => {
                  if (!this.isTablet) {
                    this.isShowControl = !this.isShowControl;
                  }
                })
            }
          }
          .width(StyleConstants.FULL_PERCENT)
          .height($r('app.float.control_icon_height'))
          .justifyContent(FlexAlign.End)
          .margin({
            top: $r('app.float.lyric_margin_top'),
            bottom: new BreakpointType({
              sm: $r('app.float.lyric_margin_bottom_sm'),
              md: $r('app.float.lyric_margin_bottom_md'),
              lg: $r('app.float.lyric_margin_bottom_lg')
            }).getValue(this.currentBreakpoint),
            right: new BreakpointType({
              sm: $r('app.float.lyric_margin_right_sm'),
              md: $r('app.float.lyric_margin_right_md'),
              lg: $r('app.float.lyric_margin_right_lg')
            }).getValue(this.currentBreakpoint)
          })

          if (this.isShowControl) {
            ControlAreaComponent()
              .margin({
                top: $r('app.float.control_lyric_margin'),
                bottom: $r('app.float.music_component_bottom')
              })
          }
          if (!this.isTablet) {
            Row().size({ width: StyleConstants.FULL_PERCENT, height: 50 })
          }
        }
        .width(StyleConstants.FULL_PERCENT)
        .onClick(() => {
          this.pageShowTime = 0;
        })
      }.scrollBar(BarState.Off)
    }.height(StyleConstants.FULL_PERCENT)
  }
}