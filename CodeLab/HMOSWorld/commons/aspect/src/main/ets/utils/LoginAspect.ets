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

import { Logger } from '@ohos/utils';
import { AspectUtil } from './AspectUtil/AspectUtil';
import { promptAction } from '@kit.ArkUI';

const TAG: string = '[LoginAspect]';

export class LoginAspect {
  static createAspect() {
    const harName: string = '@ohos/login';
    import(harName).then((ns: ESObject) => {
      const targetClass: ESObject = ns.AccountModel;
      const methodClassName: string = 'AccountModel';
      AspectUtil.getAspectUtil().addBefore(methodClassName, targetClass, 'login', false);
      AspectUtil.getAspectUtil().addAfter<Promise<object | null>>(methodClassName, targetClass, 'login', false);

      AspectUtil.getAspectUtil()
        .replace(targetClass, 'clickLogin', false, (instance: Object, account: ESObject): Promise<ESObject> => {
          let isParamValid: boolean = false;
          if (account.userType === 1) {
            const isUsernameMatch: boolean = ((account.username as string) == 'developer1');
            const isPasswordMatch: boolean = ((account.password as string) == '123456');
            isParamValid = !(isUsernameMatch && isPasswordMatch);
          }
          if (isParamValid) {
            Logger.info(TAG, 'method login is replaced by toast.');
            promptAction.showDialog({
              title: $r('app.string.failed_msg_title'),
              message: $r('app.string.user_account_error')
            })
            return Promise.reject();
          } else {
            return targetClass.getInstance().login(account);
          }
        });
    }).catch((e: Error) => {
      Logger.error(TAG, `import ${harName} error, ${JSON.stringify(e)}`);
    })
  }
}