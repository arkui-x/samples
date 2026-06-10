import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct TestLocalSocketServer {
  @State message: string = 'LocalSocketServer测试';
  @State log: string = '';

  aboutToAppear(): void {
  }

  build() {
    Row() {
      Column({ space: 15 }) {
        Text(this.message)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .padding(10)
          .backgroundColor('#f0f0f0')
          .borderRadius(5)
          .width('100%')
          .textAlign(TextAlign.Center)

        // Button('getLocalAddress-2301009')
        Button('getLocalAddress对非套接字进行套接字操作1')
          .onClick(() => this.getLocalAddress_Error1())
          .width('90%')
          .backgroundColor('#4CAF50')

        // Button('getLocalAddress-2301009')
        Button('getLocalAddress对非套接字进行套接字操作1')
          .onClick(() => this.getLocalAddress_Error2())
          .width('90%')
          .backgroundColor('#4CAF50')

        Scroll() {
          Text(this.log)
            .fontSize(14)
            .width('100%')
            .padding(10)
        }
        .height('30%')
        .width('100%')
        .border({ width: 1, color: '#eee' })
        .borderRadius(5)

        Button('← 返回')
          .width('auto')
          .padding({ left: 15, right: 15 })
          .backgroundColor('#4CAF50')
          .onClick(() => {
            router.back();
          })

      }
      .width('100%')
      .padding(10)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }

  private addLog(content: string) {
    this.log += `${content}\n`;
    this.log = this.log;
  }

  clearTestLog(): void {
    this.log = "";
  }

  getLocalAddress_Error1(): void {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    server.close();
    server.getLocalAddress().then((localPath: string) => {
      this.addLog("SUCCESS " + JSON.stringify(localPath));
      console.info("SUCCESS " + JSON.stringify(localPath));
    }).catch((err: BusinessError) => {
      this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
    })
  }

  getLocalAddress_Error2(): void {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10);
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    let listenAddr: socket.LocalAddress = {
      address: sandboxPath
    }

    server.listen(listenAddr).then((): Promise<void> => {
      console.info("listen success");
      return server.close();
    }).then((): Promise<void> => {
      console.info("first close success");
      return server.close();
    }).then((): Promise<string> => {
      console.info("second close success");
      return server.getLocalAddress();
    }).then((localPath: string) => {
      this.addLog("SUCCESS, localPath: " + JSON.stringify(localPath));
      console.info("SUCCESS, localPath: " + JSON.stringify(localPath));
    }).catch((err: BusinessError) => {
      this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
      console.error(`fail, error：${err.code} - ${err.message}`);
    });
  }

  aboutToDisappear(): void {
  }
}