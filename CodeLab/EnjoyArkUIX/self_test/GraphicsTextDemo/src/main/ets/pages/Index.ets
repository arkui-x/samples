import router from '@ohos.router';


@Entry
@Component
struct RenderTest {
  @State title: string = 'Test graphics text'

  build() {
    Row() {
      Column() {
        Scroll() {
          Column() {
            Text(this.title)
              .fontSize(35)
              .margin(20)

            Button('Test_graphics_text_Interface')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Test_graphics_text_Interface' });
              })

            Button('Test_graphics_text：FontCollection')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Test_FontCollection' });
              })

            Button('Test_graphics_text：paragraphBuilder')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Test_paragraphBuilder' });
              })

            Button('Test_graphics_text：paragraph')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph' });
              })

            Button('Test_graphics_text：TextLine')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine' });
              })

            Button('Test_graphics_text：Run')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run' });
              })

            Button('Test attribute Style')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/common1' });
              })

          }
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

