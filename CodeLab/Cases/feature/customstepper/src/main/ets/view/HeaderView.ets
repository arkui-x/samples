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

import { notImplementPrompt } from '../common/Utils';


/**
 * 展示页面上方的返回/更多按钮（页面公共部分）及对应页面的Title
 */
@Component
export struct HeaderView {
  titleArray: string[] = []; // 承载每个页面的title，由父组件传值
  @Link currentIndex: number; // 当前页面的索引，由索引及titleArray确定当前页面的Title

  build() {
    Column() {
      Row() {
        Image($r("sys.media.ohos_ic_compnent_titlebar_back"))
          .height($r("app.integer.stepper_header_image_height"))
          .aspectRatio(1)
          .onClick(() => {
            notImplementPrompt();
          })

        Text(this.titleArray[this.currentIndex])
          .fontWeight(FontWeight.Bold)
          .fontSize($r("app.integer.stepper_title_font_size"))
          .textAlign(TextAlign.Center)

        Image($r("sys.media.ohos_ic_public_more"))
          .height($r("app.integer.stepper_header_image_height"))
          .aspectRatio(1)
          .onClick(() => {
            notImplementPrompt();
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .strokeWidth(1)
        .backgroundColor($r("app.color.stepper_divider_color"))
    }
    .width('100%')
    .height($r("app.integer.stepper_header_image_height"))
  }
}