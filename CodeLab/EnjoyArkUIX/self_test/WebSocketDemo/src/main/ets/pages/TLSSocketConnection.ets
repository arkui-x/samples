import router from '@ohos.router';

@Entry
@Component
struct TLSSocketConnection {
  build() {
    Row() {
      Column() {
        Text('TLSSocketConnectionDemo')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .margin({ top: 10, bottom: 25 })
        Scroll() {
          Column() {
            Button('send')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_send'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('close')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_close'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getRemoteAddress')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_getRemoteAddress'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getRemoteCertificate')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_getRemoteCertificate'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getCipherSuite')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_getCipherSuite'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getSignatureAlgorithms')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_getSignatureAlgorithms'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getLocalAddress')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_getLocalAddress'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getSocketFd')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_getSocketFd'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('on/off_close')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketConnection_on&off_close'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('返回主界面')
              .onClick(() => {router.back();})
              .width('70%')
              .height(45)
              .backgroundColor(Color.Red)
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