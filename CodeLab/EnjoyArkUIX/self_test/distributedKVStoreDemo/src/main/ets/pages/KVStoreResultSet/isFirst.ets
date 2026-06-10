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

let kvManager_1: distributedKVStore.KVManager;
let appId: string = 'com.example.distributedkvstoretest';
let storeId: string = 'ResultSet_storeId_schema';
let kvStore_1: distributedKVStore.SingleKVStore | null = null;

const maxFieldNodeNameLength: number = 64;  // FieldNode的值，不能为空，且不大于64个字符。
const longStringFieldName: string = 's'.repeat(maxFieldNodeNameLength);
const longNumberFieldName: string = 'n'.repeat(maxFieldNodeNameLength);
const studentId: string = 'studentId';
const name: string = 'name';
const age: string = 'age';
const male: string = 'male';
const score1: string = 'score1';
const score2: string = 'score2';
let child1 = new distributedKVStore.FieldNode(studentId);
child1.type = distributedKVStore.ValueType.STRING;
child1.nullable = false;
child1.default = "1";
let child2 = new distributedKVStore.FieldNode(name);
child2.type = distributedKVStore.ValueType.STRING;
child2.nullable = true;
child2.default = 'zhangsan';
let child3 = new distributedKVStore.FieldNode(age);
child3.type = distributedKVStore.ValueType.INTEGER;
child3.nullable = true;
child3.default = '15';
let child4 = new distributedKVStore.FieldNode(male);
child4.type = distributedKVStore.ValueType.BOOLEAN;
child4.nullable = true;
child4.default = 'true';
let child5 = new distributedKVStore.FieldNode(score1);
child5.type = distributedKVStore.ValueType.DOUBLE;
child5.nullable = true;
child5.default = '99.8';
let child6 = new distributedKVStore.FieldNode(score2);
child6.type = distributedKVStore.ValueType.FLOAT;
child6.nullable = true;
child6.default = '99.8';
let child7 = new distributedKVStore.FieldNode(longStringFieldName);
child7.type = distributedKVStore.ValueType.STRING;
child7.nullable = true;
child7.default = "long9";
let child8 = new distributedKVStore.FieldNode(longNumberFieldName);
child8.type = distributedKVStore.ValueType.INTEGER;
child8.nullable = true;
child8.default = '-19';

let schema = new distributedKVStore.Schema();
schema.root.appendChild(child1);
schema.root.appendChild(child2);
schema.root.appendChild(child3);
schema.root.appendChild(child4);
schema.root.appendChild(child5);
schema.root.appendChild(child6);
schema.root.appendChild(child7);
schema.root.appendChild(child8);
schema.indexes = ['$.studentId', '$.name'];
schema.mode = 1;
schema.skip = 0;

@Entry
@Component
struct Index {
  @State createColors: Color[] = Array(30).fill(Color.Blue);
  @State errInfo: string = 'no error';

  build() {
    Row() {
      Column(){
        Text('KVStoreResultSet-isFirst test')
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
        Text('Test Info')
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

            Button('getKVStore with schema')
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
                    // kvStoreType不填时，默认创建多设备协同数据库
                    kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                    // 多设备协同数据库:kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
                    schema: schema,
                    // schema未定义可以不填，定义方法请参考上方schema示例。
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
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[1] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:An unexpected error occurred.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button("put with schema")
              .backgroundColor(this.createColors[4])
              .onClick(()=>{
                try {
                  this.errInfo = '';
                  console.info('[Debug][js]:put enter');

                  if (kvStore_1 == null) {
                    console.info('[Debug][js]:kvstore is null');
                    this.createColors[4] = Color.Red;
                    this.errInfo = 'kvStore is null';
                    return;
                  }
                  // 如果未定义Schema则Value可以传其他符合要求的值。
                  kvStore_1.put( '1', '{"studentId":"S11", "name":"zhangsan", "age":15, "male":true, "score1":69.0, "score2":69.0}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 1 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 1 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
                    }
                  });
                  kvStore_1.put( '2', '{"studentId":"S12", "name":"lisi", "age":16, "male":false, "score1":79.0, "score2":79.0}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 2 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 2 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
                    }
                  });
                  kvStore_1.put( '3', '{"studentId":"S13", "name":"wangwu", "age":17, "male":true, "score1":89.01, "score2":89.01}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 3 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 3 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
                    }
                  });
                  kvStore_1.put( '4', '{"studentId":"S14", "name":"", "age":18, "male":true, "score1":89.00, "score2":89.00}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 4 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 4 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
                    }
                  });
                  kvStore_1.put( '5', '{"studentId":"S15", "name":null, "age":null, "male":null, "score1":null, "score2":null}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 5 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 5 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
                    }
                  });
                  kvStore_1.put( '6', '{"studentId":"S16", "name":"吴验汉", "age":19, "male":true, "score1":99.001, "score2":99.001}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 6 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 6 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
                    }
                  });
                  kvStore_1.put( '7', '{"studentId":"S17", "name":"严小小", "age":13, "male":false, "score1":99.000, "score2":99.002}', (err) => {
                    if (err !== undefined) {
                      this.createColors[4] = Color.Red;
                      this.errInfo += `put 7 code is ${err.code},message is ${err.message}.\n`
                      console.error(`[Debug][js]Failed to put data. Code:${err.code},message:${err.message}`);
                      return;
                    } else {
                      this.createColors[4] = Color.Green;
                      this.errInfo += 'put 7 no error.\n';
                      console.info('[Debug][js]Succeeded in putting data.');
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
                  this.errInfo = 'no error.\n';
                  console.info('[Debug][js]:commit enter');
                  if (kvStore_1 == null) {
                    this.createColors[5] = Color.Red;
                    this.errInfo = 'kvStore is null';
                    return;
                  }

                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[5]  = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is: ${sqlLike}`
                        return;
                      } else {
                        this.createColors[5]  = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = 'no error. \n' + `resultSet.getCount: ${count}, \nquery is: ${sqlLike}. `;
                        resultSet.moveToFirst();
                        while (!resultSet.isAfterLast()) {
                          let entry = resultSet.getEntry();
                          this.errInfo += `\ngetEntry succeed, the Entry is: ${JSON.stringify(entry)}.`
                          resultSet.moveToNext();
                        }
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[5] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[5] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error(`[Debug][js]:An unexpected error occurred.code is ${error.code},message is ${error.message}`);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at first)(multiple records)')
              .backgroundColor(this.createColors[6])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[6] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.notEqualTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[6] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[6] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToFirst();
                        if (resultSet.isFirst()) {
                          this.createColors[6] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[6] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[6] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[6] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at before first)(multiple records)')
              .backgroundColor(this.createColors[7])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[7] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.notEqualTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[7] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[7] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToFirst();
                        resultSet.moveToPrevious()
                        if (resultSet.isFirst()) {
                          this.createColors[7] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[7] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[7] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[7] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at last)(multiple records)')
              .backgroundColor(this.createColors[8])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[8] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.notEqualTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[8] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[8] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToLast();
                        if (resultSet.isFirst()) {
                          this.createColors[8] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[8] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[8] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[8] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at after last)(multiple records)')
              .backgroundColor(this.createColors[9])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[9] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.notEqualTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[9] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[9] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToLast();
                        resultSet.moveToNext()
                        if (resultSet.isFirst()) {
                          this.createColors[9] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[9] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[9] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[9] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at first)(only 1 record)')
              .backgroundColor(this.createColors[10])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[10] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[10] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[10] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToFirst();
                        if (resultSet.isFirst()) {
                          this.createColors[10] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[10] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[10] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[10] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at before first)(only 1 record)')
              .backgroundColor(this.createColors[11])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[11] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[11] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[11] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToFirst();
                        resultSet.moveToPrevious()
                        if (resultSet.isFirst()) {
                          this.createColors[11] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[11] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[11] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[11] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at last)(only 1 record)')
              .backgroundColor(this.createColors[12])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[12] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[12] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[12] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToLast();
                        if (resultSet.isFirst()) {
                          this.createColors[12] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[12] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[12] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[12] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at after last)(only 1 record)')
              .backgroundColor(this.createColors[13])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[13] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S13');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[13] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[13] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToLast();
                        resultSet.moveToNext()
                        if (resultSet.isFirst()) {
                          this.createColors[13] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[13] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[13] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[13] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at first)(without matched record)')
              .backgroundColor(this.createColors[14])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[14] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S23');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[14] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[14] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToFirst();
                        if (resultSet.isFirst()) {
                          this.createColors[14] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[14] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[14] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[14] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at before first)(without matched record)')
              .backgroundColor(this.createColors[15])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[15] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S23');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[15] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[15] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToFirst();
                        resultSet.moveToPrevious()
                        if (resultSet.isFirst()) {
                          this.createColors[15] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[15] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[15] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[15] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at last)(without matched record)')
              .backgroundColor(this.createColors[16])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[16] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S23');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[16] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[16] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToLast();
                        if (resultSet.isFirst()) {
                          this.createColors[16] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[16] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[16] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[16] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
                }
              })
              .width('80%')
              .margin(5)

            Button('isFirst(at after last)(without matched record)')
              .backgroundColor(this.createColors[17])
              .onClick(()=>{
                console.info('[Debug][js]:equal to enter');

                if (kvStore_1 == null) {
                  console.info('[Debug][js]:kvstore is null');
                  this.createColors[17] = Color.Red;
                  this.errInfo = 'kvStore is null';
                  return;
                }

                try {
                  this.errInfo = 'no error.\n';
                  let resultSet: distributedKVStore.KVStoreResultSet;
                  let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                  if (query != null) {
                    query.equalTo('studentId', 'S23');
                    query.orderByAsc('studentId');
                    let sqlLike = query.getSqlLike();
                    kvStore_1.getResultSet(query, async (err: BusinessError, result: distributedKVStore.KVStoreResultSet) => {
                      if (err != undefined) {
                        console.error(`[Debug][js]:Failed to get resultset.code is ${err.code},message is ${err.message}`);
                        this.createColors[17] = Color.Red;
                        this.errInfo = `error: \ncode is ${err.code},message is ${err.message}.\n query is： ${sqlLike}`
                        return;
                      } else {
                        this.createColors[17] = Color.Green;
                        resultSet = result;
                        let count = resultSet.getCount();
                        this.errInfo = `no error. \nresultSet.getCount: ${count}`
                        console.info("getCount succeed:" + count);
                        resultSet.moveToLast();
                        resultSet.moveToNext()
                        if (resultSet.isFirst()) {
                          this.createColors[17] = Color.Green;
                          this.errInfo = 'no error. isFirst == true.\n' + `resultSet.getCount: ${count}.\n.`;
                        } else {
                          this.createColors[17] = Color.Red;
                          this.errInfo = 'no error. isFirst == false.\n' + `resultSet.getCount: ${count}.\n.`;
                        }
                        this.errInfo += `\nquery is： ${sqlLike}`
                        console.info('[Debug][js]:Succeeded in getting result set ' + result.getCount());
                        if (kvStore_1 != null) {
                          kvStore_1.closeResultSet(resultSet, (err :BusinessError) => {
                            if (err != undefined) {
                              console.error(`Failed to close resultset.code is ${err.code},message is ${err.message}`);
                              return;
                            }
                            console.info('Succeeded in closing result set');
                          });
                        }
                      }
                    });
                    query = null;
                  } else {
                    this.createColors[17] = Color.Red;
                    this.errInfo = 'query is null';
                  }
                } catch (e) {
                  let error = e as BusinessError;
                  this.createColors[17] = Color.Red;
                  this.errInfo = `error: \ntry catch code is ${error.code},message is ${error.message}`
                  console.error("[Debug][js]:simply calls should be ok :" + e);
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