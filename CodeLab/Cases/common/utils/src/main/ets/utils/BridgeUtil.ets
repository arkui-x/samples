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

import bridge from '@arkui-x.bridge'
import { logger } from './Logger'
import { PlatformInfo, PlatformTypeEnum } from './PlatformInfo'

const TAG = '[BridgeUtil]'

/*
 * 平台桥接用于客户端（ArkUI）和平台（Android或iOS）之间传递消息，即用于ArkUI与平台双向数据传递。
 * 功能限制： 仅支持APP于Android或iOS平台运行时使用
 */
export class BridgeUtil {
  private static instance: BridgeUtil
  private bridgeImpl: bridge.BridgeObject | null = null

  public static getInstance(): BridgeUtil {
    if (!BridgeUtil.instance) {
      BridgeUtil.instance = new BridgeUtil()
    }
    return BridgeUtil.instance
  }

  private constructor() {
    if (!this.isArkUIX()) {
      return
    }
    this.bridgeImpl = bridge.createBridge('BridgeUtil')
  }

  private isArkUIX(): boolean {
    return PlatformInfo.isArkUIX() ? true : false
  }

  public exit(): void {
    if (!this.isArkUIX()) {
      return
    }
    this.bridgeImpl?.callMethod('exit')
  }

  public setStatusBar(): void {
    if (!this.isArkUIX()) {
      return;
    }
    this.bridgeImpl?.sendMessage("ResetStatusBar");
  }

  public startSms(platform: string): void {
    if (!this.isArkUIX()) {
      return;
    }
    if (platform === 'Android') {
      this.bridgeImpl?.sendMessage("startSms");
    } else if (platform === 'iOS') {
      this.bridgeImpl?.callMethod("sendSMS");
    }
  }
}