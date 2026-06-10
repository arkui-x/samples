import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
@Entry
@Component
struct testOnErr {
  @State testResults: string[] = [];
  @State log: string = '';
  private tcpServer: socket.TCPSocketServer | null = null;
  private tcpSocket: socket.TCPSocket | null = null;
  private tlsSocket: socket.TLSSocket | null = null;
  private tcpConnection: socket.TCPSocketConnection | null = null;
  clientConnection?: socket.TCPSocketConnection;
  aboutToAppear(): void {
  }

  private addLog(content: string) {
    this.log += `${content}\n`;
    this.log = this.log;
  }

  clearTestLog(): void {
    this.log = "";
  }
  aboutToDisappear(): void {
    this.cleanupResources();
  }

  private async cleanupResources(): Promise<void> {
    this.addLog('开始清理Socket资源...');
    if (this.tlsSocket) {
      try {
        await this.tlsSocket.close();
        this.addLog('TLSSocket 已关闭');
        console.info('TLSSocket closed successfully');
      } catch (err) {
        this.addLog(`关闭 TLSSocket 失败: 错误码 ${err.code}, 信息 ${err.message}`);
        console.error('Failed to close TLSSocket:', err);
      } finally {
        this.tlsSocket = null;
      }
    }

    if (this.tcpConnection) {
      try {
        await this.tcpConnection.close();
        this.addLog('TCPSocket 客户端已关闭');
        console.info('TCPSocket client closed successfully');
      } catch (err) {
        this.addLog(`关闭 TCPSocket 客户端失败: 错误码 ${err.code}, 信息 ${err.message}`);
        console.error('Failed to close TCPSocket client:', err);
      } finally {
        this.tcpConnection = null;
      }
    }

    if (this.tcpServer) {
      try {
        await this.tcpServer.close();
        this.addLog('TCPSocket 服务端已关闭');
        console.info('TCPSocket server closed successfully');
      } catch (err) {
        this.addLog(`关闭 TCPSocket 服务端失败: 错误码 ${err.code}, 信息 ${err.message}`);
        console.error('Failed to close TCPSocket server:', err);
      } finally {
        this.tcpServer = null;
      }
    }
    this.addLog('所有Socket资源清理完成');
  }

  // constructTLSSocketInstance正确场景
  async getConstructTLSSocketInstance() {
    this.clearTestLog();
    try{
      this.tcpServer = socket.constructTCPSocketServerInstance();
      const listenAddr: socket.NetAddress = {
        address: "0.0.0.0",
        port: 8080,
        family: 1
      }

      this.tcpServer.listen(listenAddr, (err: BusinessError) => {
        this.tcpSocket = socket.constructTCPSocketInstance();
        let netAddress: socket.NetAddress = {
          address: "127.0.0.1",
          port: 8080
        }
        let options: socket.TCPConnectOptions = {
          address: netAddress,
          timeout: 6000
        }
        this.tcpSocket.connect(options, (err: BusinessError) => {
          if (err) {
            console.error('connect fail');
            return;
          }
          console.info('connect success!');
        })
        if (this.tcpServer) {
          this.tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
            try {
              this.tlsSocket = socket.constructTLSSocketInstance(this.tcpSocket);
              const isTLSSocket = this.tlsSocket &&
                typeof this.tlsSocket.connect === 'function' &&
                typeof this.tlsSocket.getSocketFd === 'function';
              if (isTLSSocket) {
                this.addLog('TLSSocket对象创建成功');
              }
              this.clientConnection = client;
            } catch (error) {
              this.addLog(`创建失败，错误码: ${error.code}, 信息: ${error.message}`);
            }
          })
        }
        setTimeout(()=>this.tlsSocket?.close()
          .then(() => {
            console.info('tlsSocket closed successfully in cleanup');
            this.tlsSocket = null;
          })
          .catch((err: BusinessError) => {
            console.error('Failed to close tlsSocket:', err);
          }),3000);
        setTimeout(()=>this.tcpSocket?.close()
          .then(() => {
            console.info('tcpSocket closed successfully in cleanup');
            this.tcpSocket = null;
          })
          .catch((err: BusinessError) => {
            console.error('Failed to close tcpSocket:', err);
          }),3000);
        setTimeout(()=>this.tcpServer?.close()
          .then(() => {
            console.info('tcpServer closed successfully in cleanup');
            this.tcpServer = null;
          })
          .catch((err: BusinessError) => {
            console.error('Failed to close tcpServer:', err);
          }),3000);
      })
    } catch (error) {
      this.addLog(`创建失败，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // 测试场景1：tcpSocket为null
  getConstructTLSSocketInstanceNull(){
    this.clearTestLog();
    try {
      let tls: socket.TLSSocket = socket.constructTLSSocketInstance(null);
      console.info('TLS Socket 对象:', tls);
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }finally {
      this.tcpSocket?.close();
      this.tcpSocket = null;
      this.tlsSocket?.close();
      this.tlsSocket = null;
      this.tcpServer?.close();
      this.tcpServer = null;
    }
    // setTimeout(()=>this.tlsSocket?.close()
    //   .then(() => {
    //     console.info('tcpServer closed successfully in cleanup');
    //   })
    //   .catch((err: BusinessError) => {
    //     console.error('Failed to close tcpServer:', err);
    //   }),3000);
  }

  // 测试场景2：tcpSocket为undefined
  getConstructTLSSocketInstanceUndefined(){
    this.clearTestLog();
    try {
      let tls: socket.TLSSocket = socket.constructTLSSocketInstance(undefined);
      console.info('TLS Socket 对象:', tls);
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }finally {
      this.tlsSocket?.close();
      this.tlsSocket = null;
    }
    // setTimeout(()=>this.tlsSocket?.close()
    //   .then(() => {
    //     console.info('tcpServer closed successfully in cleanup');
    //   })
    //   .catch((err: BusinessError) => {
    //     console.error('Failed to close tcpServer:', err);
    //   }),3000);
  }

  // 测试场景4：套接字错误
  getConstructTLSSocketInstanceInvalidFD(){
    this.clearTestLog();
    try {
      let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
      console.info('TCP Socket创建成功，但未建立连接');
      let tls: socket.TLSSocket = socket.constructTLSSocketInstance(tcp);
      console.info('TLS Socket 对象:', tls);
    } catch (error) {
      if (error.code == 2303601 && error.message.includes('Invalid socket FD')) {
        this.addLog('✅ 正确捕获错误：socket 预期（2303601），实际：'+ error.code);
      } else {
        this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
      }
    }finally {
      this.tcpSocket?.close();
      this.tcpSocket = null;
      this.tlsSocket?.close();
      this.tlsSocket = null;
    }
    // setTimeout(()=>this.tcpSocket?.close()
    //   .then(() => {
    //     console.info('tcpServer closed successfully in cleanup');
    //   })
    //   .catch((err: BusinessError) => {
    //     console.error('Failed to close tcpServer:', err);
    //   }),3000);
    // setTimeout(()=>this.tlsSocket?.close()
    //   .then(() => {
    //     console.info('tlsSocket closed successfully in cleanup');
    //   })
    //   .catch((err: BusinessError) => {
    //     console.error('Failed to close tlsSocket:', err);
    //   }),3000);
  }

  // 测试场景5: 套接字未连接
  getConstructTLSSocketInstanceUnconnected(): void {
    this.clearTestLog();
    try {
      let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
      console.info('TCP Socket创建成功');
      const bindAddr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 0
      };
      tcp.bind(bindAddr, (err: BusinessError) => {
        if (err) {
          console.info(`TCP绑定失败（无法获取有效FD）：错误码: ${err.code}, 信息: ${err.message}`);
          return;
        }
        console.info('TCP绑定本地地址成功（FD已有效，未连接远端）');
        try {
          let tls: socket.TLSSocket = socket.constructTLSSocketInstance(tcp);
          console.info('测试失败：未抛出2303602错误（套接字未连接）');
        } catch (error) {
          if (error) {
            this.addLog('✅ 正确捕获错误：socket 预期（2303602），实际：'+ error.code);
            console.info(`异常，错误码: ${error.code}, 信息: ${error.message}`);
          } else {
            this.addLog(`测试失败：预期错误码2303602，实际：错误码: ${error.code}, 信息: ${error.message}`);
          }
        }
      });
    } catch (error) {
      this.addLog(`意外异常：错误码: ${error.code}, 信息: ${error.message}`);
    }finally {
      this.tcpSocket?.close();
      this.tcpSocket = null;
      this.tlsSocket?.close();
      this.tlsSocket = null;
      this.tcpServer?.close();
      this.tcpServer = null;
    }
    // setTimeout(()=>this.tcpSocket?.close()
    //   .then(() => {
    //     console.info('tcpServer closed successfully in cleanup');
    //   })
    //   .catch((err: BusinessError) => {
    //     console.error('Failed to close tcpServer:', err);
    //   }),3000);
    // setTimeout(()=>this.tlsSocket?.close()
    //   .then(() => {
    //     console.info('tlsSocket closed successfully in cleanup');
    //   })
    //   .catch((err: BusinessError) => {
    //     console.error('Failed to close tlsSocket:', err);
    //   }),3000);
  }

  // constructTCPSocketServerInstance正确场景
  getConstructTCPSocketServerInstance(){
    this.clearTestLog();
    try {
      let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
      const isTCPServer =
        tcpServer !== null &&
          tcpServer !== undefined &&
          typeof tcpServer.listen === 'function' &&    // 监听方法
          typeof tcpServer.close === 'function' &&     // 关闭方法
          typeof tcpServer.on === 'function' &&        // 事件监听
          typeof tcpServer.getState === 'function' &&  // 获取状态
          typeof tcpServer.off === 'function';         // 移除监听

      if (isTCPServer) {
        console.info('对象类型验证通过');
        this.addLog('成功创建TCPSocketServer:' + tcpServer);
      }else{
        this.addLog('创建TCPSocketServer失败:' + tcpServer);
      }
    } catch (e) {
      console.error('创建失败:', e.message);
    }finally {
      this.tcpSocket?.close();
      this.tcpSocket = null;
      this.tlsSocket?.close();
      this.tlsSocket = null;
      this.tcpServer?.close();
      this.tcpServer = null;
    }
  }

  // constructTLSSocketServerInstance正确场景
  getConstructTLSSocketServerInstance() {
    this.clearTestLog();
    try {
      let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
      const isTLSServer =
        tlsServer !== null &&
          tlsServer !== undefined &&
          typeof tlsServer.listen === 'function' &&      // 监听方法
          typeof tlsServer.close === 'function' &&       // 关闭方法
          typeof tlsServer.on === 'function' &&          // 事件监听
          typeof tlsServer.getState === 'function' &&    // 获取状态
          typeof tlsServer.off === 'function' &&         // 移除监听
          typeof tlsServer.getLocalAddress === 'function'; // 获取地址
      if (isTLSServer) {
        this.addLog('TLSSocketServer 创建成功' + tlsServer);
      }else{
        this.addLog('TLSSocketServer 创建失败' + tlsServer);
      }
    } catch (err) {
      console.error('创建失败:', err.message);
    }finally {
      this.tcpSocket?.close();
      this.tcpSocket = null;
      this.tlsSocket?.close();
      this.tlsSocket = null;
      this.tcpServer?.close();
      this.tcpServer = null;
    }
  }

  async clean() {
    this.clearTestLog();
    await this.cleanupResources();
  }

  build() {
    Column({ space: 20 }) {
      // 标题和当前状态
      Text('Socket测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });
      Button('constructTLSSocketInstance-有效tcpSocket')
        .onClick(() => this.getConstructTLSSocketInstance())
        .width('90%')
        .height(40);
      Button('constructTLSSocketInstance-tcpSocket为null')
        .onClick(() => this.getConstructTLSSocketInstanceNull())
        .width('90%')
        .height(40);
      Button('constructTLSSocketInstance-tcpSocket为undefined')
        .onClick(() => this.getConstructTLSSocketInstanceUndefined())
        .width('90%')
        .height(40);
      Button('constructTLSSocketInstance-套接字错误')
        .onClick(() => this.getConstructTLSSocketInstanceInvalidFD())
        .width('90%')
        .height(40);
      Button('constructTLSSocketInstance-套接字未连接')
        .onClick(() => this.getConstructTLSSocketInstanceUnconnected())
        .width('90%')
        .height(40);
      Button('constructTCPSocketServerInstance')
        .onClick(() => this.getConstructTCPSocketServerInstance())
        .width('90%')
        .height(40);
      Button('constructTLSSocketServerInstance')
        .onClick(() => this.getConstructTLSSocketServerInstance())
        .width('90%')
        .height(40);
      Button('清除环境')
        .onClick(() => this.clean())
        .backgroundColor('#FF4D4F')
        .fontColor('#FFFFFF')
        .margin(5)
        .width('90%');
      Button('返回主界面')
        .onClick(() => {
          router.back();
        })

      // 测试结果列表
      Scroll() {
        Text(this.log)
          .fontSize(12)
          .width('100%')
          .padding(10)
          .backgroundColor('#f8f8f8')
          .borderRadius(3)
      }

    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f0f0f0')
  }

}
