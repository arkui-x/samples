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

/**
 * Using AGC Functions to Obtain Network Data.
 */
import { BusinessError } from '@kit.BasicServicesKit';
import { Request, RequestTrigger } from '@ohos/network';
import { EditTopicsParams, Logger, Topic, UserIdParams } from '@ohos/utils';

const TAG = '[TopicNetFunc]';

export class TopicNetFunc {
  /**
   * Get Topic List by the userid.
   * @param userId
   * @returns
   */
  public getTopics(userId: string): Promise<Topic[]> {
    let params: UserIdParams = { userId };
    return new Promise((resolve: (value: Topic[] | PromiseLike<Topic[]>) => void,
      reject: (reason?: Object) => void) => {
      Request.call(RequestTrigger.TOPIC_TOPICS, params).then((result: Object) => {
        Logger.info(TAG, 'getTopics success--------' + JSON.stringify(result));
        resolve(result as Topic[]);
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'getTopics error--------' + JSON.stringify(error));
        reject(error);
      });
    });
  }

  /**
   * Edited Followed Topics.
   *
   * @param userId
   * @param followTopics
   * @returns
   */
  public editTopicsFollowed(userId: string, followTopics: string,): Promise<void> {
    let params: EditTopicsParams = { userId, followTopics };
    return new Promise((resolve: (value: void | PromiseLike<void>) => void,
      reject: (reason?: Object) => void) => {
      Request.call(RequestTrigger.TOPIC_TOPIC_MODIFY, params).then(() => {
        Logger.info(TAG, 'editTopicsFollowed success--------');
        resolve();
      }).catch((error: BusinessError) => {
        Logger.error(TAG, 'editTopicsFollowed error--------' + JSON.stringify(error));
        reject(error);
      });
    });
  }
}