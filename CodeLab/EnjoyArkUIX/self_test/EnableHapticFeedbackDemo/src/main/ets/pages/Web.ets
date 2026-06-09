import { webview } from '@kit.ArkWeb';
import router from '@ohos.router';

@Entry
@Component
struct WebComponent {
  // 支持边界值测试
  @State hapticValue: boolean | null | undefined | string = true;
  @State currentTestCase: string = 'true';
  controller: webview.WebviewController = new webview.WebviewController();

  /**
   * 获取触觉反馈值 - 处理 Optional<boolean> 类型
   */
  private getHapticValue(): boolean | undefined | null {
    if (this.hapticValue === true) {
      return true;
    }
    if (this.hapticValue === false) {
      return false;
    }
    if (this.hapticValue === null) {
      return null;
    }
    return undefined;
  }

  /**
   * 获取用于显示的状态值
   */
  private getDisplayStatus(): boolean {
    const val = this.getHapticValue();
    return val === true;
  }

  // 获取状态颜色
  private getStatusColor(): string {
    return this.getDisplayStatus() ? '#34C759' : '#FF3B30';
  }

  // 获取状态文本
  private getStatusText(): string {
    const val = this.hapticValue;
    if (val === null) {
      return '触感默认(以第一次设置为准)';
    }
    if (val === undefined) {
      return '触感默认(以第一次设置为准)';
    }
    return this.getDisplayStatus() ? '触感开启' : '触感关闭';
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_back'))
            .width(20)
            .height(20)
            .fillColor('#666666')
        }
        .width(40)
        .height(40)
        .backgroundColor('#f5f5f5')
        .onClick(() => {
          router.back();
        })

        Blank()

        Text('Web 组件')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1a1a1a')

        Blank()

        Row({ space: 6 }) {
          Circle()
            .width(8)
            .height(8)
            .fill(this.getStatusColor())
          Text(this.getStatusText())
            .fontSize(12)
            .fontColor('#666666')
        }
        .padding({
          left: 10,
          right: 10,
          top: 4,
          bottom: 4
        })
        .backgroundColor('#f5f5f5')
        .borderRadius(12)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#ffffff')

      // 标题区域
      Column({ space: 4 }) {
        Text('🌐 WebView 网页浏览')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1a1a1a')
        Text('支持触觉反馈的网页组件')
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 12,
        bottom: 12
      })
      .backgroundColor('#ffffff')

      // 边界值测试控制
      Column({ space: 8 }) {
        Text('enableHapticFeedback 参数测试')
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')

        Row({ space: 6 }) {
          this.ValueButton('true', true)
          this.ValueButton('false', false)
          this.ValueButton('null', null)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Row({ space: 6 }) {
          this.ValueButton('undefined', undefined)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Row() {
          Text('当前: ' + this.currentTestCase)
            .fontSize(13)
            .fontColor('#007AFF')
          Blank()

        }
        .width('100%')
        .padding({ top: 4 })
      }
      .width('100%')
      .padding(12)
      .backgroundColor('#ffffff')
      .margin({ bottom: 8 })

      // WebView 卡片
      Column({ space: 16 }) {
        // 网址显示
        Row({ space: 8 }) {
          Text('🔗')
            .fontSize(14)
          Text('https://www.example.com/')
            .fontSize(14)
            .fontColor('#666666')
            .layoutWeight(1)
          Text('安全')
            .fontSize(12)
            .fontColor('#34C759')
            .padding({
              left: 6,
              right: 6,
              top: 2,
              bottom: 2
            })
            .backgroundColor('#E8F5E9')
            .borderRadius(4)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#f5f5f7')
        .borderRadius(8)

        // WebView
        Web({ src: 'https://www.example.com/', controller: this.controller })
          .enableHapticFeedback(this.getHapticValue())
          .backgroundColor('#ffffff')
          .borderRadius(12)
          .shadow({
            radius: 8,
            color: 'rgba(0, 0, 0, 0.08)',
            offsetY: 4
          })
          .layoutWeight(1)
      }
      .width('100%')
      .layoutWeight(1)
      .padding(16)
      .backgroundColor('#f5f5f7')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }

  @Builder
  ValueButton(label: string, value: boolean | null | undefined) {
    Button(label)
      .fontSize(12)
      .fontColor(this.currentTestCase === label ? '#ffffff' : '#1a1a1a')
      .backgroundColor(this.currentTestCase === label ? '#007AFF' : '#f5f5f5')
      .borderRadius(6)
      .height(32)
      .padding({ left: 10, right: 10 })
      .onClick(() => {
        this.hapticValue = value;
        this.currentTestCase = label;
      })
  }
}
