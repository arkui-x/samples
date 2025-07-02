import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import hash from '@ohos.file.hash';
import fs from '@ohos.file.fs';
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
  @State message: string = 'Welcome To Arkui_x';
  @State title: string = ''

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, string>
    console.info('router.getParams() title is ' + params.title)
    this.title = params.title
  }
  build() {
    Column({ space: 20 }) {
      TitleBar({ title: this.title }).size({ height: '10%' })
      Row() {
        Column({ space: 10 }) {
          Text(this.message)
            .fontSize(20)
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .height('30%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)

      Column() {
        Row() {
          Button("open")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(120)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              fs.open(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                this.message = "file: " + filePath + " fd: " + file.fd;
                fs.closeSync(file);
              }).catch((err: BusinessError) => {
                this.message = "open file failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
      }
      .width('100%')
      .height('10%')
      .justifyContent(FlexAlign.Center)

      Grid() {
        GridItem() {
          Button("hash-Promise回调")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(300)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
                hash.hash(filePath, "sha256").then((str: string) => {
                this.message = "计算hash (Promise) 成功: " + str;
              }).catch((err: BusinessError) => {
                this.message = "计算hash (Promise) 失败: " + err.message + ", 错误代码: " + err.code;
              });
            })
        }
        GridItem() {
          Button("hash-Callback回调")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(300)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              hash.hash(filePath, "sha256", (err: BusinessError, str: string) => {
                if (err) {
                  this.message = "计算hash (Callback) 失败: " + err.message + ", 错误代码: " + err.code;
                } else {
                  this.message = "计算hash (Callback) 成功: " + str;
                }
              });
            })
        }

        GridItem() {
          Button("createHash + update + digest")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(300)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              const hs = hash.createHash('sha256');
              hs.update(new Uint8Array('1234567890'?.split('').map((x: string) => x.charCodeAt(0))).buffer);
              hs.update(new Uint8Array('abcdefg'?.split('').map((x: string) => x.charCodeAt(0))).buffer);
              const hashResult = hs.digest();
              // 88A00F46836CD629D0B79DE98532AFDE3AEAD79A5C53E4848102F433046D0106
              this.message = "hashResult:  " + hashResult;
            })
        }
      }
      .columnsTemplate('1fr')
      .rowsTemplate('1fr 1fr 1fr')
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