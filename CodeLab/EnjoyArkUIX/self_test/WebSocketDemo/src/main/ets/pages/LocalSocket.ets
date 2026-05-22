import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct testLocalSocket {
  @State testResults: string[] = [];
  @State log: string = '';

  private addLog(content: string): void {
    this.log += ` ${content}\n`;
  }

  clearTestLog(): void {
    this.log = "";
  }

  // getLocalAddress正常场景测试
  getLocalAddressLocalSocket(): void {
    this.clearTestLog();
    let client = socket.constructLocalSocketInstance();

    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10);
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    let address: socket.LocalAddress = { address: sandboxPath };

    client.bind(address)
      .then(() => client.getLocalAddress())
      .then((localPath: string) => {
        this.addLog('getLocalAddress 成功: ' + JSON.stringify(localPath));
      })
      .catch((err: BusinessError) => {
        this.addLog('操作失败，错误码: ' + err.code);
      })
      .finally(() => {
        client.close().catch(() => {});
      });
  }

  testUnboundSocket(): void {
    this.clearTestLog();
    let client = socket.constructLocalSocketInstance();
    let context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let randomSuffix = Math.random().toString(36).substring(2, 10); // 8位随机字符串
    let sandboxPath: string = context.filesDir + '/' + randomSuffix;
    console.error(sandboxPath);

    client.bind({ address: sandboxPath })
      .then(() => client.close())
      .then(() => client.getLocalAddress())
      .then(() => {
        this.addLog('❌ 关闭后仍能获取地址？');
      })
      .catch((err: BusinessError) => {
        if (err.code === 2301009) {
          this.addLog('✅ 正确捕获错误：socket 预期（2301009），实际：'+ err.code);
        } else {
          this.addLog(`⚠️ 错误码 ${err.code}（可能是 2301008 或其他）`);
        }
      })
      .finally(() => {
        client.close().catch(() => {});
      });
  }

  goBack(): void {
    router.back();
  }

  build() {
    Column({ space: 20 }) {
      Text('LocalSocket测试')
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

      Button('LocalSocket_getLocalAddress')
        .onClick(() => this.getLocalAddressLocalSocket())
        .width('90%')
        .height(40);

      Button('getLocalAddress-无效的文件描述符')
        .onClick(() => {
          this.testUnboundSocket();
        })
        .width('90%')
        .height(40);

      Button('返回主界面')
        .onClick(() => this.goBack()) // ← 关键：先关 socket 再返回
        .width('90%')
        .height(40);
    }
    .padding(20)
  }
}