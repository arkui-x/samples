import router from '@ohos.router';

@Entry
@Component
struct PosterOptionsTest {
  private controller: VideoController = new VideoController();

  @State currentVideo: Resource = $rawfile('test3.mp4');
  // @State currentVideo: Resource | string = "https://contentcenter-test-bj4-001.obs.cn-north-4.myhwclouds.com/test_media/hw264/twopass/10513122801614825024851_tp.mp4";
  // https://contentcenter-test-bj4-001.obs.cn-north-4.myhwclouds.com/test_media/hw264/twopass/10513122801614825024851_tp.mp4
  @State playerVersion: number = 0;
  @State currentMode: number = 0;
  @State modeLabel: string = '未设置 posterOptions';
  @State expectedResult: string = '初始化后默认显示黑屏';
  @State statusText: string = '等待操作';

  private buildVideoOptions(): VideoOptions {
    let options: VideoOptions = {
      src: this.currentVideo,
      controller: this.controller
    };

    if (this.currentMode === 1) {
      options.posterOptions = { showFirstFrame: true };
    } else if (this.currentMode === 2) {
      options.posterOptions = { showFirstFrame: false };
    }

    return options;
  }

  private reloadPlayer(): void {
    this.controller.stop();
    this.controller = new VideoController();
    this.playerVersion = this.playerVersion + 1;
    this.statusText = '已重新装载视频';
  }

  private applyPosterMode(mode: number): void {
    this.currentMode = mode;
    if (mode === 1) {
      this.modeLabel = 'posterOptions.showFirstFrame = true';
      this.expectedResult = '视频初始化后显示首帧内容';
    } else if (mode === 2) {
      this.modeLabel = 'posterOptions.showFirstFrame = false';
      this.expectedResult = '视频初始化后显示黑屏';
    } else {
      this.modeLabel = '未设置 posterOptions';
      this.expectedResult = '视频初始化后默认显示黑屏';
    }
    this.reloadPlayer();
  }

  @Builder
  private buildVideoPlayer() {
    if (this.playerVersion % 2 === 0) {
      Video(this.buildVideoOptions())
        // .controls(true)
        .width('100%')
        // .aspectRatio(16/9)
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onPrepared(() => {
          this.statusText = '已触发 onPrepared，请观察初始化画面';
        })
        .onStart(() => {
          console.log('onStart');
        })
        .onPause(() => {
          console.log('onPause');
        })
        .onUpdate(() => {
          console.log('onUpdate');
        })
        .onFinish(() => {
          console.log('onFinish');
        })
        .onError(() => {
          console.log('onError');
        })
        .onSeeking(() => {
          console.log('onSeeking');
        })
        .onSeeked(() => {
          console.log('onSeeked');
        });
    } else {
      Video(this.buildVideoOptions())
        // .controls(true)
        .width('100%')
        // .aspectRatio(16/9)
        .height(260)
        .backgroundColor('#000000')
        .borderRadius(20)
        .onPrepared(() => {
          this.statusText = '已触发 onPrepared，请观察初始化画面';
        })
        .onStart(() => {
          console.log('onStart');
        })
        .onPause(() => {
          console.log('onPause');
        })
        .onUpdate(() => {
          console.log('onUpdate');
        })
        .onFinish(() => {
          console.log('onFinish');
        })
        .onError(() => {
          console.log('onError');
        })
        .onSeeking(() => {
          console.log('onSeeking');
        })
        .onSeeked(() => {
          console.log('onSeeked');
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

          Text('首帧送显测试')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#F3F4F6')
        }
        .width('100%')

        Text('本页只验证 posterOptions.showFirstFrame。切换模式后会重新挂载 Video 组件。')
          .fontSize(14)
          .fontColor('#B8C3D1')
          .width('100%')

        // Text('当前测试视频: test2.mp4')
        //   .fontSize(14)
        //   .fontColor('#F8D66D')
        //   .width('100%')

        Column({ space: 12 }) {
          this.buildVideoPlayer()

          Text('当前模式: ' + this.modeLabel)
            .fontSize(14)
            .fontColor('#E5E7EB')
            .width('100%')

          Text('预期结果: ' + this.expectedResult)
            .fontSize(14)
            .fontColor('#F8D66D')
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
          Button('showFirstFrame = true').onClick(() => { this.applyPosterMode(1); })
            .width('100%')

          Button('showFirstFrame = false').onClick(() => { this.applyPosterMode(2); })
            .width('100%')
        }
        .width('100%')

        Button('未设置 posterOptions')
          .width('100%')
          .onClick(() => {
            this.applyPosterMode(0);
          })

        Text('每次切换后请先观察初始画面，再决定是否点击播放。')
          .fontSize(14)
          .fontColor('#B8C3D1')
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
