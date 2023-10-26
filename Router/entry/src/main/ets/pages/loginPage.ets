import router from '@ohos.router'

@Entry
@Component
struct loginPage {
  @State scalePassU: number = 1
  @State scalePassP: number = 1

  build() {
    Column() {
      Text('Sign in')
        .fontColor(Color.Black)
        .fontSize(30)
        .margin({ bottom: 20, top: 10 })
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Text('Username')
          .fontColor('#666666')
          .fontSize(20)
          .scale({ x: this.scalePassU, y: this.scalePassU, centerX: 0 })
        Column() {
          TextInput()
            .backgroundColor('#B6C5D1')
            .onFocus(() => {
              animateTo({ duration: 200, curve: Curve.Linear }, () => {
                this.scalePassU = 0.7
              })
            })
            .onBlur(() => {
              animateTo({ duration: 200, curve: Curve.Linear }, () => {
                this.scalePassU = 1
              })
            })
          Divider()
            .height(10)
            .color('#000')
        }
      }
      .height('25%')
      .padding({ left: 20, right: 20 })
      .margin({ bottom: 10 })

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Text('Password')
          .fontColor('#666666')
          .fontSize(20)
          .scale({ x: this.scalePassP, y: this.scalePassP, centerX: 0 })
        Column() {
          TextInput()
            .backgroundColor('#B6C5D1')
            .type(InputType.Password)
            .onFocus(() => {
              animateTo({ duration: 200, curve: Curve.Linear }, () => {
                this.scalePassP = 0.7
              })
            })
            .onBlur(() => {
              animateTo({ duration: 200, curve: Curve.Linear }, () => {
                this.scalePassP = 1
              })
            })
          Divider()
            .height(20)
            .color('#000')
        }
      }
      .height('20%')
      .padding({ left: 20, right: 20 })

      Button('Sign in')
        .width('150')
        .backgroundColor('#fff')
        .fontColor('#8981F7')
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePage' })
        })
    }
    .width('100%')
    .height('50%')
    .backgroundColor('#B6C5D1')
    .position({ y: '50%' })
    .translate({ y: '-50%' })
    .borderRadius(10)
  }
}