import router from '@ohos.router'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap}) {
          Button('下载')
            .fontSize(14)
            .margin({ top: 15, left:5 })
            .fontWeight(FontWeight.Bold)
            .width('50%')
            .onClick(async () => {
              await router.pushUrl({url: "pages/download"});
            })
          Button('上传')
            .fontSize(14)
            .margin({ top: 20, left:5 })
            .fontWeight(FontWeight.Bold)
            .width('50%')
            .onClick(async () => {
              await router.pushUrl({url: "pages/upload"});
            })
        }
        .width('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
}
