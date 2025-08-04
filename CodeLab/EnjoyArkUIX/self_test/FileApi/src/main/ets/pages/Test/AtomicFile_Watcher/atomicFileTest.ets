import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { util } from '@kit.ArkTS';
import { router } from '@kit.ArkUI';
import { TitleBar } from '../../MainPage';

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
          Button("startWrite")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              try {
                let file = new fs.AtomicFile(`${pathDir}/test1.txt`);
                let writeSream = file.startWrite();
                  writeSream.write("xxxxxxxx","utf-8",()=> {
                    setTimeout(()=> {
                      let filenames = fs.listFileSync(`${pathDir}`);
                      let fileContext = fs.readTextSync(`${pathDir}/` + filenames[0]);
                      this.message = filenames[0] + " ==> " + fileContext;
                      fs.unlinkSync(`${pathDir}/` + filenames[0]);
                    },1000)
                  })
              } catch (err) {
                console.error('AtomicFile failed! err :' + err.message);
              }
            })
        }
        GridItem() {
          Button("finishWrite")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              try {
                let file = new fs.AtomicFile(`${pathDir}/test2.txt`);
                let writeSream = file.startWrite();
                writeSream.write("hello world","utf-8",()=> {
                  file.finishWrite();
                  setTimeout(()=> {
                    let filenames = fs.listFileSync(`${pathDir}`);
                    for (let i = 0; i < filenames.length; i++) {
                      let fileContext = fs.readTextSync(`${pathDir}/` + filenames[i]);
                      this.message += '\n' + filenames[i] + " ==> " + fileContext;
                      fs.unlinkSync(`${pathDir}/` + filenames[i]);
                    }
                  },1000)
                })
              } catch (err) {
                console.error('AtomicFile failed! err:' + err.message);
              }
            })
        }
        GridItem() {
          Button("failWrite")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              let filePath = pathDir + "/test3.txt";
              let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              fs.writeSync(file.fd, "hello world");
              fs.closeSync(file);
              try {
                let file = new fs.AtomicFile(`${filePath}`);
                let writeSream = file.startWrite();
                writeSream.write("failWrite","utf-8",()=> {
                  file.failWrite();
                  setTimeout(()=> {
                    let filenames = fs.listFileSync(`${pathDir}`);
                    for (let i = 0; i < filenames.length; i++) {
                      let fileContext = fs.readTextSync(`${pathDir}/` + filenames[i]);
                      this.message += '\n' + filenames[i] + " ==> " + fileContext;
                      fs.unlinkSync(`${pathDir}/` + filenames[i]);
                    }
                  },1000)
                })
              } catch (err) {
                console.error('AtomicFile failed! err:' + err.message);
              }
            })
        }
        GridItem() {
          Button("readFully")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              try {
                let file = new fs.AtomicFile(`${pathDir}/test4.txt`);
                let writeSream = file.startWrite();
                writeSream.write("readFully hello world","utf-8",()=> {
                  file.finishWrite();
                  setTimeout(()=>{
                    let data = file.readFully();
                    let decoder = util.TextDecoder.create('utf-8');
                    let str = decoder.decodeToString(new Uint8Array(data));
                    this.message = str;
                    fs.unlinkSync(`${pathDir}/test4.txt`);
                  },1000);
                })
              } catch (err) {
                console.error('AtomicFile failed! err:' + err.message);
              }
            })
        }
        GridItem() {
          Button("openRead")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              try {
                let file = new fs.AtomicFile(`${pathDir}/test5.txt`);
                let writeSream = file.startWrite();
                writeSream.write("openRead hello world","utf-8",()=> {
                  file.finishWrite();
                  setTimeout(()=>{
                    let readStream = file.openRead();
                    readStream.on('readable', () => {
                      const data = readStream.read();
                      if (!data) {
                        hilog.error(0x0000, 'AtomicFile', 'Read data is null');
                        return;
                      }
                      this.message = data;
                    });
                    fs.unlinkSync(`${pathDir}/test5.txt`);
                  },1000);
                })
              } catch (err) {
                console.error('AtomicFile failed! err:' + err.message);
              }
            })
        }
        GridItem() {
          Button("delete")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              try {
                let file = new fs.AtomicFile(`${pathDir}/test6.txt`);
                let writeSream = file.startWrite();
                writeSream.write("xxxxxxxxxxx","utf-8",()=> {
                  file.finishWrite();
                  setTimeout(()=>{
                    file.delete();
                    let filenames = fs.listFileSync(`${pathDir}`);
                    for (let i = 0; i < filenames.length; i++) {
                      let fileContext = fs.readTextSync(`${pathDir}/` + filenames[i]);
                      this.message += '\n' + filenames[i] + " ==> " + fileContext;
                      fs.unlinkSync(`${pathDir}/` + filenames[i]);
                    }
                  },1000);
                })
              } catch (err) {
                console.error('AtomicFile failed! err:' + err.message);
              }
            })
        }
        GridItem() {
          Button("getBaseFile")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              try {
                let file = new fs.AtomicFile(`${pathDir}/test6.txt`);
                let writeSream = file.startWrite();
                writeSream.write("xxxxxxxxxxx","utf-8",()=> {
                  file.finishWrite();
                  setTimeout(()=>{
                    let filePath = file.getBaseFile()
                    this.message = `${pathDir}/test6.txt:fd:` + filePath.fd;
                  },1000);
                })
              } catch (err) {
                console.error('AtomicFile failed! err:' + err.message);
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
