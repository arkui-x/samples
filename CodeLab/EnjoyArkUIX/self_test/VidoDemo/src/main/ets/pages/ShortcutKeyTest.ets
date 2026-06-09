import router from '@ohos.router';

@Entry
@Component
struct ShortcutKeyTest {
  private controller: VideoController = new VideoController();

  @State currentVideo: Resource = $rawfile('test3.mp4');
  @State playerVersion: number = 0;
  @State shortcutEnabled: boolean = true;
  @State isVideoFocused: boolean = false;
  @State statusText: string = '等待操作';

  private buildVideoOptions(): VideoOptions {
    return {
      src: this.currentVideo,
      controller: this.controller
    };
  }

  private reloadPlayer(): void {
    this.controller.stop();
    this.controller = new VideoController();
    this.playerVersion = this.playerVersion + 1;
    this.isVideoFocused = false;
    this.statusText = '已重新装载视频';
  }

  @Builder
  private buildVideoPlayer() {
    if (this.playerVersion % 2 === 0) {
      Video(this.buildVideoOptions())
        .controls(true)
        .enableShortcutKey(this.shortcutEnabled)
        .width('100%')
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onFocus(() => {
          this.isVideoFocused = true;
          this.statusText = '视频组件已获焦，可测试快捷键';
        })
        .onBlur(() => {
          this.isVideoFocused = false;
          this.statusText = '视频组件已失焦，可验证快捷键不生效';
        });
    } else {
      Video(this.buildVideoOptions())
        .controls(true)
        .enableShortcutKey(this.shortcutEnabled)
        .width('100%')
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onFocus(() => {
          this.isVideoFocused = true;
          this.statusText = '视频组件已获焦，可测试快捷键';
        })
        .onBlur(() => {
          this.isVideoFocused = false;
          this.statusText = '视频组件已失焦，可验证快捷键不生效';
        });
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Row({ space: 12 }) {
          Button('返回上一级')
            .onClick(() => {
              router.back();
            })

          Text('快捷键测试')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F3F4F6')
        }
        .width('100%')

        Text('本页只验证 enableShortcutKey 以及视频组件获焦、失焦时的行为。建议在真机或带物理键盘设备上测试。')
          .fontSize(14)
          .fontColor('#B8C3D1')
          .width('100%')

        // Text('当前测试视频: test3.mp4')
        //   .fontSize(14)
        //   .fontColor('#F8D66D')
        //   .width('100%')

        Column({ space: 12 }) {
          this.buildVideoPlayer()

          Text('enableShortcutKey: ' + (this.shortcutEnabled ? 'true' : 'false'))
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')

          Text('焦点状态: ' + (this.isVideoFocused ? '已获焦' : '未获焦'))
            .fontSize(14)
            .fontColor(this.isVideoFocused ? '#7AE582' : '#FCA5A5')
            .width('100%')

          Text('状态: ' + this.statusText)
            .fontSize(14)
            .fontColor('#B8C3D1')
            .width('100%')
        }
        .padding(20)
        .backgroundColor('#101923')
        .borderRadius(24)

        Column({ space: 10 }) {
          Button('enableShortcutKey = true')
            .width('100%')
            .onClick(() => {
              this.shortcutEnabled = true;
              this.statusText = '已开启快捷键';
              this.reloadPlayer();
            })

          Button('enableShortcutKey = false')
            .width('100%')
            .onClick(() => {
              this.shortcutEnabled = false;
              this.statusText = '已关闭快捷键';
              this.reloadPlayer();
            })
        }
        .width('100%')

        Row({ space: 10 }) {
          Button('播放').onClick(() => { this.controller.start(); })
          Button('暂停').onClick(() => { this.controller.pause(); })
          Button('将焦点切到这里')
            .onFocus(() => {
              this.isVideoFocused = false;
              this.statusText = '焦点已切换到辅助按钮';
            })
        }
        .width('100%')
      }
      .width('100%')
      .padding(20)
    }
    .scrollBar(BarState.Auto)
    .width('100%')
    .height('100%')
    .backgroundColor('#09111A')
  }
}
