/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { common } from '@kit.AbilityKit';
import { fileIo as fs, Options } from '@kit.CoreFileKit';
import fileIO from "@ohos.file.fs";
import router from '@ohos.router'
import { TitleBar } from './MainPage';

export const FILE_CONTENT = "hello world";
export function prepareFile(fpath:string, content:string) {
  try {
    let file = fileIO.openSync(fpath, fileIO.OpenMode.CREATE | fileIO.OpenMode.READ_WRITE);
    fileIO.truncateSync(file.fd);
    fileIO.writeSync(file.fd, content);
    fileIO.fsyncSync(file.fd);
    fileIO.closeSync(file);
    return true;
  } catch (e) {
    console.log("Failed to prepareFile for " + e);
    return false;
  }
}

@Entry
@Component
struct Index {
  @State message: string = 'WelCome!'
  @State text: string = 'readLines'
  @State title: string = ''

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column() {
      TitleBar({ title: this.title }).size({ height: '10%' })
      Row(){
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('40%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      List({ space: 10 }) {
        ListItem() {
          Button("readLines")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let options: Options = {
                encoding: 'utf-8'
              };
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath: string = pathDir + "/text1.txt";
              console.info("filePath: " + filePath);
              console.info("content: into");

              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              let str: string = "hello world \n promise";
              fs.write(file.fd, str, options).then((writeLen: number) => {
                console.info("write data to file succeed and size is:" + writeLen);
              }).catch((err: BusinessError) => {
                console.error("write data to file failed with error message: " + err.message + ", error code: " +
                err.code);
              }).finally(() => {
                fs.closeSync(file);
              });

              file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              fs.readLines(filePath, options).then((readerIterator: fs.ReaderIterator) => {
                console.info("content: start");
                for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
                  this.message += it.value;
                  console.info("content: " + it.value);
                }
              }).catch((err: BusinessError) => {
                console.error("readLines failed with error message: " + err.message + ", error code: " + err.code);
              });
              fs.closeSync(file);
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("readLinesCallback")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              console.info("Into readLinesSync");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath: string = pathDir + "/text9.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

              console.info("content: success to openSync");
              let str: string = "hello world \n callback";
              fs.write(file.fd, str).then((writeLen: number) => {
                console.info("write data to file succeed and size is:" + writeLen);
              }).catch((err: BusinessError) => {
                console.error("write data to file failed with error message: " + err.message + ", error code: " +
                err.code);
              }).finally(() => {
                fs.closeSync(file);
              });
              file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              let options: Options = {
                encoding: 'utf-8'
              };
              fs.readLines(filePath, options, (err: BusinessError, readerIterator: fs.ReaderIterator) => {
                if (err) {
                  console.error("readLines failed with error message: " + err.message + ", error code: " + err.code);
                } else {
                  for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
                    console.info("content: " + it.value);
                    this.message += it.value;
                  }
                }
              });
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("readLinesSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              console.info("Into readLinesSync");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath: string = pathDir + "/text8.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

              console.info("content: success to openSync");
              let str: string = "hello world \n Sync";
              fs.write(file.fd, str).then((writeLen: number) => {
                console.info("write data to file succeed and size is:" + writeLen);
              }).catch((err: BusinessError) => {
                console.error("write data to file failed with error message: " + err.message + ", error code: " +
                err.code);
              }).finally(() => {
                fs.closeSync(file);
              });
              file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              let options: Options = {
                encoding: 'utf-8'
              };
              let readerIterator = fs.readLinesSync(filePath, options);
              for (let it = readerIterator.next();!it.done; it = readerIterator.next()) {
                console.info("content: " + it.value);
                this.message += it.value;
              }
              fs.closeSync(file);
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("fs.lseek")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("Into");
              this.message = 'Into';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath: string = pathDir + "/text2.txt";

              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              console.info("content: success to openSync");
              console.info('The current offset is at ' + fs.lseek(file.fd, 5, fs.WhenceType.SEEK_SET));
              this.message = "log: Test fs.lseek success";
              fs.closeSync(file);
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("fs.utimes")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("Into");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath: string = pathDir + "/text3.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              console.info("content: success to openSync");
              fs.writeSync(file.fd, 'test data');
              console.info("content: success to write");
              fs.closeSync(file);
              console.info("content: success to closeSync");
              fs.utimes(filePath, new Date().getTime());
              console.info('The time' + new Date().getTime());
              this.message = "log: Test fs.utimes success";
            })
            .width(350)
            .height(60)
        }
        ListItem() {
          Button("getParent")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("Into unLock");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath: string = pathDir + "/text7.txt";
              console.info("content: filePath " + filePath);
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              console.info("content: success to openSync");
              console.info('The parent path is: ' + file.getParent());
              this.message = file.getParent();
              fs.closeSync(file);
            })
            .width(350)
            .height(60)
        }
      }
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}