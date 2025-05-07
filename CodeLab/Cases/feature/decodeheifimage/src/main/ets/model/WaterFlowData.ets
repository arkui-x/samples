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

import { image } from '@kit.ImageKit';

/**
 * 图片信息类
 */
export class ImageInfo {
  data: image.PixelMap | null = null;
  width: number = 0;
  height: number = 0;
  description: string | undefined = undefined;

  constructor(data: image.PixelMap | null, width: number, height: number, description?: string) {
    this.data = data;
    this.width = width;
    this.height = height;
    this.description = description;
  }
}

// HEIF图片资源链接
export const heifUrls: string[] = [
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/decodeheifimage/src/main/resources/base/media/image1.heic",
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/decodeheifimage/src/main/resources/base/media/image2.heic",
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/decodeheifimage/src/main/resources/base/media/image3.heic",
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/decodeheifimage/src/main/resources/base/media/image4.heic",
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/decodeheifimage/src/main/resources/base/media/image5.heic",
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/decodeheifimage/src/main/resources/base/media/image6.heic",
];

/**
 * 实现IDataSource接口的对象，用于瀑布流组件加载数据
 */
export class WaterFlowDataSource implements IDataSource {
  private dataArray: ImageInfo[] = [];
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): ImageInfo {
    return this.dataArray[index];
  }

  public addData(index: number, data: ImageInfo): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public clearData(): void {
    this.dataArray = [];
    this.notifyDataReload();
  }

  public pushData(data: ImageInfo): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

