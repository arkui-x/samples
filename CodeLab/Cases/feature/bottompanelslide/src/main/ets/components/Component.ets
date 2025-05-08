/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { Constants } from '../Constants/Constant'

// 视频list布局样式
@Component
export struct ListItemView {
  private videoName: ResourceStr = '';
  private authorName: ResourceStr = '';

  build() {
    RelativeContainer() {
      Image($r("app.media.bottompanelslide_strawberry"))
        .objectFit(ImageFit.Contain)
        .width(Constants.FORTY_PERCENT_SIZE)
        .height($r("app.integer.bottompanelslide_number_90"))
        .backgroundColor($r('app.color.ohos_id_color_sub_background'))
        .borderRadius($r("app.integer.bottompanelslide_number_10"))
        .id('bottompanelslide_image')
        .alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
          'left': { 'anchor': '__container__', 'align': HorizontalAlign.Start }
        })

      Text(this.videoName)
        .fontSize($r("app.integer.bottompanelslide_number_15"))
        .fontColor(Color.Black)
        .id('videoName')
        .margin({ left: $r("app.integer.bottompanelslide_number_10") })
        .alignRules({
          'top': { 'anchor': '__container__', 'align': VerticalAlign.Top },
          'left': { 'anchor': 'bottompanelslide_image', 'align': HorizontalAlign.End }
        })

      Text(this.authorName)
        .fontSize($r("app.integer.bottompanelslide_number_10"))
        .fontColor(Color.Gray)
        .id('authorName')
        .margin({ left: $r("app.integer.bottompanelslide_number_10"), top: $r("app.integer.bottompanelslide_number_25") })
        .alignRules({
          'top': { 'anchor': 'videoName', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': 'bottompanelslide_image', 'align': HorizontalAlign.End }
        })

      Column()
        .width($r("app.integer.bottompanelslide_number_20"))
        .height($r("app.integer.bottompanelslide_number_20"))
        .backgroundColor($r('app.color.ohos_id_color_sub_background'))
        .borderRadius($r("app.integer.bottompanelslide_number_5"))
        .margin({ top: $r("app.integer.bottompanelslide_number_5"), left: $r("app.integer.bottompanelslide_number_10") })
        .id('bottompanelslide_column1')
        .alignRules({
          'top': { 'anchor': 'authorName', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': 'bottompanelslide_image', 'align': HorizontalAlign.End }
        })

      Column()
        .width($r("app.integer.bottompanelslide_number_20"))
        .height($r("app.integer.bottompanelslide_number_20"))
        .backgroundColor($r('app.color.ohos_id_color_sub_background'))
        .borderRadius($r("app.integer.bottompanelslide_number_5"))
        .margin({ top: $r("app.integer.bottompanelslide_number_5"), left: $r("app.integer.bottompanelslide_number_10") })
        .id('bottompanelslide_column2')
        .alignRules({
          'top': { 'anchor': 'authorName', 'align': VerticalAlign.Bottom },
          'left': { 'anchor': 'bottompanelslide_column1', 'align': HorizontalAlign.End }
        })
    }
    .padding({
      left: $r("app.integer.bottompanelslide_number_15"),
      top: $r("app.integer.bottompanelslide_number_10"),
      bottom: $r("app.integer.bottompanelslide_number_10")
    })
    .width(Constants.FULL_SIZE)
    .height($r("app.integer.bottompanelslide_number_100"))
  }
}

// panel中list布局样式
@Component
export struct PanelListItem {
  private desc: string = '';
  private including: string = '';

  build() {
    Row() {
      Column() {
        Text(this.desc)
          .fontSize(14)
          .margin({ bottom: $r("app.integer.bottompanelslide_number_10") })
        Text(this.including)
          .fontSize(11)
          .fontColor(Color.Gray)
          .alignSelf(ItemAlign.Start)
      }

      Radio({ value: 'Radio2', group: 'radioGroup' })
        .checked(false)
    }
    .margin({ bottom: $r("app.integer.bottompanelslide_number_10") })
    .height($r("app.integer.bottompanelslide_number_70"))
    .width(Constants.NINETY_PERCENT_SIZE)
    .justifyContent(FlexAlign.SpaceBetween)
  }
}