import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';

interface ErrorExpectation {
  code: number;
  msg: string;
}

@Entry
@Component
struct TLSSocketServerSetExtraOptionsTest {
  @State private testResults: string[] = [];
  @State private callbackServer: socket.TLSSocketServer | null = null;
  @State private promiseServer: socket.TLSSocketServer | null = null;


  aboutToAppear(): void {
  }


  aboutToDisappear(): void {
    this.closeServer(this.callbackServer, 'Callback 方式');
    this.closeServer(this.promiseServer, 'Promise 方式');
  }

  // 通用服务器关闭方法（复用逻辑）
  private closeServer(server: socket.TLSSocketServer | null, type: string): void {
    if (server) {
      server.close()
        .then(() => {
        })
        .catch((err: BusinessError) => {
          this.addTestResult(` ${type} 服务器关闭失败: [${err.code}] ${err.message}`);
        });
    }
  }

  // TLS 安全配置（抽离常量，避免重复代码）
  private getTlsSecureOptions(): socket.TLSSecureOptions {
    return {
      key: `-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAnoncKS+sTY/GjMRQ86LG4/3PbGIxOLUDZFMttzK73wK+hMj6
op/KVJkVl1h3d/vaNReZfPm0PQDdWjXmMw+t6MYgtDmk2WZLvmqfUOizYFpaK9+0
2PMbAcbxwC3g6yrQ8duX2u5gHSm4FmszEf/RDID0/sLFI3kW9s9JhKqwgQUuVsIv
gfDY+wlWY0hRSm2A+XSro8cf8BjdYBcnuTM5RsoMFhAc685nqFffCpktH3iAmVfK
KDd6Sz6+Fko/vdbPDsD1Hf7A0aoO51ZwGUSkjGEhKzJxeIoVNIvBnJZ1eD/lEHSy
Ce6Yot8L7/UCA35j17vm6KzIC5OLiCSB4w/cXwIDAQABAoIBABkOhONli3/+t0zM
QlcfZPvnw37Hziu+QDj9BH6t4A+RKXdnJGXLh3jzcPwomUk3XveBMVsVRC1YE6QM
XMO5OK1Pkx+o9Kr/hf0kcOWiwab64MGKa9TWJ3CSdub+2UuRytBO+qM5hatWSqgQ
bVPs8KdfQll5gxrmKoD7pgz3xUm+vi0tkSE38o0UYEaW1AE8f+dasl/3gBYCgcup
ebKWEGd5s9ijd8Fx4EhY87qV29ijKz28z0L65Qw/C4+ywcOEHEICDvxjxkiz665d
vIbyQk6PIxGTh2jiqs0PU5b3yevo5SR6Rp92wTydGnkscT6CK23Vbz9jp7JBXqre
a+XnBnECgYEAzz3m1h6J4/8Zp0BU79rO+M2MAVMXisASH2wrPR2jjYeEeBU1FJAg
OBlfpPZoByW8pWrkAR8HKKtLaq6Lm2vwGpMYzdYg7lwGXI2h9oueCl6U4fGT7z/Z
hsQvApka3MqAZnIcF1S1YS4KfugzPhlGPbD3m2ezXXzzHVMrOhGk3eMCgYEAw9aT
t4ilZKvisyp8fF+9WSq1Kl93+OabiERpiO6C5LPNIg7P2gTwbeJ5+tHEigKn1wHE
FcHOsXEv4f5Z6oEcPmQSG439SujbS9/GTA98KPaMZGEMw3WWBSDGtXdc7XWTLdC6
5OjLdr4tM8CN87DLs0ZuKRRzx3Bl+yCINtr8EFUCgYAPMCcxvA05A2Ia6tEOvwd6
Hn5LPo60IX1yhhfpI7nvzmW78znvptxloB5tVY2sMGzR5rKNDnwU0/D0AZTDsDZp
jCw+MZo6Pc5NjCe5jOPpOKNKp8zCtPg5MzmKxDO+yKx+VZCPeSrN03T7dgMDYxDN
xqFu5zuy90xN8uFxIQfnJwKBgQCqbfD7xlV5eQS/O3g+nOsh0EL9bzvvRnGQc0kM
u9T5x2f7/bvxVl8OogvZtfg+yvTZ7lWBQbrpPUGYgUwrAtVbjqcbh8QpDuDZ9RKT
Wt6In5eqO7Np3skCCXYkso4SsUG2m3IqiFWZLwQTh72BmBiOGfsAkSX5KN33YGZq
psS6SQKBgAG6c+xTACeh8p7gNFnc6ggqXutVkfvLhBjtpkcvG7rOpKuy5Q+efEoB
aUr8muQ7IKQ0XEg57GKy/E3ySFeOhMyhw4/dF1Scx2nm8/XzuDr7onUY4/uzAUiJ
bNe8gZRkSz8wvWyV04HOCcfTwz9cAfZ/n/k6X0OwpvYRHh9HtMql
-----END RSA PRIVATE KEY-----`,
      cert: `-----BEGIN CERTIFICATE-----
MIICrzCCAZcCFAm/T+dPts7MtyE0zTcLwQ9dejlAMA0GCSqGSIb3DQEBCwUAMBQx
EjAQBgNVBAMMCWxvY2FsaG9zdDAeFw0yNTEwMzEwOTQyNTFaFw0yNjEwMzEwOTQy
NTFaMBQxEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAJ6J3CkvrE2PxozEUPOixuP9z2xiMTi1A2RTLbcyu98CvoTI+qKf
ylSZFZdYd3f72jUXmXz5tD0A3Vo15jMPrejGILQ5pNlmS75qn1Dos2BaWivftNjz
GwHG8cAt4Osq0PHbl9ruYB0puBZrMxH/0QyA9P7CxSN5FvbPSYSqsIEFLlbCL4Hw
2PsJVmNIUUptgPl0q6PHH/AY3WAXJ7kzOUbKDBYQHOvOZ6hX3wqZLR94gJlXyig3
eks+vhZKP73Wzw7A9R3+wNGqDudWcBlEpIxhISsycXiKFTSLwZyWdXg/5RB0sgnu
mKLfC+/1AgN+Y9e75uisyAuTi4gkgeMP3F8CAwEAATANBgkqhkiG9w0BAQsFAAOC
AQEAB42BI8v2TkKObx2pdceI4K3h7c69ahUvyYq2HKSzP39cvtDw2BM0NDsKzs2g
2uKn1w9VreIHg3e811SCteIq18yr3Zrj5eCHX6601zJlsAtbpku4vdciyEv+o9uD
iYTtD/9Z6u/yDiwpJgaU5HrDRC7O/0TipQfuQwxxN+An11UOd81P+bvj+DKoDs3F
E6E2M4vQY33S78RF7P4EZVlrcW3JhcW23l+lAbqcSfL1/X+QYQfGL0Lp3BLOCtBL
y/Hp0zgI2Zq1+paupseHHBjTiORJzEUIQvQyI357pTA+lT5b0Bw7VsBpxYH7vpk9
mSNTffduRuD5KUKprT8t3Nw4FQ==
-----END CERTIFICATE-----`,
      ca: [`-----BEGIN CERTIFICATE-----
MIICrzCCAZcCFAm/T+dPts7MtyE0zTcLwQ9dejlAMA0GCSqGSIb3DQEBCwUAMBQx
EjAQBgNVBAMMCWxvY2FsaG9zdDAeFw0yNTEwMzEwOTQyNTFaFw0yNjEwMzEwOTQy
NTFaMBQxEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAJ6J3CkvrE2PxozEUPOixuP9z2xiMTi1A2RTLbcyu98CvoTI+qKf
ylSZFZdYd3f72jUXmXz5tD0A3Vo15jMPrejGILQ5pNlmS75qn1Dos2BaWivftNjz
GwHG8cAt4Osq0PHbl9ruYB0puBZrMxH/0QyA9P7CxSN5FvbPSYSqsIEFLlbCL4Hw
2PsJVmNIUUptgPl0q6PHH/AY3WAXJ7kzOUbKDBYQHOvOZ6hX3wqZLR94gJlXyig3
eks+vhZKP73Wzw7A9R3+wNGqDudWcBlEpIxhISsycXiKFTSLwZyWdXg/5RB0sgnu
mKLfC+/1AgN+Y9e75uisyAuTi4gkgeMP3F8CAwEAATANBgkqhkiG9w0BAQsFAAOC
AQEAB42BI8v2TkKObx2pdceI4K3h7c69ahUvyYq2HKSzP39cvtDw2BM0NDsKzs2g
2uKn1w9VreIHg3e811SCteIq18yr3Zrj5eCHX6601zJlsAtbpku4vdciyEv+o9uD
iYTtD/9Z6u/yDiwpJgaU5HrDRC7O/0TipQfuQwxxN+An11UOd81P+bvj+DKoDs3F
E6E2M4vQY33S78RF7P4EZVlrcW3JhcW23l+lAbqcSfL1/X+QYQfGL0Lp3BLOCtBL
y/Hp0zgI2Zq1+paupseHHBjTiORJzEUIQvQyI357pTA+lT5b0Bw7VsBpxYH7vpk9
mSNTffduRuD5KUKprT8t3Nw4FQ==
-----END CERTIFICATE-----`],
      password: "",
      protocols: socket.Protocol.TLSv12,
      useRemoteCipherPrefer: true,
      signatureAlgorithms: "rsa_pss_rsae_sha256:ECDSA+SHA256",
      cipherSuite: "AES256-SHA256"
    };
  }

  // TCP 额外选项（抽离常量，统一配置）
  private getTcpExtraOptions(): socket.TCPExtraOptions {
    return {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
  }

  // Callback 方式：设置 TLSSocketServer 选项
  private testTlsServerSetExtraOptionsCallback(): void {
    if (this.callbackServer) {
      this.closeServer(this.callbackServer, 'Callback 方式');
      this.callbackServer = null;
    }

    const tlsServer = socket.constructTLSSocketServerInstance();
    this.callbackServer = tlsServer;

    const netAddress: socket.NetAddress = { address: '127.0.0.1', port: 8080 };
    const tlsSecureOptions = this.getTlsSecureOptions();
    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    };
    const tcpExtraOptions = this.getTcpExtraOptions();

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Callback 方式：服务器监听成功`);
        this.setExtraOptionsByCallback(tlsServer, tcpExtraOptions);
      })
      .catch((err: BusinessError) => {
        const errMsg = `Callback 方式：服务器监听失败: [${err.code}] ${err.message}`;
        this.addTestResult(errMsg);
      });
  }

  // Callback 方式：调用 setExtraOptions
  private setExtraOptionsByCallback(server: socket.TLSSocketServer, options: socket.TCPExtraOptions): void {
    server.setExtraOptions(options, (err: BusinessError) => {
      if (err) {
        this.addTestResult(`Callback 方式：设置 TLSSocket 选项失败 - 错误码: ${err.code}, 消息: ${err.message}`);
        return;
      }
      this.addTestResult(`Callback 方式：设置 TLSSocket 选项成功`);
    });
  }

  // Promise 方式：设置 TLSSocketServer 选项
  private testTlsServerSetExtraOptionsPromise(): void {
    if (this.promiseServer) {
      this.closeServer(this.promiseServer, 'Promise 方式');
      this.promiseServer = null;
    }

    const tlsServer = socket.constructTLSSocketServerInstance();
    this.promiseServer = tlsServer;

    const netAddress: socket.NetAddress = { address: '127.0.0.1', port: 8081 };
    const tlsSecureOptions = this.getTlsSecureOptions();
    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    };
    const tcpExtraOptions = this.getTcpExtraOptions();

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Promise 方式：服务器监听成功`);
        return this.setExtraOptionsByPromise(tlsServer, tcpExtraOptions);
      })
      .catch((err: BusinessError) => {
        const errMsg = `Promise 方式：服务器监听失败: [${err.code}] ${err.message}`;
        this.addTestResult(errMsg);
      });
  }

  // Promise 方式：调用 setExtraOptions
  private setExtraOptionsByPromise(server: socket.TLSSocketServer, options: socket.TCPExtraOptions): Promise<void> {
    return server.setExtraOptions(options)
      .then(() => {
        this.addTestResult(`Promise 方式：设置 TLSSocket 选项成功`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise 方式：设置 TLSSocket 选项失败 - 错误码: ${err.code}, 消息: ${err.message}`);
      });
  }

  // ===================== 新增：keepAlive 场景测试 =====================
  // Callback 方式：keepAlive 为 true（正常参数）
  private testKeepAliveTrue_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();

    const options: socket.TCPExtraOptions = {
      keepAlive: true, // 目标参数（覆盖基础配置）
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8092 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-keepAliveTrue: 设置失败 - 错误码[${err.code}]，消息[${err.message}]`);
        } else {
          this.addTestResult(`Callback-keepAliveTrue: 设置成功（保持连接开启）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-keepAliveTrue: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback 方式：keepAlive 为 false（正常参数）
  private testKeepAliveFalse_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: false, // 目标参数
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8093 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-keepAliveFalse: 设置失败 - 错误码[${err.code}]，消息[${err.message}]`);
        } else {
          this.addTestResult(`Callback-keepAliveFalse: 设置成功（保持连接关闭）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-keepAliveFalse: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback-keepAlive为undefined
  private testKeepAliveUndefined_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: undefined,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8090 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else{
            this.addTestResult(`Callback-keepAlive为undefined 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-keepAliveUndefined: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Promise-keepAlive为undefined
  private testKeepAliveUndefined_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: undefined,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8091 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(options);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }
      }).finally(() => {
        // 新增：关闭服务器并决议Promise
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }
  // Promise 方式：keepAlive 为 true（正常参数）
  private testKeepAliveTrue_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8099 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-keepAliveTrue: 设置成功（保持连接开启）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-keepAliveTrue: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        // 最终关闭服务器
        return server.close().then(() => {
        });
      });
  }

  // Promise 方式：keepAlive 为 false（正常参数）
  private testKeepAliveFalse_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: false,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8100 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-keepAliveFalse: 设置成功（保持连接关闭）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-keepAliveFalse: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        return server.close().then(() => {
        });
      });
  }

  // ===================== 新增：OOBInline 场景测试 =====================
  // Callback 方式：OOBInline 为 true（正常参数）
  private testOOBInlineTrue_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: true, // 目标参数
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8094 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-OOBInlineTrue: 设置失败 - 错误码[${err.code}]，消息[${err.message}]`);
        } else {
          this.addTestResult(`Callback-OOBInlineTrue: 设置成功（OOB内联开启）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-OOBInlineTrue: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback 方式：OOBInline 为 false（正常参数）
  private testOOBInlineFalse_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: false, // 目标参数
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8095 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-OOBInlineFalse: 设置失败 - 错误码[${err.code}]，消息[${err.message}]`);
        } else {
          this.addTestResult(`Callback-OOBInlineFalse: 设置成功（OOB内联关闭）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-OOBInlineFalse: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }
  // Callback-OOBInline为undefined
  private testOOBInlineUndefined_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: undefined,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8111 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else {
            this.addTestResult(`Callback-OOBInline为undefined 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-OOBInlineUndefined: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Promise-OOBInline为undefined
  private testOOBInlineUndefined_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: undefined,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8115 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(options);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }
      }).then(() => {
        this.addTestResult(`Promise-OOBInline为undefined 方式：设置 TLSSocket 选项成功`);
      }).finally(() => {
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }


  // Promise 方式：OOBInline 为 true（正常参数）
  private testOOBInlineTrue_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: true,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8101 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-OOBInlineTrue: 设置成功（OOB内联开启）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-OOBInlineTrue: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        return server.close().then(() => {
        });
      });
  }

  // Promise 方式：OOBInline 为 false（正常参数）
  private testOOBInlineFalse_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: false,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8102 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-OOBInlineFalse: 设置成功（OOB内联关闭）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-OOBInlineFalse: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        return server.close().then(() => {
        });
      });
  }


  // ===================== 新增：TCPNoDelay 场景测试 =====================

  private testTCPNoDelayTrue_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: true, // 目标参数
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8096 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-TCPNoDelayTrue: 设置失败 - 错误码[${err.code}]，消息[${err.message}]`);
        } else {
          this.addTestResult(`Callback-TCPNoDelayTrue: 设置成功（TCP无延迟开启）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-TCPNoDelayTrue: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback 方式：TCPNoDelay 为 false（正常参数）
  private testTCPNoDelayFalse_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: false, // 目标参数
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8097 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        } else {
          this.addTestResult(`Callback-TCPNoDelayFalse: 设置成功（TCP无延迟关闭）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-TCPNoDelayFalse: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback-TCPNoDelay为undefined
  private testTCPNoDelayUndefined_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: undefined,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8112 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else {
            this.addTestResult(`Callback-TCPNoDelay为undefined 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-TCPNoDelayUndefined: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Promise-TCPNoDelay为undefined
  private testTCPNoDelayUndefined_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: undefined,
      socketLinger: { on: true, linger: 10 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8116 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(options);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }
      }).then(() => {
        this.addTestResult(`Promise-TCPNoDelay为undefined 方式：设置 TLSSocket 选项成功`);
      }).finally(() => {
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }

  // Promise 方式：TCPNoDelay 为 true（正常参数）
  private testTCPNoDelayTrue_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: true,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8103 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-TCPNoDelayTrue: 设置成功（TCP无延迟开启）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-TCPNoDelayTrue: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        return server.close().then(() => {
        });
      });
  }

  // Promise 方式：TCPNoDelay 为 false（正常参数）
  private testTCPNoDelayFalse_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: false,
      socketLinger: baseOptions.socketLinger,
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8104 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(` 服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-TCPNoDelayFalse: 设置成功（TCP无延迟关闭）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-TCPNoDelayFalse: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        return server.close().then(() => {
        });
      });
  }


  // ===================== 新增：socketLinger 场景测试 =====================

  // Callback 方式：socketLinger 合法值（正常参数）
  private testSocketLingerValid_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: { on: true, linger: 100 }, // 合法值（0-65535）
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8098 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      server.setExtraOptions(options, (err: BusinessError) => {
        if (err) {
          this.addTestResult(`Callback-socketLingerValid: 设置失败 - 错误码[${err.code}]，消息[${err.message}]`);
        } else {
          this.addTestResult(`Callback-socketLingerValid: 设置成功（连接保留100秒）`);
        }
        server.close().then(() => {
        });
      });
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-socketLingerValid: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }


  // Promise 方式：socketLinger 合法值（正常参数）
  private testSocketLingerValid_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const baseOptions = this.getTcpExtraOptions();
    const options: socket.TCPExtraOptions = {
      keepAlive: baseOptions.keepAlive,
      OOBInline: baseOptions.OOBInline,
      TCPNoDelay: baseOptions.TCPNoDelay,
      socketLinger: { on: true, linger: 100 }, // 合法值（0-65535）
      receiveBufferSize: baseOptions.receiveBufferSize,
      sendBufferSize: baseOptions.sendBufferSize,
      reuseAddress: baseOptions.reuseAddress,
      socketTimeout: baseOptions.socketTimeout
    };

    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8105 };
    return server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    })
      .then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        return server.setExtraOptions(options);
      })
      .then(() => {
        this.addTestResult(`Promise-socketLingerValid: 设置成功（连接保留100秒）`);
      })
      .catch((err: BusinessError) => {
        this.addTestResult(`Promise-socketLingerValid: 操作失败 - 错误码[${err.code}]，消息[${err.message}]`);
      })
      .finally(() => {
        return server.close().then(() => {
        });
      });
  }

  // Callback-socketLinger linger为-1
  private testSocketLingerLingerNeg_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: -1 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8113 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else {
            this.addTestResult(`Callback-socketLinger linger为-1 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-socketLingerLingerNeg: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback-socketLinger linger为65536
  private testSocketLingerLingerOver_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 65536 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8114 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else {
            this.addTestResult(`Callback-socketLinger linger为65536 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-socketLingerLingerNeg: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  //callback socketlinger on为false
  private testSocketLingerLingeron_false_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: false,linger :0},
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8114 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else {
            this.addTestResult(`Callback-socketLinger on为false 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-socketLinger on为false 方式: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback-socketLinger为undefined
  private testSocketLingerUndefined_Callback(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: undefined,
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8118 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else{
            this.addTestResult(`Callback-socketLinger为undefined 方式：设置 TLSSocket 选项成功`);
          }

          server.close().catch(() => {});
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-socketLingerUndefined: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });

  }

  // Promise-socketLinger linger为-1
  private testSocketLingerLingerNeg_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: -1 }, // 异常参数：linger 为负数
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };

    // 独立端口避免冲突，激活实例（关键修复：实例需先 listen 初始化）
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8110 };

    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(), // 复用 TLS 配置
        ALPNProtocols: ["http/1.1"]
      })
        .then(() => {
          this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
          try {
            // 实例激活后调用 setExtraOptions，同步捕获可能的同步错误
            return server.setExtraOptions(options);
          } catch (err) {
            // 捕获同步错误（如参数校验失败）
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
            return Promise.reject(err); // 转为 Promise 错误，统一后续流程
          }
        })
        .then(() => {
          // 正常情况下不会执行（因参数异常），仅作兜底
          this.addTestResult(`Promise-socketLinger linger为-1 方式：设置 TLSSocket 选项成功`);
        })
        .finally(() => {
          // 确保服务器关闭，释放端口资源
          server.close()
            .then(() => {
            })
            .finally(() => {
              resolve(); // 最终决议 Promise，避免内存泄漏
            });
        });
    });
  }
  // Promise-socketLinger linger为65536
  private testSocketLingerLingerOver_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: true, linger: 65536 },
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8220 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(options);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }

      }).then(() => {
        this.addTestResult(`Promise-socketLinger linger为65536 方式：设置 TLSSocket 选项成功`);
      }).finally(() => {
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }

  //promise socketlinger on为false
  private testSocketLingerLingeron_false_Promise(): void {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: { on: false,linger :0},
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8114 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(options, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }else {
            this.addTestResult(`Promise-socketLinger on为false 方式：设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {});
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Promise-socketLinger on为false 方式: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Promise-socketLinger为undefined
  private testSocketLingerUndefined_Promise(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const options: socket.TCPExtraOptions = {
      keepAlive: true,
      OOBInline: true,
      TCPNoDelay: true,
      socketLinger: undefined,
      receiveBufferSize: 8192,
      sendBufferSize: 8192,
      reuseAddress: true,
      socketTimeout: 3000
    };
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8119 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(options);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }

      }).then(() => {
        this.addTestResult(`Promise-socketLinger为undefined 方式：设置 TLSSocket 选项成功`);
      }).finally(() => {
        // 新增：关闭服务器并决议Promise
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }


  // 添加测试结果
  private addTestResult(result: string): void {

    const fullResult = `${result}`;
    this.testResults = this.testResults.concat(fullResult);
    console.info(`测试结果: ${fullResult}`);
  }

  // 清空测试结果
  private clearTestResults(): void {
    this.testResults = [];
    this.addTestResult(`测试结果已清空`);
  }

  // 新增测试方法区域
  // ===================== Callback 方式：参数场景测试 =====================

  // Callback-Options为null
  private testSetExtraOptionsCallback_OptionsNull(): void {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8124 }; // 独立端口

    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(null, (err: BusinessError) => { // 补充回调函数（Callback方式规范）
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          } else {
            this.addTestResult(`Callback-OptionsNull 方式: 设置 TLSSocket 选项成功`);
          }
          server.close().catch(() => {}); // 测试后关闭服务器
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-OptionsNull: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback-Options为undefined
  private testSetExtraOptionsCallback_OptionsUndefined(): void {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8125 };

    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`Callback-OptionsUndefined: 服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(undefined, (err: BusinessError) => {
          if (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          } else {
            this.addTestResult(`Callback-OptionsUndefined: 设置 TLSSocket 选项成功`);
          }
          // 修复：关闭服务器逻辑移到回调内部（确保无论成功失败都关闭）
          server.close().catch(() => {
          });
        });
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        server.close().catch(() => {});
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-OptionsUndefined: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  // Callback-callback类型错误
  private testSetExtraOptionsCallback_CallbackTypeError(): void {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8126 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(this.getTcpExtraOptions(),undefined);
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      } finally {
        server.close().catch(() => {}); // 确保关闭服务器
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-CallbackTypeError: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }

  private testSetExtraOptionsCallback_CallbackTypeNull(): void {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8126 };
    server.listen({
      address: listenAddr,
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    }).then(() => {
      this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
      try {
        server.setExtraOptions(this.getTcpExtraOptions(),null);
      } catch (err) {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      } finally {
        server.close().catch(() => {}); // 确保关闭服务器
      }
    }).catch((listenErr: BusinessError) => {
      this.addTestResult(`Callback-CallbackTypeError: 监听失败 - 错误码[${listenErr.code}]，消息[${listenErr.message}]`);
    });
  }


  // Callback-未传入callback
  private testSetExtraOptionsCallback_NoCallback(): void {

    const tlsServer = socket.constructTLSSocketServerInstance();
    this.promiseServer = tlsServer;

    const netAddress: socket.NetAddress = { address: '127.0.0.1', port: 8081 };
    const tlsSecureOptions = this.getTlsSecureOptions();
    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"]
    };
    const tcpExtraOptions = this.getTcpExtraOptions();

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
          try {
            tlsServer.setExtraOptions(this.getTcpExtraOptions());
            this.addTestResult(`Callback-Nocallback: 设置 TLSSocket 选项成功`);
          } catch (err) {
            this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          }
      })
      .catch((err: BusinessError) => {
        const errMsg = `promise 方式：服务器监听失败: [${err.code}] ${err.message}`;
        this.addTestResult(errMsg);
      });
  }

  // ===================== Callback 方式：接口错误场景测试 =====================

  private testSetExtraOptionsCallback_PermissionDenied(): void {
    const server = socket.constructTLSSocketServerInstance();
    const listenOptions: socket.TLSConnectOptions = {
      address: { address: '127.0.0.1', port: 8082 },
      secureOptions: this.getTlsSecureOptions(),
      ALPNProtocols: ["http/1.1"]
    };

    server.listen(listenOptions)
      .then(() => {
        try {
          server.setExtraOptions(this.getTcpExtraOptions());
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        }
      })
      .catch((listenErr: BusinessError) => {
        this.addTestResult(`错误码”[${listenErr.code}]“，错误信息”${listenErr.message}“`);
      })
      .finally(() => {
        server.close().catch(() => {});
      });
  }

  // Promise-Options为null
  private testSetExtraOptionsPromise_OptionsNull(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8117 };

    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        // this.addTestResult(` 服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(null);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }
      }).finally(() => {
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }

  // Promise-Options为undefined
  private testSetExtraOptionsPromise_OptionsUndefined(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8120 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        // this.addTestResult(` 服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(undefined);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }
      })
        .finally(() => {
          server.close().then(() => {
            resolve();
          }).catch(() => resolve());
        });
    });
  }

  // Promise-权限校验失败
  private testSetExtraOptionsPromise_PermissionDenied(): Promise<void> {
    const server = socket.constructTLSSocketServerInstance();
    const listenAddr: socket.NetAddress = { address: '127.0.0.1', port: 8121 };
    return new Promise((resolve) => {
      server.listen({
        address: listenAddr,
        secureOptions: this.getTlsSecureOptions(),
        ALPNProtocols: ["http/1.1"]
      }).then(() => {
        //this.addTestResult(`服务器监听成功（${listenAddr.address}:${listenAddr.port}）`);
        try {
          return server.setExtraOptions(this.getTcpExtraOptions());
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
          return Promise.reject(err);
        }
      }).catch((err: BusinessError) => {
        this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
      }).finally(() => {
        server.close().then(() => {
          resolve();
        }).catch(() => resolve());
      });
    });
  }

  // 构建测试按钮（@Builder 复用组件）
  @Builder
  private buildTestButton(text: string, onClick: () => void, bgColor: string) {
    Button(text)
      .onClick(onClick)
      .width('90%')
      .height(32) // 从44改为32，减小高度
      .fontSize(13) // 从16改为13，减小字体
      .fontColor('#ffffff')
      .backgroundColor(bgColor)
      .borderRadius(6) // 从8改为6，减小圆角
      .shadow({ radius: 2, color: `${bgColor}20`, offsetX: 0, offsetY: 1 }); // 减小阴影
  }

  @Builder
  private buildSetExtraOptionsTestButtons() {
    Column({ space: 8 }) { // 从12改为8，减小按钮间距
      this.buildTestButton(
        'Callback-Options为null',
        () => this.testSetExtraOptionsCallback_OptionsNull(),
        '#FF9800'
      );
      this.buildTestButton(
        'Callback-Options为undefined',
        () => this.testSetExtraOptionsCallback_OptionsUndefined(),
        '#FF5722'
      );
      this.buildTestButton(
        'Callback-callback类型为undefined',
        () => this.testSetExtraOptionsCallback_CallbackTypeError(),
        '#9C27B0'
      );
      this.buildTestButton(
        'Callback-callback类型为null',
        () => this.testSetExtraOptionsCallback_CallbackTypeNull(),
        '#9C27B0'
      );
      this.buildTestButton(
        'Callback-未传入callback',
        () => this.testSetExtraOptionsCallback_NoCallback(),
        '#F44336'
      );
      // this.buildTestButton(
      //   'Callback-权限校验失败',
      //   () => this.testSetExtraOptionsCallback_PermissionDenied(),
      //   '#795548'
      // );

      this.buildTestButton(
        'Promise-Options为null',
        () => this.testSetExtraOptionsPromise_OptionsNull(),
        '#00BCD4'
      );
      this.buildTestButton(
        'Promise-Options为undefined',
        () => this.testSetExtraOptionsPromise_OptionsUndefined(),
        '#4CAF50'
      );

      // this.buildTestButton(
      //   'Promise-权限校验失败',
      //   () => this.testSetExtraOptionsPromise_PermissionDenied(),
      //   '#009688'
      // );
    }
    .width('100%')
  }

  @Builder
  private buildFunctionButton(text: string, onClick: () => void, bgColor: string) {
    Button(text)
      .onClick(onClick)
      .width('90%')
      .height(32) // 从44改为32，减小高度
      .fontSize(13) // 从16改为13，减小字体
      .fontColor('#ffffff')
      .backgroundColor(bgColor)
      .borderRadius(6) // 从8改为6，减小圆角
      .shadow({ radius: 2, color: `${bgColor}20`, offsetX: 0, offsetY: 1 }); // 减小阴影
  }

  // 新增测试按钮构建
  @Builder
  private buildExtraSceneTestButtons() {
    Column({ space: 8 }) { // 从12改为8，减小按钮间距
      Text('Callback 方式测试')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin({ top: 10 });

      this.buildTestButton(
        'Callback-keepAlive为true',
        () => this.testKeepAliveTrue_Callback(),
        '#2196F3'
      );
      this.buildTestButton(
        'Callback-keepAlive为false',
        () => this.testKeepAliveFalse_Callback(),
        '#00BCD4'
      );
      this.buildTestButton(
        'Callback-OOBInline为true',
        () => this.testOOBInlineTrue_Callback(),
        '#FF9800'
      );
      this.buildTestButton(
        'Callback-OOBInline为false',
        () => this.testOOBInlineFalse_Callback(),
        '#FF5722'
      );
      this.buildTestButton(
        'Callback-TCPNoDelay为true',
        () => this.testTCPNoDelayTrue_Callback(),
        '#4CAF50'
      );
      this.buildTestButton(
        'Callback-TCPNoDelay为false',
        () => this.testTCPNoDelayFalse_Callback(),
        '#8BC34A'
      );
      this.buildTestButton(
        'Callback-socketLinger合法值',
        () => this.testSocketLingerValid_Callback(),
        '#9C27B0'
      );

      this.buildTestButton(
        'Callback-keepAlive为undefined',
        () => this.testKeepAliveUndefined_Callback(),
        '#FF5722'
      );
      this.buildTestButton(
        'Callback-OOBInline为undefined',
        () => this.testOOBInlineUndefined_Callback(),
        '#F44336'
      );
      this.buildTestButton(
        'Callback-TCPNoDelay为undefined',
        () => this.testTCPNoDelayUndefined_Callback(),
        '#673AB7'
      );
      this.buildTestButton(
        'Callback-socketLinger linger为-1',
        () => this.testSocketLingerLingerNeg_Callback(),
        '#2196F3'
      );
      this.buildTestButton(
        'Callback-socketLinger linger为65536',
        () => this.testSocketLingerLingerOver_Callback(),
        '#00BCD4'
      );
      this.buildTestButton(
        'Callback-socketLinger on为false',
        () => this.testSocketLingerLingeron_false_Callback(),
        '#00BCD4'
      );
      this.buildTestButton(
        'Callback-socketLinger为undefined',
        () => this.testSocketLingerUndefined_Callback(),
        '#FF9800'
      );

      Text('Promise 方式测试')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin({ top: 15 });

      // Promise 有效场景（新增）
      this.buildTestButton(
        'Promise-keepAlive为true',
        () => this.testKeepAliveTrue_Promise(),
        '#2196F3'
      );
      this.buildTestButton(
        'Promise-keepAlive为false',
        () => this.testKeepAliveFalse_Promise(),
        '#00BCD4'
      );
      this.buildTestButton(
        'Promise-OOBInline为true',
        () => this.testOOBInlineTrue_Promise(),
        '#FF9800'
      );
      this.buildTestButton(
        'Promise-OOBInline为false',
        () => this.testOOBInlineFalse_Promise(),
        '#FF5722'
      );
      this.buildTestButton(
        'Promise-TCPNoDelay为true',
        () => this.testTCPNoDelayTrue_Promise(),
        '#4CAF50'
      );
      this.buildTestButton(
        'Promise-TCPNoDelay为false',
        () => this.testTCPNoDelayFalse_Promise(),
        '#8BC34A'
      );
      this.buildTestButton(
        'Promise-socketLinger合法值',
        () => this.testSocketLingerValid_Promise(),
        '#9C27B0'
      );

      this.buildTestButton(
        'Promise-keepAlive为undefined',
        () => this.testKeepAliveUndefined_Promise(),
        '#4CAF50'
      );
      this.buildTestButton(
        'Promise-OOBInline为undefined',
        () => this.testOOBInlineUndefined_Promise(),
        '#3F51B5'
      );
      this.buildTestButton(
        'Promise-TCPNoDelay为undefined',
        () => this.testTCPNoDelayUndefined_Promise(),
        '#9C27B0'
      );
      this.buildTestButton(
        'Promise-socketLinger linger为-1',
        () => this.testSocketLingerLingerNeg_Promise(),
        '#9C27B0'
      );
      this.buildTestButton(
        'Promise-socketLinger linger为65536',
        () => this.testSocketLingerLingerOver_Promise(),
        '#F44336'
      );

      this.buildTestButton(
        'Promise-socketLinger on为false',
        () => this.testSocketLingerLingeron_false_Promise(),
        '#F44336'
      );

      this.buildTestButton(
        'Promise-socketLinger为undefined',
        () => this.testSocketLingerUndefined_Promise(),
        '#3F51B5'
      );
    }
    .width('100%')
  }

  build() {
    Scroll() {
      Column({ space: 20 }) {
        // 标题区域
        Text('TLSSocketServer_setExtraOptions测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 10 })
          .padding(12)
          .backgroundColor('#ffffff')
          .borderRadius(12)
          .shadow({
            radius: 4,
            color: '#00000010',
            offsetX: 0,
            offsetY: 2
          });

        Column({ space: 10 }) { // 从12改为10，减小按钮间距
          this.buildTestButton(
            'Callback 方式设置',
            () => this.testTlsServerSetExtraOptionsCallback(),
            '#2196F3'
          );
          this.buildTestButton(
            'Promise 方式设置',
            () => this.testTlsServerSetExtraOptionsPromise(),
            '#00BCD4'
          );
        }
        .width('100%')

        Text('参数异常场景测试')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('90%')
          .textAlign(TextAlign.Start)

        Scroll() {
          Column({ space: 15 }) { // 从20改为15，减小区块间距
            Text('基础参数异常场景')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .width('90%')
              .textAlign(TextAlign.Start)
              .margin({ top: 10 });

            this.buildSetExtraOptionsTestButtons();

            Text('TCP属性场景测试（正常+异常）')
              .fontSize(15)
              .fontWeight(FontWeight.Bold)
              .width('90%')
              .textAlign(TextAlign.Start)
              .margin({ top: 15 });

            this.buildExtraSceneTestButtons();
          }
          .width('100%')
          .padding(10)
        }
        .scrollBar(BarState.On)
        .scrollable(ScrollDirection.Vertical)
        .height(200)
        .width('100%')
        .border({ width: 1, color: '#EEEEEE' })
        .borderRadius(8);
        Scroll(){
          Column({ space: 6 }) {
            Text('测试结果日志')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .width('90%')
              .textAlign(TextAlign.Start)

            Scroll() {
              Column({ space: 6 }) {
                ForEach(
                  this.testResults,
                  (result: string, index: number) => {
                    Text(`${index + 1}. ${result}`)
                      .fontSize(14)
                      .textAlign(TextAlign.Start)
                      .padding(10)
                      .backgroundColor(index % 2 === 0 ? '#f5f5f5' : '#ffffff')
                      .width('100%')
                      .borderRadius(6)
                      .shadow({
                        radius: 2,
                        color: '#00000008',
                        offsetX: 0,
                        offsetY: 1
                      });
                  },
                  (result: string, index: number) => `${result}-${index}`
                );

                if (this.testResults.length === 0) {
                  Text('暂无测试结果，点击上方按钮开始测试')
                    .fontSize(14)
                    .textAlign(TextAlign.Center)
                    .padding(30)
                    .width('100%');
                }
              }
              .width('100%')
              .padding(4);
            }
            .scrollBar(BarState.On)
            .scrollable(ScrollDirection.Vertical)
            .height(200)
            .width('90%')
            .backgroundColor('#ffffff')
            .borderRadius(10)
            .border({ width: 1, color: '#eeeeee' })

            Row() {
              Button('← 返回')
                .layoutWeight(1)
                .padding({ left: 15, right: 15 })
                .backgroundColor('#4CAF50')
                .onClick(() => {
                  router.back();
                })
              Button('清理日志')
                .layoutWeight(1)
                .padding({ left: 15, right: 15 })
                .backgroundColor('#4CAF50')
                .onClick(() => this.clearTestResults())
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(10)
            .margin({ top: 5 })
          }
      }
      }
      .width('100%')
      .padding(15);
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f7');
  }
}