// xxx.ets — onRenderExited 接口测试
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import deviceInfo from '@ohos.deviceInfo';

@Entry
@Component
struct WebComponent {
  controller: webview.WebviewController = new webview.WebviewController();
  @State logMessages: string[] = [];

  // 平台相关计算
  getWebSrc(): ResourceStr | string {
    const osFullNameInfo: string = deviceInfo.osFullName ?? '';
    const platform = osFullNameInfo.split(' ')[0] ?? '';
    const isIOS: boolean = platform === 'iOS';
    return isIOS ? $rawfile('crash_oom.html') : 'chrome://crash/';
  }

  getWebLabel(): string {
    const osFullNameInfo: string = deviceInfo.osFullName ?? '';
    const platform = osFullNameInfo.split(' ')[0] ?? '';
    const isIOS: boolean = platform === 'iOS';
    return isIOS
      ? '[Web组件] rawfile: crash_oom.html (iOS 新逻辑)'
      : '[Web组件] chrome://crash/';
  }

  addLog(msg: string): void {
    const time = new Date().toLocaleTimeString();
    this.logMessages = this.logMessages.concat('[' + time + '] ' + msg);
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

      // 标题区
      Text('onRenderExited 测试')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 12, bottom: 8 })

      Divider()

      // 日志显示区（置顶）
      Row() {
        Text('实时日志 (' + this.logMessages.length + ')')
          .fontSize(13).fontColor('#333333').fontWeight(FontWeight.Medium)
        Blank()
        Button('清空').fontSize(11).height(26)
          .onClick(() => { this.logMessages = []; })
      }.width('100%').margin({ left: 8, right: 8 })

      Scroll() {
        Text(this.logMessages.length > 0
          ? this.logMessages.join('\n')
          : '[暂无日志，页面加载 chrome://crash/ 后自动触发]')
          .fontSize(10)
          .fontColor(this.logMessages.length > 0 ? '#52c41a' : '#666666')
          .textAlign(TextAlign.Start)
      }
      .scrollable(ScrollDirection.Vertical)
      .width('100%')
      .flexShrink(0)
      .height(140)
      .padding(10)
      .backgroundColor('#1a1a2e')
      .borderRadius(4)
      .margin({ left: 8, right: 8 })

      Divider()

      // Web 组件
      Text(this.getWebLabel())
        .fontSize(11)
        .fontColor('#888888')
        .alignSelf(ItemAlign.Start)
        .margin({ left: 8, top: 4 })

      Web({ src: this.getWebSrc(), controller: this.controller })
        .javaScriptAccess(true)
        .onRenderExited((event) => {
          const reason = event ? event.renderExitReason : 'event为null';
          let msg = '[onRenderExited] 触发!\n  renderExitReason = ' + reason;
          console.info(msg);
          this.addLog(msg.replace(/\n/g, ' | '));
        })
        .layoutWeight(1)
        .width('100%')

      // 返回按钮已移至页面顶部
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f7fa')
  }
}