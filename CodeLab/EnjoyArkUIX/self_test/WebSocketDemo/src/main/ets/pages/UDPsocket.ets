import socket from '@ohos.net.socket';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import router from '@ohos.router';

@Entry
@Component
struct testudp {
  @State testResults: string[] = [];
  @State log: string = '';
  private addLog(content: string) {
    this.log += `${content}\n`;
  }

  clearTestLog(): void {
    this.log = "";
  }

  getLocalAddress(): void {
    this.clearTestLog();
    let udp: socket.UDPSocket = socket.constructUDPSocketInstance();

    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 0
    }
    udp.bind(bindAddr).then(() => {
      udp.getLocalAddress().then((localAddress: socket.NetAddress) => {
        this.addLog('getLocalAddress成功'+ JSON.stringify(localAddress));
      }).catch((err: BusinessError) => {
        this.addLog('getLocalAddress失败');
      })
    }).catch((err: BusinessError) => {
      this.addLog('bind失败');
    }).finally(() => {
      udp.close().then(() => {
        this.addLog('udp 资源已成功关闭');
      })
        .catch(() => {});
    });
  }

  // 测试场景2：getLocalAddress无效的文件描述符
  testInvalidFileDescriptor(): void {
    this.clearTestLog();
    const udp = socket.constructUDPSocketInstance();
    const bindAddr: socket.NetAddress = { address: '0.0.0.0', port: 0 };
    udp.bind(bindAddr)
      .then(() => udp.close())
      .then(() => udp.getLocalAddress())
      .then(() => {
        this.addLog('❌ 关闭后仍能获取地址？');
      })
      .catch((err: BusinessError) => {
        if (err.code === 2301009) {
          this.addLog('✅ 正确捕获错误：socket 预期（2301009），实际：'+ err.code);
        } else {
          this.addLog(`⚠️ 非预期错误码：${err.code}`);
        }
      })
      .finally(() => {
        udp.close().catch(() => {});
      });
  }

  getSocketFd(): void {
    this.clearTestLog();
    const udp = socket.constructUDPSocketInstance();
    const bindAddr: socket.NetAddress = { address: '0.0.0.0', port: 0 };
    udp.bind(bindAddr)
      .then(() => udp.getSocketFd())
      .then((fd: number) => {
        if (fd >= 0) {
          this.addLog(`✅ getSocketFd 成功，Fd: ${fd}`);
        } else {
          this.addLog(`⚠️ getSocketFd 返回无效 fd: ${fd}`);
        }
      })
      .catch((err: BusinessError) => {
        this.addLog(`❌ getSocketFd 失败，错误码: ${err.code}, 信息: ${err.message}`);
      })
      .finally(() => {
        udp.close().then(() => {
          this.addLog('udp 资源已成功关闭');
        })
          .catch((err:BusinessError) => {
            console.warn('关闭 UDP socket 时出错:', err?.code, err?.message);
          });
      });
  }

  build() {
    Column({ space: 20 }) {
      // 标题和当前状态
      Text('UDPSocket测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });
      // 日志展示区域
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
      .margin({ top: 10 })
      Button('UDPSocket_getLocalAddress')
        .onClick(() => this.getLocalAddress())
        .width('90%')
        .height(40);
      Button('getLocalAddress-无效的文件描述符')
        .onClick(() => this.testInvalidFileDescriptor())
        .width('90%')
        .height(40);
      Button('UDPSocket_getSocketFd')
        .onClick(() => this.getSocketFd())
        .width('90%')
        .height(40);
      Button('返回主界面')
        .onClick(() => {
          router.back();
        })
    }
  }
}