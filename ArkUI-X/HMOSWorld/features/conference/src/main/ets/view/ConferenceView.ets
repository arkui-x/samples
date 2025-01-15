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

import { LoadingView } from '@ohos/uicomponents';
import { CommonConstants, PlatformInfo, PlatformTypeEnum, WebUtil } from '@ohos/utils';

@Component
export struct ConferenceView {
  @Link @Watch('updateNode') updateNodeFlag: boolean | undefined;

  updateNode(): void {
    if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID ||
      PlatformInfo.getPlatform() == PlatformTypeEnum.IOS) {
      if (this.updateNodeFlag) {
        WebUtil.createNWeb(WebUtil.WebUrls.ACTIVITY_URL, this.getUIContext());
      } else {
        WebUtil.deleteNode(WebUtil.WebUrls.ACTIVITY_URL);
      }
    }
  }

  build() {
    Stack() {
      LoadingView()
      if (this.updateNodeFlag) {
        NodeContainer(WebUtil.getNWeb(WebUtil.WebUrls.ACTIVITY_URL))
          .width(CommonConstants.FULL_PERCENT)
          .height(CommonConstants.FULL_PERCENT)
      }
    }
    .padding({ top: AppStorage.get<number>('statusBarHeight') })
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }
}