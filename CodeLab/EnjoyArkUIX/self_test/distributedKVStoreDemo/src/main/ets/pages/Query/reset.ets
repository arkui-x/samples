

/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { BusinessError } from '@kit.BasicServicesKit';
import distributedKVStore from '@ohos.data.distributedKVStore';

function putBatchString(len: number, prefix: string) {
  let entries: distributedKVStore.Entry[] = [];
  for (let i = 0; i < len; i++) {
    let entry: distributedKVStore.Entry = {
      key: prefix + i,
      value: {
        type: distributedKVStore.ValueType.STRING,
        value: 'batch_test_string_value'
      }
    }
    entries.push(entry);
  }
  return entries;
} //自定义函数，放置在作用域最外侧，防止语法检查报错

let kvManager_1: distributedKVStore.KVManager;
let appId: string = 'com.example.distributedkvstoretest';
let storeId: string = 'Query_storeId_no_schema';
let kvStore_1: distributedKVStore.SingleKVStore | null = null;

const KEY_TEST_STRING_ELEMENT = 'key_not_batch_test_string';
const VALUE_TEST_STRING_ELEMENT = 'value-not-batch-test-string';

@Entry
@Component
struct Index {
  @State createColors: Color[] = Array(30).fill(Color.Blue);
  @State errInfo: string = 'no error';

  build() {
    Row() {
      Column(){
        Text('Query-reset test')
          .fontSize('18fp')
          .fontWeight(FontWeight.Bolder)
          .margin({
            left: 16
          })
        Button('返回')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
          .width('80%')
          .margin(5)
        Text('Info')
          .fontSize('16fp')
          .fontWeight(FontWeight.Bolder)
          .align(Alignment.Start)
          .width('80%')
          .margin({
            left: 16
          })
        Scroll() {
          Column() {
            Text(this.errInfo)
              .fontSize('16fp')
              .fontWeight(FontWeight.Normal)
              .width('80%')
              .margin({
                left: 16
              })
          }.align(Alignment.TopStart)
        }.height('30%')
        .backgroundColor('#D0D0D0')
        Divider().margin(5);
        Scroll() {
          Column() {
            Button("createKvManager")
              .backgroundColor(this.createColors[0])
              .onClick(() => {
                console.info("[Debug][js]:Create KV Manager start");
                let context = getContext();
                const kvManagerConfig: distributedKVStore.KVManagerConfig = {
                  context: context,
                  bundleName: appId
                }
                try {
                  kvManager_1 = distributedKVStore.createKVManager(kvManagerConfig);
                  console.info("[Debug][js]:Succeeded in creating KVManager");
                  if (kvManager_1 !== undefined) {
                    this.createColors[0] = Color.Green;
                    this.errInfo = 'no error';
                  } else {
                    this.createColors[0] = Color.Red;
                    this.errInfo = 'kvManager is undefined';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[0] = Color.Red;
                  this.errInfo = `error: \ncode is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:Failed to create KVManager.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button('getKvStore')
              .backgroundColor(this.createColors[1])
              .onClick(() => {
                console.info("[Debug][js]:get kv store start");
                if (kvManager_1 == undefined) {
                  console.info("[Debug][js]:KvManager is nullptr");
                  this.createColors[1] = Color.Red;
                  this.errInfo = 'kvManager is undefined';
                  return;
                }

                try {
                  const options: distributedKVStore.Options = {
                    createIfMissing: true,
                    kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                    securityLevel: distributedKVStore.SecurityLevel.S3
                  };
                  kvManager_1.getKVStore(storeId, options,
                    (err: BusinessError, store: distributedKVStore.SingleKVStore) => {
                      if (err) {
                        this.createColors[1] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                        return;
                      }
                      console.info("[Debug][js]:Succeeded in getting kvStore_1");
                      kvStore_1 = store;
                      if (kvStore_1 !== null) {
                        this.createColors[1] = Color.Green;
                        this.errInfo = 'no error';
                      } else {
                        this.createColors[1] = Color.Red;
                        this.errInfo = 'kvStore is null';
                      }
                    })
                  this.errInfo = 'no error';
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[1] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:An unexpected error occurred.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button("put")
              .backgroundColor(this.createColors[4])
              .onClick(() => {
                if (kvStore_1 == null) {
                  this.createColors[4] = Color.Red;
                  this.errInfo = 'kvStore is undefined';
                  console.info("[Debug][js]:kvStore_1 is nullptr");
                  return;
                }

                try {
                  kvStore_1.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err: BusinessError) => {
                    if (err != undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                      console.error(`[Debug][js]Failed to put.code is ${err.code},message is ${err.message}`);
                      return;
                    }  else {
                      this.createColors[4] = Color.Green;
                      this.errInfo = 'no error';
                      console.info("[Debug][js]Succeeded in putting");
                    }
                  });
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[4] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:An unexpected error occurred.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button("get")
              .backgroundColor(this.createColors[5])
              .onClick(()=>{
                try {
                  console.info('[Debug][js]:commit enter');
                  if (kvStore_1 == null) {
                    this.createColors[5] = Color.Red;
                    this.errInfo = 'kvStore is null';
                    return;
                  }
                  kvStore_1.get(KEY_TEST_STRING_ELEMENT, (err: BusinessError, data: boolean | string | number | Uint8Array) => {
                    if (err != undefined) {
                      this.createColors[5] = Color.Red;
                      this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                      console.error(`Failed to get.code is ${err.code},message is ${err.message}`);
                      return;
                    } else {
                      this.createColors[5] = Color.Green;
                      this.errInfo = `no error. \nSucceeded in getting data.data=${data}`;
                      console.info(`Succeeded in getting data.data=${data}`);
                    }
                  });
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[5] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:An unexpected error occurred.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button("putBatch")
              .backgroundColor(this.createColors[6])
              .onClick(() => {
                try {
                  this.errInfo = 'no error';
                  console.info('[Debug][js]:startTransaction enter');
                  if (kvStore_1 == null) {
                    this.createColors[6] = Color.Red;
                    this.errInfo = 'kvStore is null';
                    return;
                  }
                  let entries = putBatchString(10, 'batch_test_string_key');
                  if (kvStore_1 != null) {
                    kvStore_1.putBatch(entries, async (err: BusinessError) => {
                      if (err != undefined) {
                        this.createColors[6] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                        console.error(`Failed to put Batch.code is ${err.code},message is ${err.message}`);
                        return;
                      } else {
                        this.createColors[6] = Color.Green;
                        this.errInfo = 'no error';
                        console.info('Succeeded in putting Batch');
                      }

                      if (kvStore_1 != null) {
                        kvStore_1.getEntries('batch_test_string_key', (err: BusinessError, entries: distributedKVStore.Entry[]) => {
                          if (err != undefined) {
                            this.createColors[6] = Color.Red;
                            this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                            console.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
                          } else {
                            console.info('Succeeded in getting Entries');
                            console.info(`entries.length: ${entries.length}`);
                            console.info(`entries[0]: ${entries[0]}`);
                            this.errInfo += `\nentries.length: ${entries.length}.`
                            // let index = 0
                            // while (index < entries.length) {
                            //   this.errInfo += `\nentries[${index}]’s key: ${entries[index].key}\nentries[${index}]’s value type: ${entries[index].value.type}, \nentries[${index}]’s value value: ${entries[index].value.value}.`;
                            //   index++
                            // }
                          }
                        });
                      } else {
                        console.error('KvStore is null'); //后续示例代码与此处保持一致
                      }
                    });
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[6] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:Failed to start Transaction.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button("getEntries")
              .backgroundColor(this.createColors[7])
              .onClick(() => {
                try {
                  this.errInfo = 'no error';
                  console.info('[Debug][js]:startTransaction enter');
                  if (kvStore_1 == null) {
                    this.createColors[7] = Color.Red;
                    this.errInfo = 'kvStore is null';
                    return;
                  }
                  const query = new distributedKVStore.Query();
                  query.prefixKey("batch_test");
                  kvStore_1.getEntries(query, (err: BusinessError, entries: distributedKVStore.Entry[]) => {
                    if (err != undefined) {
                      this.createColors[7] = Color.Red;
                      this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                      console.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
                    } else {
                      console.info('Succeeded in getting Entries');
                      console.info(`entries.length: ${entries.length}`);
                      console.info(`entries[0]: ${entries[0]}`);
                      this.createColors[7] = Color.Green;
                      this.errInfo += `\nentries.length: ${entries.length}.`
                      let index = 0
                      while (index < entries.length) {
                        this.errInfo += `\nentries[${index}]’s key: ${entries[index].key}\nentries[${index}]’s value type: ${entries[index].value.type}, \nentries[${index}]’s value value: ${entries[index].value.value}.`;
                        index++
                      }
                    }
                  });
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[7] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:Failed to start Transaction.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button("getEntries and reset")
              .backgroundColor(this.createColors[8])
              .onClick(() => {
                try {
                  this.errInfo = 'no error';
                  console.info('[Debug][js]:startTransaction enter');
                  if (kvStore_1 == null) {
                    this.createColors[8] = Color.Red;
                    this.errInfo = 'kvStore is undefined';
                    return;
                  }
                  const query = new distributedKVStore.Query();
                  query.prefixKey("batch_test");
                  query.reset()
                  kvStore_1.getEntries(query, (err: BusinessError, entries: distributedKVStore.Entry[]) => {
                    if (err != undefined) {
                      console.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
                      this.createColors[8] = Color.Red;
                      this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                      return;
                    } else {
                      this.createColors[8] = Color.Green;
                      this.errInfo += `\nentries.length: ${entries.length}.`
                      let index = 0
                      while (index < entries.length) {
                        this.errInfo += `\nentries[${index}]’s key: ${entries[index].key}\nentries[${index}]’s value type: ${entries[index].value.type}, \nentries[${index}]’s value value: ${entries[index].value.value}.`;
                        index++
                      }
                      console.info('Succeeded in getting Entries');
                      console.info(`entries.length: ${entries.length}`);
                      console.info(`entries[0]: ${entries[0]}`);
                    }
                  });
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[8] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:Failed to start Transaction.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button('closeKvStore')
              .backgroundColor(this.createColors[3])
              .onClick(() => {
                console.info("[Debug][js]:close store start");
                if (kvManager_1 == undefined) {
                  console.info("[Debug][js]:KvManager is nullptr");
                  return;
                }
                // appId为createKVManager中的appId
                kvManager_1.closeKVStore(appId, storeId, (err: BusinessError) => {
                  if (err != undefined) {
                    this.createColors[3] = Color.Red;
                    this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                    console.error(`[Debug][js]:Failed to close kvStore_1.code is ${err.code},message is ${err.message}`);
                    return;
                  } else {
                    this.createColors[3] = Color.Green;
                    this.errInfo = 'no error';
                    console.info('[Debug][js]:Succeeded in closing kvStore_1');
                  }

                });
              })
              .width('80%')
              .margin(5)

            Button('deleteKVStore')
              .backgroundColor(this.createColors[2])
              .onClick(() => {
                console.info("[Debug][js]:close store start");
                if (kvManager_1 == undefined) {
                  console.info("[Debug][js]:KvManager is nullptr");
                  return;
                }
                // appId为createKVManager中的appId
                kvManager_1.deleteKVStore(appId, storeId, (err: BusinessError) => {
                  if (err != undefined) {
                    this.createColors[2] = Color.Red;
                    this.errInfo = `error: \ncode is ${err.code},message is ${err.message}`
                    console.error(`[Debug][js]:Failed to delete kvStore_1.code is ${err.code},message is ${err.message}`);
                    return;
                  } else {
                    this.createColors[2] = Color.Green;
                    this.errInfo = 'no error';
                    console.info('[Debug][js]:Succeeded in delete kvStore_1');
                  }
                });
              })
              .width('80%')
              .margin(5)
          }
          .width('100%')
        }
        .scrollBar(BarState.On)
        .backgroundColor('#E0E0E0')
        .height('50%')
      }
    }
    .height('100%')
  }
}
