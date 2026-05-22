import socket from '@ohos.net.socket';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';

@Entry
@Component
struct MulticastSocketFdTest {
  @State logText: string = '';

  private addLog(content: string) {
    this.logText += `${content}\n`;
    this.logText = this.logText;
  }

  private clearLog() {
    this.logText = '';
  }

  // 只测试getSocketFd核心功能
  private async testSocketFdCore() {
    this.clearLog();

    let multicastSocket: socket.MulticastSocket | null = null;

    try {
      // 1. 创建Socket
      this.addLog('1. 创建MulticastSocket实例...');
      multicastSocket = socket.constructMulticastSocketInstance();
      if (!multicastSocket) {
        this.addLog('❌ 创建失败');
        return;
      }
      this.addLog('✅ 创建成功');

      // 2. 绑定回环地址
      this.addLog('2. 绑定本地回环地址...');
      await multicastSocket.bind({
        address: '127.0.0.1',
        port: 0, // 系统分配端口
        family: 1
      });
      this.addLog('✅ 绑定成功');

      // 3. 测试getSocketFd()
      this.addLog('3. 测试getSocketFd()...');

      // 第一次获取
      const fd1 = await multicastSocket.getSocketFd();
      this.addLog(`   FD1: ${fd1} (${typeof fd1})`);

      // 第二次获取（验证一致性）
      const fd2 = await multicastSocket.getSocketFd();
      this.addLog(`   FD2: ${fd2} (${typeof fd2})`);

      // 第三次获取
      const fd3 = await multicastSocket.getSocketFd();
      this.addLog(`   FD3: ${fd3} (${typeof fd3})`);

      // 验证结果
      if (typeof fd1 === 'number' && fd1 >= 0) {
        this.addLog('✅ FD是有效的非负整数');

        if (fd1 === fd2 && fd2 === fd3) {
          this.addLog('✅ 多次获取FD结果一致');
        } else {
          this.addLog('❌ 多次获取FD结果不一致');
        }
      } else {
        this.addLog('❌ FD无效');
      }

      // 4. 测试Socket基本功能
      this.addLog('4. 测试基本发送功能...');
      const testPort = 9999;
      const testSocket = socket.constructUDPSocketInstance();
      await testSocket.bind({ address: '127.0.0.1', port: testPort, family: 1 });

      // 发送测试数据
      const sendResult = await multicastSocket.send({
        data: 'Test Message',
        address: { address: '127.0.0.1', port: testPort, family: 1 }
      });
      this.addLog(`✅ 发送成功，字节数: ${sendResult}`);

      // 接收测试数据
      testSocket.on('message', () => {
        this.addLog('📨 收到回送数据');
      });

      await new Promise<void>((resolve) => setTimeout(resolve, 1000));
      await testSocket.close();

    } catch (err) {
      const error = err as BusinessError;
      this.addLog(`❌ 测试失败: ${error.code} - ${error.message}`);
    } finally {
      if (multicastSocket) {
        try {
          await multicastSocket.close();
          this.addLog('✅ Socket已清理');
        } catch (e) {
          // 忽略关闭错误
        }
      }
    }
  }

  // 测试错误场景
  private async testErrorScenarios() {
    this.addLog('\n===== 测试错误场景 =====');

    let socketInstance: socket.MulticastSocket | null = null;

    try {
      // 场景1：未绑定就获取FD
      this.addLog('1. 测试：未绑定端口获取FD...');
      socketInstance = socket.constructMulticastSocketInstance();
      const fd = await socketInstance.getSocketFd();
      this.addLog(`   结果: ${fd}`);
    } catch (err) {
      const error = err as BusinessError;
      this.addLog(`✅ 预期错误: ${error.code} - ${error.message}`);
    }

    try {
      // 场景2：关闭后获取FD
      this.addLog('2. 测试：关闭Socket后获取FD...');
      if (!socketInstance) return;

      // 先绑定
      await socketInstance.bind({
        address: '127.0.0.1',
        port: 8888,
        family: 1
      });

      // 然后关闭
      await socketInstance.close();

      // 尝试获取FD
      const fd = await socketInstance.getSocketFd();
      this.addLog(`   结果: ${fd}`);
    } catch (err) {
      const error = err as BusinessError;
      this.addLog(`✅ 预期错误: ${error.code} - ${error.message}`);
    }
  }

  build() {
    Column() {
      Text('UDPsocket_MulticastSocket测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 });

      Button('测试getSocketFd()核心功能')
        .width('90%')
        .height(60)
        .backgroundColor('#007DFF')
        .fontColor('#FFFFFF')
        .borderRadius(8)
        .margin({ top: 20, bottom: 10 })
        .onClick(() => this.testSocketFdCore());

      // Button('测试错误场景')
      //   .width('90%')
      //   .height(40)
      //   .backgroundColor('#FF6B81')
      //   .fontColor('#FFFFFF')
      //   .borderRadius(8)
      //   .margin({ bottom: 10 })
      //   .onClick(() => this.testErrorScenarios());

      Button('清空日志')
        .width('90%')
        .height(40)
        .backgroundColor('#8C8C8C')
        .fontColor('#FFFFFF')
        .borderRadius(8)
        .margin({ bottom: 20 })
        .onClick(() => this.clearLog());
      Button('返回主界面')
        .onClick(() => {
          router.back();
        })

      Scroll() {
        Text(this.logText)
          .fontSize(14)
          .padding(10)
          .textAlign(TextAlign.Start)
          .fontColor('#333333')
      }
      .width('90%')
      .flexGrow(1)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .padding(10)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#FFFFFF');
  }
}