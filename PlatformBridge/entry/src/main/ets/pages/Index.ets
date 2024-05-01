/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

function methodOfTs(stringParam: string) {
  console.log("原生侧调用Ts侧函数成功");
  return "Ts methodOfTs return success. " + stringParam;
}

@Entry
@Component
struct Index {
  private bridgeImpl = bridge.createBridge('Bridge');
  private bridgeCodec = bridge.createBridge("BridgeCodec", bridge.BridgeType.BINARY_TYPE);
  private BridgeTask = bridge.createBridge("BridgeTask", bridge.BridgeType.BINARY_TYPE);
  @State btnWidth: string = "75%";
  @State btnHeight: number = 50;
  @State title: string = 'PlatformBridge Demo';
  @State nativeResponse: string = '';
  @State receivePlatformSendMessage: string = '';

  onPageShow(): void {
    this.bridgeImpl.setMessageListener((data) => {
      console.log("Bridge JSON setMessageListener: " + data);
      this.receivePlatformSendMessage = JSON.stringify(data);
      return data;
    });
    this.bridgeCodec.setMessageListener((data) => {
      console.log("Bridge Codec setMessageListener: " + data);
      this.receivePlatformSendMessage = JSON.stringify(data);
      return data;
    });
    this.BridgeTask.setMessageListener((data) => {
      console.log("Bridge Task setMessageListener: " + data);
      this.receivePlatformSendMessage = JSON.stringify(data);
      return data;
    });
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          Text(this.title)
            .fontSize(35)
            .margin(5)

          Text('原生侧返回结果: ' + this.nativeResponse)
            .fontSize(20)
            .margin(5)

          Text('注册函数被调用结果: ' + this.receivePlatformSendMessage)
            .fontSize(20)
            .margin(5)

          Text("Bridge JSON模式(默认模式)")
            .fontSize(20)
            .margin(5)

          Button('sendMessage JSON_TYPE')
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(async () => {
              this.bridgeImpl.sendMessage("(JSON_TYPE)").then((res) => {
                this.nativeResponse = '发送数据到原生侧响应成功, 返回数据为 ' + res;
                console.log(this.nativeResponse);
              }).catch((err: Error) => {
                this.nativeResponse = '发送数据到原生侧响应失败： ' + err;
                console.log(this.nativeResponse);
              });
            })

          Button('callMethod JSON_TYPE')
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(async () => {
              this.bridgeImpl.callMethod('getHelloArkUI', "(JSON_TYPE)").then((res) => {
                this.nativeResponse = '调用原生侧函数调用成功, 返回数据为 ' + res;
                console.log(this.nativeResponse);
              }).catch((err: Error) => {
                this.nativeResponse = '调用原生侧函数调用失败： ' + err;
                console.log(this.nativeResponse);
              });
            })

          Button("callMethodWithCallback JSON_TYPE")
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              this.bridgeImpl.callMethodWithCallback("methodOfPlatform", methodOfTs, "(JSON_TYPE)").then((res) => {
                this.nativeResponse = '注册Ts侧函数并调用原生侧函数调用成功, 返回数据为 ' + res;
              })
                .catch((err: Error) => {
                  this.nativeResponse = '注册Ts侧函数并调用原生侧函数失败： ' + err;
                });
            })

          Text("Bridge 二进制编解码模式")
            .fontSize(20)
            .margin(5)

          Button('sendMessage BINARY_TYPE')
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(async () => {
              this.bridgeCodec.sendMessage('(BINARY_TYPE)').then((res) => {
                this.nativeResponse = '发送数据到原生侧响应成功, 返回数据为 ' + res;
                console.log(this.nativeResponse);
              }).catch((err: Error) => {
                this.nativeResponse = '发送数据到原生侧响应失败： ' + err;
                console.log(this.nativeResponse);
              });
            })

          Button('callMethod BINARY_TYPE')
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(async () => {
              this.bridgeCodec.callMethod('getHelloArkUI', "(BINARY_TYPE)").then((res) => {
                this.nativeResponse = '调用原生侧函数调用成功, 返回数据为 ' + res;
                console.log(this.nativeResponse);
              }).catch((err: Error) => {
                this.nativeResponse = '调用原生侧函数调用失败： ' + err;
                console.log(this.nativeResponse);
              });
            })

          Button("callMethodWithCallback BINARY_TYPE")
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              this.bridgeCodec.callMethodWithCallback("methodOfPlatform", methodOfTs, "(BINARY_TYPE)").then((res) => {
                this.nativeResponse = '注册Ts侧函数并调用原生侧函数调用成功, 返回数据为 ' + res;
              })
                .catch((err: Error) => {
                  this.nativeResponse = '注册Ts侧函数并调用原生侧函数失败： ' + err;
                });
            })

          Text("Bridge 并发模式")
            .fontSize(20)
            .margin(5)

          Button('sendMessage TaskType')
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(async () => {
              this.BridgeTask.sendMessage("(TaskType)").then((res) => {
                this.nativeResponse = '发送数据到原生侧响应成功, 返回数据为 ' + res;
                console.log(this.nativeResponse);
              }).catch((err: Error) => {
                this.nativeResponse = '发送数据到原生侧响应失败： ' + err;
                console.log(this.nativeResponse);
              });
            })

          Button('callMethod TaskType')
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(async () => {
              this.BridgeTask.callMethod('getHelloArkUI', "(TaskType)").then((res) => {
                this.nativeResponse = '调用原生侧函数调用成功, 返回数据为 ' + res;
                console.log(this.nativeResponse);
              }).catch((err: Error) => {
                this.nativeResponse = '调用原生侧函数调用失败： ' + err;
                console.log(this.nativeResponse);
              });
            })

          Button("callMethodWithCallback TaskType")
            .backgroundColor(Color.Gray)
            .width(this.btnWidth)
            .height(this.btnHeight)
            .fontSize(15)
            .margin(5)
            .onClick(() => {
              this.BridgeTask.callMethodWithCallback("methodOfPlatform", methodOfTs, "(TaskType)").then((res) => {
                this.nativeResponse = '注册Ts侧函数并调用原生侧函数调用成功, 返回数据为 ' + res;
              })
                .catch((err: Error) => {
                  this.nativeResponse = '注册Ts侧函数并调用原生侧函数失败： ' + err;
                });
            })

        }
        .width('100%')
      }
      .height('100%')
    }
  }
}