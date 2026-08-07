// OnWindowNewNullUndefined.ets — 测试 onWindowNew(null) / onWindowNew(undefined) 场景
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct OnWindowNewNullUndefinedPage {
  controller1: webview.WebviewController = new webview.WebviewController();
  controller2: webview.WebviewController = new webview.WebviewController();
  @State logMessages: string[] = [];
  @State activeScenario: string = '';   // ''=未选择, 'null'=场景A, 'undefined'=场景B

  addLog(msg: string): void {
    const time = new Date().toLocaleTimeString();
    this.logMessages = this.logMessages.concat('[' + time + '] ' + msg);
  }

  clearLogs(): void {
    this.logMessages = [];
  }

  // ========== 触发场景A：onWindowNew(null) ==========
  triggerScenarioA(): void {
    this.addLog('═══ 尝试构建: onWindowNew(null) ═══');
    try {
      this.activeScenario = 'null';
      this.addLog('[try] Web组件开始构建, onWindowNew回调=null');
      this.addLog('[OK] [场景A成功] 组件已挂载, 等待window.open触发...');
    } catch (error) {
      const errMsg = '[FAIL] [场景A异常] ' + (error as Error).message;
      this.addLog(errMsg);
    }
  }

  // ========== 触发场景B：onWindowNew(undefined) ==========
  triggerScenarioB(): void {
    this.addLog('═══ 尝试构建: onWindowNew(undefined) ═══');
    try {
      this.activeScenario = 'undefined';
      this.addLog('[try] Web组件开始构建, onWindowNew回调=undefined');
      this.addLog('[OK] [场景B成功] 组件已挂载, 等待window.open触发...');
    } catch (error) {
      const errMsg = '[FAIL] [场景B异常] ' + (error as Error).message;
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
        Text('onWindowNew(null/undefined) 测试')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 12, bottom: 6 })

        Text('点击按钮触发对应场景的 try-catch 构建')
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
            : '[暂无日志，点击下方按钮开始测试]')
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

        // ====== 触发按钮区 ======
        Column() {
          Row() {
            Text('选择测试场景:')
              .fontSize(14).fontWeight(FontWeight.Medium)
            Blank()
          }.width('100%').margin({ bottom: 10 })

          Row({ space: 16 }) {
            // 场景A 按钮
            Button('场景A: onWindowNew(null)')
              .fontSize(13)
              .height(40)
              .type(this.activeScenario === 'null' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'null' ? '#1890ff' : '#ffffff')
              .fontColor(this.activeScenario === 'null' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'null' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioA(); })

            // 场景B 按钮
            Button('场景B: onWindowNew(undefined)')
              .fontSize(13)
              .height(40)
              .type(this.activeScenario === 'undefined' ? ButtonType.Capsule : ButtonType.Normal)
              .backgroundColor(this.activeScenario === 'undefined' ? '#fa8c16' : '#ffffff')
              .fontColor(this.activeScenario === 'undefined' ? Color.White : '#333333')
              .borderWidth(this.activeScenario === 'undefined' ? 0 : 1)
              .borderColor('#d9d9d9')
              .layoutWeight(1)
              .onClick(() => { this.triggerScenarioB(); })
          }
          .width('100%')

          if (this.activeScenario !== '') {
            Text('当前激活: ' + (this.activeScenario === 'null'
              ? '场景A — onWindowNew(null)'
              : '场景B — onWindowNew(undefined)'))
              .fontSize(12)
              .fontColor(this.activeScenario === 'null' ? '#1890ff' : '#fa8c16')
              .margin({ top: 8 })
          }
        }
        .width('100%')
        .padding(14)
        .backgroundColor('#fafafa')
        .borderRadius(8)
        .margin(8)

        Divider()

        // ====== 动态 Web 组件区域 ======
        Text('[Web组件区域]')
          .fontSize(11).fontColor('#888888').alignSelf(ItemAlign.Start).margin({ left: 8 })

        if (this.activeScenario === 'null') {
          // 场景A: onWindowNew(null)
          Column() {
            Text('回调 = null')
              .fontSize(10).fontColor('#f5222d')
              .backgroundColor('#fff1f0').borderRadius(4)
              .padding({ left: 6, right: 4, top: 2, bottom: 2 })
              .alignSelf(ItemAlign.Start)

            Web({ src: $rawfile('window.html'), controller: this.controller1 })
              .javaScriptAccess(true)
              .multiWindowAccess(true)
              .allowWindowOpenMethod(true)
              .onWindowNew(null)   // ★ 回调传 null
              .layoutWeight(1)
              .width('100%')
          }
          .width('100%')
          .padding(8)
          .borderRadius(8)
          .backgroundColor('#ffffff')
        } else if (this.activeScenario === 'undefined') {
          // 场景B: onWindowNew(undefined)
          Column() {
            Text('回调 = undefined')
              .fontSize(10).fontColor('#f5222d')
              .backgroundColor('#fff1f0').borderRadius(4)
              .padding({ left: 6, right: 4, top: 2, bottom: 2 })
              .alignSelf(ItemAlign.Start)

            Web({ src: $rawfile('window.html'), controller: this.controller2 })
              .javaScriptAccess(true)
              .multiWindowAccess(true)
              .allowWindowOpenMethod(true)
              .onWindowNew(undefined) // ★ 回调传 undefined
              .layoutWeight(1)
              .width('100%')
          }
          .width('100%')
          .padding(8)
          .borderRadius(8)
          .backgroundColor('#ffffff')
        } else {
          // 未选择任何场景时的占位提示
          Column() {
            Text('请点击上方按钮触发测试场景')
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
