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
import { webview } from '@kit.ArkWeb';
import { TopNavigationView, WebViewArkUIX, WebViewLocal } from '@ohos/uicomponents';
import { CommonConstants, PlatformInfo, PlatformTypeEnum } from '@ohos/utils';

@Entry({ routeName: 'PrivacyPage' })
@Component
struct PrivacyPage {
  @State webViewController: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      TopNavigationView({
        title: $r('app.string.privacy_statement'),
        onBackClick: () => {
          router.replaceNamedRoute({
            name: 'SafePage',
          });
        }
      })
      if (PlatformInfo.getPlatform() == PlatformTypeEnum.ANDROID ||
        PlatformInfo.getPlatform() == PlatformTypeEnum.IOS) {
        WebViewArkUIX({
          url: $rawfile('privacy-statement-zh-cn.htm'),
          webViewController: $webViewController,
        })
      } else {
        WebViewLocal({
          url: $rawfile('privacy-statement-zh-cn.htm'),
          webViewController: $webViewController,
        })
      }

    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .padding({ top: AppStorage.get<number>('statusBarHeight'), bottom: $r('app.float.xxl_padding_margin') })
  }
}