import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

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
            Button('on_error_normal')
              .onClick(() => this.on_error())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('on_error_type_null')
              .onClick(() => this.on_error_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('on_error_type_undefined')
              .onClick(() => this.on_error_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_error_normal')
              .onClick(() => this.off_error())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_error_type_null')
              .onClick(() => this.off_error_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_error_type_undefined')
              .onClick(() => this.off_error_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_error_callback_undefined')
              .onClick(() => this.off_error_callback_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_error_special')
              .onClick(() => this.off_error_special())
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
        .height(250)
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
          Button('清理环境')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(async () => {
              await this.cleanupAllWebSocketResources();
            })
        }
      }
      .width('100%')
      .padding(5)
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
          this.localClient.off('error');
          this.localClient.close();
          console.info(`客户端：移除所有订阅并关闭连接`);
        } catch (err) {
          const error = err as BusinessError;
          console.info(`客户端清理失败：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.localServer) {
        try {
          this.localServer.off('error');
          this.localServer.stop().then((success: boolean) => {
            if (success) {
              console.info(`服务端：移除所有订阅并成功停止服务器`);
            } else {
              console.info(`服务端：移除所有订阅，当前无运行中的服务器`);
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

      console.info(`所有WebSocket资源清理完成，无残留干扰`);
    } catch (err) {
      const error = err as Error;
      console.info(`全局资源清理异常：${error.message || err}`);
    }
    setTimeout(()=>{
      this.addTestResult('环境清理完成');
    },2000);
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
      serverPort: 8110,
      maxConcurrentClientsNumber: 1,
      maxConnectionsForOneClient: 1,
    }

    this.localServer?.on('error', (err: BusinessError) => {
      console.error(`服务端错误事件触发! code: ${err.code}, message: ${err.message}`);
      this.addTestResult(`服务端on_error回调: code=${err.code}, Message=${err.message}`);
    });

    this.localServer?.on('connect', async (connection: webSocket.WebSocketConnection) => {
      console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      this.addTestResult(`客户端连接: ${connection.clientIP}:${connection.clientPort}`);

      if (!this.connections) {
        this.connections = [];
      }
      this.connections.push(connection);

    });

    this.localServer?.on('messageReceive', (message: webSocket.WebSocketMessage) => {
      console.info(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
      this.addTestResult(`收到消息: ${message.data}`);
    });

    this.localServer?.on('close', (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
      console.info(`client close, client: ${clientConnection}, closeReason: Code: ${closeReason.code}, reason: ${closeReason.reason}`);
    });

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
      console.error(`Failed to start. Code: ${error.code}, message: ${error.message}`);
      this.addTestResult(`启动错误: ${error.message}`);
    });
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
        console.info("on close, code is " + value.code + ", reason is " + value.reason);
      });

      try{
        this.localClient.on('error', (err: BusinessError) => {
          this.addTestResult(`订阅WebSocketServer的Error事件成功：code: ${err.code}, message: ${err.message}`);
          console.error('Client: Connection error:', err);
        });
      }catch (err) {
        this.addTestResult(`订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
      }

      try {
        const url = `ws://127.0.0.1:8110`;
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

  private connectWithInvalidURLs(): void {
    this.addTestResult(`开始创建会失败的客户端连接...`);
    let invalidURLs: string = 'ws://127.0.0.1:8110/invalid-path';

    const client: webSocket.WebSocket = webSocket.createWebSocket();

    client.on('error', (error: BusinessError) => {
      this.addTestResult(`无效URL错误: ${error.message}`);
    });

    client.connect(invalidURLs, (err: BusinessError, connected: boolean) => {
      if (err) {
        this.addTestResult(`无效URL连接失败: ${err.message}`);
      }
    });
  }

  private testClientConnectionError(): void {

    setTimeout(() => {
      const client: webSocket.WebSocket = webSocket.createWebSocket();

      client.on('open', () => {
        this.addTestResult(`客户端连接成功`);
      });

      client.on('error', (error: BusinessError) => {
        this.addTestResult(`客户端注册错误: ${error.message}`);
      });

      const url = `ws://127.0.0.1:8080`;
      client.connect(url, (err: BusinessError, connected: boolean) => {
        if (err) {
          this.addTestResult(`客户端连接失败: ${err.message}`);
        }
      });
    }, 1000);
  }

  private on_error() {
      this.connectWithInvalidURLs();
      setTimeout(() => {
        this.testClientConnectionError();
      }, 2000);
  }

  //on_error_type_null
  private on_error_null() {
    try {
      this.localServer?.on(null, (err: BusinessError) => {
        this.addTestResult(`订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
      })
      this.addTestResult(`订阅WebSocketServer的Error事件成功`);
    } catch (error) {
      const err = error as BusinessError;
      this.addTestResult(`订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  //on_error_undefined
  private on_error_undefined() {
    try {
      this.localServer?.on(undefined, (err: BusinessError) => {
        this.addTestResult(`订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
      })
      this.addTestResult(`订阅WebSocketServer的Error事件成功`);
    } catch (error) {
      const err = error as BusinessError;
      this.addTestResult(`订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  private connectWithInvalidURLs_1(): void {
    this.addTestResult(`开始创建会失败的客户端连接...`);
    let invalidURLs: string = 'ws://127.0.0.1:8110/invalid-path';

    const client: webSocket.WebSocket = webSocket.createWebSocket();

    client.on('error', (error: BusinessError) => {
      this.addTestResult(`无效URL错误: ${error.message}`);
    });

    client.connect(invalidURLs, (err: BusinessError, connected: boolean) => {
      if (err) {
        this.addTestResult(`无效URL连接失败: ${err.message}`);
      }
    });
  }

  private testClientConnectionError_1(): void {
      const client: webSocket.WebSocket = webSocket.createWebSocket();

      client.on('open', () => {
        this.addTestResult(`客户端连接成功`);
      });

      client.on('error', (error: BusinessError) => {
        this.addTestResult(`客户端注册错误: ${error.message}`);
      });

      const url = `ws://127.0.0.1:8110`;
      client.connect(url, (err: BusinessError, connected: boolean) => {
        if (err) {
          this.addTestResult(`客户端连接失败: ${err.message}`);
        }
      });
  }

  private off_error() {
    if(!this.checkServerStart()){
      return;
    }
    let callback_1 = (err: BusinessError) => {
      if(err){
        this.addTestResult(`订阅WebSocketServer的Error_1事件失败, code: ${err.code}, message: ${err.message}`);
      }else{
        this.addTestResult(`订阅WebSocketServer的Error_1事件成功`);
      }
    }
    try{
      this.localServer?.on('error',callback_1);
      this.localServer?.off('error',callback_1);
      this.addTestResult(`取消订阅WebSocketServer的Error事件成功`);
    }catch (err) {
      this.addTestResult(`取消订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  //off_error_null
  private off_error_null() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off(null);
      this.addTestResult(`取消订阅WebSocketServer的Error事件成功`);
    }catch (err) {
      this.addTestResult(`取消订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  //off_error_undefined
  private off_error_undefined() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off(undefined);
      this.addTestResult(`取消订阅WebSocketServer的Error事件成功`);
    }catch (err) {
      this.addTestResult(`取消订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  //off_error_callback_undefined
  private off_error_callback_undefined() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off('error',undefined);
      this.addTestResult(`取消订阅WebSocketServer的Error事件成功`);
    }catch (err) {
      this.addTestResult(`取消订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  //special
  private off_error_special() {
    if(!this.checkServerStart()){
      return;
    }
    let callback_1 = (err: BusinessError) => {
      if(err){
        this.addTestResult(`订阅WebSocketServer的Error_1事件失败, code: ${err.code}, message: ${err.message}`);
      }else{
        this.addTestResult(`订阅WebSocketServer的Error_1事件成功`);
      }
    }
    let callback_2 = (err: BusinessError) => {
      if(err){
        this.addTestResult(`订阅WebSocketServer的Error_2事件失败, code: ${err.code}, message: ${err.message}`);
      }else{
        this.addTestResult(`订阅WebSocketServer的Error_2事件成功`);
      }
    }
    try{
      this.localServer?.on('error',callback_1);
      this.localServer?.on('error',callback_2);
      this.localServer?.off('error');
      this.addTestResult(`取消所有订阅WebSocketServer的Error事件成功`);
    }catch (err) {
      this.addTestResult(`取消订阅WebSocketServer的Error事件失败, code: ${err.code}, message: ${err.message}`);
    }
  }

  private sendData() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let wrongConnection: webSocket.WebSocketConnection = {
        clientIP: '1.1.1.1',
        clientPort: 8888
      }
      this.localServer?.send("Hello, I'm server!", wrongConnection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
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