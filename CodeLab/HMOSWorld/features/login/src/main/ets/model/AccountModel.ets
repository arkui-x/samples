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

import { PreferenceManager } from '@ohos/datastore';
import { UserAccount } from '@ohos/utils';
import { LoginNetFunc } from '../service/LoginNetFunc';

const LOGIN_USER: string = 'logged_user';

export class AccountModel {
  private static instance: AccountModel;
  private funNetwork: LoginNetFunc;
  private preferenceManager: PreferenceManager = PreferenceManager.getInstance();

  private constructor() {
    this.funNetwork = new LoginNetFunc();
  }

  public static getInstance(): AccountModel {
    if (!AccountModel.instance) {
      AccountModel.instance = new AccountModel();
    }
    return AccountModel.instance;
  }

  login(userAccount: UserAccount): Promise<UserAccount | null> {
    return this.funNetwork.login(userAccount).then((data: UserAccount) => {
      this.preferenceManager.setValue<UserAccount>(LOGIN_USER, data);
      return data;
    });
  }

  clickLogin(userAccount: UserAccount): Promise<UserAccount | null> {
    return this.login(userAccount);
  }
}