import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';

@Entry
@Component
struct TLSSocketServerGetLocalAddressTest {
  @State testResults: string[] = [];
  private readonly tlsSecureConfig: socket.TLSSecureOptions = {
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

  aboutToAppear(): void {

  }

  testNormalGetLocalAddress(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const listenOptions: socket.TLSConnectOptions = {
      address: { address: '0.0.0.0', port: 12346 },
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    };

    tlsServer.listen(listenOptions)
      .then(() => {
        return tlsServer.getLocalAddress()
          .then((address) => {
            if (address) {
              this.addTestResult(`服务器地址信息: 地址${address.address}: 端口${address.port}`);
            } else {
              this.addTestResult(`服务器本地地址: 获取为空`);
            }
          })
          .catch((getAddrErr: BusinessError) => {
            this.addTestResult(`连接成功后获取服务器地址失败 - 错误码: ${getAddrErr.code}, 消息: ${getAddrErr.message}`);
          });

      })
      .finally(() => {
        tlsServer.close().catch((err: BusinessError) => console.warn("服务器关闭失败:", err));
      });
  }

  testInvalidFdError(): void {
    let tlsServer: socket.TLSSocketServer = socket.constructTLSSocketServerInstance();

    const listenOptions: socket.TLSConnectOptions = {
      address: { address: '0.0.0.0', port: 12346 },
      secureOptions: this.tlsSecureConfig,
      ALPNProtocols: ["http/1.1"]
    };

    tlsServer.listen(listenOptions, (bindErr: BusinessError) => {
      if (bindErr) {
        console.error("首次监听失败:", bindErr);
        this.addTestResult(`首次监听失败 [${bindErr.code}]-${bindErr.message}`);
        return;
      }

      console.log("TLSSocketServer监听成功，准备关闭");
      tlsServer.close().then(() => {
        console.log("TLSSocketServer已关闭，文件描述符无效");
        tlsServer.getLocalAddress().then((address) => {
          console.error("意外成功获取地址: " + JSON.stringify(address));
          this.addTestResult("预期应该触发错误但实际成功了");
        }).catch((err: BusinessError) => {
          this.addTestResult(JSON.stringify(err));
        });
      }).catch((closeErr: BusinessError) => {
        console.error("关闭失败:", closeErr);
        this.addTestResult(`关闭失败 [${closeErr.code}]-${closeErr.message}`);
      });
    });
  }

  addTestResult(result: string): void {
    this.testResults = [...this.testResults, result];
    console.info(`[测试结果] ${result}`);
  }

  clearTestResults(): void {
    this.testResults = [];
    this.addTestResult(`测试结果已清空`);
  }


  build() {
    Column({ space: 15 }) {
      // 标题
      Text('TLSSocketServer_getLocalAddress 测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })
        .alignSelf(ItemAlign.Center);

      Button('TLSSocketServer_getLocalAddress')
        .onClick(() => this.testNormalGetLocalAddress())
        .width('90%')
        .height(45)
        .backgroundColor('#27ae60')
        .fontColor(Color.White)
        .fontSize(16)
        .borderRadius(8);

      Button('错误场景：无效文件描述符')
        .onClick(() => this.testInvalidFdError())
        .width('90%')
        .height(45)
        .backgroundColor('#c0392b')
        .fontColor(Color.White)
        .fontSize(16)
        .borderRadius(8);

      Button('清空测试结果')
        .onClick(() => this.clearTestResults())
        .width('90%')
        .height(45)
        .backgroundColor(Color.Gray)
        .fontColor(Color.White)
        .fontSize(16)
        .borderRadius(8);

      Button('返回主界面')
        .onClick(() => router.back())
        .width('90%')
        .height(45)
        .backgroundColor('#3498db')
        .fontColor(Color.White)
        .fontSize(16)
        .borderRadius(8);

      Scroll() {
        Column({ space: 8 }) {
          ForEach(this.testResults, (result: string, index: number) => {
            Text(`${index + 1}. ${result}`)
              .fontSize(14)
              .textAlign(TextAlign.Start)
              .padding(10)
              .backgroundColor(index % 2 === 0 ? '#f8f9fa' : '#ffffff')
              .width('100%')
              .borderRadius(4);
          }, (result: string) => `${result}-${Date.now()}`) // 唯一key避免渲染异常
        }
        .width('100%')
        .padding(10)
      }
      .scrollBar(BarState.On)
      .scrollable(ScrollDirection.Vertical)
      .height(250)
      .margin({ top: 10, left: '5%', right: '5%' })
      .backgroundColor('#ffffff')
      .borderRadius(8)
      .border({ width: 1, color: '#e0e0e0' })

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}