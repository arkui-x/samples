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
            Button('新建连接')
              .onClick(() => this.on_connect())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('获取连接列表')
              .onClick(() => this.getAllConnections())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('清空日志')
              .onClick(() => this.clearTestResults())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('清理环境')
              .onClick(async () => {
                await this.cleanupAllWebSocketResources();
              })
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

  aboutToAppear(): void {
    this.testResults = [];
    this.localServer = null;
    this.localClient = null;
    this.success = false;
    this.connections = [];
  }

  async aboutToDisappear() {
    await this.cleanupAllWebSocketResources();
  }

  private async cleanupAllWebSocketResources() {
    try {
      if (this.localClient) {
        try {
          this.localClient.close();
          console.info(`客户端：成功关闭连接并释放引用`);
        } catch (err) {
          const error = err as BusinessError;
          console.info(`客户端清理失败：code=${error.code}, message=${error.message}`);
        }

      }

      if (this.localServer) {
        try {
          this.localServer.off('connect');
          this.localServer.stop().then((success: boolean) => {
            if (success) {
              console.info(`服务端：移除连接事件订阅并成功停止服务器`);
            } else {
              console.info(`服务端：移除连接事件订阅，当前无运行中的服务器`);
            }
          }).catch((error: BusinessError) => {
            console.info(`服务端停止异常：code=${error.code}, message=${error.message}`);
          });
          this.success = false;
        } catch (err) {
          const error = err as BusinessError;
          console.info(`服务端清理失败：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.connections && this.connections.length > 0) {
        this.connections = [];
        console.info(`连接列表：已清空所有客户端连接引用`);
      }
      console.info(`所有on connect测试相关WebSocket资源清理完成，无残留干扰`);
    } catch (err) {
      const error = err as Error;
      console.info(`全局资源清理异常：${error.message || err}`);
    }
    setTimeout(()=>{
      this.addTestResult('环境清理完成');
    },2000)
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
      serverPort: 8108,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    }
    this.localServer.off('connect');
    this.localServer.off('messageReceive');
    this.localServer.off('close');
    this.localServer.off('error');

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
      console.info(`client close, client: ${clientConnection}, closeReason: Code: ${closeReason.code}, reason: ${closeReason.reason}`);
    });
    this.localServer?.on('error', (err: BusinessError) => {
      console.error(`error. Code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`订阅WebSocketServer的Error事件成功,信息: Code: ${err.code}, message: ${err.message}`);
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
        console.info(`Failed to start. Code: ${error.code}, message: ${error.message}`);
        this.addTestResult(`Failed to start. Code: ${error.code}, message: ${error.message}`);
      });
    }catch(err){
      console.info(`Failed to start. Code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`Failed to start. Code: ${err.code}, message: ${err.message}`);
    };
  }

  private on_connect(): void {
    setTimeout(() => this.startClient(), 2000);
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
        console.info("on close, code is " + value.code + ", reason is " + value.reason);
      });
      
      this.localClient.on('error', (error: BusinessError) => {
        this.addTestResult(`WebSocket客户端连接出错：${error.message || JSON.stringify(error)}`);
        console.error('Client: Connection error:', error);
      });
      
      try {
        const url = `ws://127.0.0.1:8108`;
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


  private async getAllConnections(): Promise<void> {
    if(!this.checkServerStart()){
      return;
    }
    try {
      this.connections = await this.localServer?.listAllConnections();

      if (this.connections?.length === 0) {
        console.info('client list is empty');
        this.addTestResult(`客户列表为空`);
      } else {
        const connectionCount = this.connections?.length;
        const connectionInfo = this.connections?.map((conn) => {
          return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
        }).join(', ');

        console.info(`client list cnt: ${connectionCount}, client connections list is: ${connectionInfo}`);
        this.addTestResult(`客户列表信息: 连接数: ${connectionCount}, 连接列表: ${connectionInfo}`);
      }
    } catch (error) {
      const err = error as BusinessError;
      const errorCode = err.code || 'unknown';
      const errorMsg = err.message || 'unknown error';
      console.error(`Failed to listAllConnections. Code: ${errorCode}, message: ${errorMsg}`);
      this.addTestResult(`获取连接列表失败: 错误码: ${errorCode}, 错误信息: ${errorMsg}`);
    }
  }

  private closeConnect() {
    if(!this.checkServerStart()){
      return;
    }
    if(this.connections?.length){
      let connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try{
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接：`+ connectionInfo);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        });
      }catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
  }


  private sendData() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send("Hello, I'm server!", connection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`message send failed, Code: ${error.code}, message: ${error.message}`);
      });
    }
  }

  private stopServer() {
    if(!this.checkServerStart()){
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
      console.error(`message send failed, Code: ${error.code}, message: ${error.message}`);
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