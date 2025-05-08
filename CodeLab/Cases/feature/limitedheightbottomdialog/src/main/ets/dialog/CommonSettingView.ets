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
 * 常用设置底部弹窗视图
 */
@Component
export struct CommonSettingView {

  private firstSectionActionItems: ActionItem[] =
    [{ id: '0', title: $r('app.string.limited_height_bottom_dialog_shipping_address'), subTitle: '' },
      { id: '1', title: $r('app.string.limited_height_bottom_dialog_my_file'), subTitle: '' },
      { id: '2', title: $r('app.string.limited_height_bottom_dialog_invoice_management'), subTitle: '' }]

  private secondSectionActionItems: ActionItem[] =
    [{ id: '3', title: $r('app.string.limited_height_bottom_dialog_mode_switch'), subTitle: '' },
      { id: '4', title: $r('app.string.limited_height_bottom_dialog_theme_skin_peeler'), subTitle: '' },
      { id: '5', title: $r('app.string.limited_height_bottom_dialog_dark_mode'), subTitle: '' }]

  private thirdSectionActionItems: ActionItem[] =
    [{ id: '6', title: $r('app.string.limited_height_bottom_dialog_clear_cache'), subTitle: '' },
      { id: '7', title: $r('app.string.limited_height_bottom_dialog_message_notification'), subTitle: '' },
      { id: '8', title: $r('app.string.limited_height_bottom_dialog_personalized_recommendation'), subTitle: '' },
      { id: '9', title: $r('app.string.limited_height_bottom_dialog_network_detection'), subTitle: '' }]

  private forthSectionActionItems: ActionItem[] =
    [{ id: '10', title: $r('app.string.limited_height_bottom_dialog_personal_information_collection_list'), subTitle: '' },
      { id: '11', title: $r('app.string.limited_height_bottom_dialog_third_party_sharing_personal_information_list'), subTitle: '' },
      { id: '12', title: $r('app.string.limited_height_bottom_dialog_service_agreement'), subTitle: '' },
      { id: '13', title: $r('app.string.limited_height_bottom_dialog_privacy_statement'), subTitle: '' }]

  build() {
    Column() {
      ActionSectionView({
        actionItems: this.firstSectionActionItems
      })

      ActionSectionView({
        actionItems: this.secondSectionActionItems
      }).margin({
        top: $r('app.integer.limited_height_bottom_dialog_section_gap')
      })

      ActionSectionView({
        actionItems: this.thirdSectionActionItems
      }).margin({
        top: $r('app.integer.limited_height_bottom_dialog_section_gap')
      })

      ActionSectionView({
        actionItems: this.forthSectionActionItems
      }).margin({
        top: $r('app.integer.limited_height_bottom_dialog_section_gap')
      })
    }.width($r('app.string.limited_height_bottom_dialog_full_width'))
    .padding({
      left: $r('app.integer.limited_height_bottom_dialog_common_setting_left_and_right_padding'),
      right: $r('app.integer.limited_height_bottom_dialog_common_setting_left_and_right_padding'),
      top: $r('app.integer.limited_height_bottom_dialog_common_setting_top_padding')
    })
  }

}