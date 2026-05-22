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
const maxKeyLength: number = 1024;  // MAX_KEY_LENGTH
const maxValueLength: number = 4194303;  //MAX_VALUE_LENGTH
let temp: distributedKVStore.Entry[] = [];

@Entry
@Component
struct InsertAndDeleteTest {
  @State consoleInfo: string = "";

  private router: Router = this.getUIContext().getRouter();
  private key_put: string = "key_str";
  private value_put: Uint8Array | string | number | boolean = "a string";
  private entries: distributedKVStore.Entry[] = [];
  private key_delete: string = "key_str";
  private keys: string[] = ["string key", "integer key", "float key"];

  private kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(kvManagerConfig);
  private singleKVStore: distributedKVStore.SingleKVStore | undefined = undefined;
  private uiContext: UIContext = this.getUIContext();

  scroller: Scroller = new Scroller();
  scroller2: Scroller = new Scroller();

  aboutToAppear(): void {
    temp.push({
      key: "string key",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: 'a string'
      }
    })
    temp.push({
      key: "integer key",
      value: {
        type: distributedKVStore.ValueType.INTEGER,
        value: 100
      }
    })
    temp.push({
      key: "float key",
      value: {
        type: distributedKVStore.ValueType.FLOAT,
        value: 3.1415926
      }
    })
    temp.push({
      key: "boolean key",
      value: {
        type: distributedKVStore.ValueType.BOOLEAN,
        value: false
      }
    })
    temp.push({
      key: "double key",
      value: {
        type: distributedKVStore.ValueType.DOUBLE,
        value: 3.1415926
      }
    })

    this.entries = temp;
  }

  build() {
    Column() {
      Row() { // 导航栏
        Navigation() {
        }
        .height('100%')
        .width('100%')
        .hideBackButton(false)
        .titleMode(NavigationTitleMode.Mini)
        .title('InsertAndDelete测试')
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

                Button("获取数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      let options: distributedKVStore.Options = {
                        createIfMissing: true,
                        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                        securityLevel: distributedKVStore.SecurityLevel.S3,
                      };

                      try {
                        await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "insertAndDeleteTest");
                      } catch (error) {}

                      await this.kvManager.getKVStore("insertAndDeleteTest", options).then((data: distributedKVStore.SingleKVStore) => {
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
                  .margin({ top: 10 })

                Button("关闭数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      await this.kvManager.closeKVStore("com.example.distributedkvstoretest", "insertAndDeleteTest").then(() => {
                        this.consoleInfo = "关闭成功";
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                      })
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ top: 10, bottom: 10 })

                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('put的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("key: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"key_str"' }, { value: '"key_num1"' }, { value: '"key_num2"' }, { value: '"key_bool"' }, { value: '"key_arr"' },
                        { value: '超长的字符串' }, { value: "\"\"" }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"key_str"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.key_put = "key_str"
                              break
                            case 1:
                              this.key_put = "key_num1"
                              break
                            case 2:
                              this.key_put = "key_num2"
                              break
                            case 3:
                              this.key_put = "key_bool"
                              break
                            case 4:
                              this.key_put = "key_arr"
                              break
                            case 5:

                              this.key_put = "s".repeat(maxKeyLength + 1);
                              break
                            case 6:
                              this.key_put = ""
                              break
                            case 7:
                              this.key_put = null!
                              break
                            case 8:
                              this.key_put = undefined!
                              break
                          }
                        })
                    }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                    // 参数选项
                    Row() {
                      Text("value: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"a string"' }, { value: "100" }, { value: "3.1415926" }, { value: "true" }, { value: "[1, 3, 5, 7, 9]" },
                        { value: "超长的字符串" }, { value: "超长的Uint8Array" },
                        { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"a string"')
                        .onSelect((index: number, value: string) => {
                          switch (index) {
                            case 0:
                              this.value_put = "a string"
                              break
                            case 1:
                              this.value_put = 100;
                              break
                            case 2:
                              this.value_put = 3.1415926;
                              break
                            case 3:
                              this.value_put = true;
                              break
                            case 4:
                              this.value_put = Uint8Array.from([1, 3, 5, 7, 9]);
                              break
                            case 5:

                              this.value_put = "s".repeat(maxValueLength + 1);
                              break
                            case 6:

                              this.value_put = new Uint8Array(maxValueLength + 1)
                              break
                            case 7:
                              this.value_put = null!
                              break
                            case 8:
                              this.value_put = undefined!
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

                Button("put_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.put(this.key_put, this.value_put, (error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "插入成功 callback";
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("put_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.put(this.key_put, this.value_put).then(() => {
                          this.consoleInfo = "插入成功 promise";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("put_Callback_Callback参数为null")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.put("key_str", "a string", null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("put_Callback_Callback参数为undefined")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.put("key_str", "a string", undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Column() { // 参数设置区域二
                  Column() {
                    Row({ space: 10 }) {
                      Text('putBatch的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("entries: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: 'Entry[]' }, { value: '[]' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('Entry[]')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.entries = []
                              this.entries = temp;
                              break
                            case 1:
                              this.entries = []
                              break
                            case 2:
                              this.entries = null!
                              break
                            case 3:
                              this.entries = undefined!
                              break
                          }
                        })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)


                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域二
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("putBatch_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.putBatch(this.entries, (error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "插入成功 callback";
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("putBatch_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.putBatch(this.entries).then(() => {
                          this.consoleInfo = "插入成功 promise";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("putBatch_Callback_Callback参数为null")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.putBatch(temp, null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("putBatch_Callback_Callback参数为undefined")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.putBatch(temp, undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `插入失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Column() { // 参数设置区域三
                  Column() {
                    Row({ space: 10 }) {
                      Text('delete的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("key: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"key_str"' }, { value: '"abc"' }, { value: '超长的字符串' }, { value: '""' }, { value: "null" },
                        { value: "undefined" }])
                        .selected(0)
                        .value('"key_str"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.key_delete = "key_str"
                              break
                            case 1:
                              this.key_delete = "abc"
                              break
                            case 2:
                              this.key_delete = "s".repeat(maxKeyLength + 1);
                              break
                            case 3:
                              this.key_delete = ""
                              break
                            case 4:
                              this.key_delete = null!
                              break
                            case 5:
                              this.key_delete = undefined!
                              break
                          }
                        })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)


                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域三
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("delete_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.delete(this.key_delete, (error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "删除成功 callback";
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("delete_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.delete(this.key_delete).then(() => {
                          this.consoleInfo = "删除成功 promise";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("delete_Callback_Callback参数为null")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.delete("key_str", null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("delete_Callback_Callback参数为undefined")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.delete("key_str", undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Column() { // 参数设置区域四
                  Column() {
                    Row({ space: 10 }) {
                      Text('deleteBatch的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("keys: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '["string key", "integer key", "float key"]' }, { value: '["abc"]' }, { value: '[""]' }, { value: '[]' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('["string key", "integer key", "float key"]')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.keys = ["string key", "integer key", "float key"]
                              break
                            case 1:
                              this.keys = ["abc"]
                              break
                            case 2:
                              this.keys = [""]
                              break
                            case 3:
                              this.keys = []
                              break
                            case 4:
                              this.keys = null!
                              break
                            case 5:
                              this.keys = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '75%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)


                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域四
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("deleteBatch_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.deleteBatch(this.keys, (error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = "删除成功 callback";
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("deleteBatch_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.deleteBatch(this.keys).then(() => {
                          this.consoleInfo = "删除成功 promise";
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("deleteBatch_Callback_Callback参数为null")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.deleteBatch(["string key"], null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("deleteBatch_Callback_Callback参数为undefined")
                  .fontWeight(FontWeight.Bold)
                  .backgroundColor(Color.Orange)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.deleteBatch(["string key"], undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `删除失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })


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