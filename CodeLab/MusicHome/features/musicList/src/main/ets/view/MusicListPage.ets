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

import { BreakpointSystem, MediaService, PlatformInfo, PlatformTypeEnum } from '@ohos/mediaCommon';
import { BreakpointConstants, SongConstants, StyleConstants } from '@ohos/constantsCommon';
import { Header } from '../components/Header';
import { Player } from '../components/Player';
import { Content } from '../components/ListContent';
import { songList } from '../viewmodel/SongListData';

@Entry({ routeName: 'MusicListPage' })
@Component
export struct MusicListPage {
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @StorageLink('deviceHeight') deviceHeight: number = 0;

  aboutToAppear() {
    AppStorage.setOrCreate('songList', songList);
    MediaService.getInstance();
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Header()
      Content()
      Player()
    }
    .width(StyleConstants.FULL_PERCENT)
    .backgroundColor(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ?
    $r('app.color.page_background_sm') : $r('app.color.page_background_other'))
    .onAreaChange((oldArea: Area, newArea: Area) => {
      if (typeof newArea.height === 'number') {
        this.deviceHeight = newArea.height;
      }
    })
    .padding({
      top: PlatformInfo.getPlatform() == PlatformTypeEnum.IOS ? AppStorage.get<number>('statusBarHeight') : 0
    })
  }

  pageTransition() {
    PageTransitionEnter({ duration: SongConstants.TRANSITION_DURATION, curve: Curve.Smooth, type: RouteType.Pop })
    PageTransitionExit({ duration: SongConstants.TRANSITION_DURATION, curve: Curve.Smooth, type: RouteType.Push })
  }
}