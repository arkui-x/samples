import router from '@ohos.router'

// Page title bar
@Component
export struct TitleBar {
  @Prop title: Resource

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(20)
          .height(20)
          .margin({ left: 26 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
          .id('backBtn')
        Text(this.title)
          .fontSize(20)
          .layoutWeight(1)
          .margin({ left: 16 })
          .align(Alignment.Start)
        Blank()
      }
      .height(56)
      .width('100%')
    }
  }
}