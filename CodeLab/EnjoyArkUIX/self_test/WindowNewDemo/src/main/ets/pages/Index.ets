// xxx.ets — Web多窗口接口测试程序
// 测试接口：multiWindowAccess、allowWindowOpenMethod、onWindowNew
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

// ========== 子窗口 Dialog 组件 ==========
@CustomDialog
struct NewWebViewComp {
  controller?: CustomDialogController;
  webviewController1: webview.WebviewController = new webview.WebviewController();
  onPageEndLog?: (msg: string) => void;

  build() {
    Column() {
      // src 故意设为与 window.open 目标不同的 URL
      // window.open 目标是 baidu.com，这里 src 是 example.com
      Web({ src: 'https://www.example.com', controller: this.webviewController1 })
        .javaScriptAccess(true)
        .multiWindowAccess(false)
        .onPageEnd((event) => {
          const msg = '[子Web] 页面加载完成, URL=' + (event.url ?? 'null');
          console.info(msg);
          if (this.onPageEndLog) {
            this.onPageEndLog(msg);
          }
        })
        .onWindowExit(() => {
          const msg = '[子Web] onWindowExit 触发';
          console.info(msg);
          if (this.onPageEndLog) {
            this.onPageEndLog(msg);
          }
          if (this.controller) {
            this.controller.close();
          }
        })
    }.width('100%').height('100%')
  }
}

// ========== 主页面组件 ==========
@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  dialogController: CustomDialogController | null = null;

  // ---- 控制开关 ----
  @State multiWindowAccess: boolean = true;       // multiWindowAccess 接口开关
  @State allowWindowOpenMethod: boolean = true;    // allowWindowOpenMethod 接口开关
  @State useSetWebController: boolean = false;     // 是否调用 setWebController

  // ---- 日志收集 ----
  @State logMessages: string[] = [];

  // ---- onWindowNew 回调捕获的关键字段 ----
  @State lastTargetUrl: string = '';
  @State lastMultiWindowAccess: string = '';
  @State lastAllowWindowOpenMethod: string = '';

  // 添加日志并触发UI刷新
  addLog(msg: string): void {
    const time = new Date().toLocaleTimeString();
    const line = '[' + time + '] ' + msg;
    this.logMessages = this.logMessages.concat(line);
  }

  // 清空日志
  clearLogs(): void {
    this.logMessages = [];
  }

  build() {
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

      // ====== 标题区 ======
      Text('Web 多窗口接口测试面板')
        .fontSize(18).fontColor('#333333').fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 8 })

      Divider()

      // ====== 日志显示区（置顶）======
      Row() {
        Text('实时日志 (' + this.logMessages.length + ')')
          .fontSize(13).fontColor('#333333').fontWeight(FontWeight.Medium)
        Blank()
        Button('清空').fontSize(11).height(26)
          .onClick(() => { this.clearLogs(); })
      }.width('100%').margin({ left: 8, right: 8 })

      // ====== onWindowNew 关键字段展示 ======
      if (this.lastTargetUrl !== '') {
        Column() {
          Row() {
            Text('targetUrl').fontSize(10).fontColor('#888888').width(110)
            Text(this.lastTargetUrl).fontSize(10).fontColor('#1890ff')
              .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
            Blank()
          }.width('100%')
          Row() {
            Text('multiWindowAccess').fontSize(10).fontColor('#888888').width(110)
            Text(this.lastMultiWindowAccess)
              .fontSize(10)
              .fontColor(this.lastMultiWindowAccess === 'true' ? '#52c41a' : '#f5222d')
            Blank()
          }.width('100%')
          Row() {
            Text('allowWindowOpenMethod').fontSize(10).fontColor('#888888').width(110)
            Text(this.lastAllowWindowOpenMethod)
              .fontSize(10)
              .fontColor(this.lastAllowWindowOpenMethod === 'true' ? '#52c41a' : '#f5222d')
            Blank()
          }.width('100%')
        }
        .width('100%')
        .padding(8)
        .backgroundColor('#f0f5ff')
        .borderRadius(4)
        .margin({ left: 8, right: 8, bottom: 6 })
      }

      Scroll() {
        Text(this.logMessages.length > 0
          ? this.logMessages.join('\n')
          : '[暂无日志，切换开关或触发 window.open 后查看日志]')
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

      // ====== 控制面板 ======
      Column() {
        // multiWindowAccess 开关
        Row() {
          Text('multiWindowAccess').fontSize(14).width(160)
          Checkbox()
            .select(this.multiWindowAccess)
            .selectedColor('#1890ff')
            .width(24)
            .height(24)
            .onChange((isOn: boolean) => {
              this.multiWindowAccess = isOn;
              this.addLog('multiWindowAccess → ' + isOn);
            })
        }.width('100%').margin({ top: 8 }).justifyContent(FlexAlign.SpaceBetween)

        // allowWindowOpenMethod 开关
        Row() {
          Text('allowWindowOpenMethod').fontSize(14).width(160)
          Checkbox()
            .select(this.allowWindowOpenMethod)
            .selectedColor('#1890ff')
            .width(24)
            .height(24)
            .onChange((isOn: boolean) => {
              this.allowWindowOpenMethod = isOn;
              this.addLog('allowWindowOpenMethod → ' + isOn);
            })
        }.width('100%').margin({ top: 6 }).justifyContent(FlexAlign.SpaceBetween)

        // setWebController 开关（onWindowNew 内部使用）
        Row() {
          Text('调用setWebController').fontSize(14).width(160)
          Checkbox()
            .select(this.useSetWebController)
            .selectedColor('#1890ff')
            .width(24)
            .height(24)
            .onChange((isOn: boolean) => {
              this.useSetWebController = isOn;
              this.addLog('setWebController开关 → ' + isOn);
            })
        }.width('100%').margin({ top: 6 }).justifyContent(FlexAlign.SpaceBetween)

        // 当前配置摘要
        Column() {
          Text('当前配置:')
            .fontSize(13).fontColor('#666666').alignSelf(ItemAlign.Start)
          Text('multiWindowAccess=' + this.multiWindowAccess
            + '  allowWindowOpenMethod=' + this.allowWindowOpenMethod
            + '  setWebController=' + this.useSetWebController)
            .fontSize(12).fontColor('#1890ff').alignSelf(ItemAlign.Start)
        }.width('100%').margin({ top: 8 }).alignItems(HorizontalAlign.Start)

        // 预期行为提示
        Text(this.getExpectedHint())
          .fontSize(11).fontColor('#fa8c16').margin({ top: 4 })
      }
      .padding(12)
      .backgroundColor('#f5f5f5')
      .borderRadius(8)
      .margin(8)

      Divider()

      // ====== Web 组件（三个被测接口均在此） ======
      Text('[主Web组件]')
        .fontSize(12).fontColor('#888888').alignSelf(ItemAlign.Start).margin({ left: 8 })

      Web({ src: $rawfile("window.html"), controller: this.controller })
        .javaScriptAccess(true)
        .multiWindowAccess(this.multiWindowAccess)           // ★ 被测接口1
        .allowWindowOpenMethod(this.allowWindowOpenMethod)   // ★ 被测接口2
        .onWindowNew((event) => {                            // ★ 被测接口3
          const targetUrl = event.targetUrl ?? 'null';
          this.lastTargetUrl = targetUrl;
          this.lastMultiWindowAccess = String(this.multiWindowAccess);
          this.lastAllowWindowOpenMethod = String(this.allowWindowOpenMethod);
          let log = '';
          log += '[onWindowNew] 触发!\n';
          log += '  targetUrl = ' + targetUrl + '\n';
          log += '  multiWindowAccess = ' + this.multiWindowAccess + '\n';
          log += '  allowWindowOpenMethod = ' + this.allowWindowOpenMethod + '\n';
          console.info(log);

          // 关闭旧弹窗
          if (this.dialogController) {
            this.dialogController.close();
            log += '  已关闭旧弹窗\n';
          }

          // 创建新弹窗和 popController
          const popController: webview.WebviewController = new webview.WebviewController();
          this.dialogController = new CustomDialogController({
            builder: NewWebViewComp({
              webviewController1: popController,
              onPageEndLog: (msg: string) => { this.addLog(msg); }
            }),
            autoCancel: true
          });

          // 打开弹窗
          this.dialogController.open();
          log += '  新弹窗已打开\n';

          if (this.useSetWebController) {
            // 场景A：调用 setWebController
            // 预期：子WebView通过transport绑定到window.open请求
            // Android内核驱动导航到 baidu.com（忽略src）
            try {
              event.handler.setWebController(popController);
              log += '  [OK] setWebController(popController) 调用成功\n';
              log += '  → 预期: 子窗口加载 ' + targetUrl + '\n';
            } catch (error) {
              log += '  [FAIL] setWebController 异常: ' + error + '\n';
              if (this.dialogController) {
                this.dialogController.close();
                log += '  → 已关闭弹窗\n';
              }
            }
          } else {
            // 场景B：不调用 setWebController
            // 预期：子Web作为独立组件加载自身src(example.com)
            log += '  [SKIP] 未调用 setWebController\n';
            log += '  → 预期: 子窗口加载 https://www.example.com\n';
          }

          this.addLog(log.trim());
        })
        .layoutWeight(1)
        .width('100%')

      // 返回按钮已移至页面顶部
    }
    .width('100%')
    .height('100%')
  }

  // 根据当前配置生成预期行为提示
  getExpectedHint(): string {
    if (!this.allowWindowOpenMethod || !this.multiWindowAccess) {
      return '[WARN] onWindowNew 不会被触发（需两者均为true）';
    }
    return this.useSetWebController
      ? '→ onWindowNew 触发后调用 setWebController → 子窗口应显示百度'
      : '→ onWindowNew 触发但不调用 setWebController → 子窗口应显示example.com';
  }
}
