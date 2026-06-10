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

import distributedKVStore from '@ohos.data.distributedKVStore';
import { common } from '@kit.AbilityKit';
import { Router } from '@ohos.arkui.UIContext'
import { BusinessError } from '@kit.BasicServicesKit';

const context = AppStorage.get<common.UIAbilityContext>("EntryAbilityContext") as common.UIAbilityContext;

@Entry
@Component
struct CreateKVManagerTest {
  @State consoleInfo: string = "";
  @State context: common.BaseContext = context;
  @State bundleName: string = "com.example.distributedkvstoretest";
  @State router: Router = this.getUIContext().getRouter();

  private kvManager: distributedKVStore.KVManager | undefined = undefined;

  scroller: Scroller = new Scroller()
  scroller2: Scroller = new Scroller()

  build() {
    Column() {
      Row() { // 导航栏
        Navigation() {
        }
        .height('100%')
        .width('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        .title('createKVManager测试')
        .mode(NavigationMode.Stack);
      } // 导航栏
      .height(56)
      .width('100%')
      .onClick(async () => {
        this.router.back();
      });

      Row() { //这一行放了返回之外的一整页
        Column() {
          // 结果显示
          Column() {
            Column() {
              Scroll(this.scroller) {
                Row({ space: 10 }) {
                  Text("结果: " + this.consoleInfo)
                    .fontSize(18)
                    .margin({ top: 3 })
                    .fontColor('#182431')
                    .fontWeight(500);
                }.width('100%')
                .margin({ top: 5 });
              }
            }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
          }
          .height(120)
          .width('100%')
          .padding({ left: '3.35%', right: '3.35%' })
          .backgroundColor(Color.White)
          .margin({ bottom: 16 })
          .borderRadius(24)

          Column() { // 界面部分
            Scroll(this.scroller2) {
              Column() {
                Column() { // 参数设置区域
                  Column() {
                    Row({ space: 10 }) {
                      Text('KVManagerConfig参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项1
                    Row() {
                      Text("context: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ right: 4 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: "context" }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value("context")
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.context = context
                              break
                            case 1:
                              this.context = null!
                              break
                            case 2:
                              this.context = undefined!
                              break
                          }
                        })
                    }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                    // 参数选项2
                    Row() {
                      Text("bundleName: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ right: 4 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"com.example.distributedkvstoretest"' }, { value: "长度257的字符串" }, { value: "\"\"" }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"com.example.distributedkvstoretest"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.bundleName = "com.example.distributedkvstoretest"
                              break
                            case 1:
                              this.bundleName = "s".repeat(257);
                              break
                            case 2:
                              this.bundleName = ""
                              break
                            case 3:
                              this.bundleName = null!
                              break
                            case 4:
                              this.bundleName = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '60%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                }
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("createKVManager")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    let kvManagerConfig: distributedKVStore.KVManagerConfig = {
                      context: this.context,
                      bundleName: this.bundleName,
                    }

                    try {
                      let kvManager = distributedKVStore.createKVManager(kvManagerConfig);
                      if (kvManager !== undefined) {
                        this.consoleInfo = "KVManager创建成功";
                        this.kvManager = kvManager;
                      } else {
                        this.consoleInfo = "创建KVManager返回 undefined";
                      }
                    } catch (error) {
                      this.consoleInfo = `KVManager创建失败，code: ${error.code}，message: ${error.message}`;
                    }
                  }).margin({ bottom: 10 })

                Button("获取数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.kvManager != undefined) {
                        let options: distributedKVStore.Options = {
                          securityLevel: distributedKVStore.SecurityLevel.S3,
                        };

                        this.kvManager.getKVStore("temp", options).then((data: distributedKVStore.SingleKVStore) => {
                          this.consoleInfo = "数据库获取成功";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `数据库获取失败，code: ${error.code}，message: ${error.message}`;
                        })

                        try {
                          await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "temp");
                        } catch (error) {}
                      } else {
                        this.consoleInfo = "请先创建KVManager";
                      }
                    } catch (error) {
                      this.consoleInfo = `数据库获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })

              }
            }
          }.height('75%') // 界面部分
        }.width('100%').height('100%')

      } // 整页
      .width('100%')
      .padding({ left: '3.35%', right: '3.35%' })
      .margin({ bottom: 20 })
      .borderRadius(24)
    }
    .width('100%')
    .backgroundColor('#f1f3f5')
  }
}