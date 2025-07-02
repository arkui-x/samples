import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs,ReadTextOptions  } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { router } from '@kit.ArkUI';
import { TitleBar } from '../../MainPage';

@Entry
@Component
struct Index {
  @State message: string = 'Welcome To Arkui_x Test';
  @State title: string = ''

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column({ space: 20 }) {
      TitleBar({ title: this.title }).size({ height: '10%' })
      Column() {
        Text(this.message)
          .fontSize(20)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('60%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)
      Grid() {
        GridItem() {
          Button("writePromise")
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "onclick";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              let str: string = "hello, writePromise";
              fs.write(file.fd, str).then((writeLen: number) => {
                console.info("write data to file succeed and size is:" + writeLen);
                this.message = "write data to file succeed and size is:" + writeLen;
              }).catch((err: BusinessError) => {
                console.error("write data to file failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "write data to file failed with error message: " + err.message + ", error code: " + err.code;
              }).finally(() => {
                fs.closeSync(file);
              });
            })
        }
        GridItem() {
          Button("writeSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              let str: string = "hello, writeSync";
              let writeLen = fs.writeSync(file.fd, str);
              console.info("write data to file succeed and size is:" + writeLen);
              this.message = "write data to file succeed and size is:" + writeLen;
              fs.closeSync(file);
            })
        }
        GridItem() {
          Button("read")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
              let arrayBuffer = new ArrayBuffer(4096);
              fs.read(file.fd, arrayBuffer).then((readLen: number) => {
                console.info("read file data succeed");
                let buf = buffer.from(arrayBuffer, 0, readLen);
                console.info(`The content of file: ${buf.toString()}`);
                this.message = `The content of file: ${buf.toString()}`;
              }).catch((err: BusinessError) => {
                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "read file data failed with error message: " + err.message + ", error code: " + err.code;
              }).finally(() => {
                fs.closeSync(file);
              });
            })
        }
        GridItem() {
          Button("read2")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
              let arrayBuffer = new ArrayBuffer(4096);
              fs.read(file.fd, arrayBuffer, (err: BusinessError, readLen: number) => {
                if (err) {
                  console.error("read failed with error message: " + err.message + ", error code: " + err.code);
                  this.message = "read2 failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("read2 file data succeed");
                  this.message ="read2 file data succeed";
                  let buf = buffer.from(arrayBuffer, 0, readLen);
                  console.info(`The content of file: ${buf.toString()}`);
                  this.message += `The content of file: ${buf.toString()}`;
                }
                fs.closeSync(file);
              });
            })
        }
        GridItem() {
          Button("readSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
              let buf = new ArrayBuffer(4096);
              fs.readSync(file.fd, buf);
              this.message = "readSync file succeed";
              fs.closeSync(file);
            }
            )
        }
        GridItem() {
          Button("readText")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              fs.readText(filePath).then((str: string) => {
                console.info("readText succeed:" + str);
                this.message = "readText succeed:" + str;
              }).catch((err: BusinessError) => {
                console.error("readText failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "readText failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("readText2")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let readTextOption: ReadTextOptions = {
                offset: 0,
                length: 0,
                encoding: 'utf-8'
              };
              let stat = fs.statSync(filePath);
              readTextOption.length = stat.size;
              fs.readText(filePath, readTextOption, (err: BusinessError, str: string) => {
                if (err) {
                  console.error("readText failed with error message: " + err.message + ", error code: " + err.code);
                  this.message = "readText failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("readText succeed:" + str);
                  this.message = "readText2 succeed:" + str;
                }
              });
            })
        }
        GridItem() {
          Button("readTextSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let readTextOptions: ReadTextOptions = {
                offset: 0,
                length: 0,
                encoding: 'utf-8'
              };
              let stat = fs.statSync(filePath);
              readTextOptions.length = stat.size;
              let str = fs.readTextSync(filePath, readTextOptions);
              console.info("readTextSync succeed:" + str);
              this.message = "readTextSync succeed:" + str;
            }
            )
        }

        GridItem() {
          Button("返回")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              router.back();
            })
        }
      }
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .height('33%')
      .width('98%')
    }
    .height('100%')
    .width('100%')
  }
}