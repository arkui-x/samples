import { getTimeStr } from '../util/Common'
import { NewsItem } from '../util/Request'
import router from '@ohos.router';
import { images, videos } from '../util/Mock';

@Component
export struct VideoItem {
  @Prop t: NewsItem;
  private random: number = Math.floor(Math.random() * 5)
  @State isPlayVideo: boolean = false
  @State isplaying: boolean = false
  controller: VideoController = new VideoController()

  @Builder
  VideoOverlay() {
    Column() {
      Column() {
        Image($r('app.media.bofang'))
          .height(30)
          .width(30)
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column({ space: 15 }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
          //Author profile picture
          Column() {
            Image(this.t.user_info ? this.t.user_info.avatar_url : this.t.media_info.avatar_url)
              .height(30)
              .width(30)
              .objectFit(ImageFit.Contain)
              .borderRadius(15)
          }
          .borderRadius(13)

          //Author nickname
          Column() {
            Text(this.t.source)
              .fontSize(12)
              .width('100%')
              .fontColor(Color.Black)
          }
          .padding({ left: 10, right: 10 })
        }.width('85%')

        //Follow button
        Button() {
          Text('关注')
            .fontSize(12)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
        }
        .height(22)
        .width(50)
        .backgroundColor(Color.White)
        .border({ width: 1, color: '#999' })
      }

      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        // Video title
        Column() {
          Text(this.t.title)
            .fontSize(15)
            .maxLines(2)
            .fontColor(Color.Black)
        }

        //Video content
        Column() {
          if (this.isPlayVideo) {
            Video({
              src: videos[this.random],
              previewUri: images[this.random],
              controller: this.controller,
            })
              .width('100%')
              .height(194)
              .autoPlay(true)
              .controls(false)
              .objectFit(ImageFit.Contain)
              .onStart(() => {
                this.isplaying = true
              })
              .onPause(() => {
                this.isplaying = false
              })
              .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
                if (currentRatio < 0.9 || !isVisible) {
                  this.controller.stop()
                  this.isplaying = false
                  this.isPlayVideo = false
                }
              })
              .onFinish(() => {
                this.isplaying = false
                this.isPlayVideo = false
              })

          } else {
            Image(images[this.random])
              .height(194)
              .width('100%')
              .overlay(this.VideoOverlay())
              .onClick(() => {
                this.isPlayVideo = true
              })
          }

        }
        .width('100%')
        .margin({ top: 8, bottom: 8 })

        // Video source
        Flex() {
          // Video source
          Text(this.t.source)
            .fontColor('#999999')
            .fontSize(12)
          // Video review count
          Text(`${this.t.comment_count} 评论`)
            .fontColor('#999999')
            .fontSize(12)
            .margin({ left: 10, right: 10 })
          // Video release time
          Text(getTimeStr(this.t.behot_time - this.t.publish_time))
            .fontColor('#999999')
            .fontSize(12)
        }
      }
      .constraintSize({ minHeight: 260 })
    }
    .constraintSize({ minHeight: 300 })
  }
}