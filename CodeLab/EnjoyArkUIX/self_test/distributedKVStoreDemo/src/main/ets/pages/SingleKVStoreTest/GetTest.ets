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
// let temp: distributedKVStore.Entry[] = [];
function sleep(ms:number) {
  return new Promise<Object>(resolve => setTimeout(resolve, ms));
}

@Entry
@Component
struct GetTest {
  @State consoleInfo: string = "";

  private router: Router = this.getUIContext().getRouter();
  private key_get: string = "string key";
  private keyPrefix_getEntries: string = "key";
  private query_getEntries: distributedKVStore.Query | null = null;
  private keyPrefix_getResultSet: string = "key";
  private query_getResultSet: distributedKVStore.Query | null = null;
  private entries_withoutSchema: distributedKVStore.Entry[] = [];
  private entries_withSchema: distributedKVStore.Entry[] = [];
  private resultSet: distributedKVStore.KVStoreResultSet | null = null;
  private query_getResultSize: distributedKVStore.Query | null = null;

  private kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(kvManagerConfig);
  private singleKVStore: distributedKVStore.SingleKVStore | undefined = undefined;
  private uiContext: UIContext = this.getUIContext();

  scroller: Scroller = new Scroller();
  scroller2: Scroller = new Scroller();

  aboutToAppear(): void {
    let query: distributedKVStore.Query | null = new distributedKVStore.Query();
    if (query != null) {
      query.greaterThan("id", 2);
      console.info(`query is ${query.getSqlLike()}`);
    }
    this.query_getEntries = query;
    this.query_getResultSet = query;
    this.query_getResultSize = query;

    this.entries_withoutSchema.push({
      key: "string key",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: 'a string'
      }
    })
    this.entries_withoutSchema.push({
      key: "string key2",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: 'a string 2'
      }
    })
    this.entries_withoutSchema.push({
      key: "integer key",
      value: {
        type: distributedKVStore.ValueType.INTEGER,
        value: 100
      }
    })
    this.entries_withoutSchema.push({
      key: "float key",
      value: {
        type: distributedKVStore.ValueType.FLOAT,
        value: 3.1415926
      }
    })
    this.entries_withoutSchema.push({
      key: "boolean key",
      value: {
        type: distributedKVStore.ValueType.BOOLEAN,
        value: false
      }
    })
    this.entries_withoutSchema.push({
      key: "double key",
      value: {
        type: distributedKVStore.ValueType.DOUBLE,
        value: 3.1415926
      }
    })


    this.entries_withSchema.push({
      key: "key_1",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: '{"id":1, "value":"the value of id 1"}'
      }
    })
    this.entries_withSchema.push({
      key: "key_2",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: '{"id":2, "value":"the value of id 2"}'
      }
    })
    this.entries_withSchema.push({
      key: "key_3",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: '{"id":3, "value":"the value of id 3"}'
      }
    })
    this.entries_withSchema.push({
      key: "key_4",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: '{"id":4, "value":"the value of id 4"}'
      }
    })
    this.entries_withSchema.push({
      key: "key_5",
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: '{"id":5, "value":"the value of id 5"}'
      }
    })
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
        .title('Get测试')
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
          .height(120)
          .width('100%')
          .padding({ left: '3.35%', right: '3.35%' })
          .backgroundColor(Color.White)
          .margin({ bottom: 16 })
          .borderRadius(24)

          Column() { // 界面部分
            Scroll(this.scroller2) {
              Column() {
                Button("获取不带schema数据库")
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
                        await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "getTest_withoutSchema");
                      } catch (error) {}

                      try {
                        await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "getTest_withSchema");
                      } catch (error) {}

                      this.singleKVStore = undefined;
                      await this.kvManager.getKVStore("getTest_withoutSchema", options).then(async (data: distributedKVStore.SingleKVStore) => {
                        if (data !== undefined) {
                          this.singleKVStore = data;
                          this.consoleInfo = "SingleKVStore获取成功";

                          await this.singleKVStore.putBatch(this.entries_withoutSchema).then(() => {
                          }).catch((error: BusinessError) => {
                            this.consoleInfo = `插入数据失败，code: ${error.code}，message: ${error.message}`;
                          })

                          let array: Uint8Array = Uint8Array.from([2, 4, 6, 8, 10]);
                          await this.singleKVStore.put("array key", array).then(() => {
                          }).catch((error: BusinessError) => {
                            this.consoleInfo = `插入数据失败，code: ${error.code}，message: ${error.message}`;
                          })

                          try {
                            await this.singleKVStore.put("key_string", "a string").then(() => {});
                            await this.singleKVStore.put("key_number1", 100).then(() => {});
                            await this.singleKVStore.put("key_number2", 3.1415926).then(() => {});
                            await this.singleKVStore.put("key_boolean", false).then(() => {});
                            await this.singleKVStore.put("key_array", array).then(() => {});
                          } catch (error) {
                            this.consoleInfo = `插入数据失败，code: ${error.code}，message: ${error.message}`;
                          }
                        }
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `SingleKVStore获取失败，code: ${error.code}，message: ${error.message}`;
                      })
                    } catch (error) {
                      this.consoleInfo = `SingleKVStore获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ top: 10 })

                Button("获取带schema数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      let child1 = new distributedKVStore.FieldNode('id');
                      child1.type = distributedKVStore.ValueType.INTEGER;
                      child1.nullable = true;
                      child1.default = '0';
                      let child2 = new distributedKVStore.FieldNode('value');
                      child2.type = distributedKVStore.ValueType.STRING;
                      child2.nullable = true;
                      child2.default = 'a string';

                      let schema = new distributedKVStore.Schema();
                      schema.root.appendChild(child1);
                      schema.root.appendChild(child2);
                      schema.indexes = ['$.id', '$.value'];
                      schema.mode = 0;
                      schema.skip = 0;

                      let options: distributedKVStore.Options = {
                        createIfMissing: true,
                        kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                        securityLevel: distributedKVStore.SecurityLevel.S3,
                        schema: schema
                      };

                      try {
                        await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "getTest_withoutSchema");
                      } catch (error) {}

                      try {
                        await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "getTest_withSchema");
                      } catch (error) {}

                      this.singleKVStore = undefined;
                      await this.kvManager.getKVStore("getTest_withSchema", options).then((data: distributedKVStore.SingleKVStore) => {
                        if (data !== undefined) {
                          this.singleKVStore = data;
                          this.consoleInfo = "SingleKVStore获取成功";

                          this.singleKVStore.putBatch(this.entries_withSchema).then(() => {
                          }).catch((error: BusinessError) => {
                            this.consoleInfo = `插入数据失败，code: ${error.code}，message: ${error.message}`;
                          })
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
                      await this.kvManager.closeKVStore("com.example.distributedkvstoretest", "getTest_withoutSchema").then(() => {
                        this.consoleInfo = "关闭成功";
                      }).catch((error: BusinessError) => {
                        this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                      })

                      await this.kvManager.closeKVStore("com.example.distributedkvstoretest", "getTest_withSchema").then(() => {
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
                      Text('get的参数')
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

                      Select([{ value: '"string key"' }, { value: '"integer key"' }, { value: '"float key"' }, { value: '"boolean key"' },
                        { value: '"double key"' }, { value: '"array key"' }, { value: '"abc"' }, { value: '超长的字符串' }, { value: "\"\"" },
                        { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"string key"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.key_get = "string key"
                              break
                            case 1:
                              this.key_get = "integer key"
                              break
                            case 2:
                              this.key_get = "float key"
                              break
                            case 3:
                              this.key_get = "boolean key"
                              break
                            case 4:
                              this.key_get = "double key"
                              break
                            case 5:
                              this.key_get = "array key"
                              break
                            case 6:
                              this.key_get = "abc"
                              break
                            case 7:
                              this.key_get = "s".repeat(maxKeyLength + 1);
                              break
                            case 8:
                              this.key_get = ""
                              break
                            case 9:
                              this.key_get = null!
                              break
                            case 10:
                              this.key_get = undefined!
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

                Button("get_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.get(this.key_get, (error: BusinessError, data: boolean | string | number | Uint8Array) => {
                          if (error) {
                            this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = `获取成功 callback，data: ${data}`;
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("get_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.get(this.key_get).then((data: boolean | string | number | Uint8Array) => {
                          this.consoleInfo = `获取成功 promise，data: ${data}`;
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("get_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.get("string key", null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("get_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.get("string key", undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })


                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('getEntries(key)的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("keyPrefix: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"key"' }, { value: '"abc"' }, { value: '"^"' }, { value: '超长的字符串' }, { value: "\"\"" },
                        { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"key"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.keyPrefix_getEntries = "key"
                              break
                            case 1:
                              this.keyPrefix_getEntries = "abc"
                              break
                            case 2:
                              this.keyPrefix_getEntries = "^"
                              break
                            case 3:
                              this.keyPrefix_getEntries = "s".repeat(maxKeyLength + 1);
                              break
                            case 4:
                              this.keyPrefix_getEntries = ""
                              break
                            case 5:
                              this.keyPrefix_getEntries = null!
                              break
                            case 6:
                              this.keyPrefix_getEntries = undefined!
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

                Button("getEntries(key)_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.getEntries(this.keyPrefix_getEntries, (error: BusinessError, entries: distributedKVStore.Entry[]) => {
                          if (error) {
                            this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = `获取成功 callback，` + "\n";
                            if (entries.length !== 0) {
                              entries.forEach((value: distributedKVStore.Entry, index: number) => {
                                this.consoleInfo += `${index + 1}. key: ${value.key}, value: ${value.value.value}, 值类型为${value.value.type}` + "\n";
                              });
                            } else {
                              this.consoleInfo += "没有数据";
                            }

                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getEntries(key)_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.getEntries(this.keyPrefix_getEntries).then((entries: distributedKVStore.Entry[]) => {
                          this.consoleInfo = `获取成功 promise，` + "\n";
                          if (entries.length !== 0) {
                            entries.forEach((value: distributedKVStore.Entry, index: number) => {
                              this.consoleInfo += `${index + 1}. key: ${value.key}, value: ${value.value.value}, 值类型为${value.value.type}` + "\n";
                            });
                          } else {
                            this.consoleInfo += "没有数据";
                          }
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getEntries(key)_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.getEntries("key", null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getEntries(key)_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.getEntries("key", undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('getEntries(query)的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("query: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: 'query' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('query')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                              if (query != null) {
                                query.greaterThan("id", 2);
                              }
                              this.query_getEntries = query
                              break
                            case 1:
                              this.query_getEntries = null!
                              break
                            case 2:
                              this.query_getEntries = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '60%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域一
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("getEntries(query)_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.getEntries(this.query_getEntries, (error: BusinessError, entries: distributedKVStore.Entry[]) => {
                          if (error) {
                            this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = `获取成功 callback，` + "\n";
                            entries.forEach((value: distributedKVStore.Entry, index: number) => {
                              this.consoleInfo += `${index + 1}. key: ${value.key}, value: ${value.value.value}, 值类型为${value.value.type}` + "\n";
                            });
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getEntries(query)_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.getEntries(this.query_getEntries).then((entries: distributedKVStore.Entry[]) => {
                          this.consoleInfo = `获取成功 promise，` + "\n";
                          entries.forEach((value: distributedKVStore.Entry, index: number) => {
                            this.consoleInfo += `${index + 1}. key: ${value.key}, value: ${value.value.value}, 值类型为${value.value.type}` + "\n";
                          });
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getEntries(query)_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                        if (query != null) {
                          query.greaterThan("id", 2);
                        }

                        this.singleKVStore.getEntries(query, null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getEntries(query)_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                        if (query != null) {
                          query.greaterThan("id", 2);
                        }

                        this.singleKVStore.getEntries(query, undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })


                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('getResultSet(key)的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("keyPrefix: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"key"' }, { value: '"abc"' }, { value: '"^"' }, { value: '超长的字符串' }, { value: "\"\"" },
                        { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"key"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.keyPrefix_getResultSet = "key"
                              break
                            case 1:
                              this.keyPrefix_getResultSet = "abc"
                              break
                            case 2:
                              this.keyPrefix_getResultSet = "^"
                              break
                            case 3:
                              this.keyPrefix_getResultSet = "s".repeat(maxKeyLength + 1);
                              break
                            case 4:
                              this.keyPrefix_getResultSet = ""
                              break
                            case 5:
                              this.keyPrefix_getResultSet = null!
                              break
                            case 6:
                              this.keyPrefix_getResultSet = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '60%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域一
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Row() {
                  Button("getResultSet(key)_Callback")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          this.singleKVStore.getResultSet(this.keyPrefix_getResultSet, (error: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                            if (error) {
                              this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                            } else {
                              this.consoleInfo = `获取成功 callback，` + "\n";
                              let index = 1;
                              if (result.getCount()) {
                                while (true) {
                                  if (!result!.moveToNext()) {
                                    break;
                                  }
                                  let entry = result!.getEntry()
                                  this.consoleInfo += `${index}. key: ${entry.key}, value: ${entry.value.value}, 值类型为${entry.value.type}` + "\n";
                                  index++;
                                }
                              } else {
                                this.consoleInfo += "没有数据";
                              }

                              try {
                                this.singleKVStore?.closeResultSet(result);
                              } catch (error) {}
                            }
                          })
                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })

                  Button("9次")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          let num = 0;
                          let result_arr: distributedKVStore.KVStoreResultSet[] = [];
                          while(num < 9) {
                            this.singleKVStore.getResultSet(this.keyPrefix_getResultSet, (error: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                              if (error) {
                                this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                              } else {
                                result_arr[num] = result;
                              }
                            })
                            await sleep(50);
                            num++;
                          }

                          result_arr.forEach(async (value: distributedKVStore.KVStoreResultSet, index: number) => {
                            try {
                              await this.singleKVStore?.closeResultSet(value);
                            } catch (error) {}
                          })
                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })
                }


                Row() {
                  Button("getResultSet(key)_Promise")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          await this.singleKVStore.getResultSet(this.keyPrefix_getResultSet).then((result: distributedKVStore.KVStoreResultSet) => {
                            this.consoleInfo = `获取成功 promise，` + "\n";
                            let index = 1;
                            if (result.getCount() !== 0) {
                              while (true) {
                                if (!result!.moveToNext()) {
                                  break;
                                }
                                let entry = result!.getEntry();
                                this.consoleInfo += `${index}. key: ${entry.key}, value: ${entry.value.value}, 值类型为${entry.value.type}` + "\n";
                                index++;
                              }
                            } else {
                              this.consoleInfo += "没有数据";
                            }

                            try {
                              this.singleKVStore?.closeResultSet(result);
                            } catch (error) {}
                          }).catch((error: BusinessError) => {
                            this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                          })
                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })

                  Button("9次")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          let num = 0;
                          let result_arr: distributedKVStore.KVStoreResultSet[] = [];
                          while(num < 9) {
                            await this.singleKVStore.getResultSet(this.keyPrefix_getResultSet).then((result: distributedKVStore.KVStoreResultSet) => {
                              result_arr[num] = result;
                            }).catch((error: BusinessError) => {
                              this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                            })
                            num++;
                          }

                          result_arr.forEach(async (value: distributedKVStore.KVStoreResultSet, index: number) => {
                            try {
                              await this.singleKVStore?.closeResultSet(value);
                            } catch (error) {}
                          })
                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })
                }

                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('getResultSet(query)的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("query: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: 'query' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('query')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                              if (query != null) {
                                query.greaterThan("id", 2);
                              }
                              this.query_getResultSet = query
                              break
                            case 1:
                              this.query_getResultSet = null!
                              break
                            case 2:
                              this.query_getResultSet = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '60%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域一
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Row() {
                  Button("getResultSet(query)_Callback")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          this.singleKVStore.getResultSet(this.query_getResultSet, (error: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                            if (error) {
                              this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                            } else {
                              this.consoleInfo = `获取成功 callback，` + "\n";
                              let index = 1;
                              while (true) {
                                if (!result!.moveToNext()) {
                                  break;
                                }
                                let entry = result!.getEntry()
                                this.consoleInfo += `${index}. key: ${entry.key}, value: ${entry.value.value}, 值类型为${entry.value.type}` + "\n";
                                index++;
                              }

                              try {
                                this.singleKVStore?.closeResultSet(result);
                              } catch (error) {}
                            }
                          })
                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })

                  Button("9次")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          let num = 0;
                          let result_arr: distributedKVStore.KVStoreResultSet[] = [];
                          while(num < 9) {
                            this.singleKVStore.getResultSet(this.query_getResultSet, (error: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                              if (error) {
                                this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                              } else {
                                result_arr[num] = result;
                              }
                            })
                            await sleep(50);
                            num++;
                          }

                          result_arr.forEach(async (value: distributedKVStore.KVStoreResultSet, index: number) => {
                            try {
                              await this.singleKVStore?.closeResultSet(value);
                            } catch (error) {}
                          })

                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })
                }

                Row() {
                  Button("getResultSet(query)_Promise")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          await this.singleKVStore.getResultSet(this.query_getResultSet).then((result: distributedKVStore.KVStoreResultSet) => {
                            this.consoleInfo = `获取成功 promise，` + "\n";
                            let index = 1;
                            while (true) {
                              if (!result!.moveToNext()) {
                                break;
                              }
                              let entry = result!.getEntry();
                              this.consoleInfo += `${index}. key: ${entry.key}, value: ${entry.value.value}, 值类型为${entry.value.type}` + "\n";
                              index++;
                            }

                            try {
                              this.singleKVStore?.closeResultSet(result);
                            } catch (error) {}
                          }).catch((error: BusinessError) => {
                            this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                          })
                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })

                  Button("9次")
                    .fontWeight(FontWeight.Bold)
                    .onClick(async () => {
                      try {
                        if (this.singleKVStore !== undefined) {
                          let num = 0;
                          let result_arr: distributedKVStore.KVStoreResultSet[] = [];
                          while(num < 9) {
                            await this.singleKVStore.getResultSet(this.query_getResultSet).then((result: distributedKVStore.KVStoreResultSet) => {
                              result_arr[num] = result;
                            }).catch((error: BusinessError) => {
                              this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                            })
                            num++;
                          }

                          result_arr.forEach(async (value: distributedKVStore.KVStoreResultSet, index: number) => {
                            try {
                              await this.singleKVStore?.closeResultSet(value);
                            } catch (error) {}
                          })

                        } else {
                          this.consoleInfo = "请先创建数据库";
                        }
                      } catch (error) {
                        this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                      }
                    })
                    .margin({ bottom: 10 })
                }

                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('closeResultSet的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("resultSet: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: 'resultSet' }, { value: "null" }, { value: "undefined" }])
                        .selected(1)
                        .value('null')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              try {
                                if (this.singleKVStore !== undefined) {
                                  this.singleKVStore.getResultSet("^").then((result: distributedKVStore.KVStoreResultSet) => {
                                    this.resultSet = result;
                                  }).catch((error: BusinessError) => {
                                    this.consoleInfo = `获取ResultSet失败，code: ${error.code}，message: ${error.message}`;
                                  })
                                } else {
                                  this.consoleInfo = "请先创建数据库";
                                }
                              } catch (error) {
                                this.consoleInfo = `获取ResultSet失败，code: ${error.code}，message: ${error.message}`;
                              }
                              break
                            case 1:
                              this.resultSet = null!
                              break
                            case 2:
                              this.resultSet = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '60%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域一
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("getCount")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      this.consoleInfo = "getCount成功：" + this.resultSet?.getCount();
                    } catch (error) {
                      this.consoleInfo = `getCount失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("closeResultSet_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.closeResultSet(this.resultSet, (error: BusinessError) => {
                          if (error) {
                            this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = `关闭成功 callback`;
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("closeResultSet_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.closeResultSet(this.resultSet).then(() => {
                          this.consoleInfo = `关闭成功 promise`;
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("closeResultSet_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        let tempResult: distributedKVStore.KVStoreResultSet;
                        await this.singleKVStore.getResultSet("^").then((result: distributedKVStore.KVStoreResultSet) => {
                          tempResult = result;
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `获取ResultSet失败，code: ${error.code}，message: ${error.message}`;
                        })

                        this.singleKVStore.closeResultSet(tempResult!, null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("closeResultSet_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        let tempResult: distributedKVStore.KVStoreResultSet;
                        await this.singleKVStore.getResultSet("^").then((result: distributedKVStore.KVStoreResultSet) => {
                          tempResult = result;
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `获取ResultSet失败，code: ${error.code}，message: ${error.message}`;
                        })

                        this.singleKVStore.closeResultSet(tempResult!, undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('getResultSize的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项
                    Row() {
                      Text("query: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ left: 8 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: 'query' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('query')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                              if (query != null) {
                                query.greaterThan("id", 2);
                              }
                              this.query_getResultSize = query
                              break
                            case 1:
                              this.query_getResultSize = null!
                              break
                            case 2:
                              this.query_getResultSize = undefined!
                              break
                          }
                        }).constraintSize({ maxWidth: '60%' })
                    }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                } // 参数设置区域一
                .width('100%')
                .padding({ left: '3.35%', right: '3.35%' })
                .backgroundColor(Color.White)
                .margin({ bottom: 16 })
                .borderRadius(24)

                Button("getResultSize_Callback")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        this.singleKVStore.getResultSize(this.query_getResultSize, (error: BusinessError, resultSize: number) => {
                          if (error) {
                            this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                          } else {
                            this.consoleInfo = `获取成功 callback，resultSize: ${resultSize}`;
                          }
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getResultSize_Promise")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        await this.singleKVStore.getResultSize(this.query_getResultSize).then((resultSize: number) => {
                          this.consoleInfo = `获取成功 promise，resultSize: ${resultSize}`;
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                        })
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getResultSize_Callback_Callback参数为null")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                        if (query != null) {
                          query.greaterThan("id", 2);
                        }

                        this.singleKVStore.getResultSize(query, null);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("getResultSize_Callback_Callback参数为undefined")
                  .backgroundColor(Color.Orange)
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.singleKVStore !== undefined) {
                        let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                        if (query != null) {
                          query.greaterThan("id", 2);
                        }

                        this.singleKVStore.getResultSize(query, undefined);
                        this.consoleInfo = `未抛出异常`;
                      } else {
                        this.consoleInfo = "请先创建数据库";
                      }
                    } catch (error) {
                      this.consoleInfo = `获取失败，code: ${error.code}，message: ${error.message}`;
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