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
const kvManagerConfig: distributedKVStore.KVManagerConfig = {
  context: context,
  bundleName: "com.example.distributedkvstoretest"
}
const maxStoreIdLength: number = 128; // MAX_STORE_ID_LENGTH

@Entry
@Component
struct DeleteKVStoreTest {
  @State consoleInfo: string = "";

  private router: Router = this.getUIContext().getRouter();
  private appId: string = "com.example.distributedkvstoretest";
  private storeId: string = "storeId_3";

  private kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(kvManagerConfig);
  private singleKVStore: distributedKVStore.SingleKVStore | undefined = undefined;
  private uiContext: UIContext = this.getUIContext();

  scroller: Scroller = new Scroller();
  scroller2: Scroller = new Scroller();

  build() {
    Column() {
      Row() { // 导航栏
        Navigation() {
        }
        .height('100%')
        .width('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        .title('deleteKVStore测试')
        .mode(NavigationMode.Stack);
      } // 导航栏
      .height(56)
      .width('100%')
      .onClick(async () => {
        this.router.back();
      });

      Row() { //这一行放了返回之外的一整页
        Column() {
          // 结果log
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
          .height(100)
          .width('100%')
          .padding({ left: '3.35%', right: '3.35%' })
          .backgroundColor(Color.White)
          .margin({ bottom: 16 })
          .borderRadius(24)

          Column() { // 界面部分
            Scroll(this.scroller2) {
              Column() {
                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('deleteKVStore的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("appId: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"com.example.distributedkvstoretest"' }, { value: '"abc"' }, { value: '长度257的字符串' }, { value: "\"\"" }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"com.example.distributedkvstoretest"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.appId = "com.example.distributedkvstoretest"
                              break
                            case 1:
                              this.appId = "abc"
                              break
                            case 2:
                              this.appId = "s".repeat(257);
                              break
                            case 3:
                              this.appId = ""
                              break
                            case 4:
                              this.appId = null!
                              break
                            case 5:
                              this.appId = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '75%' })
                    }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                    // 参数选项
                    Row() {
                      Text("storeId: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"storeId_3"' }, { value: '"abc"' }, { value: "超长的字符串" }, { value: '"！@#￥"' },
                        { value: '""' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"storeId_3"')
                        .onSelect((index: number, value: string) => {
                          switch (index) {
                            case 0:
                              this.storeId = "storeId_3"
                              break
                            case 1:
                              this.storeId = "abc"
                              break
                            case 2:
                              this.storeId = "s".repeat(maxStoreIdLength + 1);
                              break
                            case 3:
                              this.storeId = "！@#￥"
                              break
                            case 4:
                              this.storeId = ""
                              break
                            case 5:
                              this.storeId = null!
                              break
                            case 6:
                              this.storeId = undefined!
                              break
                          }
                        })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域一
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("获取数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      // let options: distributedKVStore.Options = {
                      //   securityLevel: distributedKVStore.SecurityLevel.S3,
                      // };
                      let options: distributedKVStore.Options = {
                        createIfMissing: true,
                        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                        securityLevel: distributedKVStore.SecurityLevel.S3,
                      };

                      await this.kvManager.getKVStore("storeId_3", options).then((data: distributedKVStore.SingleKVStore) => {
                        if (data !== undefined) {
                          this.singleKVStore = data;
                          this.consoleInfo = "SingleKVStore获取成功";
                        }
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `SingleKVStore获取失败，code: ${error.code}，message: ${error.message}`;
                      })
                    } catch (error) {
                      this.consoleInfo = `SingleKVStore获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("deleteKVStore_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      this.kvManager.deleteKVStore(this.appId, this.storeId, (error: BusinessError) => {
                        if (error) {
                          this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                        } else {
                          this.consoleInfo = "删除成功 callback";
                        }
                      })
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("deleteKVStore_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      await this.kvManager.deleteKVStore(this.appId, this.storeId).then(() => {
                        this.consoleInfo = "删除成功 promise";
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                      })
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Column() { // 数据插入区域
                  Column() {
                    Row({ space: 10 }) {
                      Text('数据插入')
                        .fontSize(20)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 按钮
                    Row() {
                      Button("put")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          try {
                            if (this.singleKVStore !== undefined) {
                              await this.singleKVStore.put("key", "a value").then(() => {
                                this.consoleInfo = "数据插入成功";
                              }).catch((error: BusinessError) => {
                                this.consoleInfo = `数据插入失败，code: ${error.code}，message: ${error.message}`;
                              });
                            } else {
                              this.consoleInfo = "请先创建数据库";
                            }
                          } catch (error) {
                            this.consoleInfo = `数据插入失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("查看数据库的数据")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          try {
                            if (this.singleKVStore !== undefined) {
                              await this.singleKVStore.getEntries("^").then((entries: distributedKVStore.Entry[]) => {
                                let str = `共有${entries.length}条数据` + "\n";
                                entries.forEach((value: distributedKVStore.Entry, index: number) => {
                                  str += `${index + 1}. key: ${value.key}, value: ${value.value.value}` + "\n";
                                });

                                this.uiContext.showAlertDialog({
                                  title: '数据库内容弹窗',
                                  message: str,
                                  primaryButton: {
                                    value: '关闭',
                                    backgroundColor: '#F5F7FA',
                                    action: () => {}
                                  },
                                })
                              }).catch((error: BusinessError) => {
                                this.consoleInfo = `数据获取失败，code: ${error.code}，message: ${error.message}`;
                              });
                            } else {
                              this.consoleInfo = "请先创建数据库";
                            }
                          } catch (error) {
                            this.consoleInfo = `数据插入失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 数据插入区域
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("deleteKVStore_Callback_Callback参数为null")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "storeId_3", null);
                      this.consoleInfo = `未抛出异常`;
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("deleteKVStore_Callback_Callback参数为undefined")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "storeId_3", undefined);
                      this.consoleInfo = `未抛出异常`;
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

              }
            }
          }.height('75%')
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