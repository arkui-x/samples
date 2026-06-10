import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

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
  @State message: string = `websocket测试`;
  @State testResults: string[] = [];
  @State isClientConnected: boolean = false;

  private connections: webSocket.WebSocketConnection[] = [];
  private localServer: webSocket.WebSocketServer | null = null;
  private localClient: webSocket.WebSocket | null = null;
  private serverStarted: boolean = false;
  private success?: boolean = false;
  private serverPort: number = 8099;
  private isServerListening: boolean = false;

  private delayConfig: DelayConfig = {
    clientStart: 1500,
    closeOperation: 800,
    cleanEnv: 1000,
    portRelease: 2000,
    pageExit: 200,
    serverRestart: 800,
    clientClean: 1000
  };

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
            Button('创建websocketServer实例')
              .onClick(() => this.createWebSocketServerInstance())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('启动服务器')
              .onClick(() => this.startWebServer())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('连接客户端')
              .onClick(() => this.startClient())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('断开连接')
              .onClick(() => this.disconnectClient())
              .width('90%')
              .backgroundColor('#F44336')

            Button('清空日志')
              .onClick(() => this.clearTestResults())
              .width('90%')
              .backgroundColor('#9C27B0')

            Button('← 返回')
              .width('auto')
              .padding({ left: 15, right: 15 })
              .backgroundColor('#607D8B')
              .onClick(() => {
                router.back();
              })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor('#0A59F7')
        .scrollBarWidth(10)
        .edgeEffect(EdgeEffect.Spring)
        .height('40%')

        Scroll() {
          Column() {
            ForEach(this.testResults, (result: string, index: number) => {
              Text(`${index + 1}. ${result}`)
                .fontSize(14)
                .textAlign(TextAlign.Start)
                .padding(5)
                .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
                .width('100%');
            })
          }
          .width('100%')
        }
        .scrollBar(BarState.On)
        .scrollable(ScrollDirection.Vertical)
        .height(300)
        .margin({ top: 10 })
        .padding(10)
        .border({ width: 1, color: '#dddddd' })
      }
      .width('100%')
      .padding(10)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }

  async aboutToDisappear() {
    await this.cleanupAllWebSocketResources();
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
        }
      }
      
    } catch (err) {
      const error = err as Error;
    }
    setTimeout(() => {
      this.addTestResult('清理环境完成，可重新建立客户端连接');
    }, this.delayConfig.cleanEnv);
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

  
  private addTestResult(result: string): void {
    const log = `${result}`;
    console.info(`测试结果: ${result}`);
    this.testResults = [...this.testResults, log];
  }
  
  private clearTestResults(): void {
    this.testResults = [];
  }
  
  private createWebSocketServerInstance() {
    if (this.localServer) {
      this.addTestResult('server实例已存在');
      return this.localServer;
    }
    try {
      this.localServer = webSocket.createWebSocketServer();
      if(!this.localServer){
        this.addTestResult('server实例为null!');
      }else{
        this.addTestResult('server实例创建成功!');
      }
      return this.localServer;
    } catch (error) {
      this.addTestResult(`server实例创建失败! 错误：${error.message || error}`);
      return undefined;
    }
  }
  
  private startWebServer() {
    if (!this.localServer) {
      this.addTestResult('server实例未创建，请先创建实例!');
      return;
    }

    if (this.serverStarted) {
      this.addTestResult('服务器已经在运行');
      return;
    }

    let config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: 8080,
      protocol : "lws_server",
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    };
    
    this.setupServerListeners();

    this.localServer.start(config).then((success: boolean) => {
      if (success) {
        console.info('webSocket server start success');
        this.addTestResult('启动服务端成功');
        this.serverStarted = true;
      } else {
        console.error('websocket server start failed');
        this.addTestResult('启动服务端失败');
      }
    }).catch((error: BusinessError) => {
      console.info(`Failed to start. code: ${error.code}, message: ${error.message}`);
      this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
    });
  }
  
  private setupServerListeners(): void {
    if (!this.localServer) return;

    this.localServer.on('connect', (connection: webSocket.WebSocketConnection) => {
      console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      this.addTestResult(`客户端连接: ${connection.clientIP}:${connection.clientPort}`);
      this.connections.push(connection);
    });

    this.localServer.on('messageReceive', (message: webSocket.WebSocketMessage) => {
      const data = typeof message.data === 'string' ? message.data : '[二进制数据]';
      this.addTestResult(`收到客户端消息: ${data}`);
    });

    this.localServer.on('close', (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      this.addTestResult(`连接关闭: code=${closeReason.code}, reason=${closeReason.reason}`);
    });

    this.localServer.on('error', (err: BusinessError) => {
      console.error(`error. code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`服务器错误: code=${err.code}, message=${err.message}`);
    });
  }
  
  private startClient(): void {
    const ws = webSocket.createWebSocket();
    if (!ws) {
      console.error('WebSocket 实例创建失败');
      return;
    }

    const options: webSocket.WebSocketRequestOptions = {
      header: {
        name1: "value1",
        name2: "value2",
        name3: "value3",
        "x-custom-header": "HarmonyOS-WebSocket-Test"
      },
      skipServerCertVerification: true,
      protocol: "mytest-protocol",
      pingInterval: 5,
      pongTimeout: 2,
    };

    ws.on('open', () => {
      console.info('连接成功（局域网直连）');
      this.addTestResult(`连接成功`);
      ws.send('鸿蒙测试消息');
    });
    
    ws.on('message', (err: BusinessError<void>, value: string | ArrayBuffer) => {
      if(err){
        console.error(`接受服务端信息失败. Code: ${err.code}, message: ${err.message}`);
      }
      console.info("收到服务端信息:" + value)
      this.addTestResult("收到服务端信息:" + value);
    });

    ws.on('close', () => {
      console.info('🔌 连接已关闭');
    });

    ws.on('headerReceive', (data) => {
      console.info("on headerReceive " + JSON.stringify(data))
      this.addTestResult("收到响应头部事件:" + JSON.stringify(data));
    });
    
    const url = `ws://10.232.188.102:8081`;
    ws.connect(url, options, (err) => {
      if (!err) console.info("connect success");
      else console.error(`connect fail: ${err.message}`);
    });
  }
  
  private setupClientListeners(): void {
    if (!this.localClient) return;
    
    this.localClient.on('open', (err: BusinessError, value: Object) => {
      if (err) {
        this.addTestResult(`open事件失败: ${err.message}`);
        this.isClientConnected = false;
        return;
      }

      interface OpenResult {
        status?: number;
        message?: string;
      }

      const result = value as OpenResult;
      const status = result.status || 0;
      const message = result.message || '';

      this.addTestResult(`连接真正建立！状态: ${status}, 消息: ${message}`);
      this.isClientConnected = true;
      
      setTimeout(() => this.verifyConnection(), 1000);
    });
    
    this.localClient.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
      if (err) {
        this.addTestResult(`接收消息错误: ${err.message}`);
        return;
      }

      const message = typeof value === 'string' ? value : '[二进制数据]';
      this.addTestResult(`客户端收到: ${message}`);
    });
    
    this.localClient.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      this.isClientConnected = false;

      if (err) {
        this.addTestResult(`关闭事件错误: ${err.message}`);
        return;
      }

      this.addTestResult(`连接关闭: code=${value.code}, reason=${value.reason || '(无)'}`);
    });
    
    this.localClient.on('error', (error: BusinessError) => {
      this.isClientConnected = false;
      this.addTestResult(`客户端错误: ${error.code} - ${error.message}`);
    });
  }
  
  private verifyConnection(): void {
    if (!this.localClient || !this.isClientConnected) return;

    this.addTestResult('验证连接稳定性...');

    const testMessage = "connection_test_110";
    this.localClient.send(testMessage, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`验证发送失败: ${err.message}`);
        this.isClientConnected = false;
      } else {
        this.addTestResult(`验证发送成功: ${testMessage}`);
      }
    });
  }
  
  private handleConnectionError(err: BusinessError): void {
    this.isClientConnected = false;

    switch (err.code) {
      case 2302001:
        this.addTestResult('可能原因: 协议不匹配');
        break;
      case 2302002:
        this.addTestResult('可能原因: URL格式错误');
        break;
      case 2302003:
        this.addTestResult('可能原因: 网络连接失败');
        break;
      default:
        this.addTestResult(`未知错误码: ${err.code}`);
    }
  }
  
  private sendData() {
    if (!this.serverStarted) {
      this.addTestResult('服务器未启动');
      return;
    }
    
    if (!this.isClientConnected) {
      this.addTestResult('客户端未连接，请先连接客户端');
      return;
    }
    
    if (this.connections.length === 0) {
      this.addTestResult('没有可用的客户端连接记录');
      return;
    }

    const connection = this.connections[0];
    const message = `服务器消息 ${new Date().toLocaleTimeString()}`;

    this.addTestResult(`尝试发送: "${message}"`);

    this.localServer?.send(message, connection)
      .then((success: boolean) => {
        if (success) {
          this.addTestResult('消息发送成功');
        } else {
          this.addTestResult('消息发送失败');
          this.isClientConnected = false;
        }
      })
      .catch((error: BusinessError) => {
        this.addTestResult(`发送异常: ${error.message}`);
        this.isClientConnected = false;
      });
  }
  
  private disconnectClient() {
    if (!this.localClient) {
      this.addTestResult('客户端实例不存在');
      return;
    }

    if (!this.isClientConnected) {
      this.addTestResult('客户端未连接');
      return;
    }

    this.addTestResult('正在断开连接...');

    this.localClient.close()
      .then(() => {
        this.isClientConnected = false;
        this.addTestResult('客户端已断开');
      })
      .catch((error: BusinessError) => {
        this.addTestResult(`断开连接失败: ${error.message}`);
      });
  }
}