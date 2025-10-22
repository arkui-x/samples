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

import { BusinessError } from '@kit.BasicServicesKit'
import bridge from '@arkui-x.bridge'
import { common } from '@kit.AbilityKit'
import { bridgeManager } from '../BridgeManager'
import { BridgeUtil } from '../BridgeUtil'
import { JSON } from '@kit.ArkTS'

const JSON_TYPE: string = 'JSON_TYPE'
const BINARY_TYPE: string = 'BINARY_TYPE'

function callBackFunc() {
  return "ArkTS callBackFunc success."
}

@Entry
@Component
struct EnterPage {
  @State message: string = '平台桥接'
  @State bridgeType: string = JSON_TYPE
  @State javaMessage: bridge.Message = ""
  @State info: string = ''
  private bridgeUtil: BridgeUtil | null = null

  async sendMessageSample(dataType: string) {
    const senddata = `${dataType}`
    this.info = `1.向平台侧发送数据:\n\n【 ${senddata} 】\n\n`
    if (this.bridgeUtil == null) {
      this.info += `2.bridge为空`
      return
    }
    try {
      this.bridgeUtil.getBridge().sendMessage(senddata)
        .then((res: bridge.Response) => {
          this.info += `2.平台侧接收成功，返回数据为:\n\n【 ${JSON.stringify(res)} 】\n\n`
        })
        .catch((error: BusinessError) => {
          this.info += `2.平台侧接收失败，返回数据为:\n\n【 错误码:${error.code} , 错误信息:${error.message} 】\n\n`
        })
    } catch (err) {
      this.info += `2.平台侧接收失败，返回数据为:\n\n【 错误码:${err.code} , 错误信息:${err.message} 】\n\n`
    }
  }

  async callNativeMethod(dataType: string) {
    const senddata = `${dataType}`
    const funcName = 'nativeFunc'
    this.info = `1.调用平台侧方法:\n\n【 ${funcName}(${senddata}) 】\n\n`
    if (this.bridgeUtil == null) {
      this.info += `2.bridge为空`
      return
    }
    try {
      this.bridgeUtil.getBridge().callMethod(funcName, senddata)
        .then((res: bridge.ResultValue) => {
          this.info += `2.调用平台侧方法 ${funcName}() 成功，返回值为:\n\n【 ${JSON.stringify(res)} 】\n\n`
        })
        .catch((err: BusinessError) => {
          this.info += `2.调用平台侧方法 ${funcName}() 失败，返回值为:\n\n【 错误码:${err.code} , 错误信息${err.message} 】\n\n`
        })
    } catch (err) {
      this.info += `2.调用平台侧方法 ${funcName}() 失败，返回值为:\n\n【 错误码:${err.code} , 错误信息${err.message} 】\n\n`
    }
  }

  async callNativeMethodWithCallback(dataType: string) {
    const senddata = `${dataType}`
    const funcName = `nativeFuncWithCallback`
    this.info = `1.调用平台侧方法:\n\n【 ${funcName}(${senddata}) 】\n\n`
    if (this.bridgeUtil == null) {
      this.info += `2.bridge为空`
      return
    }
    try {
      this.bridgeUtil.getBridge().callMethodWithCallback(funcName, callBackFunc, senddata)
        .then((res: bridge.ResultValue) => {
          this.info += `2.调用平台侧方法 ${funcName}() 成功，返回值为:\n\n【 ${JSON.stringify(res)} 】\n\n`
        })
        .catch((err: BusinessError) => {
          this.info += `2.调用平台侧方法 ${funcName}() 失败，返回值为:\n\n【 错误码:${err.code} , 错误信息${err.message} 】\n\n`
        })
    } catch (err) {
      this.info += `2.调用平台侧方法 ${funcName}() 失败，返回值为:\n\n【 错误码:${err.code} , 错误信息${err.message} 】\n\n`
    }
  }

  async callNativeMethodSync(dataType: string) {
    const senddata = `${dataType}`
    const funcName = `nativeFuncSync`
    this.info = `1.调用平台侧方法:\n\n【 ${funcName}(${senddata}) 】\n\n`
    if (this.bridgeUtil == null) {
      this.info += `2.bridge为空`
      return
    }
    try {
      let res: bridge.ResultValue = this.bridgeUtil.getBridge().callMethodSync(funcName, senddata)
      this.info += `2.调用平台侧方法 ${funcName}() 成功，返回值为:\n\n【 ${JSON.stringify(res)} 】\n\n`
    } catch (err) {
      this.info += `2.调用平台侧方法 ${funcName}() 失败，返回值为:\n\n【 错误码:${err.code} , 错误信息${err.message} 】\n\n`
    }
  }

  onPageShow(): void {
    this.bridgeUtil = bridgeManager.get('BridgeJsonObject', bridge.BridgeType.JSON_TYPE)
    bridgeManager.get('BridgeBinaryObject', bridge.BridgeType.BINARY_TYPE)
  }

  build() {
    Row() {
      Column() {
        Row() {
        }.size({ width: '100%', height: 20 })

        Column() {
          Scroll() {
            Column() {
              Text(this.message)
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
                .margin(10)

              Row() {
                Button('Native')
                  .fontSize(14)
                  .size({ width: '30%', height: 45 })
                  .margin({ left: 10 })
                  .backgroundColor(Color.Pink)
                  .onClick(() => {
                    let context = getContext(this) as common.UIAbilityContext
                    context.startAbility({
                      bundleName: "com.example.bridge",
                      moduleName: "entry",
                      abilityName: "NativeAbility",
                    })
                  })

                Button('重置文本')
                  .fontSize(14)
                  .size({ width: '30%', height: 45 })
                  .margin({ left: 10 })
                  .backgroundColor(Color.Green)
                  .onClick(() => {
                    this.info = ''
                  })

                Button('切换Type')
                  .fontSize(14)
                  .size({ width: '30%', height: 45 })
                  .margin({ left: 10 })
                  .backgroundColor(Color.Green)
                  .onClick(() => {
                    if (this.bridgeType == 'JSON_TYPE') {
                      this.bridgeType = BINARY_TYPE
                      this.bridgeUtil = bridgeManager.get('BridgeBinaryObject', bridge.BridgeType.BINARY_TYPE)
                    } else if (this.bridgeType == 'BINARY_TYPE') {
                      this.bridgeType = JSON_TYPE
                      this.bridgeUtil = bridgeManager.get('BridgeJsonObject', bridge.BridgeType.JSON_TYPE)
                    }
                  })

              }
              .margin({ top: 10 })
              .width('95%')

              Text('BridgeType：' + this.bridgeType)
                .fontSize(18)
                .border({ width: 2 })
                .fontWeight(FontWeight.Bold)
                .borderRadius(5)
                .width('95%')
                .height(40)
                .textAlign(TextAlign.Center)
                .margin({ top: 15 })

              Text('操作日志：\n' + this.info)
                .fontSize(15)
                .border({ width: 2 })
                .fontWeight(FontWeight.Bold)
                .borderRadius(5)
                .width('95%')
                .height('60%')
                .margin({ top: 15 })

              Row() {
              }.size({ width: '95%', height: 10 })
            }
          }.scrollBar(BarState.Off)
        }.size({ width: '95%', height: '60%' })

        Column() {
          Scroll() {
            Column({ space: 2 }) {
              Column() {
                Button('sendMessage')
                  .fontSize(20)
                  .size({ width: '95%', height: 45 })
                  .margin({ top: 17 })
                  .onClick(async () => {
                    this.sendMessageSample(this.bridgeType)
                  })
                Button('callMethod')
                  .fontSize(20)
                  .size({ width: '95%', height: 45 })
                  .margin({ top: 17 })
                  .onClick(async () => {
                    this.callNativeMethod(this.bridgeType)
                  })
                Button('callMethodWithCallback')
                  .fontSize(20)
                  .size({ width: '95%', height: 45 })
                  .margin({ top: 17 })
                  .onClick(async () => {
                    this.callNativeMethodWithCallback(this.bridgeType)
                  })
                Button('callMethodSync')
                  .fontSize(20)
                  .size({ width: '95%', height: 45 })
                  .margin({ top: 17 })
                  .onClick(async () => {
                    this.callNativeMethodSync(this.bridgeType)
                  })
              }
            }
          }.scrollBar(BarState.Off)
        }.size({ width: '100%', height: '35%' })

        Row() {
        }.size({ width: '100%', height: 20 })
      }.width('100%')
    }.height('100%')
  }
}
