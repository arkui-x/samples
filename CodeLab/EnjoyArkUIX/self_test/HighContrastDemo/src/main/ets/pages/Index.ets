import { text } from '@kit.ArkGraphics2D';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State highContrastMode: number = text.TextHighContrast.TEXT_FOLLOW_SYSTEM_HIGH_CONTRAST;
  @State refreshTick: number = 0;

  aboutToAppear(): void {
    this.refreshCurrentPage();
  }

  @Builder
  private renderPageContent() {
    Column() {
      Text("高对比度测试模式控制界面")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin(20)
        .fontColor(Color.Pink)

      // 模式切换按钮
      Button("跟随系统")
        .onClick(() => {
          this.highContrastMode = text.TextHighContrast.TEXT_FOLLOW_SYSTEM_HIGH_CONTRAST;
          this.applyHighContrast();
        })
        .margin(10);

      Button("应用禁用")
        .onClick(() => {
          this.highContrastMode = text.TextHighContrast.TEXT_APP_DISABLE_HIGH_CONTRAST;
          this.applyHighContrast();
        })
        .margin(10);

      Button("应用启用")
        .onClick(() => {
          this.highContrastMode = text.TextHighContrast.TEXT_APP_ENABLE_HIGH_CONTRAST;
          this.applyHighContrast();
        })
        .margin(10);

      // 异常测试
      Button("测试 null")
        .onClick(() => {
          text.setTextHighContrast(null);
        })
        .margin(10);

      Button("测试 undefined")
        .onClick(() => {
          text.setTextHighContrast(undefined);
        })
        .margin(10);

      Button("测试 99")
        .onClick(() => {
          text.setTextHighContrast(99);
        })
        .margin(10);

      Button("跳转至组件测试界面")
        .onClick(() => {
          router.pushUrl({ url: 'pages/textHighContrast' })
        })
        .width('100%').margin(10)
    }
    .width('100%')
  }


  build() {
    Row() {
      if (this.refreshTick % 2 === 0) {
        this.renderPageContent();
      } else {
        this.renderPageContent();
      }
    }
    .height('100%')
  }

  private applyHighContrast(): void {
    text.setTextHighContrast(this.highContrastMode);
    this.refreshCurrentPage();
    console.info(`已设置高对比度模式: ${this.highContrastMode}`);
  }

  private refreshCurrentPage(): void {
    this.refreshTick++;
  }
}