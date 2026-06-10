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

  getLocalAddress_Error1(): void {
    this.clearTestLog();
    const udp = socket.constructUDPSocketInstance();
    udp.close();
    udp.getLocalAddress().then((localAddress: socket.NetAddress) => {
      console.info("UDP_Socket getLocalAddress success, localAddress: ",JSON.stringify(localAddress));
    }).catch((err: BusinessError) => {
      console.error("UDP_Socket getLocalAddress fail, ",JSON.stringify(err));
      if (err.code === 2303188) {
        this.addLog('Correctly captured error: '+ err.code);
      } else {
        this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
      }
    })
  }

  getLocalAddress_Error2(): void {
    this.clearTestLog();
    const udp = socket.constructUDPSocketInstance();
    const bindAddr: socket.NetAddress = { address: '0.0.0.0', port: 0 };
    udp.bind(bindAddr)
      .then(() => udp.close())
      .then(() => udp.close())
      .then(() => udp.getLocalAddress())
      .then(() => {
        this.addLog('close success');
      })
      .catch((err: BusinessError) => {
        if (err.code === 2303188) {
          this.addLog('Correctly captured error: '+ err.code);
        } else {
          this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
        }
      })
      .finally(() => {
        udp.close().catch(() => {});
      });
  }

  build() {
    Column({ space: 20 }) {
      Text('UDPSocket测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });
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
      // Button('getLocalAddress-2301009')
      Button('getLocalAddress对非套接字进行套接字操作1')
        .onClick(() => this.getLocalAddress_Error1())
        .width('90%')
        .height(40);
      // Button('getLocalAddress-2300999')
      Button('getLocalAddress对非套接字进行套接字操作2')
        .onClick(() => this.getLocalAddress_Error2())
        .width('90%')
        .height(40);
      Button('返回主界面')
        .onClick(() => {
          router.back();
        })
    }
  }
}