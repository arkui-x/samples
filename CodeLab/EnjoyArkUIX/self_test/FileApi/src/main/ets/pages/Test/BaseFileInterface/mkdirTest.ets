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
          Button("mkdirbasePromise")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("lzy Into mkdir");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let dirPath = pathDir + "/mkdirbasePromise";
              fs.mkdir(dirPath).then(() => {
                console.info("mkdirbasePromise succeed");
                this.message = "mkdirbasePromise succeed";
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "mkdirbasePromise failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("mkdirAsyncPromise")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("lzy Into mkdir");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let dirPath = pathDir + "/mkdirAsyncPromise";
              fs.mkdir(dirPath, false).then(() => {
                console.info("mkdirAsyncPromise succeed");
                this.message = "mkdirAsyncPromise succeed";
              }).catch((err: BusinessError) => {
                console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "mkdir failed with error message: " + err.message + ", error code: " + err.code;
              });
            })
        }
        GridItem() {
          Button("mkdirAsyncCallback")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("lzy Into mkdir");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let dirPath = pathDir + "/mkdirAsyncCallback";
              fs.mkdir(dirPath, (err: BusinessError) => {
                if (err) {
                  console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
                  this.message = "mkdir failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("mkdirAsyncCallback succeed");
                  this.message = "mkdirAsyncCallback succeed";
                }
              });
            })
        }
        GridItem() {
          Button("mkdirMultiCallback")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              console.info("Into mkdir");
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let dirPath = pathDir + "/testDir5/testDir6/mkdirMultiCallback";
              fs.mkdir(dirPath, true, (err: BusinessError) => {
                if (err) {
                  console.error("mkdir failed with error message: " + err.message + ", error code: " + err.code);
                  this.message = "mkdir failed with error message: " + err.message + ", error code: " + err.code;
                } else {
                  console.info("mkdirMultiCallback succeed");
                  this.message = "mkdirMultiCallback succeed";
                }
              });
            })
        }
        GridItem() {
          Button("mkdirbaseSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              try{
                console.info("Into mkdirSync");
                let context = getContext(this) as common.UIAbilityContext;
                let pathDir = context.filesDir + "/mkdirbaseSync";
                fs.mkdirSync(pathDir);
                this.message = "mkdirbaseSync success";
              }catch (e) {
                console.log('mkdir has failed for ' + e.message + ', code: ' + e.code);
                this.message = 'mkdir has failed for ' + e.message + ', code: ' + e.code;
              }
            })
        }
        GridItem() {
          Button("mkdirSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              try{
                console.info("Into mkdirSync");
                let context = getContext(this) as common.UIAbilityContext;
                let pathDir = context.filesDir + "d";
                let dirPath = pathDir + "/mkdirSync";
                fs.mkdirSync(pathDir, false);
                fs.mkdirSync(dirPath, false);
                this.message = "mkdirSync success";
              }catch (e) {
                console.log('mkdir has failed for ' + e.message + ', code: ' + e.code);
                this.message = 'mkdir has failed for ' + e.message + ', code: ' + e.code;
              }
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