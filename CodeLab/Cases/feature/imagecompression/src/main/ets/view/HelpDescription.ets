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

// 自定义帮助组件
@Component
export struct HelpDescription {
  @State isShow: boolean = false;
  @Prop info: string | Resource = '';

  /**
   * popup构造器定义弹框内容
   */
  @Builder
  popupBuilder() {
    Column() {
      Text(this.info).fontSize($r('app.integer.image_compression_font_size_fourteen'))
    }
    .justifyContent(FlexAlign.SpaceAround)
    .padding($r('app.integer.image_compression_padding_thirteen'))
  }

  build() {
    Image($r("app.media.image_compression_help"))
      .width($r('app.integer.image_compression_eighteen'))
      .onClick(() => {
        // 创建点击事件，控制弹窗显隐
        this.isShow = !this.isShow;
      })
      .bindPopup(this.isShow, {
        builder: this.popupBuilder, onStateChange: (e) => {
          // 使用bindPopup接口将弹窗内容绑定给元素
          if (!e.isVisible) {
            this.isShow = false;
          }
        }
      })
  }
}