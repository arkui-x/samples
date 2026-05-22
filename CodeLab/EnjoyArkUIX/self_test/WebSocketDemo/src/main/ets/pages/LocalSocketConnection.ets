import socket from '@ohos.net.socket';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';
@Entry
@Component
struct testLocalSocketConnection {
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

  // 正常场景
  getLocalAddress(): void {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10); // 8位随机字符串
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    console.error(sandboxPath);
    let localAddr : socket.LocalAddress = {
      address: sandboxPath
    }
    server.listen(localAddr).then(() => {
      console.info('listen success');
      let client: socket.LocalSocket = socket.constructLocalSocketInstance();
      let connectOpt: socket.LocalConnectOptions = {
        address: localAddr,
        timeout: 6000
      }
      client.connect(connectOpt).then(() => {
        server.getLocalAddress().then((localPath: string) => {
          this.addLog("success, localPath is" + JSON.stringify(localPath));
          console.info("success, localPath is" + JSON.stringify(localPath));
        }).catch((err: BusinessError) => {
          console.error("FAIL " + JSON.stringify(err));
        })
      }).catch((err: Object) => {
        console.error('connect fail: ' + JSON.stringify(err));
      });
    });
  }

  // 无效文件描述符场景
  getLocalAddressInvalidFD(): void {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    server.getLocalAddress().then((localPath: string) => {
      server.close();
      this.addLog('首次获取地址成功，准备触发无效文件描述符');
    }).catch((err: BusinessError) => {
      if (err.code === 2301009) {
        this.addLog('✅ 正确捕获错误：socket 预期（2301009），实际：'+ err.code);
      } else {
        this.addLog('当前错误码: ' + err.code);
      }
    });
  }

  getSocketFd(): void {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10); // 8位随机字符串
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    console.error(sandboxPath);
    let localAddr : socket.LocalAddress = {
      address: sandboxPath
    }
    server.listen(localAddr).then(() => {
      console.info('listen success');

      server.on('connect', (connection: socket.LocalSocketConnection) => {
        if (connection) {
          console.info('accept a client')

          connection.getSocketFd().then((data: number) => {
            this.addLog("getSocketFd成功，Fd：" + data);
            console.info("getSocketFd成功，Fd：" + data);
          }).catch((err: BusinessError) => {
            console.error(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
            this.addLog(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
          })
        }
      });

      let client: socket.LocalSocket = socket.constructLocalSocketInstance();
      let connectOpt: socket.LocalConnectOptions = {
        address: localAddr,
        timeout: 6000
      }
      client.connect(connectOpt).then(() => {
        this.addLog(`客户端发起连接`);
      }).catch((err: BusinessError) => {
        this.addLog(`connect fail，错误码: ${err.code}, 信息: ${err.message}`);
        console.error(`connect fail，错误码: ${err.code}, 信息: ${err.message}`);
      });
    }).catch((err: BusinessError) => {
      this.addLog(`listen fail，错误码: ${err.code}, 信息: ${err.message}`);
      console.error(`listen fail，错误码: ${err.code}, 信息: ${err.message}`);
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
      Button('LocalSocketConnection_getLocalAddress')
        .onClick(() => this.getLocalAddress())
        .width('90%')
        .height(40);
      Button('getLocalAddress-无效文件描述符')
        .onClick(() => this.getLocalAddressInvalidFD())
        .width('90%')
        .height(40);
      Button('LocalSocketConnection_getSocketFd')
        .onClick(() => this.getSocketFd())
        .width('90%')
        .height(40);
      Button('返回主界面')
        .onClick(() => {
          router.back();
        })
    }
  }
}