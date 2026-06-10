import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct testOnConnect {
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
            Button('on_connect')
              .onClick(() => this.on_connect())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('on_connect_type_is_null')
              .onClick(() => this.on_connect_type_is_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('on_connect_type_is_undefined')
              .onClick(() => this.on_connect_type_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_connect')
              .onClick(() => this.off_connect())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_connect_type_null')
              .onClick(() => this.off_connect_type_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_connect_type_undefined')
              .onClick(() => this.off_connect_type_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_connect_callback_undefined')
              .onClick(() => this.off_connect_callback_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_connect_no_callback')
              .onClick(() => this.off_connect_no_callback())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('off_connect_special')
              .onClick(() => this.off_connect_special())
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
        .height(240)
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
      serverPort: 9000,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 10,
    }
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

  startClient(): void {
    this.localClient = webSocket.createWebSocket();
    try {
      const ubuntuIp = '172.18.55.32';
      const url = `ws://127.0.0.1:9000`;
      console.info(`📡 连接地址：${url}`);
      this.localClient.connect(url);
    } catch (err) {
      console.error('连接失败：', (err as Error).message);
    }
  }


  private on_connect(): void {
    try {
      this.localServer?.on('connect', async (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.connections?.push(connection);
      });
    }catch(err){
      this.addTestResult(`订阅WebSocketServer的连接事件失败,code: ${err.code}, message: ${err.message}`);
    }
    setTimeout(() => this.startClient(), 2000);

  }


  private on_connect_type_is_null(): void {
    try {
      this.localServer?.on(null, async (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.connections?.push(connection);
      });
    }catch (err) {
      this.addTestResult(`订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
      console.error(`订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private on_connect_type_is_undefined(): void {
    try {
      this.localServer?.on(undefined, async (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.connections?.push(connection);
      });
    }catch (err) {
      this.addTestResult(`订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
      console.error(`订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_connect() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      let callback_1 = (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      };
      this.localServer?.on('connect',callback_1);
      this.localServer?.off('connect',callback_1);
      setTimeout(() => this.startClient(), 1000);
      setTimeout(() =>this.addTestResult(`取消订阅WebSocketServer的连接事件成功`),2000);
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_connect_type_null() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off(null);
      this.addTestResult(`取消订阅WebSocketServer的连接事件成功`)
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_connect_type_undefined() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off(undefined);
      this.addTestResult(`取消订阅WebSocketServer的连接事件成功`)
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_connect_callback_undefined() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      this.localServer?.off('connect',undefined);
      this.addTestResult(`取消订阅WebSocketServer的连接事件成功`)
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_connect_no_callback() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      let callback_1 = (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      };
      this.localServer?.on('connect',callback_1);
      this.localServer?.off('connect');
      setTimeout(() => this.startClient(), 1000);
      setTimeout(() =>this.addTestResult(`取消订阅WebSocketServer的连接事件成功`),2000);
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
    }
  }

  private off_connect_special() {
    if(!this.checkServerStart()){
      return;
    }
    try{
      let  callback_1 = (connection: webSocket.WebSocketConnection) => {
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      };
      let  callback_2 = (connection: webSocket.WebSocketConnection) => {
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
      };
      this.localServer?.on('connect',callback_1);
      this.localServer?.on('connect',callback_2);
      this.localServer?.off('connect');
      setTimeout(() => this.startClient(), 1000);
      setTimeout(() =>this.addTestResult(`取消订阅WebSocketServer的连接事件成功`),2000);
    }catch(err){
      this.addTestResult(`取消订阅WebSocketServer的连接事件失败，code: ${err.code}, message: ${err.message}`);
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