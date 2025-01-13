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

import { display } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { common } from '@kit.AbilityKit';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { BreakpointConstants, StyleConstants } from '@ohos/constantsCommon';
import { ColorConversion, Logger, PlatformInfo, PlatformTypeEnum, SongItem } from '@ohos/mediaCommon';
import { LyricsComponent } from './LyricsComponent';
import { MusicInfoComponent } from './MusicInfoComponent';
import { ControlAreaComponent } from './ControlAreaComponent';
import { TopAreaComponent } from './TopAreaComponent';
import { PlayerConstants } from '../constants/PlayerConstants';
import { ContentConstants } from '../constants/ContentConstants';

@Preview
@Component
export struct MusicControlComponent {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageProp('selectIndex') @Watch('getImageColor') selectIndex: number = 0;
  @StorageLink('imageColor') imageColor: string = 'rgba(0, 0, 2, 1.00)';
  @StorageLink('topArea') topArea: number = 0;
  @StorageLink('bottomArea') bottomArea: number = 0;
  @State imageLabel: PixelMap | Resource = this.songList[this.selectIndex].label;
  @State isShowControl: boolean = true;
  @State isShowControlLg: boolean = false;
  @State isTablet: boolean = true;
  @State isTabletFalse: boolean = false;
  @StorageLink('pageShowTime') pageShowTime: number = 0;
  @State intervalID: number = 0;
  @Link isShowPlay: boolean;
  @StorageLink('isFoldFull') isFoldFull: boolean = false;
  private context: common.UIAbilityContext | undefined = AppStorage.get('context');
  private callback: Callback<display.FoldDisplayMode> = (data: display.FoldDisplayMode) => {
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        if (data === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
          this.isFoldFull = true;
        } else {
          this.isFoldFull = false;
        }
      }
    }
  };

  aboutToAppear(): void {
    this.getImageColor();
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
      try {
        if (canIUse('SystemCapability.Window.SessionManager')) {
          let mode = display.getFoldDisplayMode();
          if (mode === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
            this.isFoldFull = true;
          }
          display.on('foldDisplayModeChange', this.callback);
        }
      } catch (exception) {
        Logger.error('Failed to register callback. Code: ' + JSON.stringify(exception));
      }
    }
  }

  aboutToDisappear(): void {
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
      if (canIUse('SystemCapability.Window.SessionManager')) {
        display.off('foldDisplayModeChange', this.callback);
      }
    }
  }

  build() {
    Stack() {
      Image(this.imageLabel)
        .size({ width: StyleConstants.FULL_PERCENT, height: StyleConstants.FULL_PERCENT })
        .objectFit(ImageFit.Cover)
        .opacity(0.5)

      Row() {
        if (this.isFoldFull) {
          Column() {
            TopAreaComponent({ isShowPlay: this.isShowPlay })
              .margin({
                bottom: $r('app.float.music_info_margin_top'),
                left: $r('app.float.top_margin_left')
              })
            GridRow({
              columns: { md: BreakpointConstants.COLUMN_MD },
              gutter: BreakpointConstants.GUTTER_MUSIC_X
            }) {
              GridCol({
                span: { md: BreakpointConstants.SPAN_SM }
              }) {
                MusicInfoComponent()
              }
              .margin({
                left: $r('app.float.margin_small'),
                right: $r('app.float.margin_small')
              })

              GridCol({
                span: { md: BreakpointConstants.SPAN_SM }
              }) {
                LyricsComponent({ isShowControl: this.isShowControlLg, isTablet: this.isTabletFalse })
              }
              .padding({
                left: $r('app.float.twenty_four')
              })
            }
            .layoutWeight(1)
            .margin({
              bottom: $r('app.float.fold_margin_bottom')
            })
          }
          .layoutWeight(1)
          .padding({
            left: $r('app.float.common_padding'),
            right: $r('app.float.common_padding')
          })
        } else if (this.currentBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
          Column() {
            TopAreaComponent({ isShowPlay: this.isShowPlay })
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })
            GridRow({
              columns: { md: BreakpointConstants.COLUMN_MD, lg: BreakpointConstants.COLUMN_LG },
              gutter: BreakpointConstants.GUTTER_MUSIC_X
            }) {
              GridCol({
                span: { md: BreakpointConstants.SPAN_SM, lg: BreakpointConstants.SPAN_SM },
                offset: { lg: BreakpointConstants.OFFSET_MD }
              }) {
                Scroll() {
                  Column() {
                    Image(this.songList[this.selectIndex].label)
                      .width(StyleConstants.FULL_PERCENT)
                      .aspectRatio(ContentConstants.ASPECT_RATIO_ALBUM_COVER)
                      .borderRadius($r('app.float.cover_radius'))
                      .margin({ bottom: '5vp' })
                    ControlAreaComponent()
                  }
                  .justifyContent(FlexAlign.SpaceBetween)
                  .margin({
                    bottom: $r('app.float.common_margin')
                  })
                }.scrollBar(BarState.Off)
              }

              GridCol({
                span: { md: BreakpointConstants.SPAN_SM, lg: BreakpointConstants.SPAN_MD },
                offset: { lg: BreakpointConstants.OFFSET_MD }
              }) {
                LyricsComponent({ isShowControl: this.isShowControlLg, isTablet: this.isTablet })
              }
            }
            .layoutWeight(1)
            .padding({
              left: $r('app.float.common_padding'),
              right: $r('app.float.common_padding'),
              top: $r('app.float.lg_music_top'),
              bottom: $r('app.float.lg_music_margin_bottom')
            })
          }
        } else {
          Column() {
            TopAreaComponent({ isShowPlay: this.isShowPlay })
              .width(StyleConstants.FULL_PERCENT)
              .padding({
                left: $r('app.float.common_padding'),
                right: $r('app.float.common_padding')
              })

            Swiper() {
              MusicInfoComponent()
                .margin({
                  top: $r('app.float.music_component_top'),
                  bottom: $r('app.float.music_component_bottom')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
              LyricsComponent({ isShowControl: this.isShowControl, isTablet: this.isTabletFalse })
                .margin({
                  top: $r('app.float.margin_lyric')
                })
                .padding({
                  left: $r('app.float.common_padding'),
                  right: $r('app.float.common_padding')
                })
            }
            .height(StyleConstants.FULL_PERCENT)
            .indicator(
              new DotIndicator()
                .top($r('app.float.options_padding'))
                .selectedColor($r('app.color.select_swiper'))
                .color($r('app.color.slider_track'))
            )
            .clip(false)
            .loop(false)
            .onChange((index: number) => {
              if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
                if (index === 1) {
                  this.isShowControl = true;
                  this.intervalID = setInterval(() => {
                    this.pageShowTime += 1;
                    if (this.pageShowTime > 5) {
                      this.isShowControl = false;
                      clearInterval(this.intervalID);
                    }
                  }, 1000);
                } else {
                  this.pageShowTime = 0;
                  clearInterval(this.intervalID);
                }
              }
            })
          }
          .width(StyleConstants.FULL_PERCENT)
        }
      }
      .padding({
        bottom: this.bottomArea,
        top: this.topArea
      })
    }
    .height(StyleConstants.FULL_PERCENT)
    .width(StyleConstants.FULL_PERCENT)
    .backgroundColor(this.imageColor)
  }

  /**
   * Get largest proportion color of an image.
   */
  getImageColor() {
    if (!this.context) {
      return;
    }
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
      this.context.resourceManager.getMediaContent(this.songList[this.selectIndex].label)
        .then((value: Uint8Array) => {
          let buffer = value.buffer as ArrayBuffer;
          image.createImageSource(buffer).createPixelMap().then((pixelMap) => {
            effectKit.createColorPicker(pixelMap, (error, colorPicker) => {
              if (error) {
                Logger.error('Failed to create color picker.');
              } else {
                let color = colorPicker.getLargestProportionColor();
                let colorArr = ColorConversion.dealColor(color.red, color.green, color.blue);
                this.imageColor = `rgba(${colorArr[0]}, ${colorArr[1]}, ${colorArr[2]}, 1)`;
              }
            })
            let headFilter = effectKit.createEffect(pixelMap);
            if (headFilter !== null) {
              headFilter.blur(PlayerConstants.IMAGE_BLUR);
              headFilter.getEffectPixelMap().then((value) => {
                this.imageLabel = value;
              })
            }
          })
            .catch((error: BusinessError) => {
              Logger.error(`${error.code} + ${error.message}`)
            })
        })
        .catch((error: BusinessError) => {
          Logger.error(`${error.code} + ${error.message}`)
        })
    } else if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID ||
      PlatformInfo.getPlatform() == PlatformTypeEnum.IOS) {
      this.imageLabel = this.songList[this.selectIndex].label;
    }
  }
}