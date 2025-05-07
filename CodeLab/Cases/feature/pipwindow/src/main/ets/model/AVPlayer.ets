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

import { audio } from '@kit.AudioKit';
import { media } from '@kit.MediaKit';
import { logger } from '../util/Logger';
import { PipManager } from './PipManager';

// AVPlayer的状态机
enum AVPlayerState {
  IDLE = 'idle',
  INITIALIZED = 'initialized',
  PREPARED = 'prepared',
  PLAYING = 'playing',
  PAUSED = 'paused',
  COMPLETED = 'completed',
  STOPPED = 'stopped',
  RELEASED = 'released',
  ERROR = 'error'
}

/**
 * AVPlayer 类用于处理视频播放相关的逻辑。
 */
@Observed
export class AVPlayer {
  surfaceID: string = ''; // surfaceID用于播放画面显示，具体的值需要通过XComponent接口获取，相关文档链接见上面XComponent创建方法
  isLoadingVideo: boolean = false; // 视频是否加载完成
  private isCreate: boolean = false; // 视频播放器是否被创建
  private callbackComplete: () => void = () => { // 播放至结尾状态回调
  };
  private callbackTimeUpdate: (nol: number) => void = (nol: number) => { // 时间上报函数回调
  };
  private callbackBitrateUpdate: (bitrateList: number[]) => void = (bitrateList: number[]) => { // 比特率更新回调
  };
  private callbackErrorUpdate: (error: string) => void = (error: string) => { // 错误状态回调
  };
  private flag: boolean = false; // 视频是否进入准备状态
  avPlayer: media.AVPlayer = {} as media.AVPlayer; // 视频播放器对象
  currentTime: number = 0; // 视频当前时间
  totalDuration: number = 0; // 视频总时长
  isPlaying: boolean = true; // 是否播放状态
  isLoading: boolean = true; // 是否显示加载动画
  isPiPWindowLoad: boolean = false; // 是否启动画中画
  isPiPWindowRestore: boolean = false; // 画中画从小窗口复原

  /**
   * 初始化AVPlayer
   * @param url 在线视频路径
   * @returns 返回值将在线视频进行绑定
   */
  async init(url: string): Promise<void> {
    await this.release();
    // 创建avPlayer实例对象
    this.avPlayer = await media.createAVPlayer();
    this.isCreate = true;
    // 创建状态机变化回调函数
    await this.setSourceInfo(); // 视频信息上报函数
    await this.setStateChangeCallback(); // 状态机上报回调函数
    this.avPlayer.url = url; // 播放hls网络直播码流
  }

  // 释放AVPlayer资源
  async release() {
    if (this.isCreate) {
      await this.avPlayer.release();
      this.isCreate = false;
      this.isPlaying = false;
    }
  }

  // 播放视频
  getPlay() {
    if (this.isCreate) {
      this.flag = true; // 视频准备完毕
      this.avPlayer.play();
    }
  }

  // 暂停视频
  getPause() {
    if (this.isCreate) {
      this.avPlayer.pause();
    }
  }

  // 结束视频
  getStop() {
    if (this.isCreate) {
      this.avPlayer.stop();
    }
  }

  // 设置媒体播放音量
  changeVolume(volume: number) {
    this.avPlayer.setVolume(volume)
  }

  // TODO 知识点：XComponent和AVPlayer通过surfaceId绑定
  setSurfaceID(): void {
    this.avPlayer.surfaceId = this.surfaceID;
  }

  setCompleteCallback(func: () => void) {
    this.callbackComplete = func;
  }

  setTimeUpdateCallback(func: (nol: number) => void) {
    this.callbackTimeUpdate = func;
  }

  setBitrateUpdateCallback(func: (bitrateList: number[]) => void) {
    this.callbackBitrateUpdate = func;
  }

  setErrorCallback(func: (error: string) => void) {
    this.callbackErrorUpdate = func;
  }

  // 视频信息上报函数
  async setSourceInfo(): Promise<void> {
    // 时间上报函数
    this.avPlayer.on('timeUpdate', (time: number) => {
      logger.info('timeUpdate called: time is :' + time);
      logger.info('timeUpdate called: currentTime is :' + this.avPlayer.currentTime);
      this.callbackTimeUpdate(time);
    });
    // 音量变化回调函数
    this.avPlayer.on('volumeChange', (vol: number) => {
      logger.info('volumeChange success,and new volume is :' + vol);
    });
    // 视频播放结束触发回调
    this.avPlayer.on('endOfStream', () => {
      logger.info('endOfStream success');
    });
    // seek操作回调函数
    this.avPlayer.on('seekDone', (seekDoneTime: number) => {
      logger.info('seekDone success,and seek time is:' + seekDoneTime);
    });
    // 视频总时长上报函数
    this.avPlayer.on('durationUpdate', (duration: number) => {
      logger.info('durationUpdate success,and durationUpdate is:' + duration);
    });
    // 设置倍速播放回调函数
    this.avPlayer.on('speedDone', (speed: number) => {
      logger.info('speedDone success,and speed value is:' + speed);
    });
    // bitrate设置成功回调函数
    this.avPlayer.on('bitrateDone', (bitrate: number) => {
      logger.info('bitrateDone success,and bitrate value is:' + bitrate);
    });
    // 缓冲上报回调函数
    this.avPlayer.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
      logger.info('bufferingUpdate success,and infoType value is:' + infoType + ', value is :' + value);
    });
    // 首帧上报回调函数
    this.avPlayer.on('startRenderFrame', () => {
      logger.info('startRenderFrame success 1');
    });
    // 视频宽高上报回调函数
    this.avPlayer.on('videoSizeChange', (width: number, height: number) => {
      logger.info('videoSizeChange success,and width is:' + width + ', height is :' + height);
    });
    // 焦点上报回调函数
    this.avPlayer.on('audioInterrupt', (info: audio.InterruptEvent) => {
      // 触发焦点上报后调用暂停接口暂停播放
      logger.info('audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info));
    });
    // HLS上报所有支持的比特率
    this.avPlayer.on('availableBitrates', (bitrates: number[]) => {
      logger.info('availableBitrates success,and availableBitrates length is:' + bitrates.length);
      this.callbackBitrateUpdate(bitrates);
    });
    // 设置错误监听
    this.avPlayer.on('error', (error) => {
      logger.error('error happened,message is :' + error.message);
      this.callbackErrorUpdate('Error ' + error.code + ' - ' + error.message);
    });
  }

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    this.avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      logger.info('stateChange callback function is triggered,state is:' + state + ',reason is :' + reason);
      switch (state) {
      // 闲置状态
        case AVPlayerState.IDLE:
          // 调用release接口销毁实例对象
          this.release();
          logger.info('state idle called');
          break;
      // 资源初始化，avplayer设置播放源后触发该状态上报
        case AVPlayerState.INITIALIZED:
          logger.info('state initialized called');
          this.setSurfaceID(); // 设置显示画面，当播放的资源为纯音频时无需设置
          this.avPlayer.prepare(); // 进入准备状态
          break;
      // 已准备状态
        case AVPlayerState.PREPARED:
          logger.info('state prepared called');
          this.avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE; // 避免同时出现两个视频的声音
          this.avPlayer.loop = true; // 设置循环播放
          this.isLoadingVideo = true; // 视频加载完成
          this.isPlaying = true;
          this.totalDuration = this.avPlayer.duration; // 获取视频总长
          this.avPlayer.play();
          break;
      // 正在播放状态
        case AVPlayerState.PLAYING:
          this.flag = true; // 视频准备完毕
          this.isLoading = false; // 取消加载
          logger.info('state playing called');
          break;
      // 暂停状态
        case AVPlayerState.PAUSED:
          logger.info('state paused called');
          break;
      // 播放至结尾状态
        case AVPlayerState.COMPLETED:
          logger.info('state completed called');
          this.callbackComplete();
          break;
      // 停止状态
        case AVPlayerState.STOPPED:
          logger.info('state stopped called');
          break;
      // 销毁状态，销毁与当前AVPlayer关联的播放引擎，无法再进行状态转换
        case AVPlayerState.RELEASED:
          this.isLoadingVideo = false;
          this.isLoading = true;
          logger.info('state released called');
          break;
      // 错误状态，当播放引擎发生不可逆的错误，则会转换至当前状态
        case AVPlayerState.ERROR:
          this.isPlaying = false;
          logger.error('state error called');
          break;
        default:
          logger.info('unknown state :' + state);
          break;
      }
    })
  }
}
