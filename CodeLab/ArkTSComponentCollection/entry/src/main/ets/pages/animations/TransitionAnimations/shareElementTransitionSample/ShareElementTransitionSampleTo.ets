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

@Entry
@Component
struct ShareElementTransitionSampleTo {
  @State image: Resource | undefined = undefined;
  @State sharedTransitionID: number = -1;

  build() {
    Column() {
      Image(this.image)
        .objectFit(ImageFit.Contain)
        .sharedTransition(`sharedImage_${this.sharedTransitionID}`)
        .onClick(() => {
          router.back()
        }).id('test_back')
    }
    .padding(12)
    .backgroundColor(Color.Black)
    .justifyContent(FlexAlign.Center)
  }

  aboutToAppear() {
    let params = router.getParams() as Record<string, string | number | Resource>;
    this.image = params.image as Resource;
    this.sharedTransitionID = params.id as number;
  }
}