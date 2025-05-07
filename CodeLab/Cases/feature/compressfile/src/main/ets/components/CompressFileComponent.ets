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

import { worker, MessageEvents } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { promptAction } from '@kit.ArkUI';
import { logger } from '../utils/Logger';

const TAG: string = 'compressFileComponent';

/**
 * 功能描述：
 * 1. 点击压缩按钮，指定目录下的文件会被压缩，压缩成功后，会显示压缩包名字
 *
 * 实现原理：
 * 1. 通过initCompressFile函数将rawfile下指定目录的待压缩文件写入到应用沙箱路径中
 * 2. 在Button的onClick回调中向worker子线程发送应用沙箱路径和待压缩文件所在目录
 *
 * @param { string } compressBundleName - 压缩成功后压缩包的名字
 * @param { string } compressZipPath - 压缩成功后压缩包路径
 * @param { string } beCompressFileDir - 待压缩文件所在目录名
 */
@Component
export struct CompressFileComponent {
  // -------------------对外暴露变量-----------------------
  // 压缩成功后压缩包的名字
  @Link compressBundleName: string;
  // 压缩成功后压缩包路径
  compressZipPath: string = '';
  // 待压缩文件所在目录名
  beCompressFileDir: string = '';
  // --------------------私有属性----------------------------
  private rawfilePath: string = ''; // rawfile被压缩文件的应用沙箱路径
  private context: Context = getContext(this);
  @State pathDir: string = ''; // 应用沙箱目录
  @State outFileDir: string = ''; // 压缩后的文件所处的应用沙箱目录
  @State beCompressFiles: Array<string> = []; // rawfile下指定目录所有待压缩文件名字

  aboutToAppear(): void {
    this.initCompressFile(this.beCompressFileDir);
  }

  /**
   * 向worker线程发送信息，进行压缩
   * @returns
   */
  compressByWorker(): void {
    /**
     * TODO：知识点：主线程中使用new worker.ThreadWorker创建Worker对象。
     * TODO：知识点：相对路径加载形式，加载路径规则：{relativePath}。
     */
    let workerInstance: worker.ThreadWorker = new worker.ThreadWorker('../worker/Worker.ets');
    // TODO：知识点：主线程使用postMessage()向worker线程发送消息。
    // 主线程使用postMessage()向worker线程发送应用沙箱路径，压缩包路径和被压缩文件所在目录。
    workerInstance.postMessage({
      pathDir: this.pathDir,
      compressZipPath: this.compressZipPath,
      beCompressFileDir: this.beCompressFileDir
    });

    // 主线程接收worker线程发送的压缩结果所在路径
    workerInstance.onmessage = (e: MessageEvents): void => {
      if (e.data) {
        promptAction.showToast({
          message: $r('app.string.compress_file_compress_success_tips')
        });
        logger.info(TAG, `compressed Files outFileDir: ${e.data}`);
        this.listCompressBundle(e.data);
      } else {
        logger.error(TAG, 'compress Files failed!');
      }
      // TODO：知识点：主线程使用terminate()销毁Worker线程。
      workerInstance.terminate();
    }
  }

  /**
   * 读取压缩包输出目录下压缩包
   * @param outDir 压缩包输出目录
   * @returns
   */
  listCompressBundle(outDir: string) {
    fs.listFile(outDir).then((fileNames: Array<string>) => {
      this.compressBundleName = fileNames[0];
    }).catch((err: BusinessError) => {
      logger.error(TAG, `list file failed with error message: ${err.message}, error code: ${err.code}`)
    })
  }

  /**
   * 将待压缩文件写入到应用沙箱目录
   * @param compressZipName 待压缩文件所处路径
   * @returns
   */
  initCompressFile(beCompressFileDir: string): void {
    //获取rawfile下的所有待压缩文件名
    this.beCompressFiles = this.context.resourceManager.getRawFileListSync(beCompressFileDir);
    this.beCompressFiles.forEach((fileName: string) => {
      this.context.resourceManager.getRawFileContent(`${beCompressFileDir}/${fileName}`,
        (error: BusinessError, value: Uint8Array) => {
          if (error !== undefined) {
            logger.error(TAG, `getRawFileContent failed, error message: ${error.message}, error code: ${error.code}`);
          } else {
            const rawFile: Uint8Array = value;
            this.pathDir = this.context.filesDir; // 获取应用沙箱目录
            this.rawfilePath = `${this.pathDir}/${beCompressFileDir}`; // 设置rawfile压缩文件的应用沙箱路径
            if (!fs.accessSync(this.rawfilePath)) {
              fs.mkdirSync(this.rawfilePath);
            }
            // 在指定路径以同步方法打开或创建文件
            const file = fs.openSync(`${this.rawfilePath}/${fileName}`,
              fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
            // 使用fs.write接口将字节数组形式的rawfile的文件内容写入到指定沙箱路径filePath中
            fs.write(file.fd, rawFile.buffer).then((writeLen: number) => {
              logger.info(TAG, `write data to file succeed and size is: ${writeLen}`);
            }).catch((err: BusinessError) => {
              logger.error(TAG,
                `write data to file failed with error message: ${err.message}, error code: ${err.code}`);
            }).finally(() => {
              logger.info(TAG, 'write finished');
              fs.closeSync(file); // 以同步方法关闭文件。
            });
          }
        });
    })
  }

  build() {
    Column() {
      Button($r('app.string.compress_file_compress_button_message'))
        .width($r('app.string.compress_file_compress_button_width'))
        .height($r('app.string.compress_file_compress_button_height'))
        .id('compressButton')
        .onClick(() => {
          this.compressByWorker();
        })
    }
  }
}