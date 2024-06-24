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

  getNews() {
    if (this.isShow) {
      homePageRequest('video').then(res => {
        this.videoMap.video = res
        this.isShow = false
      }).catch(() => {
        promptAction.showToast({ message: '请确保网络已连接' });
        this.isShow = false
      });
    }
  }

  aboutToAppear() {
    homePageRequest('video').then(res => {
      this.videoMap.video = res
      this.isShow = false
    }).catch(() => {
      promptAction.showToast({ message: '请确保网络已连接' });
      this.isShow = false
    });

    setTimeout(() => {
      this.isWaitingForLoading = false
    }, 3900)
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
              VideoItem({
                t: t
              })
            }.padding({ left: 15, right: 15 })
          }, (t: NewsItem, i: number) => i.toString())
        }
        .edgeEffect(EdgeEffect.None)
        .height('90%')
        .padding({ top: 15 })

        .onScrollIndex(async (first: number, last: number) => {
          let total: number = this.videoMap.totalCount() - 2
          if (last > total) {
            let item: NewsItem[] = await homePageRequest('video')
            this.videoMap.addBatchData(item)
          }
        })
      }
    }
    .height('100%')
  }
}