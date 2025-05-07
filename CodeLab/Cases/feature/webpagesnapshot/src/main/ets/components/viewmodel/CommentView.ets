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

import Constant from '../../common/Constants';
import { Comment } from '../model/DataModel';

/**
 * 单条评论布局
 */
@Component
export struct CommentView {
  // 评论
  @ObjectLink comment: Comment;

  build() {
    Row() {
      Column(){
        Image(this.comment.avatar)
          .width($r('app.string.web_page_snap_shot_comment_image_width'))
          .height($r('app.string.web_page_snap_shot_comment_image_width'))
          .borderRadius($r('app.string.web_page_snap_shot_comment_image_border_radius'))
          .margin({ left:$r('app.string.web_page_snap_shot_comment_image_left_margin') , right:$r('app.string.web_page_snap_shot_comment_image_right_margin') })
      }.alignItems(HorizontalAlign.Start)

      Column({ space: Constant.LIST_COMMENT_SPACE }) {
        Text(this.comment.name)
          .fontSize($r('app.string.web_page_snap_shot_comment_text_name_fontsize'))
          .padding({ top: 3 })
          .fontColor(Color.Gray)
        Text(this.comment.commentContent)
          .fontSize($r('app.string.web_page_snap_shot_comment_text_content_fontsize'))
          .maxLines(Constant.LIST_COMMENT_LINE)
          .wordBreak(WordBreak.NORMAL)
          .width($r('app.string.web_page_snap_shot_comment_text_content_width'))
        Text() {
          Span(this.comment.timeAgo)
          Span($r('app.string.web_page_snap_shot_comment_text_time_address_span'))
          Span(this.comment.address)
        }
        .fontSize($r('app.string.web_page_snap_shot_comment_text_name_fontsize'))
        .fontColor(Color.Gray)
      }.alignItems(HorizontalAlign.Start)
    }
    .width($r('app.string.web_page_snap_shot_web_snap_full_size'))
    .height($r('app.string.web_page_snap_shot_list_element_text_height'))
    .borderRadius($r('app.string.web_page_snap_shot_list_element_text_border_radius'))
    .backgroundColor($r('app.string.web_page_snap_shot_list_background_color'))
  }
}