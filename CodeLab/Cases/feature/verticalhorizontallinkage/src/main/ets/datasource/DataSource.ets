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
 * 实现IDataSource接口的对象，用于List加载数据
 * 数据类型不固定，使用泛型
 */
export class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  /**
   * 存储数据
   * @param data
   */
  public setData(data: T[]) {
    this.originDataArray = data;
  }

  /**
   * 获取索引对应的数据
   * @param index 数组索引
   * @returns
   */
  public getData(index: number): T {
    return this.originDataArray[index];
  }

  /**
   * 获取所有数据
   * @returns
   */
  public getAllData(): T[] {
    return this.originDataArray;
  }

  /**
   * 获取数据总数
   * @returns
   */
  public totalCount(): number {
    return this.originDataArray.length;
  }

  /**
   * 通过索引添加数据
   * @param index 索引号
   * @param data
   */
  public addData(index: number, data: T): void {
    this.originDataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 增加数据
   * @param data
   */
  public pushData(data: T): void {
    this.originDataArray.push(data);
    this.notifyDataAdd(this.originDataArray.length - 1);
  }

  /**
   * 注册改变数据的控制器
   * @param listener 数据控制器
   */
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  /**
   * 注销改变数据的控制器
   * @param listener 数据控制器
   */
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  /**
   * 通知控制器数据位置变化
   */
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  /**
   * 通知控制器数据增加
   * @param index 数组索引
   */
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  /**
   * 通知控制器数据变化
   * @param index 数组索引
   */
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  /**
   * 通知控制器数据删除
   * @param index 数组索引
   */
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  /**
   * 通知控制器数据位置变化
   * @param from 起始位置
   * @param to 最终位置
   */
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}
