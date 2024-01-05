import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { images, videos } from '../util/Mock';

interface Params {
  random: number;
}

@Entry
@Component
struct VideoDetail {
  controller: VideoController = new VideoController();
  @State isPlay: boolean = false
  @State isPrepared: boolean = false
  private random: number = 0

  aboutToAppear() {
    let params = router.getParams() as Params
    this.random = params.random
  }

  @Builder
  VideoOverlay() {
    Column() {
      if (!this.isPlay) {
        Column() {
          Image($r('app.media.bofang'))
            .height(30)
            .width(30)
        }
        .height(30)
        .width(30)
        .position({ x: '50%', y: '50%' })
        .translate({ x: '-50%', y: '-50%' })
      }
    }
    .height('80%')
    .width('90%')
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (this.isPrepared) {
        if (this.isPlay) {
          this.controller.pause()
        } else {
          this.controller.start()
        }
        this.isPlay = !this.isPlay
      } else {
        promptAction.showToast({ message: '请稍等，视频加载中' });
      }
    })
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Column() {
          ImageSpan($r('app.media.ic_public_arrow_left'))
            .width(18)
            .height(18)
            .objectFit(ImageFit.Contain)
        }
        .padding({ right: 8 })
        .onClick(() => {
          router.back()
          this.controller.stop()
        })

        Search({ placeholder: '搜你想看的' })
          .height(40)
          .backgroundColor("#f1f3f4")
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 12 })
        Column() {
          ImageSpan($r('app.media.ic_device_earphone_filled'))
            .width(18)
            .height(18)
            .objectFit(ImageFit.Contain)
        }
        .margin({ left: 12, right: 15 })

        Column() {
          ImageSpan($r('app.media.ic_more'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
        }
      }
      .padding({ top: 20, left: 10, right: 10 })
      .backgroundColor(Color.White)

      Column() {
        Column() {
          Video({
            src: videos[this.random],
            previewUri: images[this.random],
            controller: this.controller,
          })
            .height(240)
            .width('100%')
            .controls(false)
            .objectFit(ImageFit.Cover)
            .onPrepared(() => {
              console.log('this.isPrepared', '视频准备好了')
              this.isPrepared = true
              this.controller.start()
              this.isPlay = !this.isPlay
            })
            .onError(() => {
              promptAction.showToast({ message: '视频播放失败，请稍后重试' });
            })
            .onFinish(() => {
              this.isPlay = !this.isPlay
            })
        }
        .height(240)
        .width('100%')
        .overlay(this.VideoOverlay())
        .position({ y: '15%' })
      }
      .padding({ left: 5, right: 5 })
      .height('100%')
      .width('100%')
    }
    .backgroundColor(Color.White)
  }
}