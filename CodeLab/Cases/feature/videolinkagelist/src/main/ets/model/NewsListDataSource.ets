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
import { NewsItem } from './NewsItemModel';

/**
 * IDataSource处理数据监听的基本实现
 */
export class NewsListDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private dataList: Array<NewsItem> = [];

  public totalCount(): number {
    return this.dataList.length;
  }

  /**
   * 获取索引对应的数据
   * @param index 数组索引
   * @returns
   */
  public getData(index: number): NewsItem {
    return this.dataList[index];
  }

  /**
   * 在指定索引位置增加一个元素
   * @param index
   */
  public addData(index: number, data: NewsItem): void {
    this.dataList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }
  /**
   * 在数据尾部增加一个元素
   */
  public pushData(data: NewsItem): void {
    this.dataList.push(data);
    this.notifyDataAdd(this.dataList.length - 1);
  }

  /**
   * 清空数据
   */
  public clearData(): void {
    this.dataList = [];
    this.notifyDataReload();
  }

  /**
   * 注册改变数据的控制器
   * @param listener 数据控制器
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  /**
   * 注销改变数据的控制器
   * @param listener 数据控制器
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener)
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  /**
   * 通知控制器数据重新加载
   */
  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    });
  }

  /**
   * 通知控制器数据增加
   * @param index 数组索引
   */
  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataAdd(index);
    })
  }

  /**
   * 通知控制器数据变化
   * @param index 数组索引
   */
  notifyDataChange(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataChange(index);
    })
  }

  /**
   * 通知控制器数据删除
   * @param index 数组索引
   */
  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataDelete(index);
    })
  }

  /**
   * 通知控制器数据位置变化
   * @param from 起始位置
   * @param to 最终位置
   */
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataMove(from, to);
    })
  }
}