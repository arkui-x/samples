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

import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';

// 封装的文件操作工具类
export class FileUtils {
  // 文件路径分隔符
  static readonly SEPARATOR: string = '/';

  /**
   * 获取目录中的文件名列表
   *
   * @param path 文件绝对路径
   */
  static getFilesInDir(path: string) {
    const fileNames = fs.listFileSync(path);
    return fileNames;
  }

  /**
   * 获取文件状态
   *
   * @param path 文件绝对路径
   */
  static getFileStat(path: string): fs.Stat {
    return fs.statSync(path);
  }

  /**
   * 删除文件
   *
   * @param path 文件绝对路径
   */
  static deleteFile(path: string): void {
    fs.unlinkSync(path);
  }

  /**
   * 向path写入数据
   *
   * @param path 文件绝对路径
   * @param content 文件内容
   */
  static writeNewFile(path: string, content: ArrayBuffer | string) {
    let fd = -1;
    fd = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).fd;

    fs.truncateSync(fd);
    fs.writeSync(fd, content);
    fs.fsync(fd).then(() => {
      fs.close(fd).then(() => {
      }).catch((err: BusinessError) => {
        console.error('close file failed with error message: ' + err.message + ', error code: ' + err.code);
      })
    })

  }

  /**
   * 判断path文件是否存在
   *
   * @param path 文件绝对路径
   */
  static exist(path: string): boolean {
    if (fs.accessSync(path)) {
      let stat = fs.statSync(path);
      return stat.isFile();
    } else {
      return false;
    }
  }

  /**
   * 读取路径path的文件
   *
   * @param path 文件绝对路径
   */
  static readFile(path: string): ArrayBuffer {
    let fd = fs.openSync(path, fs.OpenMode.READ_WRITE).fd;
    let size = fs.statSync(path).size;
    let buf = new ArrayBuffer(size);
    fs.readSync(fd, buf);
    return buf;
  }

  /**
   * 判断文件夹是否存在
   *
   * @param path 文件夹绝对路径
   */
  static existFolder(path: string): boolean {
    if (fs.accessSync(path)) {
      let stat = fs.statSync(path);
      return stat.isDirectory();
    } else {
      return false;
    }
  }

  /**
   * 创建文件夹
   *
   * @param path 文件夹绝对路径，只有是权限范围内的路径，可以生成
   */
  static createFolder(path: string) {
    if (!FileUtils.existFolder(path)) {
      let lastInterval = path.lastIndexOf(FileUtils.SEPARATOR);
      if (lastInterval == 0) {
        return;
      }
      let newPath = path.substring(0, lastInterval);
      FileUtils.createFolder(newPath);
      if (!FileUtils.existFolder(path)) {
        fs.mkdirSync(path);
      }
    }
  }
}