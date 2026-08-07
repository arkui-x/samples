/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

@Component
export struct GridTitle {
  @Link foldFlag: boolean
  private title: string = ''

  build() {
    Row() {
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 8 })
      Blank()
      Image(this.foldFlag ? $r('app.media.ic_down_arrow') : $r('app.media.ic_right_arrow'))
        .width(this.foldFlag ? 24 : 12)
        .height(this.foldFlag ? 12 : 24)
        .margin({ right: this.foldFlag ? 30 : 36 })
    }
    .height(45)
    .width('100%')
    .onClick(() => {
      this.foldFlag = !this.foldFlag
    })
  }
}
