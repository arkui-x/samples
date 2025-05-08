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

import LazyDataSource from '../model/LazyDataSource';
import { http } from '@kit.NetworkKit';
import { LoadingView } from './LoadingView';
import { LoadingStatus } from '../common/CommonEnums';
import { Model } from '../model/Model';
import { ListView } from './ListView';
import { LoadingFailedView } from './LoadingFailedView';
import { NoneContentView } from './NoneContentView';
import { CommonConstants } from '../common/CommonConstants';

// json数据的网络请求地址
const REQUEST_URL: string =
  "https://gitee.com/harmonyos-cases/cases/raw/master/CommonAppDevelopment/feature/skeletondiagram/src/main/resources/rawfile/skeletondiagram.json";

/**
 * 功能描述: 提供一个在页面数据加载完成前，先给用户展示出页面的大致结构的骨架屏（通常以灰色或其他浅色系的占位图形式呈现），待接口数据加载完成后，再渲染出实际页面内容并替换掉骨架屏，以此来提升加载时用户体验的骨架屏功能。
 *
 * 推荐场景: 页面数据加载慢需要用户等待时，需要提升用户体验的场景
 *
 * 核心组件:
 * 1. 自定义骨架屏布局ArticleLoadingSkeleton
 *
 * 实现步骤：
 * 1. 首先自行构造一个网络JSON数据供请求使用（此处不详述具体过程）。在aboutToAppear生命周期方法中加载网络数据，并根据返回结果改变状态变量loadingCollectedStatus的值。
 * 2. 根据LoadingStatus的值渲染不同的页面内容：当LoadingStatus为LOADING时，显示骨架屏（LoadingView）；若LoadingStatus为SUCCESS且dataSource.totalCount大于零，则显示列表页（ListView）；若数据为空，则显示无数据页面（NoneContentView）；若LoadingStatus为FAILED，则显示加载失败页面（LoadingFailedView）。
 * 3. 实现与真实列表布局一致的骨架屏效果，采用如下步骤：首先，使用Row控件并设置灰色背景还原ListItem上所有的控件位置和大小，通过ForEach循环创建列表项，以此形成骨架屏的基本结构；接着，为骨架屏列表添加animateTo显示动画，这样在加载过程中，骨架屏就会呈现出闪烁的效果，从而提升用户体验。
 */
@Component
export struct SkeletonDiagramComponent {
  @State loadingCollectedStatus: LoadingStatus = LoadingStatus.OFF;
  @State dataSource: LazyDataSource<Model> = new LazyDataSource();

  aboutToAppear() {
    this.loadList();
  }

  // 加载网络数据
  loadList() {
    // 正在加载状态
    this.loadingCollectedStatus = LoadingStatus.LOADING;
    let httpRequest = http.createHttp();
    // 设置发起请求可选参数
    let options: http.HttpRequestOptions = {
      expectDataType: http.HttpDataType.OBJECT, // 可选，指定返回数据的类型
    };
    // TODO: 知识点：request(url: string, callback: AsyncCallback<HttpResponse>): void此接口仅支持数据大小为5M以内的数据接收。若url包含中文或其他语言，需先调用encodeURL(url)编码，再发起请求。
    // TODO: 知识点：需要权限：ohos.permission.INTERNET在entry/src/main/module.json5文件中添加
    httpRequest.request(REQUEST_URL, options,
      (err: Error, data: http.HttpResponse) => {
        if (!err) {
          if (data.responseCode === CommonConstants.SUCCESS) {
            // 数据加载成功
            this.loadingCollectedStatus = LoadingStatus.SUCCESS;
            // 加载数据的处理
            this.dataSource.pushArrayData(data.result['data'] as Array<Model>)
          } else {
            // 数据加载失败
            this.loadingCollectedStatus = LoadingStatus.FAILED;
          }
        } else {
          // 数据加载失败
          this.loadingCollectedStatus = LoadingStatus.FAILED;
        }
      });
  }

  build() {
    Column() {
      // TODO: 知识点：通过状态变量loadingCollectedStatus的变化，动态切换页面内容，显示骨架屏、正常内容、无数据或加载失败提示。
      if (this.loadingCollectedStatus === LoadingStatus.LOADING) {
        // 加载骨架屏
        LoadingView()
      } else if (this.loadingCollectedStatus === LoadingStatus.FAILED) {
        // 网络请求失败
        LoadingFailedView({
          handleReload: () => {
            this.loadList()
          }
        })
      } else if (this.dataSource.totalCount() === 0) {
        // 获取数据为空
        NoneContentView()
      } else {
        // 加载列表
        ListView({ listData: this.dataSource })
      }
    }
    .backgroundColor($r("app.color.ske_list_back_ground_color"))
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}
