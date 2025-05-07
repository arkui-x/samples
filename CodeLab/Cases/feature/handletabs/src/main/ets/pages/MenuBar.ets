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

import { STYLE_CONFIGURATION } from '../model/constantsData';

@Component
export struct MenuBar {
  private leftIconList: Resource[] = [
    $r('app.media.handle_tabs_ic_public_back'),
    $r('app.media.handle_tabs_ic_public_forward'),
    $r('app.media.handle_tabs_ic_public_refresh'),
    $r('app.media.handle_tabs_ic_public_home'),
  ];
  private rightIconList: Resource[] = [
    $r('app.media.handle_tabs_ic_user_portrait'),
    $r('app.media.handle_tabs_ic_quick_reply'),
    $r('app.media.handle_tabs_ic_screenshot_arbitrarygraphics'),
    $r('app.media.handle_tabs_ic_public_drawer'),
  ];

  @Builder
  IconList(srcArray: Resource[]) {
    Row({ space: STYLE_CONFIGURATION.CONTENT_GUTTER_S }) {
      // 性能知识点：此处为横向列表，列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
      ForEach(srcArray, (item: Resource) => {
        Image(item)
          .width(STYLE_CONFIGURATION.ICON_SIZE)
          .aspectRatio(1)
      })
    }
  }

  build() {
    Row({ space: STYLE_CONFIGURATION.CONTENT_GUTTER_M }) {
      this.IconList(this.leftIconList)
      Search()
        .flexShrink(1)
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
        .height(STYLE_CONFIGURATION.SEARCH_HEIGHT)
      this.IconList(this.rightIconList)
    }
    .width('100%')
    .padding({
      left: $r('sys.float.ohos_id_default_padding_start'),
      right: $r('sys.float.ohos_id_default_padding_end')
    })
  }
}