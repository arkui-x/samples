import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs, ConflictFiles  } from '@kit.CoreFileKit';
import { router } from '@kit.ArkUI';
import { TitleBar } from '../../MainPage';

@Entry
@Component
struct Index {
  @State message: string = 'Welcome To Arkui_x Test';
  @State message2: string = 'Welcome To Arkui_x Test';
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
        Text(this.message2)
          .fontSize(20)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('60%')
      .backgroundColor('#F5DEB3')
      .justifyContent(FlexAlign.Center)
      Grid() {
        GridItem() {
          Button("moveDir")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              // move directory from srcPath to destPath
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.moveDir(srcPath, destPath, 1).then(() => {
                console.info("moveDir directory succeed");
                this.message2 = "moveDir directory succeed";
              }).catch((err: BusinessError) => {
                console.error("moveDir directory failed with error message: " + err.message + ", error code: " + err.code);
                this.message2 = "moveDir directory failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("moveDir2")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.moveDir(srcPath, destPath, 1, (err: BusinessError<Array<ConflictFiles>>) => {
                if (err && err.code == 13900015 && err.data?.length !== undefined) {
                  for (let i = 0; i < err.data.length; i++) {
                    console.error("moveDir2 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile);
                    this.message2 = "moveDir2 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile;
                  }
                } else if (err) {
                  console.error("moveDir2 directory failed with error message: " + err.message + ", error code: " + err.code);
                  this.message2 = "moveDir2 directory failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("moveDir2 directory succeed");
                  this.message2 = "moveDir2 directory succeed: ";
                }
              });
            })
        }
        GridItem() {
          Button("moveDir3")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              // move directory from srcPath to destPath
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.moveDir(srcPath, destPath, (err: BusinessError<Array<ConflictFiles>>) => {
                if (err && err.code == 13900015 && err.data?.length !== undefined) {
                  for (let i = 0; i < err.data.length; i++) {
                    console.error("moveDir3 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile);
                    this.message2 = "moveDir3 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile;
                  }
                } else if (err) {
                  console.error("moveDir3 directory failed with error message: " + err.message + ", error code: " + err.code);
                  this.message2 = "moveDir3 directory failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("moveDir3 directory succeed");
                  this.message2 = "moveDir3 directory succeed: ";
                }
              });
            })
        }
        GridItem() {
          Button("moveDirSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              try {
                fs.moveDirSync(srcPath, destPath, 1);
                console.info("move directory succeed");
                this.message2 = "moveDirSync directory succeed: ";
              } catch (error) {
                let err: BusinessError<Array<ConflictFiles>> = error as BusinessError<Array<ConflictFiles>>;
                if (err.code == 13900015 && err.data?.length !== undefined) {
                  for (let i = 0; i < err.data.length; i++) {
                    console.error("moveDirSync directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile);
                    this.message2 = "moveDirSync directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile;
                  }
                } else {
                  console.error("moveDirSync directory failed with error message: " + err.message + ", error code: " + err.code);
                  this.message2 = "moveDirSync directory failed with error message: " + err.message + ", error code: " + err.code;
                }
              }
            })
        }
        GridItem() {
          Button("mkdir")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.mkdir(srcPath).then(() => {
                console.info("mkdir succeed");
                this.message = "mkdir srcPath succeed" + "\n";
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
              });
              fs.mkdir(destPath).then(() => {
                console.info("mkdir destPath succeed");
                this.message += "mkdir destPath succeed";
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
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
      .rowsTemplate('1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .height('33%')
      .width('98%')
    }
    .height('100%')
    .width('100%')
  }
}