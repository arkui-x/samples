/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Permissions } from '@kit.AbilityKit';
import Logger from '../Logger';
import { PermissionUtilInterface } from '../interface/PermissionUtilInterface';

const TAG: string = '[PermissionUtilArkUIX]';

export class PermissionUtilArkUIX implements PermissionUtilInterface {
  private static instance: PermissionUtilArkUIX;

  public static getInstance(): PermissionUtilInterface {
    if (!PermissionUtilArkUIX.instance) {
      PermissionUtilArkUIX.instance = new PermissionUtilArkUIX();
    }
    return PermissionUtilArkUIX.instance;
  }

  public requestPermissions(permissions: Array<Permissions>, callback?: Function): void {
    Logger.warn(TAG, 'Func requestPermissions not support arkui-x');
  }

  public async checkPermissions(permissions: Array<Permissions>): Promise<boolean> {
    Logger.warn(TAG, 'Func checkPermissions not support arkui-x');
    return false;
  }
}