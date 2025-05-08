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

import { Comment, CommentData } from '../model/CommentModel';
import { CommentView } from './CommentItemView';
import { CommentInputDialog } from './CommentInputDialog';
import { mockData } from '../model/MockCommentData';

/**
 * 功能描述：本示例将通过发布图片评论场景，介绍如何使用startAbilityForResult接口拉起相机拍照，并获取相机返回的数据。
 *
 * 推荐场景：社交软件，如微博，小红书
 *
 * 核心组件：
 * 1.ImageCommentViewComponent
 * 2.CommentView
 * 3.ImageListView
 *
 * 实现步骤：
 * 1.添加评论列表
 * 2.点击评论组件，弹出评论输入框，输入文字，点击相机按钮拉起相机拍照，并在列表中显示照片
 * 3.点击发布，将评论添加到列表中
 */

const ID_ROW_PUBLISH: string = "id_image_comment_row_publish";
const ID_TEXT_EMPTY: string = "id_image_comment_text_empty";
const ID_LIST: string = "id_image_comment_list";
const ID_TEXT_TITLE: string = "id_image_comment_text_title";
const ID_IMAGE: string = "id_image_comment_top_image";

@Component
export struct ImageCommentViewComponent {
  // 评论列表
  @State commentList: CommentData = new CommentData();
  // 评论中的文字
  @State textInComment: string = "";
  // 评论中的图片列表
  @State imageInComment: string[] = [];
  private scroller: ListScroller = new ListScroller();
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  // 评论数量，用于刷新列表
  commentCount: number = 0;
  // 评论输入弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: $textInComment,
      imagesInComment: $imageInComment,
      publish: () => this.publishComment()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    offset: {
      dx: $r('app.integer.image_comment_dialog_offset_x'),
      dy: $r('app.integer.image_comment_dialog_offset_y')
    }
  });

  aboutToAppear(): void {
    // 添加模拟数据
    this.commentList = mockData();
    this.commentCount = this.commentList.totalCount();
  }

  aboutToDisappear() {
    // 将dialogController置空
    this.dialogController = null;
  }

  // 发布评论
  publishComment(): void {
    const comment: Comment =
      new Comment("Kevin", this.textInComment, $r("app.media.icon_comment_icon_main"), this.imageInComment,
        this.getCurrentDate());
    this.commentList.addDataFirst(comment);
    this.scroller.scrollToIndex(0, true, ScrollAlign.START);
  }

  // 获取当前时间
  getCurrentDate(): string {
    const date: Date = new Date();
    return `${date.getFullYear()}-${date.getMonth()}-${date.getDay()} ${date.getHours()}:${date.getMinutes()}`;
  }

  build() {
    Column() {
      RelativeContainer() {
        Image($r("app.media.icon_comment_launch_advert"))
          .height($r('app.string.image_comment_percent_30'))
          .alignRules({
            top: { anchor: "__container__", align: VerticalAlign.Top },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_IMAGE)
        Text($r('app.string.image_comment_hot_comment'))
          .height($r('app.integer.image_comment_text_hot_comment_height'))
          .width($r('app.string.image_comment_percent_100'))
          .padding({
            left: $r('app.integer.image_comment_text_hot_comment_padding_left')
          })
          .border({
            width: {
              bottom: $r('app.integer.image_comment_text_hot_comment_border_width_bottom')
            },
            color: {
              bottom: $r('app.color.image_comment_color_divider')
            }
          })
          .alignRules({
            top: { anchor: ID_IMAGE, align: VerticalAlign.Bottom },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_TEXT_TITLE)

        if (this.commentCount > 0) {
          List({ scroller: this.scroller }) {
            // TODO：知识点：使用LazyForEach加载评论列表，可以按需加载，解决一次性加载全部列表数据引起的卡顿问题，提高页面响应速度
            LazyForEach(this.commentList, (comment: Comment) => {
              ListItem() {
                CommentView({ comment: comment })
              }
            }, (item: Comment) => JSON.stringify(item))
          }
          .scrollBar(BarState.Off)
          .width($r('app.string.image_comment_percent_100'))
          .margin({
            bottom: $r('app.integer.image_comment_list_comment_margin_bottom')
          })
          .alignRules({
            top: { anchor: ID_TEXT_TITLE, align: VerticalAlign.Bottom },
            bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
            left: { anchor: "__container__", align: HorizontalAlign.Start },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .id(ID_LIST)
        } else {
          Text($r('app.string.image_comment_no_comment'))
            .textAlign(TextAlign.Center)
            .width($r('app.string.image_comment_percent_100'))
            .margin({
              bottom: $r('app.integer.image_comment_text_no_comment_margin_bottom')
            })
            .alignRules({
              top: { anchor: ID_TEXT_TITLE, align: VerticalAlign.Bottom },
              bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
              left: { anchor: "__container__", align: HorizontalAlign.Start },
              right: { anchor: "__container__", align: HorizontalAlign.End }
            })
            .id(ID_TEXT_EMPTY)
        }

        Row() {
          Text($r('app.string.image_comment_text_input_hint'))
            .borderRadius($r('app.integer.image_comment_text_input_hint_border_radius'))
            .height($r('app.integer.image_comment_text_input_hint_height'))
            .width($r('app.string.image_comment_percent_95'))
            .padding({
              left: $r('app.integer.image_comment_text_input_hint_padding_left')
            })
            .backgroundColor($r('app.color.image_comment_color_comment_text_background'))
            .onClick(() => {
              if (this.dialogController !== null) {
                // 打开评论输入弹窗
                this.dialogController.open();
              }
            })
            .border({
              width: $r('app.integer.image_comment_text_input_hint_border_width'),
              color: $r('app.color.image_comment_color_comment_text_border')
            })
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height($r('app.integer.image_comment_row_input_hint_height'))
        .width($r('app.string.image_comment_percent_100'))
        .border({
          width: {
            top: $r('app.integer.image_comment_row_input_hint_border_width_top')
          },
          color: {
            top: $r('app.color.image_comment_color_divider')
          }
        })
        .alignRules({
          bottom: { anchor: "__container__", align: VerticalAlign.Bottom },
          left: { anchor: "__container__", align: HorizontalAlign.Start },
          right: { anchor: "__container__", align: HorizontalAlign.End }
        })
        .id(ID_ROW_PUBLISH)

      }
      .width($r('app.string.image_comment_percent_100'))
      .height($r('app.string.image_comment_percent_100'))
    }
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .width('100%')
    .height('100%')
  }
}