import { getTimeStr } from '../util/Common'
import { NewsItem } from '../util/Request'
import router from '@ohos.router';
import { images } from '../util/Mock';

@Component
export struct VideoItem {
  @Prop t: NewsItem;
  private random: number = Math.floor(Math.random() * 5)

  @Builder
  VideoOverlay() {
    Column() {
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
    .height('80%')
    .width('90%')
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      router.pushUrl({ url: 'pages/video/VideoDetail', params: { random: this.random } })
    })
  }

  build() {
    Column({ space: 15 }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
          //Author profile picture
          Column() {
            Image(this.t.user_info.avatar_url)
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
        }

        //Video content
        Column() {
          Image(images[this.random])
            .height(240)
            .width('100%')
        }
        .height(240)
        .width('100%')
        .overlay(this.VideoOverlay())
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