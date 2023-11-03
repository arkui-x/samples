import TitleBar from '../../component/TitleBar'
import router from '@ohos.router'

@Entry
@Component
struct FourthBook {
  build() {
    Column() {
      TitleBar({ title: 'The Lathe of Heaven' })
      Column() {
        Text('The Lathe of Heaven')
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