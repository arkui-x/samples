@Entry
@Component
struct IndexNext {
  @State message: string = 'First module\nAbility B Page B'

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