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
        Text(this.readMessage)
          .fontSize(16)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('15%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      Grid() {
        GridItem() {
          Button("createRandomAccessFile_Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(320)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              fs.createRandomAccessFile(file).then((randomAccessFile: fs.RandomAccessFile) => {
                this.readMessage = "createRandomAccessFile（Promise）创建成功: " + randomAccessFile.fd;
                randomAccessFile.close();
              }).catch((err: BusinessError) => {
                this.readMessage = "createRandomAccessFile（Promise）创建失败: " + err.message + ", error code: " + err.code;
              }).finally(() => {
                fs.closeSync(file);
              });
            })
        }
        GridItem() {
          Button("createRandomAccessFile-Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(320)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              fs.createRandomAccessFile(file, (err: BusinessError, randomAccessFile: fs.RandomAccessFile) => {
                if (err) {
                  this.readMessage = "createRandomAccessFile（Callback）创建失败: " + err.message + ", error code: " + err.code;
                } else {
                  this.readMessage = "createRandomAccessFile（Callback）创建成功: " + randomAccessFile.fd;
                  randomAccessFile.close();
                }
                fs.closeSync(file);
              });
            })
        }

        GridItem() {
          Button("createRandomAccessFile-readonly Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(320)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              fs.createRandomAccessFile(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE, { start: 10, end: 100 })
                .then((randomAccessFile: fs.RandomAccessFile) => {
                  this.readMessage = "createRandomAccessFile（Promise + readonly）创建成功: " + randomAccessFile.fd;
                  randomAccessFile.close();
                })
                .catch((err: BusinessError) => {
                  this.readMessage = "createRandomAccessFile（Promise + readonly）创建失败: " + err.message + ", error code: " + err.code;
                });
            })
        }
        GridItem() {
          Button("createRandomAccessFile-readonly Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(320)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
              fs.createRandomAccessFile(file, fs.OpenMode.READ_ONLY, (err: BusinessError, randomAccessFile: fs.RandomAccessFile) => {
                if (err) {
                  this.readMessage = "createRandomAccessFile（Callback + readonly）创建失败: " + err.message + ", error code: " + err.code;
                } else {
                  this.readMessage = "createRandomAccessFile（Callback + readonly）创建成功: " + randomAccessFile.fd;
                  randomAccessFile.close();
                }
                fs.closeSync(file);
              });
            })
        }

        GridItem() {
          Button("createRandomAccessFileSync")
            .type(ButtonType.Capsule)
            .fontSize(12)
            .width(320)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

              try {
                let randomAccessFile = fs.createRandomAccessFileSync(file);
                this.readMessage = "createRandomAccessFileSync 创建成功";
                randomAccessFile.close();
              } catch (err) {
                this.readMessage = "RandomAccessFile创建失败： " + err;
              }
            })
        }
        GridItem() {
          Button("createRandomAccessFileSync + options")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(320)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";

              try {
                let randomAccessFile = fs.createRandomAccessFileSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE,
                  { start: 0, end: 100 });
                  this.readMessage = "createRandomAccessFileSync + options 创建成功";
                  randomAccessFile.close();
              } catch (err) {
                this.readMessage = "RandomAccessFile 创建失败： " + err;
              }
            })
        }
      }
      .columnsTemplate('1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(10)
      .rowsGap(10)
      .width('100%')
      .height('50%')
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}