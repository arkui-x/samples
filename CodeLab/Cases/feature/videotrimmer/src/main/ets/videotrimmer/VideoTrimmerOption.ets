/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import { VideoLoadFramesListener } from './VideoLoadFramesListener';
import { VideoTrimListener } from './VideoTrimListener';

/**
 * 视频剪辑参数选项
 */
@Observed
export class VideoTrimmerOption {
  constructor() {
    this.scaleNum = 100;
    this.video_max_time = 8;
    this.video_min_time = 3;
    this.max_count_range = 8;
    this.thumb_width = 30;
    this.padding_line_height = 10;
  }

  // 源文件路径
  @Track srcFilePath: string = '';
  // 视频剪辑回调接口
  @Track listener: VideoTrimListener = {
    onStartTrim() {
    },
    onFinishTrim(outputFile: string) {
    },
    onCancel() {
    }
  };
  // 视频帧加载回调接口
  @Track loadFrameListener: VideoLoadFramesListener = {
    onStartLoad() {
    },
    onFinishLoad() {
    }
  }
  // 裁剪事件长度 默认值8秒
  @Track video_max_time?: number = 8;
  // 最小剪辑时间
  @Track video_min_time?: number = 3;
  // seekBar的区域内一共有多少张图片
  @Track max_count_range?: number = 8;
  // 裁剪视频预览长方形条状左右边缘宽度
  @Track thumb_width?: number = 30;
  // 裁剪视频预览长方形条状上下边缘高度
  @Track padding_line_height?: number = 10;
  // 当加载帧没有完成，默认的占位图
  @Track framePlaceholder?: PixelMap;
  // 裁剪视频预览长方形条状区域背景颜色
  @Track frameBackground?: string;
  @Track context?: common.UIAbilityContext;
  // 裁剪时压缩比率，100 为1：1，即不压缩
  @Track scaleNum?: number = 100;
}