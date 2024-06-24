import { homePageRequest, NewsItem } from '../util/Request';
import { TopSearch } from '../components/TopSearch'
import promptAction from '@ohos.promptAction';
import { VideoItem } from './VideoItem';
import { OfflinePage } from '../components/OfflinePage';
import { VideoSource } from './VideoLazy';

@Component
export struct VideoPage {
  @State videoMap: VideoSource = new VideoSource()
  scroller: Scroller = new Scroller()
  @State @Watch('getNews') isShow: boolean = false
  @State isWaitingForLoading: boolean = true

  async getNews() {
    if (this.isShow) {
      let item: NewsItem[] = await homePageRequest('video')
      if (item[item.length - 1].user_info.avatar_url != undefined) {
        this.videoMap.video = item
        this.isShow = false
      }
    }
  }

  async aboutToAppear() {
    setTimeout(() => {
      this.isWaitingForLoading = false
    }, 30000)

    for (let i = 0; i < 21; i++) {
      let item: NewsItem[] = await homePageRequest('video')
      if (item[item.length - 1].user_info.avatar_url != undefined) {
        this.videoMap.video = item
        this.isShow = false
        return
      } else {
        setTimeout(() => {
        }, 1000)
      }
    }

  }

  build() {
    Column() {
      TopSearch()
      if (!this.videoMap.totalCount()) {
        if (this.isWaitingForLoading) {
          LoadingProgress()
            .color(0xf04142)
            .width(70)
            .height(70)
            .margin({top: 180})
        } else {
          Column() {
            OfflinePage({ isShow: this.isShow })
          }
          .margin({ top: 50 })
        }
      } else {
        List({ scroller: this.scroller, space: 15 }) {
          LazyForEach(this.videoMap, (t: NewsItem, i: number) => {
            ListItem() {
              if (t.user_info && t.source) {
                VideoItem({
                  t: t
                })
              }
            }.padding({ left: 15, right: 15 })
          }, (t: NewsItem, i: number) => i.toString())
        }
        .edgeEffect(EdgeEffect.None)
        .height('90%')
        .padding({ top: 15 })
        .onReachEnd(async () => {
          let item: NewsItem[] = await homePageRequest('video')
          if (item[item.length - 1].user_info.avatar_url != undefined) {
            this.videoMap.addBatchData(item)
          }
        })

      }
    }
    .height('100%')
  }
}