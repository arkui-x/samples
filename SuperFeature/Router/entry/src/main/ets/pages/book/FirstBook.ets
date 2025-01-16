import TitleBar from '../../component/TitleBar'
import router from '@ohos.router'

@Entry
@Component
struct FirstBook {
  build() {
    Column() {
      TitleBar({ title: 'Left Hand of Darkness' })
      Column() {
        Text('Left Hand of Darkness')
          .fontSize(25)
          .margin({ bottom: 10 })
        Text('Ursula K. Le Guin')
          .fontSize(15)
        Button('View author(Push)').width('150')
          .backgroundColor('#fff')
          .fontColor('#564AF7')
          .onClick(() => {
            router.pushUrl({ url: 'pages/author/FirstAuthor', params: { key: true } })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}