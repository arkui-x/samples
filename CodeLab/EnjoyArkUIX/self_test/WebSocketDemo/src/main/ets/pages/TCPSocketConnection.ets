import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import router from '@ohos.router';
import { data } from '@kit.TelephonyKit';

@Entry
@Component
struct Index {
  @State message: string = 'TCPSocketConnection 测试';
  @State log: string = '';
  private listenAddr: socket.NetAddress = {
    address: '0.0.0.0',
    port: 8080,
    family: 1
  };

  aboutTodisappear():void{
    this.stopTest();
  }
  private tcpServer: socket.TCPSocketServer | null = null;
  private testClient: socket.TCPSocket | null = null;
  private clientConn: socket.TCPSocketConnection | null = null;
  private closeCallback: Callback<void> | null = null;
  private errorCallback: ((err: BusinessError) => void) | null = null;
  private testPort: number = 8080; // 更换新端口

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
            Button('send_callback')
              .onClick(() => this.sendTCPSocketConnectioncallback())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中data为""')
              .onClick(() => this.sendTCPSocketConnectionData())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中data为"11111"')
              .onClick(() => this.sendTCPSocketConnectionDataOne())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"utf-8"')
              .onClick(() => this.sendTCPSocketConnectionEncodingUTF8())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"utf-16be"')
              .onClick(() => this.sendTCPSocketConnectionEncodingUTF16BE())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"utf-16le"')
              .onClick(() => this.sendTCPSocketConnectionEncodingUTF16LE())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"utf-16"')
              .onClick(() => this.sendTCPSocketConnectionEncodingUTF16())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"us-aecii"')
              .onClick(() => this.sendTCPSocketConnectionEncodingUSASCII())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"iso-8859-1"')
              .onClick(() => this.sendTCPSocketConnectionEncodingISO88591())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为undefined')
              .onClick(() => this.sendTCPSocketConnectionEncodingUndefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为""')
              .onClick(() => this.sendTCPSocketConnectionEncoding())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中encoding为"11111"')
              .onClick(() => this.sendTCPSocketConnectionEncodingOne())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中options为null')
              .onClick(() => this.testSendWithNullOptions())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中options为undefined')
              .onClick(() => this.testSendWithUndefinedOptions())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中callback类型错误_undefined')
              .onClick(() => this.testSendWithUndefinedCallback())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback中callback类型错误_null')
              .onClick(() => this.testSendWithNullCallback())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_callback未传入callback')
              .onClick(() => this.testSendWithNullMissCallback())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('send_callback未获取权限')
            //   .onClick(() => this.verifyPictureScenario())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')

            Button('send_Promise')
              .onClick(() => this.sendTCPSocketConnection())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中data为""')
              .onClick(() => this.sendPromiseData())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中data为"11111"')
              .onClick(() => this.sendPromiseDataOne())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"utf-8"')
              .onClick(() => this.sendPromiseEncodingUTF8())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"utf-16be"')
              .onClick(() => this.sendPromiseEncodingUTF16BE())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"utf-16le"')
              .onClick(() => this.sendPromiseEncodingUTF16LE())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"utf-16"')
              .onClick(() => this.sendPromiseEncodingUTF16())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"us-aecii"')
              .onClick(() => this.sendPromiseEncodingUSASCII())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"iso-8859-1"')
              .onClick(() => this.sendPromiseEncodingISO88591())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为undefined')
              .onClick(() => this.sendPromiseEncodingUndefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为""')
              .onClick(() => this.sendPromiseEncoding())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中encoding为"11111"')
              .onClick(() => this.sendPromiseEncodingOne())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中options为null')
              .onClick(() => this.testSendNullOptions())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('send_Promise中options为undefined')
              .onClick(() => this.testSendUndefinedOptions())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('send_Promise未获取权限')
            //   .onClick(() => this.sendVerifyPictureScenario())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')

            Button('close_callback')
              .onClick(() => this.closeTCPSocketConnectioncallback())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('close_callback类型错误_undefined')
              .onClick(() => this.testCloseCallbackTypeUndefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('close_callback类型错误_null')
              .onClick(() => this.testCloseCallbackTypeNull())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('close_callback未传入callback')
              .onClick(() => this.testCloseWithMissingCallback())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('close_callback未获取权限')
            //   .onClick(() => this.closeVerifyPictureScenario())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')


            Button('close_Promise')
              .onClick(() => this.closeTCPSocketConnection())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('close_Promise未获取权限')
            //   .onClick(() => this.closePromiseVerifyPictureScenario())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')

            Button('getRemoteAddress-callback为合法函数')
              .onClick(() => this.getRemoteAddressNormal())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('getRemoteAddress-callback类型错误_undefined')
              .onClick(() => this.testGetRemoteAddressCallbackTypeError())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('getRemoteAddress-callback类型错误_null')
              .onClick(() => this.testGetRemoteAddressCallbackNull())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('getRemoteAddress-未传入callback参数')
              .onClick(() => this.testGetRemoteAddressMissingCallback())
              .width('90%')
              .backgroundColor('#4CAF50')



            // Button('getRemoteAddress未获取权限')
            //   .onClick(() => this.getRemoteAddressVerifyPictureScenario())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')

            Button('getRemoteAddress_Promise')
              .onClick(() => this.getRemoteAddressNormalPromise())
              .width('90%')
              .backgroundColor('#4CAF50')

            // Button('getRemoteAddress_Promise未获取权限')
            //   .onClick(() => this.testGetRemoteAddressPermissionScenario())
            //   .width('90%')
            //   .backgroundColor('#4CAF50')

            Button('getLocalAddress_Promise')
              .onClick(() => this.testGetLocalAddressNormal())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('getLocalAddress_Promise文件描述符无效')
              .onClick(() => this.testGetLocalAddressInvalidFd())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('getSocketFd_Promise')
              .onClick(() => this.getSocketFd())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('on_close_normal')
              .onClick(() => this.on_close_normal())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('on_close_type_null')
              .onClick(() => this.on_close_type_null())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('on_close_type_undefined')
              .onClick(() => this.on_close_type_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('on_close_callback_type_error_undefined')
              .onClick(() => this.on_close_callback_type_error_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('on_close_callback_type_error_null')
              .onClick(() => this.on_close_callback_type_error_null())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_normal')
              .onClick(() => this.off_close_normal())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_type_null')
              .onClick(() => this.off_close_type_null())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_type_undefined')
              .onClick(() => this.off_close_type_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_callback_type_error_undefined')
              .onClick(() => this.off_close_callback_type_error_undefined())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_callback_type_error_null')
              .onClick(() => this.off_close_callback_type_error_null())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_missing_callback')
              .onClick(() => this.off_close_missing_callback())
              .width('90%')
              .backgroundColor('#4CAF50')

            Button('off_close_special')
              .onClick(() => this.off_close_special())
              .width('90%')
              .backgroundColor('#4CAF50')
          }
          .width('100%') // 内部Column宽度设为100%
        }
        .height('50%') // 为Scroll区域设置一个明确的高度，这是关键！
        .width('100%')

        // 3. 底部固定区域
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

        Row() {
          Button('← 返回')
            .width('30%')
            .padding({ left: 15, right: 15 })
            .backgroundColor('#4CAF50')
            .onClick(() => {
              router.back();
            })

          Button('启动环境')
            .onClick(() => this.setupTestEnv())
            .padding({ left: 15, right: 15 })
            .width('30%')
            .backgroundColor('#ff9800')

          Button('清理环境')
            .width('30%')
            .padding({ left: 15, right: 15 })
            .backgroundColor('#4CAF50')
            .onClick(() => this.stopTest())
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(10)
    }
    .height('100%')
    .backgroundColor('#f9f9f9')
  }

  clearTestLog(): void {
    this.log = "";
  }

  // 字符串转ArrayBuffer
  private stringToArrayBuffer(str: string): ArrayBuffer {
    const buffer = new ArrayBuffer(str.length);
    const dataView = new Uint8Array(buffer);
    for (let i = 0; i < str.length; i++) {
      dataView[i] = str.charCodeAt(i);
    }
    return buffer;
  }

  private stringToUtf16BeArrayBuffer(str: string): ArrayBuffer {
    if (str.length === 0) {
      return new ArrayBuffer(0);
    }

    // UTF-16BE：每个字符占 2 字节
    const buffer = new ArrayBuffer(str.length * 2);
    const view = new DataView(buffer);

    for (let i = 0; i < str.length; i++) {
      // 获取 Unicode 码点（0~65535）
      const code = str.charCodeAt(i);
      // 写入大端序：高位字节在前
      view.setUint16(i * 2, code, false); // false = 大端序 (BE)
    }

    return buffer;
  }

  private stringToUtf16LeArrayBuffer(str: string): ArrayBuffer {
    if (str.length === 0) return new ArrayBuffer(0);

    const buffer = new ArrayBuffer(str.length * 2);
    const view = new DataView(buffer);

    for (let i = 0; i < str.length; i++) {
      view.setUint16(i * 2, str.charCodeAt(i), true); // true = 小端序 (LE)
    }
    return buffer;
  }

  private stringToUtf16ArrayBuffer(str: string, withBom: boolean = true): ArrayBuffer {
    if (str.length === 0) {
      return withBom ? new ArrayBuffer(2) : new ArrayBuffer(0);
    }

    const bomSize = withBom ? 2 : 0;
    const buffer = new ArrayBuffer(bomSize + str.length * 2);
    const view = new DataView(buffer);

    // 写入 BOM（LE 格式：FF FE）
    if (withBom) {
      view.setUint8(0, 0xFF);
      view.setUint8(1, 0xFE);
    }

    // 写入字符串（小端序）
    const start = bomSize;
    for (let i = 0; i < str.length; i++) {
      view.setUint16(start + i * 2, str.charCodeAt(i), true); // LE
    }
    return buffer;
  }

  private addLog(content: string) {
    this.log += `${content}\n`;
  }

  private stopTest(): void {
  this.clearTestLog();
  this.addLog('开始清理资源...');

  // 清理客户端连接
  this.cleanupClientConnection();

  // 清理客户端
  this.cleanupTestClient();

  // 清理服务器
  this.cleanupTcpServer();

  // 重置状态
  this.resetNetworkState();

  setTimeout(():void=>this.addLog('资源清理完成'),500);
}

private cleanupClientConnection(): void {
  if (!this.clientConn) {
    return;
  }
  try {
    // 取消事件监听
    this.clientConn.off('close');
    this.clientConn.off('message');
    
    // 关闭连接
    this.clientConn.close((err: BusinessError) => {
      if (err) {
        console.error(`关闭连接失败: ${err.message}`);
      } else {
        console.info('客户端连接已关闭');
      }
    });
  } catch (error) {
    console.error('清理客户端连接时出错:', error);
  } finally {
    this.clientConn = null;
    //this.addLog('客户端连接已清理');
  }
}

private cleanupTestClient(): void {
  if (!this.testClient) {
    return;
  }

  try {
    // 取消所有事件监听
    this.testClient.off('close');
    this.testClient.off('error');
    this.testClient.off('message');

    // 关闭客户端
    this.testClient.close((err: BusinessError) => {
      if (err) {
        console.error(`关闭连接失败: ${err.message}`);
      } else {
        console.info('客户端已关闭');
      }
    });
  } catch (error) {
    console.error('清理测试客户端时出错:', error);
  } finally {
    this.testClient = null;
    //this.addLog('测试客户端已关闭');
  }
}

private cleanupTcpServer(): void {
  if (!this.tcpServer) {
    return;
  }

  try {
    // 取消所有事件监听
    this.tcpServer.off('connect');

    // 关闭服务器
    this.tcpServer.close();
  } catch (error) {
    console.error('清理TCP服务器时出错:', error);
  } finally {
    this.tcpServer = null;
    //this.addLog('TCP服务器已关闭');
  }
}

private resetNetworkState(): void {
  this.testPort = 8080;
  this.currentSendEncoding = 'utf-8';
  //this.addLog('网络状态已重置');
}

  private setupTestEnv() {
    if (this.tcpServer && this.clientConn) {
      this.addLog('测试环境已启动，无需重复启动');
      return;
    }
    this.tcpServer = socket.constructTCPSocketServerInstance();
    this.tcpServer.listen(this.listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务器启动失败: ${err.message}`);
        this.tcpServer = null;
        return;
      }
    });
    this.testClient = socket.constructTCPSocketInstance();
    const clientOpts: socket.TCPConnectOptions = {
      address: { address: '127.0.0.1', port: 8080, family: 1 } as socket.NetAddress,
      timeout: 5000
    };
    this.setupClientEvents();
    this.testClient.connect(clientOpts, (err: BusinessError) => {
      if (err) {
        this.addLog(`客户端连接失败: ${err.message}`);
        return;
      }
      this.addLog('客户端连接服务器成功');
    });

    this.tcpServer.on('connect', (client: socket.TCPSocketConnection) => {
      this.clientConn = client;
      console.info("connection clientId: " + client.clientId);
      this.addLog("connection clientId: " + client.clientId);
      // 新增：调用 setupConnectionEvents 绑定服务端客户端连接事件
      this.setupConnectionEvents(this.clientConn);
    });
  }

  // 1. 新增：setupConnectionEvents（参考TLS同名方法，适配TCP）
  private setupConnectionEvents(client: socket.TCPSocketConnection): void {
    client.on('close', () => {
      //this.addLog('客户端连接已关闭'); // 沿用你的 addLog 方法，与原有日志风格一致
    });

    client.on('message', (data: socket.SocketMessageInfo) => {
      this.handleClientMessage(data);
    });
  }

  // 2. 新增：setupClientEvents（参考TLS同名方法，适配TCP）
  private setupClientEvents(): void {
    if (!this.testClient) return;

    this.testClient.on('close', () => {
      this.addLog('客户端连接关闭');
    });

    this.testClient.on('error', (err: BusinessError) => {
      this.addLog(`客户端错误: ${err.code} - ${err.message}`);
    });

    this.testClient.on('message', (data: socket.SocketMessageInfo) => {
      this.handleServerMessage(data);
    });
  }

  // 3. 新增：handleClientMessage（与TLS同名方法逻辑完全一致）
  private handleClientMessage(data: socket.SocketMessageInfo): void {
    try {
      const message = new Uint8Array(data.message);
      this.addLog(`收到客户端消息，长度: ${message.length}`);
    } catch (err) {
      this.addLog(`处理客户端消息错误: ${err}`);
    }
  }

  private currentSendEncoding: string = 'utf-8';
  // 4. 新增：handleServerMessage（与TLS同名方法逻辑完全一致）
  private handleServerMessage(data: socket.SocketMessageInfo): void {
    try {
      let content = '';
      const message: ArrayBuffer = data.message;
      content = this.arrayBufferToString(message, this.currentSendEncoding);
      if (message.byteLength === 0) {
        this.addLog(`收到服务器消息：（长度: 0）`);
      } else {
        this.addLog(`收到服务器消息，长度：${message.byteLength},内容: ${content}`);
      }
    } catch (error) {
      const errMsg = error instanceof Error ? error.message : String(error);
      this.addLog(`处理服务器消息错误: ${errMsg}`);
      console.error(`处理服务器消息错误: ${errMsg}`)
    }
  }
  
  private arrayBufferToString(buffer: ArrayBuffer, encoding: string): string {
    const uint8Data = new Uint8Array(buffer);
    let result = '';

    console.error(encoding)
    switch (encoding.toLowerCase()) {
      // 处理UTF-16BE（你发送的格式）
      case 'utf-16be':
        // ✅ 正确：使用 DataView 以大端序解析
        const view = new DataView(buffer);
        const len = buffer.byteLength / 2;
        const chars: number[] = []; // ArkTS 必须显式声明类型

        for (let i = 0; i < len; i++) {
          chars.push(view.getUint16(i * 2, false)); // false = 大端序 (BE)
        }

        return String.fromCharCode(...chars)
        console.error(result)
        break;

      case 'utf-16le':
        // ✅ 正确：使用 DataView 以小端序解析
        const viewLe = new DataView(buffer);
        const lenLe = buffer.byteLength / 2;
        const charsLe: number[] = [];
        for (let i = 0; i < lenLe; i++) {
          charsLe.push(viewLe.getUint16(i * 2, true as boolean)); // true = 小端序
        }
        result = String.fromCharCode(...charsLe);
        console.error(result)
        break;

      case 'utf-16':
        // 处理带 BOM 的 UTF-16（自动检测字节序）
        if (buffer.byteLength >= 2) {
          const b0 = uint8Data[0];
          const b1 = uint8Data[1];
          if (b0 === 0xFE && b1 === 0xFF) {
            // BE BOM
            const view = new DataView(buffer, 2); // 跳过 BOM
            const len = (buffer.byteLength - 2) / 2;
            const chars: number[] = [];
            for (let i = 0; i < len; i++) {
              chars.push(view.getUint16(i * 2, false as boolean));
            }
            result = String.fromCharCode(...chars);
          } else if (b0 === 0xFF && b1 === 0xFE) {
            // LE BOM
            const view = new DataView(buffer, 2);
            const len = (buffer.byteLength - 2) / 2;
            const chars: number[] = [];
            for (let i = 0; i < len; i++) {
              chars.push(view.getUint16(i * 2, true as boolean));
            }
            result = String.fromCharCode(...chars);
          } else {
            // 无 BOM → 默认按小端序（但强烈建议指定明确字节序）
            const view = new DataView(buffer);
            const len = buffer.byteLength / 2;
            const chars: number[] = [];
            for (let i = 0; i < len; i++) {
              chars.push(view.getUint16(i * 2, true as boolean));
            }
            result = String.fromCharCode(...chars);
          }
        } else {
          result = String.fromCharCode(...uint8Data);
        }
        console.error(result)
        break;
      // 处理UTF-8（默认）
      case 'utf-8':
        result = String.fromCharCode(...uint8Data);
        break;
      // 其他编码可扩展（如ascii）
      case 'aecii':
        result = String.fromCharCode(...uint8Data);
        break;

      case 'us-aecii':
        result = uint8Data.reduce((acc, byte) => {
          return acc + String.fromCharCode(byte & 0x7F);
        }, '');
        break;

      case 'iso-8859-1':
        result = uint8Data.reduce((acc, byte) => {
          return acc + String.fromCharCode(byte & 0xFF);
        }, '');
        break;

      default:
        result = String.fromCharCode(...uint8Data);
        break;
    }
    return result;
  }

  // 测试回调方式的send
  private sendTCPSocketConnectioncallback(): void {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-8';

    let tcpSendOption: socket.TCPSendOptions = {
      data: ('Hello, client! from callback')
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send 回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中options为null
  private testSendWithNullOptions() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    try {
      this.clientConn.send(null!, (err: BusinessError) => {
        if (err) {
          this.addLog(`错误码: ${err.code}, 信息: ${err.message}`);
        }
      });
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // options为undefined作为参数测试
  private testSendWithUndefinedOptions() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    try {
      this.clientConn.send(undefined!, (err: BusinessError) => {
        if (err) {
          this.addLog(`错误码: ${err.code}, 信息: ${err.message}`);
        }
      });
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // send中data为""
  private sendTCPSocketConnectionData() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-8';

    let tcpSendOption: socket.TCPSendOptions = {
      data: ""
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中data为"11111"
  private sendTCPSocketConnectionDataOne() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-8';

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer("11111")
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为'utf-8'
  private sendTCPSocketConnectionEncodingUTF8() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-8';

    let tcpSendOption: socket.TCPSendOptions = {
      data: 'Hello, client! from callback utf-8',
      encoding: 'utf-8'
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为'utf-16be'
  private sendTCPSocketConnectionEncodingUTF16BE() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-16be';

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToUtf16BeArrayBuffer('Hello, client! from callback utf-16be '),
      encoding: 'utf-16be'
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为'utf-16le'
  private sendTCPSocketConnectionEncodingUTF16LE() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-16le';

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToUtf16LeArrayBuffer('Hello, client! from callback utf-16le '),
      encoding: 'utf-16le'
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为'utf-16'
  private sendTCPSocketConnectionEncodingUTF16() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'utf-16';

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToUtf16ArrayBuffer('Hello, client! from callback utf-16 '),
      encoding: 'utf-16'
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为'us-aecii'
  private sendTCPSocketConnectionEncodingUSASCII() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'us-aecii';

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from callback us-aecii'),
      encoding: 'us-aecii'
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为'iso-8859-1'
  private sendTCPSocketConnectionEncodingISO88591() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    this.currentSendEncoding = 'iso-8859-1';

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from callback iso-8859-1'),
      encoding: 'iso-8859-1'
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为undefined
  private sendTCPSocketConnectionEncodingUndefined() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from callback'),
      encoding: undefined
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为""
  private sendTCPSocketConnectionEncoding() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from callback'),
      encoding: ""
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send中encoding为"11111"
  private sendTCPSocketConnectionEncodingOne() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from callback'),
      encoding: "11111"
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }

  // send函数中未传入callback参数
  private testSendWithNullMissCallback() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    try {
      const validOptions: socket.TCPSendOptions = {
        data: this.stringToArrayBuffer('Hello, client! from callback')
      };

      this.clientConn.send(validOptions,)
          console.info("send success "+ JSON.stringify(validOptions));
          this.addLog('send success' + JSON.stringify(validOptions));
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // send函数中callback类型错误Undefined
  private testSendWithUndefinedCallback() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    try {
      const validOptions: socket.TCPSendOptions = {
        data: this.stringToArrayBuffer('Hello, client! from callback')
      };
      this.clientConn.send(validOptions, undefined!);
      this.addLog('已调用send（callback为undefined）');

    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // send函数中callback类型错误Null
  private testSendWithNullCallback() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    try {
      const validOptions: socket.TCPSendOptions = {
        data: this.stringToArrayBuffer('Hello, client! from callback')
      };
      this.clientConn.send(validOptions, null!);
      this.addLog('已调用send（callback为null）');

    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // send未获取权限
  private async verifyPictureScenario() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    try{
    this.currentSendEncoding = 'utf-8';

    let tcpSendOption: socket.TCPSendOptions = {
      data: ('Hello, client! from callback')
    }
    this.clientConn.send(tcpSendOption, (err: BusinessError) => {
      if (err) {
        this.addLog('send回调失败: ' + err.code);
        console.error("send fail: " + JSON.stringify(err));
      } else {
        this.addLog('send 回调成功 - 数据发送成功');
        console.info("send success");
      }
    });
  }catch (err) {
      this.addLog(`callback回调触发 - 错误码: ${err.code}, 错误信息: ${err.message}`);
      console.error("connect fail: " + JSON.stringify(err));
    }
  }

  // 测试Promise方式的send
  private sendTCPSocketConnection() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from Promise')
    }
    this.clientConn.send(tcpSendOption).then(() => {
        console.info("send success "+ JSON.stringify(tcpSendOption));
        this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send fail: ' + err.message);
    });
  }

  // options为null
  private testSendNullOptions() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    try {
      this.clientConn.send(null).then(() => {
        this.addLog('测试失败：null options场景未触发错误');
      }).catch((err: BusinessError) => {
        this.addLog(`Promise rejected - 错误码: ${err.code}, 信息: ${err.message}`);
      });
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // options为undefined
  private testSendUndefinedOptions() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    try {
      this.clientConn.send(undefined).then(() => {
        this.addLog('测试失败：undefined options场景未触发错误');
      }).catch((err: BusinessError) => {
        this.addLog(`异常，错误码: ${err.code}, 信息: ${err.message}`);
      });
    } catch (error) {
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // send_Promise中data为""
  private sendPromiseData() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer("")
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send fail: ' + err.message);
    });
  }

  // send_Promise中data为"11111"
  private sendPromiseDataOne() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer("11111")
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send fail: ' + err.message);
    });
  }

  // send_Promise中encoding为"utf-8"
  private sendPromiseEncodingUTF8() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from Promise utf-8'),
      encoding: "utf-8"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为"utf-16be"
  private sendPromiseEncodingUTF16BE() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-16be';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToUtf16BeArrayBuffer('Hello, client! from Promise utf-16be'),
      encoding: "utf-16be"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为"utf-16le"
  private sendPromiseEncodingUTF16LE() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-16le';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToUtf16LeArrayBuffer('Hello, client! from Promise utf-16le'),
      encoding: "utf-16le"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为"utf-16"
  private sendPromiseEncodingUTF16() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-16';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToUtf16ArrayBuffer('Hello, client! from Promise utf-16'),
      encoding: "utf-16"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为"us-aecii"
  private sendPromiseEncodingUSASCII() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'us-aecii';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from Promise us-aecii'),
      encoding: "us-aecii"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为"iso-8859-1"
  private sendPromiseEncodingISO88591() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'iso-8859-1';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from Promise iso-8859-1'),
      encoding: "iso-8859-1"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为undefined
  private sendPromiseEncodingUndefined() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from Promise'),
      encoding: undefined
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为""
  private sendPromiseEncoding() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from Promise'),
      encoding: ""
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise中encoding为"11111"
  private sendPromiseEncodingOne() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.currentSendEncoding = 'utf-8';
    let tcpSendOption: socket.TCPSendOptions = {
      data: this.stringToArrayBuffer('Hello, client! from callback'),
      encoding: "11111"
    }
    this.clientConn.send(tcpSendOption).then(() => {
      console.info("send success "+ JSON.stringify(tcpSendOption));
      this.addLog('send Promise成功'+ JSON.stringify(tcpSendOption));
    }).catch((err: BusinessError) => {
      console.info("send fail "+JSON.stringify(err) );
      this.addLog('send Promise失败: ' + err.message);
    });
  }

  // send_Promise未获取权限
  private async sendVerifyPictureScenario(): Promise<void> {
    this.clearTestLog();
    let tcpClient: socket.TCPSocket = socket.constructTCPSocketInstance();
    try {
      let connectOptions: socket.TCPConnectOptions = {
        address: {
          address: '0.0.0.0',
          port: 8080,
          family: 1
        } as socket.NetAddress,
        timeout: 5000
      };

      await tcpClient.connect(connectOptions);
      let options: socket.TCPSendOptions = {
        data: this.stringToArrayBuffer('验证数据')
      };
      tcpClient.send(options).then((result: void | undefined): void => {
        if (result == undefined) {
          console.info("send success "+ JSON.stringify(options));
          this.addLog('send Promise成功且Promise返回为空');
        }
      }).catch((err: BusinessError): void => {
        console.info("send fail "+JSON.stringify(err) );
        this.addLog('send Promise失败: ' + err.message);
      });

    } catch (err) {
      this.addLog(`send调用失败 - 错误码: ${(err as BusinessError).code}, 错误信息: ${(err as Error).message}`);
    }
  }

  // 测试回调方式的close
  private closeTCPSocketConnectioncallback() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    try {
      this.clientConn.close((err: BusinessError) => {
        if (err) {
          this.addLog('close回调失败: ' + err.message);
          console.info("close fail " + JSON.stringify(err));
          this.clientConn = null;
          return;
        } else {
          this.addLog('callback无err参数');
        }
        this.addLog('close回调成功');
        console.info("close success");
        this.clientConn = null;
      });
    } catch (err) {
      this.addLog('close操作异常: ' + (err as Error).message);
      this.clientConn = null;
    }
  }

  // close-callback类型错误undefined
  private testCloseCallbackTypeUndefined() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('请先启动测试环境');
      return;
    }

    try {
      this.clientConn.close(undefined!);
      this.addLog('已调用close（类型错误的callback）');

    } catch (err) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
  }

  // close-callback类型错误null
  private testCloseCallbackTypeNull() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('请先启动测试环境');
      return;
    }

    try {
      this.clientConn.close(null!);
      this.addLog('已调用close（类型错误的callback）');

    } catch (err) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`异常，错误码: ${(err as BusinessError).code}, 信息: ${(err as Error).message}`);
    }
  }

  // close-未传入callback参数
  private testCloseWithMissingCallback() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('请先启动测试环境');
      return;
    }

    try {
      this.clientConn.close()
          this.addLog('close success');
          console.info("close success" );
          this.clientConn = null;
    } catch (error) {
      this.addLog('成功捕获未传入callback错误');
      this.addLog(`异常，错误码: ${error.code}, 信息: ${error.message}`);
    }
  }

  // close回调未获取权限
  private async closeVerifyPictureScenario(): Promise<void> {
    this.clearTestLog();
    let tcpClient: socket.TCPSocket = socket.constructTCPSocketInstance();
    try {
      let connectOptions: socket.TCPConnectOptions = {
        address: {
          address: '0.0.0.0',
          port: 8080,
          family: 1
        } as socket.NetAddress,
        timeout: 5000
      };

      await tcpClient.connect(connectOptions);
      tcpClient.close((err: BusinessError): void => {
        if (err) {
          this.addLog('close回调失败: ' + err.message);
          console.info("close fail " + JSON.stringify(err));
          return;
        } else {
          this.addLog('callback无err参数');
        }
        this.addLog('close回调成功');
        console.info("close success");
      });
    } catch (err) {
      this.addLog(`close调用失败 - 错误码: ${(err as BusinessError).code}, 错误信息: ${(err as Error).message}`);
    }
  }

  // 测试Promise方式的close
  private closeTCPSocketConnection(): void {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }

    this.clientConn.close().then((result: void | undefined): void => {
      if (result == undefined) {
        this.addLog('close Promise成功，且Promise返回为空');
        console.info("close success" );
      }
      this.clientConn = null;
    }).catch((err: BusinessError): void => {
      console.info("close fail " + JSON.stringify(err));
      this.addLog(`错误码: ${err.code}, 错误信息: ${err.message}`);
    });
  }

  // close_Promise未获取权限
  private async closePromiseVerifyPictureScenario(): Promise<void> {
    this.clearTestLog();
    let tcpClient: socket.TCPSocket = socket.constructTCPSocketInstance();
    try {
      let connectOptions: socket.TCPConnectOptions = {
        address: {
          address: '0.0.0.0',
          port: 8080,
          family: 1
        } as socket.NetAddress,
        timeout: 5000
      };

      await tcpClient.connect(connectOptions);
      tcpClient.close().then((result: void | undefined): void => {
        if (result == undefined) {
          this.addLog('close Promise成功，且Promise返回为空');
          console.info("close success" );
        }
      }).catch((err: BusinessError): void => {
        this.addLog(`close调用失败 - 错误码: ${err.code}, 错误信息: ${err.message}`);
      });
    } catch (err) {
      this.addLog(`close调用失败 - 错误码: ${(err as BusinessError).code}, 错误信息: ${(err as Error).message}`);
    }
  }

  // getRemoteAddress-callback为合法函数
  private getRemoteAddressNormal() {
    this.clearTestLog();
    try {
      if (!this.clientConn) {
        throw new Error('请先启动测试环境，确保客户端连接已建立');
      }
      this.clientConn.getRemoteAddress((err: BusinessError, data: socket.NetAddress) => {
        if (err) {
          this.addLog(`getRemoteAddress失败: code = ${err.code}, message = ${err.message}`);
          console.error('getRemoteAddress fail: ' + JSON.stringify(err));
          return;
        }
        this.addLog('getRemoteAddress成功');
        this.addLog(`远程地址: ${data.address}，远程端口: ${data.port}`);
        console.info('getRemoteAddress success: ' + JSON.stringify(data));
      });
    } catch (error) {
      this.addLog(`异常信息: ${error.message}`);
    }
  }

  // getRemoteAddress-未传入callback参数
  private testGetRemoteAddressMissingCallback() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('请先启动测试环境');
      return;
    }
    try {
      this.clientConn.getRemoteAddress()
        this.addLog('getRemoteAddress成功');
    } catch (error) {
      this.addLog('成功捕获未传入callback错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // getRemoteAddress-callback类型错误undefined
  private testGetRemoteAddressCallbackTypeError() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    try {
      this.clientConn.getRemoteAddress(undefined!);
      this.addLog('已调用getRemoteAddress（类型错误的callback）');

    } catch (error) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // getRemoteAddress-callback类型错误null
  private testGetRemoteAddressCallbackNull() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    try {
      this.clientConn.getRemoteAddress(null!);
      this.addLog('已调用getRemoteAddress（类型错误的callback）');

    } catch (error) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // getRemoteAddress未获取权限
  private async getRemoteAddressVerifyPictureScenario(): Promise<void> {
    this.clearTestLog();
    let tcpClient: socket.TCPSocket = socket.constructTCPSocketInstance();
    try {
      let connectOptions: socket.TCPConnectOptions = {
        address: {
          address: '0.0.0.0',
          port: 8080,
          family: 1
        } as socket.NetAddress,
        timeout: 5000
      };

      await tcpClient.connect(connectOptions);
      tcpClient.getRemoteAddress((err: BusinessError, data: socket.NetAddress): void => {
        if (err) {
          this.addLog(`getRemoteAddress失败: code = ${err.code}, message = ${err.message}`);
          console.error('getRemoteAddress fail: ' + JSON.stringify(err));
          return;
        }
        this.addLog('getRemoteAddress成功');
        this.addLog(`远程地址: ${data.address}，远程端口: ${data.port}`);
        console.info('getRemoteAddress success: ' + JSON.stringify(data));
      });
    } catch (err) {
      this.addLog(`getRemoteAddress_callback调用失败 - 错误码: ${(err as BusinessError).code}, 错误信息: ${err.message}`);
    }
  }

  // getRemoteAddress-promise形式
  private getRemoteAddressNormalPromise(): void {
    this.clearTestLog();
    try {
      if (!this.clientConn) {
        throw new Error('请先启动测试环境，确保客户端连接已建立');
      }
      this.clientConn.getRemoteAddress().then((data: socket.NetAddress): void => {
        this.addLog('getRemoteAddress成功');
        this.addLog(`远程地址: ${data.address}，远程端口: ${data.port}`);
        console.info('getRemoteAddress success: ' + JSON.stringify(data));
      }).catch((error: BusinessError): void => {
        this.addLog(`getRemoteAddress失败: ${error.message}`);
        console.error('getRemoteAddress fail: ' + JSON.stringify(error));
      });
    } catch (error) {
      this.addLog(`异常信息: ${error.message}`);
    }
  }

  // getRemoteAddress-promise未获取权限
  private async testGetRemoteAddressPermissionScenario(): Promise<void> {
    this.clearTestLog();
    let tcpClient: socket.TCPSocket = socket.constructTCPSocketInstance();
    try {
      let connectOptions: socket.TCPConnectOptions = {
        address: {
          address: '0.0.0.0',
          port: 8080,
          family: 1
        } as socket.NetAddress,
        timeout: 5000
      };

      await tcpClient.connect(connectOptions);
      tcpClient.getRemoteAddress().then((data: socket.NetAddress): void => {
        this.addLog('getRemoteAddress成功');
        this.addLog(`远程地址: ${data.address}，远程端口: ${data.port}`);
        console.info('getRemoteAddress success: ' + JSON.stringify(data));
      }).catch((error: BusinessError): void => {
        this.addLog(`getRemoteAddress失败: ${error.message}`);
        console.error('getRemoteAddress fail: ' + JSON.stringify(error));
      });
    } catch (err) {
      this.addLog(`getRemoteAddress_promise调用失败 - 错误码: ${(err as BusinessError).code}, 错误信息: ${err.message}`);
    }
  }

  // getLocalAddress正常
  private testGetLocalAddressNormal() {
    this.clearTestLog();
    this.clientConn?.getLocalAddress().then((localAddress: socket.NetAddress): void => {
      console.info("Family IP Port: " + JSON.stringify(localAddress));
      this.addLog("Family IP Port: " + JSON.stringify(localAddress));
    }).catch((err: BusinessError): void => {
      this.addLog('Error:' + JSON.stringify(err));
    });
  }

  // getLocalAddress无效的文件描述符
  private testGetLocalAddressInvalidFd() {
    this.clearTestLog();
    let tcpServer: socket.TCPSocketServer = socket.constructTCPSocketServerInstance();
    let listenAddr: socket.NetAddress = {
      address: "0.0.0.0",
      port: 8080,
      family: 1
    }

    tcpServer.listen(listenAddr, (err: BusinessError) => {
      if (err) {
        this.addLog(`服务器启动失败: ${err.message}`);
        return;
      }

      let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
      let netAddress: socket.NetAddress = {
        address: "127.0.0.1",
        port: 8080
      }
      let options: socket.TCPConnectOptions = {
        address: netAddress,
        timeout: 6000
      }

      tcp.connect(options, (err: BusinessError) => {
        if (err) {
          this.addLog(`连接失败: ${err.message}`);
          return;
        }
        tcp.close().then(() => {
          tcp.getLocalAddress().then((localAddress: socket.NetAddress) => {
            this.addLog('无效文件描述符场景未触发错误');

          }).catch((err: BusinessError) => {
            if (err.code === 2301009) {
              this.addLog('成功触发无效文件描述符错误');
              this.addLog(`预期错误码: 2301009，实际: ${err.code}`);
            } else {
              this.addLog(`非预期错误码: ${err.code}`);
            }
          }).finally(() => {
            tcp.close();
          });
        });
      });
    });
  }

  private getSocketFd() {
    this.clearTestLog();
    if (!this.clientConn) {
      this.addLog('先启动测试环境');
      return;
    }
    try {
      this.clientConn.getSocketFd().then((data: number) => {
        console.info("getSocketFd成功，Fd：" + data);
        this.addLog("getSocketFd成功，Fd：" + data);
      }).catch((err: BusinessError) => {
        console.error(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
        this.addLog(`getSocketFd失败, fail: ${err.code}, 信息: ${err.message}`);
      });
    } catch (error) {
      this.addLog(`异常信息: ${error.message}`);
    }
  }

  // on_close
  private on_close_normal() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('on close success');
      console.info("on close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.on('close', this.closeCallback);
        this.clientConn.close();
        this.addLog('订阅close事件成功');
      } else {
        this.addLog('clientConn为null，无法执行on操作');
      }
    } catch (error) {
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // on_close的type为null
  private on_close_type_null() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('on close success');
      console.info("on close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.on(null, this.closeCallback);
        this.addLog('订阅close事件成功');
      } else {
        this.addLog('clientConn为null，无法执行on操作');
      }
    } catch (error) {
      this.addLog('成功捕获type为null错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // on_close的type为undefined
  private on_close_type_undefined() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('on close success');
      console.info("on close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.on(undefined, this.closeCallback);
        this.addLog('订阅close事件成功');
      } else {
        this.addLog('clientConn为null，无法执行on操作');
      }
    } catch (error) {
      this.addLog('成功捕获type为undefined错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // on_close的callback类型错误
  private on_close_callback_type_error_undefined() {
    this.clearTestLog();
    try {
      if (this.clientConn != null) {
        this.clientConn.on('close', undefined!);
        this.addLog('订阅close事件成功');
      } else {
        this.addLog('clientConn为null，无法执行on操作');
      }
    } catch (error) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // on_close的callback类型错误
  private on_close_callback_type_error_null() {
    this.clearTestLog();
    try {
      if (this.clientConn != null) {
        this.clientConn.on('close', null!);
        this.addLog('订阅close事件成功');
      } else {
        this.addLog('clientConn为null，无法执行on操作');
      }
    } catch (error) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close
  private off_close_normal() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('on close success');
      console.info("on close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.on('close', this.closeCallback);
        this.clientConn.off('close', this.closeCallback);
        this.addLog('取消订阅close事件成功');
        this.clientConn.close();
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close的type为null
  private off_close_type_null() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('off close success');
      console.info("off close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.off(null, this.closeCallback);
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog('成功捕获type为null错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close的type为undefined
  private off_close_type_undefined() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('off close success');
      console.info("off close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.off(undefined, this.closeCallback);
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog('成功捕获type为undefined错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close的callback类型错误
  private off_close_callback_type_error_undefined() {
    this.clearTestLog();
    try {
      if (this.clientConn != null) {
        this.clientConn.off('close', undefined!);
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close的callback类型错误
  private off_close_callback_type_error_null() {
    this.clearTestLog();
    try {
      if (this.clientConn != null) {
        this.clientConn.off('close', null!);
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog('成功捕获callback类型错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close的未传入callback参数
  private off_close_missing_callback() {
    this.clearTestLog();
    this.closeCallback = (): void => {
      this.addLog('on close success');
      console.info("on close success");
    };

    try {
      if (this.clientConn != null) {
        this.clientConn.on('close', this.closeCallback);
        this.clientConn.off('close');
        this.addLog('取消订阅close事件成功');
        this.clientConn.close();
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  // off_close的特殊场景测试
  private off_close_special() {
    this.clearTestLog();
    let callback1 = () => {
      this.addLog("on close1 success");
    }
    let callback2 = () => {
      this.addLog("on close2 success");
    }
    let callback3 = () => {
      this.addLog("on close3 success");
    }
    try {
      if (this.clientConn != null) {
        this.clientConn.on('close', callback1);
        this.clientConn.on('close', callback2);
        this.clientConn.on('close', callback3);
        this.clientConn.off('close', callback1);
        this.clientConn.off('close');
        this.clientConn.close();
        this.addLog('清空所有订阅成功');
      } else {
        this.addLog('clientConn为null，无法执行off操作');
      }
    } catch (error) {
      this.addLog('成功捕获未传入callback错误');
      this.addLog(`错误码: ${error.code}, 错误信息: ${error.message}`);
    }
  }

  aboutToDisappear(): void {
    if (this.tcpServer) {
      this.tcpServer.close().catch();
    }
    if (this.testClient) {
      this.testClient.close().catch();
    }
    this.stopTest();
  }
}