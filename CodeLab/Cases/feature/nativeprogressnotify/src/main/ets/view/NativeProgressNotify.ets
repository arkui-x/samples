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

import naitiveprogressnotify from 'libnativeprogressnotify.so';
import { NativeProgressNotifyConstants } from '../constants/NativeProgressNotifyConstants';

/**
 * 功能描述: 本示例介绍如何通过自定义native侧下载方法startDownload将Native的进度信息实时同步到ArkTS侧的功能。
 *
 * 推荐场景: Native侧进度信息需要实时同步到ArkTS侧的场景
 *
 * 核心组件:
 * 1. 自定义native侧下载方法startDownload
 *
 * 实现步骤：
 * 1. 前端进度条使用Progress绘制。
 * 2. JS侧调用Native侧方法，并传入用于接收下载进度的回调函数，在该回调函数中更改状态变量。
 * 3. Naitive侧使用std::thread创建子线程执行模拟下载的任务。
 * 4. Native侧模拟下载的线程中，每100ms执行一次uv_queue_work；向eventloop事件堆栈push异步任务。
 * 5. 在模拟下载任务的子线程中，调用napi_call_function来执行Arkts回调，向Arkts侧传递进度信息。
 */
@Component
export struct NativeProgressNotifyComponent {
  private START_DOWNLOAD: string = "Start Download";
  private DOWNING: string = "Downloading";
  private PROGRESS_START: number = 0;
  private PROGRESS_END: number = 100;
  @State progress: number = 0;
  @State buttonEnabled: boolean = true;
  @State buttonText: string = this.START_DOWNLOAD;

  build() {
    Column({ space: 10 }) {
      // TODO 知识点：进度信息使用Progress组件进行显示
      Progress({ value: this.progress, total: 100, type: ProgressType.Ring })
        .width($r("app.integer.nativeprogressnotify_progress_size"))
        .height($r("app.integer.nativeprogressnotify_progress_size"))
        .animation({ duration: NativeProgressNotifyConstants.PROGRESS_ANIMATION_DURATION, curve: Curve.Ease })
        .style({ strokeWidth: 15 })
      Text(`当前下载进度：${this.progress}%`)
        .id('txtProgress')
      Button(this.buttonText)
        .id('btnProgressNotify')
        .onClick(() => {
          // TODO 知识点：调用native的下载方法，并传入回调函数，在回调函数中接收native侧传递过来的进度信息
          naitiveprogressnotify.startDownload((data: number) => {
            if (data === this.PROGRESS_START || data === this.PROGRESS_END) {
              this.buttonEnabled = true;
              this.buttonText = this.START_DOWNLOAD;
            }
            else {
              if (this.buttonEnabled) {
                this.buttonEnabled = false;
              }
              if (this.buttonText === this.START_DOWNLOAD) {
                this.buttonText = this.DOWNING;
              }
            }
            this.progress = data;
            console.info("[NativeProgressNotify]progress:" + this.progress);
          })
        })
        .enabled(this.buttonEnabled)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
}

