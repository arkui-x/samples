
import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { On } from '@ohos.UiTest';
import { connection } from '@kit.ConnectivityKit';

@Entry
@Component
struct Index {
  @State message: string = `websocketserver测试`;
  @State testResults: string[] = [];
  private connections?: webSocket.WebSocketConnection[] = [];
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

        // 核心修正：Scroll组件的属性挂载到Scroll上，而非内部Column
        Scroll() {
          Column({ space: 8 }) { // 补充space属性，优化按钮间距
            Button('发送数据')
              .onClick(() => this.sendData())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('send_after_stop')
              .onClick(() => this.sendData_no_connect())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_data_is_null')
              .onClick(() => this.sendData_data_is_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_data_is_undefined')
              .onClick(() => this.sendData_data_is_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_data_over_5242864')
              .onClick(() => this.sendData_data_over_5242864())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_data_is_empty')
              .onClick(() => this.sendData_data_is_empty())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_data_is_11111')
              .onClick(() => this.sendData_data_is_11111())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_connection_null')
              .onClick(() => this.sendData_connection_null())
              .width('90%')
              .backgroundColor('#4CAF50')
            Button('sendData_connection_undefined')
              .onClick(() => this.sendData_connection_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')
            // Button('sendData_permission')
            //   .onClick(() => this.sendData())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')
          }
          .width('100%') // 内部Column占满Scroll宽度
        }
        // Scroll组件的属性移到此处（核心修正）
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor('#0A59F7')
        .scrollBarWidth(10)
        .edgeEffect(EdgeEffect.Spring)
        .height('40%') // 调整高度，为测试结果列表留出空间
        .flexGrow(1)

        // 新增：测试结果列表（嵌入到外层Column中，按钮区域下方）
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
      .padding(10)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }
  async aboutToDisappear() {
    await this.cleanupAllWebSocketResources();
    await this.clearServer();
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

          this.localServer.stop().then((success: boolean) => {
            if (success) {
              console.info(`服务端：移除订阅并成功停止（send场景），无法再发送消息`);
            } else {
              console.info(`服务端：移除订阅，当前无运行中的服务器（send场景）`);
            }
          }).catch((error: BusinessError) => {
            console.info(`服务端停止异常（send场景）：code=${error.code}, message=${error.message}`);
          });

          this.success = false;
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
      serverPort: 9636,
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
          setTimeout(() => this.startClient(), 2000);
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

  private startWebServer_1() {
    if (!this.localServer) {
      this.addTestResult(`server实例未创建，请先创建实例!`);
      return;
    }
    let config: webSocket.WebSocketServerConfig = {
      serverIP: '0.0.0.0',
      serverPort: 9636, // 监听端口
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
          this.addTestResult(`启动服务端service_1成功`);
          this.success = true;
          setTimeout(() => this.startClient_1(), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(`启动服务端service_1失败`);
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

  private startClient_1(): void {
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
        console.info("on close, code is " + value.code + ", reason is " + value.reason);
      });

      this.localClient.on('error', (error: BusinessError) => {
        this.addTestResult(`WebSocket客户端连接出错：${error.message || JSON.stringify(error)}`);
        console.error('Client: Connection error:', error);
      });

      try {
        const url = `ws://127.0.0.1:8080`;
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
        const url = `ws://127.0.0.1:9636`;
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

  private sendData() {
    if(!this.checkServerStart()){
      return;
    }
    if (!this.localClient) {
      this.addTestResult("客户端未连接，正在连接...");
    }else{

      if (this.connections?.length) {
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
          console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
        })
      }
    }
  }

  private sendData_connection_null() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send("Hello, I'm server!", null).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
        this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  private sendData_connection_undefined() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send("Hello, I'm server!", undefined).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  private sendData_no_connect() {
    if (!this.checkServerStart()) {
      return;
    }
    this.localServer?.stop().then((stopSuccess: boolean) => {
      if (stopSuccess) {
        setTimeout(() => {
          if (this.connections?.length) {
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
              console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
              this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
            }).finally(()=>{
              this.connections = this.connections?.filter(conn => conn !== connection);
            })
          }
        }, 1000);
      }
    }).catch((error: BusinessError) => {
      console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
    })
  }

  private sendData_data_is_null() {
    if(!this.checkServerStart()){
      return;
    }
    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send(null, connection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          console.info('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
        console.info(`message send failed, code: ${error.code}, message: ${error.message}`);
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  private sendData_data_is_undefined() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send(undefined, connection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  private sendData_data_over_5242864() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      const EXACT_LIMIT = 5242864; // 5 * 1024 * 1024 - 16
      const OVER_LIMIT_SIZE = EXACT_LIMIT + 1; // 超过1字节
      const overLimitString = 'A'.repeat(OVER_LIMIT_SIZE);
      this.localServer?.send(overLimitString, connection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  private sendData_data_is_empty() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send("", connection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        this.addTestResult(`message send failed, code: ${error.code}, message: ${error.message}`);
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }
  private sendData_data_is_11111() {
    if(!this.checkServerStart()){
      return;
    }

    if(this.connections?.length){
      let connection = this.connections[0];
      this.localServer?.send("11111", connection).then((success: boolean) => {
        if (success) {
          console.info('message send successfully');
          this.addTestResult(`发送信息成功`);
        } else {
          console.error('message send failed');
          this.addTestResult(`发送信息失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`message send failed, code: ${error.code}, message: ${error.message}`);
      })
    }
  }

  private async clearServer() {
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
            this.addTestResult(`关闭指定连接成功，连接信息：`+ connectionInfo);
            this.connections = this.connections?.filter(conn => conn !== connection);
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) =>{
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
        this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
      }
    }
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