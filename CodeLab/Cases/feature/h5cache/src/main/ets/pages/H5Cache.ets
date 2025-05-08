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

import { IWebParams } from '../common/WebParamsModel';
import { SubWeb } from './SubWeb';

/**
 * 场景描述: 本模块结合内存缓存和磁盘缓存实现了一个H5页面资源离线缓存案例
 *
 * 推荐场景: 网络不稳定或需要加快网页加载的场景，如：浏览网页等
 *
 * 核心组件:
 * 1. SubWeb
 *
 * 实现步骤：
 * 1.通过onInterceptRequest回调，拿到请求的url
 * 2.如果是需要缓存的资源，构造WebResourceResponse；否则，返回null，走正常的请求流程
 * 3.新建promise, 在promise回调中判断本地内存/硬盘缓存（本案例中内存缓存为LRUCache，磁盘缓存为手动实现的DiskLruCache）中是否存在对应的数据
 *（可以配置缓存优化策略，例如资源增加版本号，页面加载时优先使用缓存，保证页面快速加载，不影响用户体验，同时通过对比版本号等方法判断资源是否需要更新，
 * 如果需要，则发起请求更新缓存资源，后续重新加载页面时使用新的缓存）
 *    3.1 如果存在对应的数据，setResponseData给WebResourceResponse设置数据，调用resolve()使promise变成fulfilled状态（开发者可以增加自定义缓存逻辑，例如增加版本对比来实现缓存资源更新）
 *    3.2 如果不存在，手动创建http请求对应数据，在http回调中将数据保存到缓存中，同时通过setResponseData给WebResourceResponse设置数据，调用resolve()使promise变成fulfilled状态
 */
@Component
export struct H5Cache {
  pageInfos: NavPathStack = new NavPathStack();
  // 项目cache文件夹路径
  baseCacheDir: string = getContext(this).cacheDir;

  @Builder
  pagesMap(name: string, params: IWebParams) {
    SubWeb(params)
  }

  build() {
    Column() {
      Button('加载网页')
        .onClick(() => {
          const params: IWebParams = {
            url: $rawfile('example.html'),
            // WEB的title名
            title: '示例页面',
            // 目前只针对h5页面img、script等标签发起的资源类请求做缓存，尚未对作字体、音视频文件文件缓存
            cacheableResourceUrls: ['jpg', 'html', 'css', 'png', 'js'],
            // 磁盘缓存大小 3MB
            diskCacheCapacity: 3 * 1024 * 1024,
            // 内存缓存大小 1MB
            memoryCacheCapacity: 1024 * 1024,
            // 磁盘缓存路径
            diskCachePath: `${this.baseCacheDir}/example1`
          }
          this.pageInfos.pushPathByName('subWeb', params)
        })
      Navigation(this.pageInfos) {
      }
      .mode(NavigationMode.Stack)
      .navDestination(this.pagesMap)
    }
  }
}
