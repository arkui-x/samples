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

import { worker, ThreadWorkerGlobalScope, MessageEvents } from '@kit.ArkTS';
import { fileIo as fs } from '@kit.CoreFileKit';
import { zlib, BusinessError } from '@kit.BasicServicesKit';
import { logger } from '../utils/Logger';

// 绑定Worker对象
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

const TAG: string = 'compressFileWorker';

/**
 * 接收主线程发送的信息，对路径下的文件进行压缩
 * @param 接收信息内容
 */
workerPort.onmessage = (e: MessageEvents): void => {
  logger.info(TAG, `Worker onmessage：${JSON.stringify(e.data)}`);
  const pathDir: string = e.data.pathDir; // 沙箱目录
  const rawfileDirName: string = e.data.beCompressFileDir; // 被压缩文件所在目录名
  // TODO: 知识点: 压缩文件输出路径不能有特殊字符，否则会压缩失败
  // 压缩包输出路径
  const outFilePath: string = `${pathDir}/${e.data.compressZipPath}`;
  // 压缩包输出目录
  const outFileDir: string = outFilePath.slice(0, outFilePath.lastIndexOf('/'));
  // 判断结果输出目录是否存在
  if(!fs.accessSync(outFileDir)){
    fs.mkdirSync(outFileDir);
    logger.info(TAG, 'mkdirSync succeed');
  }

  let options: zlib.Options = {
    level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
    memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
    strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
  };
  try {
    // 对目录下的文件进行压缩
    zlib.compressFile(`${pathDir}/${rawfileDirName}`, outFilePath, options, (errData: BusinessError) => {
      if (errData !== null) {
        logger.error(TAG, `compress failed with error message: ${errData.message}, error code: ${errData.code}`);
      } else {
        logger.info(TAG, 'compress succeed')
        workerPort.postMessage(outFileDir);
      }
    })
  } catch (errData) {
    let code = (errData as BusinessError).code;
    let message = (errData as BusinessError).message;
    logger.error(TAG, `compress errData is error code: ${code}, message: ${message}`);
  }
};