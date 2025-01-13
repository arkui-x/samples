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

import { BreakpointConstants, GridConstants, StyleConstants } from '@ohos/constantsCommon';
import { AlbumCover } from './AlbumCover';
import { PlayList } from './PlayList';

@Component
export struct Content {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  build() {
    GridRow() {
      GridCol({ span: { sm: GridConstants.SPAN_TWELVE, md: GridConstants.SPAN_SIX, lg: GridConstants.SPAN_FOUR } }) {
        AlbumCover({ currentBreakpoint: this.currentBreakpoint })
      }
      .backgroundColor($r('app.color.album_background'))

      GridCol({ span: { sm: GridConstants.SPAN_TWELVE, md: GridConstants.SPAN_SIX, lg: GridConstants.SPAN_EIGHT } }) {
        PlayList({ currentBreakpoint: this.currentBreakpoint })
      }
      .borderRadius($r('app.float.playlist_border_radius'))
    }
    .height(StyleConstants.FULL_PERCENT)
  }
}