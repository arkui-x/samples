import socket from '@ohos.net.socket';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import router from '@ohos.router';

@Entry
@Component
struct testudp {
  @State testResults: string[] = [];
  @State log: string = '';
  aboutToAppear(): void {
  }
  private addLog(content: string) {
    this.log += `${content}\n`;
    this.log = this.log;
  }

  clearTestLog(): void {
    this.log = "";
  }

  getLocalAddress_Error1(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    tcp.close();
    tcp.getLocalAddress().then((localAddress: socket.NetAddress) => {
      console.info("SUCCESS! Address:" + JSON.stringify(localAddress));
      this.addLog('getLocalAddress success, localAddress: '+ JSON.stringify(localAddress));
    }).catch((err: BusinessError) => {
      console.error("FAILED! Error:" + JSON.stringify(err));
      this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
    })
  }

  getLocalAddress_Error2(): void {
    this.clearTestLog();
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0',
      port: 8080,
      family: 1
    };

    tcp.bind(bindAddr).then(() => {
      return tcp.close();
    }).then(() => {
      console.info('first close success');
      return tcp.close();
    }).then(() => {
      console.info('second close success');
      return tcp.getLocalAddress();
    }).then((localAddress: socket.NetAddress) => {
      console.info("SUCCESS! Address:" + JSON.stringify(localAddress));
      this.addLog('getLocalAddress success, Address:'+ JSON.stringify(localAddress));
    }).catch((err: BusinessError) => {
      console.error("FAILED! Error:" + JSON.stringify(err));
      this.addLog(`正确捕获错误：socket 预期(2303188)，实际：${err.code}`);
    }).catch((err: BusinessError) => {
      console.error('bind fail');
      this.addLog('bind fail');
    });
  }

  build() {
    Column({ space: 10 }) {
      Text('TCPSocket测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });

      Text('测试日志:')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('90%')
        .textAlign(TextAlign.Start);

      Scroll() {
        Text(this.log)
          .fontSize(14)
          .width('100%')
          .padding(10)
          .backgroundColor('#f5f5f5')
      }
      .height('15%')
      .width('90%')
      .border({ width: 1, color: '#ddd' })
      .borderRadius(8)

      Text('测试功能:')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin({ top: 10 });

      Scroll() {
        Column({ space: 8 }) {
          // Button('getLocalAddress-2301009')
          Button('getLocalAddress对非套接字进行套接字操作1')
            .onClick(() => this.getLocalAddress_Error1())
            .width('100%')
            .height(40);

          // Button('getLocalAddress-2301009')
          Button('getLocalAddress对非套接字进行套接字操作2')
            .onClick(() => this.getLocalAddress_Error2())
            .width('100%')
            .height(40);

          Button('返回主界面')
            .onClick(() => {
              router.back();
            })
            .width('100%')
            .height(40)
            .backgroundColor('#ff6b81')
            .fontColor(Color.White);
        }
        .width('100%')
      }
      .height('55%')
      .width('90%')
      .scrollBar(BarState.Auto)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor(Color.White)
  }
}