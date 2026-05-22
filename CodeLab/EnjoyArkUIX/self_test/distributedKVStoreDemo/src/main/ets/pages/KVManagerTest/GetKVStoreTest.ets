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
struct GetKVStoreTest {
  @State consoleInfo: string = "";

  @State storeId_selectIndex: number = 0;
  @State createIfMissing_selectIndex: number = 0;
  @State indexes_selectIndex: number = 0;
  @State mode_selectIndex: number = 0;
  @State skip_selectIndex: number = 0;
  @State nullable_selectIndex: number = 0;
  @State type_selectIndex: number = 0;
  @State default_selectIndex: number = 0;

  @State storeId_selectValue: string = '"storeId_1"';
  @State createIfMissing_selectValue: string = "true";
  @State indexes_selectValue: string = '["$.id", "$.name"]';
  @State mode_selectValue: string = "0";
  @State skip_selectValue: string = "0";
  @State nullable_selectValue: string = "true";
  @State type_selectValue: string = "INTEGER";
  @State default_selectValue: string = "100";

  private router: Router = this.getUIContext().getRouter();
  private storeId: string = "storeId_1";
  private createIfMissing: boolean = true;
  private kvStoreType: distributedKVStore.KVStoreType = distributedKVStore.KVStoreType.SINGLE_VERSION;
  private indexes: Array<string> = ['$.id', '$.name'];
  private mode: number = 0;
  private skip: number = 0;
  private nullable: boolean = true;
  private type: distributedKVStore.ValueType = distributedKVStore.ValueType.INTEGER;
  private default: string = "100";
  private keyStr: string = "key_1";
  private value: string = '{"id":0, "name":"lisi"}';
  private keyStr2: string = "key_1";
  private value2: string = '{"id":0, "name":"lisi"}';

  private kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(kvManagerConfig);
  private singleKVStore: distributedKVStore.SingleKVStore | undefined = undefined;
  private singleKVStore2: distributedKVStore.SingleKVStore | undefined = undefined;
  private fieldNode1: distributedKVStore.FieldNode | undefined = undefined;
  private fieldNode2: distributedKVStore.FieldNode | undefined = undefined;
  private schema: distributedKVStore.Schema | undefined = undefined;

  private controller: TabsController = new TabsController();
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
        .title('getKVStore测试')
        .mode(NavigationMode.Stack);
      } // 导航栏
      .height(56)
      .width('100%')
      .onClick(async () => {
        this.router.back();
      });

      Row() { //这一行放了返回之外的一整页
        Column() { //数个页面
          Tabs({ barPosition: BarPosition.Start, index: 0, controller: this.controller }) {
            // 界面一: 传入可选参数
            TabContent() {
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
                            Text('storeId参数')
                              .fontSize(18)
                              .margin({ top: 3 })
                              .fontColor('#182431')
                              .fontWeight(500);
                          }.width('100%')
                          .margin({ top: 5 });

                          // 参数选项
                          Row() {
                            Text("storeId: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: '"storeId_1"' }, { value: "超长的字符串" }, { value: '"！@#￥"' }, { value: '""' },
                              { value: "null" }, { value: "undefined" }])
                              .selected(this.storeId_selectIndex)
                              .value(this.storeId_selectValue)
                              // .optionWidth("300vp")
                              .onSelect((index: number, value: string) => {
                                this.storeId_selectIndex = index;
                                this.storeId_selectValue = value;
                                switch (index) {
                                  case 0:
                                    this.storeId = "storeId_1"
                                    break
                                  case 1:
                                    this.storeId = "s".repeat(maxStoreIdLength + 1);
                                    break
                                  case 2:
                                    this.storeId = "！@#￥"
                                    break
                                  case 3:
                                    this.storeId = ""
                                    break
                                  case 4:
                                    this.storeId = null!
                                    break
                                  case 5:
                                    this.storeId = undefined!
                                    break
                                }
                              }) // .constraintSize({ maxWidth: '90%' })
                          }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                        }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                      } // 参数设置区域一
                      .width('100%')
                      .padding({ left: '3.35%', right: '3.35%' })
                      .backgroundColor(Color.White)
                      .margin({ bottom: 16 })
                      .borderRadius(24)

                      Column() { // 参数设置区域二
                        Column() {
                          Row({ space: 10 }) {
                            Text('options参数')
                              .fontSize(18)
                              .margin({ top: 3 })
                              .fontColor('#182431')
                              .fontWeight(500);
                          }.width('100%')
                          .margin({ top: 5 });

                          // 参数选项
                          Row() {
                            Text("createIfMissing: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: "true" }, { value: "false" }])
                              .selected(this.createIfMissing_selectIndex)
                              .value(this.createIfMissing_selectValue)
                              .onSelect((index: number, value: string) => {
                                this.createIfMissing_selectIndex = index;
                                this.createIfMissing_selectValue = value;
                                switch (index) {
                                  case 0:
                                    this.createIfMissing = true
                                    break
                                  case 1:
                                    this.createIfMissing = false
                                    break
                                }
                              })
                          }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                          // 参数选项
                          Row() {
                            Text("kvStoreType: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: "SINGLE_VERSION" }])
                              .selected(0)
                              .value("SINGLE_VERSION")
                              .onSelect((index: number, value: string) => {
                                switch (index) {
                                  case 0:
                                    this.kvStoreType = distributedKVStore.KVStoreType.SINGLE_VERSION
                                    break
                                }
                              })
                          }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                          // 子参数区域
                          Column() {
                            Column() {
                              Row() {
                                Text('schema参数')
                                  .fontSize(16)
                                  .margin({ left: 5, bottom: 5 })
                              }.justifyContent(FlexAlign.SpaceBetween).width('100%').height(35)
                              .margin({ top: 3, left: 3 })

                              // 参数选项
                              Row() {
                                Text("indexes: ")
                                  .fontWeight(FontWeight.Bold)
                                  .margin({ left: 8 })
                                  .backgroundColor('#F5F7FA')
                                  .borderRadius(24)

                                Select([{ value: '["$.id", "$.name"]' }, { value: '["abc", "def"]' }, { value: '[""]' }, { value: '[]' }])
                                  .selected(this.indexes_selectIndex)
                                  .value(this.indexes_selectValue)
                                  .onSelect((index: number, value: string) => {
                                    this.indexes_selectIndex = index;
                                    this.indexes_selectValue = value;
                                    switch (index) {
                                      case 0:
                                        this.indexes = ["$.id", "$.name"]
                                        break
                                      case 1:
                                        this.indexes = ["abc", "def"]
                                        break
                                      case 2:
                                        this.indexes = [""]
                                        break
                                      case 3:
                                        this.indexes = []
                                        break
                                    }
                                  })
                              }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                              // 参数选项
                              Row() {
                                Text("mode: ")
                                  .fontWeight(FontWeight.Bold)
                                  .margin({ left: 8 })
                                  .backgroundColor('#F5F7FA')
                                  .borderRadius(24)

                                Select([{ value: "0" }, { value: "1" }, { value: "-10" }])
                                  .selected(this.mode_selectIndex)
                                  .value(this.mode_selectValue)
                                  .onSelect((index: number, value: string) => {
                                    this.mode_selectIndex = index;
                                    this.mode_selectValue = value;
                                    switch (index) {
                                      case 0:
                                        this.mode = 0
                                        break
                                      case 1:
                                        this.mode = 1
                                        break
                                      case 2:
                                        this.mode = -10
                                        break
                                    }
                                  })
                              }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                              // 参数选项
                              Row() {
                                Text("skip: ")
                                  .fontWeight(FontWeight.Bold)
                                  .margin({ left: 8 })
                                  .backgroundColor('#F5F7FA')
                                  .borderRadius(24)

                                Select([{ value: "0" }, { value: "4" }, { value: "-10" }, { value: "4 * 1024 * 1024" }])
                                  .selected(this.skip_selectIndex)
                                  .value(this.skip_selectValue)
                                  .onSelect((index: number, value: string) => {
                                    this.skip_selectIndex = index;
                                    this.skip_selectValue = value;
                                    switch (index) {
                                      case 0:
                                        this.skip = 0
                                        break
                                      case 1:
                                        this.skip = 4
                                        break
                                      case 2:
                                        this.skip = -10
                                        break
                                      case 3:
                                        this.skip = 4 * 1024 * 1024
                                        break
                                    }
                                  })
                              }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                              // 子子参数区域
                              Column() {
                                Column() {
                                  Row() {
                                    Text('root参数')
                                      .fontSize(16)
                                      .margin({ left: 5, bottom: 5 })
                                  }.justifyContent(FlexAlign.SpaceBetween).width('100%').height(35)
                                  .margin({ top: 3, left: 3 })

                                  // 参数选项
                                  Row() {
                                    Text("nullable: ")
                                      .fontWeight(FontWeight.Bold)
                                      .margin({ left: 8 })
                                      .backgroundColor('#F5F7FA')
                                      .borderRadius(24)

                                    Select([{ value: "true" }, { value: "false" }])
                                      .selected(this.nullable_selectIndex)
                                      .value(this.nullable_selectValue)
                                      .onSelect((index: number, value: string) => {
                                        this.nullable_selectIndex = index;
                                        this.nullable_selectValue = value;
                                        switch (index) {
                                          case 0:
                                            this.nullable = true
                                            break
                                          case 1:
                                            this.nullable = false
                                            break
                                        }
                                      })
                                  }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                                  // 参数选项
                                  Row() {
                                    Text("type: ")
                                      .fontWeight(FontWeight.Bold)
                                      .margin({ left: 8 })
                                      .backgroundColor('#F5F7FA')
                                      .borderRadius(24)

                                    Select([{ value: "INTEGER" }, { value: "STRING" }, { value: "FLOAT" }, { value: "BOOLEAN" }, { value: "DOUBLE" },
                                      { value: "-10" }])
                                      .selected(this.type_selectIndex)
                                      .value(this.type_selectValue)
                                      .onSelect((index: number, value: string) => {
                                        this.type_selectIndex = index;
                                        this.type_selectValue = value;
                                        switch (index) {
                                          case 0:
                                            this.type = distributedKVStore.ValueType.INTEGER
                                            break
                                          case 1:
                                            this.type = distributedKVStore.ValueType.STRING
                                            break
                                          case 2:
                                            this.type = distributedKVStore.ValueType.FLOAT
                                            break
                                          case 3:
                                            this.type = distributedKVStore.ValueType.BOOLEAN
                                            break
                                          case 4:
                                            this.type = distributedKVStore.ValueType.DOUBLE
                                            break
                                          case 5:
                                            this.type = -10
                                            break
                                        }
                                      })
                                  }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                                  // 参数选项
                                  Row() {
                                    Text("default: ")
                                      .fontWeight(FontWeight.Bold)
                                      .margin({ left: 8 })
                                      .backgroundColor('#F5F7FA')
                                      .borderRadius(24)

                                    Select([{ value: '"100"' }, { value: '"a string"' }, { value: '"3.1415926"' }, { value: '"true"' }])
                                      .selected(this.default_selectIndex)
                                      .value(this.default_selectValue)
                                      .onSelect((index: number, value: string) => {
                                        this.default_selectIndex = index;
                                        this.default_selectValue = value;
                                        switch (index) {
                                          case 0:
                                            this.default = "100"
                                            break
                                          case 1:
                                            this.default = "a string"
                                            break
                                          case 2:
                                            this.default = "3.1415926"
                                            break
                                          case 3:
                                            this.default = "true"
                                            break
                                        }
                                      })
                                  }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)

                                  Row() { // 子子参数区域 按钮
                                    Button('创建"id"节点')
                                      .type(ButtonType.Capsule)
                                      // .margin({ left: 4 })
                                      .backgroundColor('#0D9FFB')
                                      .onClick(() => {
                                        try {
                                          this.fieldNode1 = new distributedKVStore.FieldNode("id");
                                          this.fieldNode1.type = this.type;
                                          this.fieldNode1.nullable = this.nullable;
                                          this.fieldNode1.default = this.default;
                                          this.consoleInfo = '创建"id"节点成功';
                                        } catch (error) {
                                          this.consoleInfo = `创建失败，code: ${error.code}，message: ${error.message}`;
                                        }
                                      })

                                    Button('创建"name"节点')
                                      .type(ButtonType.Capsule)
                                      // .margin({ left: 4 })
                                      .backgroundColor('#0D9FFB')
                                      .onClick(() => {
                                        try {
                                          this.fieldNode2 = new distributedKVStore.FieldNode("name");
                                          this.fieldNode2.type = this.type;
                                          this.fieldNode2.nullable = this.nullable;
                                          this.fieldNode2.default = this.default;
                                          this.consoleInfo = '创建"name"节点成功';
                                        } catch (error) {
                                          this.consoleInfo = `创建失败，code: ${error.code}，message: ${error.message}`;
                                        }
                                      })
                                  }.margin({ top: 10, bottom: 10 })

                                }.margin({left:4,right:4,top:4,bottom:4})
                                .backgroundColor(Color.White)
                                .borderRadius(24)
                              }.margin({left:4,right:4})
                              .backgroundColor('#F1F3F5') // 子子参数区域
                              .borderRadius(24)

                              Button('创建Schema对象')
                                .type(ButtonType.Capsule)
                                // .margin({ left: 4 })
                                .backgroundColor('#0D9FFB')
                                .onClick(() => {
                                  try {
                                    this.schema = new distributedKVStore.Schema();
                                    this.schema.root.appendChild(this.fieldNode1);
                                    this.schema.root.appendChild(this.fieldNode2);
                                    this.schema.indexes = this.indexes;
                                    this.schema.mode = this.mode;
                                    this.schema.skip = this.skip;
                                    this.consoleInfo = "创建Schema对象成功";
                                  } catch (error) {
                                    this.consoleInfo = `创建失败，code: ${error.code}，message: ${error.message}`;
                                  }
                                })
                                .margin({ top: 10, bottom: 10 })

                            }.margin({left:4,right:4,top:4,bottom:4})
                            .backgroundColor(Color.White)
                            .borderRadius(24)
                          }.margin({bottom:8})
                          .backgroundColor('#F1F3F5') // 子参数区域
                          .borderRadius(24)

                        }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                      } // 参数设置区域二
                      .width('100%')
                      .padding({ left: '3.35%', right: '3.35%' })
                      .backgroundColor(Color.White)
                      .margin({ bottom: 16 })
                      .borderRadius(24)

                      Button("重置所有参数选项")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          this.storeId_selectIndex = 0;
                          this.createIfMissing_selectIndex = 0;
                          this.indexes_selectIndex = 0;
                          this.mode_selectIndex = 0;
                          this.skip_selectIndex = 0;
                          this.nullable_selectIndex = 0;
                          this.type_selectIndex = 0;
                          this.default_selectIndex = 0;

                          this.storeId_selectValue = '"storeId_1"';
                          this.createIfMissing_selectValue = "true";
                          this.indexes_selectValue = '["$.id", "$.name"]';
                          this.mode_selectValue = "0";
                          this.skip_selectValue = "0";
                          this.nullable_selectValue = "true";
                          this.type_selectValue = "INTEGER";
                          this.default_selectValue = "100";

                          this.storeId = "storeId_1";
                          this.createIfMissing = true;
                          this.indexes = ["$.id", "$.name"];
                          this.mode = 0;
                          this.skip = 0;
                          this.nullable = true;
                          this.type = distributedKVStore.ValueType.INTEGER;
                          this.default = "100";

                          this.fieldNode1 = undefined;
                          this.fieldNode2 = undefined;

                          this.consoleInfo = "参数重置完成";
                        })
                        .margin({ bottom: 10 })

                      Button("关闭数据库")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          try {
                            await this.kvManager.closeKVStore("com.example.distributedkvstoretest", "storeId_1");
                            this.consoleInfo = "关闭完成";
                          } catch (error) {
                            this.consoleInfo = `关闭失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("删除数据库")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          try {
                            await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "storeId_1");
                          } catch (error) {}

                          this.singleKVStore = undefined;
                          this.consoleInfo = "删除完成";
                        })
                        .margin({ bottom: 10 })

                      Button("getKVStore_Callback")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          let options: distributedKVStore.Options = {
                            createIfMissing: this.createIfMissing,
                            kvStoreType: this.kvStoreType,
                            securityLevel: distributedKVStore.SecurityLevel.S3,
                            schema: this.schema
                          };

                          try {
                            this.kvManager.getKVStore(this.storeId, options, (error: BusinessError, data: distributedKVStore.SingleKVStore) => {
                              if (error) {
                                this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                              } else {
                                this.singleKVStore = data;
                                if (this.singleKVStore !== undefined) {
                                  this.consoleInfo = "SingleKVStore创建成功 callback";
                                }
                              }
                            })
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("getKVStore_Promise")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          let options: distributedKVStore.Options = {
                            createIfMissing: this.createIfMissing,
                            kvStoreType: this.kvStoreType,
                            securityLevel: distributedKVStore.SecurityLevel.S3,
                            schema: this.schema
                          };

                          try {
                            await this.kvManager.getKVStore(this.storeId, options).then((data: distributedKVStore.SingleKVStore) => {
                              this.singleKVStore = data;
                              if (this.singleKVStore !== undefined) {
                                this.consoleInfo = "SingleKVStore创建成功 promise";
                              }
                            }).catch((error: BusinessError) => {
                              this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                            })
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
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

                          // 参数选项
                          Row() {
                            Text("key: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: '"key_1"' }, { value: '"key_2"' }, { value: '"key_3"' }, { value: '"key_4"' }, { value: '"key_5"' },
                              { value: '"key_6"' }])
                              .selected(0)
                              .value('"key_1"')
                              // .optionWidth("300vp")
                              .onSelect((index: number, value: string) => {
                                switch (index) {
                                  case 0:
                                    this.keyStr = "key_1"
                                    break
                                  case 1:
                                    this.keyStr = "key_2";
                                    break
                                  case 2:
                                    this.keyStr = "key_3";
                                    break
                                  case 3:
                                    this.keyStr = "key_4";
                                    break
                                  case 4:
                                    this.keyStr = "key_5";
                                    break
                                  case 5:
                                    this.keyStr = "key_6";
                                    break
                                }
                              }) // .constraintSize({ maxWidth: '90%' })
                          }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                          // 参数选项
                          Row() {
                            Text("value: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: '"{"id":0, "name":"lisi"}"' }, { value: '"{"str":"string"}"' }, { value: '"string"' }, { value: '"{}"' },
                              { value: '"{"id":null, "name":null}"' }, { value: '"{"id":1}"' }, { value: '"{"id":"string"}"' },
                              { value: '"{"id":9.99}"' }, { value: '"{"id":false}"' }, { value: '"test{"id":6}"' }])
                              .selected(0)
                              .value('"{"id":0, "name":"lisi"}"')
                              // .optionWidth("250vp")
                              .onSelect((index: number, value: string) => {
                                switch (index) {
                                  case 0:
                                    this.value = '{"id":0, "name":"lisi"}'
                                    break
                                  case 1:
                                    this.value = '{"str":"string"}';
                                    break
                                  case 2:
                                    this.value = 'string';
                                    break
                                  case 3:
                                    this.value = '{}';
                                    break
                                  case 4:
                                    this.value = '{"id":null, "name":null}';
                                    break
                                  case 5:
                                    this.value = '{"id":1}';
                                    break
                                  case 6:
                                    this.value = '{"id":"string"}';
                                    break
                                  case 7:
                                    this.value = '{"id":9.99}';
                                    break
                                  case 8:
                                    this.value = '{"id":false}';
                                    break
                                  case 9:
                                    this.value = 'test{"id":6}';
                                    break
                                }
                              }) // .constraintSize({ maxWidth: '90%' })
                          }.margin({ top: 10 }).justifyContent(FlexAlign.Center)


                          // 按钮
                          Row() {
                            Button("put")
                              .fontWeight(FontWeight.Bold)
                              .onClick(async () => {
                                try {
                                  if (this.singleKVStore !== undefined) {
                                    await this.singleKVStore.put(this.keyStr, this.value).then(() => {
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

                            // Button("查")
                            //   .fontWeight(FontWeight.Bold)
                            //   .onClick(async () => {
                            //     try {
                            //       if (this.singleKVStore !== undefined) {
                            //         let query: distributedKVStore.Query | null = new distributedKVStore.Query();
                            //         if (query != null) {
                            //           query.equalTo("id", 100);
                            //           console.info(`query is ${query.getSqlLike()}`);
                            //         }
                            //
                            //         await this.singleKVStore.getEntries(query).then((entries: distributedKVStore.Entry[]) => {
                            //           let str = `共有${entries.length}条数据` + "\n";
                            //           entries.forEach((value: distributedKVStore.Entry, index: number) => {
                            //             str += `${index + 1}. key: ${value.key}, value: ${value.value.value}` + "\n";
                            //           });
                            //
                            //           this.uiContext.showAlertDialog({
                            //             title: '数据库内容弹窗',
                            //             message: str,
                            //             primaryButton: {
                            //               value: '关闭',
                            //               backgroundColor: '#F5F7FA',
                            //               action: () => {}
                            //             },
                            //
                            //           })
                            //         }).catch((error: BusinessError) => {
                            //           this.consoleInfo = `数据获取失败，code: ${error.code}，message: ${error.message}`;
                            //         });
                            //       } else {
                            //         this.consoleInfo = "请先创建数据库";
                            //       }
                            //     } catch (error) {
                            //       this.consoleInfo = `数据插入失败，code: ${error.code}，message: ${error.message}`;
                            //     }
                            //   })
                            //   .margin({ bottom: 10 })
                          }.margin({ top: 10, bottom: 10 }).justifyContent(FlexAlign.Center)


                        }.justifyContent(FlexAlign.SpaceBetween).width('100%').margin({ top: 5 });
                      } // 数据插入区域
                      .width('100%')
                      .padding({ left: '3.35%', right: '3.35%' })
                      .backgroundColor(Color.White)
                      .margin({ bottom: 16 })
                      .borderRadius(24)


                      Button("getKVStore_Callback_options参数为null")
                        .fontWeight(FontWeight.Bold)
                        .backgroundColor(Color.Orange)
                        .onClick(async () => {
                          try {
                            this.kvManager.getKVStore("111", null, (error: BusinessError, data: distributedKVStore.SingleKVStore) => {
                              if (error) {
                                this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                              } else {
                                this.singleKVStore = data;
                                if (this.singleKVStore !== undefined) {
                                  this.consoleInfo = "SingleKVStore创建成功 callback";
                                }
                              }
                            })
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("getKVStore_Callback_options参数为undefined")
                        .fontWeight(FontWeight.Bold)
                        .backgroundColor(Color.Orange)
                        .onClick(async () => {
                          try {
                            this.kvManager.getKVStore("111", undefined, (error: BusinessError, data: distributedKVStore.SingleKVStore) => {
                              if (error) {
                                this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                              } else {
                                this.singleKVStore = data;
                                if (this.singleKVStore !== undefined) {
                                  this.consoleInfo = "SingleKVStore创建成功 callback";
                                }
                              }
                            })
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("getKVStore_Callback_Callback参数为null")
                        .fontWeight(FontWeight.Bold)
                        .backgroundColor(Color.Orange)
                        .onClick(async () => {
                          let options: distributedKVStore.Options = {
                            createIfMissing: this.createIfMissing,
                            kvStoreType: this.kvStoreType,
                            securityLevel: distributedKVStore.SecurityLevel.S3,
                            schema: this.schema
                          };

                          try {
                            this.kvManager.getKVStore("111", options, null);
                            this.consoleInfo = `未抛出异常`;
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("getKVStore_Callback_Callback参数为undefined")
                        .fontWeight(FontWeight.Bold)
                        .backgroundColor(Color.Orange)
                        .onClick(async () => {
                          let options: distributedKVStore.Options = {
                            createIfMissing: this.createIfMissing,
                            kvStoreType: this.kvStoreType,
                            securityLevel: distributedKVStore.SecurityLevel.S3,
                            schema: this.schema
                          };

                          try {
                            this.kvManager.getKVStore("111", options, undefined);
                            this.consoleInfo = `未抛出异常`;
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                    }
                  }
                }.height('75%')
              }.width('100%').height('100%')
            }
            .tabBar(new BottomTabBarStyle($r('sys.media.ohos_app_icon'), "传入可选参数"))


            // 界面二: 传入可选参数
            TabContent() {
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
                      Button("删除数据库")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          try {
                            await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "storeId_2");
                          } catch (error) {}

                          this.singleKVStore = undefined;
                          this.consoleInfo = "删除完成";
                        })
                        .margin({ top: 10, bottom: 10 })

                      Button("getKVStore_Callback")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          let options: distributedKVStore.Options = {
                            // kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                            securityLevel: distributedKVStore.SecurityLevel.S3,
                          };

                          try {
                            this.kvManager.getKVStore("storeId_2", options, (error: BusinessError, data: distributedKVStore.SingleKVStore) => {
                              if (error) {
                                this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                              } else {
                                this.singleKVStore2 = data;
                                if (this.singleKVStore2 !== undefined) {
                                  this.consoleInfo = "SingleKVStore创建成功 callback";
                                }
                              }
                            })
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                          }
                        })
                        .margin({ bottom: 10 })

                      Button("getKVStore_Promise")
                        .fontWeight(FontWeight.Bold)
                        .onClick(async () => {
                          let options: distributedKVStore.Options = {
                            // kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                            securityLevel: distributedKVStore.SecurityLevel.S3,
                          };

                          try {
                            await this.kvManager.getKVStore("storeId_2", options).then((data: distributedKVStore.SingleKVStore) => {
                              this.singleKVStore2 = data;
                              if (this.singleKVStore2 !== undefined) {
                                this.consoleInfo = "SingleKVStore创建成功 promise";
                              }
                            }).catch((error: BusinessError) => {
                              this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                            })
                          } catch (error) {
                            this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
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

                          // 参数选项
                          Row() {
                            Text("key: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: '"key_1"' }, { value: '"key_2"' }])
                              .selected(0)
                              .value('"key_1"')
                              // .optionWidth("300vp")
                              .onSelect((index: number, value: string) => {
                                switch (index) {
                                  case 0:
                                    this.keyStr2 = "key_1"
                                    break
                                  case 1:
                                    this.keyStr2 = "key_2";
                                    break
                                }
                              }) // .constraintSize({ maxWidth: '90%' })
                          }.margin({ top: 10 }).justifyContent(FlexAlign.Center)

                          // 参数选项
                          Row() {
                            Text("value: ")
                              .fontWeight(FontWeight.Bold)
                              .margin({ left: 8 })
                              .backgroundColor('#F5F7FA')
                              .borderRadius(24)

                            Select([{ value: '"{"id":0, "name":"lisi"}"' }, { value: '"string"' }])
                              .selected(0)
                              .value('"{"id":0, "name":"lisi"}"')
                              // .optionWidth("250vp")
                              .onSelect((index: number, value: string) => {
                                switch (index) {
                                  case 0:
                                    this.value2 = '{"id":0, "name":"lisi"}'
                                    break
                                  case 1:
                                    this.value2 = 'string';
                                    break
                                }
                              }) // .constraintSize({ maxWidth: '90%' })
                          }.margin({ top: 10 }).justifyContent(FlexAlign.Center)


                          // 按钮
                          Row() {
                            Button("put")
                              .fontWeight(FontWeight.Bold)
                              .onClick(async () => {
                                try {
                                  if (this.singleKVStore2 !== undefined) {
                                    await this.singleKVStore2.put(this.keyStr2, this.value2).then(() => {
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
                                  if (this.singleKVStore2 !== undefined) {
                                    await this.singleKVStore2.getEntries("^").then((entries: distributedKVStore.Entry[]) => {
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
            }
            .tabBar(new BottomTabBarStyle($r('sys.media.ohos_app_icon'), "不传入可选参数"))

          }
          .vertical(false)
          .barMode(BarMode.Fixed)
          .scrollable(true)
        } // 数个界面

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