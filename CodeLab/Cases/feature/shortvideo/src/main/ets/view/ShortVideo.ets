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

import { promptAction } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { GlobalStateDialogManager, PlatformInfo, PlatformTypeEnum } from 'utils';
import { AppRouter, DynamicsRouter } from 'routermodule';
import { TopTabContent, VIDEO_DATA, VideoBuilder } from '../model/DataModel';
import { VideoNew } from '../model/BasicDataSource';
import { VideoComponent } from './VideoMask';
import { VideoSwiper } from '../utils/VideoSwiper';

/**
 * 功能描述：本示例介绍了如何通过Swiper、LazyForEach以及Video组件实现短视频切换的功能。
 *
 * 推荐场景：视频切换场景
 *
 * 核心组件：
 * 1. VideoSwiper - 视频切换组件
 * 2. VideoSection - 视频播放组件
 *
 * 实现步骤：
 * 1. 构建遮罩层视图。遮罩层内容包括视频信息以及博主头像等内容，开发者可以自定义。
 *  @Builder
    export function VideoComponent(videoData: VideoData) {
      VideoMask({
        videoData: videoData
      })
    }
 * 2. 初始化数据。数据项类型为VideoBuilder，参数分别为短视频数据以及对应的遮罩层视图框架。
 * @example
   aboutToAppear() {
     for (let i = 0; i < VIDEO_DATA.length; i++) {
       // 模拟评论数据,真实场景需要请求后台获取评论数据
       for (let j = 0; j < 100; j++) {
         VIDEO_DATA[i].videoMask.commentDataSource.pushData({
           id: j + "",
           avatar: VIDEO_DATA[i].videoMask.head,
           name: "精灵球收七龙珠" + j,
           commentContent: "我没有看到后续，但总有人会看到" + j,
           timeAgo: j + "小时前",
           address: "广州",
           likeCount: j + ""
         });
       }
       this.data.pushData(new VideoBuilder(VIDEO_DATA[i], wrapBuilder(VideoComponent)));
     }
   }
 * 3. 构建短视频视图。
 * @example
 * VideoSwiper({
     data: this.data,
     playButtonView: this.playButtonView,
   })
 */


@AppRouter({ name: "shortvideo/ShortVideo" })
@Component
export struct ShortVideo {
  @State statusHeight: number = 0; // 系统状态栏高度
  @State bottomHeight: number = 0; // 系统导航栏高度
  // 当前tab下标
  @State currentIndex: number = 1;
  // 初始化顶部tab数据
  private topTabListData: TopTabContent = new TopTabContent();
  // 短视频数据
  @State data: VideoNew = new VideoNew();
  // scroller控制器初始化
  scroller: Scroller = new Scroller();

  listenBackPress() {
    let innerEvent: emitter.InnerEvent = {
      eventId: 8
    };
    // 收到eventId为8的事件后执行回调函数
    emitter.on(innerEvent, () => {
      if (AppStorage.get('isShowGlobalStateDialog')) {
        // 路由发生改变时，隐藏全局弹窗
        GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: false });
      } else {
        // 弹窗未打开时，退出当前页面
        //  TODO：需求：插件化时，需要将路由返回接口通过参数传入
        DynamicsRouter.popAppRouter();
      }
    });
  }

  // 视频数据初始化
  async aboutToAppear() {
    for (let i = 0; i < VIDEO_DATA.length; i++) {
      // 模拟评论数据,真实场景需要请求后台获取评论数据
      for (let j = 0; j < 100; j++) {
        VIDEO_DATA[i].videoMask.commentDataSource.pushData({
          id: j + "",
          avatar: VIDEO_DATA[i].videoMask.head,
          name: "精灵球收七龙珠" + j,
          commentContent: "我没有看到后续，但总有人会看到" + j,
          timeAgo: j + "小时前",
          address: "广州",
          likeCount: j + ""
        });
      }
      this.data.pushData(new VideoBuilder(VIDEO_DATA[i], wrapBuilder(VideoComponent)));
    }
    // 注册事件监听
    this.listenBackPress();
  }

  aboutToDisappear(): void {
    // 销毁事件监听
    emitter.off(8);
    // 页面销毁时，隐藏全局弹窗
    GlobalStateDialogManager.operateGlobalStateDialog({ isShowGlobalStateDialog: false });
  }

  @Builder
  playButtonView() {
    Image($r("app.media.shortvideo_pau"))
      .height($r("app.integer.shortvideo_play_icon_size"))
      .width($r("app.integer.shortvideo_play_icon_size"))
      .id('pause_icon')
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.currentIndex === 1) {
        /**
         * 视频切换组件
         * @param {VideoNew} data - 短视频数据
         * @param {()=>void} playButtonView - 播放按钮视图
         * @param {number} defaultIndex 默认上次播放视频下标（开发者可以根据此下标来跳转上次播放视频功能）
         */
        VideoSwiper({
          data: this.data,
          playButtonView: this.playButtonView,
        })
          .height('100%')
      }
      Row() {
        Image($r("app.media.shortvideo_search_icon"))
          .width($r("app.integer.shortvideo_search_icon_width"))
          .height($r("app.integer.shortvideo_search_icon_height"))
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
          })
        List({ scroller: this.scroller }) {
          /*
           *性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
           *当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
           *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2
           */
          LazyForEach(this.topTabListData, (item: string, index) => {
            ListItem() {
              Column() {
                Text(item)
                  .fontColor(this.currentIndex === index ? Color.White : $r("app.color.shortvideo_ont_color"))
                  .fontSize($r("app.integer.shortvideo_tab_font_size"))
                  .onClick(() => {
                    // 调用Toast显示提示：此样式仅为案例演示
                    promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") });
                  })
                Divider()
                  .width(this.currentIndex === index ? $r("app.integer.shortvideo_tab_divider_width") :
                  $r("app.integer.shortvideo_tab_divider_width_0"))
                  .strokeWidth(2)
                  .color(this.currentIndex === index ? Color.White : Color.Gray)
                  .margin({
                    top: $r("app.integer.shortvideo_divider_margin_top")
                  })
              }
              .padding({ top: $r("app.integer.shortvideo_tab_padding_top") })
              .width('25%')
            }
          }, (item: string, index) => JSON.stringify(item))
        }
        .listDirection(Axis.Horizontal) // 顶部tab列表横向排列
        .height('100%')
        .width('60%')

        Image($r("app.media.shortvideo_add1"))
          .width($r("app.integer.shortvideo_add_icon_width"))
          .height($r("app.integer.shortvideo_add_icon_width"))
          .onClick(() => {
            // 调用Toast显示提示：此样式仅为案例演示
            promptAction.showToast({ message: $r("app.string.shortvideo_demo_toast_tips") })
          })
      }
      .height($r("app.integer.shortvideo_tab_list_height"))
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .gesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event: GestureEvent) => {
          if (PlatformInfo.getPlatform() === PlatformTypeEnum.IOS) {
            if (event) {
              DynamicsRouter.popAppRouter();
            }
          }
        })
    )
  }
}
