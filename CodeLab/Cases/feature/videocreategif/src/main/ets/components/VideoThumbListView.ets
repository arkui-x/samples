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

export class ThumbContent {
  framePlaceholder?: PixelMap = undefined;
  pixelMap?: PixelMap = undefined;
}

export class VideoThumbOption {
  videoThumbs: ThumbContent[] = [];
  videoThumbWidth: number = 0;
}

/**
 * 时间轴小图展示
 */
@Component
export struct VideoThumbListView {
  @Link mVideoThumbOption: VideoThumbOption;

  build() {
    Column() {
      List() {
        // 需要展示全部的视频每秒的小图，不需要使用LazyForEach
        ForEach(this.mVideoThumbOption.videoThumbs, (item:ThumbContent) => {
          ListItem() {
            Image(item.pixelMap ? item.pixelMap : item.framePlaceholder)
              .objectFit(ImageFit.CENTER)
              .width(this.mVideoThumbOption.videoThumbWidth)
              .height($r('app.string.video_create_gif_full_width'))
          }
          .width(this.mVideoThumbOption.videoThumbWidth)
          .height($r('app.string.video_create_gif_full_width'))
          .backgroundColor(Color.Black)
        }, (item: ThumbContent, index: number) => `${index}`)
      }
      .listDirection(Axis.Horizontal)
      .height($r('app.string.video_create_gif_full_width'))
      .width($r('app.string.video_create_gif_full_width'))
      .scrollBar(BarState.Off)
    }.width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_full_width'))
  }

}