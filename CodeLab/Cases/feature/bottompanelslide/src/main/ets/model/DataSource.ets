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

/**
 * 代表自定义类
 *
 * @class
 * @property {string} desc - 视频名称描述
 * @property {string} author - 作者名称
 * @property {string} including - 包含内容
 */
export class VideoDataType {
  desc: string = '';
  author: string = '';

  constructor(desc: string, author: string) {
    this.desc = desc;
    this.author = author;
  }
}

export class PanelDataType {
  desc: string = '';
  including: string = '';

  constructor(desc: string, include: string) {
    this.desc = desc;
    this.including = include;
  }
}

/**
 * Basic implementation of IDataSource to handle data listener
 * @implements {IDataSource}
 */
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: VideoDataType[] | PanelDataType[] = [];

  /**
   * 获取数组长度。
   * @returns {number} 返回数组长度
   */
  public totalCount(): number {
    return 0;
  }

  /**
   * 获取指定索引数据。
   * @param {number} index - 索引值
   * @returns {CustomDataType} 返回指定索引数据
   */
  public getData(index: number): VideoDataType | PanelDataType {
    return this.originDataArray[index];
  }

  /**
   * 为LazyForEach组件向其数据源处添加listener监听
   * @param {DataChangeListener} listener - 监听对象
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  /**
   * 为对应的LazyForEach组件在数据源处去除listener监听
   * @param {DataChangeListener} listener - 监听对象
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  /**
   * 通知LazyForEach组件需要在index对应索引处添加子组件
   * @param {number} index - 索引值
   */
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  /**
   * 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
   * @param {number} index - 索引值
   */
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  /**
   * 通知LazyForEach组件需要在index对应索引处删除该子组件
   * @param {number} index - 索引值
   */
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  /**
   * 通知LazyForEach组件将from索引和to索引处的子组件进行交换
   * @param {number} from - 起始值
   * @param {number} to - 终点值
   */
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

/**
 * 继承自BasicDataSource的子类，重写了方法
 * @class MyDataSource
 * @extends {BasicDataSource}
 */
export class VideoDataSource extends BasicDataSource {
  private dataArray: VideoDataType[] = [];

  /**
   * 获取数组长度
   * @returns {number} 返回数组长度
   */
  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * 获取指定索引数据
   * @param {number} index - 索引值
   * @returns {VideoDataType} 返回指定索引数据
   */
  public getData(index: number): VideoDataType {
    return this.dataArray[index];
  }

  /**
   * 改变单个数据
   * @param {number} index - 索引值
   * @param {VideoDataType} data - 修改后的值
   */
  public addData(index: number, data: VideoDataType): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据
   * @param {VideoDataType} data - 需要添加的数据
   */
  public pushData(data: VideoDataType | VideoDataType[]): void {
    if (Array.isArray(data)) {
      this.dataArray.push(...data);
    } else {
      this.dataArray.push(data);
    }
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}

/**
 * 继承自BasicDataSource的子类，重写了方法
 * @class SecondDataSource
 * @extends {BasicDataSource}
 */
export class PanelDataSource extends BasicDataSource {
  private dataArray: PanelDataType[] = [];

  /**
   * 获取数组长度
   * @returns {number} 返回数组长度
   */
  public totalCount(): number {
    return this.dataArray.length;
  }

  /**
   * 获取指定索引数据
   * @param {number} index - 索引值
   * @returns {PanelDataType} 返回指定索引数据
   */
  public getData(index: number): PanelDataType {
    return this.dataArray[index];
  }

  /**
   * 改变单个数据
   * @param {number} index - 索引值
   * @param {PanelDataType} data - 修改后的值
   */
  public addData(index: number, data: PanelDataType): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 添加数据
   * @param {PanelDataType} data - 需要添加的数据
   */
  public pushData(data: PanelDataType | PanelDataType[]): void {
    if (Array.isArray(data)) {
      this.dataArray.push(...data);
    } else {
      this.dataArray.push(data);
    }
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
