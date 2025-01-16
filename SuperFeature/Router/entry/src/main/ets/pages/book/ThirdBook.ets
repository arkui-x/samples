import TitleBar from '../../component/TitleBar'
import router from '@ohos.router'

@Entry
@Component
struct ThirdBook {
  build() {
    Column() {
      TitleBar({ title: 'Kindred' })
      Column() {
        Text('Kindred')
          .fontSize(25)
          .margin({ bottom: 10 })
        Text('Octavia E. Butler')
          .fontSize(15)
        Button('View author(Push)').width('150')
          .backgroundColor('#fff')
          .fontColor('#564AF7')
          .onClick(() => {
            router.pushUrl({ url: 'pages/author/ThirdAuthor', params: { key: true } })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}