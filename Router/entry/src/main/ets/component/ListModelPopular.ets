import router from '@ohos.router'

@Component
export default struct ListModelPopular {
  build() {
    List({ space: 10 }) {
      ListItem() {
        Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween}) {
          Text('Left Hand of Darkness').fontSize(20)
          Text('Ursula K. Le Guin').fontSize(15)
        }
        .padding(10)
        .height(70)
        .onClick(() => {
          router.pushUrl({
            url: "pages/book/FirstBook",
            params:{name:'Ursula K. Le Guin',bookName:'Left Hand of Darkness'}
          })
        })
      }

      ListItem() {
        Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.SpaceBetween}) {
          Text('Kindred')
            .fontSize(20)
          Text('Octavia E. Butler')
            .fontSize(15)
        }
        .padding(10)
        .height(70)
        .onClick(() => {
          router.pushUrl({
            url: "pages/book/ThirdBook",
            params:{name:'Octavia E. Butler',bookName:'Kindred'}
          })
        })
      }

    }
    .position({ y: 0 })
  }
}