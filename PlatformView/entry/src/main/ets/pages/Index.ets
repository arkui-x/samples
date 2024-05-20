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

@Entry
@Component
struct PlatformView {

  build() {
    Column() {
      Column(){
        XComponent({
          id: 'PlatformViewTest1',
          type: XComponentType.PLATFORM_VIEW,
        })
          .width('100%')
          .backgroundColor(Color.White)
      }
      .alignItems(HorizontalAlign.Center)
      .height('80%')
      Column(){
        Text("PlatformView")
          .fontSize(30)
          .fontFamily('HarmonyHeiTi-Bold')
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Start)
        .margin({ top: $r('app.float.wh_value_15')})
      }
      .height('20%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}