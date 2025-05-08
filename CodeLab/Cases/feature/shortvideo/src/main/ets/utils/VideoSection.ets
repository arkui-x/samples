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

import { VideoBuilder } from '../model/DataModel';
import { logger } from './Logger';
import { GlobalStateDialogManager } from 'utils';
import { Constants } from '../constant/Contants';

const TAG: string = 'VideoSection';

@Component
export struct VideoSection {
  // -------------------对外暴露变量-----------------------
  // 短视频数据
  @Prop videoData: VideoBuilder;
  // 是否在切换视频
  @Link changeVideo: boolean;
  // 首视频标志
  @Link firstFlag: boolean;
  // 视频播放状态
  @Link @Watch('playController') playBoo: boolean;
  // 视频下标
  videoItemIndex: number = 0;
  // 当前视频下标
  @Prop @Watch('playVideo') currentVideoIndex: number = -1;

  // --------------------私有属性----------------------------

  // 视频控制器
  controller: VideoController = new VideoController();
  // 初始化控制评论半模态弹窗显示
  @StorageProp('isShowGlobalStateDialog') isShowGlobalStateDialog: boolean = false; // 是否展示全局弹窗

  // 播放短视频
  playVideo() {
    if (this.currentVideoIndex === this.videoItemIndex) {
      this.controller.start();
    }
  }

  // 通过播放按钮控制视频播放
  playController() {
    if(this.playBoo){
      this.controller.start()
    }else{
      this.controller.pause()
    }
  }

  build() {
    Video({
      // 使用Video组件实现播放视频并控制其播放状态
      src: this.videoData.data.video.videoUrl,
      controller: this.controller,
      previewUri: this.videoData.data.video.previewUri
    })
      .width($r('app.string.shortvideo_hundred_percent'))
      .height(this.isShowGlobalStateDialog ? $r('app.string.shortvideo_fifty_percent') :
      $r('app.string.shortvideo_hundred_percent'))
      .animation({ duration: Constants.NUMBER_200 })
      .objectFit(ImageFit.Contain)// 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内
      .loop(true)
      .autoPlay(false)
      .controls(false)// 控制视频播放的控制栏是否显示
      .onPrepared((e) => { // 准备事件回调
        this.videoData.data.video.duration = e.duration;
        if (this.videoItemIndex === 0 && this.firstFlag && !this.changeVideo) {
          this.controller.start();
          this.firstFlag = false;
        }
      })
      .onStart(() => {
        logger.info(TAG, `onStart`);
        if (this.changeVideo) {
          this.changeVideo = !this.changeVideo;
        }
      })
      .onPause(() => {
        logger.info(TAG, `onPause start`);
      })
      .onUpdate((e) => {
        logger.info(TAG, `onUpdate start`);
      })
      .onFinish(() => {
        logger.info(TAG, `onFinish start`);
        this.controller.reset();
      })
      .onError(() => {
        logger.error(TAG, `onError start`);
      })
      .onClick(() => {
        if (this.isShowGlobalStateDialog) {
          GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: false });
          return;
        }
        this.playBoo = false;
      })
  }
}