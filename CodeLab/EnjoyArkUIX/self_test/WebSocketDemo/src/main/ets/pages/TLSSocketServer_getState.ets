import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';



// 定义公共配置返回接口（符合 ArkTS 类型规范）
interface CommonTlsConfig {
  tlsConnectOptions: socket.TLSConnectOptions;
}

interface MockTLSSocketServerInterface {
  getState(callback: (err: BusinessError, data: socket.SocketStateBase) => void): void;
}

interface MockTLSSocketServerPromiseInterface {
  getState(): Promise<socket.SocketStateBase>;
}

// 新增：TLS 服务端真实状态接口（覆盖实际返回的字段）
interface TLSSocketServerState extends socket.SocketStateBase {
  state: number;
  localAddress: string;
  localPort: number;
  connectionCount: number;
}

@Entry
@Component
struct testTLSSocketServerGetState {
  @State testResults: string[] = [];

  aboutToAppear(): void {
  }

  private getCommonTlsConfig(port: number): CommonTlsConfig {
    const netAddress: socket.NetAddress = {
      address: '127.0.0.1',
      port: port
    };

    const tlsSecureOptions: socket.TLSSecureOptions = {
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

    const tlsConnectOptions: socket.TLSConnectOptions = {
      address: netAddress,
      secureOptions: tlsSecureOptions,
      ALPNProtocols: ["http/1.1"],
      skipRemoteValidation: false
    };

    return { tlsConnectOptions };
  }

  private getStateDescription(state: number): string {
    switch (state) {
      case 0: return "未连接（INIT/CLOSED）";
      case 1: return "监听中（LISTENING）";
      case 2: return "已连接（CONNECTED）";
      case 3: return "关闭中（CLOSING）";
      case 4: return "出错（ERROR）";
      default: return `未知状态（${state}）`;
    }
  }

  testTlsServerGetStateCallback(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const commonConfig = this.getCommonTlsConfig(8081);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;

    this.addTestResult(`Callback模式 - 开始启动服务（端口：8081）`);

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Callback模式 - listen 启动成功`);
        tlsServer.getState((err: BusinessError, data: socket.SocketStateBase) => {
          if (err) {
            this.addTestResult(`Callback模式 - 获取状态失败 [${err.code}]: ${err.message}`);
          } else {
            console.info('getState success:' + JSON.stringify(data));
            this.addTestResult('getState success:' + JSON.stringify(data))
          }
          tlsServer.close()
            .then(() => this.addTestResult(`Callback模式 - 服务已关闭（端口：8081）`))
            .catch((closeErr: BusinessError) =>
            this.addTestResult(`Callback模式 - 关闭服务失败 [${closeErr.code}]: ${closeErr.message}`));
        });
      })
      .catch((listenErr: BusinessError) => {
        this.addTestResult(`Callback模式 - listen 启动失败 [${listenErr.code}]: ${listenErr.message}`);
        tlsServer.getState((err: BusinessError) => {
          if (err) {
            this.addTestResult(`Callback模式 - 启动失败后查询状态：[${err.code}]: ${err.message}`);
          } else {
            this.addTestResult(`Callback模式 - 启动失败后查询状态：服务处于初始状态`);
          }
        });
      });
  }

  // 【未修改】testTlsServerGetStatePromise 方法（时序正确）
  testTlsServerGetStatePromise(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const commonConfig = this.getCommonTlsConfig(8080);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;

    this.addTestResult(`Promise模式 - 开始启动服务（端口：8080）`);

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Promise模式 - listen 启动成功`);
        tlsServer.getState().then((data: socket.SocketStateBase) => {
          this.addTestResult('getState success'+ JSON.stringify(data));
        }).catch((err: BusinessError) => {
          this.addTestResult('getState fail');
        });
          tlsServer.close()
            .then(() => this.addTestResult(`Promise模式 - 服务已关闭（端口：8080）`))
            .catch((closeErr: BusinessError) =>
            this.addTestResult(`Promise模式 - 关闭服务失败 [${closeErr.code}]: ${closeErr.message}`));
        })
      .catch((listenErr: BusinessError) => {
        this.addTestResult(`Promise模式 - listen 启动失败 [${listenErr.code}]: ${listenErr.message}`);
        tlsServer.getState((err: BusinessError) => {
          if (err) {
            this.addTestResult(`Promise模式 - 启动失败后查询状态：[${err.code}]: ${err.message}`);
          } else {
            this.addTestResult(`Promise模式 - 启动失败后查询状态：服务处于初始状态`);
          }
        });
      });
  }

  // 【未修改】参数异常测试方法
  // Callback-callback类型错误（增加listen激活，确保实例就绪后测试参数合法性）
  testGetStateCallbackInvalidCallback(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const commonConfig = this.getCommonTlsConfig(8090); // 专用测试端口
    const tlsConnectOptions = commonConfig.tlsConnectOptions;

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        try {
          tlsServer.getState(undefined);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        } finally {
          tlsServer.close();
          };
        })
      }

  testGetStateCallbackCallbackNull(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const commonConfig = this.getCommonTlsConfig(8090); // 专用测试端口
    const tlsConnectOptions = commonConfig.tlsConnectOptions;

    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        try {
          tlsServer.getState(undefined);
        } catch (err) {
          this.addTestResult(`错误码”[${err.code}]“，错误信息”${err.message}“`);
        } finally {
          tlsServer.close();
        };
      })
  }

  // Callback-未传入callback（增加listen激活，确保实例就绪后测试参数合法性）
  testGetStateCallbackNoCallback(): void {
    const tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();
    const commonConfig = this.getCommonTlsConfig(8080);
    const tlsConnectOptions = commonConfig.tlsConnectOptions;


    tlsServer.listen(tlsConnectOptions)
      .then(() => {
        this.addTestResult(`Callback模式 - listen 启动成功`);
        try{
          tlsServer.getState()
          this.addTestResult('getState success');
        }catch(err){
          this.addTestResult('getState fail');
        }

        tlsServer.close()
          .then(() => this.addTestResult(`Callback模式 - 服务已关闭（端口：8080）`))
          .catch((closeErr: BusinessError) =>
          this.addTestResult(`Callback模式 - 关闭服务失败 [${closeErr.code}]: ${closeErr.message}`));
      })
      .catch((listenErr: BusinessError) => {
        this.addTestResult(`Callback模式 - listen 启动失败 [${listenErr.code}]: ${listenErr.message}`);
        tlsServer.getState((err: BusinessError) => {
          if (err) {
            this.addTestResult(`Callback模式 - 启动失败后查询状态：[${err.code}]: ${err.message}`);
          } else {
            this.addTestResult(`Callback模式 - 启动失败后查询状态：服务处于初始状态`);
          }
        });
      });
  }


  addTestResult(result: string): void {
    this.testResults = [...this.testResults, `${result}`];
    console.info(`测试结果: ${result}`);
  }

  clearTestResults(): void {
    this.testResults = [];
    this.addTestResult(`已清空所有测试结果`);
  }

  build() {
    Column({ space: 15 }) {
      // 标题（优化视觉层级）
      Text('TLSSocketServer_getState测试')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 1, bottom: 5 })
        .textAlign(TextAlign.Center)
        .width('100%');

      Button('Callback模式测试（端口8081）')
        .onClick(() => this.testTlsServerGetStateCallback())
        .width('90%')
        .height(30)
        .backgroundColor('#4ECDC4')
        .fontSize(16)
        .fontWeight(FontWeight.Medium);

      Button('Promise模式测试（端口8080）')
        .onClick(() => this.testTlsServerGetStatePromise())
        .width('90%')
        .height(30)
        .backgroundColor('#45B7D1')
        .fontSize(16)
        .fontWeight(FontWeight.Medium);

      Text('getState接口参数测试')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 5, bottom: 5 })
        .alignSelf(ItemAlign.Start)
        .padding({ left: '5%' });

      Button('Callback-callback类型为undefined')
        .onClick(() => this.testGetStateCallbackInvalidCallback())
        .width('90%')
        .height(30)
        .backgroundColor('#FF6B6B');
      Button('Callback-callback类型为null')
        .onClick(() => this.testGetStateCallbackCallbackNull())
        .width('90%')
        .height(30)
        .backgroundColor('#FF6B6B');
      Button('Callback-未传入callback')
        .onClick(() => this.testGetStateCallbackNoCallback())
        .width('90%')
        .height(30)
        .backgroundColor('#FF8E53');

      Button('清空测试结果')
        .onClick(() => this.clearTestResults())
        .width('90%')
        .height(35)
        .backgroundColor(Color.Gray)
        .fontSize(16)
        .fontWeight(FontWeight.Medium);

      Button('返回主界面')
        .onClick(() => router.back())
        .width('90%')
        .height(35)
        .backgroundColor('#333333')
        .fontColor(Color.White)
        .fontSize(16)
        .fontWeight(FontWeight.Medium);

      Text('测试结果日志')
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 5, bottom: 5 })
        .alignSelf(ItemAlign.Start)
        .padding({ left: '5%' });

      Scroll() {
        Column({ space: 4 }) {
          ForEach(this.testResults, (result: string, index: number) => {
            Text(`${index + 1}. ${result}`)
              .fontSize(13)
              .textAlign(TextAlign.Start)
              .padding(6)
              .backgroundColor(index % 2 === 0 ? '#f8f9fa' : '#ffffff')
              .width('100%')
              .borderRadius(4)
              .border({ width: 1, color: '#e9ecef' });
          }, (result: string) => result);
        }
        .width('100%')
        .padding(5)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start);
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height(200)
      .margin({ top: 5 })
      .padding(10)
      .backgroundColor('#ffffff')
      .border({ width: 1, color: '#dddddd' })
      .borderRadius(8);

    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#f5f7fa');
  }
}