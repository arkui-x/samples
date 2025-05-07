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

import { PanelDataSource, PanelDataType, VideoDataSource, VideoDataType } from '../model/DataSource';
import { ListItemView, PanelListItem } from '../components/Component';
import promptAction from '@ohos.promptAction';
import { Constants } from '../Constants/Constant';

/**
 * 功能描述: 本示例主要介绍了利用panel实现底部面板内嵌套列表，分阶段滑动效果场景。
 *
 * 推荐场景: 实现底部抽屉滑动效果场景
 *
 * 核心组件:
 * 1. LazyForEach
 * 2. Component
 *
 * 实现步骤：
 * 1. 通过mode来设置panel的不同展开模式的高度
 * 2. 通过panel的onChange事件，来改变panel的展开模式
 * 3. 通过panel内嵌套列表的onTouch属性，来控制嵌套列表的滑动，和mode值的改变
 */
@Component
export struct BottomPanelSlideComponent {
  private listScroller = new ListScroller(); // panel中的list滚动控制器
  @State isShown: boolean = false; // panel是否显示
  @State mainContentData: VideoDataSource = new VideoDataSource(); // 视频展示列表
  @State panelList: PanelDataSource = new PanelDataSource(); // panel中的list数据数据
  @State isOpen: boolean = false; // panel中的列表是否可以滑动
  @State startIndex: number = 0; // list显示区域内第一个子组件的索引值
  @State mode: PanelMode = PanelMode.Half; // panel展开模式
  @State yStart: number = 0; // 手指按下屏幕起始纵坐标

  aboutToAppear(): void {
    // 构造视频列表数据
    for (let index = 0; index < Constants.VIDEO_LIST_LENGTH; index++) {
      let temp: PanelDataType = new PanelDataType(`收藏夹名称${index + 1}`, `${index + 1}个内容`)
      this.panelList.pushData(temp);
    }

    // 构造panel数据
    for (let index = 0; index < Constants.PANEL_LIST_LENGTH; index++) {
      let temDate: VideoDataType = new VideoDataType(`视频标题${index + 1}`, `发布作者昵称${index + 1}`);
      this.mainContentData.pushData(temDate);
    }
  }

  build() {
    Stack() {
      Column() {
        List() {
          /**
           *性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
           *当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
           *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
           */
          LazyForEach(this.mainContentData, (item: VideoDataType) => {
            ListItem() {
              ListItemView({ videoName: item.desc, authorName: item.author })
            }
            .width('100%')
            .alignSelf(ItemAlign.Center)
          }, (item: string) => item)
        }
        .id('page_list')
        .edgeEffect(EdgeEffect.None)
        .cachedCount(7)
        .divider({
          strokeWidth: $r("app.integer.bottompanelslide_number_2"),
          color: $r('app.color.ohos_id_color_background'),
          startMargin: $r("app.integer.bottompanelslide_number_20"),
          endMargin: $r("app.integer.bottompanelslide_number_20")
        }) // 每条数据之间的分界线
        .width(Constants.FULL_SIZE)
        .height(Constants.NINETY_PERCENT_SIZE)

        Row() {
          Text($r("app.string.bottompanelslide_open"))
            .fontColor('#004eff')
            .fontSize($r("app.integer.bottompanelslide_number_15"))
            .onClick(() => {
              this.isShown = !this.isShown
            })
        }
        .margin({
          right: $r("app.integer.bottompanelslide_number_40"),
          top: $r("app.integer.bottompanelslide_number_10")
        })
        .width(Constants.EIGHTY_PERCENT_SIZE)
        .justifyContent(FlexAlign.End)
        .height($r("app.integer.bottompanelslide_number_15"))
      }

      Panel(this.isShown) { // 展示收藏夹
        Column() {
          Row() {
            Text($r("app.string.bottompanelslide_watch_later"))
              .fontSize($r("app.integer.bottompanelslide_number_15"))
              .margin({ left: $r("app.integer.bottompanelslide_number_30") })
          }
          .height($r("app.integer.bottompanelslide_number_50"))
          .borderRadius($r("app.integer.bottompanelslide_number_10"))
          .width(Constants.NINETY_PERCENT_SIZE)
          .backgroundColor(Color.White)
          .margin({ bottom: $r("app.integer.bottompanelslide_number_15") })

          Row() {
            Text($r("app.string.bottompanelslide_choose_file"))
              .fontSize($r("app.integer.bottompanelslide_number_15"))
              .fontColor(Color.Black)
              .onClick(() => {
                promptAction.showToast({
                  message: '该功能暂未开发',
                  duration: 2000
                })
              })

            Text($r("app.string.bottompanelslide_new_file"))
              .fontSize($r("app.integer.bottompanelslide_number_15"))
              .fontColor(Color.Black)
              .alignSelf(ItemAlign.Start)
              .onClick(() => {
                promptAction.showToast({
                  message: '该功能暂未开发',
                  duration: 2000
                })
              })
          }
          .margin({ bottom: $r("app.integer.bottompanelslide_number_10") })
          .width(Constants.NINETY_PERCENT_SIZE)
          .justifyContent(FlexAlign.SpaceBetween)

          this.loadMyPanelList();
        }
        .id('bottom_panel_column')
      }
      .miniHeight(Constants.MINI_PANEL_HEIGHT) // panel最小高度
      .type(PanelType.Foldable)
      .mode(this.mode)
      .draggable(false) // 关闭拖拽panel
      .halfHeight(Constants.HALF_PANEL_HEIGHT) // panel一半高度
      .onChange((width: number, height: number, mode: PanelMode) => {
        switch (mode) {
          case PanelMode.Full: {
            this.mode = PanelMode.Full;
            this.isOpen = true;
            break;
          }
          case PanelMode.Half: {
            this.mode = PanelMode.Half;
            this.isOpen = false;
            break;
          }
          case PanelMode.Mini: {
            this.isShown = false;
          }
        }
      })
    }
    .width(Constants.FULL_SIZE)
    .height(Constants.FULL_SIZE)
    .backgroundColor(Color.White)
    .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.BOTTOM])
  }

  @Builder
  loadMyPanelList() {
    List({ initialIndex: 0, scroller: this.listScroller }) {
      /**
       *性能知识点：列表中数据较多且不确定的情况下，使用LazyForEach进行数据循环渲染。
       *当组件滑出可视区域外时，框架会进行组件销毁回收以降低内存占用。
       *文档参考链接：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-rendering-control-lazyforeach-0000001820879609
       */
      LazyForEach(this.panelList, (item: PanelDataType) => {
        ListItem() {
          PanelListItem({ desc: item.desc, including: item.including })
        }
        .width(Constants.FULL_SIZE)
      }, (item: PanelDataType) => item.desc)
    }
    .id('bottom_panel_list')
    .cachedCount(5)
    .onTouch((event?: TouchEvent) => {
      // panel展开时滑动事件
      if (event) {
        switch (event.type) {
          case TouchType.Down: {
            // 记录手机按下屏幕时的纵坐标
            this.yStart = event.touches[0].y;
            break;
          }
          case TouchType.Up: {
            break;
          }
          case TouchType.Move: {
            let yEnd: number = event.touches[0].y;
            // 判断是上滑还是下滑
            if (this.yStart < yEnd) {
              // 下滑
              // 在手指下滑且panel内列表达到顶部的情况下，panel回到half模式
              if (this.startIndex === 0) {
                this.mode = PanelMode.Half;
              }
            }
          }
        }
      }
    })
    .onScrollIndex((start: number) => {
      this.startIndex = start;
    })
    .edgeEffect(EdgeEffect.None)
    .enabled(this.isOpen)
  }
}
