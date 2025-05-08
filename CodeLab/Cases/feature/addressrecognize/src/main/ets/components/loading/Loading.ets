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

import { promptAction } from '@kit.ArkUI'
import { GlobalContext } from './GlobalContext'

@Builder
export function customDialogBuilder(content: string | Resource) {
  Column() {
    LoadingProgress()
      .width($r('app.integer.addressrecognize_bottom_row_height'))
      .height($r('app.integer.addressrecognize_bottom_row_height'))
    Text(content)
      .fontSize($r('app.integer.addressrecognize_font_size_16'))
  }
  .backgroundColor(Color.Transparent)
  .justifyContent(FlexAlign.Center)
}

/**
 * 加载loading
 * @param msg
 * @returns number
 */
export function loading(msg: string | Resource): Promise<number> {
  const that = GlobalContext.getContext().getObject('UIContext') as UIContext;
  let result = promptAction.openCustomDialog({
    backgroundColor: Color.Transparent,
    maskColor: $r('app.color.addressrecognize_loading_mask_color'),
    autoCancel: false,
    builder: customDialogBuilder.bind(that, msg),
  })
  return result;
}

/**
 * 消除loading
 * @param loadingId
 */
export function clearLoading(loadingId: number) {
  promptAction.closeCustomDialog(loadingId);
}