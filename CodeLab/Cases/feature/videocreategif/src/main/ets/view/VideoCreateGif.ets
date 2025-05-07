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

import { BannerInfo } from '../model/BannerInfo';
import { VideoInfo } from '../model/VideoInfo';
import { promptAction } from '@kit.ArkUI';
import { fileIo as fs } from '@kit.CoreFileKit';
import resourceManager from '@ohos.resourceManager';
import { DynamicsRouter } from 'routermodule';

/**
 * 功能描述: 本示例介绍了如何截取视频的一段内容制作gif图片，使用FFmpeg命令对视频进行截取gif图
 *
 * 推荐场景: 长视频播放场景
 *
 * 核心组件:
 * 1. SelectGifTimeFrameView
 *
 * 实现步骤:
 * 1. 打开视频播放页面，根据视频是本地视频还是线上视频选择设置avPlayer的url。如果是线上视频，使用边缓存边播放的方式，需要记录缓存文件的本地路径。
 * 2. 根据视频播放页面上"gif"按钮的时间点，按一定规则确定截取的时间范围，进入选取生成gif时间片段页面，通过MP4Parser获取每秒的视频帧图片，展示在时间轴上。
 * 3. 时间轴选择框框取截取的范围。
 * 4. 点击"下一步"按钮，会出现gif生成页面，根据起始时间和截取长度通过MP4Parser的ffmpegCmd方法生成gif图片。
 */
@Component
export struct VideoCreateGifComponent {
  popPage: (() => void) | undefined = undefined;

  private bannerInfoArray: BannerInfo[] = [{image: $r("app.media.video_create_gif_preview1"), title: "鹅鹅鹅"},
    {image: $r("app.media.video_create_gif_preview2"), title: "曲项向天歌"},
    {image: $r("app.media.video_create_gif_preview3"), title: "白毛浮绿水"},
    {image: $r("app.media.video_create_gif_preview4"), title: "红掌拨清波"}];

  private videoInfoArray: VideoInfo[] = [{image: $r("app.media.video_create_gif_preview6"), title: "本地视频截取gif", description: "视频文件已在沙箱"},
    {image: $r("app.media.video_create_gif_preview5"), title: "在线视频截取gif", description: "视频边下载边播"},
    {image: $r("app.media.video_create_gif_preview1"), title: "李白", description: "床前明月光"},
    {image: $r("app.media.video_create_gif_preview2"), title: "杜甫", description: "好雨知时节"},
    {image: $r("app.media.video_create_gif_preview3"), title: "白居易", description: "离离原上草"},
    {image: $r("app.media.video_create_gif_preview4"), title: "王维", description: "空山新雨后"},
    {image: $r("app.media.video_create_gif_preview1"), title: "孟浩然", description: "春眠不觉晓"},
    {image: $r("app.media.video_create_gif_preview2"), title: "柳宗元", description: "千山鸟飞绝"},
    {image: $r("app.media.video_create_gif_preview3"), title: "韩愈", description: "古之学者必有师"},
    {image: $r("app.media.video_create_gif_preview4"), title: "苏轼", description: "水光潋滟晴方好"}];

  build() {
    Scroll() {
      Column() {
        Swiper() {
          ForEach(this.bannerInfoArray, (value: BannerInfo) => {
            this.createSwiperItem(value)
          }, (value: BannerInfo) => value.title)
        }
        .loop(true)
        .indicator(
          Indicator.dot()
            .right($r('app.integer.video_create_gif_video_home_left_and_right_padding'))
            .itemWidth($r('app.integer.video_create_gif_banner_indicator_dot_width'))
            .itemHeight($r('app.integer.video_create_gif_banner_indicator_dot_width'))
            .selectedItemWidth($r('app.integer.video_create_gif_banner_indicator_dot_width'))
            .selectedItemHeight($r('app.integer.video_create_gif_banner_indicator_dot_width'))
            .color(Color.Gray)
            .selectedColor(Color.White)
        )
        .width($r('app.string.video_create_gif_full_width'))
        .height($r('app.integer.video_create_gif_banner_height'))

        Text($r('app.string.video_create_gif_hot_teleplay'))
          .fontSize($r('app.integer.video_create_gif_big_font_size'))
          .fontColor(Color.Black)
          .fontWeight(500)
          .margin({
            left: $r('app.integer.video_create_gif_video_home_left_and_right_padding'),
            top: $r('app.integer.video_create_gif_video_home_hot_teleplay_top_margin'),
            bottom: $r('app.integer.video_create_gif_video_home_hot_teleplay_bottom_margin')
          })

        Grid() {
          ForEach(this.videoInfoArray, (item: VideoInfo, index: number) => {
            GridItem() {
              this.createVideoItem(item, index)
            }
          }, (item: VideoInfo) => item.title)
        }
        .columnsGap(6)
        .rowsGap(8)
        .columnsTemplate('1fr 1fr')
        .width($r('app.string.video_create_gif_full_width'))
        .padding({
          left: $r('app.integer.video_create_gif_video_home_left_and_right_padding'),
          right: $r('app.integer.video_create_gif_video_home_left_and_right_padding')
        })
        .alignItems(GridItemAlignment.STRETCH)
        .scrollBar(BarState.Off)
      }
      .width($r('app.string.video_create_gif_full_width'))
      .alignItems(HorizontalAlign.Start)
    }.height($r('app.string.video_create_gif_full_width'))
    .width($r('app.string.video_create_gif_full_width'))
    .edgeEffect(EdgeEffect.Spring)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  /**
   * 创建banner单项布局
   * @param bannerInfo
   */
  @Builder createSwiperItem(bannerInfo: BannerInfo) {
    Column() {
      Text(bannerInfo.title)
        .fontSize($r('app.integer.video_create_gif_big_font_size'))
        .fontColor(Color.White)
    }.width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_full_width'))
    .padding({
      left: $r('app.integer.video_create_gif_video_home_left_and_right_padding'),
      bottom: $r('app.integer.video_create_gif_banner_title_bottom_padding')
    })
    .justifyContent(FlexAlign.End)
    .alignItems(HorizontalAlign.Start)
    .backgroundImage(bannerInfo.image)
    .backgroundImageSize(ImageSize.Cover)
    .onClick(() => {
      promptAction.showToast({
        message: $r('app.string.video_create_gif_toast_tips')
      });
    })
  }

  /**
   * 创建视频单项布局
   * @param videoInfo
   * @param index
   */
  @Builder createVideoItem(videoInfo: VideoInfo, index: number) {
    Column() {
      Image(videoInfo.image)
        .objectFit(ImageFit.Fill)
        .width($r('app.string.video_create_gif_full_width'))
        .height($r('app.integer.video_create_gif_video_home_item_height'))
        .borderRadius($r('app.integer.video_create_gif_video_home_item_border_radius'))

      Text(videoInfo.title)
        .fontSize($r('app.integer.video_create_gif_big_font_size'))
        .fontColor(Color.Black)
        .maxLines(1)
        .margin({
          top: $r('app.integer.video_create_gif_video_home_item_title_top_margin')
        })

      Text(videoInfo.description)
        .fontSize($r('app.integer.video_create_gif_small_font_size'))
        .fontColor(Color.Gray)
        .maxLines(1)
        .margin({
          top: $r('app.integer.video_create_gif_video_home_item_description_top_margin')
        })
    }
    .width($r('app.string.video_create_gif_full_width'))
    .alignItems(HorizontalAlign.Start)
    .id(index === 0 ? "first_video" : (index === 1 ? "second_video" : "other_video"))
    .onClick(() => {
      if (index === 0) {    // 名称为本地视频截取gif
        this.copyFile2Sandbox('video.mp4');
        DynamicsRouter.pushUri("videocreategif/VideoPlayPage", getContext(this).filesDir + "/video.mp4");
      } else if (index === 1) {   // 名称为在线视频截取gif
        DynamicsRouter.pushUri("videocreategif/VideoPlayPage", "https://assets.mixkit.co/videos/4075/4075-720.mp4");
      } else {
        promptAction.showToast({
          message: $r('app.string.video_create_gif_toast_tips')
        });
      }
    })
  }

  /**
   * 将rawfile中的文件拷贝到沙箱中
   * @param filename
   */
  copyFile2Sandbox(filename: string) {
    const targetPath: string = getContext().filesDir + "/" + filename;
    if (fs.accessSync(targetPath)) {

      return;
    }

    const data: resourceManager.RawFileDescriptor = getContext(this).resourceManager.getRawFdSync(filename);

    const destFile: fs.File = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

    let buffSize: number = 4096;
    const buffer: ArrayBuffer = new ArrayBuffer(Math.min(buffSize, data.length));
    let off: number = 0;
    let len: number = 0;
    let readLen: number = 0;

    while (len = fs.readSync(data.fd, buffer, { offset: data.offset + off, length: buffSize })) {
      readLen += len;
      fs.writeSync(destFile.fd, buffer, { offset: off, length: len });
      off = off + len;
      if ((data.length - readLen) < buffSize) {
        buffSize = data.length - readLen;
      }
    }

    getContext(this).resourceManager.closeRawFdSync(filename);
    fs.close(destFile.fd);
  }

}