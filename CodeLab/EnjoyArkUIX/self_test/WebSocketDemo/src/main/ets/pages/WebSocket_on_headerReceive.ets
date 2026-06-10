  import { BusinessError } from '@kit.BasicServicesKit';
  import { webSocket } from '@kit.NetworkKit';
  import router from '@ohos.router';

  @Entry
  @Component
  struct testWebSocketOnHeadRecv {
    @State testResults: string[] = [];
    private localWsList: webSocket.WebSocket[] = [];
    private localServerList: webSocket.WebSocketServer[] = [];
    aboutToAppear(): void {
      // this.testWebSocketOnHeadRecv();
      // this.testWebSocketOffHeadRecv();
      // this.clearTestResults();
    }

    aboutToDisappear() {
      this.cleanupWebSocketResources();
    }

    private cleanupWebSocketResources() {
      try {
        if (this.localWsList.length > 0) {
          this.localWsList.forEach((ws, index) => {
            try {
              if (!ws) return;
              ws.off('headerReceive');
              ws.off('open');
              ws.off('message');
              ws.off('error');
              ws.off('close');
              ws.close();
              this.addTestResult(`✅ 客户端[${index}]：移除所有订阅并关闭连接`);
            } catch (err) {
              const error = err as BusinessError;
              this.addTestResult(`❌ 客户端[${index}]清理失败：code=${error.code}, message=${error.message}`);
            }
          });
          this.localWsList = []; // 修复：清空数组，彻底释放所有实例引用
        }

        if (this.localServerList.length > 0) {
          this.localServerList.forEach(async (server, index) => {
            try {
              server.off('connect');
              server.off('messageReceive');
              server.off('error');
              const success = await server.stop();
              if (success) {
                this.addTestResult(`✅ 服务端[${index}]：成功停止并移除订阅`);
              } else {
                this.addTestResult(`ℹ️ 服务端[${index}]：当前无运行中的服务`);
              }
            } catch (err) {
              const error = err as BusinessError;
              this.addTestResult(`❌ 服务端[${index}]清理失败：code=${error.code}, message=${error.message}`);
            }
          });
          this.localServerList = []; // 清空数组，释放所有实例引用
        }

        this.addTestResult(`🎉 WebSocket所有资源清理完成，无残留`);
      } catch (err) {
        const error = err as Error;
        this.addTestResult(`❌ 全局清理异常：${error.message || err}`);
      }
    }


    // 订阅HTTP Response Header事件，使用callback方式作为异步方法。
    testWebSocketOnHeadRecv(): void {
      let localServer: webSocket.WebSocketServer = webSocket.createWebSocketServer();
      let config: webSocket.WebSocketServerConfig = {
        serverPort: 8081, // 监听端口
        maxConcurrentClientsNumber: 10,
        maxConnectionsForOneClient: 10,
      }
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      this.localServerList.push(localServer);
      localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(` 启动服务端service成功`);

          setTimeout(() => this.startClient(), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(` 启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`Failed to start. Code: ${error.code}, message: ${error.message}`);
      });
    }


    startClient(): void {
      const ws = webSocket.createWebSocket();
      if (!ws) {
        console.error(' WebSocket 实例创建失败');
        return;
      }
      this.localWsList.push(ws);
      try{
        ws.on('headerReceive', (headers) => {
          console.info('headerReceive 事件触发成功！');
          console.info('响应头：', JSON.stringify(headers));
          console.info('自定义头：', headers['X-Custom-Header']); // 应输出「极简测试头」
          this.addTestResult(`订阅HTTP Response Header事件成功`);
          this.addTestResult(`'响应头: ` + JSON.stringify(headers));
        });
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }

      // 连接成功/错误/消息事件
      ws.on('open', () => {
        console.info('连接成功（局域网直连）');
        ws.send('鸿蒙测试消息');
      });
      ws.on('error', (err) => {
        console.error(' 错误：', err.message);
      });
      ws.on('message', (msg) => {
        console.info('服务器回复：', msg);
      });

      // 发起连接（替换为你的 Ubuntu 局域网 IP）
      try {
        const ubuntuIp = '172.18.55.32'; // ws://10.173.24.156:8081

        const url = `ws://127.0.0.1:8081`;
        console.info(`连接地址：${url}`);
        ws.connect(url);
      } catch (err) {
        console.error(' 连接失败：', (err as Error).message);
      }
    }

    // 订阅HTTP Response Header事件，使用callback方式作为异步方法。
    testWebSocketOnHeadRecv_Callback_null(): void {
      let localServer: webSocket.WebSocketServer = webSocket.createWebSocketServer();
      let config: webSocket.WebSocketServerConfig = {
        serverPort: 8082, // 监听端口
        maxConcurrentClientsNumber: 10,
        maxConnectionsForOneClient: 10,
      }
      this.localServerList.push(localServer);
      localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(`启动服务端service成功`);

          setTimeout(() => this.startClient_Callback_null(), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(`启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`Failed to start. code: ${error.code}, message: ${error.message}`);
      });
    }

    startClient_Callback_null(): void {
      const ws = webSocket.createWebSocket();
      if (!ws) {
        console.error(' WebSocket 实例创建失败');
        return;
      }
      this.localWsList.push(ws);

      // 核心：监听 headerReceive（握手阶段触发）
      try{
        ws.on('headerReceive', null);
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }

      // 连接成功/错误/消息事件
      ws.on('open', () => {
        console.info('连接成功（局域网直连）');
        ws.send('鸿蒙测试消息');
      });
      ws.on('error', (err) => {
        console.error(' 错误：', err.message);
      });
      ws.on('message', (msg) => {
        console.info('服务器回复：', msg);
      });

      // 发起连接（替换为你的 Ubuntu 局域网 IP）
      try {
        const ubuntuIp = '172.18.55.32'; // ws://10.173.24.156:8081

        const url = `ws://127.0.0.1:8082`;
        console.info(`连接地址：${url}`);
        ws.connect(url);
      } catch (err) {
        console.error(' 连接失败：', (err as Error).message);
      }
    }

    testWebSocketOnHeadRecv_Callback_undefined(): void {
      let localServer: webSocket.WebSocketServer = webSocket.createWebSocketServer();
      let config: webSocket.WebSocketServerConfig = {
        serverPort: 8083, // 监听端口
        maxConcurrentClientsNumber: 10,
        maxConnectionsForOneClient: 10,
      }
      this.localServerList.push(localServer);
      localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(`启动服务端service成功`);

          setTimeout(() => this.startClient_Callback_undefined(), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(`启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`Failed to start. code: ${error.code}, message: ${error.message}`);
      });
    }
    startClient_Callback_undefined(): void {
      const ws = webSocket.createWebSocket();
      if (!ws) {
        console.error(' WebSocket 实例创建失败');
        return;
      }
      this.localWsList.push(ws);

      // 核心：监听 headerReceive（握手阶段触发）
      try{
        ws.on('headerReceive', undefined);
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }

      // 连接成功/错误/消息事件
      ws.on('open', () => {
        console.info(' 连接成功（局域网直连）');
        ws.send('鸿蒙测试消息');
      });
      ws.on('error', (err) => {
        console.error(' 错误：', err.message);
      });
      ws.on('message', (msg) => {
        console.info('服务器回复：', msg);
      });

      // 发起连接（替换为你的 Ubuntu 局域网 IP）
      try {
        const ubuntuIp = '172.18.55.32'; // ws://10.173.24.156:8081

        const url = `ws://127.0.0.1:8083`;
        console.info(`连接地址：${url}`);
        ws.connect(url);
      } catch (err) {
        console.error(' 连接失败：', (err as Error).message);
      }
    }

    // 取消订阅HTTP Response Header事件，使用callback方式作为异步方法。
    testWebSocketOffHeadRecv(): void {
      let localServer: webSocket.WebSocketServer = webSocket.createWebSocketServer();
      let config: webSocket.WebSocketServerConfig = {
        serverPort: 8084, // 监听端口
        maxConcurrentClientsNumber: 10,
        maxConnectionsForOneClient: 10,
      }
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      this.localServerList.push(localServer);
      localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(` 启动服务端service成功`);

          setTimeout(() => this.startClient_1(ws), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(` 启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`Failed to start. Code: ${error.code}, message: ${error.message}`);
      });
    }

    startClient_1(ws:webSocket.WebSocket): void {
      if (!ws) {
        console.error(' WebSocket 实例创建失败');
        return;
      }
      try {
        let callback = (data: Record<string, string | string[]>) => {
          console.info(' headerReceive 事件触发成功！');
          this.addTestResult(` 订阅HTTP Response Header 事件成功`+ JSON.stringify(data));
        }
        ws.on('headerReceive', callback)
        try {
          ws.off('headerReceive', callback);
          this.addTestResult(` 取消订阅HTTP Response Header事件成功`);
        } catch (err) {
          this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
        }
      } catch (err) {
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }
      ws.on('open', () => {
        console.info(' 连接成功（局域网直连）');
        ws.send('鸿蒙测试消息');
      });
      ws.on('error', (err) => {
        console.error(' 错误：', err.message);
      });
      ws.on('message', (msg) => {
        console.info('服务器回复：', msg);
      });

      // 发起连接（替换为你的 Ubuntu 局域网 IP）
      try {
        const ubuntuIp = '172.18.55.32'; // ws://10.173.24.156:8081

        const url = `ws://127.0.0.1:8084`;
        console.info(`连接地址：${url}`);
        ws.connect(url);
      } catch (err) {
        console.error(' 连接失败：', (err as Error).message);
      }
    }

    // 取消订阅HTTP Response Header事件，使用callback方式作为异步方法。
    testWebSocketOffHeadRecv_null(): void {
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      try{
        ws.off(null);
        this.addTestResult(` 取消订阅HTTP Response Header事件成功`);
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }
    }

    testWebSocketOffHeadRecv_undefined(): void {
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      try{
        ws.off(undefined);
        this.addTestResult(` 取消订阅HTTP Response Header事件成功`);
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }
    }

    testWebSocketOffHeadRecv_Callback_null(): void {
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      try{
        ws.off("headerReceive",null);
        this.addTestResult(` 取消订阅HTTP Response Header事件成功`);
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息${err.message}`);
      }
    }

    testWebSocketOffHeadRecv_Callback_undefined(): void {
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      try{
        ws.off("headerReceive",undefined);
        this.addTestResult(` 取消订阅HTTP Response Header事件成功`);
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }
    }

    testWebSocketOffHeadRecv_no_callback(): void {
      let localServer: webSocket.WebSocketServer = webSocket.createWebSocketServer();
      let config: webSocket.WebSocketServerConfig = {
        serverPort: 8085, // 监听端口
        maxConcurrentClientsNumber: 10,
        maxConnectionsForOneClient: 10,
      }
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      this.localServerList.push(localServer);
      localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(` 启动服务端service成功`);

          setTimeout(() => this.startClient_3(ws), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(` 启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`Failed to start. Code: ${error.code}, message: ${error.message}`);
      });
    }

    startClient_3(ws:webSocket.WebSocket): void {
      if (!ws) {
        console.error(' WebSocket 实例创建失败');
        return;
      }
      try {
        ws.on('headerReceive', (data) => {
          console.info(' headerReceive 事件触发成功！');
          this.addTestResult(` 订阅HTTP Response Header 事件成功`);
        })
        try {
          ws.off('headerReceive');
          this.addTestResult(` 取消订阅HTTP Response Header事件成功`);
        } catch (err) {
          this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
        }
      } catch (err) {
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }
      ws.on('open', () => {
        console.info(' 连接成功（局域网直连）');
        ws.send('鸿蒙测试消息');
      });
      ws.on('error', (err) => {
        console.error(' 错误：', err.message);
      });
      ws.on('message', (msg) => {
        console.info('服务器回复：', msg);
      });

      // 发起连接（替换为你的 Ubuntu 局域网 IP）
      try {
        const ubuntuIp = '172.18.55.32'; // ws://10.173.24.156:8081

        const url = `ws://127.0.0.1:8085`;
        console.info(`连接地址：${url}`);
        ws.connect(url);
      } catch (err) {
        console.error(' 连接失败：', (err as Error).message);
      }
    }

    //special
    testWebSocketOffHeadRecv_special(): void {
      let localServer: webSocket.WebSocketServer = webSocket.createWebSocketServer();
      let config: webSocket.WebSocketServerConfig = {
        serverPort: 8086, // 监听端口
        maxConcurrentClientsNumber: 10,
        maxConnectionsForOneClient: 10,
      }
      let ws = webSocket.createWebSocket();
      this.localWsList.push(ws);
      this.localServerList.push(localServer);
      localServer.start(config).then((success: boolean) => {
        if (success) {
          console.info('webSocket server start success');
          this.addTestResult(` 启动服务端service成功`);

          setTimeout(() => this.startClient_2(ws), 2000);
        } else {
          console.error('websocket server start failed');
          this.addTestResult(` 启动服务端service失败`);
        }
      }).catch((error: BusinessError) => {
        console.error(`Failed to start. Code: ${error.code}, message: ${error.message}`);
      });
    }


    startClient_2(ws:webSocket.WebSocket): void {
      if (!ws) {
        console.error(' WebSocket 实例创建失败');
        return;
      }
      try{
        ws.on('headerReceive', (headers) => {
          console.info(' headerReceive_1 事件触发成功！');
          this.addTestResult(` 订阅HTTP Response Header_1 事件成功`);
        });
        ws.on('headerReceive', (headers) => {
          console.info(' headerReceive_2 事件触发成功！');
          this.addTestResult(` 订阅HTTP Response Header_2 事件成功`);
        })
        try{
          ws.off('headerReceive');
          this.addTestResult(` 取消所有订阅HTTP Response Header事件成功`);
        }catch(err){
          this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
        };
      }catch(err){
        this.addTestResult(`错误码:[${err.code}]，错误信息:${err.message}`);
      }

      // 连接成功/错误/消息事件
      ws.on('open', () => {
        console.info(' 连接成功（局域网直连）');
        ws.send('鸿蒙测试消息');
      });
      ws.on('error', (err) => {
        console.error(' 错误：', err.message);
      });
      ws.on('message', (msg) => {
        console.info('服务器回复：', msg);
      });

      // 发起连接（替换为你的 Ubuntu 局域网 IP）
      try {
        const ubuntuIp = '172.18.55.32'; // ws://10.173.24.156:8081

        const url = `ws://127.0.0.1:8086`;
        console.info(`连接地址：${url}`);
        ws.connect(url);
      } catch (err) {
        console.error(' 连接失败：', (err as Error).message);
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

    build() {
      // 外层使用Column（垂直布局），替代外层Scroll，避免整体滚动影响固定区域
      Column() {
        // 独立提取：标题（脱离滚动容器，固定显示，不随滑动移动）
        Text('websocket测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 10, bottom: 5 })
          .width('100%')
          .textAlign(TextAlign.Center);

        Scroll() {
          Column({ space: 20 }) {
            Button('on_headerReceive_normal测试')
              .onClick(() => this.testWebSocketOnHeadRecv())
              .width('90%')
              .height(40);
            Button('on_headerReceive_callback_null测试')
              .onClick(() => this.testWebSocketOnHeadRecv_Callback_null())
              .width('90%')
              .height(40);
            Button('on_headerReceive_callback_undefined测试')
              .onClick(() => this.testWebSocketOnHeadRecv_Callback_undefined())
              .width('90%')
              .height(40);
            Button('off_headerReceive_normal测试')
              .onClick(() => this.testWebSocketOffHeadRecv())
              .width('90%')
              .height(40);
            Button('off_headerReceive_null测试')
              .onClick(() => this.testWebSocketOffHeadRecv_null())
              .width('90%')
              .height(40);
            Button('off_headerReceive_undefined测试')
              .onClick(() => this.testWebSocketOffHeadRecv_undefined())
              .width('90%')
              .height(40);
            Button('off_headerReceive_Callback_null测试')
              .onClick(() => this.testWebSocketOffHeadRecv_Callback_null())
              .width('90%')
              .height(40);
            Button('off_headerReceive_Callback_undefined测试')
              .onClick(() => this.testWebSocketOffHeadRecv_Callback_undefined())
              .width('90%')
              .height(40);
            Button('off_headerReceive_no_Callback测试')
              .onClick(() => this.testWebSocketOffHeadRecv_no_callback())
              .width('90%')
              .height(40);
            Button('off_headerReceive_special测试')
              .onClick(() => this.testWebSocketOffHeadRecv_special())
              .width('90%')
              .height(40);
          }
          .width('100%')
          .padding(5)
          .backgroundColor('#f0f0f0')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .width('100%')
        .flexGrow(1)
        .height('40%')

        // 中间部分：日志显示区域（固定在下半部分，占40%空间，固定高度不随内容滚动）
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
        .height('40%')
        .width('100%')
        .margin({ top: 5 })
        .padding(5)
        .border({ width: 1, color: '#dddddd' })

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
        }
        .width('100%')
        .padding(5) // 增加内边距，优化按钮显示效果
        .margin({ top: 5 }) // 与日志区域保持间距，提升美观度
      }
      .width('100%')
      .height('100%') // 外层Column占满整个界面，确保布局定位准确
    }
  }








