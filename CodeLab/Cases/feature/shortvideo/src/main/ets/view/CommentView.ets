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

import { promptAction } from '@kit.ArkUI';
import { Constants } from '../constant/Contants';
import { Comment, CommentDataSource } from '../model/DataModel';

/**
 * 单条评论布局
 */
@Component
export struct CommentView {
  // 评论
  @ObjectLink comment: Comment;

  build() {
    Row() {
      Image(this.comment.avatar)
        .width($r("app.integer.shortvideo_comment_avatar_size"))
        .height($r("app.integer.shortvideo_comment_avatar_size"))
        .borderRadius($r("app.integer.shortvideo_comment_avatar_border_radius"))
        .margin({ right: $r('app.integer.shortvideo_comment_number_10') })
      Column({ space: Constants.NUMBER_5 }) {
        Text(this.comment.name)
          .fontSize($r('app.integer.shortvideo_comment_name_font_size'))
          .padding({ top: $r('app.integer.shortvideo_comment_number_20') })
          .fontColor(Color.Gray)
        Text(this.comment.commentContent)
          .fontSize($r('app.integer.shortvideo_comment_content_font_size'))
        Text() {
          Span(this.comment.timeAgo)
          Span($r('app.string.shortvideo_comment_split'))
          Span(this.comment.address)
        }
        .fontSize($r('app.integer.shortvideo_comment_number_12'))
        .fontColor(Color.Gray)
      }.alignItems(HorizontalAlign.Start)
    }.margin({ left: $r('app.integer.shortvideo_comment_number_20') })
  }
}

/**
 * 评论组件
 */
@Component
export struct CommentComponent {
  listScroll: ListScroller = new ListScroller();
  commentData: CommentDataSource = new CommentDataSource();
  @StorageLink('bottomHeight') bottomHeight: number | undefined = AppStorage.get('bottomHeight'); // 底部系统导航栏高度

  build() {
    Column() {
      List({ scroller: this.listScroll }) {
        /*
         *TODO 性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
         *当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
         *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2
         */
        LazyForEach(this.commentData, (item: Comment, index) => {
          ListItem() {
            CommentView({ comment: item })
              .onClick(() => {
                // 调用Toast显示提示：此样式仅为案例演示
                promptAction.showToast({ message: $r('app.string.shortvideo_demo_toast_tips') });
              })
          }
          .margin({ bottom: index === this.commentData.totalCount() - 1 ? this.bottomHeight + 'px' : 0 })
        }, (item: Comment) => item.id)
      }.height($r('app.string.shortvideo_hundred_percent'))
      .id('comment_list')
      .width($r('app.string.shortvideo_hundred_percent'))
    }
    .height($r('app.string.shortvideo_hundred_percent'))
    .backgroundColor(Color.White)
  }
}