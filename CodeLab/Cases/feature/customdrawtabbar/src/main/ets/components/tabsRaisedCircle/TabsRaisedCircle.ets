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

import { componentUtils, inspector } from '@kit.ArkUI';
import { TabMenusInterfaceIRequired } from '../../types/TabMenusInterface';
import { getImageUrl } from '../../utils/Functions';
import { ChamferInfo, RaisedSelectImageInfo } from '../../utils/CircleClass';
import { TabsRaisedCircleSelect } from './TabsRaisedCircleSelect';

@Component
export struct TabsRaisedCircle {
  // 当前选中项
  @Link @Watch("getAnimateSelectIndex") selectIndex: number;
  // 用于指控动画的当前选中项
  @State animateSelectIndex: number = 0;
  // Tabs 高度
  @Prop tabHeight: number = 60;
  // 选项数据集合
  @Link tabsMenu: TabMenusInterfaceIRequired[];
  // 背景色
  @Prop tabsBgColor: Color = Color.White;
  // 选中球填充色
  @Prop tabsSelectBgColor: string = "rgba(92, 187, 183,1)";
  // 字体颜色
  @Prop tabsFontColor: Color = Color.Black;
  // 选中时字体颜色
  @Prop tabsSelectFontColor: Color = Color.Black;
  // 凸圆信息
  @State chamfer: ChamferInfo | undefined = undefined;
  // 选中信息
  @State selectImageInfo: RaisedSelectImageInfo | undefined = undefined;
  // tabs id
  @State tabsId: string = 'bugle_tabBar';
  // 选中中间球 -- id
  @State selectBodyId: string = `ball`;
  // 每个选项 id 的前缀
  @State tabItemId: string = `nu_tabItem_${new Date().getTime()}_`;
  // 每个选项中 image 的前缀
  @State selectImageId: string = `nu_tabItemSelectImage_${new Date().getTime()}_`;
  tabsListener: inspector.ComponentObserver | undefined = undefined;
  selectImageListener: inspector.ComponentObserver | undefined = undefined;
  // 动画执行时长
  @State animateTime: number = 1000;

  /**
   * 获取动画控制的下标
   * 用于切换选项时，先让标签回到底部，然后让当前选项在上移
   */
  getAnimateSelectIndex() {
    // 动画等待时间 - 用于等待上一个选项动画结束
    let animateDelay = 500;
    animateTo({
      duration: this.animateTime,
      delay: animateDelay
    }, () => {
      this.animateSelectIndex = this.selectIndex
    })
  }

  /**
   * 计算选中图时图片所需 Y 轴偏移量
   * @returns
   */
  getCountOffsetY() {
    if (this.selectImageInfo && this.chamfer) {
      return this.selectImageInfo.getCenterOffsetY() -
        (this.chamfer.circleRadius - this.chamfer.circleOffsetY)
    }
    return 0
  }

  /**
   * 获取 tabs 尺寸信息
   */
  getChamfer() {
    let onLayoutComplete: () => void = (): void => {
      let modePosition = componentUtils.getRectangleById(this.tabsId)
      if (modePosition.size) {
        this.chamfer = new ChamferInfo(modePosition, this.tabsMenu.length)
        this.tabsListener?.off('draw')
      }
    }
    let FuncDraw = onLayoutComplete;
    this.tabsListener?.on('draw', FuncDraw)
  }

  /**
   * 获取第一个图片的 y 轴偏移量
   */
  getSelectOffsetY() {
    let onLayoutComplete: () => void = (): void => {
      let modePosition = componentUtils.getRectangleById(`${this.selectImageId}0`)
      if (modePosition.size) {
        this.selectImageInfo = new RaisedSelectImageInfo(modePosition);
        this.selectImageListener?.off('draw')
      }
    }
    let FuncDraw = onLayoutComplete;
    this.selectImageListener?.on('draw', FuncDraw)
  }

  aboutToAppear(): void {
    this.tabsListener = inspector.createComponentObserver(this.tabsId)
    this.getChamfer()
    this.selectImageListener = inspector.createComponentObserver(`${this.selectImageId}0`)
    this.getSelectOffsetY()
    this.animateSelectIndex = this.selectIndex;
  }

  build() {
    RelativeContainer() {
      // 每个选项
      ForEach(this.tabsMenu, (item: TabMenusInterfaceIRequired, index: number) => {
        this.TabItem(item, index)
      }, (item: TabMenusInterfaceIRequired, index: number) => JSON.stringify(item.text))
      // 选中时候的 球
      if (this.chamfer) {
        TabsRaisedCircleSelect({
          tabHeight: this.tabHeight,
          selectIndex: this.selectIndex,
          chamfer: this.chamfer,
          selectBodyId: this.selectBodyId,
          tabItemId: this.tabItemId,
          tabsBgColor: this.tabsBgColor,
          tabsSelectBgColor: this.tabsSelectBgColor,
        })
      }
    }
    .width("100%")
    .height(this.tabHeight)
    .backgroundColor(this.tabsBgColor)
    .id(this.tabsId)
  }

  /**
   * 每个选项的样式
   * @param { TabMenusInterfaceIRequired } item - 选项的数据
   * @param { number } index - 下标
   */
  @Builder
  TabItem(item: TabMenusInterfaceIRequired, index: number) {
    Column() {
      if (item.image && this.chamfer) {
        Image(getImageUrl(item as TabMenusInterfaceIRequired, index, this.selectIndex))
          .size({
            width: this.chamfer.circleDiameter / 2,
            height: this.chamfer.circleDiameter / 2
          })
          .interpolation(ImageInterpolation.High)
          .offset({
            y: this.selectIndex === index && this.animateSelectIndex === index ? -(this.getCountOffsetY()) : 0,
          })
          .id(`${this.selectImageId}${index}`)
      }
      Text(item.text)
        .fontColor(this.selectIndex === index ? (item.tabsSelectFontColor || this.tabsSelectFontColor) :
          (item.tabsFontColor || this.tabsFontColor))
    }
    .onClick(() => {
      animateTo({
        duration: this.animateTime,
      }, () => {
        this.selectIndex = index
      })
    })
    .width(100 / this.tabsMenu.length + "%")
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .id(`${this.tabItemId}${index}`)
    .alignRules({
      'left': {
        'anchor': index === 0 ? "__container__" : `${this.tabItemId}${index - 1}`,
        'align': index === 0 ? HorizontalAlign.Start : HorizontalAlign.End
      }
    })
  }
}
