import router from '@ohos.router';
import { TitleBar } from './title';


@Entry
@Component
struct RenderTest {
  @State title: string = 'Test TextLine'

  build() {
    Row() {
      Column() {
        Scroll() {
          Column() {
            TitleBar()

            Text(this.title)
              .fontSize(35)
              .margin(20)

            Button('设置中英文验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine' });
              })
            Button('设置韩语文验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine1' });
              })
            Button('设置日语文验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine2' });
              })

            Button('设置缅甸文验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine3' });
              })
            Button('设置藏语验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine4' });
              })
            Button('设置阿拉伯语验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine5' });
              })
            Button('设置蒙文验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine6' });
              })
            Button('设置特殊符号验证TextLine属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine7' });
              })
            Button('Test TextLine:CreateTruncatedLine')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/TextLine/Test_TextLine_paint' });
              })

          }
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

