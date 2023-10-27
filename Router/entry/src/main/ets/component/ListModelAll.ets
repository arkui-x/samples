import router from '@ohos.router'

@Component
export default struct ListModelAll {
  build() {
    List({ space: 10 }) {
      ListItem() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Text('Left Hand of Darkness').fontSize(20)
          Text('Ursula K. Le Guin').fontSize(15).margin({ right: 128, top: 5 })
        }
        .padding(10)
        .height(70)
        .onClick(() => {
          router.pushUrl({
            url: "pages/book/FirstBook"
          })
        })
      }

      ListItem() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Text('Too Like the Lighting').fontSize(20)
          Text('Ada Palmer').fontSize(15)
        }
      }
      .padding(10)
      .height(70)
      .onClick(() => {
        router.pushUrl({
          url: "pages/book/SecondBook"
        })
      })

      ListItem() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Text('Kindred').fontSize(20)
          Text('Octavia E. Butler').fontSize(15)
        }
      }
      .padding(10)
      .height(70)
      .onClick(() => {
        router.pushUrl({
          url: "pages/book/ThirdBook"
        })
      })

      ListItem() {
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
          Text('The Lathe of Heaven').fontSize(20)
          Text('Ursula K. Le Guin').fontSize(15)
        }
      }
      .padding(10)
      .height(70)
      .onClick(() => {
        router.pushUrl({
          url: "pages/book/FourthBook"
        })
      })
    }
    .scrollBar(BarState.On)
    .position({ y: 0 })
  }
}