
import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { On } from '@ohos.UiTest';

@Entry
@Component
struct Index {
  @State message: string = `websocketserver测试`;
  @State testResults: string[] = [];
  private  connections?: webSocket.WebSocketConnection[] = [];
  private localServer ?: webSocket.WebSocketServer | null | undefined;
  private localClient ?: webSocket.WebSocket | null | undefined;
  private success?: boolean = false;


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
            Button('订阅连接事件')
              .onClick(() => this.on_connect())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('stop_normal')
              .onClick(() => this.stopServer())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('清空日志')
              .onClick(() => this.clearTestResults())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('← 返回')
              .width('auto')
              .padding({ left: 15, right: 15 })
              .backgroundColor('#4CAF50')
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
        .height('50%')
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
  private async cleanupAllWebSocketResources() {
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

      if (this.localServer) {
        try {
          this.localServer.off('connect');
          this.localServer.off('messageReceive');
          this.localServer.off('close');
          this.localServer.off('error');

          this.localServer.stop().then((success: boolean) => {
            if (success) {
              this.addTestResult(`服务端：兜底停止成功 + 移除所有订阅（stop事件场景），端口已释放`);
            } else {
              this.addTestResult(`服务端：移除所有订阅，当前无运行中的服务器（stop事件场景）`);
            }
          }).catch((error: BusinessError) => {
            this.addTestResult(`服务端兜底停止异常（stop事件场景）：code=${error.code}, message=${error.message}`);
          });

          this.success = false;
        } catch (err) {
          const error = err as BusinessError;
          this.addTestResult(`服务端清理失败（stop事件场景）：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.connections && this.connections.length > 0) {
        this.connections = [];
        this.addTestResult(`连接列表：已清空所有客户端连接（stop事件场景）`);
      }

      this.addTestResult(`🎉 所有WebSocket Server stop事件相关资源清理完成，无端口占用及内存残留`);
    } catch (err) {
      const error = err as Error;
      this.addTestResult(`全局资源清理异常（stop事件场景）：${error.message || err}`);
    }
  }

  private createWebSocketServerInstance() {
    if (this.localServer) {
      this.addTestResult(`server实例已存在`);
      return this.localServer;
    }
    try {
      this.localServer = webSocket.createWebSocketServer();
      if(!this.localServer){
        this.addTestResult(`server实例为null!`);
      }else{
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
    let config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: 8109,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    }

    this.localServer?.on('connect', async (connection: webSocket.WebSocketConnection) => {
      console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      this.connections?.push(connection);
    });
    this.localServer?.on('messageReceive', (message: webSocket.WebSocketMessage) => {
      console.info(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
      this.addTestResult(`订阅WebSocketServer的接收客户端消息成功,信息: client: ${message.clientConnection}, data: ${message.data}`);
    });
    this.localServer?.on('close', (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      console.info(`client close, client: ${clientConnection}, closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
      this.addTestResult(`订阅WebSocketServer的关闭事件成功, client: ${clientConnection}, closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
    });
    this.localServer?.on('error', (err: BusinessError) => {
      console.error(`error. code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`订阅WebSocketServer的Error事件成功,信息: code: ${err.code}, message: ${err.message}`);
    });
    try{
      this.localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(`启动服务端service成功`);
          this.success = true;
        } else {
          console.error('websocket server start failed');
          this.addTestResult(`启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.info(`Failed to start. code: ${error.code}, message: ${error.message}`);
        this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
      });
    }catch(err){
      console.info(`Failed to start. code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`Failed to start. code: ${err.code}, message: ${err.message}`);
    };
  }

  private checkServerStart(): boolean
  {
    if (!this.localServer) {
      this.addTestResult(`服务器实例未创建，请先创建实例!`);
      return false;
    }
    if(this.success == false){
      this.addTestResult(`服务器未启动，请先启动服务器!`);
      return false;
    }
    return true;
  }

  private startClient(): void {
    if (this.localClient) {
      this.localClient.close();
      this.localClient = null;
    }
    try {
      this.localClient = webSocket.createWebSocket();
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
      });

      try {
        const url = `ws://127.0.0.1:8109`;
        this.localClient.connect(url);
      } catch (error) {
        const err = error as BusinessError;
        this.addTestResult(`发起连接请求失败：${err.message || JSON.stringify(err)}`);
        console.error('Client: Failed to connect:', err);
      }
    } catch (error) {
      this.addTestResult(`client实例创建失败! 错误：${error.message || error}`);
    }
  }

  private on_connect(): void {
    setTimeout(() => this.startClient(), 2000);
  }

  private stopServer() {
    if(!this.checkServerStart()){
      return;
    }
    try {
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
    }catch (err) {
      this.addTestResult(`停止服务器失败：code: ${err.code}, message: ${err.message}`);
    }
  }

  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`测试结果: ${result}`);
  }

  clearTestResults(): void {
    this.testResults = [];
  }
}