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

// subWeb入参类型
export interface IWebParams {
  // 网页url
  url: ResourceStr,

  // 网页title
  title?: string,

  // 内存缓存大小
  memoryCacheCapacity?: number,

  // 硬盘缓存大小
  diskCacheCapacity?: number,

  // 需要缓存的资源url数组，例如js、json、图片、css
  cacheableResourceUrls?: Array<string>,

  // 磁盘缓存路径
  diskCachePath?: string
}