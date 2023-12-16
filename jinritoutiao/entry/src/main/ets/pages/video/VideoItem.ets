import { getTimeStr, getVideoRandom } from '../util/Common'
import { NewsItem } from '../util/Request'
import router from '@ohos.router';

@Component
export struct VideoItem {
  @Prop t: NewsItem;

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
      router.pushUrl({ url: 'pages/video/VideoDetail' })
    })
  }

  build() {
    Column({ space: 15 }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
          //作者头像
          Column() {
            Image(this.t.user_info.avatar_url)
              .height(30)
              .width(30)
              .objectFit(ImageFit.Contain)
              .borderRadius(15)
          }
          .borderRadius(13)

          //作者昵称
          Column() {
            Text(this.t.source)
              .fontSize(12)
              .width('100%')
          }
          .padding({ left: 10, right: 10 })
        }.width('85%')

        //关注按钮
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
        // 视频title
        Column() {
          Text(this.t.title)
            .fontSize(15)
            .maxLines(2)
        }

        //视频内容
        Column() {
          Image(getVideoRandom('uri'))
            .height(240)
            .width('100%')
        }
        .height(240)
        .width('100%')
        .overlay(this.VideoOverlay())
        .margin({ top: 8, bottom: 8 })

        // 视频来源
        Flex() {
          // 视频来源
          Text(this.t.source)
            .fontColor('#999999')
            .fontSize(12)
          // 视频评论数
          Text(`${this.t.comment_count} 评论`)
            .fontColor('#999999')
            .fontSize(12)
            .margin({ left: 10, right: 10 })
          // 视频发布时间
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