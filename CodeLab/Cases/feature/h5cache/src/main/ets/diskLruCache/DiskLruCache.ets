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
import { DiskCacheEntry } from './DiskCacheEntry';
import { FileUtils } from './FileUtils';

const DEFAULT_MAX_SIZE = 300 * 1024 * 1024;

export class DiskLruCache {
  // 缓存数据最大值
  private maxSize: number = 300 * 1024 * 1024;
  // 缓存文件路径地址
  private path: string = '';
  // 当前缓存数据值
  private size: number = 0;
  // 缓存数据集合
  private cacheMap: Map<string, DiskCacheEntry> = new Map<string, DiskCacheEntry>();

  constructor(path: string, maxSize?: number) {
    this.path = path;
    this.maxSize = maxSize ?? DEFAULT_MAX_SIZE;
    // 注意点，DiskLruCache需要初始化状态，记录已存在的缓存文件
    this.initStatus();
  }

  /**
   * 初始化状态，
   * 如果不存在缓存路径，则创建
   * 如果已经存在缓存路径，则需要重新设置状态
   */
  initStatus() {
    // 如果不存在缓存文件夹，创建
    if (!FileUtils.existFolder(this.path)) {
      FileUtils.createFolder(this.path);
      return;
    }

    // 缓存文件路径内的缓存文件目录数组
    let fileNameArr: Array<string> = FileUtils.getFilesInDir(this.path);
    // 缓存文件路径内的文件Stat数组
    let fileStatArr: Array<fs.Stat> = [];
    // 文件ino和文件名映射字典
    let inoToNameMap: Map<bigint, string> = new Map();

    // 遍历缓存文件，获取Stat，完成fileStatArr初始化
    fileNameArr.forEach((fileName): void => {
      let stat: fs.Stat = FileUtils.getFileStat(`${this.path}/${fileName}`);
      inoToNameMap.set(stat.ino, fileName);
      fileStatArr.push(stat);
    })

    // 按修改时间排序fileStatArr
    fileStatArr.sort((stat1, stat2): number => {
      return stat1.mtime - stat2.mtime;
    })

    // 遍历fileStatArr，计算已有的缓存文件大小，同时缓存文件的生成时间顺序设置cacheMap
    this.size = fileStatArr.reduce<number>((cacheSize: number, stat: fs.Stat): number => {
      // 按时间顺序设置cacheMap
      let filename = inoToNameMap.get(stat.ino) as string;
      let diskCacheEntry: DiskCacheEntry = new DiskCacheEntry(filename, stat.size);
      this.cacheMap.set(filename, diskCacheEntry);

      // 累加缓存文件大小
      return cacheSize + stat.size;
    }, 0)
  }

  /**
   * 存储disk缓存数据
   *
   * @param key 键值
   * @param content 文件内容
   */
  set(key: string, content: ArrayBuffer | string) {
    let fileSize: number = 0;

    if (content instanceof ArrayBuffer) {
      fileSize = content.byteLength;
    } else {
      fileSize = content.length;
    }

    if (fileSize > this.maxSize) {
      return;
    }

    this.size = this.size + fileSize;
    // 文件记录存到缓存数据集合中
    this.putCacheMap(key, fileSize);
    // 删除多余缓存数据
    this.trimToSize();
    let tempPath = this.path + '/' + key;
    FileUtils.writeNewFile(tempPath, content);
  }

  /**
   * 缓存数据map集合
   *
   * @param key 键值
   * @param size 缓存文件大小
   */
  putCacheMap(key: string, size: number = 0) {
    this.cacheMap.set(key, new DiskCacheEntry(key, size));
  }

  /**
   * 根据LRU算法删除多余缓存数据
   */
  trimToSize() {
    while (this.size > this.maxSize) {
      // 获取cacheMap中最先设置的key
      let firstKey: string = this.cacheMap.keys().next().value;

      // 获取文件大小
      let fileSize = (this.cacheMap.get(firstKey) as DiskCacheEntry).getSize();

      // 更新当前磁盘缓存大小
      if (fileSize > 0) {
        this.size = this.size - fileSize;
      }

      // 删除磁盘文件
      FileUtils.deleteFile(`${this.path}/${firstKey}`);
      this.cacheMap.delete(firstKey);
    }
  }

  /**
   * 获取key缓存数据
   *
   * @param key 键值
   */
  get(key: string): ArrayBuffer | null {
    let path = this.path + '/' + key;
    if (FileUtils.exist(path)) {
      let content: ArrayBuffer = FileUtils.readFile(path);
      // 重新设置key，更新key的设置时间
      this.putCacheMap(key, content.byteLength);
      return content;
    } else {
      return null;
    }
  }
}