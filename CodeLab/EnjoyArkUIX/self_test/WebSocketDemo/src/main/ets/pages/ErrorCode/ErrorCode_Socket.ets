import router from '@ohos.router';

@Entry
@Component
struct Socket {
  build() {
    Row() {
      Column() {
        Text('SocketTestDemo')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .margin({ top: 10, bottom: 25 })
        Scroll() {
          Column() {
            Button('ErrorCode_UDPSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_UDPSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_LocalSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_LocalSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_LocalSocketConnection')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_LocalSocketConnection'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_LocalSocketServer')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_LocalSocketServer'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TCPSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TCPSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TCPSocketConnection')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TCPSocketConnection'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TCPSocketServer')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TCPSocketServer'
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