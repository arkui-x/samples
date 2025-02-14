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

import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { BreakpointConstants, StyleConstants } from '@ohos/constantsCommon';
import {
  BreakpointType,
  DisplaySync,
  Logger,
  MediaService,
  PlatformInfo,
  PlatformTypeEnum,
  SongItem
} from '@ohos/mediaCommon';
import { PlayerConstants } from '../constants/PlayerConstants';
import { MusicControlComponent } from './MusicControlComponent';

@Preview
@Component
export struct Player {
  @StorageProp('selectIndex') selectIndex: number = 0;
  @StorageLink('isPlay') @Watch('animationFun') isPlay: boolean = false;
  @StorageLink('songList') songList: SongItem[] = [];
  @StorageLink('topArea') topArea: number = 0;
  @StorageLink('bottomArea') bottomArea: number = 0;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @State imageRotate: number = 0;
  @StorageLink('isShowPlay') isShowPlay: boolean = false;
  @State componentHeight: number = 0;
  @StorageLink('deviceHeight') deviceHeight: number = 0;
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Vertical });
  private drawFrame: () => void = () => {
    if (this.imageRotate >= 360) {
      this.imageRotate = 0;
    }
    this.imageRotate += 1;
  };

  animationFun() {
    if (this.isPlay) {
      DisplaySync.getDisplaySync().startAnimate();
    } else {
      DisplaySync.getDisplaySync().stopAnimate();
    }
  }

  aboutToAppear() {
    let range: ExpectedFrameRateRange = {
      expected: 30,
      min: 0,
      max: 30
    };
    DisplaySync.getDisplaySync().createAnimate(range, this.drawFrame);
  }

  aboutToDisappear(): void {
    DisplaySync.getDisplaySync().deleteAnimate(this.drawFrame);
  }

  @Builder
  musicPlayBuilder() {
    Column() {
      Column() {
        MusicControlComponent({ isShowPlay: this.isShowPlay })
      }
      .height((100 - this.componentHeight) + '%')
    }
    .padding({
      top: PlatformInfo.getPlatform() == PlatformTypeEnum.IOS ? AppStorage.get<number>('statusBarHeight') : 0
    })
    .height(StyleConstants.FULL_PERCENT)
    .width(StyleConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.End)
    .onAppear(() => {
      if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
        window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
          let area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
          this.topArea = px2vp(area.topRect.height);
          let bottomArea = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
          this.bottomArea = px2vp(bottomArea.bottomRect.height);
          Logger.info('bottomArea ' + this.bottomArea)
          if (this.topArea > 0) {
            windowStage.setWindowLayoutFullScreen(true);
          }
          let sysBarProps: window.SystemBarProperties = {
            statusBarContentColor: '#FFFFFF'
          };
          windowStage.setWindowSystemBarProperties(sysBarProps);
        }).catch((error: BusinessError) => {
          Logger.error(`${error.code} + ${error.message}`)
        });
      }
    })
    .onDisAppear(() => {
      this.componentHeight = 0;
      this.isShowPlay = false;
      if (PlatformInfo.getPlatform() == PlatformTypeEnum.HARMONYOS) {
        window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
          let area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
          let topHeight = px2vp(area.topRect.height);
          if (topHeight > 0) {
            windowStage.setWindowLayoutFullScreen(false);
          }
          let sysBarProps: window.SystemBarProperties = {
            statusBarContentColor: '#000000'
          };
          windowStage.setWindowSystemBarProperties(sysBarProps);
        }).catch((error: BusinessError) => {
          Logger.error(`${error.code} + ${error.message}`)
        });
      }
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionUpdate((event?: GestureEvent) => {
          if (event) {
            let height = event.offsetY / this.deviceHeight * 100;
            this.componentHeight = height;
            if (this.componentHeight < 0) {
              this.componentHeight = 0;
            }
          }
        })
        .onActionEnd(() => {
          if (this.componentHeight > 40) {
            this.isShowPlay = false;
          } else {
            this.componentHeight = 0;
          }
        })
    )
  }

  build() {
    Row() {
      Row() {
        Image(this.songList[this.selectIndex]?.label)
          .height($r('app.float.cover_height'))
          .width($r('app.float.cover_width'))
          .borderRadius($r('app.float.label_border_radius'))
          .margin({ right: $r('app.float.cover_margin') })
          .rotate({ angle: this.imageRotate })
          .onAppear(() => {
            this.animationFun();
          })
        Column() {
          Text(this.songList[this.selectIndex].title)
            .fontColor($r('app.color.song_name'))
            .fontSize(new BreakpointType({
              sm: $r('app.float.song_title_sm'),
              md: $r('app.float.song_title_md'),
              lg: $r('app.float.song_title_lg')
            }).getValue(this.currentBreakpoint))
          Row() {
            Image($r('app.media.ic_vip'))
              .height($r('app.float.vip_icon_height'))
              .width($r('app.float.vip_icon_width'))
              .margin({ right: $r('app.float.vip_icon_margin') })
            Text(this.songList[this.selectIndex].singer)
              .fontColor($r('app.color.singer'))
              .fontSize(new BreakpointType({
                sm: $r('app.float.singer_title_sm'),
                md: $r('app.float.singer_title_md'),
                lg: $r('app.float.singer_title_lg')
              }).getValue(this.currentBreakpoint))
              .opacity($r('app.float.singer_opacity'))
          }
        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(PlayerConstants.LAYOUT_WEIGHT_PLAYER_CONTROL)
      .onClick(() => {
        this.isShowPlay = true;
      })

      Blank()
        .onClick(() => {
          this.isShowPlay = true;
        })

      Row() {
        Image($r('app.media.ic_previous'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({ right: $r('app.float.control_icon_margin') })
          .displayPriority(PlayerConstants.DISPLAY_PRIORITY_TWO)
          .onClick(() => {
            this.imageRotate = 0;
            MediaService.getInstance().playPrevious();
          })
        Image(this.isPlay ? $r('app.media.ic_play') : $r('app.media.ic_pause'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .displayPriority(PlayerConstants.DISPLAY_PRIORITY_THREE)
          .onClick(() => {
            if (MediaService.getInstance().getFirst()) {
              MediaService.getInstance().loadAssent(0);
            } else {
              this.isPlay ? MediaService.getInstance().pause() : MediaService.getInstance().play();
            }
          })
        Image($r('app.media.ic_next'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .margin({
            right: $r('app.float.control_icon_margin'),
            left: $r('app.float.control_icon_margin')
          })
          .displayPriority(PlayerConstants.DISPLAY_PRIORITY_TWO)
          .onClick(() => {
            this.imageRotate = 0;
            MediaService.getInstance().playNextAuto(true);
          })
        Image($r('app.media.ic_music_list'))
          .height($r('app.float.control_icon_height'))
          .width($r('app.float.control_icon_width'))
          .displayPriority(PlayerConstants.DISPLAY_PRIORITY_ONE)
      }
      .width(new BreakpointType({
        sm: $r('app.float.play_width_sm'),
        md: $r('app.float.play_width_sm'),
        lg: $r('app.float.play_width_lg')
      }).getValue(this.currentBreakpoint))
      .justifyContent(FlexAlign.End)
    }
    .width(StyleConstants.FULL_PERCENT)
    .height($r('app.float.player_area_height'))
    .backgroundColor($r('app.color.player_background'))
    .bindContentCover($$this.isShowPlay, this.musicPlayBuilder(), ModalTransition.DEFAULT)
    .padding({
      left: $r('app.float.player_padding'),
      right: $r('app.float.player_padding')
    })
    .position({
      x: 0,
      y: StyleConstants.FULL_PERCENT
    })
    .translate({
      x: 0,
      y: StyleConstants.TRANSLATE_PLAYER_Y
    })
    .gesture(
      PanGesture(this.panOption)
        .onActionEnd((event?: GestureEvent) => {
          if (event && event.offsetY < -10) {
            this.isShowPlay = true;
          }
        })
    )
  }
}