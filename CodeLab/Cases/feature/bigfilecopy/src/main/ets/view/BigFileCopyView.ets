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

import { BigFileCopyConstants } from '../constants/BigFileCopyConstants';
import { common } from '@kit.AbilityKit';
import { resourceManager } from '@kit.LocalizationKit';
import fs from '@ohos.file.fs';
const IMAGE_ID:string = 'bigFileImage';


@Extend(Button)
function customButtonStyle() {
  .width(BigFileCopyConstants.COMPONENT_SIZE)
  .fontSize($r("sys.float.ohos_id_text_size_body1"))
  .margin({ top: $r("sys.float.ohos_id_elements_margin_vertical_m") })
}

/**
 * 功能描述：文件拷贝是应用开发中的一个常见场景，本例将展示如何使用buffer来将大文件的rawfile复制到应用沙箱。
 *
 * 推荐场景：需要数据备份的软件，如网盘，文件管理器等
 *
 * 核心组件：
 * 1.BigFileCopyViewComponent
 *
 * 实现步骤：
 * 1. 根据rawfile获得其所在hap包的RawFileDescriptor
 * 2. 根据RawFileDescriptor中的fd、偏移、文件长度，使用buffer进行内容读取
 * 3. 调用图库的预览器对复制的文件进行预览，以验证复制过程的正确性
 */
@Component
export struct BigFileCopyViewComponent {
  @State progress: number = BigFileCopyConstants.PROGRESS_MIN;
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  fileName: string = BigFileCopyConstants.TEST_FILE_NAME;
  targetFilePath: string = "";
  @State isCopyFinished: boolean = false;
  @State isEnableSmooth: boolean = true;
  @State isPreview: boolean = false;

  // TODO 文件复制较为耗时，可放在子线程进行
  copyFile2Sandbox() {
    this.isCopyFinished = false;
    // TODO：知识点：这里获取到的fd并不是目标文件的fd，而是文件所属hap包的fd
    const data: resourceManager.RawFileDescriptor = this.context.resourceManager.getRawFdSync(this.fileName);
    const targetPath: string = this.context.filesDir + "/" + this.fileName;
    const destFile: fs.File = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    let buffSize: number = BigFileCopyConstants.BUFF_SIZE;
    const buffer: ArrayBuffer = new ArrayBuffer(Math.min(buffSize, data.length));
    let off: number = 0; // 记录读取位置的偏移（相较于文件起始偏移）
    let len: number = 0; // 本次读取内容的实际长度
    let readedLen: number = 0; // 记录已读文件长度
    // TODO：知识点：因为获取的是所属hap包的fd，这里需要通过目标文件的大小和偏移进行复制
    while (len = fs.readSync(data.fd, buffer, { offset: data.offset + off, length: buffSize })) {
      readedLen += len;
      fs.writeSync(destFile.fd, buffer, { offset: off, length: len });
      this.progress = Math.floor((readedLen / data.length) * 100); // 小数转换成百分比
      off = off + len;
      if ((data.length - readedLen) < buffSize) {
        buffSize = data.length - readedLen;
      }
    }
    this.targetFilePath = targetPath;
    fs.close(destFile.fd);
    this.isCopyFinished = true;
  }

  setIsPreview(status: boolean): void {
    animateTo({ duration: BigFileCopyConstants.ANIMATION_DURATION, curve: Curve.Friction }, () => {
      this.isPreview = status;
    })
  }

  build() {
    Column() {
      Stack() {
        if (!this.isPreview) {
          Progress({
            value: this.progress,
            total: BigFileCopyConstants.PROGRESS_MAX,
            type: ProgressType.Eclipse
          })
            .size({ width: BigFileCopyConstants.COMPONENT_SIZE, height: BigFileCopyConstants.COMPONENT_SIZE })
            .style({ strokeWidth: $r("app.integer.bigfilecopy_progress_stroke_width"), enableSmoothEffect: this.isEnableSmooth })
        } else {
          // TODO：知识点：Image组件加载沙箱路径需要加前缀 file://
          Image(BigFileCopyConstants.SANDBOX_PREFIX + this.targetFilePath)
            .width(BigFileCopyConstants.COMPONENT_SIZE)
            .height(BigFileCopyConstants.COMPONENT_SIZE)
            .borderRadius($r("sys.float.ohos_id_corner_radius_default_m"))
            .id(IMAGE_ID)
        }
      }

      Text(`当前复制进度：${this.progress}%`)
        .margin({ top: $r("sys.float.ohos_id_elements_margin_vertical_m") })
      Button($r("app.string.bigfilecopy_copy_button_msg"))
        .customButtonStyle()
        .enabled(!this.isCopyFinished)
        .onClick(() => {
          this.copyFile2Sandbox();
        })
      Button($r("app.string.bigfilecopy_reset_button_msg"))
        .customButtonStyle()
        .enabled(this.isCopyFinished)
        .onClick(() => {
          this.progress = BigFileCopyConstants.PROGRESS_MIN;
          this.isCopyFinished = false;
          this.setIsPreview(false);
        })
      Button($r("app.string.bigfilecopy_preview_button_msg"))
        .customButtonStyle()
        .enabled(this.isCopyFinished)
        .onClick(() => {
          this.setIsPreview(true);
        })
    }
    .width($r("app.string.bigfilecopy_full_size"))
    .height($r("app.string.bigfilecopy_full_size"))
    .justifyContent(FlexAlign.Center)
  }
}