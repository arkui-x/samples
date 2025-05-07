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

import { VideoData } from '../model/DataModel';
import { Side, VideoDes } from './Side';
import { promptAction } from '@kit.ArkUI';

@Component
export struct VideoMask {
  // 短视频数据
  @Prop videoData: VideoData;
  // 初始化控制评论半模态弹窗显示
  @StorageProp('isShowGlobalStateDialog') isShowGlobalStateDialog: boolean = false; // 是否展示全局弹窗

  build() {
    // 展示视频信息
    Stack({ alignContent: Alignment.BottomStart }) {
      // 视频播放组件
      Stack({ alignContent: Alignment.TopEnd }) {
        // 展示视频播放界面右侧用户头像、视频评论数量、收藏数量、分享数量等信息
        Side({
          head: this.videoData.videoMask.head,
          likeCount: this.videoData.videoMask.likeCount,
          commentCount: this.videoData.videoMask.commentCount,
          favoriteCount: this.videoData.videoMask.favoriteCount,
          shareCount: this.videoData.videoMask.shareCount,
          commentData: this.videoData.videoMask.commentDataSource
        })
      }
      .width($r('app.string.shortvideo_hundred_percent'))
      .height($r('app.string.shortvideo_hundred_percent'))
      .padding($r("app.integer.shortvideo_stack_padding"))

      // 展示视频播放界面左下角作者名字、作品描述等相关信息
      VideoDes({
        name: this.videoData.videoMask.name,
        description: this.videoData.videoMask.description,
        hotspot: this.videoData.videoMask.hotspot,
        time: this.videoData.videoMask.time
      })
        .margin({ bottom: $r("app.integer.shortvideo_video_des_margin_bottom") })
      Row() {
        Row() {
          Image($r("app.media.shortvideo_ic_public_upgrade_filled"))
            .height($r("app.integer.shortvideo_upgrade_icon_size"))
            .width($r("app.integer.shortvideo_upgrade_icon_size"))
          Text($r("app.string.shortvideo_upgrade_hot"))
            .fontSize($r("app.integer.shortvideo_upgrade_text_font_size"))
            .fontColor($r("app.color.shortvideo_up_color"))
          Text(' · ' + this.videoData.videoMask.hotspot)
            .fontSize($r("app.integer.shortvideo_mus_font_size"))
            .maxLines(1)
            .width(this.videoData.videoMask.hotspot.length * 12)
            .fontColor(Color.White)
            .height($r("app.integer.shortvideo_mus_height"))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .layoutWeight(1)
        }
        .width($r('app.string.shortvideo_upgrade_hot_width'))

        // 上升热点
        Row() {
          Divider()
            .vertical(true)
            .color(Color.White)
            .strokeWidth(1)
            .height($r("app.integer.shortvideo_upgrade_text_font_size"))
            .margin({
              left: $r("app.integer.shortvideo_upgrade_margin"),
              right: $r("app.integer.shortvideo_upgrade_margin")
            })
          Text($r("app.string.shortvideo_online_people"))
            .fontSize($r("app.integer.shortvideo_mus_font_size"))
            .fontColor(Color.White)
          Image($r("app.media.shortvideo_ic_arrow_right"))
            .width($r("app.integer.shortvideo_upgrade_text_font_size"))
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.End)
      }
      .width($r('app.string.shortvideo_hundred_percent'))
      .height($r("app.integer.shortvideo_upgrade_height"))
      .backgroundColor(Color.Gray)
      .opacity($r("app.float.shortvideo_fabulous_opacity"))
      .padding({
        left: $r("app.integer.shortvideo_upgrade_padding"),
        right: $r("app.integer.shortvideo_upgrade_padding")
      })
      .justifyContent(FlexAlign.Start)
      .onClick(() => {
        // 调用Toast显示提示：此样式仅为案例演示
        promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
      })

    }.width($r('app.string.shortvideo_hundred_percent'))
    .height($r('app.string.shortvideo_hundred_percent'))
    .padding($r("app.integer.shortvideo_stack_padding"))
    .hitTestBehavior(HitTestMode.Transparent)
  }
}

@Builder
export function VideoComponent(videoData: VideoData) {
  VideoMask({
    videoData: videoData
  })
}
