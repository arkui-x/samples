import TitleBar from '../../component/TitleBar'
import router from '@ohos.router'

@Entry
@Component
struct SecondBook {
  build() {
    Column() {
      TitleBar({ title: 'Too Like the Lighting' })
      Column() {
        Text('Too Like the Lighting')
          .fontSize(25)
          .margin({ bottom: 10 })
        Text('Ada Palmer')
          .fontSize(15)
        Button('View author(Push)').width('150')
          .backgroundColor('#fff')
          .fontColor('#564AF7')
          .onClick(() => {
            router.pushUrl({ url: 'pages/author/SecondAuthor', params: { key: true } })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}