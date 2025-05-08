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

import { webview } from '@kit.ArkWeb';
import { OfflineResourceManager, OfflineResourceManagerConfig } from '../common/OfflineResourceManager';
import { http } from '@kit.NetworkKit';
import { ResponseDataType } from '../common/ResponseDataType';
import { BusinessError } from '@kit.BasicServicesKit';
import { MimeType } from '../common/MimeType';

@Component
export struct SubWeb {
  // Web组件url
  @State url: ResourceStr = '';
  // NavDestination组件title
  @State title?: string = '';
  controller: webview.WebviewController = new webview.WebviewController();
  // 内存缓存容量
  memoryCacheCapacity?: number;
  // 磁盘缓存容量
  diskCacheCapacity?: number;
  // 需要被缓存的资源请求url，正则字符串数组
  cacheableResourceUrls?: Array<string>;
  // 离线资源管理器
  offlineResourceManager?: OfflineResourceManager;
  // 离线包路径
  offlinePath?: string;
  // 自盘缓存路径
  diskCachePath?: string;

  aboutToAppear(): void {
    webview.WebviewController.setWebDebuggingAccess(true);
    let offlineResourceManagerConfig: OfflineResourceManagerConfig = {
      offlinePath: this.offlinePath,
      memoryCacheCapacity: this.memoryCacheCapacity,
      diskCacheCapacity: this.diskCacheCapacity,
      diskCachePath: this.diskCachePath
    }
    this.offlineResourceManager = new OfflineResourceManager(offlineResourceManagerConfig);
  }

  build() {
    NavDestination() {
      Web({ src: this.url, controller: this.controller })
        .javaScriptAccess(true)
        .onInterceptRequest((event) => {
          // 资源请求url
          let url: string = event.request.getRequestUrl();

          // 如果不是http/https请求，走原始逻辑
          if (!url.startsWith('http')) {
            return null;
          }

          // 资源类型：如https://cdnjs.cloudflare.com/ajax/libs/animejs/3.2.0/anime.min.js
          // 处理后type值为js
          let type: string;
          type = (url.split('.').pop() as string);
          // url匹配，是否为需要缓存的资源请求
          let matched: boolean = false;
          let cacheableResourceUrls: Array<string> = this.cacheableResourceUrls as Array<string>;
          for (let cacheableResourceUrl of cacheableResourceUrls) {
            if (new RegExp(cacheableResourceUrl, 'g').exec(url)) {
              matched = true;
              break;
            }
          }

          // 开发者可以增加缓存策略，例如：
          // 1、 网络优先还是缓存优先
          // 2、 增加缓存生效时间
          // 3、 优先使用缓存，保证页面快速加载，同时通过对比版本号等方法，发起请求更新缓存资源，后续重新加载页面时使用新的缓存

          if (matched) {
            // 查询缓存
            let cacheResource = (this.offlineResourceManager as OfflineResourceManager).fetchFromCache(url, type);
            // 构造请求响应
            let responseWeb: WebResourceResponse = new WebResourceResponse();
            const promise: Promise<String> = new Promise((resolve: Function, reject: Function) => {
              if (cacheResource) {
                // 返回缓存
                responseWeb.setResponseData(cacheResource as ResponseDataType);
                resolve('success');
              } else {
                // 发起请求
                let httpRequest: http.HttpRequest = http.createHttp();

                httpRequest.request(url, (err: BusinessError, data: http.HttpResponse) => {
                  if (data) {
                    // 数据正常返回
                    (this.offlineResourceManager as OfflineResourceManager).submitToCache(url,
                      data.result as ResponseDataType)
                    responseWeb.setResponseData(data.result as ResponseDataType);
                  } else {
                    // 请求出错,返回null
                    responseWeb.setResponseData(null);
                  }

                  responseWeb.setResponseMimeType(MimeType[type]);
                  responseWeb.setReasonMessage('OK');
                  responseWeb.setResponseCode(200);
                  // http响应返回后将promise设置成resolve状态
                  resolve('success');
                })
              }
            })
            promise.then(() => {
              responseWeb.setResponseIsReady(true);
            })
            responseWeb.setResponseIsReady(false);
            return responseWeb;
          }

          return null;
        })
    }
    .title(this.title)
  }
}
