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

import { SubmitInfoWrapper } from '../common/DataModel';
import { FooterView } from './FooterView';
import { promptAction } from '@kit.ArkUI';

@Component
export struct TableView {
  currentIndex: number = 0;
  lastIndex: number | undefined = undefined;
  controller: SwiperController | undefined = undefined;
  submitInfo: SubmitInfoWrapper | undefined = undefined;
  readonly ITEM_SPACE: number = 5;

  build() {
    Column() {
      Scroll() {
        Column({ space: this.ITEM_SPACE }) {
          Column() {
            Text($r("app.string.stepper_input_item1"))
              .fontSize($r("app.integer.stepper_table_font_size"))
            TextInput()
              .enterKeyType(EnterKeyType.Done)
              .onChange((value: string) => {
                if (this.submitInfo) {
                  this.submitInfo.tableInfo.username = value == "" ? undefined : value;
                }
              })
          }.alignItems(HorizontalAlign.Start)

          Column() {
            Text($r("app.string.stepper_input_item2"))
              .fontSize($r("app.integer.stepper_table_font_size"))
            TextInput()
              .enterKeyType(EnterKeyType.Done)
              .onChange((value: string) => {
                if (this.submitInfo) {
                  this.submitInfo.tableInfo.age = value == "" ? undefined : Number.parseInt(value);
                }
              })
          }.alignItems(HorizontalAlign.Start)

        }
        .alignItems(HorizontalAlign.Start)
      }
      .layoutWeight(1)
      .width('100%')
      .align(Alignment.Top)

      FooterView({
        currentIndex: this.currentIndex,
        lastIndex: this.lastIndex,
        controller: this.controller,
        nextCb: () => {
          let verified: boolean =
            this.submitInfo !== undefined && this.submitInfo.tableInfo.username !== undefined &&
              this.submitInfo.tableInfo.age !== undefined;
          if (verified) {
            promptAction.showToast({ message: $r("app.string.stepper_submit_prompt") });
          } else {
            promptAction.showToast({ message: $r("app.string.stepper_info_not_filled") });
          }
          return verified;
        }
      })
    }
    .height('100%')
    .width('100%')
    .margin({ top: $r("sys.float.ohos_id_card_margin_start") })
  }
}