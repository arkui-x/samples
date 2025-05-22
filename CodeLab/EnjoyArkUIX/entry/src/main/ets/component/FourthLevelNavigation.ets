/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import { FourthLevelCategory, PlatformTypeEnum } from '../model/CategoricalDataType';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import deviceInfo from '@ohos.deviceInfo';
import Logger from '../util/Logger';
import { promptAction } from '@kit.ArkUI';

const TAG: string = '[FourthLevelNavigation] '

@Component
export struct FourthLevelNavigation {
  private fourthLevelCategory!: FourthLevelCategory;

  build() {
    Row() {
      Text(this.fourthLevelCategory.title)
        .fontSize(16)
        .layoutWeight(1)
        .margin({ left: 42 })
        .align(Alignment.Start)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontColor($r('app.color.font_color_dark'))
      Blank()
    }
    .height(48)
    .width('100%')
    .onClick(() => {
      let osFullNameInfo: string = deviceInfo.osFullName
      let platformName: string = osFullNameInfo.split(' ')[0]
      let caseSupport: boolean =
        platformName.includes("Android") && this.fourthLevelCategory.platform === PlatformTypeEnum.IOS ||
          platformName.includes("iOS") && this.fourthLevelCategory.platform === PlatformTypeEnum.ANDROID
      if (caseSupport) {
        promptAction.showToast({
          message: '当前平台不支持该用例'
        })
      } else {
        let context = getContext(this) as common.UIAbilityContext
        context.startAbility(this.fourthLevelCategory.want as Want, (err, data) => {
          if (err) {
            Logger.info(TAG, 'startAbility failed, err message 01 is ' + JSON.stringify(err))
            Logger.info(TAG, 'startAbility failed, err message 02 is ' + err)
            return
          } else {
            Logger.info(TAG, 'startAbility success')
          }
        })
      }
    })
  }
}