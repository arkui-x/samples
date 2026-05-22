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
            Button('UDPSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/UDPsocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button(' UDPSocket_MulticastSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/UDPsocket_MulticastSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('LocalSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/LocalSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('LocalSocketConnection')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/LocalSocketConnection'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('LocalSocketServer')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/LocalSocketServer'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('TCPSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TCPSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('TLSSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocket'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('TCPSocketConnection')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TCPSocketConnection'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('TCPSocketServer')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TCPSocketServer'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('TLSSocketConnection')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })

            Button('TLSSocketServer')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })

            Button('Socket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/construct'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })

            Button('Addition ErrorCode')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode'
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