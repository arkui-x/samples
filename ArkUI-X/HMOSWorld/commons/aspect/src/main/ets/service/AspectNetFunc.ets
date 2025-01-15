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

import { BusinessError } from '@kit.BasicServicesKit';
import { Request, RequestTrigger } from '@ohos/network';
import { AspectInfoParams, Logger } from '@ohos/utils';

const TAG = '[AspectNetFunc]';

export class AspectNetFunc {
  public uploadAspectInfo(params: AspectInfoParams): Promise<void> {
    return new Promise((resolve: () => void, reject: (error: BusinessError) => void) => {
      Request.call(RequestTrigger.ASPECT_UPLOAD_ASPECT, params).then(() => {
        Logger.info(TAG, 'uploadAspectInfo success');
        resolve();
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'uploadAspectInfo error,' + JSON.stringify(error));
        reject(error);
      });
    });
  }
}