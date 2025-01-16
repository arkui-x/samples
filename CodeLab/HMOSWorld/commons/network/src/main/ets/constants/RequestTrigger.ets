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

export default class RequestTrigger {
  /**
   * AspectTrigger upload-log
   */
  static readonly ASPECT_UPLOAD_ASPECT = 'upload-log';
  /**
   * DiscoveryTrigger get home data
   */
  static readonly DISCOVERY_HOME_RESOURCE = 'home-resource';
  /**
   * DiscoveryTrigger get resource by page
   */
  static readonly DISCOVERY_RESOURCE_PAGE = 'resource-list';
  /**
   * DiscoveryTrigger get hot resource
   */
  static readonly DISCOVERY_RESOURCE_HOT = 'resource-hot';
  /**
   * DiscoveryTrigger search by keywords
   */
  static readonly DISCOVERY_RESOURCE_SEARCH = 'resource-search';
  /**
   * LearningTrigger Learning Path
   */
  static readonly LEARNING_PATHS = 'learning-path';
  /**
   * LearningTrigger Update Learning Path
   */
  static readonly LEARNING_MODIFY = 'learning-modify';
  /**
   * LearningTrigger Learning Comments
   */
  static readonly LEARNING_COMMENTS = 'learning-comments';
  /**
   * LoginTrigger Login
   */
  static readonly LOGIN = 'third-login';
  /**
   * MineTrigger Get user data
   */
  static readonly MINE_USER_DATA = 'user-data';
  /**
   * MineTrigger Get List of Favorites
   */
  static readonly MINE_COLLECT = 'collect';
  /**
   * MineTrigger Get Browsing History List
   */
  static readonly MINE_HISTORY = 'history';
  /**
   * MineTrigger Achievements
   */
  static readonly MINE_ACHIEVE = 'achieve';
  /**
   * MineTrigger Like
   */
  static readonly MINE_LIKE = 'like';
  /**
   * MineTrigger Favorites
   */
  static readonly MINE_COLLECT_MODIFY = 'collect-modify';
  /**
   * MineTrigger Save push token
   */
  static readonly MINE_PUSH_TOKEN = 'set-push-token';
  /**
   * TopicTrigger Get All Topics
   */
  static readonly TOPIC_TOPICS = 'topics';
  /**
   * TopicTrigger Modify Focused Topics
   */
  static readonly TOPIC_TOPIC_MODIFY = 'topic-modify';
}