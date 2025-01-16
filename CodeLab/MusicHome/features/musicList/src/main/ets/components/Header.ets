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

import { promptAction, router } from '@kit.ArkUI';
import { Abilities, MenuData } from '@ohos/mediaCommon';
import { BreakpointConstants, StyleConstants } from '@ohos/constantsCommon';
import { HeaderConstants } from '../constants/HeaderConstants';

@Component
export struct Header {
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  build() {
    Row() {
      Image($r("app.media.ic_public_back"))
        .width($r('app.float.icon_width'))
        .height($r('app.float.icon_height'))
        .margin({ left: $r('app.float.icon_margin') })
        .onClick(() => {
          router.back();
        })
      Text($r('app.string.play_list'))
        .fontWeight(HeaderConstants.TITLE_FONT_WEIGHT)
        .fontColor(Color.Black)
        .fontSize($r('app.float.header_font_md'))
        .margin({ left: $r('app.float.title_left_margin') })
        .opacity($r('app.float.title_opacity'))
        .letterSpacing(HeaderConstants.LETTER_SPACING)

      Blank()

      Image($r('app.media.ic_more_black'))
        .width($r('app.float.icon_width'))
        .height($r('app.float.icon_height'))
        .margin({ right: $r('app.float.icon_margin') })
        .bindMenu(this.getMenu())
    }
    .width(StyleConstants.FULL_PERCENT)
    .height($r('app.float.title_bar_height'))
    .zIndex(HeaderConstants.Z_INDEX)
  }

  getMenu(): MenuData[] {
    let menuItem: MenuData = new MenuData();
    let menuDatas: MenuData[] = [];
    menuItem.value = HeaderConstants.AUDIO_DEVICE_SERVICE;
    if (Abilities.getAbilities().canIUse(HeaderConstants.SYSCAP_ETHERNET)) {
      menuItem.action = (): void => {
        promptAction.showToast({
          message: HeaderConstants.AUDIO_DEVICE_SERVICE,
          duration: HeaderConstants.TOAST_DURATION
        });
      };
    } else {
      menuItem.action = (): void => {
        promptAction.showDialog({
          message: HeaderConstants.SERVICE_UNSUPPORTED,
        })
      };
    }

    menuDatas.push(menuItem);
    return menuDatas;
  }
}