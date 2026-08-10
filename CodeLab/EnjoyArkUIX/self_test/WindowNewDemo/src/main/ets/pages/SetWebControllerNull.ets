// SetWebControllerNull.ets — 测试 setWebController(null) 场景
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

@CustomDialog
struct NewWebViewComp {
  controller?: CustomDialogController;
  webviewController1: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Text('新窗口 (setWebController=null 场景)')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#fa8c16')
        .margin({ top: 10, bottom: 8 })

      Web({ src: $rawfile('newWindow.html'), controller: this.webviewController1 })
        .javaScriptAccess(true)
        .multiWindowAccess(true)
        .layoutWeight(1)
        .width('100%')
        .onWindowExit(() => {
          console.info('NewWebViewComp onWindowExit 触发');
          if (this.controller) {
            this.controller.close();
          }
        })

      Button('关闭新窗口')
        .fontSize(12).height(32)
        .margin({ top: 8, bottom: 10 })
        .onClick(() => {
          if (this.controller) {
            this.controller.close();
          }
        })
    }
    .width('100%')
    .padding(12)
  }
}

@Entry
@Component
struct SetWebControllerNullPage {
  controller: webview.WebviewController = new webview.WebviewController();
  dialogController: CustomDialogController | null = null;

  @State logMessages: string[] = [];

  addLog(msg: string): void {
    const time = new Date().toLocaleTimeString();
    this.logMessages = this.logMessages.concat('[' + time + '] ' + msg);
  }

  clearLogs(): void {
    this.logMessages = [];
  }

  build() {
    Scroll() {
      Column() {
        // ====== 返回按钮（最顶部）======
        Button('<- 返回上层页面')
          .fontSize(14)
          .width('100%')
          .height(40)
          .type(ButtonType.Normal)
          .borderRadius(0)
          .onClick(() => {
            router.back();
          })

        // ====== 标题 ======
        Text('setWebController(null) 测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 12, bottom: 6 })

        Text('测试不创建新窗口时传入 null 的行为')
          .fontSize(12)
          .fontColor('#888888')

        Divider()

        // ====== 日志显示区（置顶）======
        Row() {
          Text('实时日志 (' + this.logMessages.length + ')')
            .fontSize(13).fontColor('#333333').fontWeight(FontWeight.Medium)
          Blank()
          Button('清空').fontSize(11).height(26)
            .onClick(() => { this.clearLogs(); })
        }.width('100%').margin({ left: 8, right: 8 })

        Scroll() {
          Text(this.logMessages.length > 0
            ? this.logMessages.join('\n')
            : '[暂无日志，Web组件加载后点击"打开新窗口"触发测试]')
            .fontSize(10)
            .fontColor(this.logMessages.length > 0 ? '#52c41a' : '#666666')
            .textAlign(TextAlign.Start)
        }
        .scrollable(ScrollDirection.Vertical)
        .width('100%')
        .flexShrink(0)
        .height(160)
        .padding(10)
        .backgroundColor('#1a1a2e')
        .borderRadius(4)
        .margin({ left: 8, right: 8 })

        Divider()

        // ====== 说明信息 ======
        Column() {
          Text('测试说明:')
            .fontSize(13).fontWeight(FontWeight.Medium).alignSelf(ItemAlign.Start)

          Text('setWebController(null) → 通知Web内核未创建新窗口')
            .fontSize(11).fontColor('#fa8c16').alignSelf(ItemAlign.Start).margin({ top: 6 })

          Text('预期行为: onWindowNew 回调触发后, 不弹出CustomDialog, 日志记录 null 设置结果')
            .fontSize(11).fontColor('#666666').alignSelf(ItemAlign.Start).margin({ top: 4 })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#fff7e6')
        .borderRadius(8)
        .margin(8)

        Divider()

        // ====== Web 组件区域 ======
        Text('[Web组件区域]')
          .fontSize(11).fontColor('#888888').alignSelf(ItemAlign.Start).margin({ left: 8 })

        Column() {
          Text('setWebController(null)')
            .fontSize(10).fontColor('#fa8c16')
            .backgroundColor('#fff7e6').borderRadius(4)
            .padding({ left: 6, right: 4, top: 2, bottom: 2 })
            .alignSelf(ItemAlign.Start)

          Web({ src: $rawfile('window.html'), controller: this.controller })
            .javaScriptAccess(true)
            .multiWindowAccess(true)
            .allowWindowOpenMethod(true)
            .onWindowNew((event) => {
              this.addLog('[onWindowNew回调触发] 捕获到新窗口请求');
              try {
                event.handler.setWebController(null);
                this.addLog('[OK] [成功] setWebController(null) 已调用');
                this.addLog('   → 已通知Web内核：未创建新窗口');
              } catch (error) {
                const errMsg = '[FAIL] [异常] setWebController(null) 失败: ' + JSON.stringify(error);
                this.addLog(errMsg);
              }
            })
            .layoutWeight(1)
            .width('100%')

          Text('点击页面中的链接打开新窗口，观察日志输出')
            .fontSize(10).fontColor('#999999')
            .alignSelf(ItemAlign.Center).margin({ top: 4 })
        }
        .width('100%')
        .padding(8)
        .borderRadius(8)
        .backgroundColor('#ffffff')
        .margin(8)

      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')
  }
}
