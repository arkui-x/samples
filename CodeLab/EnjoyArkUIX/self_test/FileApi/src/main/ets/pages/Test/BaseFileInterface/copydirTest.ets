import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { fileIo as fs, ConflictFiles } from '@kit.CoreFileKit';
import { TitleBar } from '../../MainPage';
export const FILE_CONTENT = "hello world";

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
          Button("copyDir1")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              this.message2 = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.copyDir(srcPath, destPath, 0).then(() => {
                console.info("copyDir1 directory succeed");
                this.message2 = "copyDir1 directory succeed";
              }).catch((err: BusinessError) => {
                console.error("copyDir1 directory failed with error message: " + err.message + ", error code: " + err.code);
                this.message2 = "copyDir1 directory failed with error message: " + err.message + ", error code: " + err.code;
              });

            })
        }
        GridItem() {
          Button("copyDir2")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              this.message2 = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.copyDir(srcPath, destPath, 0, (err: BusinessError<Array<ConflictFiles>>) => {
                if (err && err.code == 13900015 && err.data?.length !== undefined) {
                  for (let i = 0; i < err.data.length; i++) {
                    console.error("copyDir2 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile);
                    this.message2 = "copyDir2 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile;
                  }
                } else if (err) {
                  console.error("copyDir2 directory failed with error message: " + err.message + ", error code: " + err.code);
                  this.message2 = "copyDir2 directory failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("copyDir2 directory succeed");
                  this.message2 = "copyDir2 directory succeed";
                }
              });

            })
        }
        GridItem() {
          Button("copyDir3")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              this.message2 = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              // copy directory from srcPath to destPath
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.copyDir(srcPath, destPath, (err: BusinessError<Array<ConflictFiles>>) => {
                let filenames = fs.listFileSync(destPath, {recursion : false});
                for (let i = 0; i < filenames.length; i++) {
                  console.info("copyDirSync fileName: %s", filenames[i]);
                  this.message += "copyDirSync fileName: %s"+ filenames[i];
                }
                if (err && err.code == 13900015 && err.data?.length !== undefined) {
                  for (let i = 0; i < err.data.length; i++) {
                    console.error("copyDir3 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile);
                    this.message2 = "copyDir3 directory failed with conflicting files: " + err.data[i].srcFile + " " + err.data[i].destFile;
                  }
                } else if (err) {
                  console.error("copyDir3 directory failed with error message: " + err.message + ", error code: " + err.code);
                  this.message2 = "copyDir3 directory failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("copyDir3 directory succeed");
                  this.message2 = "copyDir3 directory succeed";
                }
              });
            })
        }
        GridItem() {
          Button("copyDirSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              this.message2 = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              let dddpath2 = srcPath + '/srcDir111';
              fs.mkdirSync(dddpath2);
              let filenames1 = fs.listFileSync(destPath, {recursion : false});
              for (let i = 0; i < filenames1.length; i++) {
                this.message += "fileName1:"+ filenames1[i] + "\n";
              }
              try {
                fs.copyDirSync(srcPath, destPath, 1);

                let filenames = fs.listFileSync(destPath, {recursion : false});
                for (let i = 0; i < filenames.length; i++) {
                  this.message += "fileName: "+ filenames[i] + "\n";
                }
                console.info("copyDirSync directory succeed");
                this.message2 = "copyDirSync directory succeed";
                fs.rmdirSync(srcPath);
                fs.rmdirSync(destPath);
              } catch (error) {
                let err: BusinessError = error as BusinessError;
                console.error("copy directory failed with error message: " + err.message + ", error code: " + err.code);
                this.message2 = "copyDirSync directory failed with error message: " + err.message + ", error code: " + err.code;
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
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";
              fs.mkdir(srcPath).then(() => {
                console.info("mkdir succeed");
                this.message = "mkdir srcDirPathLocal succeed \n";
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "srcDirPathLocal failed with error message: " + err.message + ", error code: " + err.code;
              });
              fs.mkdir(destPath).then(() => {
                console.info("mkdir srcPath succeed");
                this.message += "mkdir dstDirPathLocal succeed";
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
                this.message += "dstDirPathLocal failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("rmdirSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "";
              this.message2 = "";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/srcDir/";
              let destPath = pathDir + "/destDir/";

              this.message = "rmdir succeed!"
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
      .rowsTemplate('1fr 1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .height('33%')
      .width('98%')
    }
    .height('100%')
    .width('100%')
  }
}