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

export class UserAccount {
  /**
   * unique uid
   */
  id: string = '';
  /**
   * AccountType 1: self-owned account 2: huawei account
   */
  userType: UserTypeEnum = UserTypeEnum.HMOS;
  /**
   * username
   */
  username: string = '';
  /**
   * nick name
   */
  nickname: string = '';
  /**
   * huawei account unionId
   */
  unionId: string = '';
  /**
   * user account password
   */
  password: string = '';
  /**
   * user account portrait
   */
  portrait: string = '';
  /**
   * user account description
   */
  description: string = '';
}

export enum UserTypeEnum {
  HMOS = 1,
  HUAWEI = 2
}