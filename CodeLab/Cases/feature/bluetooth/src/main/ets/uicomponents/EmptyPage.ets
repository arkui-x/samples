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
export default struct EmptyPage {
  private img: string | PixelMap | Resource = $r('app.media.bg_empty_page');
  private message: ResourceStr = $r('app.string.ble_tv_no_device');

  build() {
    Column() {
      Image(this.img)
        .width($r('app.integer.ble_empty_image_width'))
        .aspectRatio(1)

      Text(this.message)
        .fontSize($r('app.float.ble_text_size_normal'))
        .fontColor($r('app.color.ble_text_color_tertiary'))
        .margin({ top: $r('app.integer.ble_margin_top') })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}