import { ImageList, NewsItem } from '../util/Request'
import router from '@ohos.router';
import { getTimeStr } from '../util/Common';

@Component
export struct NewHomeItem {
  @Prop t: NewsItem
  @Prop i: number

  skipRouter(ary: ImageList[]) {
    router.pushUrl({
      url: "pages/news/NewsDetail",
      params: {
        source: this.t.source,
        digg_count: this.t.digg_count,
        title: this.t.title,
        comment_count: this.t.comment_count,
        publish_time: this.t.publish_time,
        share_count: this.t.share_count,
        avatar_url: this.t.user_info.avatar_url,
        content: this.t.abstract,
        image_list: ary
      }
    })
  }

  build() {
    Column() {
      if (this.i < 5 && this.t.title) {
        Column() {
          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
            Text(this.t.title)
              .fontSize(15)
              .margin({ bottom: 5 })
              .maxLines(1)
            Flex() {
              Text('置顶')
                .fontColor('#f04142')
                .fontSize(12)
              Text(this.t.source)
                .fontColor('#999999')
                .fontSize(12)
                .margin({ left: 10, right: 10 })
              Text(`${this.t.comment_count} 评论`)
                .fontColor('#999999')
                .fontSize(12)
            }
          }
          .height(45)
          .onClick(() => {
            console.log('this.t.has_image',this.t.has_image)
            if (this.t.has_image) {
              if (this.t.detail_image_list) {
                this.skipRouter(this.t.detail_image_list)
              }else if (this.t.image_list) {
                let imgAry: ImageList[] = this.t.image_list.map((t: ImageList): ImageList => new ImageList(t.height, t.uri, t.url.replace('http', 'https'), t.url_list, t.width))
                this.skipRouter(imgAry)
              }else {
                this.skipRouter([])
              }
            } else {
              this.skipRouter([])
            }
          })
        }

        if (this.i == 4) {
          Divider()
            .strokeWidth(1)
            .color(Color.Grey)
            .width('100%')
            .opacity(0.2)
            .margin({ top: 10 })
        }
      } else {
        if (this.t.title) {
          if (this.t.has_image) {
            if (this.t.image_list) {
              Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
                Text(this.t.title)
                  .fontSize(15)
                  .margin({ bottom: 10 })
                  .maxLines(1)
                Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
                  ForEach(this.t.image_list, (t: ImageList, i: number) => {
                    Column() {
                      Image(t.url.replace('http', 'https'))
                        .height(90)
                        .width(93)
                    }
                  })
                }
                .height(90)
                .margin({ bottom: 10 })

                Flex() {
                  Text(this.t.source)
                    .fontColor('#999999')
                    .fontSize(12)
                  Text(`${this.t.comment_count} 评论`)
                    .fontColor('#999999')
                    .fontSize(12)
                    .margin({ left: 10, right: 10 })
                  Text(getTimeStr(this.t.behot_time - this.t.publish_time))
                    .fontColor('#999999')
                    .fontSize(12)
                }
              }
              .height(160)
              .onClick(() => {
                let imgAry: ImageList[] = this.t.image_list.map((t: ImageList): ImageList => new ImageList(t.height, t.uri, t.url.replace('http', 'https'), t.url_list, t.width))
                this.skipRouter(imgAry)
              })
            }
            if (this.t.detail_image_list) {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Flex({
                  direction: FlexDirection.Column,
                  justifyContent: FlexAlign.SpaceBetween,
                  alignItems: ItemAlign.Start
                }) {
                  Text(this.t.title)
                    .fontSize(15)
                    .margin({ bottom: 10 })
                    .maxLines(2)
                  Flex() {
                    Text(this.t.source)
                      .fontColor('#999999')
                      .fontSize(12)
                    Text(`${this.t.comment_count} 评论`)
                      .fontColor('#999999')
                      .fontSize(12)
                      .margin({ left: 10, right: 10 })
                    Text(getTimeStr(this.t.behot_time - this.t.publish_time))
                      .fontColor('#999999')
                      .fontSize(12)
                  }
                }
                .width('70%')
                .margin({ right: 10 })

                ForEach(this.t.detail_image_list, (t: ImageList, i: number) => {
                  Column() {
                    Image(t.url)
                      .height(90)
                      .width(130)
                  }
                })
              }
              .height(100)
              .width('100%')
              .onClick(() => {
                this.skipRouter(this.t.detail_image_list)
              })
            }
          }
        }
      }
    }
    .padding({ bottom: 10 })
  }
}