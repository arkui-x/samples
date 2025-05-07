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
 * 功能描述: 提供3D立方体旋转轮播组件，能够在用户滑动时展示生动的3D立方体旋转过渡效果。支持自定义轮播内容，并且可以通过参数自定义动画行为，例如调整动画速度、自动播放等。
 * 支持通过控制器对象动态更新轮播数据，包括添加、删除、替换等操作。
 *
 * 实现原理：
 * 1. 使用Swiper组件作为基础容器，结合LazyForEach实现轮播项的渲染。
 * 2. 通过customContentTransition属性自定义页面切换动画，实现3D立方体旋转效果。
 * 3. 在transition回调中，根据滑动距离比例计算当前页和滑入页的旋转角度和旋转中心点，实现平滑的3D旋转效果。
 * 4. 使用Stack组件包装轮播内容，通过rotate属性应用3D变换。
 * 5. 支持通过BuilderParam自定义轮播项的内容和样式。
 * 6. 提供自动播放、循环播放等基础轮播功能。
 * 7. 通过控制器对象暴露数据操作方法，支持动态更新轮播内容。
 *
 * @param {ESObject[]} items - 轮播数据，必选参数。
 * @param {CubeSwiperController} cubeSwiperController - 组件控制器，用于动态更新数据。
 * @param {(item: ESObject) => void} swiperItemSlotParam - 轮播项内容，必选参数。
 * @param {number} [duration] - 动画持续时间，可选参数，默认500ms。
 * @param {boolean} [autoPlay] - 是否自动播放，可选参数，默认true。
 * @param {boolean} [loop] - 是否循环播放，可选参数，默认true。
 */

import { RectShape } from '@kit.ArkUI';
import { IMAGES } from '../mock/MockData';
import { SwiperDataSource } from '../model/BasicDataSource';
import { CubeSwiperController } from '../model/DataModel';

@Component
export struct CubeRotateAnimationSwiper {
  // -------------------对外暴露变量-----------------------
  duration: number = 500; // 动画持续时间，默认500ms
  autoPlay: boolean = true; // 是否自动播放
  loop: boolean = true; // 是否循环播放
  // 轮播数据
  items: ESObject[] = [];
  swiperData: SwiperDataSource = new SwiperDataSource();
  // 轮播页插槽参数
  @BuilderParam swiperItemSlotParam: (item: ESObject) => void;
  // 组件控制器对象
  cubeSwiperController?: CubeSwiperController;
  // --------------------私有属性----------------------------
  @State currentIndex: number = 0; // 当前项下标
  @State angleList: number[] = []; // 旋转角度列表
  @State centerXList: Array<number | string> = []; // 旋转中心点列表
  private swiperController: SwiperController = new SwiperController(); // 轮播控制器

  aboutToAppear(): void {
    // 校验父组件是否传入合法的items和swiperItemSlotParam，不合法进行初始化
    if (this.items.length === 0 || this.swiperItemSlotParam === undefined) {
      this.items = IMAGES;
      this.swiperItemSlotParam = this.defaultSwiperItem;
    }
    this.swiperData.setData(this.items);
    this.resetAnimationAttr();
    if (this.cubeSwiperController) {
      this.cubeSwiperController.addData = this.addData;
      this.cubeSwiperController.deleteData = this.deleteData;
      this.cubeSwiperController.pushData = this.pushData;
      this.cubeSwiperController.updateData = this.updateData;
      this.cubeSwiperController.setData = this.setData;
    }
  }

  /**
   * 重置动画属性。
   */
  resetAnimationAttr() {
    this.angleList = new Array(this.items.length).fill(0);
    this.centerXList = new Array(this.items.length).fill('100%');
  }


  /**
   * 在指定索引位置插入一个新数据项，并重置动画属性。
   * @param {number} index - 插入新数据项的位置索引。
   * @param {ESObject} data - 要插入的数据对象。
   */
  addData: (index: number, data: ESObject) => void = (index: number, data: ESObject) => {
    this.swiperData.addData(index, data);
    this.resetAnimationAttr();
  };

  /**
   * 更新指定索引位置的数据项，不需要重置动画属性。
   * @param {number} index - 要更新的数据项的位置索引。
   * @param {ESObject} data - 更新的数据对象。
   */
  updateData: (index: number, data: ESObject) => void = (index: number, data: ESObject) => {
    this.swiperData.updateData(index, data);
  };

  /**
   * 删除指定索引位置的数据项，并重置动画属性。
   * @param {number} index - 要删除的数据项的位置索引。
   */
  deleteData: (index: number) => void = (index: number) => {
    this.swiperData.deleteData(index);
    this.resetAnimationAttr();
  };

  /**
   * 向数据集末尾添加一个新的数据项，并重置动画属性。
   * @param {ESObject} data - 要添加的数据对象，遵循 ESObject 接口或类型。
   */
  pushData: (data: ESObject) => void = (data: ESObject) => {
    this.swiperData.pushData(data);
    this.resetAnimationAttr();
  };

  /**
   * 设置整个数据集，并重置动画属性。
   * @param {ESObject[]} data - 新的数据集。
   */
  setData: (data: ESObject[]) => void = (data: ESObject[]) => {
    this.swiperData.setData(data);
    this.resetAnimationAttr();
  };

  // 默认轮播项内容
  @Builder
  defaultSwiperItem(item: ESObject) {
    Image(item)
      .objectFit(ImageFit.Cover)
      .width($r('app.string.cube_animation_full_size'))
      .height($r('app.string.cube_animation_full_size'))
  }

  build() {
    Swiper(this.swiperController) {
      // TODO：性能知识点: 动态加载数据或者数据量比较多的情况下，建议使用LazyForEach
      LazyForEach(this.swiperData, (item: ESObject, index: number) => {
        Stack() {
          this.swiperItemSlotParam(item)
        }
        .maskShape(new RectShape().width($r('app.string.cube_animation_full_size'))
          .height($r('app.string.cube_animation_full_size'))
          .fill(Color.White))
        .width($r('app.string.cube_animation_full_size'))
        .height($r('app.string.cube_animation_full_size'))
        .rotate({
          x: 0,
          y: 1,
          z: 0,
          angle: this.angleList[index],
          centerX: this.centerXList[index],
          centerY: '50%',
          centerZ: 0,
          perspective: 0
        })
      }, ((item: ESObject, index: number) => `${JSON.stringify(item)}_${index}`))
    }
    .width($r('app.string.cube_animation_full_size'))
    .height($r('app.string.cube_animation_full_size'))
    .cachedCount(1)
    .indicator(false)
    .loop(this.loop)
    .autoPlay(this.autoPlay)
    .duration(this.duration)
    .curve(Curve.EaseInOut)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .customContentTransition({
      // 页面移除视窗时超时1000ms下渲染树
      timeout: 1000,
      // TODO：知识点：自定义Swiper页面切换动画，在页面切换时逐帧触发回调，在回调中设置rotate属性值，实现自定义3D立方体旋转切换动画
      // TODO: 性能知识点: 该函数是系统高频回调函数，避免在函数中进行冗余或耗时操作，例如应该减少或避免在函数打印日志，会有较大的性能损耗。
      transition: (proxy: SwiperContentTransitionProxy) => {
        let angle = 0; // 旋转角度
        // position为index页面相对于selectedIndex对应页面的起始位置的移动比例，向左移动减小，向右移动增加。
        if (proxy.position < 0 && proxy.position > -1) {
          // 当前页向左滑出或上一页向右滑入
          angle = proxy.position * 90;
          // 设置index页面的旋转中心轴为右侧边缘
          this.centerXList[proxy.index] = '100%';
        } else if (proxy.position > 0 && proxy.position < 1) {
          // 当前页向右滑出或下一页向左滑入
          angle = proxy.position * 90;
          // 设置index页面的旋转中心轴为左侧边缘
          this.centerXList[proxy.index] = '0%';
        } else {
          // position小于-1时表示向左完全滑出区域，大于1时表示向右完全滑出区域，重置角度
          angle = 0;
        }
        // 修改index页的旋转角
        this.angleList[proxy.index] = angle;
      }
    })
  }
}