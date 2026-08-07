// MultiWindowAccess.ets — 测试 multiWindowAccess 接口（异常值 null/undefined）
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

// ========== 新窗口弹窗组件 ==========
@CustomDialog
struct NewWebViewDialog {
  controller?: CustomDialogController;
  webviewController1: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      Text('新窗口 (multiWindowAccess 弹出)')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#13c2c2')
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
struct MultiWindowAccessPage {
  controller: webview.WebviewController = new webview.WebviewController();
  dialogController: CustomDialogController | null = null;

  @State logMessages: string[] = [];
  @State activeScenario: string = '';   // ''=未选择, 'true', 'false', 'null', 'undefined'
  @State currentValue: boolean | null | undefined = true;
  @State windowTriggered: boolean = false;
  private timerId: number | null = null;

  addLog(msg: string): void {
    const time = new Date().toLocaleTimeString();
    this.logMessages = this.logMessages.concat('[' + time + '] ' + msg);
  }

  clearLogs(): void {
    this.logMessages = [];
  }

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
        this.addLog('   → multiWindowAccess(' + this.activeScenario + ') 阻止了多窗口创建');
      }
    }, 5500) as number;
  }

  // ========== 场景A: multiWindowAccess(true) ==========
  triggerScenarioTrue(): void {
    this.addLog('═══ 场景A: multiWindowAccess(true) ═══');
    try {
      this.activeScenario = '';       // 先销毁旧Web组件
      this.currentValue = true;
      this.addLog('[try] 设置 multiWindowAccess = true');
      this.addLog('[OK] 预期: 启用多窗口模式，允许 onWindowNew 触发');
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

  // ========== 场景B: multiWindowAccess(false) ==========
  triggerScenarioFalse(): void {
    this.addLog('═══ 场景B: multiWindowAccess(false) ═══');
    try {
      this.activeScenario = '';       // 先销毁旧Web组件
      this.currentValue = false;
      this.addLog('[try] 设置 multiWindowAccess = false');
      this.addLog('[WARN] 预期: 禁用多窗口模式，onWindowNew 不应触发');
      setTimeout(() => {
        this.activeScenario = 'false';
        this.startTimeoutCheck();
      }, 50);
    } catch (error) {
      const errMsg = '[FAIL] [场景B异常] ' + JSON.stringify(error);
      this.addLog(errMsg);
    }
  }

  // ========== 场景C: multiWindowAccess(null) ==========
  triggerScenarioNull(): void {
    this.addLog('═══ 场景C: multiWindowAccess(null) ═══');
    try {
      this.activeScenario = '';       // 先销毁旧Web组件
      this.currentValue = null;
      this.addLog('[try] 设置 multiWindowAccess = null（异常值）');
      this.addLog('[WARN] 预期: 可能使用默认值或抛出异常，待观察行为');
      setTimeout(() => {
        this.activeScenario = 'null';
        this.startTimeoutCheck();
      }, 50);
    } catch (error) {
      const errMsg = '[FAIL] [场景C异常] ' + JSON.stringify(error);
      this.addLog(errMsg);
    }
  }

  // ========== 场景D: multiWindowAccess(undefined) ==========
  triggerScenarioUndefined(): void {
    this.addLog('═══ 场景D: multiWindowAccess(undefined) ═══');
    try {
      this.activeScenario = '';       // 先销毁旧Web组件
      this.currentValue = undefined;
      this.addLog('[try] 设置 multiWindowAccess = undefined（异常值）');
      this.addLog('[WARN] 预期: 可能使用默认值或抛出异常，待观察行为');
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
        // ====== 返回按钮（置顶）======
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
        Text('multiWindowAccess 接口测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 12, bottom: 6 })

        Text('测试不同参数值对多窗口创建的影响（含异常值 null/undefined）')
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

          Text('multiWindowAccess(value)')
            .fontSize(11).fontColor('#13c2c2').alignSelf(ItemAlign.Start).margin({ top: 4 })

          Text('true → 启用多窗口模式, onWindowNew可正常触发')
            .fontSize(11).fontColor('#52c41a').alignSelf(ItemAlign.Start).margin({ top: 4 })

          Text('false → 禁用多窗口模式, onWindowNew不触发')
            .fontSize(11).fontColor('#f5222d').alignSelf(ItemAlign.Start)

          Text('null/undefined → 异常值, 待观察是否使用默认值或报错')
            .fontSize(11).fontColor('#faad14').alignSelf(ItemAlign.Start)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#e6fffb')
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
            Button('[OK] true (启用多窗口)')
              .fontSize(12)
              .height(38)
              .type(this.activeScenario === 'true' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'true' ? '#52c41a' : '#ffffff')
              .fontColor(this.activeScenario === 'true' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'true' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioTrue(); })

            Button('[X] false (禁用多窗口)')
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
            Button('[?] null (异常值)')
              .fontSize(12)
              .height(38)
              .type(this.activeScenario === 'null' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'null' ? '#faad14' : '#ffffff')
              .fontColor(this.activeScenario === 'null' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'null' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioNull(); })

            Button('[?] undefined (异常值)')
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
            Text('当前: multiWindowAccess(' + this.activeScenario + ')')
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
            // 当前参数值标签
            Row() {
              Text('multiWindowAccess = ')
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

            Web({ src: $rawfile('auto_open.html'), controller: this.controller })
              .javaScriptAccess(true)
              .multiWindowAccess(this.currentValue)
              .allowWindowOpenMethod(true)
              .onWindowNew((event) => {
                this.windowTriggered = true;
                if (this.timerId !== null) {
                  clearTimeout(this.timerId);
                  this.timerId = null;
                }
                this.addLog('[OK] [触发成功] onWindowNew 回调已收到!');
                this.addLog('   → multiWindowAccess(' + this.activeScenario + ') 允许了多窗口创建');
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
              .fontSize(10).fontColor('#13c2c2')
              .alignSelf(ItemAlign.Center).margin({ top: 4 })
          }
          .width('100%')
          .padding(8)
          .borderRadius(8)
          .backgroundColor('#ffffff')
        } else {
          Column() {
            Text('请点击上方按钮选择 multiWindowAccess 参数值')
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
