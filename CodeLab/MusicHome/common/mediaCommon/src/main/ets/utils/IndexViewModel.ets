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

import { RouterUrlConstants } from '@ohos/constantsCommon';
import IndexItemData from '../viewmodel/IndexItemData';

/**
 * Home page information data processing class.
 */
class IndexViewModel {
  /**
   * Data information on the home page.
   *
   * @returns IndexItemData array.
   */
  getIndexItemList(): IndexItemData[] {
    let IndexItemList: IndexItemData[] = [];
    IndexItemList.push(new IndexItemData(
      $r('app.string.music_title'),
      $r('app.string.music_description'),
      $r('app.string.button_music'),
      $r('app.media.ic_music'),
      RouterUrlConstants.MUSIC_LIST)
    );
    IndexItemList.push(new IndexItemData(
      $r('app.string.live_title'),
      $r('app.string.live_description'),
      $r('app.string.button_live'),
      $r('app.media.ic_live'),
      RouterUrlConstants.LIVE)
    );
    return IndexItemList;
  }
}

export default new IndexViewModel();