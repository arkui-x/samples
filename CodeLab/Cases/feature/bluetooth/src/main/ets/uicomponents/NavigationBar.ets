/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import window from '@ohos.window';
import { DynamicsRouter } from 'routermodule';

export interface Action {
  id: string;
  name: ResourceStr;
  event: (event?: ClickEvent) => void;
}

@Component
export default struct NavigationBar {
  private title?: ResourceStr;
  private showIndicator?: boolean = true;
  private darkMode?: boolean = false;
  private actions?: Array<Action>;

  build() {
    Row() {
      if (this.showIndicator) {
        Row() {
          Image($r('app.media.ic_public_back'))
            .objectFit(ImageFit.Contain)
            .width($r('app.integer.ble_navigation_image_width'))
            .aspectRatio(1)
        }
        .id('iv_back')
        .height('100%')
        .aspectRatio(1)
        .justifyContent(FlexAlign.Center)
        .onClick(async () => {
          // 恢复竖屏页面
          await globalThis.setOrientation(window.Orientation.UNSPECIFIED);
          DynamicsRouter.navPathStack.pop(true);
        });
      }

      Text(this.title ?? '')
        .fontColor(this.darkMode ? $r('app.color.ble_title_1') : $r('app.color.ble_title_2'))
        .fontSize($r('app.float.ble_text_size_title'))
        .margin({ left: this.showIndicator ? 0 : $r('app.integer.ble_title_margin_left') })

      Blank()
        .layoutWeight(1)

      ForEach(this.actions, (item: Action) => {
        Button(item.name)
          .id(item.id)
          .backgroundColor($r('app.color.ble_bg_transparent'))
          .fontSize($r('app.integer.ble_name_fontsize'))
          .fontColor($r('app.color.ble_item_name'))
          .margin({ right: $r('app.integer.ble_title_margin_right') })
          .onClick(item.event)
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.darkMode ? $r('app.color.ble_bg_transparent') : $r('app.color.ble_bg_transparent'))
  }
}