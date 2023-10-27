import router from '@ohos.router'

@Component
export struct AuthorPage {
  build() {
    Column() {
      Text('Authors')
        .fontSize(30)
        .width('100%')
        .padding(10)
        .height(70)
      List({ space: 10 }) {
        ListItem() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Ursula K. Le Guin').fontSize(20)
            Text('2 Books').fontSize(15)
          }
          .onClick(() => {
            router.pushUrl({
              url: "pages/author/FirstAuthor",
              params: { key: false }
            })
          })
        }
        .padding(10)
        .height(70)

        ListItem() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Ada Palmer').fontSize(20)
            Text('1 Books').fontSize(15)
          }
          .onClick(() => {
            router.pushUrl({
              url: "pages/author/SecondAuthor",
              params: { key: false }
            })
          })
        }
        .padding(10)
        .height(70)

        ListItem() {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Octavia E. Butler').fontSize(20)
            Text('1 Books').fontSize(15)
          }
          .padding(10)
          .height(70)
          .onClick(() => {
            router.pushUrl({
              url: "pages/author/ThirdAuthor",
              params: { key: false }
            })
          })
        }

      }
      .margin({ top: 20 })
    }
    .position({ y: 0 })
  }
}

@Component
export struct SettingsPage {
  build() {
    Column() {
      Text('Settings')
        .fontSize(30)
        .margin({ bottom: 30, top: 20 })
      Navigator({ target: 'pages/loginPage', type: NavigationType.Replace }) {
        Button('Sign out')
          .width('150')
          .backgroundColor('#BBB2C8')
      }
    }
    .backgroundColor('#B6C5D1')
    .height(400)
    .width(300)
    .position({ y: 20, x: '50%' })
    .translate({ x: '-50%' })
    .borderRadius(20)
  }
}