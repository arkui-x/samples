import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Text('TestDemo')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .margin({ top: 10, bottom: 25 })
        Scroll() {
          Column() {
            Button('Socket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Socket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('SocketErrorCode')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor('#0A59F7')
        .scrollBarWidth(10)
        .edgeEffect(EdgeEffect.Spring)
        .height('80%')
        .flexGrow(1)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width('100%')
  }
}