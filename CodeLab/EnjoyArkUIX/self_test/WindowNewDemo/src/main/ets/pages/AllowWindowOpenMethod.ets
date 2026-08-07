// AllowWindowOpenMethod.ets — 测试 allowWindowOpenMethod 接口
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

// ========== 新窗口弹窗组件 ==========
@CustomDialog
struct NewWebViewDialog {
  controller?: CustomDialogController;
  webviewController1: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Text('新窗口 (allowWindowOpenMethod 弹出)')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1890ff')
        .margin({ top: 10, bottom: 8 })

      Web({ src: 'https://www.example.com', controller: this.webviewController1 })
        .javaScriptAccess(true)
        .multiWindowAccess(false)
        .layoutWeight(1)
        .width('100%')
        .onWindowExit(() => {
          console.info('NewWebViewDialog onWindowExit');
          if (this.controller) {
            this.controller.close();
          }
        })

      Button('关闭新窗口')
        .fontSize(12)
        .height(32)
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

// ========== 主页面 ==========
@Entry
@Component
struct AllowWindowOpenMethodPage {
  controller: webview.WebviewController = new webview.WebviewController();
  dialogController: CustomDialogController | null = null;

  @State logMessages: string[] = [];
  @State activeScenario: string = '';   // ''=未选择, 'true', 'false', 'null', 'undefined'
  @State currentAllowValue: boolean | null | undefined = true;  // 当前 allowWindowOpenMethod 的值
  @State windowTriggered: boolean = false;  // onWindowNew 是否已被触发
  private timerId: number | null = null;    // 超时计时器 ID

  addLog(msg: string): void {
    const time = new Date().toLocaleTimeString();
    this.logMessages = this.logMessages.concat('[' + time + '] ' + msg);
  }

  clearLogs(): void {
    this.logMessages = [];
  }

  // ========== 启动5秒超时检测计时器 ==========
  startTimeoutCheck(): void {
    this.windowTriggered = false;
    if (this.timerId !== null) {
      clearTimeout(this.timerId);
      this.timerId = null;
    }
    this.addLog('[WAIT] 启动5秒超时检测，等待 onWindowNew 回调...');
    this.timerId = setTimeout(() => {
      if (!this.windowTriggered) {
        this.addLog('[FAIL] [触发失败] 5秒内未收到 onWindowNew 回调');
        this.addLog('   → allowWindowOpenMethod(' + this.activeScenario + ') 阻止了 window.open()');
      }
    }, 5500)  as number;
  }

  // ========== 场景A: allowWindowOpenMethod(true) ==========
  triggerScenarioTrue(): void {
    this.addLog('═══ 场景A: allowWindowOpenMethod(true) ═══');
    try {
      this.activeScenario = '';       // 先销毁旧Web组件
      this.currentAllowValue = true;
      this.addLog('[try] 设置 allowWindowOpenMethod = true');
      this.addLog('[OK] 预期: 允许通过 JS window.open() 打开新窗口');
      // 延迟重建Web组件，确保旧组件被ArkUI完全销毁
      setTimeout(() => {
        this.activeScenario = 'true';
        this.startTimeoutCheck();
      }, 50);
    } catch (error) {
      const errMsg = '[FAIL] [场景A异常] ' + JSON.stringify(error);
      this.addLog(errMsg);
    }
  }

  // ========== 场景B: allowWindowOpenMethod(false) ==========
  triggerScenarioFalse(): void {
    this.addLog('═══ 场景B: allowWindowOpenMethod(false) ═══');
    try {
      this.activeScenario = '';
      this.currentAllowValue = false;
      this.addLog('[try] 设置 allowWindowOpenMethod = false');
      this.addLog('[WARN] 预期: 禁止通过 JS window.open() 打开新窗口');
      setTimeout(() => {
        this.activeScenario = 'false';
        this.startTimeoutCheck();
      }, 50);
    } catch (error) {
      const errMsg = '[FAIL] [场景B异常] ' + JSON.stringify(error);
      this.addLog(errMsg);
    }
  }

  // ========== 场景C: allowWindowOpenMethod(null) ==========
  triggerScenarioNull(): void {
    this.addLog('═══ 场景C: allowWindowOpenMethod(null) ═══');
    try {
      this.activeScenario = '';
      this.currentAllowValue = null;
      this.addLog('[try] 设置 allowWindowOpenMethod = null');
      this.addLog('[WARN] 预期: 可能使用默认值或抛出异常');
      setTimeout(() => {
        this.activeScenario = 'null';
        this.startTimeoutCheck();
      }, 50);
    } catch (error) {
      const errMsg = '[FAIL] [场景C异常] ' + JSON.stringify(error);
      this.addLog(errMsg);
    }
  }

  // ========== 场景D: allowWindowOpenMethod(undefined) ==========
  triggerScenarioUndefined(): void {
    this.addLog('═══ 场景D: allowWindowOpenMethod(undefined) ═══');
    try {
      this.activeScenario = '';
      this.currentAllowValue = undefined;
      this.addLog('[try] 设置 allowWindowOpenMethod = undefined');
      this.addLog('[WARN] 预期: 可能使用默认值或抛出异常');
      setTimeout(() => {
        this.activeScenario = 'undefined';
        this.startTimeoutCheck();
      }, 50);
    } catch (error) {
      const errMsg = '[FAIL] [场景D异常] ' + JSON.stringify(error);
      this.addLog(errMsg);
    }
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
        Text('allowWindowOpenMethod 接口测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 12, bottom: 6 })

        Text('测试不同参数值对 window.open() 弹窗行为的影响')
          .fontSize(12)
          .fontColor('#888888')
          .margin({ bottom: 10 })

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
            : '[暂无日志，选择测试场景后查看日志]')
            .fontSize(10)
            .fontColor(this.logMessages.length > 0 ? '#52c41a' : '#666666')
            .textAlign(TextAlign.Start)
        }
        .scrollable(ScrollDirection.Vertical)
        .width('100%')
        .flexShrink(0)
        .height(180)
        .padding(10)
        .backgroundColor('#1a1a2e')
        .borderRadius(4)
        .margin({ left: 8, right: 8 })

        Divider()

        // ====== 说明信息 ======
        Column() {
          Text('接口说明:')
            .fontSize(13).fontWeight(FontWeight.Medium).alignSelf(ItemAlign.Start)

          Text('allowWindowOpenMethod(value)')
            .fontSize(11).fontColor('#1890ff').alignSelf(ItemAlign.Start).margin({ top: 4 })
            .onClick(() => {
              this.addLog('[INFO] value: boolean | null | undefined');
              this.addLog('[INFO] true → 允许JS调用window.open打开新窗口');
              this.addLog('[INFO] false → 禁止JS调用window.open打开新窗口');
              this.addLog('[INFO] null/undefined → 待观察行为');
            })

          Text('配合 multiWindowAccess=true 和 onWindowNew 使用')
            .fontSize(11).fontColor('#666666').alignSelf(ItemAlign.Start).margin({ top: 4 })
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#e6f7ff')
        .borderRadius(8)
        .margin(8)

        Divider()

        // ====== 触发按钮区 ======
        Column() {
          Row() {
            Text('选择测试场景:')
              .fontSize(14).fontWeight(FontWeight.Medium)
            Blank()
          }.width('100%').margin({ bottom: 10 })

          // 按钮行1
          Row({ space: 10 }) {
            Button('[OK] true (允许弹窗)')
              .fontSize(12)
              .height(38)
              .type(this.activeScenario === 'true' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'true' ? '#52c41a' : '#ffffff')
              .fontColor(this.activeScenario === 'true' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'true' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioTrue(); })

            Button('[X] false (禁止弹窗)')
              .fontSize(12)
              .height(38)
              .type(this.activeScenario === 'false' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'false' ? '#f5222d' : '#ffffff')
              .fontColor(this.activeScenario === 'false' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'false' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioFalse(); })
          }
          .width('100%')

          // 按钮行2
          Row({ space: 10 }) {
            Button('[?] null')
              .fontSize(12)
              .height(38)
              .type(this.activeScenario === 'null' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'null' ? '#faad14' : '#ffffff')
              .fontColor(this.activeScenario === 'null' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'null' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioNull(); })

            Button('[?] undefined')
              .fontSize(12)
              .height(38)
              .type(this.activeScenario === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'undefined' ? '#722ed1' : '#ffffff')
              .fontColor(this.activeScenario === 'undefined' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'undefined' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioUndefined(); })
          }
          .width('100%')
          .margin({ top: 8 })

          // 当前状态提示
          if (this.activeScenario !== '') {
            Text('当前: allowWindowOpenMethod(' + this.activeScenario + ')')
              .fontSize(12)
              .fontWeight(FontWeight.Medium)
              .padding({ left: 8, right: 8, top: 4, bottom: 4 })
              .borderRadius(4)
              .alignSelf(ItemAlign.Start)
              .margin({ top: 8 })
              .backgroundColor(
                this.activeScenario === 'true' ? '#f6ffed' :
                this.activeScenario === 'false' ? '#fff2f0' :
                '#fffbe6'
              )
              .fontColor(
                this.activeScenario === 'true' ? '#52c41a' :
                this.activeScenario === 'false' ? '#f5222d' :
                '#faad14'
              )
          }
        }
        .width('100%')
        .padding(14)
        .backgroundColor('#fafafa')
        .borderRadius(8)
        .margin(8)

        Divider()

        // ====== 动态 Web 组件区域 ======
        Text('[Web组件区域 - 加载测试页面]')
          .fontSize(11).fontColor('#888888').alignSelf(ItemAlign.Start).margin({ left: 8 })

        if (this.activeScenario !== '') {
          Column() {
            // 显示当前参数值标签
            Row() {
              Text('allowWindowOpenMethod = ')
                .fontSize(11).fontColor('#666666')
              Text(this.activeScenario.toUpperCase())
                .fontSize(11).fontWeight(FontWeight.Bold)
                .fontColor(
                  this.activeScenario === 'true' ? '#52c41a' :
                  this.activeScenario === 'false' ? '#f5222d' :
                  this.activeScenario === 'null' ? '#fa8c16' : '#722ed1'
                )
              Blank()
            }
            .width('100%')
            .padding({ left: 6, right: 6, top: 4, bottom: 4 })
            .backgroundColor('#fafafa')
            .borderRadius(4)
            .alignSelf(ItemAlign.Start)

            // Web 组件 — 使用自动触发 window.open 的 HTML（reloadKey变化时强制重建）
            Web({ src: $rawfile('auto_open.html'), controller: new webview.WebviewController() })
              .javaScriptAccess(true)
              .multiWindowAccess(true)
              .allowWindowOpenMethod(this.currentAllowValue)
              .onWindowNew((event) => {
                this.windowTriggered = true;
                if (this.timerId !== null) {
                  clearTimeout(this.timerId);
                  this.timerId = null;
                }
                this.addLog('[OK] [触发成功] onWindowNew 回调已收到!');
                this.addLog('   → allowWindowOpenMethod(' + this.activeScenario + ') 允许了 window.open()');
                if (this.dialogController) {
                  this.dialogController.close();
                }
                let popController: webview.WebviewController = new webview.WebviewController();
                this.dialogController = new CustomDialogController({
                  builder: NewWebViewDialog({ webviewController1: popController }),
                  isModal: false,
                  alignment: DialogAlignment.Center
                });
                this.dialogController.open();
                event.handler.setWebController(popController);
                this.addLog('[OK] 新窗口已弹出 (CustomDialog)');
                this.addLog('[INFO] setWebController(popController) 已调用');
              })
              .layoutWeight(1)
              .width('100%')

            Text('[WAIT] HTML页面加载后5秒自动触发 window.open(), 无需手动操作')
              .fontSize(10).fontColor('#1890ff')
              .alignSelf(ItemAlign.Center).margin({ top: 4 })
          }
          .width('100%')
          .padding(8)
          .borderRadius(8)
          .backgroundColor('#ffffff')
        } else {
          Column() {
            Text('请点击上方按钮选择 allowWindowOpenMethod 参数值')
              .fontSize(13)
              .fontColor('#999999')
          }
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        }

      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')
  }
}
