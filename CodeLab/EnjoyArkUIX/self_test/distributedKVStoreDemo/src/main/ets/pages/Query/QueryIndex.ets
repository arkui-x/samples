// xxx.ets
import router from '@ohos.router';

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  build() {
    Column() {
      Text('Query test')
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
          Button('reset测试')
            .id("reset")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/reset'
              })
            })

          Button('equalTo测试')
            .id("equalTo")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/equalTo'
              })
            })

          Button('notEqualTo测试')
            .id("notEqualTo")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/notEqualTo'
              })
            })

          Button('greaterThan测试')
            .id("greaterThan")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/greaterThan'
              })
            })

          Button('lessThan测试')
            .id("lessThan")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/lessThan'
              })
            })

          Button('greaterThanOrEqualTo测试')
            .id("greaterThanOrEqualTo")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/greaterThanOrEqualTo'
              })
            })

          Button('lessThanOrEqualTo测试')
            .id("lessThanOrEqualTo")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/lessThanOrEqualTo'
              })
            })

          Button('inNumber测试')
            .id("inNumber")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/inNumber'
              })
            })

          Button('notInNumber测试')
            .id("notInNumber")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/notInNumber'
              })
            })

          Button('inString测试')
            .id("inString")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/inString'
              })
            })

          Button('notInString测试')
            .id("notInString")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/notInString'
              })
            })

          Button('like测试')
            .id("like")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/like'
              })
            })

          Button('unlike测试')
            .id("unlike")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/unlike'
              })
            })

          Button('and/or测试')
            .id("and_or")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/and_or'
              })
            })

          Button('orderByAsc测试')
            .id("orderByAsc")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/orderByAsc'
              })
            })

          Button('orderByDesc测试')
            .id("orderByDesc")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/orderByDesc'
              })
            })

          Button('isNull测试')
            .id("isNull")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/isNull'
              })
            })

          Button('isNotNull测试')
            .id("isNotNull")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/isNotNull'
              })
            })

          Button('prefixKey测试')
            .id("prefixKey")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/prefixKey'
              })
            })

          Button('setSuggestIndex测试')
            .id("setSuggestIndex")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/setSuggestIndex'
              })
            })

          Button('limit测试')
            .id("limit")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/limit'
              })
            })

          Button('beginGroup/endGroup测试')
            .id("beginGroup_endGroup")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/beginGroup_endGroup'
              })
            })

          Button('getSqlLike测试')
            .id("getSqlLike")
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Query/getSqlLike'
              })
            })
        }
        .alignItems(HorizontalAlign.Center).width('100%').margin({ top: 20 })
      }
      .scrollBar(BarState.On)
      .backgroundColor('#E0E0E0')
      .height('80%')
    }
  }
}