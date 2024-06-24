/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import { AsyncCallback } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State title: string = 'First module\nAbility A Page A'
  @State message: string = 'Go To Page B'
  @State message2: string = 'Go To Second Module'

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Text(this.message)
          .fontSize(30)
          .fontColor(Color.Blue)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let wantInfo: Want = {
              bundleName: "com.example.multiability",
              moduleName: "entry",
              abilityName: "NextAbility",
            };

            let context = getContext(this) as common.UIAbilityContext;
            context.startAbility(wantInfo, null);
          })
          .position({ x: '80vp', y: '250.00vp' })

        Text(this.message2)
          .fontSize(30)
          .fontColor(Color.Blue)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let wantInfo: Want = {
              bundleName: "com.example.multiability",
              moduleName: "secondmodule",
              abilityName: "SecondmoduleAbility",
            };

            let context = getContext(this) as common.UIAbilityContext;
            context.startAbility(wantInfo, null);
          })
          .position({ x: '30vp', y: '350.00vp' })
      }
      .width('100%')
      .height('700vp')
    }
    .height('100%')
  }
}