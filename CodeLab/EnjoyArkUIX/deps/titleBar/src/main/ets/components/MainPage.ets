import router from '@ohos.router';

// Page title bar
@Component
export struct TitleBar {
  private title!: Resource;

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
          .id('backBtn')
        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor("#E6000000")
          .margin({ left: 8, right: 8 })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
  }
}