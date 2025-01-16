@Entry
@Component
struct Index {
  @State message: string = 'Second module\nAbility A Page A'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}