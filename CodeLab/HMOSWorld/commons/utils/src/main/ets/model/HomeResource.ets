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

import { LearningResource } from './LearningResource';
import { ResponseData } from '../common/ResponseData';

export interface HomeResources {
  /**
   * Swiper data on home page
   */
  bannerList: LearningResource[];

  /**
   *  Feed data on home page
   */
  feedData: ResponseData<LearningResource>;

  /**
   *  article data on home page
   */
  articleData: ResponseData<LearningResource>;
}