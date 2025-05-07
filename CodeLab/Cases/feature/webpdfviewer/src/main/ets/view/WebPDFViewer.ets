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

import webview from '@ohos.web.webview';
import { promptAction } from '@kit.ArkUI';
import { RemotePPTViewer } from './RemotePPTViewer';
import { RemoteExcelViewer } from './RemoteExcelViewer';
import { ListObj, MyDataSource } from './MyDataSource';

/**
 * 功能说明： 本示例介绍如何通过ArkWeb实现PDF、excel和PPT的预览
 *
 * 推荐场景：需要通过ArkWeb浏览PDF、excel和PPT文件场景
 *
 * 核心组件：
 * 1.tabs组件:通过tabs实现多个预览功能的切换
 * 2.swiper组件：配合tabs实现content内容的切换
 * 3.RemotePPTViewer组件：用于实现预览在线ppt文件的核心组件
 * 4.RemoteExcelViewer组件：用于实现预览在线excel文件的核心组件
 *
 * 实现步骤：
 * 1.创建一个Tabs容器组件，其中包含多个TabContent子组件，用于预览PDF和office文件。
 * 2.在第一个TabContent子组件中创建一个Web组件，通过 resource 协议来预览本地PDF资源并通过.onProgressChange方法监听加载进度。
 * 3.在第二个TabContent子组件中创建一个Web组件，通过网络链接属性来加载并预览网络PDF资源并通过.onProgressChange方法监听加载进度。
 * 4.由于ArkWeb本身不支持直接渲染office文件，借助微软的office web viewer帮助我们实现office组件的预览效果，新建2个html文件分别用于预览excel和ppt，将文件的下载地址传入到office web viewer的src参数中
 * 5.使用ArkWeb读取html文件进行渲染
 *
 */

const START_VALUE: number = 0; // 指定当前进度值，初始化开始位置为0
const TOTAL_VALUE: number = 100; // 指定进度总长，进度条总长度为100
const RESOURCE_URL: string = 'resource://rawfile/sample.pdf#toolbar=0'; // 本地PDF文件，其中“#toolbar=0”屏蔽Web组件的工具栏
const REMOTE_URL: string = 'https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/webpdfviewer/src/main/resources/rawfile/sample.pdf#toolbar=0'; // 网络PDF文件路径，其中“#toolbar=0”屏蔽Web组件的工具栏

@Component
export struct WebPDFViewerComponent {
  @State tabsIndex: number = 0; // tabs组件选中的初始位置
  @State fontColor: ResourceColor = $r("app.color.web_pdf_viewer_font_color") //未选中字体颜色
  @State selectedFontColor: ResourceColor = $r("app.color.web_pdf_viewer_selected_font_color") //选中字体的颜色
  private tabsController: TabsController = new TabsController();
  private swiperController: SwiperController = new SwiperController();
  private swiperData: MyDataSource = new MyDataSource([]);
  private list: ListObj[] = [
    { index: 0, header: $r("app.string.web_pdf_viewer_tab_index_one_title"), comp: LocalPDFViewer },
    { index: 1, header: $r("app.string.web_pdf_viewer_tab_index_two_title"), comp: RemotePDFViewer },
    { index: 2, header: $r("app.string.web_viewer_excel_online"), comp: RemoteExcelViewer },
    { index: 3, header: $r("app.string.web_viewer_ppt_online"), comp: RemotePPTViewer },
  ];

  aboutToAppear(): void {
    this.swiperData = new MyDataSource(this.list);
  }

  @Builder
  TabBuilder(index: number, name: ResourceStr) {
    Column() {
      Text(name)
        .fontColor(this.tabsIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(18)
        .margin({ top: 12, bottom: 12 })
      Divider()
        .strokeWidth(3)
        .width($r("app.string.web_pdf_viewer_progress_line_width"))
        .color($r("app.color.web_pdf_viewer_progress_line_color"))
        .opacity(this.tabsIndex === index ? 1 : 0)
    }.width($r("app.string.web_pdf_viewer_tab_width"))
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
        ForEach(this.list, (item: ListObj) =>{
          TabContent()
            .tabBar(this.TabBuilder(item.index, item.header))
        })
      }
      .scrollable(false)
      .onTabBarClick((index: number) => {
        this.tabsIndex = index;
        this.swiperController.changeIndex(index, true);
      })
      .barMode(BarMode.Scrollable)
      .backgroundColor($r("app.color.web_pdf_viewer_tab_content_color"))
      .height($r("app.integer.web_pdf_viewer_tab_content_height"))
      .width($r("app.string.web_pdf_viewer_tab_content_width"))

      Swiper(this.swiperController) {
        LazyForEach(this.swiperData, (item: ListObj) => {
          if (item.index === 0) {
            LocalPDFViewer()
          } else if (item.index === 1) {
            RemotePDFViewer()
          } else if (item.index === 2) {
            RemoteExcelViewer()
          } else {
            RemotePPTViewer()
          }
        }, (item: ListObj) => item.index.toString())
      }
      .loop(false)
      .disableSwipe(true)  // office自身有滑动效果，禁用swiper的效果防止冲突
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        this.tabsIndex = targetIndex;
        this.tabsController.changeIndex(targetIndex);
      })
      .layoutWeight(1)
    }
  }
}

@Component
struct LocalPDFViewer {
  @State localProgressValue: number = 0; // 设置加载本地进度，进度条初始值为0
  @State isHiddenLocalProgress: Boolean = true; // 记录加载本地进度条显隐，进入页面默认加载
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Stack() {
        if (this.isHiddenLocalProgress) {
          Progress({ value: START_VALUE, total: TOTAL_VALUE, type: ProgressType.Linear })
            .width($r("app.string.web_pdf_viewer_progress_width"))
            .height($r("app.integer.web_pdf_viewer_progress_height"))
            .value(this.localProgressValue)
            .color(Color.Green)
        }
      }

      // TODO：需求：可以对Web的下载、打印等按钮点击事件处理。
      // TODO: 知识点：加载本地PDF文件，通过resource协议加载本地资源文件。
      Web({
        src: RESOURCE_URL,
        controller: this.controller
      })
        // TODO: 知识点1：在远程PDF将要加载的页面之前调用，提前下载页面所需的资源，但不会执行网页JavaScript代码或呈现网页，以加快加载速度。
        // TODO: 知识点2：通过domStorageAccess(true) 设置是否开启文档对象模型存储接口（DOM Storage API）权限，默认未开启。
        .onPageEnd(() => {
          // 开启在线PDF预加载
          this.controller.prefetchPage(REMOTE_URL);
        })
        .onProgressChange((event) => {
          if (event) {
            this.localProgressValue = event.newProgress;
            if (this.localProgressValue >= TOTAL_VALUE) {
              this.isHiddenLocalProgress = false;
            }
          }
        })
        .domStorageAccess(true)
    }
  }
}

@Component
struct RemotePDFViewer {
  @State remoteProgressValue: number = 0; // 设置加载网络进度，进度条初始值为0
  @State isHiddenRemoteProgress: Boolean = true; // 记录加载网络进度条显隐，进入页面默认加载
  controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Stack() {
        if (this.isHiddenRemoteProgress) {
          Progress({ value: START_VALUE, total: TOTAL_VALUE, type: ProgressType.Linear })
            .width($r("app.string.web_pdf_viewer_progress_width"))
            .height($r("app.integer.web_pdf_viewer_progress_height"))
            .value(this.remoteProgressValue)
            .color(Color.Green)
        }
      }

      // TODO: 知识点：加载网络PDF文件，可以直接访问网络地址的方式。
      Web({
        src: REMOTE_URL,
        controller: this.controller
      })
        .onProgressChange((event) => {
          if (event) {
            this.remoteProgressValue = event.newProgress;
            if (this.remoteProgressValue >= TOTAL_VALUE) {
              this.isHiddenRemoteProgress = false;
            }
          }
        })
        .domStorageAccess(true)
        .onErrorReceive((event) => {
          if (event) {
            promptAction.showToast({ message: event.error.getErrorInfo() });
          }
        })
    }
  }
}




