import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { On } from '@ohos.UiTest';

interface DelayConfig {
  clientStart: number;       // 订阅事件后启动客户端延迟：1500ms
  closeOperation: number;    // 关闭连接后状态释放延迟：800ms
  cleanEnv: number;          // 环境清理提示延迟：1000ms
  portRelease: number;       // 端口释放等待：2000ms
  pageExit: number;          // 页面退出延迟：200ms
  serverRestart: number;     // 服务器启动后监听就绪延迟：800ms
  clientClean: number;       // 客户端强制清理延迟：1000ms
}

@Entry
@Component
struct Index {
  @State message: string = `websocketserver测试`;
  @State testResults: string[] = [];
  @State isOperating: boolean = false;
  private connections?: webSocket.WebSocketConnection[] = [];
  private localServer: webSocket.WebSocketServer | null = null;
  private localClient: webSocket.WebSocket | null = null;
  private success: boolean = false;
  private isServerListening: boolean = false;
  private nextPortIndex: number = 0;
  private portPool: number[] = (() => {
    const ports: number[] = [];
    for (let i = 9100; i <= 9119; i++) {
      ports.push(i);
    }
    return ports;
  })();

  private delayConfig: DelayConfig = {
    clientStart: 1500,
    closeOperation: 800,
    cleanEnv: 1000,
    portRelease: 2000,
    pageExit: 200,
    serverRestart: 800,
    clientClean: 1000
  };

  build(): void {
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
            Button('on_close')
              .onClick(() => this.executeWithLock(() => this.on_c(1)))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('on_close_type_null')
              .onClick(() => this.executeWithLock(() => this.on_close_type_null(1)))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('on_close_type_undefined')
              .onClick(() => this.executeWithLock(() => this.on_close_type_undefined(1)))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('on_close_callback_null')
              .onClick(() => this.executeWithLock(() => this.on_close_callback_null(1)))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('on_close_callback_undefined')
              .onClick(() => this.executeWithLock(() => this.on_close_callback_undefined(1)))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('off_close')
              .onClick(() => this.executeWithLock(() => this.off_closeReceive1()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('off_close_type_null')
              .onClick(() => this.executeWithLock(() => this.off_closeReceive2()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('off_close_type_undefined')
              .onClick(() => this.executeWithLock(() => this.off_closeReceive3()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('off_close_callback_undefined')
              .onClick(() => this.executeWithLock(() => this.off_closeReceive5()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('off_close_no_callback')
              .onClick(() => this.executeWithLock(() => this.off_close_no_callback()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('off_close_special')
              .onClick(() => this.executeWithLock(() => this.off_closeReceive6()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
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
        .height(240)
        .margin({ top: 5 })
        .padding(5)
        .border({ width: 1, color: '#dddddd' })

        Row() {
          Button('创建websocketServer实例')
            .onClick(() => this.executeWithLock(() => this.createWebSocketServerInstance()))
            .layoutWeight(1)
            .backgroundColor('#ff9800')
            .enabled(!this.isOperating)

          Button('启动服务器')
            .onClick(() => this.executeWithLock(() => this.startWebServer()))
            .layoutWeight(1)
            .backgroundColor('#ff9800')
            .enabled(!this.isOperating)
        }
        Row() {
          Button('← 返回')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(() => this.executeWithLock(async () => {
              await this.cleanupAllWebSocketResources();
              router.back();
            }))
            .enabled(!this.isOperating)
          Button('订阅连接事件')
            .layoutWeight(1)
            .onClick(() => this.executeWithLock(() => this.on_connect()))
            .width('90%')
            .backgroundColor('#4CAF50')
            .enabled(!this.isOperating)
          Button('清理日志')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(() => this.clearTestResults())
            .enabled(!this.isOperating)
          Button('清理环境')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(() => this.executeWithLock(async () => {
              await this.cleanupAllWebSocketResources();
            }))
            .enabled(!this.isOperating)
        }
      }
      .width('100%')
      .padding(5)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }
  
  async aboutToDisappear(): Promise<void> {
    this.isOperating = true;
    await this.cleanupAllWebSocketResources();
    await new Promise<void>(resolve => setTimeout(resolve, this.delayConfig.pageExit));
    this.isOperating = false;
  }
  
  private executeWithLock = async (func: () => Promise<void> | void): Promise<void> => {
    if (this.isOperating) {
      this.addTestResult(`正在执行其他操作，请等待完成后再点击`);
      return;
    }
    this.isOperating = true;
    try {
      await func();
    } catch (err) {
      const error = err as BusinessError | Error;
      this.addTestResult(`操作执行失败：${error.message || err}`);
    } finally {
      setTimeout(() => {
        this.isOperating = false;
      }, 500);
    }
  }
  
  private async safeCloseServerConnection(conn: webSocket.WebSocketConnection): Promise<boolean> {
    if (!this.localServer || !conn) {
      return false;
    }
    try {
      const success = await this.localServer.close(conn);
      if (success) {
        this.addTestResult(`成功关闭连接: ${conn.clientIP}:${conn.clientPort}`);
      } else {
        this.addTestResult(`连接${conn.clientIP}:${conn.clientPort}已关闭或不存在`);
      }
      return success;
    } catch (err) {
      const error = err as BusinessError;
      if (error.code === 2302006) {
        return true;
      } else {
        this.addTestResult(`关闭连接${conn.clientIP}:${conn.clientPort}失败：code=${error.code}, message=${error.message}`);
        return false;
      }
    }
  }

  private async cleanupAllWebSocketResources(): Promise<void> {
    try {
      if (this.localClient) {
        try {
          this.localClient.off('open');
          this.localClient.off('message');
          this.localClient.off('close');
          this.localClient.off('error');
          this.localClient.close({ code: 1000, reason: 'cleanup' });
          await new Promise<void>(resolve => setTimeout(resolve, this.delayConfig.clientClean));
        } catch (err) {
          const error = err as BusinessError;
          this.addTestResult(`客户端清理失败：code=${error.code}, message=${error.message}`);
        } finally {
          this.localClient = null;
        }
      }

      if (this.localServer) {
        try {
          // await this.localServer.stop();
          this.localServer.off('connect');
          this.localServer.off('messageReceive');
          this.localServer.off('close');
          this.localServer.off('error');
          if (this.connections && this.connections.length > 0) {
            for (const conn of this.connections) {
              await this.safeCloseServerConnection(conn);
            }
            this.connections = [];
          } else {
          }

          this.success = false;
          this.isServerListening = false;
        } catch (err) {
          const error = err as BusinessError;
          if (error.code !== 2302006) {
            this.addTestResult(`服务端清理异常（非连接不存在）：code=${error.code}, message=${error.message}`);
          }
        } finally{
          // this.localServer = null;
        }
      }

    } catch (err) {
      const error = err as Error;
    }
    setTimeout(() => {
      this.addTestResult('清理环境完成，可重新建立客户端连接');
    }, this.delayConfig.cleanEnv);
  }

  private createWebSocketServerInstance(): void {
    if (this.localServer) {
      this.addTestResult(`server实例已存在`);
      return;
    }
    try {
      this.localServer = webSocket.createWebSocketServer();
      if (!this.localServer) {
        this.addTestResult(`server实例为null!`);
      } else {
        this.addTestResult(`server实例创建成功!`);
      }
    } catch (error) {
      this.addTestResult(`server实例创建失败! 错误：${(error as Error).message || error}`);
    }
  }

  private startWebServer(): void {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    this.connections = [];
    const port = this.portPool[this.nextPortIndex];
    this.nextPortIndex = (this.nextPortIndex + 1) % this.portPool.length;

    const config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: port,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    };

    this.localServer.off('connect');
    this.localServer.off('messageReceive');
    this.localServer.off('close');
    this.localServer.off('error');

    this.localServer.on('connect', async (connection: webSocket.WebSocketConnection) => {
      console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      if (connection && connection.clientIP && connection.clientPort) {
        this.connections?.push(connection);
      }
    });

    this.localServer.on('messageReceive', (message: webSocket.WebSocketMessage) => {
      console.info(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
      this.addTestResult(`订阅WebSocketServer的接收客户端消息成功,信息: client: ${message.clientConnection}, data: ${message.data}`);
    });

    this.localServer.on('close', (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      console.info(`client close, client: ${clientConnection}, closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
      this.addTestResult(`订阅WebSocketServer的关闭事件成功, client: ${clientConnection}, closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
      if (this.connections && this.connections.length > 0) {
        this.connections = this.connections.filter(conn =>
        !(conn.clientIP === clientConnection.clientIP && conn.clientPort === clientConnection.clientPort)
        );
        this.addTestResult(`已从列表移除关闭的连接: ${clientConnection.clientIP}:${clientConnection.clientPort}`);
      }
    });

    this.localServer.on('error', (err: BusinessError) => {
      console.error(`error. code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`订阅WebSocketServer的Error事件成功,信息: code: ${err.code}, message: ${err.message}`);
    });

    try {
      this.localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');

          this.success = true;
          this.isServerListening = true;
          setTimeout(() => {
            this.addTestResult(`启动服务端service成功`);
          }, this.delayConfig.serverRestart);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(`启动服务端service失败`);
          this.success = false;
          this.isServerListening = false;
        }
      }).catch((error: BusinessError) => {
        console.info(`Failed to start. code: ${error.code}, message: ${error.message}`);
        this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
        this.success = false;
        this.isServerListening = false;
      });
    } catch (err) {
      const error = err as BusinessError;
      console.info(`Failed to start. code: ${error.code}, message: ${error.message}`);
      this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
      this.success = false;
      this.isServerListening = false;
    }
  }

  private checkServerStart(): boolean {
    if (!this.localServer) {
      this.addTestResult(`服务器实例未创建，请先创建实例!`);
      return false;
    }
    if (!this.success) {
      this.addTestResult(`服务器未启动，请先启动服务器!`);
      return false;
    }
    if (!this.isServerListening) {
      this.addTestResult(`服务器尚未监听就绪，请等待${this.delayConfig.serverRestart/1000}秒后重试`);
      return false;
    }
    return true;
  }

  private startClient(): void {
    if (this.localClient) {
      try {
        this.localClient.close({ code: 1000, reason: 'reconnect' });
        this.localClient.off('open');
        this.localClient.off('message');
        this.localClient.off('close');
        this.localClient.off('error');
        setTimeout(() => {
          this.localClient = null;
        }, 500);
      } catch (err) {
        this.addTestResult(`关闭旧客户端失败：${(err as Error).message}`);
        this.localClient = null;
      }
    }

    const createClientWithRetry = (retryCount: number = 0) => {
      try {
        this.localClient = webSocket.createWebSocket();
        if (!this.localClient) {
          throw new Error('客户端实例创建失败（null）');
        }

        this.localClient.off('open');
        this.localClient.off('message');
        this.localClient.off('close');
        this.localClient.off('error');

        class OutValue {
          status: number = 0
          message: string = ""
        }
        this.localClient.on('open', (err: BusinessError, value: Object) => {
          console.info("on open, status:" + (value as OutValue).status + ", message:" + (value as OutValue).message);
        });

        this.localClient.on('message', (err: BusinessError<void>, value: string | ArrayBuffer) => {
          this.addTestResult(`客户端收到服务端消息：${value}`);
          console.info("on message, message:" + value);
        });

        this.localClient.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
          this.addTestResult(`WebSocket客户端连接关闭，状态码：${value.code}，原因：${value.reason}`);
          console.info("on close, code is " + value.code + ", reason is " + value.reason);
        });

        this.localClient.on('error', (error: BusinessError) => {
          this.addTestResult(`WebSocket客户端连接出错：${error.message || JSON.stringify(error)}`);
          console.error('Client: Connection error:', error);
          // if (retryCount < 2) {
          //   this.addTestResult(`连接失败，${1000}ms后重试（第${retryCount+1}次）`);
          //   setTimeout(() => {
          //     createClientWithRetry(retryCount + 1);
          //   }, 1000);
          // }
        });

        try {
          const url = `ws://127.0.0.1:${this.portPool}`;
          this.localClient.connect(url);
        } catch (error) {
          const err = error as BusinessError;
          this.addTestResult(`发起连接请求失败：${err.message || JSON.stringify(err)}`);
          console.error('Client: Failed to connect:', err);
          if (retryCount < 2) {
            setTimeout(() => {
              createClientWithRetry(retryCount + 1);
            }, 1000);
          }
        }
      } catch (error) {
        this.addTestResult(`client实例创建失败! 错误：${(error as Error).message || error}`);
        if (retryCount < 2) {
          setTimeout(() => {
            createClientWithRetry(retryCount + 1);
          }, 1000);
        }
      }
    };
    createClientWithRetry();
  }

  private on_connect(): void {
    if (!this.checkServerStart()) {
      return;
    }
    setTimeout(() => this.startClient(), this.delayConfig.clientStart);
  }

  private on_close(i: number, callback?: () => void): void {
    if (!this.localClient) {
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    if (this.localServer) {
      this.localServer.stop().then((success: boolean) => {
        if (success) {
          this.addTestResult(`server stop service${i} successfully`);
        } else {
          console.error('server stop service failed');
          this.addTestResult(`server stop service${i} failed`);
        }
      }).catch((err: BusinessError) => {
        this.addTestResult(`停止服务器失败：code=${err.code}, message=${err.message}`);
      });
    }
    callback?.();
  }

  private off_closeReceive1(): void {
    if (!this.checkServerStart()) {
      return;
    }
    const callback = (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`订阅WebSocketServer的关闭事件成功`);
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},关闭结果: code=${closeReason.code}, reason=${closeReason.reason}`);
    };

    if (this.localServer) {
      this.localServer.on('close', callback);
      this.localServer.off('close', callback);
      this.addTestResult('取消订阅WebSocketServer的关闭事件成功');
    }

    if (!this.connections || this.connections.length === 0) {
      this.addTestResult('没有客户端连接，请先建立连接');
      return;
    }
    const connection = this.connections[0];
    this.addTestResult(`将关闭连接: ${connection.clientIP}:${connection.clientPort}`);

    setTimeout(() => {
      try {
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            this.addTestResult('服务器关闭连接成功');
          } else {
            this.addTestResult('服务器关闭连接失败');
          }
        }).catch((err: BusinessError) => {
          if (err.code !== 2302006) {
            this.addTestResult(`关闭连接失败：code=${err.code}, message=${err.message}`);
          } else {
            this.addTestResult(`连接已不存在，无需关闭`);
          }
        });
      } catch (error) {
        this.addTestResult(`关闭连接异常: ${(error as Error).message}`);
      }
    }, this.delayConfig.closeOperation);
  }

  private off_closeReceive2(): void {
    if (!this.checkServerStart()) {
      return;
    }
    try {
      this.localServer?.off(null);
      this.addTestResult(`取消订阅WebSocketServer的关闭事件成功`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`取消订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private off_closeReceive3(): void {
    if (!this.checkServerStart()) {
      return;
    }
    try {
      this.localServer?.off(undefined);
      this.addTestResult(`取消订阅WebSocketServer的关闭事件成功`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`取消订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private off_closeReceive5(): void {
    if (!this.checkServerStart()) {
      return;
    }
    try {
      this.localServer?.off('close', undefined);
      this.addTestResult(`取消订阅WebSocketServer的关闭事件成功`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`取消订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private off_close_no_callback(): void {
    if (!this.checkServerStart()) {
      return;
    }
    const callback = (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`订阅WebSocketServer的关闭事件成功`);
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},关闭结果: code=${closeReason.code}, reason=${closeReason.reason}`);
    };

    if (this.localServer) {
      this.localServer.on('close', callback);
      this.localServer.off('close');
      this.addTestResult('取消订阅WebSocketServer的关闭事件成功');
    }

    if (!this.connections || this.connections.length === 0) {
      this.addTestResult('没有客户端连接，请先建立连接');
      return;
    }
    const connection = this.connections[0];
    this.addTestResult(`将关闭连接: ${connection.clientIP}:${connection.clientPort}`);

    setTimeout(() => {
      try {
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            this.addTestResult('服务器关闭连接成功');
          } else {
            this.addTestResult('服务器关闭连接失败');
          }
        }).catch((err: BusinessError) => {
          if (err.code !== 2302006) {
            this.addTestResult(`关闭连接失败：code=${err.code}, message=${err.message}`);
          } else {
            this.addTestResult(`连接已不存在，无需关闭`);
          }
        });
      } catch (error) {
        this.addTestResult(`关闭连接异常: ${(error as Error).message}`);
      }
    }, this.delayConfig.closeOperation);
  }

  private off_closeReceive6(): void {
    if (!this.checkServerStart()) {
      return;
    }
    const callback_1 = (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`订阅WebSocketServer的关闭事件成功（callback_1）`);
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},关闭结果: code=${closeReason.code}, reason=${closeReason.reason}`);
    };
    const callback_2 = (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`订阅WebSocketServer的关闭事件成功（callback_2）`);
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},关闭结果: code=${closeReason.code}, reason=${closeReason.reason}`);
    };

    if (this.localServer) {
      this.localServer.on('close', callback_1);
      this.localServer.on('close', callback_2);
      this.localServer.off('close');
      this.addTestResult('取消订阅WebSocketServer的所有关闭事件成功');
    }

    if (!this.connections || this.connections.length === 0) {
      this.addTestResult('没有客户端连接，请先建立连接');
      return;
    }
    const connection = this.connections[0];
    this.addTestResult(`将关闭连接: ${connection.clientIP}:${connection.clientPort}`);

    setTimeout(() => {
      try {
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            this.addTestResult('服务器关闭连接成功');
          } else {
            this.addTestResult('服务器关闭连接失败');
          }
        }).catch((err: BusinessError) => {
          if (err.code !== 2302006) {
            this.addTestResult(`关闭连接失败：code=${err.code}, message=${err.message}`);
          } else {
            this.addTestResult(`连接已不存在，无需关闭`);
          }
        });
      } catch (error) {
        this.addTestResult(`关闭连接异常: ${(error as Error).message}`);
      }
    }, this.delayConfig.closeOperation);
  }

  private on_c(i: number, callbackName?: webSocket.ClientConnectionCloseCallback): void {
    if (!this.localServer) {
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    const callback: webSocket.ClientConnectionCloseCallback = callbackName || ((clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
    });

    try {
      this.localServer.on('close', callback);
      this.addTestResult(`订阅WebSocketServer的关闭事件成功`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }

    if (!this.connections || this.connections.length === 0) {
      this.addTestResult('没有客户端连接，请先建立连接');
      return;
    }
    const connection = this.connections[0];
    this.addTestResult(`将关闭连接: ${connection.clientIP}:${connection.clientPort}`);

    setTimeout(() => {
      try {
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            this.addTestResult('服务器关闭连接成功');
          } else {
            this.addTestResult('服务器关闭连接失败');
          }
        }).catch((err: BusinessError) => {
          if (err.code !== 2302006) {
            this.addTestResult(`关闭连接失败：code=${err.code}, message=${err.message}`);
          } else {
            this.addTestResult(`连接已不存在，无需关闭`);
          }
        });
      } catch (error) {
        this.addTestResult(`关闭连接异常: ${(error as Error).message}`);
      }
    }, this.delayConfig.closeOperation);
  }

  private on_close_type_null(i: number, callbackName?: webSocket.ClientConnectionCloseCallback): void {
    if (!this.localServer) {
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    const callback: webSocket.ClientConnectionCloseCallback = callbackName || ((clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},关闭结果: code=${closeReason.code}, reason=${closeReason.reason}`);
    });

    try {
      this.localServer.on(null, callback);
      this.addTestResult(`尝试订阅null类型的关闭事件`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private on_close_type_undefined(i: number, callbackName?: webSocket.ClientConnectionCloseCallback): void {
    if (!this.localServer) {
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    const callback: webSocket.ClientConnectionCloseCallback = callbackName || ((clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`关闭连接:${clientConnection.clientIP}:${clientConnection.clientPort},关闭结果: code=${closeReason.code}, reason=${closeReason.reason}`);
    });

    try {
      this.localServer.on(undefined, callback);
      this.addTestResult(`尝试订阅undefined类型的关闭事件`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private on_close_callback_null(i: number, callbackName?: webSocket.ClientConnectionCloseCallback): void {
    if (!this.localServer) {
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }

    try {
      this.localServer.on('close', null);
      this.addTestResult(`尝试订阅null回调的关闭事件`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private on_close_callback_undefined(i: number, callbackName?: webSocket.ClientConnectionCloseCallback): void {
    if (!this.localServer) {
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }

    try {
      this.localServer.on('close', undefined);
      this.addTestResult(`尝试订阅undefined回调的关闭事件`);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`订阅WebSocketServer的关闭事件失败, code: ${error.code}, message: ${error.message}`);
    }
  }

  private stopServer(): void {
    if (!this.checkServerStart()) {
      return;
    }
    this.localServer?.stop().then((success: boolean) => {
      if (success) {
        console.info('server stop service successfully');
        this.addTestResult(`停止服务器成功`);
        this.success = false;
        this.isServerListening = false;
      } else {
        console.error('server stop service failed');
        this.addTestResult(`停止服务器失败`);
      }
    }).catch((error: BusinessError) => {
      console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      this.addTestResult(`停止服务器异常：code=${error.code}, message=${error.message}`);
    });
  }


  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`测试结果: ${result}`);
  }

  clearTestResults(): void {
    this.testResults = [];
  }
}