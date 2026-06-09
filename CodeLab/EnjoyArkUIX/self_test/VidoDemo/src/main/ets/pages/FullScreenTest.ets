import router from '@ohos.router';

@Entry
@Component
struct FullscreenTest {
  private controller: VideoController = new VideoController();

  @State currentVideo: Resource = $rawfile('test1.mp4');
  @State playerVersion: number = 0;
  @State currentTime: number = 0;
  @State duration: number = 0;
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
    this.currentTime = 0;
    this.duration = 0;
    this.playerVersion = this.playerVersion + 1;
    this.statusText = '已重新装载视频';
  }

  private formatDuration(value: number): string {
    let totalSeconds: number = Math.max(0, Math.floor(value));
    let minutes: number = Math.floor(totalSeconds / 60);
    let seconds: number = totalSeconds % 60;
    let secondText: string = seconds < 10 ? '0' + seconds : '' + seconds;
    return '' + minutes + ':' + secondText;
  }

  @Builder
  private buildVideoPlayer() {
    if (this.playerVersion % 2 === 0) {
      Video(this.buildVideoOptions())
        .controls(true)
        .width('100%')
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onPrepared((event) => {
          if (event) {
            this.duration = event.duration;
          }
          this.statusText = '视频已就绪';
        })
        .onUpdate((event) => {
          if (event) {
            this.currentTime = event.time;
          }
        })
        .onPause(() => {
          this.statusText = '已暂停';
        })
        .onFinish(() => {
          this.controller.exitFullscreen();
        })
        .onStart(() => {
          this.statusText = '播放中';
        });
    } else {
      Video(this.buildVideoOptions())
        .controls(true)
        .width('100%')
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onPrepared((event) => {
          if (event) {
            this.duration = event.duration;
          }
          this.statusText = '视频已就绪';
        })
        .onUpdate((event) => {
          if (event) {
            this.currentTime = event.time;
          }
        })
        .onPause(() => {
          this.statusText = '已暂停';
        })
        .onStart(() => {
          this.statusText = '播放中';
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

          Text('fullscreen 测试')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F3F4F6')
        }
        .width('100%')

        Text('本页只验证全屏和退出全屏的行为')
          .fontSize(14)
          .fontColor('#B8C3D1')
          .width('100%')

        // Text('当前测试视频: test1.mp4')
        //   .fontSize(14)
        //   .fontColor('#F8D66D')
        //   .width('100%')

        Column({ space: 12 }) {
          this.buildVideoPlayer()

          Text('状态: ' + this.statusText)
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')

          Text('时间: ' + this.formatDuration(this.currentTime) + ' / ' + this.formatDuration(this.duration))
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')
        }
        .padding(20)
        .backgroundColor('#101923')
        .borderRadius(24)

        Row({ space: 10 }) {
          Button('播放').onClick(() => { this.controller.start(); })
          Button('暂停').onClick(() => { this.controller.pause(); })
          Button('全屏').onClick(() => { this.controller.requestFullscreen(true); })
          // Button('重置').onClick(() => {
          //   this.controller.reset();
          //   this.statusText = '已调用 reset，请观察视频暂停并显示当前帧';
          // })
        }
        .width('100%')

        // Text('执行建议: 点击重置后，再点击播放，确认视频从起始位置重新播放。')
        //   .fontSize(14)
        //   .fontColor('#B8C3D1')
        //   .width('100%')
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
