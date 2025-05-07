import Constants from "../../common/Constants"

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
/**
 * 计算全模态弹窗位置类
 */
export class PopupPosition {
  /**
   * 设置弹窗居中。
   * @param displayWidth
   * @param displayHeight
   * @param snapPopupWidth
   * @param snapPopupHeight
   * @returns
   */
  static calculatePopupCenter(displayWidth: number, displayHeight: number, snapPopupWidth: number,
    snapPopupHeight: number): Position {

    return {
      x: (displayWidth - snapPopupWidth) / 2,
      y: (displayHeight - snapPopupHeight) / 2
    }
  }

  /**
   * 设置弹窗位置为左下。
   * @param displayHeight
   * @param snapPopupHeight
   * @returns
   */
  static calculatePopupBottomLeft(displayHeight: number, snapPopupHeight: number): Position {

    return {
      x: Constants.POPUP_MARGIN_LEFT,
      y: displayHeight - snapPopupHeight - Constants.POPUP_MARGIN_BOTTOM
    }
  }
}