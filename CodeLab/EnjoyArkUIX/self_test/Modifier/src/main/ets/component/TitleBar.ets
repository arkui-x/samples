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

import router from '@ohos.router'

@Component
export struct TitleBar {
  @State isMarquee: boolean = false
  private title: Resource | string = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
          .id('backBtn')

        Text(this.title)
          .maxLines(1)
          .fontWeight(FontWeight.Bold)
          .fontSize(20)
          .margin({ left: 8, right: 8 })
          .width('75%')
          .onDisAppear(() => {
            this.isMarquee = false
          })
          .onAppear(() => {
            setTimeout(() => {
              this.isMarquee = true
            }, 1500)
          })
          .textOverflow(this.isMarquee ? { overflow: TextOverflow.MARQUEE } : { overflow: TextOverflow.None })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
  }
}