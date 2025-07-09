import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { fileIo as fs,   } from '@kit.CoreFileKit';
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
          Button("lstatSync")
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/testDir";

              fs.mkdir(filePath).then(() => {
                console.info("mkdir succeed");
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
              });

              let fileStat = fs.lstatSync(filePath);
              console.info("lstat succeed, the size of file is" + fileStat.size);
              this.message = "lstatSync succeed, the size of file is " + fileStat.size;


            })
        }
        GridItem() {
          Button("lstat1")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "onclick";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/testDir";

              fs.mkdir(filePath).then(() => {
                console.info("mkdir succeed");
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
              });

              fs.lstat(filePath).then((stat: fs.Stat) => {
                console.info("lstat succeed, the size of file is " + stat.size);
                this.message = "lstat1 succeed, the size of file is " + stat.size;
              }).catch((err: BusinessError) => {
                console.error("lstat failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "lstat1 failed with error message: " + err.message + ", error code: " + err.code;
              });

            })
        }
        GridItem() {
          Button("lstat2")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "onclick";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/testDir";

              fs.mkdir(filePath).then(() => {
                console.info("mkdir succeed");
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
              });

              fs.lstat(filePath, (err: BusinessError, stat: fs.Stat) => {
                if (err) {
                  console.error("lstat failed with error message: " + err.message + ", error code: " + err.code);
                  this.message = ("lstat2 failed with error message: " + err.message + ", error code: " + err.code);
                } else {
                  console.info("lstat succeed, the size of file is" + stat.size);
                    this.message = "lstat2 succeed, the size of file is " + stat.size;
                }
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