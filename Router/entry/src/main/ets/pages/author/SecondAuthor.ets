import router from '@ohos.router'
import TitleBar from '../../component/TitleBar'
@Entry
@Component
struct SecondAuthor {
  private params = router.getParams() as Record<string, boolean>
  build() {
    Column() {
      TitleBar({title: 'Ada Palmer'})
      List({ space: 10 }) {
        ListItem() {
          Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween}) {
            Text('Too Like the Lighting').fontSize(24)
            Text('Ada Palmer').fontSize(15).margin({right:150, top:5})
          }
          .onClick(() => {
            if (!this.params.key) {
              router.pushUrl({
                url: "pages/book/SecondBook"
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