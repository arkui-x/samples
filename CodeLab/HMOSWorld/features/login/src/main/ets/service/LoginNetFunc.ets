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
import { Logger, UserAccount } from '@ohos/utils';

const TAG = '[LoginNetFunc]';

/**
 * Using AGC Functions to Obtain Network Data.
 */
export class LoginNetFunc {
  /**
   *
   * @param UserAccount
   */
  public login(userAccount: UserAccount): Promise<UserAccount> {
    return new Promise((resolve: (value: UserAccount | PromiseLike<UserAccount>) => void,
      reject: (reason?: Object) => void) => {
      Logger.info(TAG, 'login----------------------');
      Request.call(RequestTrigger.LOGIN, userAccount).then((result: Object) => {
        Logger.info(TAG, 'login success--------' + JSON.stringify(result));
        resolve(result as UserAccount);
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'login error--------' + JSON.stringify(error));
        reject(error);
      });
    });
  }
}