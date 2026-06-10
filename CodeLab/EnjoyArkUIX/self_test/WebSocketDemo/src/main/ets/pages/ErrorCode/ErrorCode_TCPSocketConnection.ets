import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { data } from '@kit.TelephonyKit';

@Entry
@Component
struct Index {
  @State message: string = 'TCPSocketConnection测试';
  @State log: string = '';

  aboutTodisappear(): void {
  }

  private closeCallback: Callback<void> | null = null;
  private errorCallback: ((err: BusinessError) => void) | null = null;
  private testPort: number = 8080; // 更换新端口

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
        Scroll() {
          Column({ space: 15 }) {
            // Button('getRemoteAddress_Callback_Error1_2303188')
            Button('getRemoteAddress_callback对非套接字进行套接字操作1')
              .onClick(() => this.getRemoteAddress_Callback_Error1())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('getRemoteAddress_Callback_Error2_2303188')
            Button('getRemoteAddress_callback对非套接字进行套接字操作2')
              .onClick(() => this.getRemoteAddress_Callback_Error2())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('getRemoteAddress_Promise_Error1_2303188')
            Button('getRemoteAddress_promise对非套接字进行套接字操作1')
              .onClick(() => this.getRemoteAddress_Promise_Error1())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('getRemoteAddress_Promise_Error2_2303188')
            Button('getRemoteAddress_promise对非套接字进行套接字操作2')
              .onClick(() => this.getRemoteAddress_Promise_Error2())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('getLocalAddress_Promise_Error1_2303188')
            Button('getLocalAddress对非套接字进行套接字操作1')
              .onClick(() => this.getLocalAddress_Promise_Error1())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('getLocalAddress_Promise_Error2_2303188')
            Button('getLocalAddress对非套接字进行套接字操作2')
              .onClick(() => this.getLocalAddress_Promise_Error2())
              .width('90%')
              .backgroundColor('#4CAF50')
          }
          .width('100%')
        }
        .height('50%')
        .width('100%')

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

        Row() {
          Button('← 返回')
            .width('30%')
            .padding({ left: 15, right: 15 })
            .backgroundColor('#4CAF50')
            .onClick(() => {
              router.back();
            })
          Button('清理日志')
            .width('50%')
            .padding({ left: 15, right: 15 })
            .backgroundColor('#4CAF50')
            .onClick(() => this.clearTestLog())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(10)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }

  clearTestLog(): void {
    this.log = "";
  }

  private addLog(content: string) {
    this.log += `${content}\n`;
  }


  getRemoteAddress_Callback_Error1(): void {
    this.clearTestLog();
    let tcpServer:socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let tcpClient:socket.TCPSocket = socket.constructTCPSocketInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8080, family: 1 } as socket.NetAddress,
      timeout: 5000
    };

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`Server startup failed: ${err.message}`);
        return;
      }
      tcpServer?.on('connect', (client: socket.TCPSocketConnection) => {
        console.info("connection clientId: " + client.clientId);
        this.addLog("connection clientId: " + client.clientId);
        client.close((closeErr: BusinessError) => {
          if (closeErr) {
            this.addLog(`关闭连接失败: ${closeErr.code} - ${closeErr.message}`);
            return;
          }
          client.getRemoteAddress((err: BusinessError, data: socket.NetAddress) => {
            if (err) {
              this.addLog(`捕获错误：socket 预期(2303188)，实际：${err.code}`);
              console.error('getRemoteAddress fail: ' + JSON.stringify(err));
              tcpServer.off('connect');
              tcpServer.close();
              tcpClient.close();

              return;
            }
            this.addLog(`address: ${data.address}，port: ${data.port}`);
            console.info('getRemoteAddress success: ' + JSON.stringify(data));
          });
        });
      });


      setTimeout(() => {
        tcpClient.connect(clientOpts, (err: BusinessError) => {
          if (err) {
            this.addLog(`Client connection failed: ${err.message}`);
            return;
          }
          this.addLog('客户端连接服务器成功');
        });
      },1000);
    });
  }

  getRemoteAddress_Callback_Error2(): void {
    this.clearTestLog();
    let tcpServer:socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let tcpClient:socket.TCPSocket = socket.constructTCPSocketInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8081,
      family: 1
    };
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8081, family: 1 } as socket.NetAddress,
      timeout: 5000
    };

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`Server startup failed: ${err.message}`);
        return;
      }
      tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
        console.info("connection clientId: " + client.clientId);
        this.addLog("connection clientId: " + client.clientId);
        client.close((firstCloseErr: BusinessError) => {
          if (firstCloseErr) {
            this.addLog(`关闭连接失败: ${firstCloseErr.code} - ${firstCloseErr.message}`);
            return;
          }
          client.close((secondCloseErr: BusinessError) => {
            client.getRemoteAddress((err: BusinessError, data: socket.NetAddress) => {
              if (err) {
                this.addLog(`捕获错误：socket 预期(2303188)，实际：${err.code}`);
                console.error('getRemoteAddress fail: ' + JSON.stringify(err));
                tcpServer.off('connect');
                tcpServer.close();
                tcpClient.close();
                return;
              }
              this.addLog(`address: ${data.address}，port: ${data.port}`);
              console.info('getRemoteAddress success: ' + JSON.stringify(data));
            });
          });
        });
      });
      setTimeout(() => {
        tcpClient.connect(clientOpts, (err: BusinessError) => {
          if (err) {
            this.addLog(`Client connection failed: ${err.message}`);
            return;
          }
          this.addLog('客户端连接服务器成功');
        });
      },1000);
    });

  }

  getRemoteAddress_Promise_Error1(): void {
    this.clearTestLog();
    let tcpServer:socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let tcpClient:socket.TCPSocket = socket.constructTCPSocketInstance();
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8082, family: 1 } as socket.NetAddress,
      timeout: 5000
    };
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8082,
      family: 1
    };
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`Server startup failed: ${err.message}`);
        return;
      }
      tcpServer?.on('connect', (client: socket.TCPSocketConnection) => {
        console.info("connection clientId: " + client.clientId);
        this.addLog("connection clientId: " + client.clientId);

        client.close((closeErr: BusinessError) => {
          if (closeErr) {
            this.addLog(`关闭连接失败: ${closeErr.code} - ${closeErr.message}`);
            return;
          }
          client.getRemoteAddress()
            .then((data: socket.NetAddress) => {
              this.addLog(`getRemoteAddress success: ${JSON.stringify(data)}`);
            })
            .catch((err: BusinessError) => {
              this.addLog(`捕获错误：socket 预期(2303188)，实际：${err.code}`);
              tcpServer.off('connect');
              tcpServer.close();
              tcpClient.close();
            });
        });
      });
      tcpClient.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`Client connection failed: ${err.message}`);
          return;
        }
        this.addLog('客户端连接服务器成功');
      });
    });
  }

  getRemoteAddress_Promise_Error2(): void {
    this.clearTestLog();
    let tcpServer:socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let tcpClient:socket.TCPSocket = socket.constructTCPSocketInstance();
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8083, family: 1 } as socket.NetAddress,
      timeout: 5000
    };
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8083,
      family: 1
    };
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`Server startup failed: ${err.message}`);
        return;
      }
      tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
        console.info("connection clientId: " + client.clientId);
        this.addLog("connection clientId: " + client.clientId);
        client.close((closeErr: BusinessError) => {
          if (closeErr) {
            this.addLog(`关闭连接失败: ${closeErr.code} - ${closeErr.message}`);
            return;
          }
          client.close((closeErr: BusinessError) => {
            client.getRemoteAddress()
              .then((data: socket.NetAddress) => {
                this.addLog(`getRemoteAddress success: ${JSON.stringify(data)}`);
              })
              .catch((err: BusinessError) => {
                this.addLog(`捕获错误：socket 预期(2303188)，实际：${err.code}`);
                tcpServer.off('connect');
                tcpServer.close();
                tcpClient.close();
              });
          })
        });
      });
      tcpClient.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`Client connection failed: ${err.message}`);
          return;
        }
        this.addLog('客户端连接服务器成功');
      });
    });
  }

  getLocalAddress_Promise_Error1(): void {
    this.clearTestLog();
    let tcpServer:socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let tcpClient:socket.TCPSocket = socket.constructTCPSocketInstance();
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8084, family: 1 } as socket.NetAddress,
      timeout: 5000
    };
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8084,
      family: 1
    };
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`Server startup failed: ${err.message}`);
        return;
      }
      tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
        console.info("connection clientId: " + client.clientId);
        this.addLog("connection clientId: " + client.clientId);
        client.close((closeErr: BusinessError) => {
          if (closeErr) {
            this.addLog(`关闭连接失败: ${closeErr.code} - ${closeErr.message}`);
            return;
          }
          client.getLocalAddress().then((localAddress: socket.NetAddress) => {
            console.info("Family IP Port: " + JSON.stringify(localAddress));
            this.addLog("Family IP Port: " + JSON.stringify(localAddress));
          }).catch((err: BusinessError) => {
            this.addLog(`捕获错误：socket 预期(2303188)，实际：${err.code}`);
            tcpServer.off('connect');
            tcpServer.close();
            tcpClient.close();
          });
        });
      });
      tcpClient.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`Client connection failed: ${err.message}`);
          return;
        }
        this.addLog('客户端连接服务器成功');
      });
    });
  }

  getLocalAddress_Promise_Error2(): void {
    this.clearTestLog();
    let tcpServer:socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let tcpClient:socket.TCPSocket = socket.constructTCPSocketInstance();
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8085, family: 1 } as socket.NetAddress,
      timeout: 5000
    };
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8085,
      family: 1
    };
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`Server startup failed: ${err.message}`);
        return;
      }
      tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
        console.info("connection clientId: " + client.clientId);
        this.addLog("connection clientId: " + client.clientId);
        client.close((closeErr: BusinessError) => {
          if (closeErr) {
            this.addLog(`关闭连接失败: ${closeErr.code} - ${closeErr.message}`);
            return;
          }
          client.close((closeErr: BusinessError) => {
            client.getLocalAddress().then((localAddress: socket.NetAddress) => {
              console.info("Family IP Port: " + JSON.stringify(localAddress));
              this.addLog("Family IP Port: " + JSON.stringify(localAddress));
            }).catch((err: BusinessError) => {
              this.addLog(`捕获错误：socket 预期(2303188)，实际：${err.code}`);
              tcpServer.off('connect');
              tcpServer.close();
              tcpClient.close();
            });
          })
        });
      });
      tcpClient.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`Client connection failed: ${err.message}`);
          return;
        }
        this.addLog('客户端连接服务器成功');
      });
    });
  }

}