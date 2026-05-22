// xxx.ets
import router from '@ohos.router';

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  build() {
    Column() {
      Text('KVStoreResultSet test')
        .fontSize('18fp')
        .fontWeight(FontWeight.Bolder)
        .margin({
          left: 16
        })
      Button('返回')
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })
        .width('80%')
        .margin(5)
      Scroll(this.scroller) {
        Column({ space: 20 }) {
          // Button('maxLimitResultSet测试')
          //   .id("maxLimitResultSet")
          //   .onClick(() => {
          //     this.getUIContext().getRouter().pushUrl({
          //       url: 'pages/KVStoreResultSet/maxLimitResultSet'
          //     })
          //   })

          Button('getPosition / getEntry / getCount / moveToFirst / moveToLast测试')
            .id("getPosition")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/getPosition'
              })
            })

          Button('moveToNext测试')
            .id("moveToNext")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/moveToNext'
              })
            })

          Button('moveToPrevious测试')
            .id("moveToPrevious")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/moveToPrevious'
              })
            })

          // Button('getEntry测试')
          //   .id("getEntry")
          //   .onClick(() => {
          //     this.getUIContext().getRouter().pushUrl({
          //       url: 'pages/KVStoreResultSet/getEntry'
          //     })
          //   })

          Button('isFirst测试')
            .id("isFirst")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/isFirst'
              })
            })

          Button('isLast测试')
            .id("isLast")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/isLast'
              })
            })

          Button('move测试')
            .id("move")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/move'
              })
            })

          Button('moveToPosition测试')
            .id("moveToPosition")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/moveToPosition'
              })
            })

          Button('isBeforeFirst测试')
            .id("isBeforeFirst")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/isBeforeFirst'
              })
            })

          Button('isAfterLast测试')
            .id("isAfterLast")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/KVStoreResultSet/isAfterLast'
              })
            })
        }.alignItems(HorizontalAlign.Center).width('100%').margin({ top: 20 })
      }
      .scrollBar(BarState.On)
      .backgroundColor('#E0E0E0')
      .height('80%')
    }
  }
}