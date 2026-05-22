import socket from '@ohos.net.socket';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct testudp {
  @State testResults: string[] = [];
  @State log: string = '';

  aboutToAppear(): void {
  }

  private addLog(content: string) {
    this.log += `${content}\n`;
  }

  clearTestLog(): void {
    this.log = "";
  }

  getLocalAddress_Error1(): void {
    this.clearTestLog();
    let localsocket: socket.LocalSocket = socket.constructLocalSocketInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10);
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    let address : socket.LocalAddress = {
      address: sandboxPath
    }
    localsocket.close();
    localsocket.getLocalAddress().then(() => {
      console.info("get SUCCESS! Address：" + JSON.stringify(address));
    }).catch((err: BusinessError) => {
      console.error("get FAILED! Error: " + JSON.stringify(err));
      if (err.code === 2303188) {
        this.addLog('Correctly capturing errors, error.code：'+ err.code);
      } else {
        this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
      }
    })
  }

  // 构造对象重复关闭再调用getLocalAddress，实际报错2300999
  getLocalAddress_Error2(): void {
    this.clearTestLog();
    const localsocket = socket.constructLocalSocketInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10);
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    let address: socket.LocalAddress = {
      address: sandboxPath
    };

    localsocket.bind(address)
      .then(() => {
        console.info('socket bind success');
        return localsocket.close();
      })
      .then(() => {
        console.info('socket close success');
        return new Promise<void>(resolve => setTimeout(resolve, 100));
      })
      .then(() => {
        localsocket.close();
        return localsocket.getLocalAddress();
      })
      .then(() => {
        this.addLog('Unexpected success');
      })
      .catch((err: BusinessError) => {
        console.info(`catch errors, code：${err.code}, ${err.message}`);
        if (err.code === 2303188) {
          this.addLog(`Correctly capturing errors, code：${err.code}`);
        } else if (err.code === 2301009) {
          this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
        } else {
          this.addLog(`Unexpected error code：${err.code} - ${err.message}`);
        }
      });
  }

  build() {
    Column({ space: 20 }) {
      Text('LocalSocketConnection测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });
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
      .margin({ top: 10 })

      // Button('getLocalAddress-2301009')
      Button('getLocalAddress对非套接字进行套接字操作1')
        .onClick(() => this.getLocalAddress_Error1())
        .width('90%')
        .height(40);
      // Button('getLocalAddress-2301009')
      Button('getLocalAddress对非套接字进行套接字操作2')
        .onClick(() => this.getLocalAddress_Error2())
        .width('90%')
        .height(40);
      Button('返回主界面')
        .onClick(() => {
          router.back();
        })
    }
  }
}