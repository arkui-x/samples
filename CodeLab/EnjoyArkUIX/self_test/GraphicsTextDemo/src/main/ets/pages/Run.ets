import router from '@ohos.router';
import { TitleBar } from './title';


@Entry
@Component
struct RenderTest {
  @State title: string = 'Test Run'

  build() {
    Row() {
      Column() {
        Scroll() {
          Column() {
            TitleBar()

            Text(this.title)
              .fontSize(35)
              .margin(20)

            Button('设置中文验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run' });
              })
            Button('设置韩语文验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run1' });
              })
            Button('设置日语文验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run2' });
              })

            Button('设置缅甸文验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run3' });
              })
            Button('设置藏语验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run4' });
              })
            Button('设置阿拉伯语验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run5' });
              })
            Button('设置蒙文验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run6' });
              })
            Button('设置特殊符号验证Run属性方法')
              .width('100%')
              .height(50)
              .fontSize(15)
              .margin(5)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Run/Test_Run7' });
              })

          }
        }
      }
      .width('100%')
    }
    .height('100%')
  }
}

