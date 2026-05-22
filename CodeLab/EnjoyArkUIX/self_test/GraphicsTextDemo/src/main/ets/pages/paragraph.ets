import router from '@ohos.router';
import { TitleBar } from './title';


@Entry
@Component
struct RenderTest {
  @State title: string = 'Test paragraph'

  build() {
    Row() {
      Column() {
        Scroll() {
          Column() {
            TitleBar()

            Text(this.title)
              .fontSize(35)
              .margin(20)

            Button('设置中英文验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph' });
              })
            Button('设置韩语文验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph1' });
              })
            Button('设置日语文验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph2' });
              })

            Button('设置缅甸文验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph3' });
              })
            Button('设置藏语验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph4' });
              })
            Button('设置阿拉伯语验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph5' });
              })
            Button('设置蒙文验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph6' });
              })
            Button('设置特殊符号验证paragraph属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph7' });
              })
            Button('Test Paragraph：paint')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/paragraph/Test_paragraph_paint' });
              })
          }
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

