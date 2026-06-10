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

@Entry
@Component
struct TransactionTest {
  @State consoleInfo: string = "";

  private kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(kvManagerConfig);
  private singleKVStore : distributedKVStore.SingleKVStore | undefined = undefined;
  private router: Router = this.getUIContext().getRouter();
  private uiContext: UIContext = this.getUIContext();

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
        .title('事务相关测试')
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
                Button("创建数据库")
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

                      try {
                        await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "transactionTest");
                      } catch (error) {}

                      await this.kvManager.getKVStore("transactionTest", options).then((data: distributedKVStore.SingleKVStore) => {
                        if (data !== undefined) {
                          this.singleKVStore = data;
                          this.consoleInfo = "SingleKVStore创建成功";
                        }
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                      })
                    } catch (error) {
                      this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                    }
                  }).margin({ bottom: 10 });

                Button("关闭数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      await this.kvManager.closeKVStore("com.example.distributedkvstoretest", "transactionTest").then(() => {
                        this.consoleInfo = "关闭成功";
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                      })
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("startTransaction_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.startTransaction((error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `启动事务失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "启动事务成功";
                          }
                        });
                      }
                    } catch (error) {
                      this.consoleInfo = `启动事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("startTransaction_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.startTransaction().then(() => {
                          this.consoleInfo = "启动事务成功";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `启动事务失败，code: ${error.code}，message: ${error.message}`;
                        });
                      }
                    } catch (error) {
                      this.consoleInfo = `启动事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("startTransaction_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.startTransaction(null);
                        this.consoleInfo = `未抛出异常`;
                      }
                    } catch (error) {
                      this.consoleInfo = `启动事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("startTransaction_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.startTransaction(undefined);
                        this.consoleInfo = `未抛出异常`;
                      }
                    } catch (error) {
                      this.consoleInfo = `启动事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("commit_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.commit((error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `提交事务失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "提交事务成功";
                          }
                        });
                      }
                    } catch (error) {
                      this.consoleInfo = `提交事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("commit_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.commit().then(() => {
                          this.consoleInfo = "提交事务成功";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `提交事务失败，code: ${error.code}，message: ${error.message}`;
                        });
                      }
                    } catch (error) {
                      this.consoleInfo = `提交事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("commit_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.commit(null);
                        this.consoleInfo = `未抛出异常`;
                      }
                    } catch (error) {
                      this.consoleInfo = `提交事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("commit_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.commit(undefined);
                        this.consoleInfo = `未抛出异常`;
                      }
                    } catch (error) {
                      this.consoleInfo = `提交事务失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("rollback_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.rollback((error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `回滚失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "回滚成功";
                          }
                        });
                      }
                    } catch (error) {
                      this.consoleInfo = `回滚失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("rollback_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.rollback().then(() => {
                          this.consoleInfo = `回滚成功`;
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `回滚失败，code: ${error.code}，message: ${error.message}`;
                        })
                      }
                    } catch (error) {
                      this.consoleInfo = `回滚失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("rollback_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.rollback(null);
                        this.consoleInfo = `未抛出异常`;
                      }
                    } catch (error) {
                      this.consoleInfo = `回滚失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Button("rollback_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.rollback(undefined);
                        this.consoleInfo = `未抛出异常`;
                      }
                    } catch (error) {
                      this.consoleInfo = `回滚失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });

                Column() { // 数据插入区域
                  Column() {
                    Row({ space: 10 }) {
                      Text('数据查看')
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
                              await this.singleKVStore.put("key", "value").then(() => {
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