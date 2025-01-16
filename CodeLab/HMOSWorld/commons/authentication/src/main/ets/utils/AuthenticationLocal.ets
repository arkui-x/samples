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

import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { Logger, UserAccount, UserTypeEnum } from '@ohos/utils';
import { AuthenticationInterface } from '../interface/AuthenticationInterface';

const TAG: string = '[AuthenticationLocal]';

export class AuthenticationLocal implements AuthenticationInterface {
  public async getHWAuthorization(): Promise<UserAccount> {
    return new Promise((resolve: (data: UserAccount) => void, reject: (error: Resource) => void) => {
      try {
        let authRequest = this.createAuthRequest();
        let userAccount = new UserAccount();
        userAccount.userType = UserTypeEnum.HUAWEI;
        // Execute Authorization Request.
        let controller = new authentication.AuthenticationController(getContext(this));
        controller.executeRequest(authRequest, (err, data) => {
          if (err) {
            Logger.error(TAG, 'auth fail,error: ' + JSON.stringify(err));
            reject($r('app.string.login_failed_msg'));
            return;
          }
          let authorizationWithHuaweiIDResponse = data as authentication.AuthorizationWithHuaweiIDResponse;
          let state = authorizationWithHuaweiIDResponse.state;
          if (state != undefined && authRequest.state != state) {
            Logger.error(TAG, 'auth fail,The state is different: ' + JSON.stringify(authorizationWithHuaweiIDResponse));
            reject($r('app.string.login_failed_msg'));
            return;
          }
          Logger.info(TAG, 'auth success: ' + JSON.stringify(authorizationWithHuaweiIDResponse));
          let authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse.data!;
          userAccount.portrait = authorizationWithHuaweiIDCredential.avatarUri || '';
          userAccount.nickname = authorizationWithHuaweiIDCredential.nickName || '';

          this.handleHWLogin().then((data: string) => {
            userAccount.unionId = data;
            resolve(userAccount);
          }).catch(() => {
            reject($r('app.string.login_failed_msg'));
          })
        });
      } catch (error) {
        Logger.error(TAG, 'auth failed: ' + JSON.stringify(error));
        reject($r('app.string.login_failed_msg'));
      }
    });
  }

  private createAuthRequest() {
    let authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
    authRequest.scopes = ['profile', 'openid', 'phone'];
    authRequest.permissions = ['idtoken'];
    authRequest.forceAuthorization = true;
    authRequest.state = util.generateRandomUUID();
    return authRequest;
  }

  private async handleHWLogin(): Promise<string> {
    return new Promise((resolve: (data: string) => void, reject: (error: Resource) => void) => {
      try {
        let loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
        loginRequest.forceLogin = true;
        loginRequest.state = util.generateRandomUUID();
        // Executing login request.
        let controller = new authentication.AuthenticationController(getContext(this));
        controller.executeRequest(loginRequest, (err, data) => {
          if (err) {
            Logger.error(TAG, 'login fail, error' + JSON.stringify(err));
            reject($r('app.string.login_failed_msg'));
            return;
          }
          let loginWithHuaweiIDResponse = data as authentication.LoginWithHuaweiIDResponse;
          let state = loginWithHuaweiIDResponse.state;
          if (state != undefined && loginRequest.state != state) {
            Logger.error(TAG, 'login fail,The state is different: ' + JSON.stringify(loginWithHuaweiIDResponse));
            reject($r('app.string.login_failed_msg'));
            return;
          }
          Logger.info(TAG, 'login success, ' + JSON.stringify(loginWithHuaweiIDResponse));
          let loginWithHuaweiIDCredential = loginWithHuaweiIDResponse.data!;
          resolve(loginWithHuaweiIDCredential.unionID);
        });
      } catch (error) {
        reject($r('app.string.login_failed_msg'));
      }
    });
  }
}