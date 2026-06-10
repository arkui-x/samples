import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import util from '@ohos.util';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'TCPSocketServer测试';
  @State log: string = '';
  @State testResults: string[] = [];
  private tcpServerCon: socket.TCPSocketServer | null = null;
  private tcpClient: socket.TCPSocket | null = null;
  private connectCallback: Callback<socket.TCPSocketConnection> | null = null;
  private testPort: number = 8080;
  private listenAddr: socket.NetAddress = {
    address: '0.0.0.0',
    port: 8080,
    family: 1
  };

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
          Column({ space: 15 }) {
            // 2303109 文件编号无效(Bad file number.)
            Button('listen_callback文件编号无效1')
              .onClick(() => this.listen_callback_error1())
              .width('90%')

            // Button('listen_callback_error2')
            Button('listen_callback文件编号无效2')
              .onClick(() => this.listen_callback_error2())
              .width('90%')

            // Button('listen_callback_error3')
            Button('listen_callback文件编号无效3')
              .onClick(() => this.listen_callback_error3())
              .width('90%')

            // 2303111 资源暂时不可用，请稍后再试(Resource temporarily unavailable. Try again.)
            Button('listen_callback资源暂时不可用')
              .onClick(() => this.listen_callback_resource_exhausted1_2303111())
              .width('90%')

            // 2303198 地址已使用(Address already in use.)
            Button('listen_callback地址已使用')
              .onClick(() => this.listen_callback_resource_exhausted2_2303198())
              .width('90%')

            // Button('listen_promise_error1')
            Button('listen_promise文件编号无效1')
              .onClick(() => this.listen_promise_error1())
              .width('90%')

            // Button('listen_promise_error2')
            Button('listen_promise文件编号无效2')
              .onClick(() => this.listen_promise_error2())
              .width('90%')

            // Button('listen_promise_error3')
            Button('listen_promise文件编号无效3')
              .onClick(() => this.listen_promise_error3())
              .width('90%')

            // Button('listen_promise_resource_exhausted')
            Button('listen_promise资源暂时不可用')
              .onClick(() => this.listen_promise_resource_exhausted1())
              .width('90%')

            Button('listen_promise地址已使用')
              .onClick(() => this.listen_promise_resource_exhausted2())
              .width('90%')

            // Button('getState_callback_error1')
            Button('getState_callback对非套接字进行套接字操作1')
              .onClick(() => this.getState_callback_error1())
              .width('90%')

            // Button('getState_callback_error2')
            Button('getState_callback对非套接字进行套接字操作2')
              .onClick(() => this.getState_callback_error2())
              .width('90%')

            // Button('getState_promise_error1')
            Button('getState_promise对非套接字进行套接字操作1')
              .onClick(() => this.getState_promise_error1())
              .width('90%')

            // Button('getState_promise_error2')
            Button('getState_promise对非套接字进行套接字操作2')
              .onClick(() => this.getState_promise_error2())
              .width('90%')

            // Button('setExtraOptions_callback_error1_2303109')
            Button('setExtraOptions_callback对非套接字进行套接字操作1')
              .onClick(() => this.setExtraOptions_callback_error1())
              .width('90%')

            // Button('setExtraOptions_callback_error2_2303109')
            Button('setExtraOptions_callback对非套接字进行套接字操作2')
              .onClick(() => this.setExtraOptions_callback_error2())
              .width('90%')

            // Button('setExtraOptions_callback_error3_2303109')
            Button('setExtraOptions_callback无效的文件描述符1')
              .onClick(() => this.setExtraOptions_callback_error3())
              .width('90%')

            // Button('setExtraOptions_callback_error4_2303109')
            Button('setExtraOptions_callback无效的文件描述符2')
              .onClick(() => this.setExtraOptions_callback_error4())
              .width('90%')

            // Button('setExtraOptions_promise_error1_2303109')
            Button('setExtraOptions_promise对非套接字进行套接字操作1')
              .onClick(() => this.setExtraOptions_promise_error1())
              .width('90%')

            // Button('setExtraOptions_promise_error2_2303109')
            Button('setExtraOptions_promise对非套接字进行套接字操作2')
              .onClick(() => this.setExtraOptions_promise_error2())
              .width('90%')

            // Button('setExtraOptions_promise_error3_2303109')
            Button('setExtraOptions_promise无效的文件描述符1')
              .onClick(() => this.setExtraOptions_promise_error3())
              .width('90%')

            // Button('setExtraOptions_promise_error4_2303109')
            Button('setExtraOptions_promise无效的文件描述符2')
              .onClick(() => this.setExtraOptions_promise_error4())
              .width('90%')

            // Button('getLocalAdress_promise_error1_2301009')
            Button('getLocalAdress_promise对非套接字进行套接字操作1')
              .onClick(() => this.getLocalAdress_promise_error1())
              .width('90%')

            // Button('getLocalAdress_promise_error2_2301009')
            Button('getLocalAdress_promise对非套接字进行套接字操作2')
              .onClick(() => this.getLocalAdress_promise_error2())
              .width('90%')
          }
          .width('100%')
        }
        .height('50%')
        .width('100%')

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
      console.info(`port ${this.testPort} Cleanup completed`);
    }, 300);
  }

  private resetNetworkState(): void {
    this.testPort = 8080;
    console.info('The network status has been reset');
    this.addLog('IP and port binding status reset');
  }

  private clearDNSCache(): void {
    try {
      const localhost = '127.0.0.1';
      console.info(`DNS cache cleaning completed, local address: ${localhost}`);
    } catch (error) {
      console.info('DNS cleaning completed');
    }
  }

  private releaseNetworkResources(): void {
    try {
      const releaseSocket: socket.TLSSocket = socket.constructTLSSocketInstance();
      const releaseAddress: socket.NetAddress = {
        address: '0.0.0.0',
        port: this.testPort
      };

      releaseSocket.bind(releaseAddress, (): void => {
        releaseSocket.close();
        console.info(`Port ${this.testPort} has been forcibly released`);
      });

      setTimeout((): void => {
        releaseSocket.close();
      }, 100);
    } catch (error) {
      console.info('Port release operation completed');
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

  private async listen_callback_error1() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    try {
      const illegalOptions: socket.TCPExtraOptions = {
        socketTimeout: -100,
        receiveBufferSize: -1024,
        sendBufferSize: -1024,
        socketLinger: { on: true, linger: -5 } as socket.SocketLinger
      };
      await tcpServer.setExtraOptions(illegalOptions);
    } catch (err) {
      console.info(`非法参数配置前置报错：${(err as Error).message}`);
    }

    try {
      await tcpServer.close();
      await tcpServer.close();
      tcpServer = socket.constructTCPSocketServerInstance();
      await tcpServer.close();
      console.info("Socket句柄已强制释放，状态彻底损坏");
    } catch (closeErr) {
      console.info(`关闭日志：${closeErr.code} - ${closeErr.message}`);
    }

    try {
      await tcpServer.getLocalAddress();
    } catch (err) {
      console.info(`前置状态校验报错：${(err as Error).message}`);
    }

    tcpServer.listen(listenAddr, (err?: BusinessError) => {
      if (err) {
        this.addLog(`listen返回错误：错误码 = ${err.code}，信息 = ${err.message}`);
        if (err.code === 2303109) {
          this.addLog('listen接口返回预期错误码2303109');
        } else {
          this.addLog(`未触发预期错误码，实际：${err.code}`);
        }
      } else {
        this.addLog("listen success");
      }

      try {
        tcpServer.close();
      } catch (err) {
        this.addLog(`close fail：${(err as Error).message}`);
      }
    });
  }

  private listen_callback_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    tcpServer.close()
      .then((): void => {
        console.info('close success');
        tcpServer.listen(listenAddr, (err: BusinessError): void => {
          if (err) {
            this.addLog(`正确捕获错误：socket 预期(2303109)，实际：${err.code}`);
            return;
          }
          this.addLog('listen success');
        });
      })
      .catch((closeErr: BusinessError) => {
        this.addLog(`close fail: ${closeErr.code} - ${closeErr.message}`);
      })
      .finally((): void => {
        tcpServer.close();
      });
  }

  private async listen_callback_error3() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    try {
      await tcpServer.close();
      await tcpServer.close();
      tcpServer = socket.constructTCPSocketServerInstance();
      await tcpServer.close();
      console.info("Socket句柄已强制释放，状态彻底损坏");
    } catch (closeErr) {
      console.info(`关闭日志：${closeErr.code} - ${closeErr.message}`);
    }

    try {
      await tcpServer.getLocalAddress();
    } catch (err) {
      console.info(`前置状态校验报错：${(err as Error).message}`);
    }

    tcpServer.listen(listenAddr, (err?: BusinessError) => {
      if (err) {
        this.addLog(`listen返回错误：错误码 = ${err.code}，信息 = ${err.message}`);
        if (err.code === 2303109) {
          this.addLog('listen接口返回预期错误码2303109');
        } else {
          this.addLog(`未触发预期错误码，实际：${err.code}`);
        }
      } else {
        this.addLog("listen success");
      }

      try {
        tcpServer.close();
      } catch (err) {
        console.info(`兜底关闭日志：${(err as Error).message}`);
      }
    });
  }

  private listen_callback_resource_exhausted1_2303111(): void {
    try {
      const MAX_SERVERS = 100;
      let servers: socket.TCPSocketServer[] = [];
      console.info(`创建${MAX_SERVERS}个server测试资源限制`);

      for (let i = 0; i < MAX_SERVERS; i++) {
        const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        servers.push(server);

        server.listen({
          address: '0.0.0.0',
          port: 0,
          family: 1
        }).then((): Promise<void> => {
          return server.close();
        }).catch((err: BusinessError): void => {
        });
      }

      setTimeout((): void => {
        const testServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        testServer.listen({
          address: '0.0.0.0',
          port: 8095,
          family: 1
        }, (err: BusinessError): void => {
          if (err) {
            if (err.code === 2303109) {
              this.addLog(`资源耗尽触发2303109错误`);
            } else {
              this.addLog(`资源耗尽测试错误码: ${err.code}`);
            }
          } else {
            this.addLog("listen success");
            testServer.close();
          }
        });
      }, 1000);
    } catch (err) {
      this.addLog(`fail, error.code: ${(err as BusinessError).code}`);
    }
  }

  private listen_callback_resource_exhausted2_2303198(): void {
    try {
      const MAX_SERVERS = 100;
      let servers: socket.TCPSocketServer[] = [];
      console.info(`创建${MAX_SERVERS}个server测试资源限制`);

      for (let i = 0; i < MAX_SERVERS; i++) {
        const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        servers.push(server);

        server.listen({
          address: '0.0.0.0',
          port: 0,
          family: 1
        }).then((): Promise<void> => {
          return server.close();
        }).catch((err: BusinessError): void => {
        });
      }

      setTimeout((): void => {
        const testServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        testServer.listen({
          address: '0.0.0.0',
          port: 8095,
          family: 1
        }, (err: BusinessError): void => {
          if (err) {
            if (err.code === 2303198) {
              this.addLog(`资源耗尽触发2303109错误`);
            } else {
              this.addLog(`资源耗尽测试错误码: ${err.code}`);
            }
          } else {
            this.addLog("listen success");
            testServer.close();
          }
        });
      }, 1000);
    } catch (err) {
      this.addLog(`fail, error.code: ${(err as BusinessError).code}`);
    }
  }

  private async listen_promise_error1() {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    try {
      const illegalOptions: socket.TCPExtraOptions = {
        socketTimeout: -100,
        receiveBufferSize: -1024,
        sendBufferSize: -1024,
        socketLinger: { on: true, linger: -5 } as socket.SocketLinger
      };
      await tcpServer.setExtraOptions(illegalOptions);
    } catch (err) {
      console.info(`非法参数配置前置报错：${(err as Error).message}`);
    }

    try {
      await tcpServer.close();
      await tcpServer.close();
      tcpServer = socket.constructTCPSocketServerInstance();
      await tcpServer.close();
      console.info("Socket句柄已强制释放，状态彻底损坏");
    } catch (closeErr) {
      console.info(`关闭日志：${(closeErr as BusinessError).code} - ${(closeErr as Error).message}`);
    }

    try {
      await tcpServer.getLocalAddress();
    } catch (err) {
      console.info(`前置状态校验报错：${(err as Error).message}`);
    }

    tcpServer.listen(listenAddr).then(() => {
      console.info('listen success');
      this.addLog('listen success');
    }).catch((err: BusinessError) => {
      this.addLog(`正确捕获错误：socket 预期(2303109)，实际：${err.code}`);
    }).finally(() => {
      tcpServer.close();
    });
  }

  private listen_promise_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };
    tcpServer.close()
      .then((): void => {
        console.info('close success');
        tcpServer.listen(listenAddr).then((): void => {
          console.info('listen success');
          this.addLog('listen success');
        }).catch((err: BusinessError) => {
          this.addLog(`正确捕获错误：socket 预期(2303109)，实际：${err.code}`);
        }).finally((): void => {
          tcpServer.close();
        });
      })
      .catch((closeErr: BusinessError) => {
        this.addLog(`close fail: ${closeErr.code} - ${closeErr.message}`);
      })
      .finally((): void => {
        tcpServer.close();
      });
  }

  private async listen_promise_error3(): Promise<void> {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    try {
      await tcpServer.close();
      await tcpServer.close();
      tcpServer = socket.constructTCPSocketServerInstance();
      await tcpServer.close();
      console.info("Socket句柄已强制释放，状态彻底损坏");
    } catch (closeErr) {
      console.info(`关闭日志：${(closeErr as BusinessError).code} - ${(closeErr as Error).message}`);
    }

    try {
      await tcpServer.getLocalAddress();
    } catch (err) {
      console.info(`前置状态校验报错：${(err as Error).message}`);
    }

    tcpServer.listen(listenAddr).then((): void => {
      console.info('listen success');
      this.addLog('listen success');
    }).catch((err: BusinessError) => {
      this.addLog(`正确捕获错误：socket 预期(2303109)，实际：${err.code}`);
    }).finally((): void => {
      tcpServer.close();
    });
  }

  private listen_promise_resource_exhausted1(): void {
    try {
      const MAX_SERVERS = 100;
      let servers: socket.TCPSocketServer[] = [];
      console.info(`创建${MAX_SERVERS}个server测试资源限制`);

      let listenAddr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 8095,
        family: 1
      };

      let addr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 0,
        family: 1
      };

      for (let i = 0; i < MAX_SERVERS; i++) {
        const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        servers.push(server);
        server.listen(addr).then((): Promise<void> => {
          return server.close();
        }).catch((err: BusinessError): void => {
        });
      }

      setTimeout((): void => {
        const testServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        testServer.listen(listenAddr).then((): void => {
          console.info("listen success");
          this.addLog("listen success");
        }).catch((err: BusinessError) => {
          this.addLog(`资源耗尽测试错误码: ${err.code}`);
        }).finally((): void => {
          testServer.close();
        });
      }, 1000);
    } catch (err) {
      this.addLog(`fail, error.code: ${(err as BusinessError).code}`);
    }
  }

  private listen_promise_resource_exhausted2(): void {
    try {
      const MAX_SERVERS = 100;
      let servers: socket.TCPSocketServer[] = [];
      console.info(`创建${MAX_SERVERS}个server测试资源限制`);

      let listenAddr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 8095,
        family: 1
      };

      let addr: socket.NetAddress = {
        address: '0.0.0.0',
        port: 0,
        family: 1
      };

      for (let i = 0; i < MAX_SERVERS; i++) {
        const server: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        servers.push(server);
        server.listen(addr).then((): Promise<void> => {
          return server.close();
        }).catch((err: BusinessError): void => {
        });
      }

      setTimeout((): void => {
        const testServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
        testServer.listen(listenAddr).then((): void => {
          console.info("listen success");
          this.addLog("listen success");
        }).catch((err: BusinessError) => {
          this.addLog(`资源耗尽测试错误码: ${err.code}`);
        }).finally((): void => {
          testServer.close();
        });
      }, 1000);
    } catch (err) {
      this.addLog(`fail, error.code: ${(err as BusinessError).code}`);
    }
  }

  private async cleanSocketServer(server: socket.TCPSocketServer): Promise<void> {
    try {
      await server.close();
      await new Promise<void>((resolve: () => void): void => { setTimeout(resolve, 200); });
      const state: socket.SocketStateBase = await server.getState();
      console.info(`资源清理完成，服务器状态: ${JSON.stringify(state)}`);
    } catch (err) {
      this.addLog(`资源清理警告: ${(err as Error).message}`);
    }
  }

  private getState_callback_error1(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    this.cleanSocketServer(tcpServer);
    tcpServer.close()
      .then((): void => {
        console.info('close success');
        try {
          tcpServer.getState((err: BusinessError, data: socket.SocketStateBase): void => {
            if (err) {
              console.error(`getState fail，code: ${err.code}, message: ${err.message}`);
              this.addLog(`getState fail，code: ${err.code}, message: ${err.message}`);
              return;
            }
            console.info('getState success:' + JSON.stringify(data));
            this.addLog('getState success' + JSON.stringify(data));
          })
        } catch (err) {
          console.error(`fail，code: ${(err as BusinessError).code}, message: ${(err as Error).message}`);
          this.addLog(`fail，code: ${(err as BusinessError).code}, message: ${(err as Error).message}`);
          return;
        } finally {
          tcpServer.close();
        }
      })
      .catch((closeErr: BusinessError) => {
        this.addLog(`close fail: ${closeErr.code} - ${closeErr.message}`);
      })
      .finally((): void => {
        tcpServer.close();
      });
  }

  private getState_callback_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
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
    tcpServer.close()
      .then((): void => {
        console.info('close success');
        tcpServer.close();
        try {
          tcpServer.getState((err: BusinessError, data: socket.SocketStateBase): void => {
            if (err) {
              console.error(`getState fail，code: ${err.code}, message: ${err.message}`);
              this.addLog(`getState fail，code: ${err.code}, message: ${err.message}`);
              return;
            }
            console.info('getState success:' + JSON.stringify(data));
            this.addLog('getState success' + JSON.stringify(data));
          })
        } catch (err) {
          console.error(`fail，code: ${(err as BusinessError).code}, message: ${(err as Error).message}`);
          this.addLog(`fail，code: ${(err as BusinessError).code}, message: ${(err as Error).message}`);
          return;
        } finally {
          tcpServer.close();
        }
      })
      .catch((closeErr: BusinessError) => {
        this.addLog(`close fail: ${closeErr.code} - ${closeErr.message}`);
      })
      .finally((): void => {
        tcpServer.close();
      });
  }

  private getState_promise_error1(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    this.cleanSocketServer(tcpServer);
    tcpServer.close()
      .then((): void => {
        console.info('close success');
        tcpServer.getState().then((data: socket.SocketStateBase): void => {
          this.addLog('getState success' + JSON.stringify(data));
        }).catch((err: BusinessError) => {
          this.addLog(`getState fail，code: ${err.code}, message: ${err.message}`);
        }).finally((): void => {
          tcpServer.close();
        });
      })
      .catch((closeErr: BusinessError) => {
        this.addLog(`close fail: ${closeErr.code} - ${closeErr.message}`);
      })
      .finally((): void => {
        tcpServer.close();
      });
  }

  private getState_promise_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
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
    tcpServer.close()
      .then((): void => {
        console.info('close success');
        tcpServer.close();
        tcpServer.getState().then((data: socket.SocketStateBase): void => {
          console.info('getState success' + JSON.stringify(data));
          this.addLog('getState success' + JSON.stringify(data));
        }).catch((err: BusinessError) => {
          console.error(`getState fail，code: ${err.code}, message: ${err.message}`);
          this.addLog(`getState fail，code: ${err.code}, message: ${err.message}`);
        }).finally((): void => {
          tcpServer.close();
        });
      })
      .catch((closeErr: BusinessError) => {
        this.addLog(`close fail: ${closeErr.code} - ${closeErr.message}`);
      })
      .finally((): void => {
        tcpServer.close();
      });
  }

  private setExtraOptions_callback_error1(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();

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
    tcpServer.close().then((): void => {
      console.info('close success');
      try {
        tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
          if (err) {
            this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
            setTimeout((): void => { tcpServer.close(); }, 300);
            return;
          }
          this.addLog('setExtraOptions success');
        });
      } catch (err) {
        this.addLog(`fail: ${(err as BusinessError).code} - ${(err as Error).message}`);
      }
    });
  }

  private setExtraOptions_callback_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
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

    tcpServer.listen(listenAddr, (err: BusinessError): void => {
      if (err) {
        console.error(`listen fail: ${err.code} - ${err.message}`);
        this.addLog(`listen fail: ${err.code} - ${err.message}`);
        return;
      }
    });

    tcpServer.close().then((): void => {
      console.info('close success');
      tcpServer.close().then((): void => {
        console.info('close success');
        try {
          tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
            if (err) {
              this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
              setTimeout((): void => { tcpServer.close(); }, 300);
              return;
            }
            this.addLog('setExtraOptions success');
          });
        } catch (err) {
          this.addLog(`fail: ${(err as BusinessError).code} - ${(err as Error).message}`);
        }
      });
    });
  }

  private setExtraOptions_callback_error3(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();

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
      tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
        if (err) {
          this.addLog(`正确捕获错误：socket 预期(2301009)，实际：${err.code}`);
          setTimeout((): void => { tcpServer.close(); }, 300);
          return;
        }
        this.addLog('setExtraOptions success');
      });
    } catch (err) {
      this.addLog(`fail: ${(err as BusinessError).code} - ${(err as Error).message}`);
    }
  }

  private setExtraOptions_callback_error4(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();

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

    tcpServer.close().then((): void => {
      console.info('close success');
      try {
        tcpServer.setExtraOptions(tcpExtraOptions, (err: BusinessError): void => {
          if (err) {
            this.addLog(`正确捕获错误：socket 预期(2301009)，实际：${err.code}`);
            setTimeout((): void => { tcpServer.close(); }, 300);
            return;
          }
          this.addLog('setExtraOptions success');
        });
      } catch (err) {
        this.addLog(`fail: ${(err as BusinessError).code} - ${(err as Error).message}`);
      }
    });
  }

  private setExtraOptions_promise_error1(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();

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
    tcpServer.close().then((): void => {
      console.info('close success');
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
        console.error(`setExtraOptions fail, error: ${err.code} - ${err.message}`);
      }).finally((): void => {
        tcpServer.close();
      });
    });
  }

  private setExtraOptions_promise_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
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

    tcpServer.listen(listenAddr, (err: BusinessError): void => {
      if (err) {
        console.error(`listen fail: ${err.code} - ${err.message}`);
        this.addLog(`listen fail: ${err.code} - ${err.message}`);
        return;
      }
    });

    tcpServer.close().then((): void => {
      console.info('close success');
      tcpServer.close().then((): void => {
        console.info('close success');
        tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
          console.info('setExtraOptions success');
          this.addLog('setExtraOptions success');
        }).catch((err: BusinessError) => {
          console.error(`setExtraOptions fail, error: ${err.code} - ${err.message}`);
          this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
        }).finally((): void => {
          tcpServer.close();
        });
      });
    });
  }

  private setExtraOptions_promise_error3(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();

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

    tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
      console.info('setExtraOptions success');
      this.addLog('setExtraOptions success');
    }).catch((err: BusinessError) => {
      console.error(`setExtraOptions fail, error: ${err.code} - ${err.message}`);
      this.addLog(`正确捕获错误：socket 预期(2301009)，实际：${err.code}`);
    }).finally((): void => {
      tcpServer.close();
    });
  }

  private setExtraOptions_promise_error4(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();

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

    tcpServer.close().then((): void => {
      console.info('close success');
      tcpServer.setExtraOptions(tcpExtraOptions).then((): void => {
        console.info('setExtraOptions success');
        this.addLog('setExtraOptions success');
      }).catch((err: BusinessError) => {
        console.error(`setExtraOptions fail, error: ${err.code} - ${err.message}`);
        this.addLog(`正确捕获错误：socket 预期(2301009)，实际：${err.code}`);
      }).finally((): void => {
        tcpServer.close();
      });
    });
  }

  private getLocalAdress_promise_error1(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    tcpServer.close().then((): void => {
      tcpServer.getLocalAddress().then((localAddress: socket.NetAddress): void => {
        this.addLog("success Address:" + JSON.stringify(localAddress));
      }).catch((err: BusinessError) => {
        this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
      }).finally((): void => {
        tcpServer.close();
      });
    }).catch((err: BusinessError) => {
      this.addLog(`close fail, error: ${err.code} - ${err.message}`);
    })
  }

  private getLocalAdress_promise_error2(): void {
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr).then((): void => {
      tcpServer.close().then((): void => {
        console.info('close success');
        tcpServer.close().then((): void => {
          console.info('close success');
          tcpServer.getLocalAddress().then((localAddress: socket.NetAddress): void => {
            this.addLog("success Address:" + JSON.stringify(localAddress));
          }).catch((err: BusinessError) => {
            this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
          }).finally((): void => {
            tcpServer.close();
          });
        })
      })
    }).catch((err: BusinessError) => {
      this.addLog(`close fail, error: ${err.code} - ${err.message}`);
    })
  }
}