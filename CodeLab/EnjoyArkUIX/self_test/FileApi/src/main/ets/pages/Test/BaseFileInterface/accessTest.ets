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
          Button("access")
            .fontSize(16)
            .width(180)
            .height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = "onclick";
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/access.txt";fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              fs.access(filePath).then((res: boolean) => {
                if (res) {
                  console.info("file exists");
                  this.message = "access file exists";
                } else {
                  console.info("file not exists");
                  this.message = "access file exists";
                }
              }).catch((err: BusinessError) => {
                console.error("access failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "access failed with error message: " + err.message + ", error code: " + err.code;
              });


            })
        }
        GridItem() {
          Button("accessSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/access.txt";
              try {
                let res = fs.accessSync(filePath);
                if (res) {
                  console.info("file exists");
                  this.message = "accessSync file exists";
                } else {
                  console.info("file not exists");
                  this.message = "accessSync file not exists";
                }
              } catch(error) {
                let err: BusinessError = error as BusinessError;
                console.error("accessSync failed with error message: " + err.message + ", error code: " + err.code);
                this.message = "accessSync failed with error message: " + err.message + ", error code: " + err.code;
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
      .rowsTemplate('1fr 1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .height('33%')
      .width('98%')
    }
    .height('100%')
    .width('100%')
  }
}