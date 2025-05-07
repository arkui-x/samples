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

import { FooterView } from './FooterView'

@Component
export struct UserNoticeView {
  currentIndex: number = 0;
  lastIndex: number | undefined = undefined;
  controller: SwiperController | undefined = undefined;
  readonly ITEM_COUNT: number = 20;
  readonly ITEM_SPACE: number = 5;

  build() {
    Column() {
      // TODO 知识点：页面主体内容由Scroll承载，确保页面内容较多时能够滑动展示（也可根据实际情况使用其他方案）
      Scroll() {
        Text($r("app.string.stepper_usernotice"))
          .lineHeight(40)
          .fontSize($r("app.integer.stepper_usernotice_font_size"))
          .textAlign(TextAlign.Start)
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .width('100%')
      .align(Alignment.Top)

      FooterView({
        currentIndex: this.currentIndex,
        lastIndex: this.lastIndex,
        controller: this.controller,
      })
    }
    .height('100%')
    .width('100%')
    .margin({ top: $r("sys.float.ohos_id_card_margin_start") })
  }
}