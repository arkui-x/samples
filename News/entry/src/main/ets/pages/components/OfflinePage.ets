@Component
export struct OfflinePage {
  @Link isShow: boolean

  build() {
    Column() {
      if (this.isShow) {
        Column() {
          Image($r('app.media.jiazaizhong'))
            .height(50)
            .width(50)
            .margin({ bottom: 20 })
          Text('加载中，请稍等待...')
            .fontColor('#999')
        }
      } else {
        Image($r('app.media.shebeilixian'))
          .height(80)
          .width(80)
        Text('网络不给力')
          .fontColor('#999')
          .margin({ top: 20, bottom: 20 })
        Column() {
          Text('重试').fontColor('#f04142')
        }
        .padding({ top: 8, right: 20, bottom: 8, left: 20 })
        .border({ width: 1, color: '#f04142' })
        .borderRadius(8)
        .onClick(() => {
          this.isShow = true
        })
      }
    }
    .margin({ top: 100 })
  }
}