import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { On } from '@ohos.UiTest';

@Entry
@Component
struct Index {
  @State message: string = `websocketserver测试`;
  @State testResults: string[] = [];
  @State isServerReady: boolean = false;
  @State isOperating: boolean = false;
  private connections?: webSocket.WebSocketConnection[] = [];
  private localServer ?: webSocket.WebSocketServer | null | undefined;
  private localClient ?: webSocket.WebSocket | null | undefined;
  private success?: boolean = false;
  private originalPort: number = 9999;
  private serverPort: number = 9999;
  private portPool: number[] = (() => {
    const ports: number[] = [];
    for (let i = 0; i < 20; i++) {
      ports.push(9999 - i);
    }
    return ports;
  })();

  aboutToAppear() {
    this.initState();
  }

  async aboutToDisappear() {
    await this.cleanupAllWebSocketResources();
    await new Promise<void>(resolve => setTimeout(resolve, 2000));
  }

  private initState() {
    this.isServerReady = false;
    this.isOperating = false;
    this.connections = [];
    this.serverPort = this.originalPort;
    //this.localServer = null;
    this.success = false;
    this.localClient = null;
    this.testResults = [];
    console.info('状态已初始化，端口和实例引用已重置');
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
        Scroll() {
          Column({ space: 8 }) {
            Button('关闭指定连接')
              .onClick(() => this.closeConnect())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('close_Connection_null')
              .onClick(() => this.close_Connection_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('close_Connection_undefined')
              .onClick(() => this.close_Connection_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_code_is_1000')
              .onClick(() => this.closeConnect_ClientConnection_options_code_is_1000())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_code_is_999')
              .onClick(() => this.closeConnect_ClientConnection_options_code_is_999())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_code_is_1015')
              .onClick(() => this.closeConnect_ClientConnection_options_code_is_1015())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_code_is_1016')
              .onClick(() => this.closeConnect_ClientConnection_options_code_is_1016())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_code_is_undefined')
              .onClick(() => this.closeConnect_ClientConnection_options_code_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_reason_is_empty')
              .onClick(() => this.closeConnect_ClientConnection_options_reason_is_empty())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_reason_is_11111')
              .onClick(() => this.closeConnect_ClientConnection_options_reason_is_11111())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_reason_is_undefined')
              .onClick(() => this.closeConnect_ClientConnection_options_reason_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_is_null')
              .onClick(() => this.closeConnect_ClientConnection_options_is_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('closeConnect_ClientConnection_options_is_undefined')
              .onClick(() => this.closeConnect_ClientConnection_options_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('close_websocket connection does not exist')
              .onClick(() => this.closeConnect_2302006())
              .width('90%')
              .backgroundColor('#4CAF50')
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor('#0A59F7')
        .scrollBarWidth(10)
        .edgeEffect(EdgeEffect.Spring)
        .height('40%')
        .flexGrow(1)

        Scroll() {
          Column() {
            ForEach(this.testResults, (result: string, index: number) => {
              Text(`${index + 1}. ${result}`)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .padding(5)
                .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
                .width('100%');
            }, (result: string) => result)
          }
          .width('100%')
        }
        .scrollBar(BarState.On)
        .scrollable(ScrollDirection.Vertical)
        .height(230)
        .margin({ top: 5 })
        .padding(5)
        .border({ width: 1, color: '#dddddd' })

        Row() {
          Button('创建websocketServer实例')
            .onClick(() => this.createWebSocketServerInstance())
            .layoutWeight(1)
            .backgroundColor('#ff9800')

          Button('启动服务器')
            .onClick(() => this.startWebServer())
            .layoutWeight(1)
            .backgroundColor('#ff9800')
        }

        Row() {
          Button('← 返回')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(() => {
              router.back();
            })
          Button('订阅连接事件')
            .layoutWeight(1)
            .onClick(() => this.on_connect())
            .width('90%')
            .backgroundColor('#4CAF50')
          Button('清理日志')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(() => this.clearTestResults())
          // Button('清理环境')
          //   .layoutWeight(1)
          //   .backgroundColor('#4CAF50')
          //   .onClick(async () => {
          //     await this.cleanupAllWebSocketResources();
          //   })
        }
        .width('100%')
        .padding(10)
      }
      .height('100%')
      .backgroundColor('#f9f9f9')
    }
  }

  private async cleanupAllWebSocketResources() {
    this.success = false;
    try {
      if (this.localClient) {
        try {
          this.localClient.off('open');
          this.localClient.off('message');
          this.localClient.off('close');
          this.localClient.off('error');
          this.localClient.close();
          this.addTestResult(`客户端：移除所有订阅并成功关闭连接（stop事件场景）`);
        } catch (err) {
          const error = err as BusinessError;
          this.addTestResult(`客户端清理失败（stop事件场景）：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.connections && this.connections.length > 0) {
        this.connections = [];
        this.addTestResult(`连接列表：已清空所有客户端连接（stop事件场景）`);
      }

      this.addTestResult(`所有WebSocket Server stop事件相关资源清理完成，无端口占用及内存残留`);
    } catch (err) {
      const error = err as Error;
      this.addTestResult(`全局资源清理异常（stop事件场景）：${error.message || err}`);
    }
    setTimeout(() => {
      this.addTestResult('环境清理完成');
    }, 4000)
  }

  private createWebSocketServerInstance() {
    if (this.localServer) {
      this.addTestResult(`server实例已存在`);
      return this.localServer;
    }
    try {
      this.localServer = webSocket.createWebSocketServer();
      if (!this.localServer) {
        this.addTestResult(`server实例为null!`);
      } else {
        this.addTestResult(`server实例创建成功!`);
      }
      return this.localServer;
    } catch (error) {
      this.addTestResult(`server实例创建失败! 错误：${error.message || error}`);
      return undefined;
    }
  }

  private startWebServer() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    this.success = false;
    this.tryStartWithPortIndex(0);
  }

  private tryStartWithPortIndex(index: number) {
    if (index >= this.portPool.length) {
      this.addTestResult(`所有端口均启动失败`);
      return;
    }
    const port = this.portPool[index];
    const config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: port,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    };

    try {
      this.localServer!.start(config).then((success: boolean) => {
        if (success) {
          this.serverPort = port;
          this.success = true;
          console.info('webSocket server start success');
          setTimeout(() => {
            this.addTestResult(`启动服务端service成功`);
          }, 3000);
        } else {
          console.error(`端口 ${port} 启动失败，尝试下一个...`);
          this.tryStartWithPortIndex(index + 1);
        }
      }).catch((error: BusinessError) => {
        console.info(`Failed to start on port ${port}. code: ${error.code}, message: ${error.message}`);
        this.tryStartWithPortIndex(index + 1);
      });
    } catch (err) {
      const error = err as BusinessError;
      console.info(`Sync error on port ${port}: ${error.message}`);
      this.tryStartWithPortIndex(index + 1);
    }
  }

  startClient(): void {
    if (this.localClient) {
      this.localClient.close();
      this.localClient = null;
    }
    this.localClient = webSocket.createWebSocket();
    const ws = this.localClient;
    ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      this.addTestResult(`WebSocket客户端连接关闭，状态码：${value.code}，原因：${value.reason}`);
      this.addTestResult(`客户端收到关闭：code=${value.code}, reason=${value.reason}`);
      this.connections = [];
    });
    try {
      const url = `ws://127.0.0.1:${this.serverPort}`;
      console.info(`连接地址：${url}`);
      ws.connect(url);
    } catch (err) {
      this.addTestResult(`发起连接请求失败：${err.message || JSON.stringify(err)}`);
      console.error('Client: Failed to connect:', err);
    }
  }

  private on_connect(): void {
    try {
      this.localServer?.on('connect', async (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.connections = [];
        this.connections?.push(connection);
      });
    } catch (err) {
      this.addTestResult(`订阅WebSocketServer的连接事件失败,code: ${err.code}, message: ${err.message}`);
    }
    setTimeout(() => this.startClient(), 3000);
  }

  private checkServerStart(): boolean {
    if (!this.localServer) {
      this.addTestResult(`服务器实例未创建，请先创建实例!`);
      return false;
    }
    if (this.success == false) {
      this.addTestResult(`服务器未启动，请先启动服务器!`);
      return false;
    }
    return true;
  }

  private closeConnect() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
            this.localClient = null;
            this.success = false;
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
    this.success = false;
  }

  private close_Connection_null() {
    if (!this.checkServerStart()) {
      return;
    }

    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(null).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      } finally {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      }
    }
  }

  private close_Connection_undefined() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(undefined).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      } finally {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      }
    }
  }

  private closeConnect_ClientConnection_options_code_is_1000() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: "CLOSE_NORMAL"
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
  }

  private closeConnect_ClientConnection_options_code_is_999() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');

      let options: webSocket.WebSocketCloseOptions = {
        code: 999,
        reason: ""
      }
      try {
        this.localServer?.close(this.connections[0], options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
  }

  private closeConnect_ClientConnection_options_code_is_1015() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: 1015,
        reason: ""
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        })
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
  }

  private closeConnect_ClientConnection_options_code_is_1016() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: 1016,
        reason: ""
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        })
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
  }

  private closeConnect_ClientConnection_options_code_is_undefined() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: undefined,
        reason: ""
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
        }).finally(() => {
          this.connections = this.connections?.filter(conn => conn !== connection);
        })
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
      } finally {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      }
    }
  }

  private closeConnect_ClientConnection_options_reason_is_empty() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: ""
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
            this.success = false;
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
      }
    }
  }

  private closeConnect_ClientConnection_options_reason_is_11111() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: "11111"
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
      }
    }
  }

  private closeConnect_ClientConnection_options_reason_is_undefined() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: undefined,
      }
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
        }).finally(() => {
          this.connections = this.connections?.filter(conn => conn !== connection);
        })
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
      } finally {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      }
    }
  }

  private closeConnect_ClientConnection_options_is_null() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(connection, null).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
          this.connections = this.connections?.filter(conn => conn !== connection);
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
        }).finally(() => {
          this.connections = this.connections?.filter(conn => conn !== connection);
        })
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
      } finally {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      }
    }
  }

  private closeConnect_ClientConnection_options_is_undefined() {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(connection, undefined).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
        }).finally(() => {
          this.connections = this.connections?.filter(conn => conn !== connection);
        })
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
      } finally {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      }
    }
  }

  //2302006
  private closeConnect_2302006() {
    if (!this.checkServerStart()) {
      return;
    }
    let server: webSocket.WebSocketServer = webSocket.createWebSocketServer()
    if (this.connections?.length) {
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      let wrongConnection: webSocket.WebSocketConnection = {
        clientIP: '1.1.1.1',
        clientPort: 8888
      }
      server.close(wrongConnection).then((success: boolean) => {
        if (success) {
          return;
        }
      }).catch((err: BusinessError) => {
        console.info(`${err.code}, ${err.message}`)
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}”`);
      }).finally(() => {
        this.connections = this.connections?.filter(conn => conn !== connection);
        this.localClient?.close();
      })
    }
  }

  private stopServer() {
    if (!this.checkServerStart()) {
      return;
    }
    this.localServer?.stop().then((success: boolean) => {
      if (success) {
        console.info('server stop service successfully');
        this.addTestResult(`停止服务器成功`);
      } else {
        console.error('server stop service failed');
        this.addTestResult(`停止服务器失败`);
      }
    }).catch((error: BusinessError) => {
      console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
    });
  }

  // 添加测试结果
  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`测试结果: ${result}`);
  }

  // 清空测试结果
  clearTestResults(): void {
    this.testResults = [];
  }
}