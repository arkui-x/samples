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

import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { ResponseDataType } from './ResponseDataType';
import { MemoryCacheManager } from './MemoryCacheManager';
import { DiskCacheManager } from './DiskCacheManager';
import CryptoJS from "crypto-js"

// 文本资源类型
const textualData: Array<string> = ['js', 'json', 'css', 'html'];

export interface OfflineResourceManagerConfig {
  // 离线包资源路径
  offlinePath?: string,

  // 内存缓存大小
  memoryCacheCapacity?: number,

  // 硬盘缓存大小
  diskCacheCapacity?: number,

  // 磁盘缓存路径
  diskCachePath?: string
}


/**
 * 使用md5生成唯一键值
 *
 * @param url 资源请求url
 */
function transferUrlToKey(url: string): string {
  return CryptoJS.MD5(url).toString()
}

export class OfflineResourceManager {
  // 内存缓存管理器
  public memoryCacheManager: MemoryCacheManager;
  // 磁盘缓存管理器
  public diskCacheManager: DiskCacheManager;
  // 离线包路径
  public offlinePath: string = '';
  // 磁盘缓存路径
  public diskCachePath: string = '';

  constructor(offlineResourceManagerConfig: OfflineResourceManagerConfig) {
    let memoryCacheCapacity = offlineResourceManagerConfig.memoryCacheCapacity ?? 0;
    let diskCacheCapacity = offlineResourceManagerConfig.diskCacheCapacity ?? 0;
    let offlinePath = offlineResourceManagerConfig.offlinePath ?? '';
    this.diskCachePath = offlineResourceManagerConfig.diskCachePath ?? '';
    this.diskCacheManager = new DiskCacheManager(this.diskCachePath, diskCacheCapacity);
    this.memoryCacheManager = new MemoryCacheManager(memoryCacheCapacity);
    this.offlinePath = offlinePath;
  }

  /**
   * 保存数据到内存和磁盘中
   *
   * @param url 资源请求url
   * @param data url对应的响应数据
   */
  submitToCache(url: string, data: ResponseDataType) {
    let key = transferUrlToKey(url);
    this.memoryCacheManager.submitToMemory(key, data);
    this.diskCacheManager.submitToDisk(key, data);
  }

  /**
   * 从内存缓存、磁盘缓存和离线包中取回数据，按照内存缓存、磁盘缓存、离线包顺序依次查找
   * 如果是文本类型资源，需要将数据转化为字符串后返回
   *
   * @param url 资源请求url
   * @param data 请求的数据类型，js、png、css、json等
   */
  fetchFromCache(url: string, type: string): null | ResponseDataType {
    // 防止url过长或者包含非法字符导致意外错误，需要使用算法进行转化，这里使用md5算法
    let key = transferUrlToKey(url);

    // 按照内存缓存、磁盘缓存、离线包顺序依次查找资源
    let res = this.memoryCacheManager.fetchFromMemory(key);
    if (!res) {
      res = this.diskCacheManager.fetchFromDisk(key);
    }
    if (!res && this.offlinePath) {
      let resourceId = url.split('/').pop() as string;
      res = this.fetchFromOfflineResource(resourceId, this.offlinePath);
    }

    // 不存在返回null
    if (!res) {
      return null;
    }

    return res;
  }

  /**
   * 从离线包资源中取回数据
   *
   * @param url 文件名
   * @param filesDir 离线包文件路径
   */
  fetchFromOfflineResource(url: string, filesDir: string): null | ResponseDataType {
    let srcFile = fs.openSync(filesDir + '/' + url, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let stat = fs.statSync(filesDir + '/' + url);
    let bufSize = stat.size;

    // 如果资源不存在，直接返回null
    if (bufSize === 0) {
      return null;
    }
    let readSize = 0;
    let arrayBuffer = new ArrayBuffer(bufSize);
    let readOptions: ReadOptions = {
      offset: readSize,
      length: bufSize
    }
    fs.readSync(srcFile.fd, arrayBuffer, readOptions);
    return arrayBuffer;
  }
}
