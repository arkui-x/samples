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

import { GroupAvatarModel, PersonData } from '../datasource/GroupAvatarModel';
import { SnapShotModel } from '../model/SnapShotModel';
import { image } from '@kit.ImageKit';

/**
 * 功能描述：点击完成之后，将选定的用户头像进行拼接，最终合成一个图片进行渲染。
 *
 * 实现原理：
 *   绘制组件
 *    1)使用divideImage2Group函数分割选择的用户头像数据，生成二维数组，已达到群头像排列方式，并设置图片宽高
 *    2)结合二位数组，嵌套2层ForEach组件实现纵向与横向的线性布局，绘制群头像
 *    3)设置id与visibility属性，用于隐藏组件及后续的组件截图
 *
 * @param {PersonData} imageArr - 已选择的联系人头像
 * @param {SnapShotModel | null} snapShotModel - 组件截图属性类
 */
@Component
export struct ImageCombination {
  // ---------------对外暴露变量-----------------
  // 已选择的联系人头像
  imageArr: (ResourceStr | image.PixelMap)[] = [];
  // 组件截图属性类
  snapShotModel: SnapShotModel | null = null;

  aboutToAppear(): void {
    if (!this.snapShotModel) {
      this.snapShotModel = new SnapShotModel();
    }
  }

  build() {
    // 绘制组件，用于绘制群组头像
    Column({ space: 2 }) {
      ForEach(divideImage2Group(this.imageArr), (item: GroupAvatarModel[]) => {
        RowComponent(item)
      })
    }
    // 设置组件ID，用于进行组件截图
    .id(this.snapShotModel?.getComponentId())
    .width($r('app.integer.group_avatar_custom_loading_drawing_size'))
    .height($r('app.integer.group_avatar_custom_loading_drawing_size'))
    .justifyContent(FlexAlign.Center)
    // 设置组件隐藏
    .visibility(Visibility.Hidden)
  }
}

/**
 * 群组头像横向列表组件
 * @param imageArray
 */
@Builder
function RowComponent(imageArray: GroupAvatarModel[]) {
  Row({ space: 2 }) {
    ForEach(imageArray, (item: GroupAvatarModel) => {
      Image(item.src)
        .height(item.height)
        .width(item.width)
    })
  }
  .width($r('app.integer.group_avatar_custom_loading_drawing_size'))
  .justifyContent(FlexAlign.Center)
}

/**
 * 将选择的头像列表组装为二位数组，用于填充九宫格组件
 * @param images
 * @returns
 */
function divideImage2Group(personGroup: (ResourceStr | image.PixelMap)[]): GroupAvatarModel[][] {
  let imageGroup: GroupAvatarModel[][] = [];
  if (personGroup.length <= 4) {
    // 人数少于等于4时，显示两行两列
    imageGroup = divideGroupBySize(personGroup, 2);
  } else if (personGroup.length <= 9) {
    // 人数大于4时，显示三行三列
    imageGroup = divideGroupBySize(personGroup, 3);
  } else {
    // 人数大于9时，仅显示前9个头像
    imageGroup = divideGroupBySize(personGroup.slice(0, 9), 3);
  }
  return imageGroup;
}

/**
 * 根据群组数量判断排列方式
 *  当群成员人数大于4人，则成员头像为整体区域的1/3，按照九宫格排列
 *  当群成员人数小于等于5人，则成员头像为整体区域的1/2，按照四宫格排列
 * @param images
 * @param rowSize
 * @returns
 */
function divideGroupBySize(personData: (ResourceStr | image.PixelMap)[], rowSize: number): GroupAvatarModel[][] {
  const imageCount: number = personData.length;
  const imageGroup: GroupAvatarModel[][] = [];
  let imageWidth: number = 0;
  let imageHeight: number = 0;
  let rowCount: number = 0;
  let firstRowCount: number = 0;

  // 设置群成员头像大小与排列方式
  if (rowSize === 2) {
    imageWidth = 30;
    imageHeight = 30;
    rowCount = Math.floor(imageCount / 2);
    firstRowCount = imageCount % 2;
  } else if (rowSize === 3) {
    imageWidth = 20;
    imageHeight = 20;
    rowCount = Math.floor(imageCount / 3);
    firstRowCount = imageCount % 3;
  }

  // 组装第一组图片数据
  const firstRowGroup: GroupAvatarModel[] = [];
  for (let i = 0; i < firstRowCount; i++) {
    firstRowGroup.push({
      src: personData[i],
      width: imageWidth,
      height: imageHeight
    });
  }
  // 当取余为0时，不需要单独设置首行组件
  if (firstRowGroup.length > 0) {
    imageGroup.push(firstRowGroup);
  }

  // 根据排列方式与非首行数，组装剩余的图片数据
  for (let i = 0; i < rowCount; i++) {
    const fullRowImages: (ResourceStr | image.PixelMap)[] =
      personData.slice(firstRowCount + i * rowSize, firstRowCount + (i + 1) * rowSize);
    const fullRowGroup: GroupAvatarModel[] = [];
    fullRowImages.forEach((img:ResourceStr | image.PixelMap) => {
      fullRowGroup.push({
        src: img,
        width: imageWidth,
        height: imageHeight
      });
    });
    imageGroup.push(fullRowGroup);
  }
  return imageGroup;
}