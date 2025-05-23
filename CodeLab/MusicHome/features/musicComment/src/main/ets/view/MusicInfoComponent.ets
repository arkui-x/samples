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

import { SongItem } from '@ohos/mediaCommon';
import { StyleConstants } from '@ohos/constantsCommon';

@Component
export struct MusicInfoComponent {
  @StorageProp('selectIndex') selectIndex: number = 0;
  @StorageLink('songList') songList: SongItem[] = [];

  build() {
    Row() {
      Image(this.songList[this.selectIndex].label)
        .width($r('app.float.info_image_width'))
        .height($r('app.float.info_image_height'))
        .margin({
          right: $r('app.float.info_image_margin_right')
        })
        .borderRadius($r('app.float.info_image_border'))
      Column() {
        Text(this.songList[this.selectIndex].title)
          .fontSize($r('app.float.info_title_size'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.info_title_color'))
        Text(this.songList[this.selectIndex].singer)
          .fontSize($r('app.float.info_singer_size'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.info_singer_color'))
          .lineHeight($r('app.float.info_singer_line_height'))
      }
      .alignItems(HorizontalAlign.Start)

      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width($r('app.float.arrow_right_width'))
        .height($r('app.float.arrow_right_height'))
    }
    .height($r('app.float.info_height'))
    .width(StyleConstants.FULL_PERCENT)
    .padding({
      top: $r('app.float.info_padding_top'),
      bottom: $r('app.float.info_padding_bottom')
    })
  }
}