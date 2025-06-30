import router from '@ohos.router'
@Entry
@Component
struct videoModule {
  @State videoSrc: Resource = $rawfile('video1.mp4')
  @State previewUri: Resource = $r('app.media.poster1')
  @State curRate: PlaybackSpeed = PlaybackSpeed.Speed_Forward_1_00_X
  @State isAutoPlay: boolean = false
  @State showControls: boolean = true
  controller: VideoController = new VideoController()

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .size({width: 30, height: 30})
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })
        Text('媒体组件')
          .fontSize(24)
          .fontWeight(500)
          .fontColor(Color.Black)
          .opacity(0.9)
          .letterSpacing(2)
          .padding({ left: 10})
      }.size({width: '100%'})
      Video({
        src: this.videoSrc,
        previewUri: this.previewUri,
        currentProgressRate: this.curRate,
        controller: this.controller
      })
        .objectFit(ImageFit.Fill)
        .width('100%')
        .height('60%')
        .autoPlay(this.isAutoPlay)
        .controls(this.showControls)
        .onStart(() => {
          console.info('onStart')
        })
        .onPause(() => {
          console.info('onPause')
        })
        .onFinish(() => {
          console.info('onFinish')
        })
        .onError(() => {
          console.info('onError')
        })
        .onPrepared((e?: DurationObject) => {
          if (e != undefined) {
            console.info('onPrepared is ' + e.duration)
          }
        })
        .onSeeking((e?: TimeObject) => {
          if (e != undefined) {
            console.info('onSeeking is ' + e.time)
          }
        })
        .onSeeked((e?: TimeObject) => {
          if (e != undefined) {
            console.info('onSeeked is ' + e.time)
          }
        })
        .onUpdate((e?: TimeObject) => {
          if (e != undefined) {
            console.info('onUpdate is ' + e.time)
          }
        })

      Row() {
        Button('src').onClick(() => {
          this.videoSrc = $rawfile('video2.mp4') // 切换视频源
        }).margin(5)
        Button('previewUri').onClick(() => {
          this.previewUri = $r('app.media.poster2') // 切换视频预览海报
        }).margin(5)
        Button('controls').onClick(() => {
          this.showControls = !this.showControls // 切换是否显示视频控制栏
        }).margin(5)
      }

      Row() {
        Button('start').onClick(() => {
          this.controller.start() // 开始播放
        }).margin(5)
        Button('pause').onClick(() => {
          this.controller.pause() // 暂停播放
        }).margin(5)
        Button('stop').onClick(() => {
          this.controller.stop() // 结束播放
        }).margin(5)
        Button('setTime').onClick(() => {
          this.controller.setCurrentTime(10, SeekMode.Accurate) // 精准跳转到视频的10s位置
        }).margin(5)
      }

      Row() {
        Button('rate 0.75').onClick(() => {
          this.curRate = PlaybackSpeed.Speed_Forward_0_75_X // 0.75倍速播放
        }).margin(5)
        Button('rate 1').onClick(() => {
          this.curRate = PlaybackSpeed.Speed_Forward_1_00_X // 原倍速播放
        }).margin(5)
        Button('rate 2').onClick(() => {
          this.curRate = PlaybackSpeed.Speed_Forward_2_00_X // 2倍速播放
        }).margin(5)
      }
    }
  }
}

interface DurationObject {
  duration: number;
}

interface TimeObject {
  time: number;
}