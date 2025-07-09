import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs, WriteOptions, ReadOptions } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { util, buffer } from '@kit.ArkTS';
import { router } from '@kit.ArkUI';
import { TitleBar } from './MainPage';

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
          Button("createStream")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              try {
                let filePath = pathDir + "/test1.txt";
                fs.createStream(filePath, "w+").then((stream: fs.Stream) => {
                  let writeOption: WriteOptions = {
                    offset: 5,
                    length: 12,
                    encoding: 'utf-8'
                  };

                  stream.write("hello, world", writeOption).then((number: number) => {
                    console.info("write succeed and size is:" + number);

                    stream.flush((err: BusinessError) => {
                      if (err) {
                        console.error("flush stream failed with error message: " + err.message + ", error code: " + err.code);
                      } else {
                        console.info("flush succeed");
                      }
                    });

                    let arrayBuffer = new ArrayBuffer(4096);
                    let readOption: ReadOptions = {
                      offset: 11,
                      length: 6
                    };

                    stream.read(arrayBuffer, readOption).then((readLen: number) => {
                      console.info("read data succeed");
                      let buf = buffer.from(arrayBuffer, 0, readLen);
                      this.message = buf.toString();
                      stream.close();
                    }).catch((err: BusinessError) => {
                      console.error("read data failed with error message: " + err.message + ", error code: " + err.code);
                    });
                  }).catch((err: BusinessError) => {
                    console.error("write failed with error message: " + err.message + ", error code: " + err.code);
                  });

                }).catch((err: BusinessError) => {
                  console.error("createStream failed with error message: " + err.message + ", error code: " + err.code);
                });
              } catch (err) {
                console.error('AtomicFile failed! err :' + err.message);
              }
            })
        }
        GridItem() {
          Button("createStreamSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;
              try {
                let filePath = pathDir + "/test2.txt";
                let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                fs.closeSync(file);

                let stream = fs.createStreamSync(filePath, "r+");
                console.info("createStream succeed");
                let writeOption: WriteOptions = {
                  offset: 5,
                  length: 11,
                  encoding: 'utf-8'
                };
                let num = stream.writeSync("hello, world", writeOption);
                stream.flushSync();
                let readOption: ReadOptions = {
                  offset: 5,
                  length: 5
                };
                let buf = new ArrayBuffer(4096);
                num = stream.readSync(buf, readOption);
                let decoder = util.TextDecoder.create('utf-8');
                let str = decoder.decodeToString(new Uint8Array(buf));
                this.message = str;
                stream.closeSync();
              } catch (err) {
                console.error('stream failed! , Cause: %{public}s', JSON.stringify(err) ?? '');
              }
            })
        }
        GridItem() {
          Button("fdopenStreamSync")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              try {
                let context = getContext(this) as common.UIAbilityContext;
                let pathDir = context.filesDir;
                let filePath = pathDir + "/test3.txt";
                let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                let stream = fs.fdopenStreamSync(file.fd, "r+");
                console.info("openStream succeed");
                let writeOption: WriteOptions = {
                  offset: 5,
                  length: 12,
                  encoding: 'utf-8'
                };
                console.info("CJ openStream writeSync");
                let num = stream.writeSync("hello, world", writeOption);
                let readOption: ReadOptions = {
                  offset: 5,
                  length: 12
                };
                let buf = new ArrayBuffer(4096);
                num = stream.readSync(buf, readOption);
                let decoder = util.TextDecoder.create('utf-8');
                let str = decoder.decodeToString(new Uint8Array(buf));
                this.message = str;
                stream.closeSync();
              } catch (err) {
                console.error('stream failed Cause: %{public}s', JSON.stringify(err) ?? '');
              }
            })
        }
        GridItem() {
          Button("fdopenStream")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              try {
                let context = getContext(this) as common.UIAbilityContext;
                let pathDir = context.filesDir;
                let filePath = pathDir + "/test4.txt";
                let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                fs.fdopenStream(file.fd, "r+").then((stream: fs.Stream) => {
                  console.info("openStream succeed");
                  let writeOption: WriteOptions = {
                    offset: 5,
                    length: 9,
                    encoding: 'utf-8'
                  };
                  let num = stream.writeSync("hello ABC", writeOption);
                  let readOption: ReadOptions = {
                    offset: 5,
                    length: 9,
                  };
                  let buf = new ArrayBuffer(4096);
                  num = stream.readSync(buf, readOption);
                  let decoder = util.TextDecoder.create('utf-8');
                  let str = decoder.decodeToString(new Uint8Array(buf));
                  this.message = str;
                  stream.closeSync();
                }).catch((err: BusinessError) => {
                  console.error("openStream failed with error message: " + err.message + ", error code: " + err.code);
                  fs.closeSync(file);
                });
              } catch (err) {
                console.error('stream failed Cause: %{public}s', JSON.stringify(err) ?? '');
              }
            })
        }
        GridItem() {
          Button("createRead/WriteStream")
            .type(ButtonType.Capsule)
            .fontSize(16)
            .width(180).height(40)
            .backgroundColor("#0000FF")
            .onClick(() => {
              this.message = ' ';
              let context = getContext(this) as common.UIAbilityContext;
              let pathDir = context.filesDir;

              try {
                let filePath1 = pathDir + "/test5.txt";
                let filePath2 = pathDir + "/test6.txt";
                let file = fs.openSync(filePath1, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
                fs.writeSync(file.fd, "hello world");
                fs.closeSync(file);
                const rs = fs.createReadStream(`${filePath1}`);
                const ws = fs.createWriteStream(`${filePath2}`);
                const curOff = rs.seek(5, fs.WhenceType.SEEK_SET);
                console.info(`current offset is ${curOff}`);

                rs.on('readable', () => {
                  const data = rs.read();
                  if (!data) {
                    return;
                  }
                  const curOff = ws.seek(5, fs.WhenceType.SEEK_SET);
                  ws.write(data, "utf-8", ()=>{
                    setTimeout(()=> {
                      let fileContext = fs.readTextSync(filePath2);
                      this.message = fileContext;
                      ws.close();
                    },1000)
                  })
                });
              } catch (err) {
                console.error('stream failed! , Cause: %{public}s', JSON.stringify(err) ?? '');
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
