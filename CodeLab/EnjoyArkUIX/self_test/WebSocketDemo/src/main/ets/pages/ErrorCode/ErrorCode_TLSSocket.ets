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
            Button('ErrorCode_TLSSocket')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocket1'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_close')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_close'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_getCipherSuite')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_getCipherSuite'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_getLocalAddress')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_getLocalAddress'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_getRemoteAddress')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_getRemoteAddress'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_getRemoteCertificate')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_getRemoteCertificate'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_getSignatureAlgorithms')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_getSignatureAlgorithms'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketConnection_send')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketConnection_send'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketServer_getCertificate')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketServer_getCertificate'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketServer_getLocalAddress')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketServer_getLocalAddress'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketServer_getState')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketServer_getState'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketServer_listen')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketServer_listen'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('ErrorCode_TLSSocketServer_setExtraOptions')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ErrorCode/ErrorCode_TLSSocketServer_setExtraOptions'
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