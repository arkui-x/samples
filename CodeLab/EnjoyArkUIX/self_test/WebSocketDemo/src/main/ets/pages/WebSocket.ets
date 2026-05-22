import router from '@ohos.router';

@Entry
@Component
struct WebScoket {
  build() {
    Row() {
      Column() {
        // 标题
        Text('WebSocketTestDemo')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#0A59F7')
          .margin({ top: 10, bottom: 25 })

        // 使用Scroll组件包裹按钮列表
        Scroll() {
          Column() {
            Button('WebSocket_on/off_headerReceive')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocket_on_headerReceive'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            // Button('WebSocketServer')
            //   .onClick(() => {
            //     router.pushUrl({
            //       url: 'pages/WebSocketServer'
            //     });
            //   })
            //   .margin({ bottom: 15 })
            Button('WebSocketServer_Start')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_Start'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_listAllConnections')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_listAllConnections'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_Close')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_Close'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            // Button('WebSocketServer_Close_xin')
            //   .onClick(() => {
            //     router.pushUrl({
            //       url: 'pages/WebSocketServer_Close_xin'
            //     });
            //   })
            //   .width('70%')
            //   .height(45)
            //   .margin({ bottom: 15 })
            Button('WebSocketServer_Send')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_Send'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_On/Off_error')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_on_error'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_On/Off_connect')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_on_connect'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_On/Off_messageReceive')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_on_messageReceive'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_On/Off_close')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_on_close'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocketServer_Stop')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocketServer_Stop'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocket_connect')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Websocket_connect'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
            Button('WebSocket_connect_2')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebSocket_connect_2'
                });
              })
              .width('70%')
              .height(45)
              .margin({ bottom: 15 })
          }
          .width('100%')
        }
        .scrollable(ScrollDirection.Vertical) // 设置为垂直滚动
        .scrollBar(BarState.On) // 始终显示滚动条
        .scrollBarColor('#0A59F7') // 滚动条颜色
        .scrollBarWidth(10) // 滚动条宽度
        .edgeEffect(EdgeEffect.Spring) // 滚动边界效果
        .height('80%') // 设置滚动区域高度
        .flexGrow(1) // 让Scroll填充剩余空间
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width('100%')
  }
}