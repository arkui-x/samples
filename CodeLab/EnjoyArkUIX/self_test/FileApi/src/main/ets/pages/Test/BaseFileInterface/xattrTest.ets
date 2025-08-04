import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs,  } from '@kit.CoreFileKit';
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
          Button("setxattr")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let attrKey = "user.comment";
              let attrValue = "Test file.";

              fs.setxattr(filePath, attrKey, attrValue).then(() => {
                console.info("Set extended attribute successfully.");
                this.message = "test.txt setxattr extended attribute successfully.";
              }).catch((err: BusinessError) => {
                console.error("Failed to set extended attribute with error message: " + err.message + ", error code: " + err.code);
                this.message = "Failed to setxattr extended attribute with error message: " + err.message + ", error code: " + err.code;
              });

            })
        }
        GridItem() {
          Button("setxattrSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test2.txt";
              let attrKey = "user.comment";
              let attrValue = "Test file.";

              try {
                fs.setxattrSync(filePath, attrKey, attrValue);
                console.info("Set extended attribute successfully.");
                  this.message = "test2.txt setxattrSync extended attribute successfully.";
              } catch (err) {
                console.error("Failed to set extended attribute with error message: " + err.message + ", error code: " + err.code);
                   this.message = "Failed to setxattrSync extended attribute with error message: " + err.message + ", error code: " + err.code;
              }
            })
        }
        GridItem() {
          Button("getxattr")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let attrKey = "user.comment";

              fs.getxattr(filePath, attrKey).then((attrValue: string) => {
                console.info("Get extended attribute succeed, the value is: " + attrValue);
                this.message = "Get test.txt extended attribute succeed, the value is: " + attrValue;
              }).catch((err: BusinessError) => {
                console.error("Failed to get extended attribute with error message: " + err.message + ", error code: " + err.code);
                this.message = "Failed to getxattr extended attribute with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("getxattrSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test2.txt";
              let attrKey = "user.comment";

              try {
                let attrValue = fs.getxattrSync(filePath, attrKey);
                console.info("Get extended attribute succeed, the value is: " + attrValue);
                this.message = "getxattrSync test2.txt extended attribute succeed, the value is: " + attrValue;
              } catch (err) {
                console.error("Failed to get extended attribute with error message: " + err.message + ", error code: " + err.code);
                this.message = "Failed to getxattrSync extended attribute with error message: " + err.message + ", error code: " + err.code;
              }
            }
            )
        }
        GridItem() {
          Button("open")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              let srcPath = pathDir + "/test.txt";
              fs.open(srcPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                this.message = "file1: " + srcPath + " fd: " + file.fd + "\n";
                fs.closeSync(file);
              }).catch((err: BusinessError) => {
                this.message = "open file failed with error message: " + err.message + ", error code: " + err.code;
              });

              let srcPath2 = pathDir + "/test2.txt";
              fs.open(srcPath2, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                this.message += "file2: " + srcPath2 + " fd: " + file.fd;
                fs.closeSync(file);
              }).catch((err: BusinessError) => {
                this.message = "open file failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("unlink")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test.txt";
              let filePath2 = pathDir + "/test2.txt";
              fs.unlink(filePath).then(() => {
                console.info("unlink file succeed");
                this.message = "unlink file succeed";
              }).catch((err: BusinessError) => {
                console.error("unlink file failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "unlink file failed with error message: " + err.message + ", error code: " + err.code;
              });
              fs.unlink(filePath2).then(() => {
                console.info("unlink file succeed");
                this.message = "unlink file succeed";
              }).catch((err: BusinessError) => {
                console.error("unlink file failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "unlink file failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
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
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .height('33%')
      .width('98%')
    }
    .height('100%')
    .width('100%')
  }
}