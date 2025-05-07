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

import { ActionItem } from "../model/ActionItem";
import { ActionSectionView } from "../view/ActionSectionView";

/**
 * 安全设置底部弹窗视图
 */
@Component
export struct SecuritySettingView {

  private sectionActionItems: ActionItem[] =
    [{ id: '0', title: $r('app.string.limited_height_bottom_dialog_account_center'), subTitle: '' },
      { id: '1', title: $r('app.string.limited_height_bottom_dialog_modify_password'), subTitle: '' },
      { id: '2', title: $r('app.string.limited_height_bottom_dialog_wallet'), subTitle: '' },
      { id: '3', title: $r('app.string.limited_height_bottom_dialog_pay'), subTitle: '' }]

  build() {
    Column() {
      ActionSectionView({
        actionItems: this.sectionActionItems
      })
    }.width($r('app.string.limited_height_bottom_dialog_full_width'))
    .padding({
      left: $r('app.integer.limited_height_bottom_dialog_common_setting_left_and_right_padding'),
      right: $r('app.integer.limited_height_bottom_dialog_common_setting_left_and_right_padding'),
      top: $r('app.integer.limited_height_bottom_dialog_common_setting_top_padding')
    })
  }

}