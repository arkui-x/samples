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

import { VideoThumbListView, ThumbContent, VideoThumbOption } from './VideoThumbListView';
import { RangeSeekBarView, RangeSeekBarListener } from './RangeSeekBarView';
import media from '@ohos.multimedia.media';
import { fileIo as fs } from '@kit.CoreFileKit';
import { IFrameCallBack, ICallBack, MP4Parser } from "@ohos/mp4parser";
import image from '@ohos.multimedia.image';
import { logger } from '../util/Logger';

/**
 * 选取生成gif时间片段页面
 */
@Component
export struct SelectGifTimeFrameView {
  @State promptText: string = '';
  @State ratio: number = 1.0;
  @Prop @Watch("watchPlayEvent") playEvent: number = 0;
  @State mVideoThumbOption: VideoThumbOption = {
    videoThumbs: [],
    videoThumbWidth: 0
  };
  @State progress: number = 0;

  private seekBarWidth: number = 0;           // 选取gif时间段组件的宽度
  private seekBarHeight: number = 0;          // 选取gif时间段组件的高度
  private avPlayer?: media.AVPlayer;
  private surfaceId: string = '';
  private xComponentController: XComponentController = new XComponentController();
  private isCreate: boolean = false;        // 视频播放器是否被创建

  /************************ 必传参数 *********************************/
  private srcFilePath: string = '';      // 视频文件路径
  private maxTime: number = 10;          // 最大时间间隔，单位秒
  private minTime: number = 5;           // 最小时间间隔，单位秒
  private startTime: number = 0;         // 开始时间，单位毫秒
  private endTime: number = 0;           // 结束时间，单位毫秒
  private currentStartTime: number = 0;  // 当前选取的开始时间，单位毫秒
  private currentEndTime: number = 0;    // 当前选取的结束时间，单位毫秒
  private videoWidth: number = 1;        // 视频宽度
  private videoHeight: number = 1;       // 视频高度
  private thumbWidth: number = 12;       // 拖动bar宽度
  private back?: () => void;             // 按返回按钮的处理
  private startCreateGif?: (startTime: number, endTime: number, src: string) => void;   // 创建gif的处理
  /*******************************************************************/

  private videoThumbCount: number = 0;          // 视频小图数量
  private startTruncationTime: number = 0;      // 截取gif的起始时间
  private endTruncationTime: number = 0;        // 截断gif的结束时间

  private rangeSeekBarListener: RangeSeekBarListener = {
    onRangeSeekBarValuesChanged: (minValue: number, maxValue: number): void => {
      // 截取时间段设置
      this.startTruncationTime = Math.floor(minValue);
      this.endTruncationTime = Math.floor(maxValue);

      let duration = Math.floor((this.endTruncationTime - this.startTruncationTime) / 1000);
      this.promptText = getContext(this).resourceManager.getStringSync($r('app.string.video_create_gif_select_prompt').id, `${duration}`, `${this.maxTime}`);

      this.progress = 0;
      this.avPlayer?.play();
      this.seekTo(this.startTruncationTime);
    }
  }

  private watchPlayEvent() {
    this.avPlayer?.play();
  }

  aboutToAppear() {
    this.initThumbList();
  }

  async aboutToDisappear():Promise<void> {
    // 保证页面销毁 如果还有取帧行为应该及时停止该子线程操作
    MP4Parser.stopGetFrame();

    if (this.isCreate) {
      this.setOffCallback();
      await this.avPlayer?.stop();
      await this.avPlayer?.release();
      this.isCreate = false;
    }
  }

  /**
   * 设置AVPlayer播放时间的监听
   */
  timeUpdate(): void {
    this.avPlayer?.on('timeUpdate', (time: number) => {
      // 播放占比情况
      if (this.avPlayer) {
        let currentProgress = (this.avPlayer?.currentTime - this.startTruncationTime) * (1.0) / (this.endTruncationTime - this.startTruncationTime);

        if (currentProgress <= 0) {
          currentProgress = 0;
        }

        if (currentProgress >= 1) {
          currentProgress = 1;
        }

        this.progress = currentProgress;
      }

      // 当播放的时间大于等于截止时间时候，回到开始截取的地方重新播放
      if (this.avPlayer && this.avPlayer.currentTime >= this.endTruncationTime) {
        this.avPlayer?.play();    // 如果不调用，在线视频的方式会被暂停
        this.seekTo(this.startTruncationTime);
        this.progress = 0;
      }
    })
  }

  /**
   * 移除播放状态机AVPlayerState切换的事件监听和播放时间监听
   * @returns
   */
  setOffCallback(): void {
    if (this.avPlayer) {
      this.avPlayer?.off('timeUpdate');
      this.avPlayer?.off('stateChange');
    }
  }

  /**
   * 设置播放状态机AVPlayerState切换的事件
   * @returns
   */
  async setStateChangeCallback(): Promise<void> {
    if (this.avPlayer) {
      this.avPlayer?.on('stateChange', async (state, reason) => {
        switch (state) {
          case 'idle':
            logger.info('state idle called');
            break;

          case 'initialized':
            logger.info('state initialized called');
            this.avPlayer!.surfaceId = this.surfaceId;
            this.avPlayer!.prepare();
            break;

          case 'prepared':
            this.videoPrepared();
            this.avPlayer?.play();
            this.seekTo(this.startTruncationTime);
            break;

          case 'playing':
            logger.info('state playing called');
            break;

          case 'paused':
            logger.info('state paused called');
            break;

          case 'completed':
            logger.info('state completed called');
            this.seekTo(this.startTruncationTime);
            this.progress = 0;
            break;

          case 'stopped':
            logger.info('state stopped called');
            break;

          case 'released':
            logger.info('state released called');
            break;

          case 'error':
            logger.info('state error called');
            break;

          default:
            logger.info('state unknown called');
            break;
        }
      })
    }
  }

  build() {
    Column() {
      RelativeContainer() {
        // 返回按钮
        Image($r("app.media.video_create_gif_back"))
          .width($r('app.integer.video_create_gif_select_gif_time_back_button_width'))
          .height($r('app.integer.video_create_gif_select_gif_time_back_button_height'))
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            left: { anchor: "__container__", align: HorizontalAlign.Start }
          })
          .padding({
            top: $r('app.integer.video_create_gif_select_gif_time_back_button_left_and_right_padding'),
            bottom: $r('app.integer.video_create_gif_select_gif_time_back_button_left_and_right_padding')
          })
          .onClick(() => {
            if (this.back) {
              this.back();
            }
          })
          .id('select_gif_time_frame_back')

        // 标题
        Text($r('app.string.video_create_gif_truncate_gif'))
          .fontSize($r('app.integer.video_create_gif_large_font_size'))
          .fontColor(Color.White)
          .fontWeight(600)
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            middle: { anchor: "__container__", align: HorizontalAlign.Center }
          })

        // 下一步操作按钮
        Button($r('app.string.video_create_gif_next_step'), { type: ButtonType.Normal})
          .fontSize($r('app.integer.video_create_gif_middle_font_size'))
          .fontColor(Color.White)
          .backgroundColor($r('app.color.video_create_gif_button_background_color'))
          .borderRadius($r('app.integer.video_create_gif_select_gif_time_next_button_border_radius'))
          .borderWidth($r('app.integer.video_create_gif_select_gif_time_next_button_border_width'))
          .borderColor(Color.White)
          .alignRules({
            center: { anchor: "__container__", align: VerticalAlign.Center },
            right: { anchor: "__container__", align: HorizontalAlign.End }
          })
          .padding({
            left: $r('app.integer.video_create_gif_select_gif_time_next_button_left_and_right_padding'),
            right: $r('app.integer.video_create_gif_select_gif_time_next_button_left_and_right_padding'),
          })
          .height($r('app.integer.video_create_gif_select_gif_time_next_button_height'))
          .onClick(() => {
            this.avPlayer?.pause();
            if (this.startCreateGif) {
              this.startCreateGif(this.startTruncationTime, this.endTruncationTime, this.srcFilePath);
            }
          })
      }
      .width($r('app.string.video_create_gif_full_width'))
      .height($r('app.integer.video_create_gif_select_gif_time_top_bar_height'))
      .padding({
        left: $r('app.integer.video_create_gif_select_gif_time_top_bar_left_and_right_padding'),
        right: $r('app.integer.video_create_gif_select_gif_time_top_bar_left_and_right_padding')
      })

      // 视频播放
      this.videoContent()

      // 提示描述
      Text(this.promptText)
        .fontSize($r('app.integer.video_create_gif_middle_font_size'))
        .fontColor(Color.White)

      // 选取gif时间段
      this.selectGifTime()
    }
    .alignItems(HorizontalAlign.Center)
    .width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_full_width'))
    .backgroundColor($r('app.color.video_create_gif_view_background_color'))
  }

  /**
   * 视频播放布局
   */
  @Builder
  private videoContent() {
    Stack({ alignContent: Alignment.Center }) {
      XComponent({
        id: 'componentId',
        type: XComponentType.SURFACE,
        controller: this.xComponentController
      })
      .onLoad(async () => {
        this.surfaceId = this.xComponentController.getXComponentSurfaceId();
        this.avPlayer = await media.createAVPlayer();
        this.isCreate = true;

        this.setStateChangeCallback();
        this.timeUpdate();

        let file = await fs.open(this.srcFilePath);
        this.avPlayer.url = `fd://${file.fd}`;
      })
      .aspectRatio(this.ratio)
      .borderWidth(1)
      .borderColor(Color.Gray)
    }
    .width($r('app.string.video_create_gif_full_width'))
    .height($r('app.string.video_create_gif_half_full_width'))
    .padding({
      left: $r('app.integer.video_create_gif_select_gif_time_video_left_and_right_padding'),
      right: $r('app.integer.video_create_gif_select_gif_time_video_left_and_right_padding'),
      bottom: $r('app.integer.video_create_gif_select_gif_time_video_bottom_padding')
    })
  }

  /**
   * 选择时间布局
   */
  @Builder
  private selectGifTime() {
    Stack() {
      Column() {
        VideoThumbListView({
          mVideoThumbOption: this.mVideoThumbOption
        })
        .width($r('app.string.video_create_gif_full_width'))
        .height($r('app.string.video_create_gif_full_width'))
      }
      .padding({
        top: $r('app.integer.video_create_gif_select_gif_time_video_thumb_list_top_padding'),
        left: this.thumbWidth,
        right: this.thumbWidth
      })
      .width($r('app.string.video_create_gif_full_width'))
      .height($r('app.string.video_create_gif_full_width'))

      RangeSeekBarView({
        maxTime: this.maxTime,
        minTime: this.minTime,
        startTime: this.startTime,
        currentStartTime: this.currentStartTime,
        currentEndTime: this.currentEndTime,
        countRange: this.videoThumbCount,
        thumbWidth: this.thumbWidth,
        progress: this.progress,
        rangeSeekBarListener: this.rangeSeekBarListener
      })
        .width($r('app.string.video_create_gif_full_width'))
        .height($r('app.string.video_create_gif_full_width'))
        .onAreaChange((oldValue, newValue) => {
          this.seekBarWidth = newValue.width as number;
          this.seekBarHeight = newValue.height as number;
        })
    }
    .width($r('app.string.video_create_gif_full_width'))
    .height($r('app.integer.video_create_gif_select_gif_time_video_thumb_list_height'))
    .padding({
      left: $r('app.integer.video_create_gif_select_gif_time_video_thumb_list_left_and_right_padding'),
      right: $r('app.integer.video_create_gif_select_gif_time_video_thumb_list_left_and_right_padding'),
      top: $r('app.integer.video_create_gif_select_gif_time_video_thumb_list_top_and_bottom_padding'),
      bottom: $r('app.integer.video_create_gif_select_gif_time_video_thumb_list_top_and_bottom_padding')
    })
  }

  videoPrepared() {
    this.promptText = getContext(this).resourceManager.getStringSync($r('app.string.video_create_gif_select_prompt').id, `${this.maxTime}`, `${this.maxTime}`);

    // 宽高比设置
    if(this.avPlayer) {
      let videoWidth = this.avPlayer.width;
      let videoHeight = this.avPlayer.height;
      this.ratio = videoWidth * (1.0) / videoHeight;
    }

    this.startTruncationTime = this.currentStartTime;
    this.endTruncationTime = this.currentEndTime;
  }

  /**
   * 初始化视频小图列表
   */
  private initThumbList() {
    let videoThumbs = new Array<ThumbContent>();
    for (let i = this.startTime; i < this.endTime; i = i + 1000) {
      let thumbContent = new ThumbContent();
      videoThumbs.push(thumbContent);
    }

    this.videoThumbCount = videoThumbs.length;
    let videoThumbListTopPadding = getContext(this).resourceManager.getNumber($r('app.integer.video_create_gif_select_gif_time_video_thumb_list_top_padding'));

    let callBack: ICallBack = {
      callBackResult: (code: number) => {
        if (code == 0) {
          let count = 0;

          let frameCallBack: IFrameCallBack = {
            callBackResult: async (data: ArrayBuffer, timeUs: number) => {
              const imageSource: image.ImageSource = image.createImageSource(data);

              let videoThumbWidth = vp2px((this.seekBarWidth - 2 * this.thumbWidth) / this.videoThumbCount);
              let videoThumbHeight = vp2px(this.seekBarHeight - videoThumbListTopPadding + 1);

              if (videoThumbWidth / this.videoWidth > videoThumbHeight / this.videoHeight) {
                videoThumbHeight = videoThumbWidth * this.videoHeight / this.videoWidth;
              } else {
                videoThumbWidth = videoThumbHeight * this.videoWidth / this.videoHeight;
              }

              let decodingOptions: image.DecodingOptions = {
                sampleSize: 1,
                editable: true,
                desiredSize: { width: videoThumbWidth, height: videoThumbHeight },
                desiredPixelFormat: image.PixelMapFormat.RGBA_8888
              };

              imageSource.createPixelMap(decodingOptions).then((px: image.PixelMap) => {
                let second = timeUs / 1000000;
                let framePos = count;
                if (second == framePos) {
                  logger.info('second=' + second + ' timeUs=' + timeUs);
                  videoThumbs[second].pixelMap = px;
                  this.updateList(videoThumbs, this.videoThumbCount);
                  count++;
                  imageSource.release();
                } else {
                  logger.info('framePos=' + framePos + ' timeUs=' + timeUs);
                  videoThumbs[framePos].pixelMap = px;
                  this.updateList(videoThumbs, this.videoThumbCount);
                  count++;
                  imageSource.release();
                }

                if (count == this.videoThumbCount) {
                  logger.info("load image finish");
                }
              })
            }
          }
          let startTimeUs = this.startTime * 1000 + '';
          let endTimeUs = this.endTime * 1000 + '';
          MP4Parser.getFrameAtTimeRang(startTimeUs, endTimeUs, MP4Parser.OPTION_CLOSEST, frameCallBack);
        }
      }
    }

    MP4Parser.setDataSource(this.srcFilePath, callBack);
    this.updateList(videoThumbs, this.videoThumbCount);
  }

  /**
   * 更新视频小图列表数据
   * @param videoThumbs
   * @param videoThumbCount
   */
  updateList(videoThumbs: ThumbContent[], videoThumbCount: number) {
    this.mVideoThumbOption = {
      videoThumbWidth: (this.seekBarWidth - 2 * this.thumbWidth) / videoThumbCount,
      videoThumbs: videoThumbs
    }
  }

  /**
   * 跳转到指定的时间播放
   * @param time
   */
  seekTo(time: number) {
    if (this.avPlayer) {
      this.avPlayer.seek(time, media.SeekMode.SEEK_CLOSEST);
    }
  }

}