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

import { CommentData, CommentModel } from '../model/TextFlowMode';

const FONT_WEIGHT_FIVE_HUNDRED = 500; // 字体粗细
const FONT_WEIGHT_FOUR_HUNDRED = 400; // 字体粗细

@Component
export struct CommentPage {
  // 评论
  @State commonData: CommentModel = new CommentModel("", "", "", "", "", "", new Date(), new CommentData());
  // 评论中的文字
  @Link replyId: string;
  // 回复人昵称
  @Link replyUser: string;
  // 当前用户
  @State curUser: string = "";
  // 评论输入弹窗
  dialogController: CustomDialogController | null = null;

  build() {
    Column() {
      Row() {
        Image(this.commonData.url) // 评论的头像
          .objectFit(ImageFit.Contain)
          .width($r('app.integer.text_flow_url_width_height'))
          .height($r('app.integer.text_flow_url_width_height'))
          .borderRadius(30)
          .margin({
            top: $r('app.integer.text_flow_url_margin_top'),
            left: $r('app.integer.text_flow_url_margin_left')
          })
        Column({ space: 6 }) {
          Text(this.commonData.user) // 评论的昵称
            .fontSize($r('app.integer.text_flow_font_size'))
            .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
            .fontColor($r('app.color.text_flow_color_blank'))
          Text(this.commonData.text) // 评论的文字
            .fontSize($r('app.integer.text_flow_font_size'))
            .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
            .opacity(0.8)
            .fontColor($r('app.color.text_flow_color_blank'))
            .lineHeight(20)
            .width("87%")
          Row() {
            Text((new Date().getTime() - this.commonData.commentTime.getTime()) / 1000 <= 5 ?
            $r('app.string.text_flow_time_place') : $r('app.string.text_flow_time_place1'))
              .fontSize($r('app.integer.text_flow_font_size'))
              .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
              .opacity(0.5)
              .fontColor($r('app.color.text_flow_color_blank'))
            Text($r('app.string.text_flow_reply'))
              .fontSize($r('app.integer.text_flow_font_size'))
              .fontColor($r('app.color.text_flow_note_color'))
              .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
              .opacity(0.8)
              .margin({ left: $r('app.integer.text_flow_reply_margin_left') })
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
          }
          .width("60%")
        }
        .padding({
          left: $r('app.integer.text_flow_column_padding_left'),
          top: $r('app.integer.text_flow_column_padding_top')
        })
        .alignItems(HorizontalAlign.Start)
      }
      .alignItems(VerticalAlign.Top)
      .width("100%")

      Column() {
        // TODO：知识点：使用LazyForEach加载评论列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
        LazyForEach(this.commonData.replyList, (reply: CommentModel) => {
          Row() {
            Image(reply.url)
              .objectFit(ImageFit.Contain)
              .width($r('app.integer.text_flow_img_width_height'))
              .height($r('app.integer.text_flow_img_width_height'))

            Column({ space: 6 }) {
              Row() {
                Text(reply.user)
                  .fontSize($r('app.integer.text_flow_font_size'))
                  .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
                  .fontColor($r('app.color.text_flow_color_blank'))
                  .maxLines(1)// TODO：知识点：通过设定maxLines为1与textOverflow为Ellipsis表明最大行数为1行，超出部分为省略号
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width("30%")
                Image($r('app.media.right'))
                  .objectFit(ImageFit.Contain)
                  .width($r('app.integer.text_flow_font_size'))
                  .height($r('app.integer.text_flow_font_size'))
                  .id('reply')
                Text(reply.replyUser)
                  .fontSize($r('app.integer.text_flow_font_size'))
                  .fontWeight(FONT_WEIGHT_FIVE_HUNDRED)
                  .fontColor($r('app.color.text_flow_color_blank'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width("30%")
              }

              Text(reply.text)
                .fontSize($r('app.integer.text_flow_font_size'))
                .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
                .opacity(0.8)
                .lineHeight($r("app.integer.text_flow_text_line_height"))
                .width("85%")
                .fontColor($r('app.color.text_flow_color_blank'))
              Row() {
                Text($r('app.string.text_flow_time_place'))
                  .fontSize($r('app.integer.text_flow_font_size'))
                  .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
                  .opacity(0.5)
                  .fontColor($r('app.color.text_flow_color_blank'))
                Text($r('app.string.text_flow_reply'))
                  .fontSize($r('app.integer.text_flow_font_size'))
                  .fontWeight(FONT_WEIGHT_FOUR_HUNDRED)
                  .fontColor($r('app.color.text_flow_note_color'))
                  .opacity(0.8)
                  .margin({ left: $r('app.integer.text_flow_reply_margin_left') })
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
              left: $r('app.integer.text_flow_column_padding_left'),
            })
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Top)
          .width("100%")
          .margin({
            bottom: $r('app.integer.text_flow_row_margin_bottom'),
            top: $r('app.integer.text_flow_row_margin_top')
          })
        }, (item: CommentModel) => JSON.stringify(item))
      }
      .margin({
        left: $r('app.integer.text_flow_root_column_margin_left'),
        top: $r('app.integer.text_flow_root_column_margin_top')
      })
    }
    .width("100%")
  }
}