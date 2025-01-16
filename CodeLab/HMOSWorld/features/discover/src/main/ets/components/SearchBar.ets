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

import { router } from '@kit.ArkUI';
import { CommonConstants, Logger } from '@ohos/utils';
import { SearchInput } from '@ohos/uicomponents';

const TAG = '[SearchBar]';

export const RECOMMEND_THEME = ['开发者故事', '技术干货', '鸿蒙生态', '应用模型', 'ArkUI', 'DevEco Studio'];

@Component
export struct SearchBar {
  @Prop enableKeyboardOnFocus: boolean;
  @Link searchValue: string;
  onSearch: (value: string) => void = (value) => {
  };
  onBack: () => void = () => {
  };

  build() {
    Row() {
      Image($r('app.media.back_to'))
        .size({ width: $r('app.float.normal_img_size'), height: $r('app.float.normal_img_size') })
        .width($r('app.float.search_height'))
        .height($r('app.float.search_height'))
        .margin({ right: $r('app.float.sm_padding_margin') })
        .onClick(() => this.onBack())

      SearchInput({
        enableKeyboardOnFocus: this.enableKeyboardOnFocus,
        placeholderArray: RECOMMEND_THEME,
        onSearch: this.onSearch,
        onChange: (value: string) => {
          const length: number = parseInt(router.getLength(), 10);
          let options: router.RouterState | undefined = router.getStateByIndex(length - 1);
          // Show search page when search value is empty
          if (options != undefined && options.name === 'SearchResultView' && !value) {
            Logger.info(TAG, 'Show search page when search value is empty');
            router.replaceNamedRoute({ name: 'SearchView' });
          }
        }
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .padding({
      top: $r('app.float.sm_padding_margin'),
      bottom: $r('app.float.sm_padding_margin')
    })
  }
}