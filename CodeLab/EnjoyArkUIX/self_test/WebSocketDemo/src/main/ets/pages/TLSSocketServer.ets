import router from '@ohos.router';

@Entry
@Component
struct TLSSocketServer {
  build() {
    Row() {
      Column() {
        Text('TLSSocketServerDemo')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .margin({ top: 10, bottom: 25 })
        Scroll() {
          Column() {
            Button('close')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_close'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getCertificate')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_getCertificate'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getLocalAddress')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_getLocalAddress'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getSocketFd')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_getSocketFd'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getProtocol')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_getProtocol'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('getState')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_getState'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('listen')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_listen'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('on/off_connect')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_on_connect'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('on/off_error')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_on_error'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('setExtraOptions')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/TLSSocketServer_setExtraOptions'
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