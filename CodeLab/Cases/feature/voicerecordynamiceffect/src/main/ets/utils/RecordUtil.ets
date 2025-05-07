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

import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { CommonConstants as Const } from '../common/CommonConstants';
import { VerifyModeEnum } from '../enums/VerifyModeEnum';

/**
 * 申请权限
 * @param permissions
 * @param context
 */
export function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    const granStatus: Array<number> = data.authResults;
    const length: number = granStatus.length;
    for (let i = 0; i < length; i++) {
      if (granStatus[i] === 0) {

      } else {
        return;
      }
    }
  })
}

/**
 * 根据偏移计算模式：0=语音录制，1=转文字，2=取消
 * @param offsetX
 * @param offsetY
 * @returns
 */
export function getMode(offsetX: number, offsetY: number): number {
  if (offsetX < 0) {
    return offsetY <= Const.GESTURE_DISTANCE ? VerifyModeEnum.CANCEL : VerifyModeEnum.VOICE;
  } else {
    return offsetY <= Const.GESTURE_DISTANCE ? VerifyModeEnum.TEXT : VerifyModeEnum.VOICE;
  }
}