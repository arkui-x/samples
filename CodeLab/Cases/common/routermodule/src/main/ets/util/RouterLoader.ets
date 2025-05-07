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

import { AppRouterInfo, RouterMapModel } from '../model/AppRouterInfo';
import { resourceManager } from '@kit.LocalizationKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from 'utils';

// 加载路由
export namespace RouterLoader {
  // 加载所有路由表文件
  export function load(dir: string, routerMap: Map<string, AppRouterInfo>, context: Context) {
    const rm: resourceManager.ResourceManager = context.resourceManager;
    try {
      rm.getRawFileList(dir).then((value: Array<string>) => {
        let decoder: util.TextDecoder = util.TextDecoder.create("utf-8", {
          fatal: false,
          ignoreBOM: true
        })
        // 遍历所有模块的路由表文件，放入路由表中管理
        value.forEach((fileName: string) => {
          let fileBytes: Uint8Array = rm.getRawFileContentSync(`${dir}/${fileName}`);
          let retStr = decoder.decodeWithStream(fileBytes);
          let routerMapModel: RouterMapModel = JSON.parse(retStr) as RouterMapModel;
          loadRouterMap(routerMapModel, routerMap);
        })
      }).catch((error: BusinessError) => {
        logger.error(`promise getRawFile failed, error code:${error.code}, message :${error.message}.`);
      });
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      logger.error(`promise getRawFile failed, error code:${code} ,message :${message}`);
    }
  }

  function loadRouterMap(routerMapModel: RouterMapModel, routerMap: Map<string, AppRouterInfo>): void {
    routerMapModel.routerMap.forEach((routerInfo: AppRouterInfo) => {
      if (routerMap.has(routerInfo.name)) {
        logger.warn("duplicate router declare");
      } else {
        routerMap.set(routerInfo.name, routerInfo);
      }
    })
  }
}