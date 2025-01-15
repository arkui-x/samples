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

import { CheckEmptyUtil } from './CheckEmptyUtil';
import Logger from './Logger';

const TAG: string = '[ResourceUtil]';

export class ResourceUtil {
  /**
   * Obtains the character string corresponding to the specified resource ID.
   *
   * @param resource resource.
   */
  public static getResourceString(context: Context, resource: Resource): string {
    if (CheckEmptyUtil.isEmptyObj(resource)) {
      Logger.error(TAG, '[getResourceString] resource is empty.')
      return '';
    }
    let resourceString: string = '';
    try {
      resourceString = context.resourceManager.getStringSync(resource.id);
    } catch (error) {
      Logger.error(TAG, `[getResourceString]getStringSync failed, error : ${JSON.stringify(error)}.`);
    }
    return resourceString;
  }
}