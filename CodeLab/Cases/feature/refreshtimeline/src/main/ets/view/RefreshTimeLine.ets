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

import { AppRouter } from 'routermodule';
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh';

// 定义时间轴类型
interface TimeLineInfo {
  index: number;
  time: string;
  text: string;
}

// 图片初始高度
const IMAGE_TOP_INIT_VALUE = -100;

/**
 * 实现步骤：
 * 1. 下拉刷新效果：通过 PullToRefresh 组件实现，通过onAreaChange接口计算图片下拉高度。
 * 2. 时间轴效果：时间轴部分：通过设置Column的bordier属性，只设置左边框实现。时间轴节点：样式通过设置borderRadius属性实现，位置通过设置margin的top实现偏移显示。
 */
@AppRouter({ name: "refreshtimeline/RefreshTimeLine" })
@Component
export struct RefreshTimeLine {
  // PullToRefresh组件必需参数
  @State data: string[] = [];
  // 定义Scroller对象，Scroller组件所需参数
  private scroller: Scroller = new Scroller();
  // 控制图片下拉变化的高度
  @State refreshPullDownHeight: number = 0;
  // 图片初始高度以及控制图片上拉变化的高度
  @State imgMarginTop: number = -100;
  // 下拉刷新组件配置对象
  private pullToRefreshConfigurator: PullToRefreshConfigurator = new PullToRefreshConfigurator();
  // 屏幕高度，用于计算组件区域变化的高度值
  private windowHeight: number = 0;
  // 回弹动画执行时间
  private animationTime: number = 600;
  // 允许下拉的最大距离
  private maxPullDown: number = 200;
  // 下拉刷新时间，用于模拟网络请求
  private refreshTime: number = 2000;
  // 用于进行位置判断
  private viewIndex: number = 1;
  // 下拉高度计算基数
  private pullDownHeightRadix: number = 2;
  // 刷新成功提示
  private refreshSuccessFlag: string = '刷新成功';
  // clip属性值，表示裁剪掉超出父组件的部分
  private clipValue: boolean = true;
  // 时间轴模块数据
  private timeLineData: TimeLineInfo[] = [
    { index: 1, time: '', text: '' },
    { index: 2, time: '2024.04.11 16:05:31', text: '少年自当扶摇上，揽星衔月逐日光。' },
    { index: 3, time: '2024.04.11 15:15:18', text: '海到尽头天作岸，山登绝顶我为峰。' },
    { index: 4, time: '2024.04.11 12:21:58', text: '一身转战三千里，一剑曾当百万师。' },
    { index: 5, time: '2024.04.11 10:47:23', text: '大鹏一日同风起，扶摇直上九万里。' },
    { index: 6, time: '2024.04.11 10:08:12', text: '满堂花醉三千客，一剑霜寒十四州。' },
    { index: 7, time: '2024.04.11 09:20:45', text: '黄沙百战穿金甲，不破楼兰终不还。' },
  ];

  // 时间轴模块
  @Builder
  getTimeLineMode(time: string, text: string) {
    Row() {
      Column() {
        // 时间轴
        Column()
          .width($r('app.integer.refreshtimeline_width_and_height_zero'))
          .height($r('app.integer.refreshtimeline_width_and_height_one_hundred_and_forty'))
          .border({
            width: { left: $r('app.string.refreshtimeline_time_line_width') },
            color: { left: $r('app.color.refreshtimeline_time_line_color') },
            style: { left: BorderStyle.Dotted }
          })

        // 时间轴节点
        Column()
          .width($r('app.integer.refreshtimeline_width_and_height_ten'))
          .height($r('app.integer.refreshtimeline_width_and_height_ten'))
          .backgroundColor($r('app.color.refreshtimeline_time_node_color'))
          .borderRadius($r('app.integer.refreshtimeline_borderRadius_fifty'))
          .position({
            x: $r('app.integer.refreshtimeline_position_X'),
            y: $r('app.integer.refreshtimeline_position_Y')
          })
      }
      .margin({ left: $r('app.integer.refreshtimeline_margin_left_twenty') })

      // 内容区域
      Column() {
        Text(time)
          .fontSize($r('app.integer.refreshtimeline_font_size_fourteen'))
          .width($r('app.string.refreshtimeline_one_hundred_percent'))
          .height($r('app.integer.refreshtimeline_width_and_height_twenty'))
          .margin({
            left: $r('app.integer.refreshtimeline_margin_left_ten'),
            top: $r('app.integer.refreshtimeline_margin_top_five'),
            bottom: $r('app.integer.refreshtimeline_margin_bottom_five')
          })

        Text(text)
          .width($r('app.string.refreshtimeline_one_hundred_percent'))
          .margin({
            left: $r('app.integer.refreshtimeline_margin_left_ten'),
            top: $r('app.integer.refreshtimeline_margin_top_five')
          })
          .fontSize($r('app.integer.refreshtimeline_font_size_sixteen'))
      }
      .width($r('app.string.refreshtimeline_eighty_four_percent'))
      .height($r('app.integer.refreshtimeline_width_and_height_one_hundred_and_twenty'))
      .borderRadius($r('app.integer.refreshtimeline_borderRadius_ten'))
      .margin({
        left: $r('app.integer.refreshtimeline_margin_left_twelve'),
        top: $r('app.integer.refreshtimeline_margin_top_fifteen'),
        bottom: $r('app.integer.refreshtimeline_margin_bottom_five')
      })
      .backgroundColor(Color.White)
    }
    .width($r('app.string.refreshtimeline_one_hundred_percent'))
    .backgroundColor($r('app.color.refreshtimeline_time_line_mode_back_color'))
  }

  build() {
    Column() {
      Image($r('app.media.head_back_image'))
        .width($r('app.string.refreshtimeline_one_hundred_percent'))
        .height($r('app.integer.refreshtimeline_width_and_height_four_hundred'))
        .objectFit(ImageFit.Cover)
        .position({ y: (this.imgMarginTop + this.refreshPullDownHeight) })

      PullToRefresh({
        // 必传项，列表组件所绑定的数据
        data: $data,
        // 必传项，需绑定传入主体布局内的列表或宫格组件
        scroller: this.scroller,
        // 设置下拉回弹动画
        refreshConfigurator: this.pullToRefreshConfigurator.setAnimDuration(this.animationTime)
          .setMaxTranslate(this.maxPullDown),
        // 必传项，自定义主体布局，内部有列表或宫格组件
        customList: () => {
          // 一个用@Builder修饰过的UI方法
          this.getListView();
        },
        // 可选项，下拉刷新回调
        onRefresh: () => {
          return new Promise<string>((resolve, reject) => {
            // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
            setTimeout(() => {
              resolve(this.refreshSuccessFlag);
            }, this.refreshTime);
          });
        },
      })// TODO: 性能知识点：onAreaChange回调监听接口: 组件位置变化时，每一帧都会触发回调，属于频繁回调接口，内部需要避免打印日志等耗时操作
        .onAreaChange((oldValue, newValue) => {
          // TODO: 知识点：PullToRefresh组件会铺满整个屏幕，通过onAreaChange获取到的区域高度就是屏幕高度
          // TODO: 知识点：并且PullToRefresh组件不会随着上拉或下拉变化，该接口只会回调一次，此处不存在频繁回调造成的性能问题
          this.windowHeight = (newValue.height as number);
        })
    }
    .backgroundColor($r('app.color.refreshtimeline_back_color'))
    .clip(this.clipValue)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  @Builder
  private getListView() {
    List({ scroller: this.scroller }) {
      // TODO: 高性能知识点：此处为了演示场景，列表数量只有7个，使用ForEach，列表数量较多的场景，推荐使用LazyForEach+组件复用+缓存列表项实现
      ForEach(this.timeLineData, (timeLine: TimeLineInfo) => {
        ListItem() {
          if (timeLine.index === this.viewIndex) {
            Column()
              .height($r('app.integer.refreshtimeline_width_and_height_two_hundred'))
              .opacity($r('app.integer.refreshtimeline_opacity_Value'))
          } else {
            this.getTimeLineMode(timeLine.time, timeLine.text);
          }
        }
      })
    }
    .width($r('app.string.refreshtimeline_one_hundred_percent'))
    .height($r('app.string.refreshtimeline_one_hundred_percent'))
    .clip(false)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    // TODO: 性能知识点：onDidScroll属于频繁回调接口，应该避免在内部进行冗余和耗时操作，例如避免打印日志
    .onDidScroll((scrollOffset: number) => {
      // 获取List上滑的高度，控制图片上滑的高度
      this.imgMarginTop = IMAGE_TOP_INIT_VALUE - this.scroller.currentOffset().yOffset;
    })
    // TODO: 性能知识点：onAreaChange回调监听接口: 组件位置变化时，每一帧都会触发回调，属于频繁回调接口，内部需要避免打印日志等耗时操作
    .onAreaChange((oldValue, newValue) => {
      // TODO: 知识点: 通过onAreaChange获取到List的区域高度，与屏幕高度计算差值，得到下拉高度，除以高度基数，表明图片变化的高度是下拉高度的1/2
      this.refreshPullDownHeight = (this.windowHeight - (newValue.height as number)) / this.pullDownHeightRadix;
    })
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }
}
