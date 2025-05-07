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

import { webview } from '@kit.ArkWeb';
import { logger } from '../utils/logger';

const START_VALUE: number = 0; // 指定当前进度值，初始化开始位置为0
const TOTAL_VALUE: number = 100; // 指定进度总长，进度条总长度为100

@Component
export struct RemotePPTViewer {
  @State remoteProgressValue: number = 0; // 设置加载网络进度，进度条初始值为0
  @State isHiddenRemoteProgress: Boolean = true; // 记录加载网络进度条显隐，进入页面默认加载
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Stack() {
        if (this.isHiddenRemoteProgress) {
          Progress({ value: START_VALUE, total: TOTAL_VALUE, type: ProgressType.Linear })
            .width($r("app.string.web_pdf_viewer_progress_width"))
            .height($r("app.integer.web_pdf_viewer_progress_height"))
            .value(this.remoteProgressValue)
            .color(Color.Green)
        }
      }

      // TODO: 知识点：基于微软的office web viewer实现网络office文件的预览效果
      Web({
        src: $rawfile(`web_ppt.html`),
        controller: this.controller
      })
        .onProgressChange((event) => {
          if (event) {
            this.remoteProgressValue = event.newProgress;
            if (this.remoteProgressValue >= TOTAL_VALUE) {
              this.isHiddenRemoteProgress = false;
            }
          }
        })
        .onErrorReceive((event) => {
          if (event) {
            logger.error(`remote excel error message: ${event.error.getErrorInfo()}`)
          }
        })
    }
  }

}