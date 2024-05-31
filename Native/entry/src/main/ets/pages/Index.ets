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

import testNapi from 'libentry.so'

@Entry
@Component
struct Index {
  @State message: string = 'Test native api: 2 + 3 = ?';
  @State message2: string = 'Click me'
  @State message3: string = 'NativeUvLoop result';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .margin(15)
          .onClick(() => {
            this.message = "Test native api: 2 + 3 = " + testNapi.add(2, 3);
            console.log("Test NAPI 2 + 3 = " + testNapi.add(2, 3));
          })
        Text(this.message2)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .margin(15)
          .onClick(() => {
            this.message2 = testNapi.nativeCallArkTS((a:string)=>{
              return a + " world!";
            });
            console.log(this.message2);
          })
        Text(this.message3)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .margin(15)
        Button('NativeUvLoop execute click me')
          .width('95%')
          .height(50)
          .fontSize(20)
          .margin(20)
          .onClick(() => {
            if (testNapi.nativeUvLoop() == 0) {
              this.message3 = "NativeUvLoop successful"
            } else {
              this.message3 = "NativeUvLoop failed"
            }
            console.log(this.message3);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}