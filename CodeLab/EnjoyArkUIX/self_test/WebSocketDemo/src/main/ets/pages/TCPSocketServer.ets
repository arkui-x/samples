import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import util from '@ohos.util';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'TCPSocketServer接口测试';
  @State log: string = '';
  @State testResults: string[] = [];
  private tcpServerCon: socket.TCPSocketServer | null = null;
  private tcpClient: socket.TCPSocket | null = null;
  private connectCallback: Callback<socket.TCPSocketConnection> | null = null;
  private testPort: number = 8080;

  // 监听地址配置
  private listenAddr: socket.NetAddress = {
    address: '0.0.0.0', // 监听所有网络接口
    port: 8080,
    family: 1 // IPv4
  };

  build() {
    Row() {
      Column({ space: 15 }) {
        // 1. 顶部固定区域
        Text(this.message)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .padding(10)
          .backgroundColor('#f0f0f0')
          .borderRadius(5)
          .width('100%')
          .textAlign(TextAlign.Center)

        // 2. 可滚动的按钮区域 - 将这部分按钮用Scroll包裹
        Scroll() {
          Column({ space: 15 }) {
            Button('listen_callback')
              .onClick(() => this.listen_callback())
              .width('90%')

            // Button('listen callback 权限校验失败')
            //   .onClick(() => this.listen_callback_permission())
            //   .width('90%')

            Button('listen callback address参数类型错误 address为 ""')
              .onClick(() => this.listen_callback_address_no())
              .width('90%')

            Button('listen callback address参数类型错误 address为 11111')
              .onClick(() => this.listen_callback_address_11111())
              .width('90%')

            Button('listen callback port 为 undefined')
              .onClick(() => this.listen_callback_port_undefined())
              .width('90%')

            Button('listen callback family 为 undefined')
              .onClick(() => this.listen_callback_family_undefined())
              .width('90%')

            Button('listen callback address为 null')
              .onClick(() => this.listen_callback_address_null())
              .width('90%')

            Button('listen callback address为 undefined')
              .onClick(() => this.listen_callback_address_undefined())
              .width('90%')

            Button('listen 未传入 callback 参数')
              .onClick(() => this.listen_callback_no())
              .width('90%')

            Button('listen callback 类型错误 undefined')
              .onClick(() => this.listen_callback_undefined())
              .width('90%')

            Button('listen callback 类型错误 null')
              .onClick(() => this.listen_callback_null())
              .width('90%')

            Button('listen 无法分配请求的地址')
              .onClick(() => this.listen_callback_unable_allocate_address())
              .width('90%')

            Button('listen_promise')
              .onClick(() => this.listen_promise())
              .width('90%')

            // Button('listen_promise 权限校验失败')
            //   .onClick(() => this.listen_promise_permission())
            //   .width('90%')

            Button('listen promise address参数类型错误 address为 ""')
              .onClick(() => this.listen_promise_address_no())
              .width('90%')

            Button('listen promise address参数类型错误 address为 "11111"')
              .onClick(() => this.listen_promise_address_11111())
              .width('90%')

            Button('listen promise port 为 undefined')
              .onClick(() => this.listen_promise_port_undefined())
              .width('90%')

            Button('listen promise family 为 undefined')
              .onClick(() => this.listen_promise_family_undefined())
              .width('90%')

            Button('listen promise address为 null')
              .onClick(() => this.listen_promise_address_null())
              .width('90%')

            Button('listen promise address为 undefined')
              .onClick(() => this.listen_promise_address_undefined())
              .width('90%')



            Button('listen promise 无法分配请求的地址')
              .onClick(() => this.listen_promise_unable_allocate_address())
              .width('90%')

            Button('调用 close 且有通过listen方法绑定的端口')
              .onClick(() => this.close_normal())
              .width('90%')

            Button('多次调用listen方法，再调用close方法')
              .onClick(() => this.close_special())
              .width('90%')

            // Button('close 权限校验失败')
            //   .onClick(() => this.close_permission_denied())
            //   .width('90%')
            //2303109 文件编号无效(Bad file number.)
            // Button('listen 文件编号无效')
            //   .onClick(() => this.listen_callback_bad_file_number())
            //   .width('90%')

            // getState方法按钮

            Button('getState_callback')
              .onClick(() => this.getState_callback())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getState callback 类型错误 undefined')
              .onClick(() => this.getState_callback_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getState callback 类型错误 null')
              .onClick(() => this.getState_callback_null())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getState 未传入 callback 参数')
              .onClick(() => this.getState_callback_no())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getState_promise')
              .onClick(() => this.getState_promise())
              .width('90%')
              .backgroundColor('#2196F3')

            // 新增：连接事件绑定/解绑按钮
            Button('on_connect')
              .onClick(() => this.on_connect())
              .width('90%')
              .backgroundColor('#2196F3')

            // Button('on connect type 为 null')
            //   .onClick(() => this.on_connect_type_null())
            //   .width('90%')
            //   .backgroundColor('#2196F3')
            //
            // Button('on connect type 为 undefined')
            //   .onClick(() => this.on_connect_type_undefined())
            //   .width('90%')
            //   .backgroundColor('#2196F3')

            Button('on connect callback 类型错误 undefined')
              .onClick(() => this.on_connect_callback_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('on connect callback 类型错误 null')
              .onClick(() => this.on_connect_callback_null())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('off_connect')
              .onClick(() => this.off_connect())
              .width('90%')
              .backgroundColor('#2196F3')

            // Button('off_connect type 为 null')
            //   .onClick(() => this.off_connect_type_null())
            //   .width('90%')
            //   .backgroundColor('#2196F3')
            //
            // Button('off_connect type 为 undefined')
            //   .onClick(() => this.off_connect_type_undefined())
            //   .width('90%')
            //   .backgroundColor('#2196F3')

            Button('off_connect callback 类型错误 undefined')
              .onClick(() => this.off_connect_callback_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('off_connect callback 类型错误 null')
              .onClick(() => this.off_connect_callback_null())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('off_connect 未传入 callback 参数')
              .onClick(() => this.off_connect_callback_no())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('off_connect_special')
              .onClick(() => this.off_connect_special())
              .width('90%')
              .backgroundColor('#2196F3')

            // setExtraOptions方法按钮
            Button('setExtraOptions_promise')
              .onClick(() => this.setExtraOptions_promise())
              .width('90%')
              .backgroundColor('#2196F3')

            // Button('setExtraOptions promise 权限校验失败')
            //   .onClick(() => this.setExtraOptions_promise_permission())
            //   .width('90%')
            //   .backgroundColor('#2196F3')


            Button('setExtraOptions promise keepAlive 为 false')
              .onClick(() => this.setExtraOptions_promise_keepAlive_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise keepAlive 为 undefined')
              .onClick(() => this.setExtraOptions_promise_keepAlive_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise OOBlnline 为 false')
              .onClick(() => this.setExtraOptions_promise_kOOBlnline_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise OOBlnline 为 undefined')
              .onClick(() => this.setExtraOptions_promise_OOBlnline_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise TCPNoDelay 为 false')
              .onClick(() => this.setExtraOptions_promise_TCPNoDelay_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise TCPNoDelay 为 undefined')
              .onClick(() => this.setExtraOptions_promise_TCPNoDelay_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise linger 参数为-1')
              .onClick(() => this.setExtraOptions_promise_linger_1())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise linger 参数为65536')
              .onClick(() => this.setExtraOptions_promise_linger_65536())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise on 参数为false')
              .onClick(() => this.setExtraOptions_promise_on_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise socketLinger 为 undefined')
              .onClick(() => this.setExtraOptions_promise_socketLinger_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise options 为 null')
              .onClick(() => this.setExtraOptions_promise_options_null())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise options 为 undefined')
              .onClick(() => this.setExtraOptions_promise_options_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions_callback')
              .onClick(() => this.setExtraOptions_callback())
              .width('90%')
              .backgroundColor('#2196F3')

            // Button('setExtraOptions callback 权限校验失败')
            //   .onClick(() => this.setExtraOptions_callback_permission())
            //   .width('90%')
            //   .backgroundColor('#2196F3')

            Button('setExtraOptions callback keepAlive 为 false')
              .onClick(() => this.setExtraOptions_callback_keepAlive_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback keepAlive 为 undefined')
              .onClick(() => this.setExtraOptions_callback_keepAlive_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback OOBlnline 为 false')
              .onClick(() => this.setExtraOptions_callback_OOBlnline_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback OOBlnline 为 undefined')
              .onClick(() => this.setExtraOptions_callback_OOBlnline_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback TCPNoDelay 为 false')
              .onClick(() => this.setExtraOptions_callback_TCPNoDelay_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback TCPNoDelay 为 undefined')
              .onClick(() => this.setExtraOptions_callback_TCPNoDelay_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback linger 参数为-1')
              .onClick(() => this.setExtraOptions_callback_linger_1())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback linger 参数为65536')
              .onClick(() => this.setExtraOptions_callback_linger_65536())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback on 参数为 false')
              .onClick(() => this.setExtraOptions_callback_on_false())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback socketLinger 为 undefined')
              .onClick(() => this.setExtraOptions_callback_socketLinger_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback options为 null')
              .onClick(() => this.setExtraOptions_callback_option_null())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback options 为 undefined')
              .onClick(() => this.setExtraOptions_callback_option_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions 未传入 callback 参数')
              .onClick(() => this.setExtraOptions_callback_no())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback 类型错误 undefined')
              .onClick(() => this.setExtraOptions_callback_undefined())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback 类型错误 null')
              .onClick(() => this.setExtraOptions_callback_null())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('SetExtraOptions_callback_2303109')
              .onClick(() => this.SetExtraOptions_callback_2303109())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('SetExtraOptions_promise_2303109')
              .onClick(() => this.SetExtraOptions_promise_2303109())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback keepAlive 为 true')
              .onClick(() => this.setExtraOptions_callback_keepAlive_true())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise keepAlive 为 true')
              .onClick(() => this.setExtraOptions_promise_keepAlive_true())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions callback TCPNoDelay 为 true')
              .onClick(() => this.setExtraOptions_callback_TCPNoDelay_true())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('setExtraOptions promise TCPNoDelay 为 true')
              .onClick(() => this.setExtraOptions_promise_TCPNoDelay_true())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getLocalAdress')
              .onClick(() => this.getLocalAdress())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getLocalAdress 无效的文件描述符')
              .onClick(() => this.getLocalAdress_invalid_fd())
              .width('90%')
              .backgroundColor('#2196F3')

            Button('getSocketFd')
              .onClick(() => this.getSocketFd())
              .width('90%')
              .backgroundColor('#2196F3')

            //构造错误码  2300002 系统内部错误(System internal error.) --无法构建
            // Button('listen_callback_2300002')
            //   .onClick(() => this.listen_callback_2300002())
            //   .width('90%')
            //   .backgroundColor('#2196F3')


            //无法构建
            // Button('listen_callback_2303111')
            //   .onClick(() => this.listen_callback_2303111())
            //   .width('90%')
            //   .backgroundColor('#2196F3')
          }
          .width('100%')
        }
        .height('50%')
        .width('100%')

        // 3. 底部固定区域
        Scroll() {
          Text(this.log)
            .fontSize(14)
            .width('100%')
            .padding(10)
        }
        .height('30%')
        .width('100%')
        .border({ width: 1, color: '#eee' })
        .borderRadius(5)

        Row({ space: 10 }) {
          Button('← 返回')
            .width('50%')
            .padding({ left: 15, right: 15 })
            .backgroundColor('#4CAF50')
            .onClick(() => {
              router.back();
            })
          Button('清理日志')
            .width('50%')
            .padding({ left: 15, right: 15 })
            .backgroundColor('#4CAF50')
            .onClick(() => this.clearTestResults())
        }
      }
      .width('100%')
      .padding(10)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }

  aboutToDisappear(): void {
    this.stopTest();
  }

  private stopTest(): void {
    if (this.tcpServerCon) {
      this.tcpServerCon.close();
      this.tcpServerCon = null;
    }
    if (this.tcpClient) {
      this.tcpClient.close();
      this.tcpClient = null;
    }
    this.releaseNetworkResources();

    setTimeout(() => {
      console.info(`端口 ${this.testPort} 清理完成`);
    }, 300);
  }

  private resetNetworkState(): void {
    this.testPort = 8080;
    console.info('网络状态已重置');
    this.addLog('IP和端口绑定状态已重置');
  }

  private clearDNSCache(): void {
    try {
      const localhost = '127.0.0.1';
      console.info(`DNS缓存清理完成，本地地址: ${localhost}`);
    } catch (error) {
      console.info('DNS清理完成');
    }
  }

  private releaseNetworkResources(): void {
    try {
      const releaseSocket: socket.TLSSocket = socket.constructTLSSocketInstance();
      const releaseAddress: socket.NetAddress = {
        address: '0.0.0.0',
        port: this.testPort
      };

      releaseSocket.bind(releaseAddress, () => {
        releaseSocket.close();
        console.info(`端口 ${this.testPort} 已强制释放`);
      });

      setTimeout(() => {
        releaseSocket.close();
      }, 100);
    } catch (error) {
      console.info('端口释放操作完成');
    }

    this.resetNetworkState();
    this.clearDNSCache();
  }

  clearTestResults(): void {
    this.testResults = [];
    this.log = '';
  }

  private addLog(content: string) {
    this.log += `${content}\n`;
  }
  // Promise 方式启动监听
  private listen_promise(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8088,
      family: 1
    }
    tcpServer.listen(listenAddr).then(() => {
      console.info('listen success');
      this.addLog('listen success');
    }).catch((err: BusinessError) => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }).finally(() => {
      tcpServer.close();
    });
  }

  //listen_promise_permission
  private listen_promise_permission(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8088,
      family: 1
    }
    tcpServer.listen(listenAddr).then(() => {
      console.info('listen success');
      this.addLog('listen success');
    }).catch((err: BusinessError) => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }).finally(() => {
      tcpServer.close();
    });
  }

  // listen_promise_address_null
  private listen_promise_address_null(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: "0,0,0,0",
      port: 8088,
      family: 1
    }
    try {
      tcpServer.listen(null);
    }
    catch (err){
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
    setTimeout((): void => { tcpServer.close(); }, 3000);
  }

  //listen_promise_address_undefined
  private listen_promise_address_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: "0,0,0,0",
      port: 8088,
      family: 1
    }
    try {
      tcpServer.listen(undefined);
    }
    catch (err){
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
    setTimeout((): void => { tcpServer.close(); }, 3000);
  }

  //listen_promise_address_no
  private listen_promise_address_no(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: "",
      port: 8088,
      family: 1
    }
    try {
      tcpServer.listen(listenAddr).then((): void => {
        this.addLog('address为 ""时, listen success');
      }).catch((err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      }).finally((): void => {
        tcpServer.close();
      });
    }
    catch (err){
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
    setTimeout((): void => { tcpServer.close(); }, 3000);
  }

  //listen_promise_address_11111
  private listen_promise_address_11111(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: "11111",
      port: 8088,
      family: 1
    }

    tcpServer.listen(listenAddr).then((): void => {
      this.addLog('address为 "11111"时, listen success');
    }).catch((err: BusinessError) => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }).finally((): void => {
      tcpServer.close();
    });
  }

  //listen_promise_port_undefined
  private listen_promise_port_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: undefined,
      family: 1
    }

    tcpServer.listen(listenAddr).then((): void => {
      this.addLog("port 为 undefined 时,listen success");
    }).catch((err: BusinessError) => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }).finally((): void => {
      tcpServer.close();
    });
  }

  //listen_promise_family_undefined
  private listen_promise_family_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: undefined
    }

    tcpServer.listen(listenAddr).then((): void => {
      this.addLog("family 为 undefined 时,listen success");
    }).catch((err: BusinessError) => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }).finally(() => {
      tcpServer.close();
    });
  }

  //listen_promise_unable_allocate_address
  private listen_promise_unable_allocate_address() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '192.168.100.200',
      port: 8088,
      family: 1
    }
    tcpServer.listen(listenAddr).then(() => {
      console.info('listen success');
      this.addLog('listen success');
    }).catch((err: BusinessError) => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      console.info(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }).finally(() => {
      tcpServer.close();
    });
  }

  // Callback 方式启动监听
  private listen_callback() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    try{
      tcpServer.listen(listenAddr, (err: BusinessError) => {
        if (err) {
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          return;
        }
        this.addLog('listen success');
      })
    }catch(err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen_callback_permission
  private listen_callback_permission() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    try{
      tcpServer.listen(listenAddr, (err: BusinessError) => {
        if (err) {
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          return;
        }
        console.info("listen success");
        this.addLog('listen success');
      })
    }catch(err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen address为null
  private listen_callback_address_null() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    try{
      tcpServer.listen(null, (err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      })
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen address为undefined
  private listen_callback_address_undefined() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    try{
      tcpServer.listen(undefined, (err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      })
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen_callback_address_no
  private listen_callback_address_no() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: "",
      port: 8080,
      family: 1
    }
    try{
      tcpServer.listen(listenAddr, (err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      })
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      this.addLog("listen address 为 undefined");
    }
    finally {
      tcpServer.close();
    }
  }

  //listen_callback_address_11111
  private listen_callback_address_11111() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '11111',
      port: 8080,
      family: 1
    }
    try{
      tcpServer.listen(listenAddr, (err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      })
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }
    finally {
      tcpServer.close();
    }
  }

  //listen_callback_port_undefined
  private listen_callback_port_undefined() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: undefined,
      family: 1
    }
    try{
      tcpServer.listen(listenAddr, (err:BusinessError) =>{
        if(err){
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          return;
        }
        this.addLog("port 为 undefined 时,listen success");
      });
    }catch(err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen_callback_family_undefined
  private listen_callback_family_undefined() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: undefined
    }

    try{
      tcpServer.listen(listenAddr, (err:BusinessError) =>{
        if(err){
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          return;
        }
        this.addLog("family 为 undefined 时,listen success");
      });
    }catch(err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen callback 类型错误
  private listen_callback_null() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8088,
      family: 1
    }

    try{
      tcpServer.listen(listenAddr, null);
    }
    catch (err) {
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
    finally {
      tcpServer.close();
    }
  }

  //listen callback 类型错误
  private listen_callback_undefined() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8088,
      family: 1
    }

    try{
      tcpServer.listen(listenAddr, undefined);
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }
    finally {
      tcpServer.close();
    }
  }

  //listen 未传入 callback
  private listen_callback_no() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8088,
      family: 1
    }

    try{
      tcpServer.listen(listenAddr,).then(() => {
        this.addLog("listen 未传入 callback时,listen success");
      }).catch((err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      });
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  //listen_callback_unable_allocate_address
  private listen_callback_unable_allocate_address() {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '192.168.100.200',
      port: 8088,
      family: 1
    }

    try{
      tcpServer.listen(listenAddr, (err: BusinessError) => {
        if (err) {
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          return;
        }
        console.info("listen success");
        this.addLog('listen success');
      })
    }catch(err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }finally {
      tcpServer.close();
    }
  }

  private async cleanSocketServer(server: socket.TCPSocketServer): Promise<void> {
    try {
      // 先关闭监听
      await server.close();
      await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 200); });
      // 检查状态，确保已关闭
      const state: socket.SocketStateBase | undefined = await server.getState();
      //this.addLog(`资源清理完成，服务器状态: ${JSON.stringify(state)}`);
    } catch (err) {
      //this.addLog(`资源清理警告: ${err.message}`);
    }
  }

  //close_normal
  private close_normal(): void {
    setTimeout((): void => {
      let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
      let listenAddr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 8080,
        family: 1
      }

      tcpServer.listen(listenAddr).then((): void => {
        this.addLog('listen success');
      }).catch((err: BusinessError): void => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      });

      tcpServer.getState().then((data: socket.SocketStateBase): void => {
        this.addLog('getState success' + JSON.stringify(data));
      }).catch((err: BusinessError): void => {
        this.addLog('getState fail' + JSON.stringify(err));
      }).finally((): void => {
        tcpServer.close(); // 停止监听
        this.cleanSocketServer(tcpServer);
        tcpServer.getState().then((data: socket.SocketStateBase): void => {
          this.addLog('getState success' + JSON.stringify(data));
        }).catch((err: BusinessError): void => {
          this.addLog('getState fail' + JSON.stringify(err));
        });
      });
    }, 2000);
  }

  //close_special
  private close_special(): void {
    setTimeout((): void => {
      let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
      let listenAddr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 8081,
        family: 1
      }
      let listenAddr1: socket.NetAddress = {
        address: '0.0.0.0',
        port: 8082,
        family: 1
      }

      tcpServer.listen(listenAddr).then((): void => {
        tcpServer.getLocalAddress().then((localAddress: socket.NetAddress): void => {
          this.addLog("SUCCESS! Address:" + JSON.stringify(localAddress));
          tcpServer.listen(listenAddr1).then((): void => {
            tcpServer.getLocalAddress().then((localAddress: socket.NetAddress): void => {
              this.addLog("SUCCESS! Address:" + JSON.stringify(localAddress));
            }).catch((err: BusinessError): void => {
              this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
            })
          }).catch((err: BusinessError): void => {
            this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          });
        }).catch((err: BusinessError): void => {
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
        })
      }).catch((err: BusinessError): void => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      }).finally((): void => {
        tcpServer.close(); // 停止监听
        this.cleanSocketServer(tcpServer);
        tcpServer.getState().then((data: socket.SocketStateBase): void => {
          this.addLog('getState success' + JSON.stringify(data));
        }).catch((err: BusinessError): void => {
          this.addLog('getState fail' + JSON.stringify(err));
        });
      });
    }, 2000);

  }

  private close_permission_denied(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr).then((): void => {
      this.addLog('listen success');

    }).catch((err: BusinessError): void => {
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    });

    tcpServer.close(); // 停止监听

    tcpServer.getState().then((data: socket.SocketStateBase): void => {
      this.addLog('getState success' + JSON.stringify(data));
    }).catch((err: BusinessError): void => {
      this.addLog('getState fail' + JSON.stringify(err));
    });
  }

  // Promise 方式获取服务器状态
  private getState_promise(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError): void => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }
    })
    this.cleanSocketServer(tcpServer);
    setTimeout((): void => {
      tcpServer.getState().then((data: socket.SocketStateBase): void => {
        console.info('getState success' + JSON.stringify(data));
        this.addLog('getState success' + JSON.stringify(data));
      }).catch((err: BusinessError): void => {
        console.error('getState fail');
        this.addLog('getState fail');
      }).finally((): void => {
        tcpServer.close();
      });
    }, 1000);
  }

  // Callback 方式获取服务器状态
  private getState_callback(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError): void => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }
    })
    this.cleanSocketServer(tcpServer);
    setTimeout((): void => {
      try{
        tcpServer.getState((err: BusinessError, data: socket.SocketStateBase): void => {
          if (err) {
            console.error('getState fail');
            this.addLog('listen fail');
            return;
          }
          console.info('getState success:' + JSON.stringify(data));
          this.addLog('getState success' + JSON.stringify(data));
        })
      }catch(err){
        console.error('getState fail');
        this.addLog('listen fail');
        return;
      }finally {
        tcpServer.close();
      }
    }, 1000)

  }

  //getState_callback_undefined
  private getState_callback_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError): void => {
      if (err) {
        this.addLog('listen fail');
        return;
      }
    })
    try{
      tcpServer.getState(undefined);
    }
    catch (err){
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    } finally{
      tcpServer.close();
    }
  }

  //getState_callback_null
  private getState_callback_null(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError): void => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }
    })

    try{
      tcpServer.getState(null);
    }
    catch (err){
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    } finally{
      tcpServer.close();
    }
  }

  //getState 未传入 callback
  private getState_callback_no() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog('listen fail');
        return;
      }
    })
    try{
      tcpServer.getState();
      this.addLog('getState 未传入 callback 参数时, getState success');
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    } finally{
      tcpServer.close();
    }
  }

  // Promise 方式设置额外选项
  private setExtraOptions_promise() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }
      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_permission
  private setExtraOptions_promise_permission(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
        return;
      }
      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  private setExtraOptions_promise_keepAlive_true(): void {
    // 服务端
    const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    const keepAliveOptions: socket.TCPExtraOptions = {
      keepAlive: true,  // 重点测试
      OOBInline: false,
      TCPNoDelay: false,
      socketLinger: { on: false, linger: 0 } as socket.SocketLinger,
      socketTimeout: 10000
    };

    server.listen({ address: '0.0.0.0', port: 9091, family: 1 }, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务端监听失败: ${err.message}`);
        return;
      }
      this.addLog('服务端: 监听成功，端口 9091');

      server.setExtraOptions(keepAliveOptions).then(() => {
        this.addLog('服务端: keepAlive=true 已设置');
      }).catch((err: BusinessError) => {
        this.addLog(`服务端设置选项失败: ${err.message}`);
      });

      server.on('connect', (client: socket.TCPSocketConnection) => {
        this.addLog(`[${new Date().toISOString()}] 客户端连接`);

        // 记录最后活动时间
        let lastActivity = Date.now();
        let isConnected = true;

        // 修正：使用正确的回调类型
        client.on('message', (value: socket.SocketMessageInfo) => {
          lastActivity = Date.now();

          // 解析消息内容
          let messageView = '';
          let uint8Array = new Uint8Array(value.message);
          for (let i: number = 0; i < value.message.byteLength; i++) {
            let messages = uint8Array[i];
            let message = String.fromCharCode(messages);
            messageView += message;
          }
          this.addLog(`收到消息: ${messageView}`);
          console.info('remoteInfo: ' + JSON.stringify(value.remoteInfo));
        });

        client.on('close', () => {
          isConnected = false;
          this.addLog('连接已关闭');
        });

        // 测试1: 120秒后检查连接状态（短时间测试）
        setTimeout(() => {
          if (!isConnected) {
            this.addLog('❌ 连接已断开（可能在30秒内被系统关闭）');
            return;
          }

          const idleTime = Date.now() - lastActivity;
          this.addLog(`[${new Date().toISOString()}] 空闲时长: ${idleTime}ms`);

          // 尝试发送数据验证连接
          const tcpSendOption: socket.TCPSendOptions = {
            data: 'KeepAlive Test!'
          };

          client.send(tcpSendOption, (err: BusinessError) => {
            if (err) {
              this.addLog(`❌ 发送失败: ${err.message} (连接可能已断开)`);
            } else {
              this.addLog('✅ 发送成功 (连接保持活动)');
            }

            // 关闭连接
            client.close();
            server.close();
          });
        }, 120000); // 30秒测试
      });
    });

    // 客户端（2秒后连接）
    setTimeout(() => {
      const client: socket.TCPSocket = socket.constructTCPSocketInstance();
      const clientOpts: socket.TCPConnectOptions = {
        address: { address: '127.0.0.1', port: 9091, family: 1 } as socket.NetAddress,
        timeout: 5000
      };

      client.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`客户端连接失败: ${err.message}`);
          return;
        }
        this.addLog('客户端: 连接成功，将保持空闲120秒');

        // 设置客户端keepAlive
        client.setExtraOptions(keepAliveOptions);

        // 监听消息
        client.on('message', (value: socket.SocketMessageInfo) => {
          let messageView = '';
          let uint8Array = new Uint8Array(value.message);
          for (let i: number = 0; i < value.message.byteLength; i++) {
            let messages = uint8Array[i];
            let message = String.fromCharCode(messages);
            messageView += message;
          }
          this.addLog(`客户端收到消息: ${messageView}`);
        });

        // 连接后不发送任何数据，保持空闲
      });
    }, 2000);
  }

  private setExtraOptions_callback_keepAlive_true(): void {
    // 服务端
    const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    const keepAliveOptions: socket.TCPExtraOptions = {
      keepAlive: true,  // 重点测试
      OOBInline: false,
      TCPNoDelay: false,
      socketLinger: { on: false, linger: 0 } as socket.SocketLinger,
      socketTimeout: 10000
    };

    server.listen({ address: '0.0.0.0', port: 9091, family: 1 }, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务端监听失败: ${err.message}`);
        return;
      }
      this.addLog('服务端: 监听成功，端口 9091');

      server.setExtraOptions(keepAliveOptions,(err: BusinessError) => {
        if (err) {
          this.addLog(`服务端设置选项失败: ${err.message}`);
        } else {
          this.addLog('服务端: keepAlive=true 已设置');
        }
      });

      server.on('connect', (client: socket.TCPSocketConnection) => {
        this.addLog(`客户端连接`);

        // 记录最后活动时间
        let lastActivity = Date.now();
        let isConnected = true;

        // 修正：使用正确的回调类型
        client.on('message', (value: socket.SocketMessageInfo) => {
          lastActivity = Date.now();

          // 解析消息内容
          let messageView = '';
          let uint8Array = new Uint8Array(value.message);
          for (let i: number = 0; i < value.message.byteLength; i++) {
            let messages = uint8Array[i];
            let message = String.fromCharCode(messages);
            messageView += message;
          }
          this.addLog(`收到消息: ${messageView}`);
          console.info('remoteInfo: ' + JSON.stringify(value.remoteInfo));
        });

        client.on('close', () => {
          isConnected = false;
          this.addLog('连接已关闭');
        });

        // 测试1: 120秒后检查连接状态（短时间测试）
        setTimeout(() => {
          if (!isConnected) {
            this.addLog('❌ 连接已断开（可能在30秒内被系统关闭）');
            return;
          }

          const idleTime = Date.now() - lastActivity;
          this.addLog(`空闲时长: ${idleTime}ms`);

          // 尝试发送数据验证连接
          const tcpSendOption: socket.TCPSendOptions = {
            data: 'KeepAlive Test!'
          };

          client.send(tcpSendOption, (err: BusinessError) => {
            if (err) {
              this.addLog(`❌ 发送失败: ${err.message} (连接可能已断开)`);
            } else {
              this.addLog('✅ 发送成功 (连接保持活动)');
            }

            // 关闭连接
            client.close();
            server.close();
          });
        }, 120000); // 30秒测试
      });
    });

    // 客户端（2秒后连接）
    setTimeout((): void => {
      const client: socket.TCPSocket = socket.constructTCPSocketInstance();
      const clientOpts: socket.TCPConnectOptions = {
        address: { address: '127.0.0.1', port: 9091, family: 1 } as socket.NetAddress,
        timeout: 5000
      };

      client.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`客户端连接失败: ${err.message}`);
          return;
        }
        this.addLog('客户端: 连接成功，将保持空闲120秒');

        // 设置客户端keepAlive
        client.setExtraOptions(keepAliveOptions);

        // 监听消息
        client.on('message', (value: socket.SocketMessageInfo) => {
          let messageView = '';
          let uint8Array = new Uint8Array(value.message);
          for (let i: number = 0; i < value.message.byteLength; i++) {
            let messages = uint8Array[i];
            let message = String.fromCharCode(messages);
            messageView += message;
          }
          this.addLog(`客户端收到消息: ${messageView}`);
        });

        // 连接后不发送任何数据，保持空闲
      });
    }, 2000);
  }

  //setExtraOptions_promise_keepAlive_false
  private setExtraOptions_promise_keepAlive_false(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }
      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: false,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_keepAlive_undefined
  private setExtraOptions_promise_keepAlive_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: undefined,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      try {
        tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
          console.info('setExtraOptions success');
          this.addLog('setExtraOptions success');
        }).catch((err: BusinessError) => {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
        }).finally((): void => {
          tcpServer.close();
        });
      } catch (err) {
        this.addLog(`错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      } finally {
        tcpServer.close();
      }
    })
  }

  //setExtraOptions_promise_kOOBlnline_false
  private setExtraOptions_promise_kOOBlnline_false(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: false,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_OOBlnline_undefined
  private setExtraOptions_promise_OOBlnline_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: false,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      };
      try {
        tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
          console.info('setExtraOptions success');
          this.addLog('setExtraOptions success');
        }).catch((err: BusinessError) => {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
        }).finally((): void => {
          tcpServer.close();
        });
      } catch (err) {
        this.addLog(`错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      } finally {
        tcpServer.close();
      }
    })
  }

  private setExtraOptions_promise_TCPNoDelay_true(): void {
    const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    const noDelayOptions: socket.TCPExtraOptions = {
      keepAlive: false,
      OOBInline: false,
      TCPNoDelay: true,  // 重点测试
      socketLinger: { on: false, linger: 0 } as socket.SocketLinger,
      socketTimeout: 5000
    };

    server.listen({ address: '0.0.0.0', port: 9093, family: 1 }, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务端监听失败: ${err.message}`);
        return;
      }
      this.addLog('服务端: 监听成功，端口 9093');
      this.addLog('测试说明: TCPNoDelay=true 会禁用Nagle算法，小数据包立即发送');

      server.setExtraOptions(noDelayOptions).then((): void => {
        this.addLog('服务端: TCPNoDelay=true 已设置');
      }).catch((err: BusinessError) => {
        this.addLog(`服务端设置选项失败: ${err.message}`);
      })

      server.on('connect', (client: socket.TCPSocketConnection) => {
        this.addLog('客户端连接成功');

        let messageCount = 0;
        let startTime = Date.now();

        client.on('message', (value: socket.SocketMessageInfo) => {
          messageCount++;
          this.addLog(`收到消息${messageCount}: ${value.message.byteLength}字节`);

          if (messageCount >= 10) {
            const endTime = Date.now();
            const duration = endTime - startTime;
            this.addLog(`✅ 收到10个消息，总耗时: ${duration}ms`);

            if (duration < 100) {
              this.addLog('✅ TCPNoDelay生效: 小数据包快速传输');
            } else {
              this.addLog('⚠️ 传输较慢，可能Nagle算法仍生效');
            }

            client.close();
            server.close();
          }
        });
      });
    });

    // 客户端
    setTimeout((): void => {
      const client: socket.TCPSocket = socket.constructTCPSocketInstance();
      const clientOpts: socket.TCPConnectOptions = {
        address: { address: '127.0.0.1', port: 9093, family: 1 } as socket.NetAddress,
        timeout: 5000
      };

      client.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`客户端连接失败: ${err.message}`);
          return;
        }
        this.addLog('客户端: 连接成功');

        // 设置客户端TCPNoDelay
        client.setExtraOptions(noDelayOptions);

        // 连续发送10个小数据包
        this.addLog('开始发送10个小数据包...');
        const startTime = Date.now();

        const sendNext = (index: number): void => {
          if (index > 10) {
            const endTime = Date.now();
            this.addLog(`客户端发送完成，耗时: ${endTime - startTime}ms`);
            return;
          }

          const message = `Msg${index}`;
          const tcpSendOption: socket.TCPSendOptions = {
            data: message
          };

          client.send(tcpSendOption, (err: BusinessError) => {
            if (err) {
              this.addLog(`发送失败: ${err.message}`);
              return;
            }
            this.addLog(`已发送消息${index}: ${message}`);
            sendNext(index + 1);
          });
        };

        sendNext(1);
      });
    }, 2000);
  }

  private setExtraOptions_callback_TCPNoDelay_true(): void {
    const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    const noDelayOptions: socket.TCPExtraOptions = {
      keepAlive: false,
      OOBInline: false,
      TCPNoDelay: true,  // 重点测试
      socketLinger: { on: false, linger: 0 } as socket.SocketLinger,
      socketTimeout: 5000
    };

    server.listen({ address: '0.0.0.0', port: 9093, family: 1 }, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务端监听失败: ${err.message}`);
        return;
      }
      this.addLog('服务端: 监听成功，端口 9093');
      this.addLog('测试说明: TCPNoDelay=true 会禁用Nagle算法，小数据包立即发送');

      server.setExtraOptions(noDelayOptions, (err: BusinessError) => {
        if(err){
          this.addLog(`服务端设置选项失败: ${err.message}`);
        }else{
          this.addLog('服务端: TCPNoDelay=true 已设置');
        }
      });

      server.on('connect', (client: socket.TCPSocketConnection) => {
        this.addLog('客户端连接成功');

        let messageCount = 0;
        let startTime = Date.now();

        client.on('message', (value: socket.SocketMessageInfo) => {
          messageCount++;
          this.addLog(`收到消息${messageCount}: ${value.message.byteLength}字节`);

          if (messageCount >= 10) {
            const endTime = Date.now();
            const duration = endTime - startTime;
            this.addLog(`✅ 收到10个消息，总耗时: ${duration}ms`);

            if (duration < 100) {
              this.addLog('✅ TCPNoDelay生效: 小数据包快速传输');
            } else {
              this.addLog('⚠️ 传输较慢，可能Nagle算法仍生效');
            }

            client.close();
            server.close();
          }
        });
      });
    });

    // 客户端
    setTimeout((): void => {
      const client: socket.TCPSocket = socket.constructTCPSocketInstance();
      const clientOpts: socket.TCPConnectOptions = {
        address: { address: '127.0.0.1', port: 9093, family: 1 } as socket.NetAddress,
        timeout: 5000
      };

      client.connect(clientOpts, (err: BusinessError) => {
        if (err) {
          this.addLog(`客户端连接失败: ${err.message}`);
          return;
        }
        this.addLog('客户端: 连接成功');

        // 设置客户端TCPNoDelay
        client.setExtraOptions(noDelayOptions);

        // 连续发送10个小数据包
        this.addLog('开始发送10个小数据包...');
        const startTime = Date.now();

        const sendNext = (index: number): void => {
          if (index > 10) {
            const endTime = Date.now();
            this.addLog(`客户端发送完成，耗时: ${endTime - startTime}ms`);
            return;
          }

          const message = `Msg${index}`;
          const tcpSendOption: socket.TCPSendOptions = {
            data: message
          };

          client.send(tcpSendOption, (err: BusinessError) => {
            if (err) {
              this.addLog(`发送失败: ${err.message}`);
              return;
            }
            this.addLog(`已发送消息${index}: ${message}`);
            sendNext(index + 1);
          });
        };

        sendNext(1);
      });
    }, 2000);
  }

//setExtraOptions_promise_TCPNoDelay_false
  private setExtraOptions_promise_TCPNoDelay_false(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: false,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

//setExtraOptions_promise_TCPNoDelay_undefined
  private setExtraOptions_promise_TCPNoDelay_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: undefined,
        socketLinger: { on: true, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      try {
        tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
          console.info('setExtraOptions success');
          this.addLog('setExtraOptions success');
        }).catch((err: BusinessError) => {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
        }).finally((): void => {
          tcpServer.close();
        });
      } catch (err) {
        this.addLog(`错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      } finally {
        tcpServer.close();
      }
    })
  }

  //setExtraOptions_promise_linger_1
  private setExtraOptions_promise_linger_1(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: -1 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_linger_65536
  private setExtraOptions_promise_linger_65536(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: true, linger: 65536 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then(() => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_on_false
  private setExtraOptions_promise_on_false(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: { on: false, linger: 10 } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error('setExtraOptions fail');
        this.addLog('setExtraOptions fail');
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_socketLinger_undefined
  private setExtraOptions_promise_socketLinger_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: undefined,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        this.addLog('socketLinger 为 undefined 时，setExtraOptions success');
      }).catch((err: BusinessError) => {
        this.addLog('setExtraOptions fail');
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      }).finally((): void => {
        tcpServer.close();
      });
    })
  }

  //setExtraOptions_promise_options_null
  private setExtraOptions_promise_options_null(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      try {
        tcpServer.setExtraOptions(null);
      } catch (err) {
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
        this.addLog('setExtraOptions fail');
      } finally {
        tcpServer.close();
      }
    })
  }

  //setExtraOptions_promise_options_undefined
  private setExtraOptions_promise_options_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      try {
        tcpServer.setExtraOptions(undefined);
      } catch (err) {
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
        this.addLog('setExtraOptions fail');
      } finally {
        tcpServer.close();
      }
    })
  }

  // Callback 方式设置额外选项
  private setExtraOptions_callback(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError) => {
        if (err) {
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_permission
  private setExtraOptions_callback_permission(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_keepAlive_false
  private setExtraOptions_callback_keepAlive_false(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: false,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_keepAlive_undefined
  private setExtraOptions_callback_keepAlive_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: undefined as boolean | undefined,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      };
      try {
        tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
          if (err) {
            console.error('setExtraOptions fail');
            this.addLog('setExtraOptions fail');
            setTimeout((): void => { tcpServer.close(); }, 300);
            return;
          }
          console.info('setExtraOptions success');
          this.addLog('setExtraOptions success');
        });
      } catch (err) {
        this.addLog(`错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      }
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_OOBlnline_false
  private setExtraOptions_callback_OOBlnline_false(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: false,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_kOOBlnline_undefined
  private setExtraOptions_callback_OOBlnline_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: undefined as boolean | undefined,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      };
      try {
        tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
          if (err) {
            console.error('setExtraOptions fail');
            this.addLog('setExtraOptions fail');
            setTimeout((): void => { tcpServer.close(); }, 300);
            return;
          }
          console.info('setExtraOptions success');
          this.addLog('setExtraOptions success');
        });
      } catch (err) {
        this.addLog(`错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      }
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_TCPNoDelay_false
  private setExtraOptions_callback_TCPNoDelay_false(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: false,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_TCPNoDelay_undefined
  private setExtraOptions_callback_TCPNoDelay_undefined(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: undefined,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      try {
        tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
          if (err) {
            console.error('setExtraOptions fail');
            this.addLog('setExtraOptions fail');
            setTimeout((): void => { tcpServer.close(); }, 300);
            return;
          }
        });
      } catch (err) {
        this.addLog(`错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      }
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_linger_1
  private setExtraOptions_callback_linger_1(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: -1
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_linger_65536
  private setExtraOptions_callback_linger_65536(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 65536
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_on_false
  private setExtraOptions_callback_on_false(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: false,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          console.error('setExtraOptions fail');
          this.addLog('setExtraOptions fail');
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_socketLinger_undefined
  private setExtraOptions_callback_socketLinger_undefined(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      interface SocketLinger {
        on: boolean;
        linger: number;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: undefined,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          this.addLog('setExtraOptions fail');
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        this.addLog('socketLinger 为 undefined 时，setExtraOptions success');
      });
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_option_null
  private setExtraOptions_callback_option_null(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      interface SocketLinger {
        on: boolean;
        linger: number;
      }

      try{
        tcpServer.setExtraOptions(null,(err: BusinessError): void => {
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
        });
      }
      catch (err){
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
        this.addLog('setExtraOptions fail');
      }
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_option_undefined
  private setExtraOptions_callback_option_undefined(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      interface SocketLinger {
        on: boolean;
        linger: number;
      }

      try{
        tcpServer.setExtraOptions(undefined,(err: BusinessError): void => {
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
        });
      }
      catch (err){
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
        this.addLog('setExtraOptions fail');
      }
      setTimeout((): void => { tcpServer.close(); }, 300);
    })
  }

  //setExtraOptions_callback_null
  private setExtraOptions_callback_null(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }

      try{
        tcpServer.setExtraOptions(tcpExtraOptions, null);
      }
      catch (err){
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      }
      setTimeout((): void => { tcpServer.close(); }, 3000);
    })
  }

  //setExtraOptions_callback_no
  private setExtraOptions_callback_no(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      try {
        tcpServer.setExtraOptions(tcpExtraOptions)
        this.addLog("setExtraOptions 未传入 callback 参数时, setExtraOptions success");
      }
      catch (err){
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      }
      setTimeout((): void => { tcpServer.close(); }, 3000);
    })
  }

  //setExtraOptions_callback_undefined
  private setExtraOptions_callback_undefined(): void {

    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address:  '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog('listen fail');
        return;
      }

      let tcpExtraOptions: socket.TCPExtraOptions = {
        keepAlive: true,
        OOBInline: true,
        TCPNoDelay: true,
        socketLinger: {
          on: true,
          linger: 10
        } as socket.SocketLinger,
        receiveBufferSize: 8192,
        sendBufferSize: 8192,
        reuseAddress: true,
        socketTimeout: 3000
      }
      try {
        tcpServer.setExtraOptions(tcpExtraOptions, undefined);
      }
      catch (err){
        this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
      }
      setTimeout((): void => { tcpServer.close(); }, 3000);
    })
  }

  private getLocalAdress(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr).then(() => {
      tcpServer.getLocalAddress().then((localAddress: socket.NetAddress) => {
        this.addLog("success Address:" + JSON.stringify(localAddress));
      }).catch((err: BusinessError) => {
        this.addLog("fail Error:" + JSON.stringify(err));
      }).finally(() => {
        tcpServer.close();
      });
    }).catch((err: BusinessError) => {
      this.addLog('listen fail');
    })
  }

  //getLocalAdress 无效的文件描述符
  private getLocalAdress_invalid_fd(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr).then((): void => {
      if (tcpServer) {
        tcpServer.close();
        this.addLog("服务器已关闭，现在在已关闭的socket上操作...");
      } else {
        this.addLog('TCPSocketServer实例不存在');
      }
      setTimeout((): void => {
        tcpServer.getLocalAddress().then((localAddress: socket.NetAddress) => {
          this.addLog("SUCCESS! Address:" + JSON.stringify(localAddress));
        }).catch((err: BusinessError) => {
          this.addLog('✅ 正确捕获错误：socket 预期（2301009），实际：'+ err.code);
        })
      }, 2000);

    }).catch((err: BusinessError) => {
      this.addLog('listen fail');
    }).finally(() => {
      tcpServer.close();
    });
  }

  private getSocketFd(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.listen(listenAddr).then(() => {
      tcpServer.getSocketFd().then((data: number) => {
        this.addLog("getSocketFd成功，Fd：" + data);
        console.info("getSocketFd成功，Fd：" + data);
      }).catch((err: BusinessError) => {
        console.error(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
        this.addLog(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
      }).finally(() => {
        tcpServer.close();
      });
    }).catch((err: BusinessError) => {
      this.addLog('listen fail');
    })
  }

  //listen_callback 2300002 系统内部错误(System internal error.)
  private listen_callback_2300002(): void {


  }

  //SetExtraOptions_callback 2303109 文件编号无效(Bad file number.)
  private SetExtraOptions_callback_2303109(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    // 核心修改1：直接在未listen/未绑定的状态下调用setExtraOptions（XTS用例的核心逻辑，触发2303109）
    // 定义XTS用例中的TCPExtraOptions配置
    let tcpExtraOptions: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: {
        on: true,
        linger: 10
      } as socket.SocketLinger,
      receiveBufferSize: 1000,
      sendBufferSize: 1000,
      reuseAddress: true,
      socketTimeout: 3000
    };

    // 第一步：未listen的初始状态下调用setExtraOptions（高概率触发2303109）
    this.addLog("在未listen的TCPSocketServer上调用setExtraOptions...");
    tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
      if (err) {
        //this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
        if (err.code === 2303109) {
          this.addLog('✅ 正确捕获错误：socket 预期（2303109），实际：'+ err.code);
        }
      } else {
        this.addLog("setExtraOptions执行成功（预期外结果）");
      }
    });

  }

  //SetExtraOptions_promise 2303109 文件编号无效(Bad file number.)
  private SetExtraOptions_promise_2303109(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    // 核心修改1：直接在未listen/未绑定的状态下调用setExtraOptions（XTS用例的核心逻辑，触发2303109）
    // 定义XTS用例中的TCPExtraOptions配置
    let tcpExtraOptions: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: {
        on: true,
        linger: 10
      } as socket.SocketLinger,
      receiveBufferSize: 1000,
      sendBufferSize: 1000,
      reuseAddress: true,
      socketTimeout: 3000
    };

    // 第一步：未listen的初始状态下调用setExtraOptions（高概率触发2303109）
    this.addLog("在未listen的TCPSocketServer上调用setExtraOptions...");
    tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
      console.info('setExtraOptions success');
      this.addLog("setExtraOptions执行成功（预期外结果）");
    }).catch((err: BusinessError): void => {
      console.error('setExtraOptions fail');
      //this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      if (err.code === 2303109) {
        this.addLog('✅ 正确捕获错误：socket 预期（2303109），实际：'+ err.code);
      }
    });
  }


  //listen_callback 2303111 资源暂时不可用，请稍后再试(Resource temporarily unavailable. Try again.)
  private listen_callback_2303111(): void {
    // 核心：使用TCPSocketServer
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    // 选择常用端口（8080易被占用，或直接用80/443等已占用端口，触发更快）
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0', // 监听所有IPv4地址
      port: 8080,
      family: 1 // AF_INET (IPv4，对应family=1)
    };

    this.addLog("=== 开始通过TCPSocketServer构造2303111错误码（资源暂时不可用） ===");
    this.addLog("核心逻辑：同一端口重复监听 + 多实例占用 + 短时间高频调用");

    // 核心逻辑1：多次高频调用listen（短时间内重复请求，制造资源冲突）
    const repeatListen = (times: number) => {
      if (times <= 0) return;

      // 直接调用listen（传入NetAddress，无额外Options，适配鸿蒙所有版本）
      tcpServer.listen(listenAddr, (err: BusinessError) => {
        if (err) {
          this.addLog(`第${5 - times + 1}次listen异常，错误码: ${err.code}, 信息: ${err.message}`);
          // 只关注2303111错误码（删除其他错误码判断）
          if (err.code === 2303111) {
            this.addLog(`成功触发2303111错误码！（资源暂时不可用）`);
          }
        } else {
          this.addLog(`第${5 - times + 1}次listen成功（预期外结果，端口未被占用）`);
          // 若第一次listen成功，立即再次listen（此时端口已被占用，触发2303111）
          // 同时关闭reuseAddress的底层逻辑：先close再立即listen，制造资源未释放
          tcpServer.close();
          // 立即再次listen，利用端口释放的时间差制造资源暂时不可用
          tcpServer.listen(listenAddr, (err2: BusinessError) => {
            if (err2) {
              this.addLog(`关闭后立即listen异常，错误码: ${err2.code}, 信息: ${err2.message}`);
              if (err2.code === 2303111) {
                this.addLog(`端口释放时间差触发2303111错误码！`);
              }
            }
          });
        }
        // 无延迟递归，短时间内高频调用，加剧资源冲突
        repeatListen(times - 1);
      });
    };

    // 执行5次高频listen操作（足够触发资源暂时不可用）
    repeatListen(5);

    // 核心逻辑2：创建第二个TCPSocketServer实例监听同一端口，抢占资源
    let tcpServer2: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    // 第二个实例同样高频listen，加剧资源冲突
    const repeatListen2 = (times: number) => {
      if (times <= 0) return;
      tcpServer2.listen(listenAddr, (err: BusinessError) => {
        if (err) {
          this.addLog(`第二个TCPServer第${3 - times + 1}次listen异常，错误码: ${err.code}, 信息: ${err.message}`);
          if (err.code === 2303111) {
            this.addLog(`第二个TCPServer实例成功触发2303111错误码！`);
          }
        }
        repeatListen2(times - 1);
      });
    };
    repeatListen2(3);

    // 核心逻辑3：使用已被系统占用的端口（终极方案，必触发2303111）
    // 若上述逻辑未触发，可替换listenAddr的port为80/443/3306（如下）
    // let occupiedPortAddr: socket.NetAddress = {
    //   address: '0.0.0.0',
    //   port: 80, // 系统HTTP端口，几乎必被占用
    //   family: 1
    // };
    // tcpServer.listen(occupiedPortAddr, (err: BusinessError) => {
    //   if (err && err.code === 2303111) {
    //     this.addLog(`占用系统端口触发2303111错误码！`);
    //   }
    // });
  }

  private on_connect() {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    const listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    this.tcpServerCon.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog("listen fail");
        this.tcpServerCon = null;
        return;
      }
      console.info("listen success");
      this.addLog("listen success");

      // 定义全局回调（存储到 this.connectCallback，确保 off 时引用一致）
      this.connectCallback = (data: socket.TCPSocketConnection) => {
        console.info(JSON.stringify(data));
        this.addLog(`on_connect: ` + JSON.stringify(data));
      };

      if (this.tcpServerCon) {
        this.tcpServerCon.on('connect', this.connectCallback);
        this.createTCPClientAndConnect();
        setTimeout((): void => { this.cleanConnectResource(); }, 3000);
      }
    });
  }

  private createTCPClientAndConnect(): void {
    this.tcpClient = socket.constructTCPSocketInstance();
    let connectOptions: socket.TCPConnectOptions = {
      address: {
        address: '127.0.0.1',
        port: 8080,
        family: 1
      } as socket.NetAddress,
    };

    // 客户端发起连接
    this.tcpClient.connect(connectOptions, (err: BusinessError): void => {
      if (err) {
        console.error("客户端连接失败：", err);
        this.addLog(`客户端连接失败: ${err.code} - ${err.message}`);
        this.tcpClient = null;
        return;
      }else{
        console.info("客户端连接服务器成功！");
        this.addLog("客户端已成功连接服务器");
      }
    });
  }

  private cleanConnectResource(): void {
    if (this.tcpServerCon) {
      this.tcpServerCon.off('connect');
    }
    this.tcpServerCon?.close();
    // 重置实例
    this.tcpServerCon = null;
    this.connectCallback = null;
  }

  //on_connect_callback_null
  private on_connect_callback_null(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    const listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    this.tcpServerCon.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog("listen fail");
        this.tcpServerCon = null;
        return;
      }
      console.info("listen success");
      this.addLog("listen success");

      // 定义全局回调（存储到 this.connectCallback，确保 off 时引用一致）
      this.connectCallback = null;

      if (this.tcpServerCon) {
        try {
          this.tcpServerCon.on('connect', this.connectCallback);
        }
        catch (err){
          this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
        }
      }
    });
  }

  //on_connect_callback_undefined
  private on_connect_callback_undefined(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    const listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    this.tcpServerCon.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog("listen fail");
        this.tcpServerCon = null;
        return;
      }
      console.info("listen success");
      this.addLog("listen success");

      if (this.tcpServerCon) {
        try {
          this.tcpServerCon.on('connect', undefined);
        }
        catch (err) {
          this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
        }
      }
    });
  }


  private off_connect(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    const listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    this.tcpServerCon.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog("listen fail");
        this.tcpServerCon = null;
        return;
      }
      console.info("listen success");
      this.addLog("listen success");

      this.connectCallback = (data: socket.TCPSocketConnection) => {
        console.info(JSON.stringify(data));
        this.addLog(`on_connect: ` + JSON.stringify(data));
      };

      if (this.tcpServerCon) {
        this.tcpServerCon.on('connect', this.connectCallback);
        this.tcpServerCon.off('connect', this.connectCallback);
        this.createTCPClientAndConnect();
        this.addLog("取消订阅connect事件成功");
        setTimeout((): void => { this.cleanConnectResource(); }, 3000);
      }
    });
  }

  //off_connect_special
  private off_connect_special(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    this.tcpServerCon.listen(this.listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务器启动失败: ${err.message}`);
        this.tcpServerCon = null;
        return;
      }
      this.addLog(`服务器启动成功`);
    });

    let connectCallback1  = () => {
      this.addLog('connectCallback1已触发');
    }
    let connectCallback2  = () => {
      this.addLog('connectCallback2已触发');
    }
    let connectCallback3  = () => {
      this.addLog('connectCallback3已触发');
    }

    this.tcpServerCon.on('connect', connectCallback1);
    this.tcpServerCon.on('connect', connectCallback2);
    this.tcpServerCon.on('connect', connectCallback3);
    this.tcpServerCon.off('connect');
    setTimeout((): void => {
      this.addLog('off已取消所有的订阅事件')
    }, 1000);

    let testClient: socket.TCPSocket = socket.constructTCPSocketInstance();
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8080, family: 1 } as socket.NetAddress,
    };

    testClient.connect(clientOpts, (err: BusinessError) => {
      if (err) {
        this.addLog(`客户端连接失败: ${err.message}`);
        return;
      }
      this.addLog('客户端连接服务器成功');
    });
  }

  //off_connect_type_null
  // private off_connect_type_null() {
  //   if (!this.tcpServerCon) {
  //     this.tcpServerCon = socket.constructTCPSocketServerInstance();
  //   }
  //   this.connectCallback = (client: socket.TCPSocketConnection) => {};
  //
  //   try{
  //     this.tcpServerCon.off(null, (err: BusinessError) => {});
  //   }
  //   catch (err){
  //     this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
  //   }
  // }

  //off_connect_type_undefined
  // private off_connect_type_undefined() {
  //   if (!this.tcpServerCon) {
  //     this.tcpServerCon = socket.constructTCPSocketServerInstance();
  //   }
  //   this.connectCallback = (client: socket.TCPSocketConnection) => {};
  //   if (!this.tcpServerCon || !this.connectCallback) {
  //     this.addLog("服务器未启动或未绑定 connect 事件");
  //     return;
  //   }
  //
  //   try{
  //     this.tcpServerCon.off(undefined, (err: BusinessError) => {});
  //   }
  //   catch (err){
  //     this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
  //   }
  // }

  //off_connect_callback_null
  private off_connect_callback_null(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    this.connectCallback = (client: socket.TCPSocketConnection) => {};
    try{
      this.tcpServerCon.off('connect', null);
    }
    catch (err){
      this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
    }
  }

  //off_connect_callback_no
  private off_connect_callback_no(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    const listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    this.tcpServerCon.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        console.error("listen fail");
        this.addLog("listen fail");
        this.tcpServerCon = null;
        return;
      }
      console.info("listen success");
      this.addLog("listen success");

      this.connectCallback = (data: socket.TCPSocketConnection) => {
        console.info(JSON.stringify(data));
        this.addLog(`on_connect: ` + JSON.stringify(data));
      };

      if (this.tcpServerCon) {
        this.tcpServerCon.on('connect', this.connectCallback);
        this.tcpServerCon.off('connect');
        this.createTCPClientAndConnect();
        this.addLog("取消订阅connect事件成功");
        setTimeout((): void => { this.cleanConnectResource(); }, 3000);
      }
    });
  }

  //off_connect_callback_undefined
  private off_connect_callback_undefined(): void {
    if (!this.tcpServerCon) {
      this.tcpServerCon = socket.constructTCPSocketServerInstance();
    }
    this.connectCallback = (client: socket.TCPSocketConnection) => {};
    try {
      this.tcpServerCon.off('connect', undefined);
    }
    catch (err) {
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
  }

  private close(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }
    tcpServer.on('connect', (connection: socket.TCPSocketConnection) => {
      console.info("connection clientId: " + connection.clientId);
      tcpServer.close();
      connection.close();
    });
    tcpServer.listen(listenAddr).then(() => {
      console.info('listen success');
    }).catch((err: BusinessError) => {
      console.error('listen fail: ' + err.code);
    });
  }
}