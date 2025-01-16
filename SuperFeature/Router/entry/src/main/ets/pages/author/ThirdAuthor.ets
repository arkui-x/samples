import router from '@ohos.router'
import TitleBar from '../../component/TitleBar'

@Entry
@Component
struct ThirdAuthor {
  private params = router.getParams() as Record<string, boolean>

  build() {
    Column() {
      TitleBar({ title: 'Octavia E. Butler' })
      List({ space: 10 }) {
        ListItem() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Kindred').fontSize(20)
            Text('Octavia E. Butler').fontSize(15)
          }
        }
        .padding(10)
        .height(70)
        .onClick(() => {
          if (!this.params.key) {
            router.pushUrl({
              url: "pages/book/ThirdBook"
            })
          }
        })
      }
    }
    .height('100%')
  }
}