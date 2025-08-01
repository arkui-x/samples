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

import relationalStore from "@ohos.data.relationalStore"
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ValuesBucket } from '@ohos.data.ValuesBucket';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World /n';
  controller: TextAreaController = new TextAreaController();
  private store: relationalStore.RdbStore | undefined = undefined;
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  build() {
    Row() {
      Column() {
        TextArea({
          text: this.message,
          placeholder: 'The text area can hold an unlimited amount of text. input your word...',
          controller: this.controller,
        })
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .caretColor(Color.Blue)
          .width('100%')
          .height('45%')
          .margin(20)
          .fontSize(14)
          .focusable(true)
          .fontColor(Color.Black)
          .enableKeyboardOnFocus(false)
          .defaultFocus(true)
          .margin({ top: '1%' })
        Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap }) {

          Button('notContains')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.notContainsTest()
            })

          Button('notLike')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.notLikeTest()
            })

          Button('createTransaction')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.createTransactionTask();
            })

          Button('commit')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.commitTask();
            })

          Button('rollback')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.rollbackTask();
            })

          Button('insert')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.insertTask();
            })

          Button('batchInsert')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.batchInsertTask();
            })

          Button('batchInsertSync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.batchInsertSyncTask()
            })

          Button('batchInsertWithConflictResolution')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.batchInsertWithConflictResolutionTask()
            })

          Button('batchInsertWithConflictResolutionSync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.batchInsertWithConflictResolutionSyncTask();
            })

          Button('update')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.updateTask();
            })

          Button('updateSync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.updateSyncTask();
            })

          Button('delete')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.deleteTask()
            })

          Button('deleteSync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.deleteSyncTask();
            })

          Button('query')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.queryTask()
            })

          Button('querySync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.querySyncTask();
            })

          Button('querySql')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.querySqlTask();
            })

          Button('querySqlSync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.querySqlSyncTask();
            })

          Button('execute')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.executeTask();
            })

          Button('executeSync')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.executeSyncTask();
            })

          Button('onStatistics')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.onStatisticsTask();
            })

          Button('close')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.closeTask();
            })

          Button('getValue')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.getValueTask();
            })

          Button('getRow')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.getRowTask();
            })

          Button('清屏')
            .fontSize(14)
            .margin({ top: 10, left: 5 })
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = '';
            })
        }
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }

  async notContainsTest() {
    let predicates = new relationalStore.RdbPredicates("EMPLOYEE");
    try {
      predicates.notContains("NAME", "os");
      this.message += `====>notContains success \n`;
    } catch (error) {
      console.log(`notContains is failed, code is ${error.code},message is ${error.message}`);
    }
  }

  async notLikeTest() {
    let predicates = new relationalStore.RdbPredicates("EMPLOYEE");
    try {
      predicates.notLike("NAME", "os");
      this.message += `====>notLike success \n`;
    } catch (error) {
      console.log(`notLike is failed, code is ${error.code},message is ${error.message}`);
    }
  }

  async createTransactionTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionInsertTest.db",
      securityLevel: relationalStore.SecurityLevel.S3,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        await rdbTrans.insert("test", valueBucket);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        this.message += `====>createTransaction success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        this.message += `====>createTransaction error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async commitTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionInsertTest.db",
      securityLevel: relationalStore.SecurityLevel.S3,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        await rdbTrans.insert("test", valueBucket);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        this.message += `====>commit success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        this.message += `====>commit error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async rollbackTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionInsertTest.db",
      securityLevel: relationalStore.SecurityLevel.S3,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        await rdbTrans.insert("test", valueBucket);
        await rdbTrans.rollback();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        this.message += `====>rollback success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        this.message += `====>rollback error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async insertTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionInsertTest.db",
      securityLevel: relationalStore.SecurityLevel.S3,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        await rdbTrans.insert("test", valueBucket);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        this.message += `====>insert success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        this.message += `====>insert error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async batchInsertTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionInsertTest.db",
      securityLevel: relationalStore.SecurityLevel.S3,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBuckets = new Array(100).fill(0).map<relationalStore.ValuesBucket>(() => {
          const valueBucket: relationalStore.ValuesBucket = {
            "name": "lisi",
            "age": 18,
            "salary": 100.5,
            "blobType": u8,
          };
          return valueBucket;
        })
        const rowCount = await rdbTrans.batchInsert("test", valueBuckets);
        this.message += `====>batchInsert success rowCount: ${rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        this.message += `====>batchInsert success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        this.message += `====>batchInsert error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async batchInsertSyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBuckets = new Array(100).fill(0).map<relationalStore.ValuesBucket>(() => {
          const valueBucket: relationalStore.ValuesBucket = {
            "name": "lisi",
            "age": 18,
            "salary": 100.5,
            "blobType": u8,
          };
          return valueBucket;
        })
        const rowCount = rdbTrans.batchInsertSync("test", valueBuckets);
        this.message += `====>batchInsertSync success rowCount: ${rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        this.message += `====>batchInsertSync success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        this.message += `====>batchInsert error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async batchInsertWithConflictResolutionTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        let transaction = await (this.store as relationalStore.RdbStore).createTransaction();
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "zhangsan",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        let valueBucketArray: relationalStore.ValuesBucket[] = new Array();
        for (let i = 0; i < 2; i++) {
          valueBucketArray.push(valueBucket);
        }
        let num = await transaction.batchInsertWithConflictResolution("test", valueBucketArray,
          relationalStore.ConflictResolution.ON_CONFLICT_NONE);
        this.message += `====>batchInsertWithConflictResolution success rowCount: ${num} \n`;
        this.controller.caretPosition(this.message.length);
        let resultSet = await transaction.querySql("select * from test")
        this.message += `====>batchInsertWithConflictResolution success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
        await transaction.commit();
      } catch (e) {
        console.log(e);
        this.message += `====>batchInsertWithConflictResolution error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async batchInsertWithConflictResolutionSyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        let transaction = await (this.store as relationalStore.RdbStore).createTransaction();
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "zhangsan",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        let valueBucketArray: relationalStore.ValuesBucket[] = new Array();
        for (let i = 0; i < 2; i++) {
          valueBucketArray.push(valueBucket);
        }
        let num = await transaction.batchInsertWithConflictResolutionSync("test", valueBucketArray,
          relationalStore.ConflictResolution.ON_CONFLICT_NONE);
        this.message += `====>batchInsertWithConflictResolutionSync success rowCount: ${num} \n`;
        this.controller.caretPosition(this.message.length);
        let resultSet = await transaction.querySql("select * from test")
        this.message += `====>batchInsertWithConflictResolutionSync success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
        await transaction.commit();
      } catch (e) {
        console.log(e);
        this.message += `====>batchInsertWithConflictResolutionSync error : ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async updateTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        const rowId = await rdbTrans.insert("test", valueBucket);
        this.message += `====>update success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
        const updatePredicates = new relationalStore.RdbPredicates("test");
        updatePredicates.equalTo('name', 'lisi');
        await rdbTrans.update({
          age: 20
        }, updatePredicates);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        console.log("update result count " + resultSet.rowCount);
        this.message += `====>update success resultSet.rowCount: ${resultSet.rowCount} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.goToFirstRow();
        const rowData = resultSet.getRow();
        this.message += `====>update success rowData: ${rowData} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        console.log("update failed");
        this.message += `====>update error: ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async updateSyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      try {
        const u8 = new Uint8Array([1, 2, 3]);
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
          "blobType": u8,
        };
        const rowId = await rdbTrans.insert("test", valueBucket);
        this.message += `====>updateSync success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
        const updatePredicates = new relationalStore.RdbPredicates("test");
        updatePredicates.equalTo('name', 'lisi');
        rdbTrans.updateSync({
          age: 20
        }, updatePredicates);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates);
        console.log("updateSync result count " + resultSet.rowCount);
        this.message += `====>updateSync success resultSet.rowCount: ${resultSet.rowCount} \n`;
        resultSet.goToFirstRow();
        const rowData = resultSet.getRow();
        this.message += `====>updateSync success rowData: ${rowData} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (e) {
        console.log(e);
        console.log("updateSync failed");
        this.message += `====>updateSync error: ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async deleteTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      (this.store as relationalStore.RdbStore).createTransaction().then((transaction: relationalStore.Transaction) => {
        transaction.delete(predicates).then((rows: Number) => {
          transaction.commit();
          console.log(`Delete rows: ${rows}`);
          this.message += `====>delete success row count: ${rows} \n`;
          this.controller.caretPosition(this.message.length);
        }).catch((e: BusinessError) => {
          transaction.rollback();
          console.log(`====>Delete failed, code is ${e.code},message is ${e.message}`);
          this.message += `====>delete error: ${e.code} \n`;
          this.controller.caretPosition(this.message.length);
        });
      }).catch((err: BusinessError) => {
        console.log(`====>createTransaction failed, code is ${err.code},message is ${err.message}`);
      });
    }
  }

  async deleteSyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      (this.store as relationalStore.RdbStore).createTransaction().then((transaction: relationalStore.Transaction) => {
        try {
          let rows: Number = (transaction as relationalStore.Transaction).deleteSync(predicates);
          transaction.commit();
          console.log(`====>Delete rows: ${rows}`);
          this.message += `====>deleteSync success row count: ${rows} \n`;
          this.controller.caretPosition(this.message.length);
        } catch (e) {
          transaction.rollback();
          console.log(`====>Delete failed, code is ${e.code},message is ${e.message}`);
          this.message += `====>deleteSync error: ${e.code} \n`;
          this.controller.caretPosition(this.message.length);
        }
        ;
      }).catch((err: BusinessError) => {
        console.log(`====>createTransaction failed, code is ${err.code},message is ${err.message}`);
      });
    }
  }

  async queryTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      try {
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
        };
        const rowId = await rdbTrans.insert("test", valueBucket);
        this.message += `====>update success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
        const updatePredicates = new relationalStore.RdbPredicates("test");
        updatePredicates.equalTo('name', 'lisi');
        await rdbTrans.update({
          age: 20
        }, updatePredicates);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.query(predicates, ["name", "age", "salary"]);
        console.log("query result count " + resultSet.rowCount);
        this.message += `====>query success resultSet.rowCount: ${resultSet.rowCount} \n`;
        while (resultSet.goToNextRow()) {
          const name = resultSet.getString(resultSet.getColumnIndex("NAME"));
          const age = resultSet.getLong(resultSet.getColumnIndex("AGE"));
          const salary = resultSet.getDouble(resultSet.getColumnIndex("SALARY"));
          console.log(`name=${name}, age=${age}, salary=${salary}`);
          this.message += `====>query success name: ${name} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>query success age: ${age} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>query success salary: ${salary} \n`;
          this.controller.caretPosition(this.message.length);
        }
        resultSet.close();
        rdbTrans.commit();
      } catch (e) {
        console.log(e);
        console.log("query failed");
        this.message += `====>query error: ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async querySyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      try {
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
        };
        const rowId = await rdbTrans.insert("test", valueBucket);
        this.message += `====>update success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
        const updatePredicates = new relationalStore.RdbPredicates("test");
        updatePredicates.equalTo('name', 'lisi');
        await rdbTrans.update({
          age: 20
        }, updatePredicates);
        await rdbTrans.commit();
        let predicates = new relationalStore.RdbPredicates("test");
        let resultSet = await this.store.querySync(predicates, ["name", "age", "salary"]);
        console.log("querySync result count " + resultSet.rowCount);
        this.message += `====>querySync success resultSet.rowCount: ${resultSet.rowCount} \n`;
        while (resultSet.goToNextRow()) {
          const name = resultSet.getString(resultSet.getColumnIndex("NAME"));
          const age = resultSet.getLong(resultSet.getColumnIndex("AGE"));
          const salary = resultSet.getDouble(resultSet.getColumnIndex("SALARY"));
          console.log(`name=${name}, age=${age}, salary=${salary}`);
          this.message += `====>querySync success name: ${name} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>querySync success age: ${age} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>querySync success salary: ${salary} \n`;
          this.controller.caretPosition(this.message.length);
        }
        resultSet.close();
        rdbTrans.commit();
      } catch (e) {
        console.log(e);
        console.log("querySync failed");
        this.message += `====>querySync error: ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async querySqlTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      try {
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
        };
        const rowId = await rdbTrans.insert("test", valueBucket);
        this.message += `====>querySql success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
        const updatePredicates = new relationalStore.RdbPredicates("test");
        updatePredicates.equalTo('name', 'lisi');
        await rdbTrans.update({
          age: 20
        }, updatePredicates);
        await rdbTrans.commit();
        let resultSet = await this.store.querySql("SELECT * FROM test WHERE name = 'lisi'");
        console.log("querySql result count " + resultSet.rowCount);
        this.message += `====>querySql success resultSet.rowCount: ${resultSet.rowCount} \n`;
        while (resultSet.goToNextRow()) {
          const name = resultSet.getString(resultSet.getColumnIndex("NAME"));
          const age = resultSet.getLong(resultSet.getColumnIndex("AGE"));
          const salary = resultSet.getDouble(resultSet.getColumnIndex("SALARY"));
          console.log(`name=${name}, age=${age}, salary=${salary}`);
          this.message += `====>querySql success name: ${name} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>querySql success age: ${age} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>querySql success salary: ${salary} \n`;
          this.controller.caretPosition(this.message.length);
        }
        resultSet.close();
        rdbTrans.commit();
      } catch (e) {
        console.log(e);
        console.log("querySql failed");
        this.message += `====>querySql error: ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async querySqlSyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    let predicates = new relationalStore.RdbPredicates('test');
    predicates.equalTo("name", "lisi");
    if (this.store != undefined) {
      try {
        const rdbTrans = await this.store.createTransaction(options);
        const valueBucket: relationalStore.ValuesBucket = {
          "name": "lisi",
          "age": 18,
          "salary": 100.5,
        };
        const rowId = await rdbTrans.insert("test", valueBucket);
        this.message += `====>querySqlSync success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
        const updatePredicates = new relationalStore.RdbPredicates("test");
        updatePredicates.equalTo('name', 'lisi');
        await rdbTrans.update({
          age: 20
        }, updatePredicates);
        await rdbTrans.commit();
        let resultSet = await this.store.querySqlSync("SELECT * FROM test WHERE name = 'lisi'");
        console.log("querySqlSync result count " + resultSet.rowCount);
        this.message += `====>querySqlSync success resultSet.rowCount: ${resultSet.rowCount} \n`;
        while (resultSet.goToNextRow()) {
          const name = resultSet.getString(resultSet.getColumnIndex("NAME"));
          const age = resultSet.getLong(resultSet.getColumnIndex("AGE"));
          const salary = resultSet.getDouble(resultSet.getColumnIndex("SALARY"));
          console.log(`name=${name}, age=${age}, salary=${salary}`);
          this.message += `====>querySqlSync success name: ${name} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>querySqlSync success age: ${age} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>querySqlSync success salary: ${salary} \n`;
          this.controller.caretPosition(this.message.length);
        }
        resultSet.close();
        rdbTrans.commit();
      } catch (e) {
        console.log(e);
        console.log("querySqlSync failed");
        this.message += `====>querySqlSync error: ${e} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async executeTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      const SQL_DELETE_TABLE = 'DELETE FROM test';
      (this.store as relationalStore.RdbStore).createTransaction().then((transaction: relationalStore.Transaction) => {
        transaction.execute(SQL_DELETE_TABLE).then((data) => {
          transaction.commit();
          console.log(`====>execute delete result: ${data}`);
          this.message += `====>execute success result: ${data} \n`;
          this.controller.caretPosition(this.message.length);
        }).catch((e: BusinessError) => {
          transaction.rollback();
          console.log(`====>execute delete failed, code is ${e.code}, message is ${e.message}`);
        });
      }).catch((err: BusinessError) => {
        console.log(`====>createTransaction failed, code is ${err.code},message is ${err.message}`);
      });
    }
  }

  async executeSyncTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "TransactionTest.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      (this.store as relationalStore.RdbStore).createTransaction().then((transaction: relationalStore.Transaction) => {
        const SQL_DELETE_TABLE = 'DELETE FROM test';
        try {
          let data = (transaction as relationalStore.Transaction).executeSync(SQL_DELETE_TABLE);
          transaction.commit();
          console.log(`====>delete result: ${data}`);
          this.message += `====>executeSync success result: ${data} \n`;
          this.controller.caretPosition(this.message.length);
        } catch (e) {
          transaction.rollback();
          console.log(`====>delete failed, code is ${e.code}, message is ${e.message}`);
          this.message += `====>executeSync error: ${e.code} \n`;
          this.controller.caretPosition(this.message.length);
        }
        ;
      }).catch((err: BusinessError) => {
        console.log(`====>createTransaction failed, code is ${err.code},message is ${err.message}`);
      });
    }
  }

  async onStatisticsTask() {
    const STORE_NAME = "statistics.db"
    const CREATE_TABLE_SQL = "CREATE TABLE IF NOT EXISTS test (" +
      "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    const config: relationalStore.StoreConfig = {
      'name': STORE_NAME,
      securityLevel: relationalStore.SecurityLevel.S1,
    };
    this.store = await relationalStore.getRdbStore(this.context, config);
    await this.store.executeSql(CREATE_TABLE_SQL);
    if (this.store != undefined) {
      try {
        this.store.on('statistics', (SqlExeInfo) => {
          console.info("totalTime is : " + SqlExeInfo.totalTime);
          console.info("prepareTime is : " + SqlExeInfo.prepareTime);
          console.info("waitTime is : " + SqlExeInfo.waitTime);
          console.info("executeTime is : " + SqlExeInfo.executeTime);
          this.message += `====>onStatistics success totalTime is: ${SqlExeInfo.totalTime} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>onStatistics success prepareTime is: ${SqlExeInfo.prepareTime} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>onStatistics success waitTime is: ${SqlExeInfo.waitTime} \n`;
          this.controller.caretPosition(this.message.length);
          this.message += `====>onStatistics success executeTime is: ${SqlExeInfo.executeTime} \n`;
          this.controller.caretPosition(this.message.length);

        });
        this.store.off('statistics');
      } catch (err) {
        console.error(`on statistics fail, code:${err.code}, message: ${err.message}`);
        this.message += `====>onStatistics error: ${err.code} \n`;
        this.controller.caretPosition(this.message.length);
      }
      try {
        const valueBucket1: ValuesBucket = {
          'name': 'lisi',
          'age': 18,
          'salary': 25000,
          'blobType': new Uint8Array([1, 2, 3]),
        };
        let rowId = await this.store.insert('test', valueBucket1);
        this.message += `====>onStatistics success rowId: ${rowId} \n`;
        this.controller.caretPosition(this.message.length);
      } catch (error) {
        console.error(`insert fail, code:${error.code}, message: ${error.message}`);
        this.message += `====>onStatistics insert fail, code: ${error.code} \n`;
        this.controller.caretPosition(this.message.length);
      }
    }
  }

  async closeTask() {
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "Test.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      (this.store as relationalStore.RdbStore).close().then(() => {
        console.log(`====>close succeeded`);
        this.message += `====>close success \n`;
      }).catch((err: BusinessError) => {
        console.log(`====>close failed, code is ${err.code},message is ${err.message}`);
      });
    }
  }

  async getValueTask() {
    let predicates = new relationalStore.RdbPredicates("test");
    predicates.equalTo("name", "lisi111");
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";
    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "Test.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      const rdbTrans = await this.store.createTransaction(options);
      let bucket: relationalStore.ValuesBucket = {
        "name": "lisi111",
        "age": 1818,
        "salary": 100.555,
      };
      try {
        console.log("insert(test," + bucket + ")");
        let rowid = await rdbTrans.insert("test", bucket);
        await rdbTrans.commit();
        console.log("insert():=>" + rowid);
        this.message += `====>getValue success rowid: ${rowid} \n`;
        this.controller.caretPosition(this.message.length);
        let resultSet = await this.store.querySql("select name, age from test");
        console.log("query" + resultSet);
        let status = resultSet.goToNextRow();
        console.log("goToNextRow():=>" + status);
        let value1 = resultSet.getValue(0);
        let type = typeof value1;
        console.log("getValue(0):=>" + value1 + " type:" + type);
        this.message += `====>getValue success value1: ${value1} \n`;
        this.controller.caretPosition(this.message.length);
        this.message += `====>getValue success type: ${type} \n`;
        this.controller.caretPosition(this.message.length);
        let value2 = resultSet.getValue(1);
        type = typeof value2;
        console.log("getValue(1):=>" + value2 + " type:" + type);
        this.message += `====>getValue success value2: ${value2} \n`;
        this.controller.caretPosition(this.message.length);
        this.message += `====>getValue success type: ${type} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (err) {
        console.error(`failed, code:${err.code}, message: ${err.message}`);
      }
    }
  }

  async getRowTask() {
    let predicates = new relationalStore.RdbPredicates("test");
    predicates.equalTo("name", "lisi111");
    const CREATE_TABLE_TEST = "CREATE TABLE IF NOT EXISTS test (" + "id INTEGER PRIMARY KEY, " +
      "name TEXT NOT NULL, " + "age INTEGER, " + "salary REAL, " + "blobType BLOB)";

    let options: relationalStore.TransactionOptions = {
      transactionType: relationalStore.TransactionType.DEFERRED
    }
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "Test.db",
      securityLevel: relationalStore.SecurityLevel.S1,
    }
    this.store = await relationalStore.getRdbStore(this.context, STORE_CONFIG);
    await this.store.executeSql(CREATE_TABLE_TEST, null);
    if (this.store != undefined) {
      let bucket: relationalStore.ValuesBucket = {
        "name": "lisi111",
        "age": 1818,
        "salary": 100.555,
      };
      try {
        const rdbTrans = await this.store.createTransaction(options);
        console.log("insert(test," + bucket + ")");
        let rowid = await rdbTrans.insert("test", bucket);
        await rdbTrans.commit();
        console.log("insert():=>" + rowid);
        this.message += `====>getRow success rowid: ${rowid} \n`;
        this.controller.caretPosition(this.message.length);
        let resultSet = await this.store.querySql("select name, age from test");
        console.log("query" + resultSet);
        let status = resultSet.goToNextRow();
        console.log("goToNextRow():=>" + status);
        this.message += `====>getRow success status: ${status} \n`;
        this.controller.caretPosition(this.message.length);
        resultSet.close();
      } catch (err) {
        console.error(`failed, code:${err.code}, message: ${err.message}`);
      }
    }
  }
}
