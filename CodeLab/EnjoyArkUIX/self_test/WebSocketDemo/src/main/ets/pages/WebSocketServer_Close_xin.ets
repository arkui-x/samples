import { socket, webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { On } from '@ohos.UiTest';

/**
 * 延迟配置项（精准控制，仅保留必要等待）
 */
interface DelayConfig {
  instanceCreate: number;    // 实例创建后稳定延迟：500ms
  serverStart: number;       // 服务器启动后稳定延迟：2000ms（端口绑定）
  connectListener: number;   // 订阅事件后启动客户端延迟：1000ms
  clientConnect: number;     // 客户端连接稳定延迟：1500ms
  closeOperation: number;    // 关闭连接后状态释放延迟：800ms
  cleanEnv: number;          // 环境清理提示延迟：1000ms
  retryInterval: number;     // 操作间隔延迟：3000ms
  portRelease: number;       // 端口释放等待（解决TIME_WAIT）：2000ms
}

@Entry
@Component
struct Index {
  @State message: string = `websocketserver测试`;
  @State testResults: string[] = [];
  @State isServerReady: boolean = false;
  @State isOperating: boolean = false;
  private connections?: webSocket.WebSocketConnection[] = [];
  private localServer?: webSocket.WebSocketServer | null = null;
  private localClient?: webSocket.WebSocket | null = null;
  private success: boolean = false;
  private originalPort: number = 9999;
  private serverPort: number = 9999;

  /**
   * 优化后的延迟配置（仅端口相关保留2秒，其余大幅缩短）
   */
  private delayConfig: DelayConfig = {
    instanceCreate: 500,
    serverStart: 3000,
    connectListener: 1000,
    clientConnect: 1500,
    closeOperation: 800,
    cleanEnv: 1000,
    retryInterval: 3000,
    portRelease: 2000  // 核心：解决二次创建的端口TIME_WAIT问题
  };

  /**
   * 页面进入后台：立即清理资源，不等待
   */
  onBackground(): void {
    console.info('界面进入后台，清理WebSocket资源');
    this.cleanupAllWebSocketResources();
  }

  /**
   * 页面回到前台：立即重置状态，无等待
   */
  onForeground(): void {
    console.info('界面回到前台，重置状态');
    this.initState();
    this.addTestResult(`前台初始化完成，可开始操作`);
  }

  /**
   * 页面即将显示：立即初始化，无等待
   */
  aboutToAppear(): void {
    this.initState();
    //this.addTestResult(`页面加载完成，可立即创建实例`);
  }

  /**
   * 页面即将消失：精简清理延迟，仅等500ms
   */
  async aboutToDisappear(): Promise<void> {
    this.isOperating = true;
    await this.cleanupAllWebSocketResources();
    await new Promise<void>(resolve => setTimeout(resolve, 500));
    this.isOperating = false;
  }

  /**
   * 初始化状态：重置所有实例和标记
   */
  private initState(): void {
    this.isServerReady = false;
    this.isOperating = false;
    this.connections = [];
    this.serverPort = this.originalPort;
    this.localServer = null;
    this.success = false;
    this.localClient = null;
    this.testResults = [];
    console.info('状态已初始化，端口和实例引用已重置');
  }

  /**
   * 构建UI：修复ForEach泛型，绑定正确this上下文
   */
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
            // 关闭连接相关按钮
            Button('关闭指定连接')
              .onClick(() => this.executeWithLock(() => this.closeConnect()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('close_Connection_null')
              .onClick(() => this.executeWithLock(() => this.close_Connection_null()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('close_Connection_undefined')
              .onClick(() => this.executeWithLock(() => this.close_Connection_undefined()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_code_is_1000')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_code_is_1000()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_code_is_999')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_code_is_999()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_code_is_1015')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_code_is_1015()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_code_is_1016')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_code_is_1016()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_code_is_undefined')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_code_is_undefined()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_reason_is_empty')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_reason_is_empty()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_reason_is_11111')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_reason_is_11111()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_reason_is_undefined')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_reason_is_undefined()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_is_null')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_is_null()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_ClientConnection_options_is_undefined')
              .onClick(() => this.executeWithLock(() => this.closeConnect_ClientConnection_options_is_undefined()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('closeConnect_permission')
              .onClick(() => this.executeWithLock(() => this.closeConnect()))
              .width('90%')
              .backgroundColor('#4CAF50')
              .enabled(!this.isOperating)
            Button('close_websocket connection does not exist')
              .onClick(() => this.executeWithLock(() => this.closeConnect_2302006()))
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

        // 测试日志展示区：修复ForEach泛型错误
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

        // 核心操作按钮
        Row() {
          Button('创建websocketServer实例')
            .onClick(() => this.executeWithLock(async () => {
              await this.createWebSocketServerInstanceWithDelay();
            }))
            .layoutWeight(1)
            .backgroundColor('#ff9800')
            .enabled(!this.isOperating)
          Button('启动服务器')
            .onClick(() => this.executeWithLock(async () => {
              await this.startWebServerWithDelay();
            }))
            .layoutWeight(1)
            .backgroundColor('#ff9800')
            .enabled(!this.isOperating)
        }

        // 辅助操作按钮
        Row() {
          Button('← 返回')
            .layoutWeight(1)
            .backgroundColor('#4CAF50')
            .onClick(async () => {
              this.isOperating = true;
              await this.cleanupAllWebSocketResources();
              await new Promise<void>(resolve => setTimeout(resolve, 500));
              router.back();
              this.isOperating = false;
            })
            .enabled(!this.isOperating)
          Button('订阅连接事件')
            .onClick(() => this.executeWithLock(async () => {
              await this.on_connect_with_delay();
            }))
            .layoutWeight(1)
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
            .onClick(async () => {
              this.isOperating = true;
              await this.cleanupAllWebSocketResources();
              this.isOperating = false;
              setTimeout(()=>this.addTestResult(`环境清理完成`),this.delayConfig.cleanEnv);
            })
            .enabled(!this.isOperating)
        }
        .width('100%')
        .padding(10)
      }
      .height('100%')
      .backgroundColor('#f9f9f9')
    }
  }

  /**
   * 操作锁：防止并发操作，修复返回类型
   */
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
      // 操作完成后快速释放锁（仅500ms）
      setTimeout(() => {
        this.isOperating = false;
        //this.addTestResult(`操作完成，可执行下一次操作`);
      }, 500);
    }
  }

  /**
   * 创建实例延迟：仅实例创建成功后等待短时间
   */
  private createWebSocketServerInstanceWithDelay = async (): Promise<void> => {
    const instance = this.createWebSocketServerInstance();
    if (instance) {
      await new Promise<void>(resolve => setTimeout(resolve, this.delayConfig.instanceCreate));
      //this.addTestResult(`实例创建完成，已等待${this.delayConfig.instanceCreate/1000}秒，可启动服务器`);
    }
  }

  /**
   * 启动服务器延迟：仅启动成功后等待端口稳定
   */
  private startWebServerWithDelay = async (): Promise<void> => {
    await this.startWebServer();
    if (this.success) {
      await new Promise<void>(resolve => setTimeout(resolve, this.delayConfig.serverStart));
      //this.addTestResult(`服务器启动完成，已等待${this.delayConfig.serverStart/1000}秒，可订阅连接事件`);
    }
  }

  /**
   * 清理所有资源：核心修复端口释放，解决二次创建失败
   */
  private async cleanupAllWebSocketResources(): Promise<void> {
    try {
      // 1. 立即关闭客户端，无延迟
      if (this.localClient) {
        try {
          this.localClient.off('open');
          this.localClient.off('message');
          this.localClient.off('close');
          this.localClient.off('error');
          this.localClient.close();
          console.info(`客户端：已关闭连接`);
        } catch (err) {
          const error = err as BusinessError;
          console.info(`客户端清理失败：code=${error.code}, message=${error.message}`);
        }
        this.localClient = null;
      }

      // 2. 强制停止服务器 + 等待端口释放（核心）
      if (this.localServer) {
        try {
          this.localServer.off('connect');
          this.localServer.off('messageReceive');
          this.localServer.off('close');
          this.localServer.off('error');
          const stopSuccess = await this.localServer.stop();
          if (stopSuccess) {
            console.info(`服务端：已停止，端口已释放`);
          } else {
            console.info(`ℹ️ 服务端：无运行中的服务器`);
          }
          // 等待端口TIME_WAIT释放（2秒足够）
          await new Promise<void>(resolve => setTimeout(resolve, this.delayConfig.portRelease));
        } catch (err) {
          const error = err as BusinessError;
          console.info(`服务端清理失败：code=${error.code}, message=${error.message}`);
        }
        this.localServer = null;
      }

      this.connections = [];
      this.success = false;
      console.info(`所有资源清理完成，端口已释放`);
    } catch (err) {
      const error = err as Error;
      console.info(`全局资源清理异常：${error.message || err}`);
    }
    setTimeout(() => {
      //this.addTestResult(`环境清理完成，资源释放窗口结束`);
    }, this.delayConfig.cleanEnv);
  }

  /**
   * 创建服务器实例：核心修复二次创建失败（强制释放端口+重试）
   */
  private createWebSocketServerInstance(): webSocket.WebSocketServer | null {
    // 第一步：先强制停止旧服务器，释放端口
    if (this.localServer) {
      this.localServer.stop().then(() => {
        console.info('旧服务器已强制停止，释放端口9999');
      }).catch(() => {
        console.info('无运行中的旧服务器，继续创建');
      });
      // 短暂等待端口释放
      setTimeout(() => {}, this.delayConfig.portRelease / 2);
    }

    // 第二步：创建新实例，失败则重试
    try {
      this.localServer = webSocket.createWebSocketServer();
      if (!this.localServer) {
        this.addTestResult(`server实例为null!`);
        return null;
      }
      setTimeout(()=>this.addTestResult(`server实例创建成功!`),500);
      return this.localServer;
    } catch (error) {
      // 创建失败时，等待端口释放后重试1次
      setTimeout(() => {
        try {
          this.localServer = webSocket.createWebSocketServer();
          if (this.localServer) {
            this.addTestResult(`重试创建实例成功（端口已释放）`);
          }
        } catch (retryErr) {
          this.addTestResult(`重试创建实例仍失败：${(retryErr as Error).message}`);
        }
      }, this.delayConfig.portRelease);

      this.addTestResult(`server实例创建失败! 错误：${(error as Error).message || error}`);
      return null;
    }
  }

  /**
   * 启动服务器：添加端口稳定等待，修复返回类型
   */
  private startWebServer(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      if (!this.localServer) {
        this.addTestResult(`server实例未创建，请先创建实例!`);
        reject(false);
        return;
      }

      this.localServer.stop().then(() => {
        console.info('旧服务已停止，释放端口9999');
      }).catch(() => {
        console.info('无运行中的旧服务，直接启动');
      }).finally(() => {
        const config: webSocket.WebSocketServerConfig = {
          serverIP: '0.0.0.0',
          serverPort: 9999,
          maxConcurrentClientsNumber: 10,
          maxConnectionsForOneClient: 10,
          // 若SDK支持，添加端口复用参数（不同版本字段名可能不同）
          // reusePort: true,
          // enablePortReuse: true
        };

        try {
          this.localServer?.start(config).then((success: boolean) => {
            if (success) {
              console.info('webSocket server start success');
              setTimeout(()=>this.addTestResult(`启动服务端service成功`),this.delayConfig.serverStart);
              this.success = true;
              // 启动成功后等待端口稳定
              //setTimeout(() => {}, this.delayConfig.serverStart);
              resolve(true);
            } else {
              console.error('websocket server start failed');
              this.addTestResult(`启动服务端service失败`);
              this.success = false;
              resolve(false);
            }
          }).catch((error: BusinessError) => {
            console.info(`Failed to start. code: ${error.code}, message: ${error.message}`);
            this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
            this.success = false;
            reject(error);
          });
        } catch (err) {
          const error = err as BusinessError;
          console.info(`Failed to start. code: ${error.code}, message: ${error.message}`);
          this.addTestResult(`Failed to start. code: ${error.code}, message: ${error.message}`);
          this.success = false;
          reject(err);
        }
      });
    });
  }

  /**
   * 启动客户端：精简延迟，仅保留连接稳定等待
   */
  startClient(): void {
    if (this.localClient) {
      this.localClient.close();
      this.localClient = null;
    }
    this.localClient = webSocket.createWebSocket();
    const ws = this.localClient;

    ws.on('open', () => {
      //this.addTestResult(`客户端连接服务端成功！已建立有效连接`);
      console.info('Client: Connected to server successfully');
      setTimeout(() => {
        //this.addTestResult(`连接已稳定${this.delayConfig.clientConnect/1000}秒，可执行关闭操作`);
      }, this.delayConfig.clientConnect);
    });

    ws.on('error', (err: BusinessError) => {
      this.addTestResult(`客户端连接错误：code=${err.code}, message=${err.message}`);
      console.error('Client connection error:', err);
      this.isOperating = false;
    });

    ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
      this.addTestResult(`WebSocket客户端连接关闭，状态码：${value.code}，原因：${value.reason}`);
      this.addTestResult(`客户端收到关闭：code=${value.code}, reason=${value.reason}`);
      this.connections = [];
      setTimeout(() => {
        this.isOperating = false;
      }, this.delayConfig.closeOperation);
    });

    try {
      const url = `ws://127.0.0.1:9999`;
      console.info(`连接地址：${url}`);
      // 立即发起连接，仅延迟1秒避免启动过快
      setTimeout(() => {
        ws.connect(url);
      }, 1000);
    } catch (err) {
      this.addTestResult(`发起连接请求失败：${(err as Error).message || JSON.stringify(err)}`);
      console.error('Client: Failed to connect:', err);
      this.isOperating = false;
    }
  }

  /**
   * 订阅连接事件：精简延迟，仅必要等待
   */
  private on_connect_with_delay = async (): Promise<void> => {
    if (!this.localServer) {
      this.addTestResult(`服务器实例未创建，无法订阅连接事件`);
      this.isOperating = false;
      return;
    }
    if (!this.success) {
      this.addTestResult(`服务器未启动，先启动服务器再订阅事件`);
      await this.startWebServerWithDelay();
      if (!this.success) {
        this.addTestResult(`服务器启动失败，无法绑定连接监听`);
        this.isOperating = false;
        return;
      }
    }
    // 仅等待2秒确保服务器稳定
    await new Promise<void>(resolve => setTimeout(resolve, 2000));
    this.bindConnectListener();
  }

  /**
   * 绑定连接监听：无额外延迟
   */
  private bindConnectListener(): void {
    try {
      this.localServer?.off('connect');
      this.localServer?.on('connect', async (connection: webSocket.WebSocketConnection) => {
        console.info(`New client connected! Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.addTestResult(`订阅WebSocketServer的连接事件成功,连接信息：Client ip: ${connection.clientIP}, Client port: ${connection.clientPort}`);
        this.connections = [connection];
      });
      //this.addTestResult(`已成功订阅连接事件，${this.delayConfig.connectListener/1000}秒后启动客户端`);
      setTimeout(() => this.startClient(), this.delayConfig.connectListener);
    } catch (err) {
      const error = err as BusinessError;
      this.addTestResult(`订阅WebSocketServer的连接事件失败,code: ${error.code}, message: ${error.message}`);
      this.isOperating = false;
    }
  }

  /**
   * 检查服务器状态：修复this上下文
   */
  private checkServerStart(): boolean {
    if (!this.localServer) {
      this.addTestResult(`服务器实例未创建，请先创建实例!`);
      return false;
    }
    if (!this.success) {
      this.addTestResult(`服务器未启动，请先启动服务器!`);
      return false;
    }
    return true;
  }

  // ========== 关闭连接相关方法：修复this上下文 + 显式返回类型 ==========
  private closeConnect(): void {
    if (!this.checkServerStart()) {
      this.isOperating = false;
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(connection).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
            this.localClient = null;
            this.success = false;
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
          setTimeout(() => {
            this.isOperating = false;
          }, this.delayConfig.closeOperation);
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
          this.isOperating = false;
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.isOperating = false;
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
      this.isOperating = false;
    }
  }

  private close_Connection_null(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(null).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
      } finally {
        this.connections = [];
        this.localClient?.close();
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private close_Connection_undefined(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(undefined).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
      } finally {
        this.connections = [];
        this.localClient?.close();
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_code_is_1000(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: "CLOSE_NORMAL"
      };
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_code_is_999(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 999,
        reason: ""
      };
      try {
        this.localServer?.close(this.connections[0], options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_code_is_1015(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 1015,
        reason: ""
      };
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_code_is_1016(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 1016,
        reason: ""
      };
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}`);
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_code_is_undefined(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: undefined,
        reason: ""
      };
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
          this.connections = [];
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}“`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}”`);
      } finally {
        this.connections = [];
        this.localClient?.close();
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_reason_is_empty(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: ""
      };
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
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
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}“`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}”`);
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_reason_is_11111(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: "11111"
      };
      try {
        this.localServer?.close(connection, options).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`);
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}“`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}”`);
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_reason_is_undefined(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const options: webSocket.WebSocketCloseOptions = {
        code: 1000,
        reason: undefined,
      };
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
          this.connections = [];
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}“`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}”`);
      } finally {
        this.connections = [];
        this.localClient?.close();
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_is_null(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      try {
        this.localServer?.close(connection, null).then((success: boolean) => {
          if (success) {
            console.info('close client successfully');
            this.addTestResult(`关闭指定连接成功，连接信息：` + connectionInfo);
            this.connections = [];
          } else {
            console.error('close client failed');
            this.addTestResult(`关闭指定连接失败`);
          }
        }).catch((err: BusinessError) => {
          console.info(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}“`)
          this.addTestResult(`close client failed：错误码”[${err.code}]“，错误信息”${err.message}”`);
        }).finally(() => {
          this.connections = [];
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}“`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}”`);
      } finally {
        this.connections = [];
        this.localClient?.close();
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_ClientConnection_options_is_undefined(): void {
    if (!this.checkServerStart()) {
      return;
    }
    if (this.connections?.length) {
      const connection = this.connections[0];
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
          this.connections = [];
        });
      } catch (err) {
        const error = err as BusinessError;
        console.info(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}“`);
        this.addTestResult(`close client failed：错误码”[${error.code}]“，错误信息”${error.message}”`);
      } finally {
        this.connections = [];
        this.localClient?.close();
      }
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  private closeConnect_2302006(): void {
    if (!this.checkServerStart()) {
      return;
    }
    const server: webSocket.WebSocketServer = webSocket.createWebSocketServer();
    if (this.connections?.length) {
      const connection = this.connections[0];
      const connectionInfo = this.connections?.map((conn) => {
        return `{ip: ${conn.clientIP}, port: ${conn.clientPort}}`;
      }).join(', ');
      const wrongConnection: webSocket.WebSocketConnection = {
        clientIP: '1.1.1.1',
        clientPort: 8888
      };
      server.close(wrongConnection).then((success: boolean) => {
        if (success) {
          return;
        }
      }).catch((err: BusinessError) => {
        console.info(`${err.code}, ${err.message}`);
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}”`);
      }).finally(() => {
        this.connections = [];
        this.localClient?.close();
      });
    } else {
      this.addTestResult(`无可用连接可关闭`);
    }
  }

  /**
   * 停止服务器：修复this上下文
   */
  private stopServer(): void {
    if (!this.checkServerStart()) {
      return;
    }
    this.localServer?.stop().then((success: boolean) => {
      if (success) {
        console.info('server stop service successfully');
        this.addTestResult(`停止服务器成功`);
        this.success = false;
      } else {
        console.error('server stop service failed');
        this.addTestResult(`停止服务器失败`);
      }
    }).catch((error: BusinessError) => {
      console.error(`message send failed，code: ${error.code}, message: ${error.message}`);
      this.addTestResult(`停止服务器异常：code=${error.code}, message=${error.message}`);
    });
  }

  /**
   * 添加测试日志：显式返回类型
   */
  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`测试结果: ${result}`);
  }

  /**
   * 清理测试日志：显式返回类型
   */
  clearTestResults(): void {
    this.testResults = [];
  }
}