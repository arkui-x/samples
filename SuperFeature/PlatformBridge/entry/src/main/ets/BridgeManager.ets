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
import { BridgeUtil } from './BridgeUtil'

const LOG_TAG: string = '[ArkTS][BridgeManager]:: '

class BridgeManager {
  private static instance: BridgeManager = new BridgeManager()
  private bridgeMap: Map<string, BridgeUtil> = new Map<string, BridgeUtil>()

  public static getInstance(): BridgeManager {
    return BridgeManager.instance
  }

  public checkBridge(): boolean {
    let res: boolean = false
    res = this.bridgeMap.has('BridgeJsonObject')
    res = (res && this.bridgeMap.has('BridgeBinaryObject'))
    return res
  }

  /**
   * 根据 name 获取对应的 Bridge 实例
   * 如果该 name 对应的 Bridge 还不存在，则会创建一个新的 Bridge 并存入 Map
   * 如果现有 Bridge 不可用，会调用 unRegister 释放资源并从 Map 移除
   *
   * @param name       Bridge名称；既是Bridge对象的唯一标识，也是map中的key值
   * @param bridgeType Bridge的编码模式
   * @return 可用的 Bridge 对象，如果不可用或创建失败返回 null
   */
  public get(name: string, bridgeType: bridge.BridgeType): BridgeUtil | null {
    if (name == null || name == undefined || bridgeType == null || bridgeType == undefined) {
      console.error(LOG_TAG + "Invalid argument")
      return null
    }

    let bridgeTemp: BridgeUtil | undefined

    bridgeTemp = this.bridgeMap.get(name)
    if (bridgeTemp != null && bridgeTemp != undefined) {
      return bridgeTemp
    }

    bridgeTemp = new BridgeUtil(name, bridgeType)
    if (bridgeTemp == null || bridgeTemp == undefined) {
      console.error(LOG_TAG + "Create new bridge failed")
      return null
    }

    this.bridgeMap.set(name, bridgeTemp)
    return bridgeTemp
  }
}

export let bridgeManager = new BridgeManager()
