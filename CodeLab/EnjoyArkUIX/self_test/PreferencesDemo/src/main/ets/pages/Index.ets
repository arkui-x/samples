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

import dataPreferences from "@ohos.data.preferences";
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World \n';
  controller: TextAreaController = new TextAreaController();
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  private mPreference: dataPreferences.Preferences | undefined = undefined;
  private observer: ((data: Record<string, dataPreferences.ValueType>) => void) | undefined = undefined;
  private NAME = "test_preferences";

  build() {
    Row() {
      Column() {
        TextArea({
          text: this.message,
          placeholder: 'The text area can hold an unlimited amount of text. input your word...',
          controller: this.controller,
        })
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .caretColor(Color.Blue)
          .width('100%')
          .height('45%')
          .margin(20)
          .fontSize(14)
          .focusable(true)
          .fontColor(Color.Black)
          .enableKeyboardOnFocus(false)
          .defaultFocus(true)
          .margin({ top: '1%' })
        Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap }) {
          Button('OnDataChange')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.OnDataChangeTask()
            })

          Button('清屏')
            .fontSize(14)
            .margin({ top: 10, left:5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = '';
            })
        }
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }

  async OnDataChangeTask() {
    this.mPreference = await dataPreferences.getPreferences(this.context, this.NAME);
    if (this.mPreference != undefined) {
      this.observer = (data: Record<string, dataPreferences.ValueType>) => {
        for (const keyValue of Object.entries(data)) {
          console.info(`observer : ${keyValue}`);
        }
        console.info("The observer called.");
      }
      let keys = ['name', 'age'];
      this.mPreference.on('dataChange', keys, this.observer);
      this.message += `====OnDataChange success \n`;
      this.controller.caretPosition(this.message.length);
      this.mPreference.putSync('name', 'xiaohong');
      this.mPreference.putSync('weight', 125);
      this.mPreference.flush((err: BusinessError) => {
        if (err) {
          console.error("Failed to flush. Cause: " + err);
          this.message += `====>OnDataChange failed to flush errorcode: ${err.code} \n`;
          this.controller.caretPosition(this.message.length);
          return;
        }
        console.info("Succeeded in flushing.");
        this.message += `====>OnDataChange succeeded in flushing \n`;
        this.controller.caretPosition(this.message.length);
      })
      this.mPreference.off('dataChange', keys, this.observer);
    }
  }
}