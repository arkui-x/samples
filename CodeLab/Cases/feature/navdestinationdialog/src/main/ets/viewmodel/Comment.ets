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
import { CommentDataSource } from '../model/NavgationModel';
import { showCaseOnly } from '../common/Utils';
import Consts from '../common/Constants';

@Component
export struct Comment {
  @Link isGesture: boolean;
  @Link listScrollAble: boolean;
  close: () => void = () => {};
  private data: CommentDataSource = new CommentDataSource([]);
  private scroller: Scroller = new Scroller();
  @StorageLink('bottomHeight') bottomHeight: number = 0; // 底部导航栏高度

  aboutToAppear(): void {
    // 加载示例评论
    for (let i = 0; i < Consts.TEST_COMMENTS_COUNT; i++) {
      this.data.pushItem(i);
    }
  }

  build() {
    Column() {
      // title
      Row() {
        Blank()
          .width($r('app.integer.navdialog_comment_title_blank_width'))
        Text($r('app.string.navdialog_comment_title_label'))
          .fontSize($r('app.integer.navdialog_comment_title_font_size'))
          .fontWeight(FontWeight.Bold)
          .width($r('app.integer.navdialog_comment_title_font_width'))
          .textAlign(TextAlign.Center)
        Row() {
          Image($r("app.media.nd_close"))
            .width($r('app.integer.navdialog_comment_title_close_img_size'))
            .height($r('app.integer.navdialog_comment_title_close_img_size'))
        }
        .width($r('app.integer.navdialog_comment_title_close_button_width'))
        .height($r('app.integer.navdialog_comment_title_close_button_height'))
        .justifyContent(FlexAlign.Center)
        .onClick(this.close)
      }
      .width($r('app.string.navdialog_full_size'))
      .height($r('app.integer.navdialog_comment_title_height'))
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        left: $r('app.integer.navdialog_comment_padding'),
        right: $r('app.integer.navdialog_comment_padding')
      })

      // commets list
      List({ space: Consts.COMMENT_SPACE, scroller: this.scroller }) {
        // TODO: 高性能知识点: LazyForEach按需加载，提高加载性能。
        LazyForEach(this.data, (item: number, index: number) => {
          ListItem() {
            this.commentItem(index + 1) // index from 1
          }
        }, (item: number) => item.toString())
      }
      .width($r('app.string.navdialog_full_size'))
      // TODO: 高性能知识点: 使用了cachedCount设置预加载的评论，提高快速滑动时的性能。
      .cachedCount(Consts.COMMENTS_LIST_CACHE)
      .padding({
        left: $r('app.integer.navdialog_comment_padding'),
        right: $r('app.integer.navdialog_comment_padding')
      })
      .edgeEffect(EdgeEffect.Spring)
      .onScroll(() => {
        // TODO: 性能关注点： onScroll为系统高频回调，应避免冗余和耗时操作。
        const offsetY = this.scroller.currentOffset().yOffset;
        if (offsetY <= 0) {
          this.isGesture = true;
          this.scroller.scrollTo({ xOffset: 0, yOffset: 0 });
        } else {
          this.isGesture = false;
        }
      })
      .layoutWeight(1) // 自适应布局

      Row() {
        TextInput({ placeholder: $r('app.string.navdialog_comment_textinput_placeholder') })
          .defaultFocus(false)
          .enableKeyboardOnFocus(false)
      }
      .height($r('app.integer.navdialog_comment_textinput_height'))
      .width($r('app.string.navdialog_full_size'))
      .padding({
        left: $r('app.integer.navdialog_comment_padding'),
        right: $r('app.integer.navdialog_comment_padding')
      })
    }
    .width($r('app.string.navdialog_full_size'))
    .height($r('app.string.navdialog_full_size'))
    .padding({ bottom: this.bottomHeight + 'px' })
  }

  @Builder
  commentItem(index: number) {
    Row({ space: Consts.COMMENT_ITEM_SPACE }) {
      Image($r("app.media.nd_portrait_1"))
        .width($r('app.integer.navdialog_comment_portrait_size'))
        .height($r('app.integer.navdialog_comment_portrait_size'))
        .borderRadius($r('app.integer.navdialog_comment_portrait_radius'))

      Column({ space: Consts.COMMENT_CONTENT_SPACE }) {
        // id
        Text(Consts.COMMENTS_DEFAULT_USERNAME + index.toString())
          .fontSize($r('app.integer.navdialog_comment_username_font_size'))
          .fontColor(Color.Gray)
        // comment
        Text($r('app.string.navdialog_comment_example'))
        // comment image
        Image($r("app.media.nd_comment_pic"))
          .width($r('app.integer.navdialog_comment_image_size'))
          .height($r('app.integer.navdialog_comment_image_size'))
          .borderRadius($r('app.integer.navdialog_comment_image_radius'))
        Row() {
          Text($r('app.string.navdialog_comment_time'))
            .fontSize($r('app.integer.navdialog_comment_time_font_size'))
            .fontColor(Color.Gray)
          Blank()
            .width($r('app.integer.navdialog_comment_info_blank_width'))
          Text($r('app.string.navdialog_comment_reply_label'))
            .fontSize($r('app.integer.navdialog_comment_reply_font_size'))
            .fontColor($r("app.color.immersive_comment_reply_font_color"))
            .onClick(() => {
              showCaseOnly();
            })
          Blank()
          Image($r("app.media.nd_like"))
            .width($r('app.integer.navdialog_comment_like_icon_size'))
            .height($r('app.integer.navdialog_comment_like_icon_size'))
            .onClick(() => {
              showCaseOnly();
            })
        }
        .width($r('app.string.navdialog_full_size'))

      }
      .layoutWeight(1) // 自适应布局
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Top)
    .width($r('app.string.navdialog_full_size'))
  }
}
