import router from '@ohos.router'
import TitleBar from '../../component/TitleBar'

@Entry
@Component
struct FirstAuthor {
  private params = router.getParams() as Record<string, boolean>

  build() {
    Column() {
      TitleBar({ title: 'Ursula K. Le Guin' })
      List({ space: 10 }) {
        ListItem() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Left Hand of Darkness').fontSize(20)
            Text('Ursula K. Le Guin').fontSize(15)
          }
          .onClick(() => {
            if (!this.params.key) {
              router.pushUrl({
                url: "pages/book/FirstBook",
              })
            }
          })
        }
        .padding(10)
        .height(70)

        ListItem() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Text('The Lathe of Heaven').fontSize(20)
            Text('Ursula K. Le Guin').fontSize(15)
          }.onClick(() => {
            if (!this.params.key) {
              router.pushUrl({
                url: "pages/book/FourthBook",
              })
            }
          })
        }
        .padding(10)
        .height(70)
      }
    }
    .height('100%')
  }
}