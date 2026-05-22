import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct TestLocalSocketServer {
  @State message: string = 'LocalSocketServer 接口测试';
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

        Button('LocalSocketServer_getLocalAddress')
          .onClick(() => this.getLocalAddress())
          .width('90%')
          .backgroundColor('#4CAF50')

        Button('getLocalAddress-无效的文件描述符')
          .onClick(() => this.testGetLocalAddressInvalidFD())
          .width('90%')
          .backgroundColor('#4CAF50')

        Button('LocalSocketServer_close')
          .onClick(() => this.close())
          .width('90%')
          .backgroundColor('#4CAF50')

        // Button('LocalSocketServer_getLocalAddress_系统内部错误')
        //   .onClick(() => this.getLocalAddressSysInterErr())
        //   .width('90%')
        //   .backgroundColor('#4CAF50')

        Button('LocalSocketServer_close_系统内部错误')
          .onClick(() => this.closeSysInterErr())
          .width('90%')
          .backgroundColor('#4CAF50')

        Button('LocalSocketServer_getSocketFd')
          .onClick(() => this.getSocketFd())
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

  // getLocalAddress正常场景
  private getLocalAddress() {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

    let randomSuffix = Math.random().toString(36).substring(2, 10); // 8位随机字符串
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    console.error(sandboxPath);
    let listenAddr: socket.LocalAddress = {
      address: sandboxPath
    }
    server.listen(listenAddr).then(() => {
      console.info("listen success");
      server.getLocalAddress().then((localPath: string) => {
        this.addLog("SUCCESS " + JSON.stringify(localPath));
        console.info("SUCCESS " + JSON.stringify(localPath));
      }).catch((err: BusinessError) => {
        console.error("FAIL " + JSON.stringify(err));
      })
    }).catch((err: Object) => {
      console.error("listen fail: " + JSON.stringify(err));
    })
  }

  // 错误场景2：无效的文件描述符
  private testGetLocalAddressInvalidFD(): void {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10);
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    console.error(sandboxPath);

    let listenAddr: socket.LocalAddress = {
      address: sandboxPath
    }

    server.listen(listenAddr).then(() => {
      console.info("listen success");
      server.close().then(() => {
        console.info("server closed, file descriptor becomes invalid");
        server.getLocalAddress().then((localPath: string) => {
          this.addLog("SUCCESS " + JSON.stringify(localPath));
          console.info("SUCCESS " + JSON.stringify(localPath));
        }).catch((err: BusinessError) => {
          this.addLog("FAIL ：预期错误码：2301009, 实际：" + JSON.stringify(err.code));
          console.error("FAIL ：预期错误码：2301009, 实际：" + JSON.stringify(err.code));
          console.error("错误码检查: 2301009");
          console.error("错误信息: Bad file descriptor");
        })
      }).catch((closeErr: BusinessError) => {
        console.error("close fail: " + JSON.stringify(closeErr));
      });
    }).catch((err: Object) => {
      console.error("listen fail: " + JSON.stringify(err));
    })
  }

  // 测试close
  private close() {
    this.clearTestLog();
    let localserver: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10);
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    console.error('服务器监听路径：', sandboxPath);
    let addr: socket.LocalAddress = {
      address: sandboxPath
    };

    localserver.on('connect', (connection: socket.LocalSocketConnection) => {
      console.info("客户端连接成功，clientId: " + connection.clientId);
      localserver.close().then(() => {
        this.addLog('服务端close()调用成功（clientId: ' + connection.clientId + '）');
        console.info('服务端close()调用成功');
      }).catch((err: BusinessError) => {
        this.addLog('服务端close()调用失败：' + err.code + ' - ' + err.message);
        console.error('服务端close失败:', err);
      });
      connection.close().then(() => {
        this.addLog('客户端连接close()调用成功（clientId: ' + connection.clientId + '）');
        console.info('客户端连接close()调用成功');
      }).catch((err: BusinessError) => {
        this.addLog('客户端连接close()调用失败：' + err.code + ' - ' + err.message);
        console.error('连接close失败:', err);
      });
  })
    localserver.listen(addr).then(() => {
      this.addLog('listen success');
      console.info('listen success');
      this.createLocalClient(sandboxPath);
    }).catch((err: BusinessError) => {
      this.addLog('listen fail: ' + err.code);
      console.error('listen fail: ' + err.code);
    });
  }

  private createLocalClient(serverPath: string): void {
    const client: socket.LocalSocket = socket.constructLocalSocketInstance();
    const connectOptions: socket.LocalConnectOptions = {
      address: {
        address: serverPath
      } as socket.LocalAddress
    };
    client.connect(connectOptions)
      .then((): void => {
        console.info('客户端连接服务器成功');
        this.addLog('客户端连接服务器成功');
      })
      .catch((err: BusinessError): void => {
        console.error('客户端连接失败：', err.code, err.message);
        this.addLog('客户端连接失败：' + err.code);
      });
  }

  //getLocalAddress构造2300002 系统内部错误(System internal error.)
  private getLocalAddressSysInterErr() {
    this.clearTestLog();
    try {
      this.addLog('开始触发2300002错误测试（未监听时关闭）...');

      // 创建LocalSocketServer实例
      let localServer: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
      localServer.close()
      localServer.getLocalAddress().then(() => {
        this.addLog('未监听时close()成功（预期应该失败）');
      }).catch((err: BusinessError) => {
        if (err.code === 2300002) {
          this.addLog(`成功触发2300002错误：${err.message}`);
        } else {
          this.addLog(`收到错误但非2300002：${err.code} - ${err.message}`);
        }
      });

    } catch (err) {
      this.addLog(`捕获异常：${JSON.stringify(err)}`);
    }
  }

  //gclose构造2300002 系统内部错误(System internal error.)
  private closeSysInterErr() {
    this.clearTestLog();
    try {
      this.addLog('开始触发2300002错误测试（未监听时关闭）...');

      // 创建LocalSocketServer实例
      let localServer: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();

      localServer.close().then(() => {
        this.addLog('未监听时close()成功（预期应该失败）');
      }).catch((err: BusinessError) => {
        if (err.code === 2300002) {
          this.addLog(`成功触发2300002错误：${err.message}`);
        } else {
          this.addLog(`收到错误但非2300002：${err.code} - ${err.message}`);
        }
      });

    } catch (err) {
      this.addLog(`捕获异常：${JSON.stringify(err)}`);
    }
  }

  private getSocketFd() {
    this.clearTestLog();
    let server: socket.LocalSocketServer = socket.constructLocalSocketServerInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10); // 8位随机字符串
    let sandboxPath: string = context.filesDir + '/test';
    console.error(sandboxPath);
    let listenAddr: socket.LocalAddress = {
      address: sandboxPath
    }
    server.listen(listenAddr).then(() => {
      console.info("listen success");
      server.getSocketFd().then((data: number) => {
        this.addLog("getSocketFd成功，Fd：" + data);
        console.info("getSocketFd成功，Fd：" + data);
      }).catch((err: BusinessError) => {
        console.error(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
        this.addLog(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
      })
    }).catch((err: BusinessError) => {
      this.addLog(`listen fail，错误码: ${err.code}, 信息: ${err.message}`);
      console.error(`listen fail，错误码: ${err.code}, 信息: ${err.message}`);
    })
  }

  aboutToDisappear(): void {
  }
}