import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs, } from '@kit.CoreFileKit';
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
          Button("moveFile")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let srcPath = pathDir + "/source.txt";
              let destPath = pathDir + "/dest.txt";

              fs.open(srcPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                this.message = "file: " + srcPath + " fd: " + file.fd;
                fs.closeSync(file);
              }).catch((err: BusinessError) => {
                this.message = "open file failed with error message: " + err.message + ", error code: " + err.code;
              });
              fs.open(destPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                this.message = "file: " + destPath + " fd: " + file.fd;
                fs.closeSync(file);
              }).catch((err: BusinessError) => {
                this.message = "open file failed with error message: " + err.message + ", error code: " + err.code;
              });

              fs.moveFile(srcPath, destPath, 0).then(() => {
                console.info("move file succeed");
                this.message2 = "move file succeed";
              }).catch((err: BusinessError) => {
                console.error("move file failed with error message: " + err.message + ", error code: " + err.code);
                this.message2 = "move file failed with error message: " + err.message + ", error code: " + err.code;
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