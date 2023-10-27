import router from '@ohos.router'

@Component
export default struct ListModelNew {
  build(){
    List({ space: 10 }) {
      ListItem() {
        Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween}) {
          Text('Left Hand of Darkness').fontSize(20)
          Text('Ursula K. Le Guin').fontSize(15)
        }
      }
      .padding(10)
      .height(70)
      .onClick(() => {
        router.pushUrl({
          url: "pages/book/FirstBook",

        })
      })
      ListItem() {
        Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween}) {
          Text('Too Like the Lighting').fontSize(20)
          Text('Ada Palmer').fontSize(15)
        }
      }
      .padding(10)
      .height(70)
      .onClick(() => {
        router.pushUrl({
          url: "pages/book/SecondBook",

        })
      })
    }
    .position({y: 0})
  }
}