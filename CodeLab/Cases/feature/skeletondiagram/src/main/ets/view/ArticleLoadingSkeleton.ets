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

import { CommonConstants } from '../common/CommonConstants';

@Component
export struct ArticleLoadingSkeleton {
  @Prop isMine?: boolean

  build() {
    Row() {
      Column() {
        Column({ space: CommonConstants.SPACE_4 }) {
          // 标题
          textArea($r("app.float.ske_card_title_height"))
          // 内容
          textArea($r("app.float.ske_card_text_height"))
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(CommonConstants.LAYOUT_WEIGHT)

        // 判断是否自己作品来适配不同骨架布局
        if (!this.isMine) {
          Row() {
            // 浏览量
            actionArea()
            // 点赞数
            actionArea()
            // 收藏量
            actionArea()
          }
          .padding({ top: $r("app.float.ske_md_padding_margin") })
          .height($r("app.float.ske_row_height"))
          .width(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.SpaceBetween)
        } else {
          Row({ space: CommonConstants.SPACE_12 }) {
            // 摄影作品标签
            Row()
              .width($r("app.float.ske_lg_topic_width"))
              .topicStyle()
            // 自然风光标签
            Row()
              .width($r("app.float.ske_lg_topic_width"))
              .topicStyle()
          }
          .padding({ top: $r("app.float.ske_md_padding_margin") })
          .height($r("app.float.ske_row_height"))
          .width(CommonConstants.FULL_PERCENT)
          .justifyContent(FlexAlign.Start)
        }
      }
      .layoutWeight(CommonConstants.LAYOUT_WEIGHT)
      .height(CommonConstants.FULL_PERCENT)

      Row()
        .backgroundColor($r('app.color.skeleton_color_light'))
        .borderRadius($r("app.float.ske_small_border_radius"))
        .width($r('app.float.ske_image_width'))
        .height($r('app.float.ske_image_height'))
        .margin({ left: $r("app.float.ske_md_padding_margin") })
    }
    .padding($r("app.float.ske_md_padding_margin"))
    .borderRadius($r("app.float.ske_large_border_radius"))
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceAround)
    .width(CommonConstants.FULL_PERCENT)
    .height($r("app.float.ske_card_height"))
  }
}

@Builder
function actionArea() {
  Row()
    .width($r("app.float.ske_action_area_width"))
    .height($r("app.float.ske_action_area_height"))
    .backgroundColor($r('app.color.skeleton_color_medium'))
}

@Styles
function topicStyle() {
  .height($r("app.float.ske_topic_height"))
  .backgroundColor($r('app.color.skeleton_color_medium'))
  .borderRadius($r("app.float.ske_xs_border_radius"))
}

@Builder
function textArea(height: Length) {
  Row()
    .width(CommonConstants.FULL_PERCENT)
    .height(height)
    .backgroundColor($r('app.color.skeleton_color_medium'))
}