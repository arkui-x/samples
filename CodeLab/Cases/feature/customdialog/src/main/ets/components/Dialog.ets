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

import { CustomDialogView } from './CustomDialogView';

@Component
export struct Dialog {
  // 监听外部传入的visible变量，visible值发生变化时触发onChange回调函数
  @Watch("onChange") @Link visible: boolean;
  onCancel?: () => void;
  onConfirm?: () => void;
  // 通过CustomDialogController的builder参数绑定弹窗组件CustomDialogView
  private controller = new CustomDialogController({
    builder: CustomDialogView({
      visible: $visible,
      onCancel: this.onCancel,
      onConfirm: this.onConfirm,
    }),
    autoCancel: false,
    customStyle: true,
    alignment: DialogAlignment.Center,
    maskColor: $r('app.string.custom_dialog_mask_color'),
  })

  /**
   * 当visible的值变化时触发回调
   */
  onChange(): void{
    if (this.visible) {
      this.controller.open();
    } else {
      this.controller.close();
    }
  }

  // 二次封装的Dialog组件主要通过控制器控制弹窗，不需要任何界面
  build() {
  }
}