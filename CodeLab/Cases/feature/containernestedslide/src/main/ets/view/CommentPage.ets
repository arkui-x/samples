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

import { NewsCommentData, NewsCommentModel } from '../model/NewsCommentModel';
import { CommonConstants } from '../common/CommonConstants';
import { promptAction } from '@kit.ArkUI';

const FONT_WEIGHT_FIVE_HUNDRED = 500; // 字体粗细
const FONT_WEIGHT_FOUR_HUNDRED = 400; // 字体粗细

@Component
export struct CommentPage {
  // 评论
  @State commonData: NewsCommentModel = new NewsCommentModel("", "", "", "", "", "", new Date(), new NewsCommentData());
  // 评论中的文字
  @Link replyId: string;
  // 回复人昵称
  @Link replyUser: string;
  // 当前用户
  @State curUser: string = "";
  // 评论输入弹窗
  dialogController: CustomDialogController | null = null;
  // 记录评论的时间状态，true表示新评论的时间需要显示“刚刚”，false为默认时间。
  @Link commentState: boolean;

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.container_nested_only_show_for_ux')
    })
  }

  build() {
    Column() {
      Row() {
        Image(this.commonData.url) // 评论的头像
          .objectFit(ImageFit.Contain)
          .width($r('app.integer.container_nested_url_width_height'))
          .height($r('app.integer.container_nested_url_width_height'))
          .borderRadius(30)
          .margin({ top:10,left:15 })
        Column({ space: 6 }) {
          Text() {
            Span(this.commonData.user) // 评论的昵称
              .fontSize($r('app.integer.container_nested_font_size'))
              .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
              .fontColor($r('app.color.container_nested_color_blank'))

            Span((new Date().getTime() - this.commonData.commentTime.getTime()) / 1000 <= 5 ? $r('app.string.container_nested_time_place2') : $r('app.string.container_nested_time_place'))
              .fontSize($r('app.integer.container_nested_font_size'))
              .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
              .opacity(0.5)
              .fontColor($r('app.color.container_nested_color_blank'))
          }
          .width("80%")

          Text(this.commonData.text) // 评论的文字
            .fontSize($r('app.integer.container_nested_font_size'))
            .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
            .opacity(0.8)
            .fontColor($r('app.color.container_nested_color_blank'))
            .lineHeight(20)
            .width("80%")
          Row() {
            Text($r('app.string.container_nested_reply'))
              .fontSize($r('app.integer.container_nested_font_size'))
              .fontColor($r('app.color.container_nested_note_color'))
              .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
              .backgroundColor("#dbdbdb")
              .borderRadius(5)
              .opacity(0.8)
              .padding({
                left: 3,
                right: 3,
                top: 2,
                bottom: 2
              })
              .onClick(() => {
                if (this.dialogController !== null) {
                  // 子评论的父id作为回复id
                  this.replyId = this.commonData.id;
                  // 子评论的父昵称作为回复昵称
                  this.replyUser = this.commonData.user;
                  // 打开评论输入弹窗
                  this.dialogController.open();
                }
              })
            Blank()
            Image($r("app.media.news_follow"))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Fill)
              .onClick(()=>{
                this.showToast();
              })

            Image($r("app.media.news_HeartBreak"))
              .width(20)
              .height(20)
              .objectFit(ImageFit.Fill)
              .margin({left:20})
              .onClick(()=>{
                this.showToast();
              })
          }
          .width("85%")
        }
        .padding({
          left: $r('app.integer.container_nested_column_padding_left'),
          top: $r('app.integer.container_nested_column_padding_top')
        })
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Top)
      .width("100%")

      Column() {
        // TODO：性能知识点：使用LazyForEach加载评论列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
        LazyForEach(this.commonData.replyList, (reply: NewsCommentModel) => {
          Row() {
            Image(reply.url)
              .objectFit(ImageFit.Contain)
              .width($r('app.integer.container_nested_img_width_height'))
              .height($r('app.integer.container_nested_img_width_height'))
            Column({ space: CommonConstants.SPACE_6 }) {
              Row() {
                Text(reply.user)
                  .fontSize($r('app.integer.container_nested_font_size'))
                  .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
                  .fontColor($r('app.color.container_nested_color_blank'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width("30%")
                Image($r("app.media.news_right"))
                  .objectFit(ImageFit.Contain)
                  .width($r('app.integer.container_nested_font_size'))
                  .height($r('app.integer.container_nested_font_size'))
                Text(reply.replyUser)
                  .fontSize($r('app.integer.container_nested_font_size'))
                  .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
                  .fontColor($r('app.color.container_nested_color_blank'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width("30%")
              }

              Text(reply.text)
                .fontSize($r('app.integer.container_nested_font_size'))
                .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
                .opacity(0.8)
                .lineHeight($r("app.integer.container_nested_text_line_height"))
                .width("85%")
                .fontColor($r('app.color.container_nested_color_blank'))
              Row() {
                Text($r('app.string.container_nested_time_place1'))
                  .fontSize($r('app.integer.container_nested_font_size'))
                  .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
                  .opacity(0.5)
                  .fontColor($r('app.color.container_nested_color_blank'))
                Text($r('app.string.container_nested_reply'))
                  .fontSize($r('app.integer.container_nested_font_size'))
                  .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
                  .fontColor($r('app.color.container_nested_note_color'))
                  .opacity(0.8)
                  .margin({ left: $r('app.integer.container_nested_reply_margin_left') })
                  .onClick(() => {
                    if (this.dialogController !== null) {
                      // 子评论的父id作为回复id
                      this.replyId = this.commonData.id;
                      // 子评论的昵称作为回复昵称
                      this.replyUser = reply.user;
                      // 打开评论输入弹窗
                      this.dialogController.open();
                    }
                  })
              }
              .width("60%")
            }
            .padding({
              left: $r('app.integer.container_nested_column_padding_left')
            })
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Top)
          .width("100%")
          .margin({
            bottom: $r('app.integer.container_nested_row_margin_bottom'),
            top: $r('app.integer.container_nested_row_margin_top')
          })
        }, (item: NewsCommentModel) => item.id.toString())
      }
      .margin({
        left: $r('app.integer.container_nested_root_column_margin_left'),
        top: $r('app.integer.container_nested_root_column_margin_top')
      })
    }
    .width("100%")
  }
}