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

import { AspectUtil } from './AspectUtil/AspectUtil';
import { Logger } from '@ohos/utils';

const TAG = '[DiscoverAspect]';

export class DiscoverAspect {
  static createAspect() {
    let harName: string = '@ohos/discover';
    import(harName).then((ns: ESObject) => {
      const targetClass: ESObject = ns.DiscoverModel;
      const methodClassName: string = 'DiscoverModel';
      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'getHomeResources', false);
      AspectUtil.getAspectUtil().addAfter<Promise<void>>(methodClassName, targetClass, 'getHomeResources', false);
      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'loadMoreArticle', false);
      AspectUtil.getAspectUtil().addAfter<Promise<void>>(methodClassName, targetClass, 'loadMoreArticle', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'loadMoreFeed', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'loadMoreFeed', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'search', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'search', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'getSearchHistory', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'getSearchHistory', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'clearSearchHistory', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'clearSearchHistory', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'setCollectionCount', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'setCollectionCount', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'setLikesCount', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'setLikesCount', false);

      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'setViewsCount', false);
      AspectUtil.getAspectUtil().addAfter<void>(methodClassName, targetClass, 'setViewsCount', false);
    }).catch((e: Error) => {
      Logger.error(TAG, `import ${harName} error, ${JSON.stringify(e)}`);
    })
  }
}