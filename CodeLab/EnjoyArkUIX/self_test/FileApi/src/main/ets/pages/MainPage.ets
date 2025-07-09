import router from '@ohos.router'

@Component
export struct TitleBar {
  @State isMarquee: boolean = false
  private title: Resource | string = ''

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
          .maxLines(1)
          .fontWeight(FontWeight.Bold)
          .fontSize(20)
          .margin({ left: 8, right: 8 })
          .width('75%')
          .onDisAppear(() => {
            this.isMarquee = false
          })
          .onAppear(() => {
            setTimeout(() => {
              this.isMarquee = true
            }, 1500)
          })
          .textOverflow(this.isMarquee ? { overflow: TextOverflow.MARQUEE } : { overflow: TextOverflow.None })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
  }
}