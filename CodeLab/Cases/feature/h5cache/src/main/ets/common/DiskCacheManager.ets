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

import { ResponseDataType } from './ResponseDataType';
import { DiskLruCache } from '../diskLruCache/DiskLruCache';

// 磁盘缓存类型
export type DiskCacheType = DiskLruCache;

// 磁盘管理器
export class DiskCacheManager {
  private cache: DiskCacheType;

  /**
   * 创建磁盘缓存
   *
   * @param diskCachePath 磁盘缓存路径
   * @param diskCacheCapacity 磁盘缓存大小
   */
  constructor(diskCachePath: string, diskCacheCapacity: number) {
    this.cache = new DiskLruCache(diskCachePath, diskCacheCapacity);
  }

  /**
   * 从磁盘中取回数据
   *
   * @param key 键值
   */
  fetchFromDisk(key: string): null | ResponseDataType {
    let res = this.cache.get(key);
    if (!res) {
      return null;
    }
    return res;
  }

  /**
   * 保存数据到磁盘中
   *
   * @param key 键值
   * @param data 数据
   */
  submitToDisk(url: string, data: ResponseDataType) {
    this.cache.set(url, data);
  }
}

