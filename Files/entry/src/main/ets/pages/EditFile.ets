import fs from '@ohos.file.fs';
import router from '@ohos.router';

// 获取路由参数
let params = router.getParams() as Record<string, string | number>;
let fileName: string = params.fileName as string;
let fileContent: string = params.fileContent as string;
let filePathList: string = params.filePathList as string;

@Entry
@Component
struct EditFile {
  @State fileName: string = fileName; //文件名
  @State fileContent: string = fileContent; //文件内容
  @State filePathList: string = filePathList; //文件路径
  @State newFileContent: string = ''; //新值
  controller: TextAreaController = new TextAreaController();

  build() {
    Row() {
      Column() {
        Row() {
          Row() {
            Image($r('app.media.ic_back'))
              .width(24)
              .height(24)
              .align(Alignment.Start)
              .id('backWatcherFile')
              .onClick(() => {
                router.back();
              })
          }
          .width('70%')

          Row() {
            Flex({ direction: FlexDirection.RowReverse }) {
              Image($r('app.media.ic_ok'))
                .width(24)
                .height(24)
                .margin({ right: 0 })
                .id('save')
                .onClick(() => {
                  // 写入文件内容
                  let pathDir: string = AppStorage.get('pathDir') as string;
                  let filePath: string = pathDir + "/" + this.fileName;
                  let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
                  fs.writeSync(file.fd, this.newFileContent);
                  fs.closeSync(file);
                  router.back()
                }
                )
            }
          }
          .align(Alignment.End)
          .width('30%')
        }
        .height(26)
        .margin({ top: 19, left: 26, right: 26 })
        .align(Alignment.Center)

        Column() {
          Row() {
            Text(this.fileName)
              .fontSize(30)
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
              .id('fileName')
              .borderRadius(0)
              .fontWeight(500)
              .margin({ left: 8, right: 8 })
              .backgroundColor('#f1f3f5')
          }
          .width('100%')
          .align(Alignment.Start)
          .margin({ top: 8 })
        }
        .margin({ top: 11 })
        .height(81)

        Row() {
          TextArea({
            text: this.fileContent,
            placeholder: 'input your word...',
            controller: this.controller
          })
            .fontSize(16)
            .fontColor('#182431')
            .height(384)
            .id('fileContent')
            .borderRadius(0)
            .fontWeight(400)
            .align(Alignment.TopStart)
            .backgroundColor('#f1f3f5')
            .opacity(0.6)
            .margin({ left: 8, right: 8 })
            .onChange((value: string) => {
              setTimeout(() => {
                this.newFileContent = value
              }, 10)
            })
        }
        .margin({ top: 11 })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f3f5')
  }
}
