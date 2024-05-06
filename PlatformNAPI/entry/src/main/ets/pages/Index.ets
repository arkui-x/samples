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

import PlatformNAPI from 'libentry.so'

@Entry
@Component
struct Index {
  @State message1: string = 'Native API Function Add';
  @State text1: string = '结果:';
  @State message2: string = 'Native API Function nativeCallArkTS'
  @State text2: string = '结果:';
  @State message3: string = 'Native API Function GetDeviceBrand';
  @State text3: string = '结果:';
  @State message4: string = 'Native API Function GetProductModel';
  @State text4: string = '结果:';
  @State message5: string = 'Native API Function nativeUvLoop';
  @State text5: string = '结果:';

  build() {
    Row() {
      Scroll() {
        Column() {
          Column() {
          }.size({ width: 50, height: 50 })

          Text(this.message1)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Button('Function 调用')
            .height(50)
            .width('80%')
            .fontSize(20)
            .margin({ top: 15 })
            .onClick(() => {
              this.text1 = "Function调用中"
              let ret = JSON.stringify(PlatformNAPI.add(2, 3))
              setTimeout(() => {
                this.text1 = "结果: 2 + 3 = " + ret
              }, 500)
            })

          Text(this.text1)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Divider()
            .vertical(false)
            .strokeWidth(6)
            .color(Color.Yellow)
            .lineCap(LineCapStyle.Round)
            .margin({ top: 10, bottom: 10 })

          Text(this.message2)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Button('Function 调用')
            .height(50)
            .width('80%')
            .fontSize(20)
            .margin({ top: 15 })
            .onClick(() => {
              this.text2 = "Function调用中"
              setTimeout(() => {
                this.text2 = PlatformNAPI.nativeCallArkTS((a: string) => {
                  return a + " world!"
                })
              }, 500)
            })

          Text(this.text2)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Divider()
            .vertical(false)
            .strokeWidth(6)
            .color(Color.Yellow)
            .lineCap(LineCapStyle.Round)
            .margin({ top: 10, bottom: 10 })

          Text(this.message3)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Button('Function 调用')
            .height(50)
            .width('80%')
            .fontSize(20)
            .margin({ top: 15 })
            .onClick(() => {
              this.text3 = "Function调用中"
              let ret = JSON.stringify(PlatformNAPI.GetDeviceBrand())
              setTimeout(() => {
                this.text3 = "Your DeviceBrand is " + ret
              }, 500)
            })

          Text(this.text3)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Divider()
            .vertical(false)
            .strokeWidth(6)
            .color(Color.Yellow)
            .lineCap(LineCapStyle.Round)
            .margin({ top: 10, bottom: 10 })

          Text(this.message4)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Button('Function 调用')
            .height(50)
            .width('80%')
            .fontSize(20)
            .margin({ top: 15 })
            .onClick(() => {
              this.text4 = "Function调用中"
              let ret = JSON.stringify(PlatformNAPI.GetProductModel())
              setTimeout(() => {
                this.text4 = "Your ProductModel is " + ret
              }, 500)
            })

          Text(this.text4)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Divider()
            .vertical(false)
            .strokeWidth(6)
            .color(Color.Yellow)
            .lineCap(LineCapStyle.Round)
            .margin({ top: 10, bottom: 10 })

          Text(this.message5)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Button('Function 调用')
            .height(50)
            .width('80%')
            .fontSize(20)
            .margin({ top: 15 })
            .onClick(() => {
              this.text5 = "Function调用中"
              let ret = ""
              if (PlatformNAPI.nativeUvLoop() == 0) {
                ret = "NativeUvLoop successful"
              } else {
                ret = "NativeUvLoop failed"
              }
              setTimeout(() => {
                this.text5 = ret
              }, 500)
            })

          Text(this.text5)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 15 })

          Divider()
            .vertical(false)
            .strokeWidth(6)
            .color(Color.Yellow)
            .lineCap(LineCapStyle.Round)
            .margin({ top: 10, bottom: 10 })

          Column() {
          }.size({ width: 50, height: 50 })

        }.width('100%')
      }.scrollBar(BarState.Off)
    }.height('100%')
  }
}