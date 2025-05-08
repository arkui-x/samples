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

import { util } from '@kit.ArkTS';
import { ResponseDataType } from './ResponseDataType';

// 内存缓存类型
export type MemoryCacheType = util.LRUCache<string, ResponseDataType>;

// 内存缓存管理器
export class MemoryCacheManager {
  private cache: MemoryCacheType;

  /**
   * 创建内存缓存管理
   *
   * @param memoryCacheCapacity 内存缓存大小
   */
  constructor(memoryCacheCapacity: number = 64) {
    this.cache = new util.LRUCache(memoryCacheCapacity);
  }

  /**
   * 从内存中取回数据，如果数据不存在，返回null
   *
   * @param key 键值
   */
  fetchFromMemory(key: string): null | ResponseDataType {
    let res = this.cache.get(key);
    if (!res) {
      return null;
    }
    return res;
  }

  /**
   * 保存数据到内存中
   *
   * @param key 键值
   * @param data 数据
   */
  submitToMemory(key: string, data: ResponseDataType) {
    this.cache.put(key, data);
  }
}