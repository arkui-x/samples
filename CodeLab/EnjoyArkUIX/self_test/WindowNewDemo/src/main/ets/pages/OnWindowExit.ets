// OnWindowExit.ets — 测试 onWindowExit 回调场景
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

// ========== 子窗口 Dialog 组件 ==========
@CustomDialog
struct NewWebViewDialog {
  controller?: CustomDialogController;
  webviewController1: webview.WebviewController = new webview.WebviewController();
  onPageEndLog?: (msg: string) => void;
  onExitLog?: (msg: string) => void;

  build() {
    Column() {
      Text('子窗口 (onWindowExit 监听)')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#13c2c2')
        .margin({ top: 10, bottom: 8 })

      Web({ src: $rawfile('newWindow.html'), controller: this.webviewController1 })
        .javaScriptAccess(true)
        .multiWindowAccess(false)
        .layoutWeight(1)
        .width('100%')
        .onPageEnd((event) => {
          const msg = '[子Web] 页面加载完成, URL=' + (event.url ?? 'null');
          console.info(msg);
          if (this.onPageEndLog) {
            this.onPageEndLog(msg);
          }
        })
        .onWindowExit(() => {
          const msg = '[子Web] onWindowExit 触发!';
          console.info(msg);
          if (this.onExitLog) {
            this.onExitLog(msg);
          }
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
struct OnWindowExitPage {
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
          .width('80%')
          .height(40)
          .type(ButtonType.Normal)
          .borderRadius(20)
          .margin({ top: 8, bottom: 6 })
          .onClick(() => { router.back(); })

        // ====== 实时日志显示区（返回按钮下方）======
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
            : '[暂无日志，点击"Open New Window"打开子窗口后，点击子窗口的"Close This Window"触发onWindowExit]')
            .fontSize(10)
            .fontColor(this.logMessages.length > 0 ? '#52c41a' : '#666666')
            .textAlign(TextAlign.Start)
        }
        .scrollable(ScrollDirection.Vertical)
        .width('100%')
        .flexShrink(0)
        .height(200)
        .padding(10)
        .backgroundColor('#1a1a2e')
        .borderRadius(4)
        .margin({ left: 8, right: 8, bottom: 8 })

        Divider()

        // ====== 标题 ======
        Text('onWindowExit 接口测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 6, bottom: 6 })

        Text('测试子窗口关闭时的 onWindowExit 回调行为')
          .fontSize(12)
          .fontColor('#888888')

        Divider()

        // ====== 说明信息 ======
        Column() {
          Text('测试说明:')
            .fontSize(13).fontWeight(FontWeight.Medium).alignSelf(ItemAlign.Start)

          Text('onWindowExit — 子Web窗口关闭时触发的回调')
            .fontSize(11).fontColor('#13c2c2').alignSelf(ItemAlign.Start).margin({ top: 4 })

          Text('测试流程:')
            .fontSize(11).fontWeight(FontWeight.Medium).alignSelf(ItemAlign.Start).margin({ top: 6 })

          Text('1. 主Web(main.html) → 点击 "Open New Window" 按钮')
            .fontSize(10).fontColor('#666666').alignSelf(ItemAlign.Start)

          Text('2. 触发 window.open → 弹出子窗口(newWindow.html)')
            .fontSize(10).fontColor('#666666').alignSelf(ItemAlign.Start)

          Text('3. 子窗口点击 "Close This Window" 调用 window.close()')
            .fontSize(10).fontColor('#666666').alignSelf(ItemAlign.Start)

          Text('4. 观察 onWindowExit 是否被触发并记录日志')
            .fontSize(10).fontColor('#fa8c16').alignSelf(ItemAlign.Start)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#e6fffb')
        .borderRadius(8)
        .margin(8)

        Divider()

        // ====== Web 组件区域 ======
        Text('[主Web组件 - main.html]')
          .fontSize(11).fontColor('#888888').alignSelf(ItemAlign.Start).margin({ left: 8 })

        Column() {
          Row() {
            Text('src = main.html')
              .fontSize(10).fontColor('#13c2c2')
              .backgroundColor('#e6fffb').borderRadius(4)
              .padding({ left: 6, right: 4, top: 2, bottom: 2 })
            Blank()
          }
          .width('100%')
          .alignSelf(ItemAlign.Start)

          Web({ src: $rawfile('main.html'), controller: this.controller })
            .javaScriptAccess(true)
            .multiWindowAccess(true)
            .allowWindowOpenMethod(true)
            .onPageBegin((event) => {
              this.addLog('[主Web] onPageBegin, URL=' + (event.url ?? 'null'));
            })
            .onPageEnd((event) => {
              this.addLog('[主Web] onPageEnd, URL=' + (event.url ?? 'null'));
            })
            .onWindowNew((event) => {
              const targetUrl = event.targetUrl ?? 'null';
              this.addLog('[onWindowNew] 触发! targetUrl=' + targetUrl);
              if (this.dialogController) {
                this.dialogController.close();
                this.addLog('[onWindowNew] 已关闭旧弹窗');
              }

              let popController: webview.WebviewController = new webview.WebviewController();
              this.dialogController = new CustomDialogController({
                builder: NewWebViewDialog({
                  webviewController1: popController,
                  onPageEndLog: (msg: string) => { this.addLog(msg); },
                  onExitLog: (msg: string) => { this.addLog(msg); }
                }),
                autoCancel: true
              });

              this.dialogController.open();
              try {
                event.handler.setWebController(popController);
                this.addLog('[OK] setWebController(popController) 成功，子窗口已弹出');
              } catch (error) {
                const errMsg = '[FAIL] setWebController 异常: ' + JSON.stringify(error);
                this.addLog(errMsg);
                if (this.dialogController) {
                  this.dialogController.close();
                }
              }
            })
            .layoutWeight(1)
            .width('100%')
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
