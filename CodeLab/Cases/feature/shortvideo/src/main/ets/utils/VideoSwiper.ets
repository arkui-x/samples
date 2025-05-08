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

import curves from '@ohos.curves';
import { VideoBuilder } from '../model/DataModel';
import { VideoNew } from '../model/BasicDataSource';
import { VideoSection } from './VideoSection';

/**
 * 功能描述：
 * 1. 进入页面，播放第一个视频。上下滑动切换视频，点击视频可以控制视频的播放和暂停。
 *
 * 实现原理：
 * 1. 使用Swiper组件创建一个竖直的可上下滑动的框架
 * 2. Swiper组件结合LazyForEach使用，懒加载资源
 * 3. 在Swiper组件中使用Video组件承载视频
 *
 * @param {VideoNew} data - 短视频数据
 * @param {() => void} playButtonView - 播放按钮视图
 */

// 视频划动组件
@Component
export struct VideoSwiper {
  // -------------------对外暴露变量-----------------------
  // 短视频数据
  data: VideoNew = new VideoNew();
  // 播放按钮视图
  @BuilderParam playButtonView: () => void;
  // --------------------私有属性----------------------------
  // Swiper组件控制器
  private swiperController: SwiperController = new SwiperController();
  // 是否在切换视频
  @State changeVideo: boolean = false;
  // 初始化当前视频的下标
  @State currentVideoIndex: number = 0;
  // 首视频标志
  @State firstFlag: boolean = true;
  // 视频播放状态
  @State playBoo: boolean = true;

  build() {
    Stack() {
      Swiper(this.swiperController) { // 使用Swiper组件实现滑动轮播显示的能力
        /*
         *TODO 性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
         *当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
         *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2
         */
        LazyForEach(this.data, (item: VideoBuilder, index: number) => {
          Stack({ alignContent: Alignment.Top }) {
            /**
             * 视频播放组件
             * @param {VideoBuilder} videoData - 短视频数据
             * @param {boolean} changeVideo - 是否在切换视频
             * @param {boolean} firstFlag - 是否是首视频
             * @param {boolean} playBoo - 视频播放状态
             * @param {number} videoItemIndex - 视频下标
             * @param {number} currentVideoIndex - 当前视频下标
             */
            VideoSection({
              videoData: item,
              changeVideo: this.changeVideo,
              firstFlag: this.firstFlag,
              playBoo: this.playBoo,
              videoItemIndex: index,
              currentVideoIndex: this.currentVideoIndex,
            })
            item.contentBuilder.builder(item.data);
          }.id("short_video_" + index)
        }, (index: number) => index.toString())
      }
      .index(this.currentVideoIndex) // 设置当前在容器中显示的子组件的索引值
      .cachedCount(this.firstFlag ? 0 : 2)
      .displayCount(1)
      .width($r('app.string.shortvideo_hundred_percent'))
      .height($r('app.string.shortvideo_hundred_percent'))
      .autoPlay(false)
      .indicator(false)
      .loop(true)
      .duration(200) // 子组件切换的动画时长
      .cachedCount(0)
      .vertical(true)
      .itemSpace(0)
      /**
       * 弹性曲线产生自然的弹簧效果，四个参数分别对应附着在弹簧上的对象的初始速度、附着在弹簧上的对象的质量、单位形变量所需弹力的大小、
       * 弹簧在振动过程中的减震力，使得弹簧振幅逐渐减小直至停止在平衡位置
       */
      .curve(curves.interpolatingSpring(-1, 1, 328, 34))
      .onContentDidScroll(() => {
        if (this.changeVideo) {
          return;
        }
        this.changeVideo = true;
      })
      .onChange((index: number) => {
        this.currentVideoIndex = index;
      })

      if (!this.playBoo && !this.changeVideo) {
        Column() {
          this.playButtonView()
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .width($r('app.string.shortvideo_hundred_percent'))
        .height($r('app.string.shortvideo_hundred_percent'))
        .onClick(() => {
          this.playBoo = true;
        })
      }
    }
    .width($r('app.string.shortvideo_hundred_percent'))
    .height($r('app.string.shortvideo_hundred_percent'))
  }
}
