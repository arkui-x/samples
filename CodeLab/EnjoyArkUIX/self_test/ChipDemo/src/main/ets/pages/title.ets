import router from '@ohos.router';

// Page title bar
@Component
export struct TitleBar {

  build() {
    Column() {
      Row() {
        Text('返回')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor("#E6000000")
          .margin({ left: 8, right: 8 })
          .onClick(() => {
            router.back()
          })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
  }
}