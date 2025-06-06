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

import { SiteItem } from "./SiteItemModel";

/**
 * IDataSource处理数据监听的基本实现
 */
export class SiteListDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private dataList: SiteItem[] = [];
  private initialSiteList: SiteItem[] | undefined = []; // 原数组

  /**
   * 返回原数组
   */
  public getInitalList() {
    let siteListString: string | undefined = AppStorage.get('siteList');
    if (siteListString) {
      let siteListObject: SiteListDataSource | undefined = JSON.parse(siteListString);
      if (siteListObject === undefined) {
        return;
      }
      this.initialSiteList = siteListObject.dataList;
      this.dataList = [];
      this.dataList = this.initialSiteList;
      this.notifyDataReload();
    }
  }

  /**
   * 多重筛选
   * @param changData
   */
  public multiFilter(changData: Array<string>) {
    let siteListString: string | undefined = AppStorage.get('siteList');
    if (siteListString) {
      let siteListObject: SiteListDataSource | undefined = JSON.parse(siteListString);
      if (siteListObject === undefined) {
        return;
      }
      this.initialSiteList = siteListObject.dataList;
      this.dataList = [];
      this.dataList = this.initialSiteList;
      // 筛选数据
      let changDataSet = new Set(changData);
      let dataList: SiteItem[] = this.dataList.filter(item => {
        item.siteBale = item.siteBale.filter(item => {
          if ((item.time && item.type) && (changDataSet.has(item.time)) && (changDataSet.has(item.type))) {
            return item;
          }
          return;
        })
        return item.siteBale;
      })
      dataList = dataList.filter(item => item.siteBale.length !== 0);
      this.dataList = [];
      this.dataList = dataList;
      this.notifyDataReload();
    }
  }

  /**
   * 仅选择停放时间
   * @param changData
   */
  public timeMultiFilter(changData: Array<string>) {
    let siteListString: string | undefined = AppStorage.get('siteList');
    if (siteListString) {
      let siteListObject: SiteListDataSource | undefined = JSON.parse(siteListString);
      if (siteListObject === undefined) {
        return;
      }
      this.initialSiteList = siteListObject.dataList;
      this.dataList = [];
      this.dataList = this.initialSiteList;
      // 筛选数据
      let changDataSet = new Set(changData);
      let dataList: SiteItem[] = this.dataList.filter(item => {
        item.siteBale = item.siteBale.filter(item => {
          if (changDataSet.has(item.time)) {
            return item;
          }
          return;
        })
        return item.siteBale;
      })
      dataList = dataList.filter(item => item.siteBale.length !== 0);
      this.dataList = [];
      this.dataList = dataList;
      this.notifyDataReload();
    }
  }

  /**
   * 仅选择套餐类型
   * @param changData
   */
  public typeMultiFilter(changData: Array<string>) {
    let siteListString: string | undefined = AppStorage.get('siteList');
    if (siteListString) {
      let siteListObject: SiteListDataSource | undefined = JSON.parse(siteListString);
      if (siteListObject === undefined) {
        return;
      }
      this.initialSiteList = siteListObject.dataList;
      this.dataList = [];
      this.dataList = this.initialSiteList;
      // 筛选数据
      let changDataSet = new Set(changData);
      let dataList: SiteItem[] = this.dataList.filter(item => {
        item.siteBale = item.siteBale.filter(item => {
          if (changDataSet.has(item.type)) {
            return item;
          }
          return;
        })
        return item.siteBale;
      })
      dataList = dataList.filter(item => item.siteBale.length !== 0);
      this.dataList = [];
      this.dataList = dataList;
      this.notifyDataReload();
    }
  }

  /**
   * 获取当前数据长度
   * @returns
   */
  public totalCount(): number {
    return this.dataList.length;
  }

  /**
   * 获取索引对应的数据
   * @param index 数组索引
   * @returns
   */
  public getData(index: number): SiteItem {
    return this.dataList[index];
  }

  /**
   * 在指定索引位置增加一个元素
   * @param index
   */
  public addData(index: number, data: SiteItem): void {
    this.dataList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  /**
   * 在数据尾部增加一个元素
   */
  public pushData(data: SiteItem): void {
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
}