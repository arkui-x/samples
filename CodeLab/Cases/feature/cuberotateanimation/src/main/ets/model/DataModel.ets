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
 * CubeSwiperController 类用于管理立方体轮播组件的数据。
 * 提供了添加、删除、推送和设置数据的方法。
 */
export class CubeSwiperController {

  /**
   * 在指定索引位置插入一个新数据项。
   * @param index - 插入新数据项的位置索引。
   * @param data - 要插入的数据对象。
   */
  addData: (index: number, data: ESObject) => void = () => {};

  /**
   * 删除指定索引位置的数据项。
   * @param index - 要删除的数据项的位置索引。
   */
  deleteData: (index: number) => void = () => {};

  /**
   * 更新指定索引位置的数据项。
   * @param index - 要更新的数据项的位置索引。
   * @param data - 更新的数据对象。
   */
  updateData: (index: number, data: ESObject) => void = () => {};

  /**
   * 向数据集末尾添加一个新的数据项。
   * @param data - 要添加的数据对象。
   */
  pushData: (data: ESObject) => void = () => {};

  /**
   * 设置整个数据集。
   * @param data - 新的数据集数组。
   */
  setData: (data: ESObject[]) => void = () => {};
}


/**
 * 定义功能图标网格项的数据类型。
 * 每个网格项包含一个图标 (icon) 和一个标题 (title)。
 */
export interface MyGridItem {
  icon: Resource
  title: string
}

/**
 * 定义Tab标签项的数据类型。
 * 每个标签项包含一个未选中状态的图标 (icon)、一个选中状态的图标 (selectedIcon) 和一个标题 (title)。
 */
export interface MyTabItem {
  icon: Resource
  selectedIcon: Resource
  title: ResourceStr
}

/**
 * 定义3D立方体旋转动画轮播项的数据类型。
 * 每个轮播项包含一个主标题 (title)、一个副标题 (subTitle) 和一个图像资源 (image)。
 */
export class MySwiperItem {
  title: string;
  subTitle: string;
  image: Resource;

  constructor(title: string, subTitle: string, image: Resource) {
    this.title = title;
    this.subTitle = subTitle;
    this.image = image;
  }
}