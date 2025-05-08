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

/*
 * Custom dialog for loading.
 */
@CustomDialog
export struct CustomLoadingDialog {
  private controller: CustomDialogController;
  private content: string | Resource = '';

  build() {
    Column() {
      LoadingProgress()
        .width($r('app.integer.video_create_gif_dialog_loading_width'))
        .height($r('app.integer.video_create_gif_dialog_loading_width'))
        .color(Color.Blue)

      Text(this.content)
        .fontSize($r('app.integer.video_create_gif_small_font_size'))
        .fontColor(Color.Black)
    }
    .width($r('app.integer.video_create_gif_dialog_width'))
    .height($r('app.integer.video_create_gif_dialog_width'))
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
