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

// 缓存记录对象
export class DiskCacheEntry {
  // 缓存的key
  private key: string = '';
  // 缓存文件大小
  private size: number = 0;

  constructor(key: string, size?: number) {
    this.key = key;
    this.size = size ?? 0;
  }

  /**
   * 设置缓存文件key值
   *
   * @param key 键值
   */
  setKey(key: string) {
    this.key = key;
  }

  /**
   * 返回缓存文件key值
   */
  getKey(): string {
    return this.key;
  }

  /**
   * 设置缓存文件大小
   *
   * @param size 文件大小
   */
  setSize(size: number) {
    this.size = size;
  }

  /**
   * 返回缓存文件大小
   */
  getSize(): number {
    return this.size;
  }
}