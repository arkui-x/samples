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

import window from '@ohos.window';
import deviceInfo from '@ohos.deviceInfo';

@Entry
@Component
struct Index {
  @State message: string = 'DynamicTwoAbility'
  private windowStage?: window.WindowStage = AppStorage.get("windowStage");
  private window?: window.Window;
  @State osName: string = deviceInfo.osFullName;

  build() {
    Row() {
      Scroll() {
        Column() {
          Text(this.message)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin(10)
          Text('type: Switch').fontSize(12).fontColor(0xcccccc).width('90%')
          Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
            Toggle({ type: ToggleType.Switch, isOn: false })
              .selectedColor('#007DFF')
              .switchStyle({
                pointRadius: 15,
                trackBorderRadius: 10,
                pointColor: '#D2B48C',
                unselectedColor: Color.Pink
              })

            Toggle({ type: ToggleType.Switch, isOn: true })
              .selectedColor('#007DFF')
              .switchStyle({
                pointRadius: 15,
                trackBorderRadius: 10,
                pointColor: '#D2B48C',
                unselectedColor: Color.Pink
              })
          }
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}
