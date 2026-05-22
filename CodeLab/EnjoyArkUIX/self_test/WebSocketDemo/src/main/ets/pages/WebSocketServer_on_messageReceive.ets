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
  private portPool: number[] = [9091, 9092, 9093, 9094, 9095, 9096, 9097, 9098, 9099];
  private currentPort: number | null = null;

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
            Button('on_messagereceive')
              .onClick(() => this.on_messagereceive(1))
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('on_messagereceive_type_null')
              .onClick(() => this.on_messagereceive_type_null(1))
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('on_messagereceive_type_undefined')
              .onClick(() => this.on_messagereceive_type_undefined(1))
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_messageReceive_normal')
              .onClick(() => this.off_messageReceive1())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_messageReceive_type_null')
              .onClick(() => this.off_messageReceive2())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_messageReceive_type_undefined')
              .onClick(() => this.off_messageReceive3())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_messageReceive_callback_null')
              .onClick(() => this.off_messageReceive4())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_messageReceive_callback_undefined')
              .onClick(() => this.off_messageReceive5())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_messageReceive_special')
              .onClick(() => this.off_messageReceive6())
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
          // Button('清理环境')
          //   .layoutWeight(1)
          //   .backgroundColor('#4CAF50')
          //   .onClick(async () => {
          //     await this.cleanupAllWebSocketResources();
          //   })
        }

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
          this.localClient.off('message');
          this.localClient.close();
          this.addTestResult(`客户端：移除消息订阅并成功关闭连接`);
        } catch (err) {
          const error = err as BusinessError;
          this.addTestResult(`客户端清理失败：code=${error.code}, message=${error.message}`);
        }
      }
      if (this.localServer) {
        try {
          this.localServer.off('messageReceive'); // 对应本demo核心测试的消息接收事件
          this.localServer.stop().then((success: boolean) => {
            if (success) {
              this.addTestResult(`服务端：移除消息接收订阅并成功停止服务器`);
            } else {
              this.addTestResult(`服务端：移除消息接收订阅，当前无运行中的服务器`);
            }
          }).catch((error: BusinessError) => {
            this.addTestResult(`服务端停止异常：code=${error.code}, message=${error.message}`);
          });
          this.success = false;
        } catch (err) {
          const error = err as BusinessError;
          this.addTestResult(`服务端清理失败：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.connections && this.connections.length > 0) {
        this.connections = [];
        this.addTestResult(`连接列表：已清空所有客户端连接引用`);
      }
      this.addTestResult(`所有on messageReceive测试相关WebSocket资源清理完成，无残留干扰`);
    } catch (err) {
      const error = err as Error;
      this.addTestResult(`全局资源清理异常：${error.message || err}`);
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
    this.success = false;
    this.currentPort = null;
    this.tryStartWithPortIndex(0);

    // let config: webSocket.WebSocketServerConfig = {
    //   serverIP: '0.0.0.0',
    //   serverPort: 9091,
    //   maxConcurrentClientsNumber: 10,
    //   maxConnectionsForOneClient: 10,
    // }
    //
    // this.localServer?.on('connect', async (connection: webSocket.WebSocketConnection) => {
    //   console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
    //   this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
    //   this.connections?.push(connection);
    // });
    // this.localServer?.on('messageReceive', (message: webSocket.WebSocketMessage) => {
    //   console.info(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
    //   this.addTestResult(`订阅WebSocketServer的接收客户端消息成功,信息: client: ${message.clientConnection}, data: ${message.data}`);
    // });
    // this.localServer?.on('close', (clientConnection: webSocket.WebSocketConnection, closeReason: webSocket.CloseResult) => {
    //   console.info(`client close, client: ${clientConnection}, closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
    //   this.addTestResult(`订阅WebSocketServer的关闭事件成功, client: ${clientConnection}, closeReason: code: ${closeReason.code}, reason: ${closeReason.reason}`);
    // });
    // this.localServer?.on('error', (err: BusinessError) => {
    //   console.error(`error. code: ${err.code}, message: ${err.message}`);
    //   this.addTestResult(`订阅WebSocketServer的Error事件成功,信息: code: ${err.code}, message: ${err.message}`);
    // });
    // try{
    //   this.localServer.start(config).then((success: boolean) => {
    //     if (success) {
    //       console.info('webSocket server start success');
    //       this.addTestResult(`启动服务端service成功`);
    //       this.success = true;
    //     } else {
    //       console.error('websocket server start failed');
    //       this.addTestResult(`启动服务端service失败`);
    //     }
    //   }).catch((error: BusinessError) => {
    //     console.info(`Failed to start. Code: ${error.code}, message: ${error.message}`);
    //     this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
    //   });
    // }catch(err){
    //   console.info(`Failed to start. Code: ${err.code}, message: ${err.message}`);
    //   this.addTestResult(`Failed to start. code: ${err.code}, message: ${err.message}`);
    // };
  }

  private tryStartWithPortIndex(index: number) {
    if (index >= this.portPool.length) {
      return;
    }

    const port = this.portPool[index];
    const config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: port,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    };

    if (index === 0) {
      this.registerServerEvents();
    }

    this.localServer!.start(config)
      .then((success: boolean) => {
        if (success) {
          this.currentPort = port;
          this.success = true;
          this.addTestResult(`启动服务端service成功`);
          console.info(`WebSocket server started on port ${port}`);
        } else {
          this.tryStartWithPortIndex(index + 1);
        }
      })
      .catch((error: BusinessError) => {
        console.warn(`端口 ${port} 启动异常: ${error.message}，尝试下一个...`);
        this.tryStartWithPortIndex(index + 1);
      });
  }
  
  private registerServerEvents() {
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
      this.addTestResult(`client实例已存在`);
      this.localClient.close();
      this.localClient = null;
      return;
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
        const url = `ws://127.0.0.1:${this.currentPort}`;
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

  private on_messageReceive(i:number,callback?: () => void) {
    if(!this.localClient){
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    this.localClient?.send(`Hello, server!${i}`, (err: BusinessError, value: boolean) => {
      if (!err) {
        console.info("send success")
        console.info(`WebSocket客户端发送消息成功${i}`);
      } else {
        console.error(`send fail. code: ${err.code}, message: ${err.message}`)
      }
    });
    callback?.();
  }

  private off_messageReceive1() {
    if(!this.localServer){
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    let callback = (message: webSocket.WebSocketMessage) => {
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件成功`);
      this.addTestResult(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
    }
    try{
      this.localServer.on('messageReceive',callback);
      this.localServer?.off('messageReceive',callback);
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件成功`);
    }catch (err){
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
    setTimeout(() => {
      const localClient = webSocket.createWebSocket();

      localClient.on('open', () => {
        this.addTestResult('客户端连接成功，准备发送消息');

        localClient.send('测试消息内容');
        this.addTestResult('客户端已发送消息');
      });

      localClient.on('error', (err: BusinessError) => {
        this.addTestResult(`客户端错误: ${err.message}`);
      });
      localClient.connect(`ws://127.0.0.1:${this.currentPort}`);
    }, 1000);
  }

  private off_messageReceive2() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off(null);
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件成功`);
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_messageReceive3() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off(undefined);
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件成功`);
    } catch(err){
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_messageReceive4() {
    if(!this.checkServerStart()){
      return;
    }

    try{
      this.localServer?.off('messageReceive',null);
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件成功`);
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_messageReceive5() {
    if(!this.checkServerStart()){
      return;
    }
    try {
      this.localServer?.off('messageReceive', undefined);
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件成功`);
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_messageReceive6() {
    if(!this.localServer){
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    let callback_1 = (message: webSocket.WebSocketMessage) => {
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件成功`);
      this.addTestResult(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
    }
    let callback_2 = (message: webSocket.WebSocketMessage) => {
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件成功`);
      this.addTestResult(`on message received, client: ${message.clientConnection}, data: ${message.data}`);
    }
    try{
      this.localServer.on('messageReceive',callback_1);
      this.localServer.on('messageReceive',callback_2);
      this.localServer?.off('messageReceive');
      this.addTestResult(`取消订阅WebSocketServer的接收客户端消息事件成功`);
    }catch (err){
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
    setTimeout(() => {
      const localClient = webSocket.createWebSocket();

      localClient.on('open', () => {
        this.addTestResult('客户端连接成功，准备发送消息');

        localClient.send('测试消息内容');
        this.addTestResult('客户端已发送消息');
      });

      localClient.on('error', (err: BusinessError) => {
        this.addTestResult(`客户端错误: ${err.message}`);
      });

      localClient.connect(`ws://127.0.0.1:${this.currentPort}`);
    }, 1000);
  }

  //on_messagereceive
  private on_messagereceive(i:number,callbackName?:Callback<webSocket.WebSocketMessage>){
    if(!this.localServer){
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    let callback:Callback<webSocket.WebSocketMessage>|undefined = undefined;
    if(callbackName!==undefined)
    {
      callback = callbackName;
    }else{
      callback=(message: webSocket.WebSocketMessage) => {
        this.addTestResult(`on message received, client: ${message.clientConnection},${i} data: ${message.data}`);
      };
    }
    try{
      this.localServer.on('messageReceive',callback);
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件成功`);
    }catch (err){
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
    setTimeout(() => {
      const localClient = webSocket.createWebSocket();

      localClient.on('open', () => {
        this.addTestResult('客户端连接成功，准备发送消息');

        localClient.send('测试消息内容');
        this.addTestResult('客户端已发送消息');
      });

      localClient.on('error', (err: BusinessError) => {
        this.addTestResult(`客户端错误: ${err.message}`);
      });

      localClient.connect(`ws://127.0.0.1:${this.currentPort}`);

    }, 1000);
  }

  //on_messagereceive_type_null
  private on_messagereceive_type_null(i:number,callbackName?:Callback<webSocket.WebSocketMessage>){
    if(!this.localServer){
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    let callback:Callback<webSocket.WebSocketMessage>|undefined = undefined;
    if(callbackName!==undefined)
    {
      callback = callbackName;
    }else{
      callback=(message: webSocket.WebSocketMessage) => {
        this.addTestResult(`on message received, client: ${message.clientConnection},${i} data: ${message.data}`);
      };
    }
    try{
      this.localServer.on(null,callback);
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件成功`);
    }catch (err){
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  //on_messagereceive_type_undefined
  private on_messagereceive_type_undefined(i:number,callbackName?:Callback<webSocket.WebSocketMessage>){
    if(!this.localServer){
      this.addTestResult('客户端未启动,请先建立连接');
      return;
    }
    let callback:Callback<webSocket.WebSocketMessage>|undefined = undefined;
    if(callbackName!==undefined)
    {
      callback = callbackName;
    }else{
      callback=(message: webSocket.WebSocketMessage) => {
        this.addTestResult(`on message received, client: ${message.clientConnection},${i} data: ${message.data}`);
      };
    }
    try{
      this.localServer.on(undefined,callback);
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件成功`);
    }catch (err){
      this.addTestResult(`订阅WebSocketServer的接收客户端消息事件失败，code: ${err.code}, message: ${err.message}`);
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
      console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
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