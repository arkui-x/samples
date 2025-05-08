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

import { promptAction } from '@kit.ArkUI'
import { DialogTypeEnum } from '../enum/DialogTypeEnum'
import { AnimationUtil } from './AnimationUtil';

export class DialogOptionsFactory {
  /**
   * 工厂方法，拿到option
   * @param dialogType
   * @returns
   */
  public static getOptionsByDialogType(dialogType: DialogTypeEnum): promptAction.BaseDialogOptions {
    let options: promptAction.BaseDialogOptions = {
      maskColor: Color.Transparent,
      autoCancel: false
    };
    switch (dialogType) {
      case DialogTypeEnum.BOTTOM:
        DialogOptionsFactory.fillBottomOption(options);
        break;
      case DialogTypeEnum.CENTER:
        DialogOptionsFactory.fillCenterOption(options);
        break;
      case DialogTypeEnum.TOP:
        DialogOptionsFactory.fillTopOption(options);
        break;
    }
    return options;
  }

  private static fillTopOption(options: promptAction.BaseDialogOptions) {
    options.alignment = DialogAlignment.Top;
    options.transition = AnimationUtil.transitionFromUp(200);
  }

  private static fillCenterOption(options: promptAction.BaseDialogOptions) {
    options.alignment = DialogAlignment.Center;
    options.transition = AnimationUtil.transitionFromCenter(200);
  }

  private static fillBottomOption(options: promptAction.BaseDialogOptions) {
    options.alignment = DialogAlignment.Bottom;
    options.transition = AnimationUtil.transitionFromDown(200);
  }
}