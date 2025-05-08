/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 * Basic implementation of IDataSource to handle data listener
 * @implements {IDataSource}
 */
export class SwiperDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: ESObject[] = [];

  /**
   * 获取数组长度
   */
  public totalCount(): number {
    return this.originDataArray.length;
  }

  /**
   * 获取索引对应的数据
   * @param index 数组索引
   */
  public getData(index: number): ESObject {
    return this.originDataArray[index];
  }

  /**
   * 在指定索引位置增加一个元素
   * @param index 数组索引
   * @param data 元素对象
   */
  public addData(index: number, data: ESObject): void {
    this.originDataArray.splice(index, 0, data);
    this.notifyDataReload();
  }

  /**
   * 在指定索引位置移除一个元素
   */
  public deleteData(index: number): void {
    this.originDataArray.splice(index, 1);
    this.notifyDataReload();
  }

  /**
   * 更新指定索引位置的元素
   * @param index 数组索引
   */
  public updateData(index: number, data: ESObject): void {
    this.originDataArray.splice(index, 1, data);
    this.notifyDataChange(index);
  }

  /**
   * 设置数据
   * @param data 新数据集
   */
  public setData(data: ESObject[]): void {
    this.originDataArray = data;
    this.notifyDataReload();
  }

  /**
   * 在数据尾部增加一个元素
   * @param data 元素对象
   */
  public pushData(data: ESObject): void {
    this.originDataArray.push(data);
    this.notifyDataAdd(this.originDataArray.length - 1);
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