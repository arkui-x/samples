@Component
export struct IntroductionTitle {
  @Prop introduction: Resource

  build() {
    Text(this.introduction)
      .fontSize(18)
      .width('100%')
      .direction(Direction.Ltr)
      .margin({ left: 26, top: 8, bottom: 8 })
      .fontColor('#182431')
  }
}