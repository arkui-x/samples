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

import bridge from '@arkui-x.bridge';
import deviceInfo from '@ohos.deviceInfo';
import Logger from '../util/Logger';
import { TitleBar } from 'titleBar';
import { CommonItemSelect } from './CommonItemSelect'

const TAG: string = '[BridgePage] '
const osFullNameInfo: string = deviceInfo.osFullName
const platform = osFullNameInfo.split(' ')[0]

function methodOfTs(stringParam: string) {
  Logger.info(TAG, '原生侧调用Ts侧函数成功');
  return 'Ts methodOfTs return success. ' + stringParam;
}

@Entry
@Component
struct BridgePage {
  private bridgeImpl: undefined | bridge.BridgeObject = undefined;
  private bridgeCodec: undefined | bridge.BridgeObject = undefined;
  private BridgeTask: undefined | bridge.BridgeObject = undefined;
  @State callMethodFlag: boolean = false;
  @State sendMessageFlag: boolean = false;
  @State btnWidth: string = '55%';
  @State btnHeight: number = 40;
  @State title: string = 'PlatformBridge';
  @State nativeResponse: string = '';
  @State receivePlatformSendMessage: string = '';


  aboutToAppear(): void {
    Logger.info(TAG, 'The Device Platform is :' + JSON.stringify(platform));
    if (platform == 'Android' || platform == 'iOS') {
      this.bridgeImpl = bridge.createBridge('Bridge');
      if (this.bridgeImpl != undefined) {
        this.bridgeImpl.setMessageListener((data) => {
          Logger.info(TAG, 'Bridge JSON setMessageListener: ' + data);
          this.receivePlatformSendMessage = JSON.stringify(data);
          return data;
        });
      }
      this.bridgeCodec = bridge.createBridge('BridgeCodec', bridge.BridgeType.BINARY_TYPE);
      if (this.bridgeImpl != undefined) {
        this.bridgeCodec.setMessageListener((data) => {
          Logger.info(TAG, 'Bridge Codec setMessageListener: ' + data);
          this.receivePlatformSendMessage = JSON.stringify(data);
          return data;
        });
      }
      this.BridgeTask = bridge.createBridge('BridgeTask', bridge.BridgeType.BINARY_TYPE);
      if (this.BridgeTask != undefined) {
        this.BridgeTask.setMessageListener((data) => {
          Logger.info(TAG, 'Bridge Task setMessageListener: ' + data);
          this.receivePlatformSendMessage = JSON.stringify(data);
          return data;
        });
      }
    }
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.PlatformBridge_title') })
      Column() {
        Row() {
          Column() {
            Column() {
              Scroll() {
                Column() {
                  if (this.sendMessageFlag) {
                    Text('注册函数被调用结果: ' + this.receivePlatformSendMessage)
                      .fontSize(20)
                      .margin(5)
                  }

                  if (this.callMethodFlag) {
                    Text('原生侧返回结果: ' + this.nativeResponse)
                      .fontSize(20)
                      .margin(5)
                  }
                }
              }.scrollBar(BarState.Off)
            }
            .size({ width: '98%', height: '40%' })
            .border({
              width: 3,
              color: Color.Grey,
              radius: 30,
              style: BorderStyle.Solid
            })
            .margin({ top: 10, bottom: 10 })
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)


            Divider().size({ width: '100%', height: 3 }).backgroundColor(Color.Black).margin({ top: 20, bottom: 20 })

            Column() {
              Scroll() {
                Column({ space: 2 }) {
                  CommonItemSelect({
                    name: 'JSON模式(默认模式)',
                    selects: ['sendMessage JSON_TYPE', 'callMethod JSON_TYPE', 'callMethodWithCallback JSON_TYPE'],
                    callback: (index) => {
                      switch (index) {
                        case 0:
                          if (this.bridgeImpl != undefined) {
                            this.bridgeImpl.sendMessage('(JSON_TYPE)').then((res) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '发送数据到原生侧响应成功, 返回数据为 ' + res;
                              Logger.info(TAG, this.nativeResponse);
                            }).catch((err: Error) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '发送数据到原生侧响应失败： ' + err;
                              Logger.info(TAG, this.nativeResponse);
                            });
                          }
                          break
                        case 1:
                          if (this.bridgeImpl != undefined) {
                            this.bridgeImpl.callMethod('getHelloArkUI', '(JSON_TYPE)').then((res) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '调用原生侧函数调用成功, 返回数据为 ' + res;
                              Logger.info(TAG, this.nativeResponse);
                            }).catch((err: Error) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '调用原生侧函数调用失败： ' + err;
                              Logger.info(TAG, this.nativeResponse);
                            });
                          }
                          break
                        case 2:
                          if (this.bridgeImpl != undefined) {
                            this.bridgeImpl.callMethodWithCallback('methodOfPlatform', methodOfTs, '(JSON_TYPE)')
                              .then((res) => {
                                this.sendMessageFlag = true;
                                this.callMethodFlag = true;
                                this.nativeResponse = '注册Ts侧函数并调用原生侧函数调用成功, 返回数据为 ' + res;
                              })
                              .catch((err: Error) => {
                                this.sendMessageFlag = true;
                                this.callMethodFlag = true;
                                this.nativeResponse = '注册Ts侧函数并调用原生侧函数失败： ' + err;
                              });
                          }
                          break
                        default:
                      }
                    }
                  })

                  CommonItemSelect({
                    name: '二进制编解码模式',
                    selects: ['sendMessage BINARY_TYPE', 'callMethod BINARY_TYPE',
                      'callMethodWithCallback BINARY_TYPE'],
                    callback: (index) => {
                      switch (index) {
                        case 0:
                          if (this.bridgeCodec != undefined) {
                            this.bridgeCodec.sendMessage('(BINARY_TYPE)').then((res) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '发送数据到原生侧响应成功, 返回数据为 ' + res;
                              Logger.info(TAG, this.nativeResponse);
                            }).catch((err: Error) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '发送数据到原生侧响应失败： ' + err;
                              Logger.info(TAG, this.nativeResponse);
                            });
                          }
                          break
                        case 1:
                          if (this.bridgeCodec != undefined) {
                            this.bridgeCodec.callMethod('getHelloArkUI', '(BINARY_TYPE)').then((res) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '调用原生侧函数调用成功, 返回数据为 ' + res;
                              Logger.info(TAG, this.nativeResponse);
                            }).catch((err: Error) => {
                              this.nativeResponse = '调用原生侧函数调用失败： ' + err;
                              Logger.info(TAG, this.nativeResponse);
                            });
                          }
                          break
                        case 2:
                          if (this.bridgeCodec != undefined) {
                            this.bridgeCodec.callMethodWithCallback('methodOfPlatform', methodOfTs, '(BINARY_TYPE)')
                              .then((res) => {
                                this.sendMessageFlag = true;
                                this.callMethodFlag = true;
                                this.nativeResponse = '注册Ts侧函数并调用原生侧函数调用成功, 返回数据为 ' + res;
                              })
                              .catch((err: Error) => {
                                this.sendMessageFlag = true;
                                this.callMethodFlag = true;
                                this.nativeResponse = '注册Ts侧函数并调用原生侧函数失败： ' + err;
                              });
                          }
                          break
                        default:
                      }
                    }
                  })

                  CommonItemSelect({
                    name: '并发模式',
                    selects: ['sendMessage TaskType', 'callMethod TaskType',
                      'callMethodWithCallback TaskType'],
                    callback: (index) => {
                      switch (index) {
                        case 0:
                          if (this.BridgeTask != undefined) {
                            this.BridgeTask.sendMessage('(TaskType)').then((res) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '发送数据到原生侧响应成功, 返回数据为 ' + res;
                              Logger.info(TAG, this.nativeResponse);
                            }).catch((err: Error) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '发送数据到原生侧响应失败： ' + err;
                              Logger.info(TAG, this.nativeResponse);
                            });
                          }
                          break
                        case 1:
                          if (this.BridgeTask != undefined) {
                            this.BridgeTask.callMethod('getHelloArkUI', '(TaskType)').then((res) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '调用原生侧函数调用成功, 返回数据为 ' + res;
                              Logger.info(TAG, this.nativeResponse);
                            }).catch((err: Error) => {
                              this.sendMessageFlag = false;
                              this.callMethodFlag = true;
                              this.nativeResponse = '调用原生侧函数调用失败： ' + err;
                              Logger.info(TAG, this.nativeResponse);
                            });
                          }
                          break
                        case 2:
                          if (this.BridgeTask != undefined) {
                            this.BridgeTask.callMethodWithCallback('methodOfPlatform', methodOfTs, '(TaskType)')
                              .then((res) => {
                                this.sendMessageFlag = true;
                                this.callMethodFlag = true;
                                this.nativeResponse = '注册Ts侧函数并调用原生侧函数调用成功, 返回数据为 ' + res;
                              })
                              .catch((err: Error) => {
                                this.sendMessageFlag = true;
                                this.callMethodFlag = true;
                                this.nativeResponse = '注册Ts侧函数并调用原生侧函数失败： ' + err;
                              });
                          }
                          break
                        default:
                      }
                    }
                  })

                }
              }.scrollBar(BarState.Off)
            }.size({ width: '100%', height: '40%' })

          }
          .width('100%')
        }
        .height('100%')
      }
    }
  }
}
