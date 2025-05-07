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
import { GlobalStateDialogManager } from 'utils';
import { CommentDataSource } from '../model/DataModel';
import { CommentComponent } from './CommentView';

// 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量、作者是否被用户关注等信息
@Component
export struct Side {
  @State head: ResourceStr = $r("app.media.shortvideo_app_icon"); // 头像
  @State likeCount: string = ''; // 点赞数量
  @State commentCount: string = ''; // 评论数量
  @State favoriteCount: string = ''; // 收藏数量
  @State shareCount: string = ''; // 分享数量
  @State isFocus: boolean = true; // 是否关注
  @State isLike: boolean = false; // 是否点赞
  @State isFavorite: boolean = true; // 是否收藏
  @ObjectLink @Watch('changeCommentData') commentData: CommentDataSource; // 当评论内容更改时刷新全局弹窗

  changeCommentData() {
    GlobalStateDialogManager.operateGlobalStateDialog({
      wrapBuilder: wrapBuilder(commentBuilder),
      params: this.commentData
    });
  }

  aboutToAppear(): void {
    this.changeCommentData();
  }

  // 点击点赞按钮的回调函数
  private changeLikeCount(isAdd: boolean) {
    let likeCountNum = Number(this.likeCount);
    if (isAdd) {
      likeCountNum++;
    } else {
      likeCountNum--;
    }
    this.likeCount = '' + likeCountNum;
    animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
      this.isLike = !this.isLike;
    })
  }

  // 点击收藏按钮的回调函数
  private changefavoriteCount(isIncrease: boolean) {
    let favoriteCountNum = Number(this.favoriteCount);
    if (isIncrease) {
      favoriteCountNum++;
    } else {
      favoriteCountNum--;
    }
    this.favoriteCount = '' + favoriteCountNum;
    animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
      this.isFavorite = !this.isFavorite;
    })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Image(this.head)
          .width($r("app.integer.shortvideo_avatar_size"))
          .height($r("app.integer.shortvideo_avatar_size"))
          .borderRadius($r("app.float.shortvideo_avatar_borderRadius"))
          .border({
            width: 1,
            color: Color.White
          })
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
          })
        if (this.isFocus) {
          Image($r("app.media.shortvideo_img"))
            .width($r("app.integer.shortvideo_concern_size"))
            .height($r("app.integer.shortvideo_concern_size"))
            .borderRadius($r("app.integer.shortvideo_concern_border_radius"))
            .margin({ bottom: $r("app.integer.shortvideo_concern_margin_bottom") })
            .onClick(() => {
              animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
                this.isFocus = !this.isFocus;
              })
            })
        } else {
          Image($r("app.media.shortvideo_follow1"))
            .width($r("app.integer.shortvideo_concern_size"))
            .height($r("app.integer.shortvideo_concern_size"))
            .borderRadius($r("app.integer.shortvideo_concern_border_radius"))
            .margin({ bottom: $r("app.integer.shortvideo_concern_margin_bottom") })
            .onClick(() => {
              animateTo({ duration: 200, curve: Curve.EaseInOut }, () => {
                this.isFocus = !this.isFocus;
              })
            })
        }
      }
      .width('100%')
      .height($r("app.integer.shortvideo_avatar_height"))
      .padding({ bottom: $r("app.integer.shortvideo_avatar_padding_bottom") })

      Column() {
        if (!this.isLike) {
          Image($r("app.media.shortvideo_fabulous"))
            .height($r("app.integer.shortvideo_fabulous_height"))
            .width($r("app.integer.shortvideo_fabulous_width"))
            .objectFit(ImageFit.ScaleDown)
            .onClick(() => {
              this.changeLikeCount(true);
            })
            .margin({ bottom: $r("app.integer.shortvideo_fabulous_margin_bottom") })
          Text(this.likeCount)
            .fontSize($r("app.integer.shortvideo_fabulous_font_size"))
            .fontColor(Color.White)
            .opacity($r("app.float.shortvideo_fabulous_opacity"))
        } else {
          Image($r("app.media.shortvideo_fabulo"))
            .height($r("app.integer.shortvideo_fabulous_height"))
            .width($r("app.integer.shortvideo_fabulous_width"))
            .objectFit(ImageFit.ScaleDown)
            .onClick(() => {
              this.changeLikeCount(false);
            })
            .margin({ bottom: $r("app.integer.shortvideo_fabulous_margin_bottom") })
          Text(this.likeCount)
            .fontSize($r("app.integer.shortvideo_fabulous_font_size"))
            .fontColor(Color.White)
            .opacity($r("app.float.shortvideo_fabulous_opacity"))
        }
      }.width('60%')
      .height($r("app.integer.shortvideo_all_fabulous_height"))

      Column() {
        Image($r("app.media.shortvideo_new_icon"))
          .height($r("app.integer.shortvideo_fabulous_height"))
          .width($r("app.integer.shortvideo_fabulous_width"))
          .objectFit(ImageFit.ScaleDown)
          .margin({ bottom: $r("app.integer.shortvideo_fabulous_margin_bottom") })
        Text(this.commentCount)
          .fontSize($r("app.integer.shortvideo_fabulous_font_size"))
          .fontColor(Color.White)
          .opacity($r("app.float.shortvideo_fabulous_opacity"))
      }.width('60%')
      .height($r("app.integer.shortvideo_all_fabulous_height"))
      .onClick(() => {
        // 开启全局弹窗
        GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: true });
      })
      .id('comment_button')

      Column() {
        if (this.isFavorite) {
          Image($r("app.media.shortvideo_ic_public_highlightsed_white"))
            .height($r("app.integer.shortvideo_fabulous_height"))
            .width($r("app.integer.shortvideo_fabulous_width"))
            .onClick(() => {
              this.changefavoriteCount(true);
            })
            .margin({ bottom: $r("app.integer.shortvideo_fabulous_margin_bottom") })
          Text(this.favoriteCount)
            .fontSize($r("app.integer.shortvideo_fabulous_font_size"))
            .fontColor(Color.White)
            .opacity($r("app.float.shortvideo_fabulous_opacity"))
        } else {
          Image($r("app.media.shortvideo_ic_public_highlightsed_yellow"))
            .height($r("app.integer.shortvideo_fabulous_height"))
            .width($r("app.integer.shortvideo_fabulous_width"))
            .onClick(() => {
              this.changefavoriteCount(false);
            })
            .margin({ bottom: $r("app.integer.shortvideo_fabulous_margin_bottom") })
          Text(this.favoriteCount)
            .fontSize($r("app.integer.shortvideo_fabulous_font_size"))
            .fontColor(Color.White)
            .opacity($r("app.float.shortvideo_fabulous_opacity"))
        }
      }.width('60%')
      .height(60)

      Column() {
        Image($r("app.media.shortvideo_share1"))
          .height($r("app.integer.shortvideo_share_height"))
          .width($r("app.integer.shortvideo_share_height"))
          .objectFit(ImageFit.ScaleDown)
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
          })
        Text($r("app.string.shortvideo_share"))
          .fontSize($r("app.integer.shortvideo_fabulous_font_size"))
          .fontColor(Color.White)
          .opacity($r("app.float.shortvideo_fabulous_opacity"))
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
          })
      }.width('60%')
      .height($r("app.integer.shortvideo_share_all_width"))
    }
    .margin({ top: $r("app.integer.shortvideo_side_margin_top") })
    .height('60%')
    .width($r("app.integer.shortvideo_side_width"))
    .justifyContent(FlexAlign.End)
  }
}

@Builder
function commentBuilder(commentData: CommentDataSource): void {
  CommentComponent({ commentData: commentData })
}

// 展示视频相关信息，比如视频作者的昵称、视频文案、搭配的音乐以及发布时间
@Component
export struct VideoDes {
  @State name: string = ''; // 昵称
  @State description: string = ''; // 文案
  @State hotspot: string = ''; // 上升热点
  @State time: string = ''; // 发布时间

  build() {
    Column() {
      Text(this.name)
        .fontSize($r("app.integer.shortvideo_name_font_size"))
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ bottom: $r("app.integer.shortvideo_name_margin_bottom") })
        .onClick(() => {
          // 调用Toast显示提示：此样式仅为案例演示
          promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
        })

      Text(this.description)
        .fontSize($r("app.integer.shortvideo_new_font_size"))
        .fontColor(Color.White)
        .width('70%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .onClick(() => {
          // 调用Toast显示提示：此样式仅为案例演示
          promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
        })

      Row() {
        Text(this.time)
          .fontSize($r("app.integer.shortvideo_time_font_size"))
          .fontColor($r("app.color.shortvideo_time_color"))
      }
    }
    .padding({ left: $r("app.integer.shortvideo_name_padding_left") })
    .alignItems(HorizontalAlign.Start)
    .width('80%')
  }
}
