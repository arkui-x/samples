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

import { logger } from '../utils/Logger';
import { GridItemModifier, TranslateItemModifier } from './AttributeModifier';
import { componentUtils } from '@kit.ArkUI';
import { AppInfo } from './AppInfo';

const DELETE_ANIMATION_DURATION: number = 200; // 删除应用动画总时长200ms
const ADD_ANIMATION_DURATION: number = 1000; // 添加应用动画总时长1000ms
const GRID_ITEM_SIZE: number = 72; // gridItem的高度和宽度
const COLUMN_COUNT: number = 5; // 列数
const FIRST_APP_SCREEN_OFFSET_Y = 741; // 首页应用里第一个app相对于屏幕的y轴坐标（px）

export enum DeletionStatus {
  IDLE,
  START,
  FINISH
}

export enum AddStatus {
  IDLE,
  START,
  FINISH
}

/**
 * gridItem删除管理
 */
export class GridItemDeletionCtrl<T> {
  private modifier: GridItemModifier[] = [];
  private gridData: T[] = [];
  private status: DeletionStatus = DeletionStatus.IDLE;

  constructor(data: T[]) {
    this.gridData = data;
    data.forEach(() => {
      this.modifier.push(new GridItemModifier());
    })
  }

  /**
   * 获取当前gridItem的modifier
   * @param item 网格元素
   * @returns 属性对象
   */
  getModifier(item: T): GridItemModifier {
    logger.info(`getModifier start, item：${JSON.stringify(item)}`);
    const index: number = this.gridData.indexOf(item);
    if (index === -1) {
      return new GridItemModifier();
    } else {
      return this.modifier[index];
    }
  }

  /**
   * 删除gridItem
   * @param item 网格元素
   * @param itemAreaWidth 网格区域宽度
   */
  deleteGridItem(item: T, itemAreaWidth: number): void {
    const index: number = this.gridData.indexOf(item);
    animateTo({
      curve: Curve.Friction, duration: DELETE_ANIMATION_DURATION, onFinish: () => {
        // 初始化偏移位置
        this.modifier.forEach((item) => {
          item.offsetX = 0;
          item.offsetY = 0;
        })
        // 删除对应的数据
        this.gridData.splice(index, 1);
        this.modifier.splice(index, 1);
        this.status = DeletionStatus.FINISH;
        // 存储动画状态
        AppStorage.setOrCreate('deletionStatus', this.status);
      }
    }, () => {
      // TODO:知识点:实现删除动画。先让目标元素的opacity为0，不可视，直接删除目标元素会导致偏移的时候位置异常，接着遍历元素的属性对象，修改偏移量。
      this.modifier[index].opacity = 0;
      this.modifier.forEach((item: GridItemModifier, ind: number) => {
        // 最后一条数据不执行偏移
        if (index === this.gridData.length - 1) {
          this.status = DeletionStatus.START;
          return;
        }
        if (ind > index && ind % COLUMN_COUNT !== 0) {
          item.offsetX = -itemAreaWidth;
        } else if (ind > index && ind % COLUMN_COUNT === 0) {
          item.offsetX = itemAreaWidth * 4; // 位置偏移到上一行的最后一列，因此偏移4个gridItem所占的宽度
          item.offsetY = -GRID_ITEM_SIZE;
        }
      })
      this.status = DeletionStatus.START;
    })
  }
}

/**
 * gridItem添加管理
 */
export class GridItemAddCtrl<T> {
  private modifier: TranslateItemModifier[] = [];
  private sortAppData: T[] = [];
  private status: AddStatus = AddStatus.IDLE;

  constructor(data: T[]) {
    this.sortAppData = data;
    data.forEach(() => {
      this.modifier.push(new TranslateItemModifier());
    })
  }

  /**
   * 获取当前gridItem的modifier
   * @param item 网格元素
   * @returns 属性对象
   */
  getModifier(item: T): TranslateItemModifier {
    logger.info(`getModifier start, sortItem：${JSON.stringify(item)}`);
    const index: number = this.sortAppData.indexOf(item);
    logger.info(`getModifier start, sortIndex：${index}`);
    if (index === -1) {
      return new TranslateItemModifier();
    } else {
      return this.modifier[index];
    }
  }

  /**
   * 向首页应用里添加应用的动画
   * @param item 被点击的gridItem
   * @param appInfoList 首页应用里的所有GridItem
   */
  addGridItem(item: T, appInfoList: AppInfo[]): void {
    const index: number = this.sortAppData.indexOf(item);
    const appId: string = (item as AppInfo).name.toString();
    animateTo({
      curve: Curve.ExtremeDeceleration, duration: ADD_ANIMATION_DURATION, onFinish: () => {
        this.modifier[index].attribute?.visibility(Visibility.Hidden);
        // 初始化modifier所有属性
        this.modifier.forEach((item) => {
          item.attribute?.visibility(Visibility.Hidden).translate({ x: 0, y: 0 });
        })
        this.status = AddStatus.FINISH;
        // 存储动画状态
        AppStorage.setOrCreate('addStatus', this.status);
      }
    }, () => {
      let offsetX: number = 0;
      let offsetY: number = 0;
      this.modifier[index].attribute?.visibility(Visibility.Visible);
      // 首页应用里的gridItem个数
      const gridItemNumber: number = appInfoList.length;
      // 首页应用里的gridItem个数除列数的余数
      const homeAppIndex: number = gridItemNumber % COLUMN_COUNT;
      // 被点击应用的坐标信息
      const componentInfo: componentUtils.ComponentInfo = componentUtils.getRectangleById(appId);
      // 余数也是被点击应用移动的终点位置的索引号，两者索引号相减，再乘gridItem本身的宽度，就是横向移动的距离
      offsetX = (homeAppIndex - index) * GRID_ITEM_SIZE;
      // 首页应用里的个数为0
      if (appInfoList.length === 0) {
        // 用首页应用的第一个app的y轴坐标减去被点击应用的y轴坐标即可计算出y轴偏移量
        offsetY = FIRST_APP_SCREEN_OFFSET_Y - componentInfo.screenOffset.y;
        this.modifier[index].attribute?.translate({ x: offsetX, y: px2vp(offsetY) });
        this.status = AddStatus.START;
        return;
      }
      // 首页应用里最后一个gridItem的坐标信息
      const lastAppComponentInfo: componentUtils.ComponentInfo =
        componentUtils.getRectangleById(`${appInfoList[appInfoList.length - 1].name.toString()}InHome`);

      if (homeAppIndex === 0) {
        // 余数等于0，说明gridItem要移动到一行的第一个，y轴移动距离要加上girItem本身的高度
        offsetY = lastAppComponentInfo.screenOffset.y - componentInfo.screenOffset.y + lastAppComponentInfo.size.height;
      } else {
        // 余数不等于0，直接使用两者的y轴坐标相减即可得到移动距离
        offsetY = lastAppComponentInfo.screenOffset.y - componentInfo.screenOffset.y;
      }
      this.modifier[index].attribute?.translate({ x: offsetX, y: px2vp(offsetY) });
      this.status = AddStatus.START;
    })
  }
}