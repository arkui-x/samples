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
import { Constants } from '../contants/Constants';

@Component
export struct Banner {
  @Link increaseBannerHeight: number;
  // 创建swiper组件控制器
  private swiperController: SwiperController = new SwiperController();
  // swiper显示数据
  private swiperData: Resource[] = [
    $r("app.media.status_bar_animation_page1"),
    $r("app.media.status_bar_animation_page2"),
    $r("app.media.status_bar_animation_page3")
  ];

  build() {
    Column() {
      Swiper(this.swiperController) {
        ForEach(this.swiperData, (item: Resource) => {
          Image(item)
            .width(Constants.FULL_PERCENT)
            .height(Constants.FULL_PERCENT)
        })
      }
      .width(Constants.FULL_PERCENT)
      // TODO: 知识点：当列表回滚到顶部继续下拉负值时，Banner放大效果。
      .height(`calc(${Constants.BANNER_HEIGHT_PERCENT} - ${this.increaseBannerHeight}vp)`)
      .loop(true)
      .autoPlay(true)
      .indicator(false)
    }
  }
}