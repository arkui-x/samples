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


@Component
export struct FooterView {
  @State currentIndex: number = 0; // 当前页面的索引
  lastIndex: number | undefined = undefined; // 最后一个页面的索引
  controller: SwiperController | undefined = undefined; // Swiper的Controller，控制页面的前进回头
  nextCb: Function | undefined = undefined; // 进入下一页前的回调，只有当函数返回true时，才能进入下一页

  build() {
    Row() {
      if (this.currentIndex !== 0) {
        Button($r("app.string.stepper_prev_label"))
          .onClick(() => {
            this.controller?.showPrevious();
          })
      }
      // TODO 知识点：通过回调对当前页面数据进行验证，只有验证通过，才能切换到下一页
      Button(this.currentIndex !== this.lastIndex ? $r("app.string.stepper_next_label") :
      $r("app.string.stepper_submit"))
        .onClick(() => {
          if (this.nextCb === undefined) {
            this.controller?.showNext();
          } else if (this.nextCb()) {
            this.controller?.showNext();
          }
        })
    }.width('100%')
    .justifyContent(this.currentIndex === 0 ? FlexAlign.End : FlexAlign.SpaceBetween)
  }
}