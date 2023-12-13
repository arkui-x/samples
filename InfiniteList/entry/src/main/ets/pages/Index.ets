import { MyDataSource } from '../bean/MyDataSource'
import { InfiniteData } from '../bean/InfiniteData'

@Entry
@Component
struct Index {
  @State myData: MyDataSource = new MyDataSource()
  @State isReachEnd: number = 0
  @State control: boolean = true

  build() {
    Row() {
      Flex({ direction: FlexDirection.Column }) {
        Text('Infinite List Sample')
          .fontSize(24)
          .backgroundColor(Color.Grey)
          .padding(12)
          .margin({
            bottom: 12
          })
          .width('100%')
          .height(55)
        List({ space: 10 }) {
          LazyForEach(this.myData, (item: InfiniteData) => {
            ListItem() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
                  Text()
                    .width(65)
                    .height(65)
                    .backgroundColor(item.color)
                    .margin({ right: 12 })
                  Text(item.title).fontSize(24)
                }
                .width('80%')
                .padding({ left: 12 })
                Text(item.price)
                  .height(50)
                  .width('20%')
              }
            }
          })
        }
        .cachedCount(8)
        .onReachEnd(() => {
          if (this.control) {
            this.control = false
            const now = new Date().getTime()
            if (now - this.isReachEnd >= 350) {
              this.isReachEnd = now
              AlertDialog.show(
                {
                  title: 'tips',
                  message: '是否继续加载？',
                  alignment: DialogAlignment.Bottom,
                  gridCount: 4,
                  offset: { dx: 0, dy: -20 },
                  primaryButton: {
                    value: '取消',
                    action: () => {
                      this.isReachEnd = new Date().getTime()
                      this.control = true
                    }
                  },
                  secondaryButton: {
                    value: '确定',
                    action: () => {
                      const total = this.myData.totalCount()
                      const count = total / 200
                      const moreData: Array<InfiniteData> = this.myData.setData(count)
                      this.myData.addBatchData(moreData)
                      this.isReachEnd = new Date().getTime()
                      this.control = true
                    }
                  },
                  cancel: () => {
                    this.isReachEnd = new Date().getTime()
                    this.control = true
                  }
                }
              )
            } else {
              this.isReachEnd = now
            }
          }
        })
      }
      .width('100%')
      .height('100%')
      .padding({
        bottom: 12
      })
    }
    .height('100%')
  }
}
