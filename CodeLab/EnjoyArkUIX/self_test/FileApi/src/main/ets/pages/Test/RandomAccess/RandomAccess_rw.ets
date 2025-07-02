import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { fileIo as fs, Filter, ListFileOptions, ReadOptions,ReadTextOptions, WriteOptions  } from '@kit.CoreFileKit';
import { router } from '@kit.ArkUI';
import { TitleBar } from '../../MainPage';

export default class EntryAbility extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage) {
    let context = this.context;
    let pathDir = context.filesDir;
  }
}

@Entry
@Component
struct Index {
  @State writeMessage: string = '';
  @State readMessage: string = '';
  @State title: string = '';
  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column({ space: 20 }) {
      TitleBar({ title: this.title }).size({ height: '10%' })
      Row() {
        Text(this.writeMessage)
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('15%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      Row() {
        Text(this.readMessage)
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('15%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      Column() {
        Row() {
          Button("setFilePointer")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(120)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;let filePath = pathDir + "/test.txt";
              let randomAccessFile = fs.createRandomAccessFileSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              randomAccessFile.setFilePointer(1);
              this.writeMessage = "setFilePointer succeed";
              randomAccessFile.close();
            })
        }
      }
      .width('100%')
      .height('10%')
      .justifyContent(FlexAlign.Center)

      Grid() {
        GridItem() {
          Button("Write-Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              let randomAccessFile = fs.createRandomAccessFileSync(file);
              let bufferLength: number = 4096;
              let writeOption: WriteOptions = {
                offset: 1,
                length: 5,
                encoding: 'utf-8'
              };
              let arrayBuffer = new ArrayBuffer(bufferLength);
              randomAccessFile.write(arrayBuffer, writeOption).then((bytesWritten: number) => {
                this.writeMessage = "Write (Promise) 写入成功，长度： " + bytesWritten.toString();
              }).catch((err: BusinessError) => {
                this.writeMessage = "Write (Promise) 写入失败： " + err.message + ", error code: " + err.code;
              }).finally(() => {
                randomAccessFile.close();
                fs.closeSync(file);
              });
            })
        }
        GridItem() {
          Button("Read-Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              let randomAccessFile = fs.createRandomAccessFileSync(file);
              let bufferLength: number = 4096;
              let readOption: ReadOptions = {
                offset: 1,
                length: 5
              };
              let arrayBuffer = new ArrayBuffer(bufferLength);
              randomAccessFile.read(arrayBuffer, readOption).then((readLength: number) => {
                this.readMessage = "Read (Promise) 读取成功，长度： " + readLength.toString();
              }).catch((err: BusinessError) => {
                this.readMessage = "Read (Promise) 读取失败： " + err.message + ", error code: " + err.code;
              }).finally(() => {
                randomAccessFile.close();
                fs.closeSync(file);
              });
            })
        }

        GridItem() {
          Button("Write-Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              let randomAccessFile = fs.createRandomAccessFileSync(file);
              let bufferLength: number = 4096;
              let writeOption: WriteOptions = {
                offset: 1,
                length: bufferLength,
                encoding: 'utf-8'
              };
              let arrayBuffer = new ArrayBuffer(bufferLength);
              randomAccessFile.write(arrayBuffer, writeOption, (err: BusinessError, bytesWritten: number) => {
                if (err) {
                  this.writeMessage = "Write (Callback) 写入失败： " + err.message + ", error code: " + err.code;
                } else {
                  if (bytesWritten) {
                    this.writeMessage = "Write (Callback) 写入成功，长度： " + bytesWritten.toString();
                  }
                }
                randomAccessFile.close();
                fs.closeSync(file);
              });
            })
        }
        GridItem() {
          Button("Read-Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              let randomAccessFile = fs.createRandomAccessFileSync(file);
              let length: number = 20;
              let readOption: ReadOptions = {
                offset: 1,
                length: length
              };
              let arrayBuffer = new ArrayBuffer(length);
              randomAccessFile.read(arrayBuffer, readOption, (err: BusinessError, readLength: number) => {
                if (err) {
                  this.readMessage = "Read (Callback) 读取失败： " + err.message + ", error code: " + err.code;
                } else {
                  if (readLength) {
                    this.readMessage = "Read (Callback) 读取成功，长度： " + readLength.toString();
                  }
                }
                randomAccessFile.close();
                fs.closeSync(file);
              });
            })
        }

        GridItem() {
          Button("Write-Sync")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let randomAccessFile = fs.createRandomAccessFileSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              let writeOption: WriteOptions = {
                offset: 5,
                length: 10,
                encoding: 'utf-8'
              };
              let length = 100;
              let bytesWritten = randomAccessFile.writeSync(new ArrayBuffer(length));
              randomAccessFile.close();
              this.writeMessage = "Write (Sync) 写入成功，长度： " + bytesWritten.toString();
            })
        }
        GridItem() {
          Button("Read-Sync")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(150)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              let randomAccessFile = fs.createRandomAccessFileSync(file);
              let length: number = 4096;
              let arrayBuffer = new ArrayBuffer(length);
              let readLength = randomAccessFile.readSync(arrayBuffer);
              randomAccessFile.close();
              fs.closeSync(file);
              this.readMessage = "Read (Sync) 读取成功，长度： " + readLength.toString();
            })
        }
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height('40%')
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}