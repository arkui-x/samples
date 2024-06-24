import { NewHomeItem } from './NewHomeItem'
import { homePageRequest, NewsItem } from '../util/Request'
import promptAction from '@ohos.promptAction'
import { NewsSource } from './NewsLazy'
import { OfflinePage } from '../components/OfflinePage'

@Component
export struct NewHomePage {
  scroller: Scroller = new Scroller()
  @State news: NewsSource = new NewsSource();
  @State @Watch('getNews') isShow: boolean = false
  @State isLoading: boolean = false
  @State touchOld: number = 0
  @State isWaitingForLoading: boolean = true

  aboutToAppear() {
    homePageRequest().then(res => {
      this.news.news = res
    }).catch(() => {
      promptAction.showToast({ message: '请确保网络已连接' });
      this.isShow = false
    });

    setTimeout(() => {
      this.isWaitingForLoading = false
    }, 3900)
  }

  getNews() {
    if (this.isShow) {
      homePageRequest().then(res => {
        this.news.news = res
        this.isShow = false
      }).catch(() => {
        promptAction.showToast({ message: '请确保网络已连接' });
        this.isShow = false
      });
    }
  }

  build() {
    Column() {
      if (this.news.totalCount() == 0) {
        if (this.isWaitingForLoading) {
          LoadingProgress()
            .color(0xf04142)
            .width(70)
            .height(70)
            .margin({top: 180})
        } else {
          OfflinePage({ isShow: this.isShow })
        }
      } else {
        List({ scroller: this.scroller }) {
          LazyForEach(this.news, (t: NewsItem, i: number) => {
            ListItem() {
              NewHomeItem({ t: t, i: i })
            }
            .padding({ left: 15, right: 15 })
          }, (item: string) => item)
        }
        .edgeEffect(EdgeEffect.None)
        .onScrollIndex((first: number, last: number) => {
          let total: number = this.news.totalCount() - 2
          if (last > total) {
            homePageRequest().then(res => {
              this.news.addBatchData(res)
            }).catch(() => {
              promptAction.showToast({ message: '请确保网络已连接' });
            });
          }
        })
      }
    }
    .height('88%')
    .margin({ bottom: 70 })

  }
}