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

import media from '@ohos.multimedia.media';
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import { CommonConstants, CommonConstants as Const } from '../common/CommonConstants';

// 音频录制
export class AudioRecorder {
  private avRecorder: media.AVRecorder | undefined = undefined;
  public maxAmplitude: number = 0;
  public time: number = 0;
  private avProfile: media.AVRecorderProfile = {
    audioBitrate: Const.AUDIO_BITRATE, // 音频比特率
    audioChannels: Const.AUDIO_CHANNELS, // 音频声道数
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式，当前只支持aac
    audioSampleRate: Const.AUDIO_SAMPLE_RATE, // 音频采样率
    fileFormat: media.ContainerFormatType.CFT_MPEG_4A, // 封装格式，当前只支持m4a
  };
  private avConfig: media.AVRecorderConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC, // 音频输入源，这里设置为麦克风
    profile: this.avProfile,
    url: 'fd://35', // 参考应用文件访问与管理开发示例新建并读写一个文件
  };

  // 注册audioRecorder回调函数
  setAudioRecorderCallback(): void {
    if (this.avRecorder !== undefined) {
      // 状态机变化回调函数
      this.avRecorder.on('stateChange', (state: media.AVRecorderState, _: media.StateChangeReason) => {
        console.log(`AudioRecorder current state is ${state}`);
      })
      // 错误上报回调函数
      this.avRecorder.on('error', (err: BusinessError) => {
        console.error(`AudioRecorder failed, code is ${err.code}, message is ${err.message}`);
      })
    }
  }

  // 开始录制对应的流程
  async startRecordingProcess(): Promise<void> {
    if (this.avRecorder !== undefined) {
      await this.avRecorder.release();
      this.avRecorder = undefined;
    }
    // 1.创建录制实例
    this.avRecorder = await media.createAVRecorder();
    this.setAudioRecorderCallback();
    // 2.获取录制文件fd赋予avConfig里的url；参考FilePicker文档
    const context = getContext(this);
    const path = context.filesDir;
    const filepath = path + '/' + CommonConstants.FILE_NAME;

    const file = fs.openSync(filepath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const fdNumber = file.fd;
    this.avConfig.url = 'fd://' + fdNumber;
    // 3.配置录制参数完成准备工作
    await this.avRecorder.prepare(this.avConfig);
    // 4.开始录制
    await this.avRecorder.start();

    // TODO：知识点：通过getAudioCapturerMaxAmplitude接口获取声音振幅大小。
    this.time = setInterval(() => {
      this.avRecorder!.getAudioCapturerMaxAmplitude((_: BusinessError, amplitude: number) => {
        this.maxAmplitude = amplitude;
      });
    }, Const.COLUMN_HEIGHT);
  }

  // 暂停录制对应的流程
  async pauseRecordingProcess(): Promise<void> {
    if (this.avRecorder !== undefined && this.avRecorder.state === 'started') { // 仅在started状态下调用pause为合理状态切换
      await this.avRecorder.pause();
    }
  }

  // 恢复录制对应的流程
  async resumeRecordingProcess(): Promise<void> {
    if (this.avRecorder !== undefined && this.avRecorder.state === 'paused') { // 仅在paused状态下调用resume为合理状态切换
      await this.avRecorder.resume();
    }
  }

  // 停止录制对应的流程
  async stopRecordingProcess(): Promise<void> {
    if (this.avRecorder !== undefined) {
      // 1. 停止录制
      if (this.avRecorder.state === 'started'
        || this.avRecorder.state === 'paused') { // 仅在started或者paused状态下调用stop为合理状态切换
        await this.avRecorder.stop();
        clearInterval(this.time);
      }
      // 2.重置
      await this.avRecorder.reset();
      // 3.释放录制实例
      await this.avRecorder.release();
      this.avRecorder = undefined;
    }
  }
}