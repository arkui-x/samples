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

@Entry
@Component
struct dynamicIndex {
  private startIcon: Resource = $rawfile('setting.jpeg');
  private icon: Resource = $r('app.media.ic_camera_master_ai_leaf');
  @State src: Resource = this.icon;

  build() {
    Row() {
      Scroll() {
        Column() {
          Text("预制演示页面")
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin(10)
          Image(this.src)
            .width(110)
            .height(110)
            .margin(15)
            .overlay('jpg', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          Button("切换图片")
            .onClick(() => {
              this.src = this.startIcon;
            })
            .width('100%')
            .margin(10)
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}