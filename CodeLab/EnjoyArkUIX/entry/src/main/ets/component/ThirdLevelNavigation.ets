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

import { FourthLevelCategory, PlatformTypeEnum, ThirdLevelCategory } from '../model/CategoricalDataType';
import { FourthLevelNavigation } from './FourthLevelNavigation';
import { common } from '@kit.AbilityKit';
import Want from '@ohos.app.ability.Want';
import Logger from '../util/Logger';
import deviceInfo from '@ohos.deviceInfo';
import promptAction from '@ohos.promptAction';

const TAG: string = '[ThirdLevelNavigation] '

@Component
export struct ThirdLevelNavigation {
  @State isUnfold: boolean = false
  private thirdLevelCategory!: ThirdLevelCategory
  private ThirdLevelNavigationIndex: number = 0
  private secondLevelCategoryIndex: number = 0

  build() {
    Column() {
      Row() {
        Image(this.thirdLevelCategory.image)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Fill)

        Text(this.thirdLevelCategory.title)
          .fontSize(16)
          .margin({ left: 16 })
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.font_color_dark'))

        Blank()

        if (this.thirdLevelCategory.childNodes) {
          Image(this.isUnfold ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
            .width(this.isUnfold ? 24 : 12)
            .height(this.isUnfold ? 12 : 24)
            .margin({ right: this.isUnfold ? 0 : 6 })
        }
      }
      .height(56)
      .width('100%')
      .onClick(() => {
        if (this.thirdLevelCategory.childNodes === undefined) {
          let osFullNameInfo: string = deviceInfo.osFullName
          let platformName: string = osFullNameInfo.split(' ')[0]
          let caseSupport: boolean =
            platformName.includes("Android") && this.thirdLevelCategory.platform === PlatformTypeEnum.IOS ||
              platformName.includes("iOS") && this.thirdLevelCategory.platform === PlatformTypeEnum.ANDROID
          if (caseSupport) {
            promptAction.showToast({
              message: '当前平台不支持该用例'
            })
          } else {
            let context = getContext(this) as common.UIAbilityContext
            context.startAbility(this.thirdLevelCategory.want as Want, (err, data) => {
              if (err) {
                Logger.info(TAG, 'startAbility failed, err message 01 is ' + JSON.stringify(err))
                Logger.info(TAG, 'startAbility failed, err message 02 is ' + err)
                return
              } else {
                Logger.info(TAG, 'startAbility success')
              }
            })
          }
        } else {
          this.isUnfold = !this.isUnfold
        }
      })

      if (this.isUnfold) {
        ForEach(this.thirdLevelCategory.childNodes, (fourthLevelCategory: FourthLevelCategory) => {
          Column() {
            Divider()
              .height(1)
              .opacity(0.2)
              .margin({ left: 42, right: 8 })
              .color($r('app.color.font_color_dark'))

            FourthLevelNavigation({ fourthLevelCategory: fourthLevelCategory })
          }
        })
      }
    }
  }
}