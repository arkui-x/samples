/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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
import { JSON } from '@kit.ArkTS'
import { BusinessError } from '@kit.BasicServicesKit'

export const LOG_TAG: string = '[ArkTS][BridgeUtil]:: '

export class BridgeUtil {
  private bridgeObject: bridge.BridgeObject
  public ArkTSMethod = (...parameters: bridge.Message[]): bridge.ResultValue => {
    return `ArkTS侧函数(ArkTSMethod)被调用成功，param为：(${parameters[0]})`
  }
  public ArkTSMethodSync = (...parameters: bridge.Message[]): bridge.ResultValue => {
    return `ArkTS侧函数(ArkTSMethodSync)被调用成功，param为：(${parameters[0]})`
  }

  constructor(name: string, bridgeType: bridge.BridgeType) {
    this.bridgeObject = bridge.createBridge(name, bridgeType)
    this.setListener()
    this.registerMethod()
  }

  private setListener() {
    this.bridgeObject.setMessageListener((data) => {
      return `这里是<ArkTS>,<Native>通过sendMessage 发送的数据为（${data?.toString()}）`
    })
  }

  private registerMethod() {
    this.bridgeObject.registerMethod({ name: 'ArkTSMethod', method: this.ArkTSMethod })
      .catch((error: BusinessError) => {
        console.error(LOG_TAG + 'registerMethod func ArkTSMethod failed; error is ' + JSON.stringify(error))
      })
    this.bridgeObject.registerMethod({ name: 'ArkTSMethodSync', method: this.ArkTSMethodSync })
      .catch((error: BusinessError) => {
        console.error(LOG_TAG + 'registerMethod func ArkTSMethodSync failed; error is ' + JSON.stringify(error))
      })
  }

  public getBridge(): bridge.BridgeObject {
    return this.bridgeObject
  }
}
