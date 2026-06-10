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
            Button('启动服务器')
              .onClick(() => this.startWebServer())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_IP_is_0.0.0.0')
              .onClick(() => this.startWebServer_IP_is_0000())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_IP_is_undefine')
              .onClick(() => this.startWebServer_IP_is_undefine())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_IP_is_empty')
              .onClick(() => this.startWebServer_IP_is_empty())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_IP_is_11111')
              .onClick(() => this.startWebServer_IP_is_11111())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_ServerCert_CertPath_is_empty')
              .onClick(() => this.startWebServer_ServerCert_CertPath_is_empty())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_ServerCert_CertPath_is_11111')
              .onClick(() => this.startWebServer_ServerCert_CertPath_is_11111())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_ServerCert_KeyPath_is_empty')
              .onClick(() => this.startWebServer_ServerCert_KeyPath_is_empty())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_ServerCert_KeyPath_is_11111')
              .onClick(() => this.startWebServer_ServerCert_KeyPath_is_11111())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_ServerCert_is_undefined')
              .onClick(() => this.startWebServer_ServerCert_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_protocol_is_undefined')
              .onClick(() => this.startWebServer_protocol_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_protocol_is_empty')
              .onClick(() => this.startWebServer_protocol_is_empty())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_protocol_is_11111')
              .onClick(() => this.startWebServer_protocol_is_11111())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConcurrentClientsNumber_is_0')
              .onClick(() => this.startWebServer_maxConcurrentClientsNumber_is_0())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConcurrentClientsNumber_is_10')
              .onClick(() => this.startWebServer_maxConcurrentClientsNumber_is_10())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConcurrentClientsNumber_is_Negative_one')
              .onClick(() => this.startWebServer_maxConcurrentClientsNumber_is_Negative_one())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConcurrentClientsNumber_is_11')
              .onClick(() => this.startWebServer_maxConcurrentClientsNumber_is_11())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConnectionsForOneClient_is_0')
              .onClick(() => this.startWebServer_maxConnectionsForOneClient_is_0())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConnectionsForOneClient_is_10')
              .onClick(() => this.startWebServer_maxConnectionsForOneClient_is_10())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConnectionsForOneClient_is_Negative_one')
              .onClick(() => this.startWebServer_maxConnectionsForOneClient_is_Negative_one())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_maxConnectionsForOneClient_is_11')
              .onClick(() => this.startWebServer_maxConnectionsForOneClient_is_11())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_config_is_null')
              .onClick(() => this.startWebServer_config_is_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('startWebServer_config_is_undfined')
              .onClick(() => this.startWebServer_config_is_undfined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('错误码场景-无法在给定端口上监听')
              .onClick(() => this.error())
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
  aboutToDisappear() {
    this.cleanupAllWebSocketResources();
  }

  private async cleanupAllWebSocketResources() {
    try {
      if (this.localClient) {
        try {
          this.localClient.off('message');
          this.localClient.close();
        } catch (err) {
          const error = err as BusinessError;
          this.addTestResult(`客户端清理失败（send场景）：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.localServer) {
        try {
          this.localServer.off('connect');
          this.localServer.off('messageReceive');

          this.localServer.off('close');
          this.localServer.off('error');

          await this.localServer.stop().then((success: boolean) => {
            if (success) {
              console.info(`服务端：移除订阅并成功停止（send场景），无法再发送消息`);
            } else {
              console.info(`服务端：移除订阅，当前无运行中的服务器（send场景）`);
            }
          }).catch((error: BusinessError) => {
            console.info(`服务端停止异常（send场景）：code=${error.code}, message=${error.message}`);
          });

          this.success = false;    // 重置服务器运行状态
        } catch (err) {
          const error = err as BusinessError;
          console.info(`服务端清理失败（send场景）：code=${error.code}, message=${error.message}`);
        }
      }

      if (this.connections && this.connections.length > 0) {
        this.connections = [];
        console.info(`连接列表：已清空所有客户端连接（send场景依赖的连接）`);
      }
      console.info(`所有WebSocket Server send事件相关资源清理完成，无残留干扰`);
    } catch (err) {
      const error = err as Error;
      console.info(`全局资源清理异常（send场景）：${error.message || err}`);
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
      serverPort: 8087,
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

  private startWebServer_IP_is_0000() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: 8088,
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

  private startWebServer_IP_is_undefine() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: undefined,
      serverPort: 8089,
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

  private startWebServer_IP_is_empty() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "",
      serverPort: 8090, // 监听端口
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

  private startWebServer_IP_is_11111() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "11111",
      serverPort: 8091, // 监听端口
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


  private startWebServer_ServerCert_CertPath_is_empty() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8092, // 监听端口
      serverCert: { // 符合ServerCert类型的对象（只包含已知属性：certPath、keyPath）
        certPath: "", // 证书文件路径
        keyPath: "/etc/certs/server.key" // 私钥文件路径
      },
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

  private startWebServer_ServerCert_CertPath_is_11111() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8093, // 监听端口
      serverCert: { // 符合ServerCert类型的对象（只包含已知属性：certPath、keyPath）
        certPath: "11111", // 证书文件路径
        keyPath: "/etc/certs/server.key" // 私钥文件路径
      },
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

  private startWebServer_ServerCert_KeyPath_is_empty() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8094, // 监听端口
      serverCert: { // 符合ServerCert类型的对象（只包含已知属性：certPath、keyPath）
        certPath: "/etc/certs/server.key", // 证书文件路径
        keyPath: "" // 私钥文件路径
      },
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
      this.addTestResult(`Failed to start.code: ${err.code}, message: ${err.message}`);
    };
  }

  private startWebServer_ServerCert_KeyPath_is_11111() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8095, // 监听端口
      serverCert: { // 符合ServerCert类型的对象（只包含已知属性：certPath、keyPath）
        certPath: "/etc/certs/server.key", // 证书文件路径
        keyPath: "11111" // 私钥文件路径
      },
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


  private startWebServer_ServerCert_is_undefined() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8096, // 监听端口
      serverCert: undefined,
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

  private startWebServer_protocol_is_undefined() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8097, // 监听端口
      protocol:undefined,
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

  private startWebServer_protocol_is_empty() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8098,
      protocol:"",
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
  private startWebServer_protocol_is_11111() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8099, // 监听端口
      protocol:"11111",
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

  private startWebServer_maxConcurrentClientsNumber_is_0() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8100, // 监听端口
      maxConcurrentClientsNumber: 0,
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
  private startWebServer_maxConcurrentClientsNumber_is_10() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8101, // 监听端口
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

  private startWebServer_maxConcurrentClientsNumber_is_Negative_one() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8102, // 监听端口
      maxConcurrentClientsNumber: -1,
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


  private startWebServer_maxConcurrentClientsNumber_is_11() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8103, // 监听端口
      maxConcurrentClientsNumber: 11,
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



  private startWebServer_maxConnectionsForOneClient_is_0() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8104, // 监听端口
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 0,
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
  private startWebServer_maxConnectionsForOneClient_is_10() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8105, // 监听端口
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

  private startWebServer_maxConnectionsForOneClient_is_Negative_one() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8106, // 监听端口
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: -1,
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


  private startWebServer_maxConnectionsForOneClient_is_11() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: "0.0.0.0",
      serverPort: 8107,
      maxConcurrentClientsNumber: 10,
      maxConnectionsForOneClient: 11,
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

  private startWebServer_config_is_null() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    try{
      this.localServer.start(null).then((success: boolean) => {
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

  private startWebServer_config_is_undfined() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    try{
      this.localServer.start(undefined).then((success: boolean) => {
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

  private error() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: 99999,
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
      this.addTestResult(`client实例已存在`);
      this.localClient.close();
      this.localClient = null;
      return;
    }
    try {
      this.localClient = webSocket.createWebSocket();
      this.addTestResult(`client实例创建成功!`);

      class OutValue {
        status: number = 0
        message: string = ""
      }
      this.localClient.on('open', (err: BusinessError, value: Object) => {
        this.addTestResult('WebSocket客户端连接服务端成功！');
        console.info("on open, status:" + (value as OutValue).status + ", message:" + (value as OutValue).message);
      });

      this.localClient.on('message', (err: BusinessError<void>, value: string | ArrayBuffer) => {
        this.addTestResult(`📩 客户端收到服务端消息：${value}`);
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
        const url = `ws://127.0.0.1:8080`;
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