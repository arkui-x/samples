import router from '@ohos.router'
import fs from '@ohos.file.fs';
import { bufferToString } from '../utils/Utils'

@Preview
@Component
export struct FileList {
  @State isNoFile: boolean = true;
  @State isFileContent: boolean = true;
  @State fileContent: string = ''; //文件内容
  @State fileList: Array<string> = []; //文件列表
  @State filePathList: Array<string> = []; //文件路径
  title: Resource = {} as Resource;

  @Builder
  itemEnd(index: number) {
    Row() {
      Image($r('app.media.ic_edit'))
        .width(40)
        .height(40)
        .margin({ left: 16, right: 8 })
        .id('editFile')
        .onClick(() => {
          // 读取文件内容
          let filePath: string = this.filePathList[index];
          let file: fs.File = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
          let buf: ArrayBuffer = new ArrayBuffer(4096);
          fs.readSync(file.fd, buf, {
            offset: 0
          });
          this.fileContent = bufferToString(buf).trim();
          // 传递文件名、文件内容、文件路径
          router.pushUrl({
            url: 'pages/EditFile',
            params: {
              fileName: this.fileList[index],
              fileContent: this.fileContent,
              filePathList: this.filePathList
            }
          }, router.RouterMode.Standard);
        });
    }
    .padding(1)
    .justifyContent(FlexAlign.SpaceEvenly)
  }

  // 读取本地文件
  private async getFiles() {
    return new Promise((resolve: (res: string) => void) => {
      let pathDir: string = AppStorage.get('pathDir') as string;
      fs.listFile(pathDir, { "recursion": false,
        "listNum": 0,
        "filter": {
          "suffix": [".log", ".txt", ".doc"], } }, (err, filenames) => {
        if (err) {
          console.info("list file failed with error message: " + err.message + ", error code: " + err.code);
        } else {
          console.info("listFile succeed");
          this.fileList = [...filenames]
          for (let i = 0; i < filenames.length; i++) {
            console.info("filename: %s", filenames[i]);
            this.filePathList.push(pathDir + '/' + filenames[i])
          }
          resolve('success')
        }
      });
    })
  }

  // 创建测试文件
  private createTestFile(fileName: string, content: string) {
    let pathDir: string = AppStorage.get('pathDir') as string;
    let filePath: string = pathDir + '/' + fileName;
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
    fs.write(file.fd, content).then((writeLen) => {
      console.info("write data to file succeed and size is:" + writeLen);
      fs.closeSync(file);
    }).catch(() => {
      throw new Error()
    });
  }

  private createFiles() {
    this.createTestFile("test.txt", 'text文件内容')
    this.createTestFile("test.log", 'log文件内容')
    this.createTestFile("test.doc", 'doc文件内容')

    this.isNoFile = false
    this.getFiles()
  }

  aboutToAppear() {
    this.getFiles()
      .then((res) => {
        if (res === 'success') {
          if (this.isFileContent) {
            if (this.fileList[0] === undefined) {
              this.createFiles();
              this.isFileContent = false;
            } else {
              this.isNoFile = false
            }
          }
        }
      })
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .id('back')
          .width(36)
          .height(36)
          .objectFit(ImageFit.Fill)
          .alignSelf(ItemAlign.Start)
          .responseRegion({
            x: 0,
            y: 0,
            width: 45,
            height: 45
          })
          .onClick(() => {
            router.back()
          })

        Text(this.title)
          .fontSize(24)
          .margin({ left: 10 })
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.black'))

        Blank()
      }
      .width('100%')
      .margin({ top: 10, bottom: 20 })

      if (this.isNoFile) {
        Column() {
          Image($r('app.media.no_file'))
            .id('no_file')
            .width(36)
            .height(36)
            .margin({ top: 50 })
            .objectFit(ImageFit.Fill)

          Text($r('app.string.no_file'))
            .fontSize(16)
            .margin({ top: 10 })
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.font_gray'))
        }
        .width('100%')
      } else {
        Row() {
          Text('左滑显示编辑按钮')
        }

        Row() {
          Column() {
            List({ space: 12, initialIndex: 0 }) {
              ForEach(this.fileList, (item: string, index: number) => {
                ListItem() {
                  Row() {
                    Text(item)
                      .fontSize(16)
                      .fontColor('#182431')
                      .width('70%')
                      .lineHeight(22)
                      .textAlign(TextAlign.Start)
                      .fontWeight(500)
                      .margin({ left: 12 })
                      .borderRadius(10)
                      .backgroundColor(0xFFFFFF)
                      .id('item' + index)
                  }
                  .borderRadius(20)
                  .width('94%')
                  .height(56)
                  .backgroundColor(0xFFFFFF)
                }
                .swipeAction({ end: this.itemEnd(index), edgeEffect: SwipeEdgeEffect.Spring })
              })
            }
            .id('list')
            .height('100%')
            .width('100%')
            .alignListItem(ListItemAlign.Center)
            .scrollBar(BarState.Auto)
          }
          .padding({ top: 5 })
          .backgroundColor('#f1f3f5')
          .width('100%')
          .height('100%')
          .align(Alignment.Center)
        }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .padding(20)
  }
}
