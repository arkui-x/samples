import socket from '@ohos.net.socket';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import router from '@ohos.router';

@Entry
@Component
struct testudp {
  @State testResults: string[] = [];
  @State log: string = '';
  aboutToAppear(): void {
  }
  private addLog(content: string) {
    this.log += `${content}\n`;
    this.log = this.log;
  }

  clearTestLog(): void {
    this.log = "";
  }

  // getSocketFd_callback中bind成功
  getSocketFdTcpSocketCallbackBind(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
    }
    tcp.bind(bindAddr)
    tcp.getSocketFd((err: BusinessError, data: number) => {
      console.error("getSocketFd failed: " + err);
      console.info("bind成功，tunenlfd: " + data);
      this.addLog("bind成功，tunenlfd: " + data);
    })
  }

  // getSocketFd_callback中connect成功
  getSocketFdTcpSocketCallbackConnect(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions)
    tcp.getSocketFd((err: BusinessError, data: number) => {
      console.error("getSocketFd failed: " + err);
      console.info("connect成功，tunenlfd: " + data);
      this.addLog("connect成功，tunenlfd: " + data);
    })
  }

  // 错误场景1：bind失败导致getSocketFd返回undefined
  getSocketFdBindError(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: 'invalid.address.xxx',
      port: 8088
    }

    tcp.bind(bindAddr, (bindErr: BusinessError) => {
      if (bindErr) {
        tcp.getSocketFd((err: BusinessError, data: number) => {
          if (err) {
            this.addLog('bind失败，getSocketFd返回错误,错误码：' + err.code);
          } else if (data === undefined) {
            this.addLog('bind失败，getSocketFd返回: ' + data);
          } else {
            this.addLog('bind失败，getSocketFd返回: ' + data);
          }
        });
      }
    });
  }

  // 错误场景2：connect失败导致getSocketFd返回undefined
  getSocketFdConnectError(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 9999
    };

    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 1000
    };

    tcp.connect(tcpconnectoptions, (connectErr: BusinessError) => {
      if (connectErr) {
        tcp.close((closeErr: BusinessError) => {
          if (!closeErr) {
            tcp.getSocketFd((err: BusinessError, data: number) => {
              if (data === undefined) {
                this.addLog('connect失败，getSocketFd返回: ' + data);
              } else {
                this.addLog('getSocketFd返回: ' + data);
              }
            });
          }
        });
      }
    });
  }

  // getSocketFd_callback未传入callback
  getSocketFdMissCallback(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
    }
    tcp.bind(bindAddr)
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions);
    try {
      tcp.getSocketFd()
        this.addLog(`getSocketFd success`);
        console.error('getSocketFd success');
    } catch (error) {
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // getSocketFd_callback类型错误
  getSocketFdCallbackUndefined(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
    }
    tcp.bind(bindAddr)
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions);
    try {
      tcp.getSocketFd(undefined);
    } catch (error) {
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // getSocketFd_callback类型错误null
  getSocketFdNullCallback(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
    }
    tcp.bind(bindAddr)
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions);
    try {
      tcp.getSocketFd(null);
    } catch (error) {
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // getSocketFd_Promise正常场景bind成功
  getSocketFdTcpSocketBind(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
    }
    tcp.bind(bindAddr)
    tcp.getSocketFd().then((data: number) => {
      this.addLog("bind成功，tunenlfd: " + data);
      console.info("bind成功，tunenlfd: " + data);
    }).catch((error: BusinessError) => {
      this.addLog(`getSocketFd失败: ${error.message}`);
      console.error('getSocketFd fail: ' + JSON.stringify(error));
    });
  }

  // getSocketFd_Promise正常场景connect成功
  getSocketFdTcpSocketConnect(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions)
    tcp.getSocketFd().then((data: number) => {
      this.addLog("connect成功，tunenlfd: " + data);
      console.info("connect成功，tunenlfd: " + data);
    }).catch((error: BusinessError) => {
      this.addLog(`getSocketFd失败: ${error.message}`);
      console.error('getSocketFd fail: ' + JSON.stringify(error));
    });
  }

  // 错误场景1：bind失败导致getSocketFd返回undefined
  getSocketFdPromiseBindError(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: 'invalid.address.xxx',
      port: 8088
    }

    tcp.bind(bindAddr, (bindErr: BusinessError) => {
      if (bindErr) {
        tcp.getSocketFd().then((data: number) => {
          if (data === undefined) {
            this.addLog('bind失败，getSocketFd返回: ' + data);
          } else {
            this.addLog('bind失败，getSocketFd返回: ' + data);
          }
        }).catch((error: BusinessError) => {
          this.addLog(`bind失败，getSocketFd返回错误,错误码：${error.code}，错误信息：${error.message}`);
          console.error('getSocketFd fail:' + JSON.stringify(error));
        });
      }
    });
  }

  // 错误场景2：connect失败导致getSocketFd返回undefined
  getSocketFdPromiseConnectError(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let netAddress: socket.NetAddress = {
      address: '0.0.0.0',
      port: 9999
    };

    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 1000
    };

    tcp.connect(tcpconnectoptions, (connectErr: BusinessError) => {
      if (connectErr) {
        tcp.close((closeErr: BusinessError) => {
          if (!closeErr) {
            tcp.getSocketFd().then((data: number) => {
              if (data === undefined) {
                this.addLog('connect失败，getSocketFd返回: ' + data);
              } else {
                this.addLog('connect失败，getSocketFd返回: ' + data);
              }
            }).catch((error: BusinessError) => {
              this.addLog(`connect失败，getSocketFd返回错误,错误码：${error.code}，错误信息：${error.message}`);
              console.error('getSocketFd fail:' + JSON.stringify(error));
            });
          }
        });
      }
    });
  }

  // getLocalAddress正常场景
  getLocalAddressTcpSocket(){
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcp.bind(bindAddr).then(() => {
      tcp.getLocalAddress().then((localAddress: socket.NetAddress) => {
        console.info("SUCCESS! Address:" + JSON.stringify(localAddress));
        this.addLog('getLocalAddress成功'+ JSON.stringify(localAddress))
      }).catch((err: BusinessError) => {
        console.error("FAILED! Error:" + JSON.stringify(err));
        this.addLog('getLocalAddress失败'+ JSON.stringify(err))
      })
    }).catch((err: BusinessError) => {
      console.error('bind fail');
      this.addLog('bind失败')
    }).finally(() => {
      tcp.close();
    });
  }

  // getLocalAddress错误场景 - 无效的文件描述符
  getLocalAddressBadFileDescriptor(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      family: 1,
      port: 8080
    }

    tcp.bind(bindAddr).then(() => {
      tcp.close().then(() => {
        tcp.getLocalAddress().then((localAddress: socket.NetAddress) => {
        }).catch((err: BusinessError) => {
          if (err.code === 2301009) {
            this.addLog(`预期错误码: 2301009, 实际: ${err.code}`);
            console.error(`预期错误码: 2301009, 实际: ${err.code}`);
          } else {
            this.addLog(`当前错误码: ${err.code}`);
          }
        });
      });
    }).catch((err: BusinessError) => {
      this.addLog(`bind失败: ${err.code}`);
    }).finally(() => {
      tcp.close();
    });
  }

  build() {
    Column({ space: 10 }) {
      Text('TCPSocket测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });

      Text('测试日志:')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('90%')
        .textAlign(TextAlign.Start);

      Scroll() {
        Text(this.log)
          .fontSize(14)
          .width('100%')
          .padding(10)
          .backgroundColor('#f5f5f5')
      }
      .height('15%')
      .width('90%')
      .border({ width: 1, color: '#ddd' })
      .borderRadius(8)

      Text('测试功能:')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin({ top: 10 });

      Scroll() {
        Column({ space: 8 }) {
          Button('getSocketFd_Callback中bind成功')
            .onClick(() => this.getSocketFdTcpSocketCallbackBind())
            .width('100%')
            .height(40);

          Button('getSocketFd_Callback中connect成功')
            .onClick(() => this.getSocketFdTcpSocketCallbackConnect())
            .width('100%')
            .height(40);

          Button('getSocketFd_Callback中bind失败')
            .onClick(() => this.getSocketFdBindError())
            .width('100%')
            .height(40);

          Button('getSocketFd_Callback中connect失败')
            .onClick(() => this.getSocketFdConnectError())
            .width('100%')
            .height(40);

          Button('getSocketFd_Callback未传入')
            .onClick(() => this.getSocketFdMissCallback())
            .width('100%')
            .height(40);

          Button('getSocketFd_Callback类型错误_undefined')
            .onClick(() => this.getSocketFdCallbackUndefined())
            .width('100%')
            .height(40);

          Button('getSocketFd_Callback类型错误_null')
            .onClick(() => this.getSocketFdNullCallback())
            .width('100%')
            .height(40);

          Button('getSocketFd_Promise中bind成功')
            .onClick(() => this.getSocketFdTcpSocketBind())
            .width('100%')
            .height(40);

          Button('getSocketFd_Promise中connect成功')
            .onClick(() => this.getSocketFdTcpSocketConnect())
            .width('100%')
            .height(40);

          Button('getSocketFd_Promise中bind失败')
            .onClick(() => this.getSocketFdPromiseBindError())
            .width('100%')
            .height(40);

          Button('getSocketFd_Promise中connect失败')
            .onClick(() => this.getSocketFdPromiseConnectError())
            .width('100%')
            .height(40);

          Button('TcpSocket_getLocalAddress_Promise')
            .onClick(() => this.getLocalAddressTcpSocket())
            .width('100%')
            .height(40);

          Button('TcpSocket_getLocalAddress_Promise无效的文件描述符')
            .onClick(() => this.getLocalAddressBadFileDescriptor())
            .width('100%')
            .height(40);

          Button('返回主界面')
            .onClick(() => {
              router.back();
            })
            .width('100%')
            .height(40)
            .backgroundColor('#ff6b81')
            .fontColor(Color.White);
        }
        .width('100%')
      }
      .height('55%')
      .width('90%')
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor(Color.White)
  }
}