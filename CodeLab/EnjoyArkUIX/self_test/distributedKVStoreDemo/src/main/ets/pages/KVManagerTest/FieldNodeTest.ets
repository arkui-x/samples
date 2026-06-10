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
struct FieldNodeTest {
  @State consoleInfo: string = "";

  private name: string = "root";
  private root: distributedKVStore.FieldNode | null = null;
  private child: distributedKVStore.FieldNode = new distributedKVStore.FieldNode("fieldNode");
  private kvManager: distributedKVStore.KVManager = distributedKVStore.createKVManager(kvManagerConfig);
  private router: Router = this.getUIContext().getRouter();

  scroller: Scroller = new Scroller()
  scroller2: Scroller = new Scroller()

  aboutToAppear(): void {
    this.child.type = distributedKVStore.ValueType.STRING;
    this.child.nullable = true;
    this.child.default = "";
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
        .title('FieldNode测试')
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
                Column() { // 参数设置区域一
                  Column() {
                    Row({ space: 10 }) {
                      Text('constructor的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项1
                    Row() {
                      Text("name: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ right: 4 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: '"root"' }, { value: "长度65的字符串" }, { value: '"+- *#"' }, { value: '""' }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value('"root"')
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.name = "root"
                              break
                            case 1:
                              this.name = "s".repeat(65)
                              break
                            case 2:
                              this.name = "+- *#"
                              break
                            case 3:
                              this.name = ""
                              break
                            case 4:
                              this.name = null!
                              break
                            case 5:
                              this.name = undefined!
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

                Button("constructor")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      this.root = new distributedKVStore.FieldNode(this.name);
                      this.root.type = distributedKVStore.ValueType.STRING;
                      this.root.nullable = true;
                      this.root.default = "";

                      if (this.root !== undefined) {
                        this.consoleInfo = "FieldNode创建成功";
                      } else {
                        this.consoleInfo = "创建FieldNode返回 undefined";
                      }
                    } catch (error) {
                      this.consoleInfo = `FieldNode创建失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 });


                Column() { // 参数设置区域二
                  Column() {
                    Row({ space: 10 }) {
                      Text('appendChild的参数')
                        .fontSize(18)
                        .margin({ top: 3 })
                        .fontColor('#182431')
                        .fontWeight(500);
                    }.width('100%')
                    .margin({ top: 5 });

                    // 参数选项1
                    Row() {
                      Text("child: ")
                        .fontWeight(FontWeight.Bold)
                        .margin({ right: 4 })
                        .backgroundColor('#F5F7FA')
                        .borderRadius(24)

                      Select([{ value: "FieldNode" }, { value: "null" }, { value: "undefined" }])
                        .selected(0)
                        .value("FieldNode")
                        .onSelect((index: number) => {
                          switch (index) {
                            case 0:
                              this.child = new distributedKVStore.FieldNode("fieldNode");
                              this.child.type = distributedKVStore.ValueType.STRING;
                              this.child.nullable = true;
                              this.child.default = "";
                              break
                            case 1:
                              this.child = null!
                              break
                            case 2:
                              this.child = undefined!
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

                Button("appendChild")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.root !== undefined) {
                        let result = this.root?.appendChild(this.child);
                        this.consoleInfo = result ? "添加成功" : "添加失败";
                      } else {
                        this.consoleInfo = "请先创建FieldNode";
                      }
                    } catch (error) {
                      this.consoleInfo = `调用失败，code: ${error.code}，message: ${error.message}`;
                    }
                  })
                  .margin({ bottom: 10 })

                Button("创建数据库")
                  .fontWeight(FontWeight.Bold)
                  .onClick(async () => {
                    try {
                      if (this.root !== undefined) {
                        let schema = new distributedKVStore.Schema();
                        schema.root.appendChild(this.root);
                        schema.indexes = [];
                        schema.mode = 0;
                        schema.skip = 0;

                        let options: distributedKVStore.Options = {
                          createIfMissing: true,
                          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
                          securityLevel: distributedKVStore.SecurityLevel.S3,
                          schema: schema
                        };

                        try {
                          await this.kvManager.deleteKVStore("com.example.distributedkvstoretest", "id");
                        } catch (error) {}

                        await this.kvManager.getKVStore("id", options).then((data: distributedKVStore.SingleKVStore) => {
                          if (data !== undefined) {
                            this.consoleInfo = "SingleKVStore创建成功";
                          }
                        }).catch((error: BusinessError) => {
                          this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
                        })

                      } else {
                        this.consoleInfo = "请先创建FieldNode";
                      }
                    } catch (error) {
                      this.consoleInfo = `SingleKVStore创建失败，code: ${error.code}，message: ${error.message}`;
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